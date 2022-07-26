#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [ -z $1 ]
then
  echo "Please provide an element as an argument."
  exit
fi
numre='[0-9]+'
symre='^[A-Za-z]{1,2}$'
if [[ $1 =~ $numre ]] ; then
  ELEMENT_RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1;")
elif [[ $1 =~ $symre ]] ; then
  ELEMENT_RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1';")
else
  ELEMENT_RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type FROM elements LEFT JOIN properties ON elements.atomic_number=properties.atomic_number LEFT JOIN types ON properties.type_id = types.type_id WHERE elements.name = '$1';")
fi

if ! [[ -z "$ELEMENT_RESULT" ]];
then
  #the IFS="|" makes it so we do not have to use "BAR" between each read identifier
  echo "$ELEMENT_RESULT" | while IFS="|" read NUM SYM NAME MASS MP BP TYPE
  do
    echo -e "The element with atomic number $NUM is $NAME ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    len=`expr length "$ELEMENT_RESULT"`
    #echo "The length of string is $len"
    #echo -e $ELEMENT_RESULT
  done
else
  echo "I could not find that element in the database."
fi

