# Agent Context & Guidelines: 50嵐 (50 Lan) 品牌網頁設計與 UI/UX 系統

本文件提供給 AI Agent 與前端開發團隊，用於構建「50嵐 (50 Lan)」經典手搖飲品牌的網頁設計、視覺風格與互動規範。

---

## 1. 品牌定位與視覺核心 (Brand Context)
* **品牌印象**：親民、經典、高品質手搖茶飲、活力黃藍視覺、現點現做。
* **網頁設計目標**：
  * 打造現代化且俐落的響應式網頁（RWD）。
  * 突出代表性商品（如：四季春瑪奇朵、波霸奶茶、1号Tea）。
  * 提供清晰的菜單瀏覽、門市地圖與線上點餐/品牌資訊引導。

---

## 2. 配色系統 (Color Palette)

50嵐以經典的「明亮黃」與「深海藍」為核心識別，視覺搭配如下：

### 2.1 主色調 (Primary Colors)
* **50Lan Yellow (品牌黃)**: `#FFD100` 或 `#FBC02D`
  * *用途*：主要按鈕（CTA）、醒目標題背景、強烈品牌意象區塊。
* **50Lan Navy Blue (品牌藍)**: `#002B49` 或 `#0F4C81`
  * *用途*：Header/Footer 背景、主要文字、圖標顏色、底色對比。

### 2.2 輔助與背景色 (Secondary & Backgrounds)
* **Milk Tea Cream (奶茶溫柔白)**: `#FAF6EE`
  * *用途*：網頁整體背景色，取代純白（#FFFFFF），營造溫潤質感。
* **Tealeaf Green (茶葉綠)**: `#4A6B5D`
  * *用途*：茶葉標籤、鮮萃茶系列強調色、健康/自然元素裝飾。
* **Tapioca Pearl (波霸黑/黑糖咖)**: `#2B231D`
  * *用途*：主要段落文字、波霸珍珠裝飾圖案、選單高亮。

### 2.3 功能顏色 (Functional Colors)
* **Success (成功/推薦)**: `#2E7D32`
* **Accent Highlight (限時/經典熱銷)**: `#E65100`

---

## 3. 字體與排版 (Typography)

* **繁體中文標題 (Heading)**: `PingFang TC`, `Noto Sans TC`, sans-serif (粗體，展現活力與清晰感)
* **內文與說明 (Body Text)**: `Noto Sans TC`, `-apple-system`, sans-serif
* **數字與英文字體**: `Montserrat`, `Poppins` (適用於價格、容量、熱量標示)

---

## 4. 網頁頁面結構與 UI 組件 (Page Architecture)

### 4.1 首頁 (Landing / Hero Section)
* **Hero Banner**:
  * 動態飲品視覺（如珍珠落入奶茶的微動畫或滿版高清商品照）。
  * 大標題：「經典茶飲，五十嵐現場現泡」。
  * CTA 按鈕：「探索線上菜單」與「尋找附近門市」。
* **熱銷排行榜 (Best Sellers Slide)**:
  * 卡片式設計（Card Component），展示「1号 (四季春+珍波椰)」、「波霸奶茶」、「燕麥紅茶拿鐵」。

### 4.2 線上互動菜單 (Interactive Menu)
* **分類 Tab 標籤**:
  * 找好茶 (Base Tea)
  * 找奶茶 (Milk Tea)
  * 找新鮮 (Fruit & Juice)
  * 找拿鐵 (Latte)
* **客製化篩選器 (Customizer Modal)**:
  * 甜度選單：無糖 (0%) ➔ 微糖 (30%) ➔ 半糖 (50%) ➔ 少糖 (70%) ➔ 正常 (100%)
  * 冰塊選單：去冰 ➔ 微冰 ➔ 少冰 ➔ 正常冰 ➔ 熱飲
  * 加料選項：波霸、珍珠、椰果、仙草、燕麥

### 4.3 門市搜尋器 (Store Locator)
* 整合 Google Maps API，支援「使用目前位置」與「縣市分區篩選」。
* 每間門市卡片顯示：營業時間、外送專線、支援線上點餐標誌。

---

## 5. UI/UX 與互動規範 (UX/UI Rules for AI Development)

1. **對比度安全 (Accessibility)**：
   * 當背景為 `50Lan Yellow (#FFD100)` 時，文字必須使用 `50Lan Navy Blue (#002B49)`，不可使用白色文字。
2. **卡片圓角 (Border Radius)**：
   * 按鈕與商品卡片統一採用 `border-radius: 12px` 或 ` rounded-xl`，保持親切、無尖銳感的視覺體驗。
3. **微互動 (Micro-interactions)**：
   * 懸停 (Hover) 卡片時向上微浮動 (`transform: translateY(-4px)`) 並加入柔和陰影。
   * 加料/甜度選擇時，使用順暢的 Radio/Toggle 動畫。
4. **響應式斷點 (Responsive Design)**：
   * Mobile First 優先設計，導覽列在手機端轉換為底欄 (Bottom Navigation Bar) 或漢堡選單 (Hamburger Menu)。

---

## 6. 前端開發建議技術棧 (Tech Stack Recommendation)
* **Framework**: React / Next.js 或 Vue 3
* **Styling**: Tailwind CSS (搭配自訂 50Lan 主題色系)
* **Icons**: Lucide Icons 或 FontAwesome (包含茶杯、地標、搜尋、購物車圖示)
* **Animation**: Framer Motion (用於菜單切換與產品卡片出現動畫)

## 專案任務與版本控制流程

* 所有任務說明、進度紀錄、commit 訊息與面向使用者的文件，均使用繁體中文（台灣用語）。
* 開始每個新任務時，建立 `tasks/features/YYYY-MM-DD/<任務名稱>/progress.md`。任務名稱使用簡短、清楚的中文或 kebab-case 名稱。
* 每份進度紀錄至少包含任務目標、目前狀態、已完成事項、驗證結果及待辦事項；任務開始、進度有明顯變化及完成時都要更新。
* `.vscode/tasks.json` 會在工作區開啟時啟動檔案監看器；每次檔案儲存後，監看器會等待短暫安靜時間，再自動提交該批變更並推送至 `origin`。
* 自動 commit 訊息格式為 `YYYYMMDD-HHmmss_簡短任務說明`。監看器只提交觸發該批次的檔案，不應納入其他既有變更。
* 自動化若遇到 commit 或 push 失敗，必須明確顯示錯誤，不可假稱成功；修正問題後再重試。
* 不得將密鑰、憑證或其他機敏資料加入版本控制。新增機敏檔案類型時，先確認其已加入 `.gitignore`。