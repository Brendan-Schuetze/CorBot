# Calculate the Proportion of False Positives

# Set the precision of our calculations.
echo -n 'scale=3;' > calc.txt

# Comb through the rstats log for false positive results. 
grep -P '(?<!Not) Publishable.' /var/www/html/index.html | grep -P '(?<!Maybe) Publishable\.' | wc -l  >> calc.txt
echo -n '/' >> calc.txt 

# Comb through rstats log for total number of tests conducted thus far.
grep Publishable. -o /var/www/html/index.html | wc -l >> calc.txt
perl -p -i -e 's/\R//g;' calc.txt
echo '' >> calc.txt
rm results.txt

# Run calculation using the Linux built-in bc calculator
cat calc.txt | bc > results.txt
