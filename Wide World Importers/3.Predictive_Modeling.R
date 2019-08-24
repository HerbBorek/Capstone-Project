# Herbert Borek
# Week 6

WWI <- read.csv("World_Wide_Importers.csv")

# Remove unnecessary variables
WWI <- WWI[c(6,7:10, 12:15,17:20, 22, 25, 27:30 )]

# Set seed to get the same answer
set.seed(1)

# Partition into train and test data
train <- sample(1:nrow(WWI), (2/3)*nrow(WWI))
test <- WWI[-train,]
train <- WWI[train,]

# Load necessary packages
require(ggplot2)
require(GGally)
require(nnet)

# Pairwise scatterplot of calculated variables
pairs(WWI[c(16:19)])

# Formulas for predictive models
formulaMonths <- ("ROI ~ Invoice.Month + Delivery.Month")
formula <- ("ROI ~ Reorder.Point + Demand + Percent.Profit")
formula2 <- ("ROI ~ Is.Finalized + Package")
formula3 <- ("ROI ~ City")
formula4 <- ("ROI ~ Item")
formula5 <- ("ROI ~ .")
formula6 <- ("ROI ~ Package + Profit + Quantity + Tax.Amount + Tax.Rate + Unit.Price + Item +
             Item.Characteristic + Reorder.Point + Demand + Percent.Profit")
formula7 <- ("ROI ~ Package + Profit + Tax.Amount + Unit.Price + Item + Reorder.Point + Demand + Percent.Profit")

# Linear/Multiple Regressions and Summaries
fitMonths <- lm(formulaMonths, data = train)
summary(fitMonths)

fit1 <- lm(formula, data = train)
summary(fit1)

fit2 <- lm(formula2, data = train)
summary(fit2)

fit3 <- lm(formula3, data = train)
summary(fit3)

fit4 <- lm(formula4, data = train)
summary(fit4)

fit5 <- lm(formula5, data = train)
summary(fit5)

fit6 <- lm(formula6, data = train)
summary(fit6)

fit7 <- lm(formula7, data = train)
summary(fit7)

# Graphs of Residuals
ggplot(data=train, aes(fitMonths$residuals)) +
  geom_histogram(bins = 20, color = "black", fill = "purple4") +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(),
        axis.line.y=element_line()) +
  ggtitle("Histogram of Model Residuals")

ggplot(data=train, aes(fit1$residuals)) +
  geom_histogram(bins = 20, color = "black", fill = "purple4") +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(),
        axis.line.y=element_line()) +
  ggtitle("Histogram of Model Residuals")

ggplot(data=train, aes(fit2$residuals)) +
  geom_histogram(bins = 20, color = "black", fill = "purple4") +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(),
        axis.line.y=element_line()) +
  ggtitle("Histogram of Model Residuals")

ggplot(data=train, aes(fit3$residuals)) +
  geom_histogram(bins = 20, color = "black", fill = "purple4") +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(),
        axis.line.y=element_line()) +
  ggtitle("Histogram of Model Residuals")

ggplot(data=train, aes(fit4$residuals)) +
  geom_histogram(bins = 20, color = "black", fill = "purple4") +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(),
        axis.line.y=element_line()) +
  ggtitle("Histogram of Model Residuals")

ggplot(data=train, aes(fit5$residuals)) +
  geom_histogram(bins = 20, color = "black", fill = "purple4") +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(),
        axis.line.y=element_line()) +
  ggtitle("Histogram of Model Residuals")

ggplot(data=train, aes(fit6$residuals)) +
  geom_histogram(bins = 20, color = "black", fill = "purple4") +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(),
        axis.line.y=element_line()) +
  ggtitle("Histogram of Model Residuals")


# Final Model
ggplot(data=train, aes(fit7$residuals)) +
  geom_histogram(bins = 20, color = "black", fill = "purple4") +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(),
        axis.line.y=element_line()) +
  ggtitle("Histogram of Model Residuals")

# Dataset of predictive fields in the test set
predtest <- test[c(3, 4, 6, 10, 12, 16:18)]

# Predicting the test set
pred <- predict(fit7, predtest)
pred <- as.data.frame(round(pred, 4))

# Putting the predicted and the actual ROI side-by-side
predictions <- data.frame(pred=pred, actual=test[19])
names(predictions) <- c("predicted", "actual")

# Summary stats for predictions
summary(predictions)

# Standard Deviations
sd(predictions$predicted)
sd(predictions$actual)


# Creating a brand new dataset of ten values
Package <- as.data.frame(sample(x = c("Bag", "Each", "Packet", "Pair"),
                  prob = c(.005, .95, .02, .02), size = 10, replace = TRUE))
Profit <- as.data.frame(rnorm(n = 10, mean = 38871, sd = 82657.62))
Tax.Amount <- as.data.frame(rnorm(n = 10, mean = 11643.4, sd = 23380.23))
Unit.Price <- as.data.frame(rnorm(n = 10, mean = 4716.78, sd = 15073.61))
Item <- as.data.frame(sample(x = unique(WWI$Item), size = 10, replace = TRUE))
Reorder.Point <- as.data.frame(rnorm(n = 10, mean = 1.205e+09, sd = 18110928))
Demand <- as.data.frame(rnorm(n = 10, mean = 39142, sd = 64097.98))
Percent.Profit <- as.data.frame(rnorm(n = 10, mean = 0.5375, sd = 0.191738))

TopTen <- data.frame(Package, Profit, Tax.Amount, Unit.Price, Item, Reorder.Point, Demand, Percent.Profit)
names(TopTen) <- c("Package", "Profit", "Tax.Amount", "Unit.Price", "Item", "Reorder.Point", "Demand", "Percent.Profit")

# Predicting the ROI for these new values
future <- predict(fit7, TopTen)
future <- as.data.frame(round(future, 4))
names(future) <- "ROI"

TopTen <- data.frame(TopTen, future)
