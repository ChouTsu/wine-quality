install.packages("caret")
install.packages("randomForest")

# ==========================================

# 0. 安裝並載入機器學習必備套件 caret (若未安裝請先執行 install.packages("caret"))
# 註：某些系統可能還需要安裝 install.packages("randomForest")
library(caret)
library(randomForest)

# ==========================================

# 1. 為了確保每次執行的隨機切分結果都一樣，設定隨機種子
set.seed(525)

# ==========================================

# 2. 進行分層抽樣（依據 quality_label 的比例來切）, 70–30 training-test split 
train_index <- createDataPartition(wine$quality_label, p = 0.70, list = FALSE)

# 訓練集：只拿 70% 的資料，並且移除原始的 quality 欄位
train_data <- wine[train_index, ] %>% select(-quality)

# 測試集：拿剩下的 30% 資料，同樣移除原始的 quality 欄位
test_data  <- wine[-train_index, ] %>% select(-quality)

# 檢查切分後的標籤比例是否一致
cat("訓練集標籤分佈：\n")
print(table(train_data$quality_label))
cat("\n測試集標籤分佈：\n")
print(table(test_data$quality_label))

# ==========================================

set.seed(525)

# 3. 訓練隨機森林模型
# quality_label ~ . 代表「預測 quality_label，其餘所有欄位都當作預測變數」
rf_model <- randomForest(quality_label ~ ., data = train_data, 
                         ntree = 500,       # 建造 500 棵決策樹
                         importance = TRUE) # 啟動計算變數重要性功能

# 3.1 查看模型在訓練集上的表現（包含 Out-of-bag 錯誤率）
print(rf_model)

# 3.2 看影響這 500 棵樹的判斷最關鍵的特徵
importance(rf_model)
varImpPlot(rf_model)

# ==========================================

# 4. 讓模型對測試集進行預測
rf_predictions <- predict(rf_model, newdata = test_data)

# 4.1 產出混淆矩陣與各項評估指標
evaluation_matrix <- confusionMatrix(rf_predictions, test_data$quality_label, positive = "good")
print(evaluation_matrix)

# ==========================================

# 之前(3.2)有畫過圖了, 但這裡給長條圖的呈現方式

# 5. 提取變數重要性數值
importance_values <- as.data.frame(importance(rf_model))
importance_values$Variable <- rownames(importance_values)

# 繪製精美的變數重要性條形圖
ggplot(importance_values, aes(x = reorder(Variable, MeanDecreaseGini), y = MeanDecreaseGini)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() + # 讓圖表橫過來比較好閱讀
  labs(title = "Feature Importance - Which chemicals matter most?",
       x = "Chemical Predictors",
       y = "Importance (Mean Decrease Gini)") +
  theme_minimal()
