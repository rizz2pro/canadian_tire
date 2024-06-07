#!/bin/bash

if [ -z $1 ];then 
read -p "Item code: " itemcodetmp
fi

if echo $itemcodetmp | grep html > /dev/null;then
	itemcode=$(echo $itemcodetmp | awk -F'.html' '{print $1}'| awk -F "-" '{print $NF}'&> /dev/null)
else
	itemcode=$itemcodetmp
fi

item_name=$(curl -s "https://apim.canadiantire.ca/v1/product/api/v1/product/productFamily/${itemcode}?baseStoreId=CTR&lang=en_CA&storeId=174&light=true"   -H 'sec-ch-ua: "Google Chrome";v="125", "Chromium";v="125", "Not.A/Brand";v="24"'   -H 'service-client: ctr/web'   -H 'bannerid: CTR'   -H 'sec-ch-ua-mobile: ?0'   -H 'service-version: ctc-dev2'   -H 'x-web-host: www.canadiantire.ca'   -H 'basesiteid: CTR'   -H 'ocp-apim-subscription-key: c01ef3612328420c9f5cd9277e815a0e'   -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36'   -H 'accept: application/json, text/plain, */*'   -H 'Referer: https://www.canadiantire.ca/'   -H 'browse-mode: OFF'   -H 'sec-ch-ua-platform: "Linux"'| json_pp | grep originalPrice -B 6 | grep name | awk -F':' '{print $2}')
echo
echo "   ===== $item_name =====   "
echo
#exit
for i in $(cat ./canadian_tire.conf); do
location=$(echo $i | awk -F':' '{print $1}')
store=$(echo $i | awk -F':' '{print $2}')

price=$(curl -s "https://apim.canadiantire.ca/v1/product/api/v1/product/productFamily/${itemcode}?baseStoreId=CTR&lang=en_CA&storeId=${store}&light=true"   -H 'sec-ch-ua: "Google Chrome";v="125", "Chromium";v="125", "Not.A/Brand";v="24"'   -H 'service-client: ctr/web'   -H 'bannerid: CTR'   -H 'sec-ch-ua-mobile: ?0'   -H 'service-version: ctc-dev2'   -H 'x-web-host: www.canadiantire.ca'   -H 'basesiteid: CTR'   -H 'ocp-apim-subscription-key: c01ef3612328420c9f5cd9277e815a0e'   -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36'   -H 'accept: application/json, text/plain, */*'   -H 'Referer: https://www.canadiantire.ca/'   -H 'browse-mode: OFF'   -H 'sec-ch-ua-platform: "Linux"' | json_pp | grep currentPrice -A 3 | grep value | awk -F':' '{ print $2}')

echo " - $location: $price"
done
