# Calculate the Proportion of False Positives
echo -n 'scale=3;' > calc.txt
grep -P '(?<!Not) Publishable.' /var/www/html/index.html | grep -P '(?<!Maybe) Publishable\.' | wc -l  >> calc.txt
echo -n '/' >> calc.txt 
grep Publishable. -o /var/www/html/index.html | wc -l >> calc.txt
perl -p -i -e 's/\R//g;' calc.txt
echo '' >> calc.txt
rm results.txt
cat calc.txt | bc > results.txt
