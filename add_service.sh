#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "Name of new service: "
read SERVICE

while [[ ! -z $SERVICE ]]
do
  if [[ -z $($PSQL "SELECT * FROM services WHERE name='$SERVICE'") ]] 
  then
    INSERT_SERVICE=$($PSQL "INSERT INTO services(name) VALUES('$SERVICE');")
    echo -e "\nService with name '$SERVICE' Inserted Into database."

  else
    echo -e "\nService with name '$SERVICE' already exists. Create new name. Not Inserted."
  fi
  
  read SERVICE
done