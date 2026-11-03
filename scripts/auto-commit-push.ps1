$ErrorActionPreference = 'Stop'

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path.TrimEnd('\')
$debounceSeconds = 2
$sourcePrefix = 'AI_Prompt.AutoCommitPush'
$pendingPaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$lastChangeAt = [DateTime]::MinValue

function Write-GitFailure {
    param([string]$Operation)
    Write-Host "自動 Git 作業失敗：$Operation。請查看上方錯誤訊息；變更尚未確認推送成功。" -ForegroundColor Red
}

function Get-CommitSummary {
    param([string[]]$Paths)

    foreach ($path in $Paths) {
        if ($path -match '^tasks/features/[^/]+/([^/]+)/') {
            return "更新$($Matches[1])"
        }
    }

    if ($Paths.Count -eq 1) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($Paths[0])
        if ($name.Length -gt 32) {
            $name = $name.Substring(0, 32)
        }
        return "更新$name"
    }

    return "更新$($Paths.Count)個檔案"
}

function Add-ChangedPath {
    param([string]$FullPath)

    if ([string]::IsNullOrWhiteSpace($FullPath)) {
        return
    }

    $rootPrefix = $repositoryRoot + [System.IO.Path]::DirectorySeparatorChar
    if (-not $FullPath.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        return
    }

    if ([System.IO.Directory]::Exists($FullPath)) {
        return
    }

    $relativePath = $FullPath.Substring($rootPrefix.Length).Replace('\', '/')
    if ($relativePath -match '(^|/)\.git(/|$)') {
        return
    }

    if ($relativePath -match '(^|/)([^/]+\.tmp|[^/]+\.swp|[^/]+\.bak|~\$[^/]+)$' -or
        $relativePath -match '(^|/)(\.env($|\.)|[^/]+\.(pem|key|p12|pfx)$|id_rsa($|\.)|id_ed25519($|\.))') {
        Write-Host "略過暫存或疑似機敏檔案：$relativePath" -ForegroundColor Yellow
        return
    }

    [void]$pendingPaths.Add($relativePath)
    $script:lastChangeAt = Get-Date
}

function Submit-ChangedPaths {
    param([string[]]$Paths)

    $eligiblePaths = [System.Collections.Generic.List[string]]::new()
    foreach ($path in $Paths) {
        & git -C $repositoryRoot check-ignore -q -- $path
        if ($LASTEXITCODE -eq 0) {
            continue
        }
        if ($LASTEXITCODE -ne 1) {
            Write-GitFailure "檢查忽略規則（$path）"
            return
        }

        $eligiblePaths.Add($path)
    }

    if ($eligiblePaths.Count -eq 0) {
        return
    }

    $pathArguments = $eligiblePaths.ToArray()
    $status = & git -C $repositoryRoot --literal-pathspecs status --porcelain -- @pathArguments
    if ($LASTEXITCODE -ne 0) {
        Write-GitFailure '檢查工作目錄狀態'
        return
    }
    if (-not $status) {
        return
    }

    & git -C $repositoryRoot --literal-pathspecs add -A -- @pathArguments
    if ($LASTEXITCODE -ne 0) {
        Write-GitFailure '加入本次變更'
        return
    }

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $summary = Get-CommitSummary -Paths $pathArguments
    $message = "${timestamp}_${summary}"
    & git -C $repositoryRoot --literal-pathspecs commit --only -m $message `
        -m 'Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>' -- @pathArguments
    if ($LASTEXITCODE -ne 0) {
        Write-GitFailure '建立 commit'
        return
    }

    & git -C $repositoryRoot push origin HEAD
    if ($LASTEXITCODE -ne 0) {
        Write-GitFailure "推送至 origin（本機 commit 為 $message）"
        return
    }

    Write-Host "已自動 commit 並 push：$message" -ForegroundColor Green
}

$watcher = [System.IO.FileSystemWatcher]::new($repositoryRoot)
$watcher.IncludeSubdirectories = $true
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor
    [System.IO.NotifyFilters]::FileName -bor
    [System.IO.NotifyFilters]::DirectoryName
$watcher.InternalBufferSize = 65536

$subscriptions = @(
    Register-ObjectEvent -InputObject $watcher -EventName Changed -SourceIdentifier "${sourcePrefix}.Changed"
    Register-ObjectEvent -InputObject $watcher -EventName Created -SourceIdentifier "${sourcePrefix}.Created"
    Register-ObjectEvent -InputObject $watcher -EventName Deleted -SourceIdentifier "${sourcePrefix}.Deleted"
    Register-ObjectEvent -InputObject $watcher -EventName Renamed -SourceIdentifier "${sourcePrefix}.Renamed"
)
$watcher.EnableRaisingEvents = $true

Write-Host "已啟動自動 commit／push 檔案監看器（安靜 $debounceSeconds 秒後處理；按 Ctrl+C 停止）。" -ForegroundColor Cyan

try {
    while ($true) {
        $queuedEvent = Wait-Event -Timeout 1
        while ($null -ne $queuedEvent) {
            $eventArgs = $queuedEvent.SourceEventArgs
            if ($queuedEvent.SourceIdentifier -like "${sourcePrefix}.*") {
                Add-ChangedPath -FullPath $eventArgs.FullPath
                if ($eventArgs -is [System.IO.RenamedEventArgs]) {
                    Add-ChangedPath -FullPath $eventArgs.OldFullPath
                }
            }
            Remove-Event -EventIdentifier $queuedEvent.EventIdentifier
            $queuedEvent = Get-Event |
                Where-Object { $_.SourceIdentifier -like "${sourcePrefix}.*" } |
                Select-Object -First 1
        }

        if ($pendingPaths.Count -gt 0 -and
            ((Get-Date) - $lastChangeAt).TotalSeconds -ge $debounceSeconds) {
            $batch = [string[]]@($pendingPaths | Sort-Object)
            $pendingPaths.Clear()
            try {
                Submit-ChangedPaths -Paths $batch
            }
            catch {
                Write-Host "自動 Git 作業發生未預期錯誤：$($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}
finally {
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    foreach ($subscription in $subscriptions) {
        Unregister-Event -SourceIdentifier $subscription.SourceIdentifier -ErrorAction SilentlyContinue
    }
    Get-Event | Where-Object { $_.SourceIdentifier -like "${sourcePrefix}.*" } | Remove-Event
}
