install.packages("ggplot2") 
install.packages("dplyr")
install.packages("GGally")
install.packages("caret")
install.packages("randomForest")

# ==========================================

# 0. 載入需要的套件（若未安裝請先執行 install.packages("ggplot2") 與 install.packages("dplyr")）
library(ggplot2)
library(dplyr)

# ==========================================

# 1. loading data
# 註: 自行更改路徑
wine <- read.csv("C:/Users/heave/Downloads/archive/WineQT.csv")

# 檢查資料結構
str(wine)
summary(wine)
#--- 發現有 1143 筆觀測值（列）和 13 個變數（欄）---

# 移除 datasets 的 row-index column named rownames. 
wine <- subset(wine, select = -Id)
str(wine)
summary(wine)

# ==========================================

# 2. 將目標變數 quality 轉換為因子（Factor），因為在分類任務中它代表獨立的類別
wine$quality <- as.factor(wine$quality)

# ==========================================

# 3. 整合為結構清晰的 Data Frame 並呈現文字表格
class_counts <- table(wine$quality)
class_proportions <- prop.table(class_counts) * 100
balance_df <- data.frame(
  Quality = names(class_counts),
  Count = as.vector(class_counts),
  Percentage = round(as.vector(class_proportions), 2)
)
print("--- 類別平衡統計表 ---")
print(balance_df)

# 3.1 呈現類別不平衡長條圖 
ggplot(balance_df, aes(x = Quality, y = Count, fill = Quality)) +
  geom_bar(stat = "identity", color = "black", alpha = 0.8) +
  geom_text(aes(label = paste0(Count, "\n(", Percentage, "%)")), vjust = -0.2, size = 3.5) +
  labs(title = "Class Balance of Red Wine Quality",
       x = "Wine Quality Score (Class)",
       y = "Number of Samples (Count)") +
  theme_minimal() +
  theme(legend.position = "none") # 隱藏重複的圖例

# ==========================================

# 4. Exploratory data analysis: Provide at least one plot of predictors by class.
# 4.1 預測變數圖 1：酒精濃度 vs 品質 ----
ggplot(wine, aes(x = quality, y = alcohol, fill = quality)) +
  geom_boxplot(alpha = 0.7, outlier.color = "red", outlier.shape = 16) +
  labs(title = "Alcohol Content across Different Wine Quality Levels",
       x = "Wine Quality Score",
       y = "Alcohol Content (%)") +
  theme_minimal() +
  theme(legend.position = "none")

# 4.2 預測變數圖 2：揮發性酸度 vs 品質 ----
ggplot(wine, aes(x = quality, y = volatile.acidity, fill = quality)) +
  geom_boxplot(alpha = 0.7, outlier.color = "red", outlier.shape = 16) +
  labs(title = "Volatile Acidity across Different Wine Quality Levels",
       x = "Wine Quality Score",
       y = "Volatile Acidity (g/dm³)") +
  theme_minimal() +
  theme(legend.position = "none")

# ==========================================

# 5. 定義 good wine: >= 6 為 good，< 6 為 bad
wine$quality_label <- ifelse(as.numeric(as.character(wine$quality)) >= 6, "good", "bad")

# 轉換為因子型態
wine$quality_label <- as.factor(wine$quality_label)

# 檢查轉換後的類別分佈
table(wine$quality_label)

# ==========================================

# 6. 繪製所有變數的相關係數熱圖
# 載入畫熱圖很方便的套件（若未安裝請先執行 install.packages("GGally")）
library(GGally)

# 只挑選前 11 個連續型化學變數來計算相關係數
num_vars <- wine[, 1:11]

# 快速繪製所有變數的相關係數熱圖
# num_vars：input（通常是你篩選過、只留下數字的 dataframe）。ggcorr 會自動計算這群變數兩兩之間的相關性。
# method = c("pairwise", "pearson")：這是設定計算相關係數的方法。
# "pearson"（皮爾森相關係數）：最常用的相關性指標。算出來的數值會介於 -1 到 1 之間。1 代表完全正相關，-1 代表完全負相關，0 代表沒關係。
# "pairwise"：意思是「兩兩成對刪除（pairwise deletion）」。如果某瓶紅酒的某一欄剛好有漏掉的資料（NA），R 在算這兩個變數的相關性時，只會跳過那一筆，而不是把整瓶紅酒的資料都丟掉。
ggcorr(num_vars, method = c("pairwise", "pearson"), 
       label = TRUE, label_size = 3, label_round = 2, hjust = 0.85)
