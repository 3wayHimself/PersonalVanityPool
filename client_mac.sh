#!/usr/bin/env bash
echo "Connectivity check, please allow any firewall popup."
PATTERN=$(curl "http://ajwest.dyndns.org:5001/pattern")
PUBLICKEY=$(curl "http://ajwest.dyndns.org:5001/public_key")
echo Search pattern from server: $PATTERN
echo Public Key from server: $PUBLICKEY
echo "Starting generation WARNING: ensure your computer fans are not obstructed!"
echo "If you find the solution, the results will be saved automatically."
echo "You may use your computer, but it will be bogged down."
echo "You can restart at anytime and it's no detriment at all, please continue!"
vanitygen -o "save.txt" -P $PUBLICKEY $PATTERN
filename="save.txt"
while read -r line
do
    name="$line"
    first=0
    for word in $name
        do
         if first==0
            then type=$word
            first=1
         else key=$word
         fi
         echo here $type $key
         curl "http://ajwest.dyndns.org:5001/report?type=$type&key=$key"
    done
done < "$filename"