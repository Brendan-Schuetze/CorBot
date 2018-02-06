library(ggplot2)
library(dplyr)
library(ggthemes)
library(twitteR)
library(luzlogr)

source("~/CorBot/Credentials.R")

conditions <- c(rep("A", 100), rep("B", 100))
sd <-  abs(rnorm(1, .5, .25))

df <- data.frame(factor(conditions), rnorm(200, 1, sd))
colnames(df) <- c("Condition","Value")

sig <- t.test(x = df[df$Condition == "A",]$Value, y = df[df$Condition == "B",]$Value)

if(sig$p.value <= .05) {
  caption <-  "Publishable. 🎉 "
  title <-  "Publishable."
} else if(sig$p.value <= .1) {
  title <- "Maybe Publishable."
  caption <- title
} else {
  title <- "Not Publishable."
  caption <- title
}

df <- df %>%
  group_by(Condition) %>%
    summarize(mean = mean(Value), 
              sd = sd(Value),
              se = sd(Value) / sqrt(n()))

df <- df %>%
  mutate(ci_low = mean - 1.96 * se, ci_high = mean + 1.96 * se)


ggplot(data = df) + geom_bar(aes(x = Condition, y = mean), stat = "identity") + 
  geom_errorbar(aes(x = Condition, ymin = ci_low, ymax = ci_high), width = 0.2) + ylab("Mean") + 
  ggtitle(label = title, subtitle = paste("n = 200, sd =", paste(substr(toString(sd), 1, 5),",", sep = ""), "t =", paste(substr(toString(sig$statistic), 1, 5),",", sep=""), "p =", substr(toString(sig$p.value), 1, 5))) + theme_base()

ggsave(filename = "plot.png")

tweet(text = caption, mediaPath = "plot.png")

openlog("correlations.log", append = TRUE)
printlog(paste(title, substr(toString(sig$p.value), 1, 5)))
closelog(sessionInfo = FALSE)

quit(save = "no", status = 0)

