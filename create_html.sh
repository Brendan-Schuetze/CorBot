touch index.html
cat header.html > index.html
sed -n '/Closing/!p' correlations.log | sed -n '/Opening/!p' | sed 's/$/<br>/'  >> index.html
cat footer.html >> index.html
mv index.html /var/www/html/index.html
