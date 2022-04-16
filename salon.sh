#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

SHOW_SERVICES(){
  SERVICES=$($PSQL "SELECT * FROM services;")
  echo "$SERVICES" | while IFS='|' read SER_ID NAME
  do
  echo "$SER_ID) $NAME"
  done
}

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e $1
  fi
  # VERSION FOR FREECODECAMP TO PASS
  SHOW_SERVICES
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
    echo -e "\nI could not find that service. What would you like today?"
    SHOW_SERVICES
    read SERVICE_ID_SELECTED
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    if [[ ! -z $SERVICE_NAME ]]
    then
      SERVICE_C $SERVICE_NAME $SERVICE_ID_SELECTED 
    fi
  else
    SERVICE_C $SERVICE_NAME $SERVICE_ID_SELECTED 
  fi

  # BETTER VERSION
  # read SERVICE_ID_SELECTED
  # if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  # then
  #   MAIN_MENU "\nI could not find that service. What would you like today?"
  # fi

  # SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  # if [[ -z $SERVICE_NAME ]]
  # then
  #   MAIN_MENU "\nI could not find that service. What would you like today?"
  # else
  #   SERVICE_C $SERVICE_NAME $SERVICE_ID_SELECTED 

  # fi
}

TIME_DUTY(){
  echo "What time do you want to $2, $1?"
  read SERVICE_TIME

  CUST_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$4' AND name='$1';")

  INSRT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUST_ID,$3,'$SERVICE_TIME');")

  echo "I have put you down for a $2 at $SERVICE_TIME, $1."

}

SERVICE_C(){
  echo $1

  echo -e "\nWhat is your Phone Number?"
  read CUSTOMER_PHONE
  if [[ -z $($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE';") ]]
  then
    echo "Welcome New user, Enter Your Name:"
    read CUSTOMER_NAME
    INSRT_CST=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
    TIME_DUTY $CUSTOMER_NAME $1 $2 $CUSTOMER_PHONE
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    TIME_DUTY $CUSTOMER_NAME $1 $2 $CUSTOMER_PHONE
  fi
}

MAIN_MENU