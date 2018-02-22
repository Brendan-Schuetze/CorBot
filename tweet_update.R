library(ggplot2)
library(dplyr)
library(ggthemes)
library(twitteR)
library(luzlogr)

source("~/CorBot/credentials.R")

truncateStr <- function(strng, comma = TRUE) {
  # Takes a string and truncates it to 5 decimal characters.
  if(comma){
    return(paste(substr(toString(strng), 1, 5), ",", sep=""))
  } else {
    return(substr(toString(strng), 1, 5))
  }
}

getTitle <- function(p_value) {
  # Generates titles and captions for graphs based upon p-values.
  if(p_value <= .05) {
    caption <-  "Publishable. 🎉 "
    title <-  "Publishable."
  } else if(p_value <= .1) {
    title <- "Publishable?"
    caption <- title
  } else {
    title <- "Not Publishable."
    caption <- title
  }
  return(list(title, caption))
}

# Create Random Dataset
conditions <- c(rep("A", 100), rep("B", 100))
sd <-  abs(rnorm(1, .5, .25))

df <- data.frame(factor(conditions), rnorm(200, 1, sd))
colnames(df) <- c("Condition","Value")

# Segment Data by Condition
x <- df[df$Condition == "A",]$Value
y <- df[df$Condition == "B",]$Value
z <- data.frame(x, y)

if(runif(1, 0, 1) > .5) {
  # Compare Means and Create Bar Graph
  sig <- t.test(x, y)
  p_value <- sig$p.value
  
  # Calculate SD and Confidence Intervals
  df <- df %>%
    group_by(Condition) %>%
    summarize(mean = mean(Value), 
              sd = sd(Value),
              se = sd(Value) / sqrt(n()))
  
  df <- df %>%
    mutate(ci_low = mean - 1.96 * se, ci_high = mean + 1.96 * se)
  
  title <- unlist(getTitle(p_value)[1])
  caption <- unlist(getTitle(p_value)[2])
  
  # Generate Bar Graph
  ggplot(data = df) + geom_bar(aes(x = Condition, y = mean), stat = "identity") + 
    geom_errorbar(aes(x = Condition, ymin = ci_low, ymax = ci_high), width = 0.2) + ylab("Mean") + 
    ggtitle(label = title, subtitle = paste("n = 200, sd =", truncateStr(sd), "t =", truncateStr(sig$statistic), "p =", truncateStr(sig$p.value, FALSE))) + 
    theme_base()

} else {
  # Calculate Correlation and Plot Data
  sig <- cor.test(x, y)
  p_value <- sig$p.value
  r_value <- sig$estimate
  t_value <- sig$statistic
  
  title <- unlist(getTitle(p_value)[1])
  caption <- unlist(getTitle(p_value)[2])
  
  ggplot(data = z, aes(x, y)) + geom_point() + geom_smooth(method = "lm", se = FALSE) +
    theme_base() + ggtitle(label = title, subtitle = paste("n = 200, df = 98, r =", truncateStr(r_value), "t =", 
                                            truncateStr(t_value), "p =", truncateStr(p_value, FALSE))) + 
    xlab("A") + ylab("B") 
}
ggsave(filename = "plot.png")

tweet(text = caption, mediaPath = "plot.png")

if(p_value <= .05) {
    fp <- read.table("results.txt")
    fp_caption = paste("New false positive! Current false positive rate =", fp, "#rstats")
    tweet(text = fp_caption)
}

openlog("~/CorBot/correlations.log", append = TRUE)
printlog(paste(caption, "p =",  substr(toString(sig$p.value), 1, 5)))
closelog(sessionInfo = FALSE)

quit(save = "no", status = 0)

