# This script pulls results from the rstats log, cleans them, and turns this cleaned text into an html file.
cd ~/CorBot/
touch website/index.html
cat website/header.html > website/index.html
sed -n '/Closing/!p' correlations.log | sed -n '/Opening/!p' | sed 's/$/<br>/' >> website/index.html
cat website/footer.html >> website/index.html
mv website/index.html /var/www/html/index.html
