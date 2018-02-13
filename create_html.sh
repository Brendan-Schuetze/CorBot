header.html > index.html
sed -n '/Closing/!p' correlations.log | sed -n '/Opening/!p' >> index.html
footer.html >> index.html
mv index.html /var/www/html/index.html
