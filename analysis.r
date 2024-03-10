setwd("/Users/f/raw")

week1 <- read.csv("pulse2020_puf_01.csv", header=TRUE)
week15 <- read.csv("pulse2020_puf_15.csv", header=TRUE)
week21 <- read.csv("pulse2020_puf_21.csv", header=TRUE)

# Drop other columns we don't need
week1 = subset(week1, select = c(WEEK, RRACE, INCOME,
                                 WRKLOSS, ANXIOUS, WORRY,
                                 ANXIOUS_WORRY_SCORE,
                                 ANXIOUS_WORRY_BOOL) )
week15 = subset(week15, select = c(WEEK, RRACE, INCOME,
                                 WRKLOSS, ANXIOUS, WORRY,
                                 ANXIOUS_WORRY_SCORE,
                                 ANXIOUS_WORRY_BOOL) )
week21 = subset(week21, select = c(WEEK, RRACE, INCOME,
                                   WRKLOSS, ANXIOUS, WORRY,
                                   ANXIOUS_WORRY_SCORE,
                                   ANXIOUS_WORRY_BOOL) )

# Combine all weeks
all_weeks <- rbind (week1, week15, week21)

# Filter out no answers
all_weeks <- all_weeks[( ( all_weeks$ANXIOUS != -88 &
                           all_weeks$ANXIOUS != -99
                         ) &
                         ( all_weeks$WORRY != -88 &
                           all_weeks$WORRY != -99 
                         ) &
                         ( all_weeks$INCOME != -88 &
                           all_weeks$INCOME != -99
                         ) &
                         ( all_weeks$WRKLOSS != -88 &
                           all_weeks$WRKLOSS != -99
                         )
                       ),]

# Encode as categorical variables
all_weeks$RRACE <- factor(all_weeks$RRACE)
all_weeks$INCOME <- factor(all_weeks$INCOME)
all_weeks$WRKLOSS <- factor(all_weeks$WRKLOSS)

# Do a logistic regression
GLMLogit <- glm(ANXIOUS_WORRY_BOOL ~ WEEK + RRACE + INCOME + WRKLOSS, family="binomial", data = all_weeks)
summary(GLMLogit)
# Call:
#   glm(formula = ANXIOUS_WORRY_BOOL ~ WEEK + RRACE + INCOME + WRKLOSS, 
#       family = "binomial", data = all_weeks)
# 
# Deviance Residuals: 
#   Min       1Q   Median       3Q      Max  
# -2.0111  -1.3248   0.7271   0.9777   1.1303  
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)  1.6024081  0.0195726  81.870  < 2e-16 ***
#   WEEK         0.0052148  0.0006009   8.678  < 2e-16 ***
#   RRACE2      -0.0738015  0.0193494  -3.814 0.000137 ***
#   RRACE3      -0.0651989  0.0231198  -2.820 0.004802 ** 
#   RRACE4       0.1684427  0.0243841   6.908 4.92e-12 ***
#   INCOME2     -0.2527062  0.0240300 -10.516  < 2e-16 ***
#   INCOME3     -0.3265666  0.0224829 -14.525  < 2e-16 ***
#   INCOME4     -0.4177974  0.0204635 -20.417  < 2e-16 ***
#   INCOME5     -0.4852885  0.0210429 -23.062  < 2e-16 ***
#   INCOME6     -0.5473512  0.0202430 -27.039  < 2e-16 ***
#   INCOME7     -0.5492994  0.0232582 -23.617  < 2e-16 ***
#   INCOME8     -0.6306909  0.0223790 -28.182  < 2e-16 ***
#   WRKLOSS2    -0.7913208  0.0106233 -74.489  < 2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 250198  on 198143  degrees of freedom
# Residual deviance: 242182  on 198131  degrees of freedom
# AIC: 242208
# 
# Number of Fisher Scoring iterations: 4


# Interpret WEEK as odd-ratios
# For each additional week, the odds of being diagnosed (vs not being diagnosed)
# increase by a factor of 1.005
exp(cbind(OR = coef(GLMLogit), confint(GLMLogit)))
# Waiting for profiling to be done...
# OR     2.5 %    97.5 %
#   (Intercept) 4.9649740 4.7785082 5.1595679
# WEEK        1.0052284 1.0040450 1.0064128
# RRACE2      0.9288561 0.8943453 0.9648205
# RRACE3      0.9368811 0.8954485 0.9803950
# RRACE4      1.1834604 1.1283920 1.2415759
# INCOME2     0.7766961 0.7409600 0.8141498
# INCOME3     0.7213963 0.6902790 0.7538766
# INCOME4     0.6584956 0.6325746 0.6854083
# INCOME5     0.6155196 0.5906220 0.6414069
# INCOME6     0.5784800 0.5559466 0.6018598
# INCOME7     0.5773542 0.5516108 0.6042662
# INCOME8     0.5322240 0.5093641 0.5560669
# WRKLOSS2    0.4532458 0.4438987 0.4627743

# Look at predicted probabilities of getting diagnosed
#newdata2 <- with(GLMLogit, data.frame(WEEK = rep(seq(from = 1, to = 21, length.out = 3),
#                                              8), RRACE = factor(rep(1:4, each=3)), WRKLOSS = factor(rep(1:2, each=3)), INCOME = factor(rep(1:8, each = 3))))
newdata2 <- with(GLMLogit, data.frame(WEEK = rep(seq(from = 1, to = 21, length.out = 1000),
                                                 4), RRACE = factor(rep(1:4, each=1000)), WRKLOSS = factor(rep(1:2, each=1000)), INCOME = factor(rep(1:8, each = 1000))))


newdata3 <- cbind(newdata2, predict(GLMLogit, newdata = newdata2, type = "link", se = TRUE))

newdata3 <- within(newdata3, {
  PredictedProb <- plogis(fit)
  LL <- plogis(fit - (1.96 * se.fit))
  UL <- plogis(fit + (1.96 * se.fit))
})

#ggplot(newdata3, aes(x = WEEK, y = PredictedProb)) +
#  geom_ribbon(aes(ymin = LL, ymax = UL, fill = RRACE), alpha = 0.2) + geom_line(aes(colour = RRACE),size = 1)
ggplot(newdata3, aes(x = WEEK, y = PredictedProb)) +
  geom_ribbon(aes(ymin = LL, ymax = UL, fill = WRKLOSS), alpha = 0.2) + geom_line(aes(colour = WRKLOSS),size = 1)

# fit logistic model for predicting
# diagnosis of anxiety or depression
library(ggplot2)
library(visreg)
visreg(GLMLogit, "WEEK", 
       gg = TRUE, 
       scale="response") +
  labs(y = "PredictedProbability", 
       x = "WEEK",
       title = "Relationship of WEEK (into COVID-19 lockdown) and being diagnosed with anxiety or depression",
       subtitle = "controlling for RRACE, INCOME, and WRKLOSS",
       caption = "source: Household Pulse Survey")

# controlling for INCOME and WRKLOSS
library(ggplot2)
library(visreg)
visreg(GLMLogit, "WEEK",
       by = "RRACE",
       gg = TRUE, 
       scale="response") +
  labs(y = "PredictedProbability", 
       x = "WEEK",
       title = "Relationship of WEEK (into COVID-19 lockdown) and being diagnosed with anxiety or depression",
       subtitle = "Controlling for INCOME, and WRKLOSS",
       caption = "source: Household Pulse Survey")

# controlling for RRACE and WRKLOSS
library(ggplot2)
library(visreg)
visreg(GLMLogit, "WEEK",
       by = "INCOME",
       gg = TRUE, 
       scale="response") +
  labs(y = "PredictedProbability", 
       x = "WEEK",
       title = "Relationship of WEEK (into COVID-19 lockdown) and being diagnosed with anxiety or depression",
       subtitle = "Controlling for RRACE and WRKLOSS",
       caption = "source: Household Pulse Survey")


# controlling for RRACE and INCOME
library(ggplot2)
library(visreg)
visreg(GLMLogit, "WEEK",
       by = "WRKLOSS",
       gg = TRUE, 
       scale="response") +
  labs(y = "PredictedProbability", 
       x = "WEEK",
       title = "Relationship of WEEK (into COVID-19 lockdown) and being diagnosed with anxiety or depression",
       subtitle = "Controlling for RRACE and INCOME",
       caption = "source: Household Pulse Survey")



# RRACE vs INCOME controlling for WEEK and WRKLOSS
library(ggplot2)
library(visreg)
visreg(GLMLogit, "INCOME",
       by = "RRACE",
       gg = TRUE, 
       scale="response") +
  labs(y = "PredictedProbability", 
       x = "INCOME",
       title = "Relationship of INCOME and being diagnosed with anxiety or depression",
       subtitle = "Controlling for WEEK and WRKLOSS",
       caption = "source: Household Pulse Survey")

# WRKLOSS vs INCOME controlling for WEEK and RRACE
library(ggplot2)
library(visreg)
visreg(GLMLogit, "INCOME",
       by = "WRKLOSS",
       gg = TRUE, 
       scale="response") +
  labs(y = "PredictedProbability", 
       x = "INCOME",
       title = "Relationship of INCOME and being diagnosed with anxiety or depression",
       subtitle = "Controlling for WEEK and RRACE",
       caption = "source: Household Pulse Survey")


