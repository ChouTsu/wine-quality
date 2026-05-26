# Wine Quality Analysis
Research goal: to predict whether a wine receives a high-quality score based on its physicochemical measurements, and to identify which specific chemical properties (such as alcohol content or acidity) are the most critical determinants of this classification.

## About `Exploratory_data_analysis.R` file
### Data Preprocessing & Exploratory Data Analysis (EDA)
這個專案使用 R 語言針對紅酒品質數據集（WineQT）進行資料清洗、前處理以及深入的探索性資料分析（EDA）。本階段的分析著重於探索各項化學成分（如酒精濃度、揮發性酸度）與紅酒品質之間的關係，並為後續的機器學習分類模型（Classification）奠定基礎。

### Working Flow
1. 資料載入與清洗 (Data Loading & Cleaning)
   - 載入 `WineQT.csv` 數據集（共 1,143 筆觀測值、13 個變數）。
   - 移除與預測無關的 `Id` 欄位。
2. 類別不平衡檢查 (Class Balance Analysis)
   - 統計原始品質評分（Quality Score）的分佈，並繪製長條圖檢視類別不平衡問題。
3. 特徵工程與標籤定義 (Feature Engineering)
   - 將多分類的品質評分轉換為二分類標籤 `quality_label`：
     - **Good**: 評分 $\ge 6$
     - **Bad**: 評分 $< 6$
4. 探索性資料分析 (Exploratory Data Analysis, EDA)
   - 繪製重要預測變數（如 Alcohol, Volatile Acidity）在不同品質等級下的箱線圖（Boxplot）。
   - 計算前 11 個連續型化學變數的皮爾森相關係數（Pearson Correlation），並繪製相關係數熱圖（Correlation Heatmap）。

## About `Random_forest_model.R` file
### Machine Learning Modeling & Evaluation
本階段專案使用 R 語言中的隨機森林（Random Forest）演算法，針對前處理後的紅酒數據進行二分類預測（預測紅酒品質為 `good` 或 `bad`）。內容涵蓋資料分層抽樣、模型建置、測試集效能評估以及化學特徵重要性分析。

### Working Flow
1. 資料分層抽樣 (Stratified Data Splitting)
   - 使用 `caret` 套件進行 **70% 訓練集（Training Set）與 30% 測試集（Test Set）** 的切分。
   - 採用分層抽樣（Stratified Sampling），確保訓練集與測試集中的 `good`/`bad` 標籤比例保持一致，避免抽樣偏差。
2. 隨機森林模型訓練 (Random Forest Training)
   - 使用 `randomForest` 套件，在訓練集上建造 **500 棵決策樹 (`ntree = 500`)**。
   - 開啟評估功能以計算 Out-of-bag (OOB) 錯誤率與特徵重要性指標。
3. 模型預測與效能評估 (Model Prediction & Evaluation)
   - 讓訓練好的模型對從未接觸過的測試集（30% test data）進行預測。
   - 輸出完整的**混淆矩陣（Confusion Matrix）**，並評估準確度（Accuracy）、敏感度（Sensitivity/Recall）、特異度（Specificity）等指標。
4. 特徵重要性視覺化 (Feature Importance Plot)
   - 提取模型的 `MeanDecreaseGini`數值。
   - 使用 `ggplot2` 繪製橫向長條圖，直觀呈現哪些化學成分（如酒精濃度、酸度）對預測紅酒品質最具關鍵影響。

