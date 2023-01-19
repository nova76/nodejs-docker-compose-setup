#!/bin/bash

if [ -f .env ]; then
    # If .env file exists, extract domain and network values
    domain=$(grep domain .env | awk -F "=" '{print $2}')
    service=$(grep service .env | awk -F "=" '{print $2}')
    network=$(grep network .env | awk -F "=" '{print $2}')
    host=$(grep host .env | awk -F "=" '{print $2}')
else
    # If .env file does not exist, set domain to the current Linux domain and network to the first available Docker network
    domain=$(hostname)
    service=$(pwd -P | awk -F/ '{print $NF}')
    network=$(docker network ls --format "{{.Name}}" | head -n 1)
    host="$service.$domain"
fi

# get default network number from docker nwtwork list
default_network_number=$(docker network ls | awk '{print NR-1, $2}' | tail -n +2 | grep "$network" | awk '{print $1}')
#echo "The default network number is: $default_network_number"

#Prompt user to enter new value for domain and offer the current value as suggestion
echo "Please enter a new value for domain (current value: $domain): "
read new_domain
if [ -n "$new_domain" ]; then
    host=$(echo "$host" | sed "s/$domain/$new_domain/g")
    domain="$new_domain"
fi

#Prompt user to enter new value for service and offer the current value as suggestion
echo "Please enter a name for the service (current value: $service): "
read new_service
if [ -n "$new_service" ]; then
    host=$(echo "$host" | sed "s/$service/$new_service/g")
    service="$new_service"
fi

#Prompt user to enter new value for nwtwork and offer the current value as suggestion
echo "Please select a value for network from the list below (current value: $network):"
docker network ls | awk '{print NR-1, $2}' | tail -n +2 
while [ -z "" ];
do 
    read -p '' network_number
    if [ -z $network_number ]; then 
        # the netwok number not selected, set current value (default_network_number)
        network_number=$default_network_number
    fi
    network=$(docker network ls | awk -v num="$network_number" 'NR==num+1 {print $2; exit}')
    if [ -z "$network" ] || [ "$network" = "ID" ] ; then
        tput setaf 1 # Set text color to red
        echo "The network is not selected. Try again ($network_number)"
        tput sgr0 # Reset text color to the default
    else
        #echo "selected network: $network";
        break;
    fi
done

# echo "domain: $domain"
# echo "service: $service"
# echo "network: $network"

echo "domain=$domain" > .env 
echo "service=$service" >> .env
echo "network=$network" >> .env
echo "host=$host" >> .env

mkdir app -p

cat .env
