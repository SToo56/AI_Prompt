# 設定專案開發規則

- 日期：2026-11-03
- 狀態：已完成設定，待工作區重新啟動後實際運作

## 任務目標

建立專案通用開發規則：以繁體中文（台灣用語）記錄任務、為每個任務建立日期與任務名稱目錄，並在檔案儲存後自動 commit 與 push。

## 目前進度

- 已確認自動化範圍為任何程式儲存檔案後執行。
- 已新增 AGENTS.md 開發流程規則、PowerShell 檔案監看器與 VS Code 開啟工作區時啟動的 Task。
- 監看器排除 Git 目錄、Git 忽略檔、常見暫存檔與常見機敏檔案，並使用精確路徑提交，避免納入其他已暫存的變更。

## 已完成事項

- 已完成：PowerShell 語法解析與 VS Code Task JSON 驗證通過。
- 已完成：以獨立測試 Git 儲存庫確認精確路徑 commit 不會納入其他已暫存變更。
- 已完成：在隔離的 Windows PowerShell／Git 環境驗證監看器可自動 commit 並 push，commit 格式與 Co-authored-by trailer 正確。
- 已完成：初始 commit `616ea2b` 已推送至 `origin/main`，並設定本機分支追蹤遠端 `main`。
- 尚未完成：需重新開啟本工作區並允許自動 Task，才能啟用監看器。

## 驗證結果

- 待驗證。

## 待辦事項

- 重新開啟工作區；若 VS Code 要求授權自動 Task，請允許「自動 commit 並 push」Task 執行。
