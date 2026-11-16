# NAME: Jesse Velasquez
# Project Code: NBA Shot Make Probability Model (Logistic Regression)

library(tidyverse)

# Data
train_df <- read_csv("training.csv.gz")
test_df <- read_csv("testing.csv.gz")
submission <- read_csv("submission.csv")

# 1. Clean Data Function
clean_data <- function(df) {
  df %>%
    mutate(
      gamestate = as.factor(gamestate),
      shottype  = as.factor(shottype)
    ) %>%
    select(
      distance, locationx, locationy,
      num_contesters, closestdefdist,
      dribblesbefore, shotclock, shooterspeed,
      gamestate, shottype,
      any_of("outcome")
    )
}

train_clean <- clean_data(train_df)
test_clean  <- clean_data(test_df)

# 2. Fit Logistic Regression with Distance * Defender Interaction
logit_model <- glm(
  outcome ~ shottype - 1 + distance * closestdefdist + 
    num_contesters + locationx + locationy + 
    dribblesbefore + shotclock + shooterspeed + gamestate,
  data = train_clean,
  family = binomial(link = "logit")
)



# Logistic Model Summary
summary(logit_model)

# Generating Coefficients Importance / Odds Ratio Plot
model_coefs <- broom::tidy(logit_model) %>%
  filter(term != "(Intercept)") %>%
  mutate(odds_ratio = exp(estimate)) %>%
  arrange(desc(abs(statistic)))

coef_plot <- ggplot(model_coefs, aes(x = reorder(term, estimate), y=estimate)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Logistic Regression Feature Coefficients (Log-Odds)",
    subtitle = "Positive = Increases Make Probabililty | Negative = Decreases Make Probability",
    x = "Feature",
    y = "Coefficient Estimate (Log-Odds)"
) +
  theme_minimal()

print(coef_plot)
ggsave("feature_importance.png", plot = coef_plot, width = 8, height = 5)


# Predicting Probabilities on Test Data 
# type = "response" forces predictions to be probabilities between 0 and 1 (Make or no Make)
test_preds <- predict(logit_model, newdata = test_clean, type = "response")
test_preds[is.na(test_preds)] <- mean(train_clean$outcome, na.rm = TRUE)

# Transferring Data over to Submission.csv
submission$make_prob <- test_preds
write_csv(submission,"submission.csv")
cat("Predictions successfully exported to submission.csv!\n")
