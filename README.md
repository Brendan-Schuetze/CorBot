# CorBot

>*[I'm a bot. Technically Type 1 Errors, not correlations. Plotting random data and running t-tests since 2018.](https://twitter.com/CorrelationsBot)*

A Twitter Bot that generates a set of random data, performs a t-test, and tweets out a graph of this data.

# Installation Instructions

1. Clone this repository into a Linux or Unix-based platform.
2. Create a Twitter API application [here](https://apps.twitter.com/).
3. Fill your credentials into "Credentials_Example.R" and rename this file to "Credentials.R".
4. If you want to change the behavior of the bot, edit the commands found within "tweet_update.R"; this is the main R script that composes the tweet and sends it to Twitter.
4. Create a cronjob running your bot every hour. See this [website](https://code.tutsplus.com/tutorials/scheduling-tasks-with-cron-jobs--net-8800) for more information. A sample cronjob might look like:
> 0 * * * * Rscript ~/CorBot/tweet_update.R >/dev/null 2>&1
5. That's it. You're done.