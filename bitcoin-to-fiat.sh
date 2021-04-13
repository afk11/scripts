#!/usr/bin/env bash

currency=${TO_CURRENCY:-EUR}
price=$(curl -s http://api.coindesk.com/v1/bpi/currentprice.json  | jq -r ".bpi.$currency.rate" | sed 's/,//g')
code_curl="${PIPESTATUS[0]}" code_final=$?

[[ $code_curl = 0 ]] || { echo "Failed to fetch current price"; exit 1; }
[[ $code_final = 0 ]] || { echo "Failed to process price response"; exit 1; }

while IFS= read -r amount
do
    value=`echo $price $amount | awk '{printf "%4.3f\n",$1*$2}'`
    echo $value
    echo ""

done < /dev/stdin

