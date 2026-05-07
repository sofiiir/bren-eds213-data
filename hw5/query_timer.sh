#!/bin/bash

## PART 1
# set arguments
label="$1"
num_reps="$2"
query="$3"
db_file="$4"
csv_file="$5"

initialtime=$(date +%s)

echo $initialtime

i=0
while [ $i -lt $num_reps ]; do
    duckdb $db_file "$query;" 
    i=$((i+1))
done

currenttime=$(date +%s)

time_diff=$(($currenttime - $initialtime))

avg_time=$(echo "scale=7; $time_diff/$num_reps" | bc)

echo "$label" "," "$avg_time" >> $csv_file 


## PART 2
# In order to get timings that differed even slightly I ran the queries 
# 10,000 times. The outer_join was the fastest. The except clause was the
# slowest. The subquery was in between the two other times. 