initialtime=$(date +%s)

echo $initialtime

i=0
while [ $i -lt 10 ]; do
    'SELECT COUNT(*) FROM Bird_nests'
    i=$((i+1))
done