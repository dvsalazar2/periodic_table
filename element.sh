#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#check if argument is empty
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  #if not check if arg is numberic
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #if numeric retrieve element by atomic number
    ELEMENT_INFO=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number = $1")
    if [[ -z $ELEMENT_INFO ]]
    then
      #if not found
      echo I could not find that element in the database.
    else
      #if found pipe result into variables and show corresponding message
      echo $ELEMENT_INFO | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  else
    #if arg is not numeric assume it is string and retrieve by symbol or name
    ELEMENT_INFO=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where symbol ILIKE '$1' OR name ILIKE '$1'")
    if [[ -z $ELEMENT_INFO ]]
    then
      #if not found
      echo I could not find that element in the database.
    else
      #if found pipe result into variables and show corresponding message
      echo $ELEMENT_INFO | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  fi
fi