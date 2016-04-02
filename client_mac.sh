#!/usr/bin/env bash
echo "Connectivity check, please allow any firewall popup."
# We need to get the search pattern and public key from the server. We could have setup the server to return json
# and then written some bash code to set the values to the proper variables. However, we have a server and it's just
# a bit of text, so why not make two separate calls and return plaintext? So we do that, set it to the variable and we
# can just use that directly later. This also serves to prompt any firewall popup from the client computer so the user
# can allow the connection, which we'll need later if it ends up solving the key.
PATTERN=$(curl --silent "http://localhost:5001/pattern")
PUBLICKEY=$(curl "http://localhost:5001/public_key")


echo " "
echo " "
echo "Search pattern from server: $PATTERN"
echo "Public Key from server: $PUBLICKEY"
echo " "
echo "Starting key generation"
echo " "
echo "!!! WARNING: Ensure your computer fans are not obstructed! !!!"
echo " "
echo "If this is a laptop, you'll need to plug it into a wall outlet."
echo " "
echo "If you find the solution, the results will be saved and reported over the internet automatically. You may use your computer while the computation is underway, but it will be bogged down and you won't be able to render complex graphics. You can restart at anytime and it's no detriment at all, please feel free to close for a period and reopen later to continue the search for the solution!"
echo " "
echo " "
echo "Below you can watch the probability of finding the solution in this session. This is NOT a traditional progress bar, it's an idea of the work you've performed in the time since you opened this script."

if PUBLICKEY=="OFF":
    then vanitygen -o "save.txt" $PATTERN
else
    vanitygen -o "save.txt" -P $PUBLICKEY $PATTERN
fi
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