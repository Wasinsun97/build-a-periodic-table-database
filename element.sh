#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# if argument is number
if [[ $1 =~ ^[1-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties using(atomic_number) INNER JOIN types using(type_id) WHERE atomic_number = '$1'")
else
# if argument is string
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties using(atomic_number) INNER JOIN types using(type_id) WHERE name = '$1' OR symbol = '$1'")
fi
  # echo $ELEMENT

# not found ELEMENT
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo $ELEMENT | while IFS="|" read NUM ELEMENT_NAME SYMBOL TYPE MASS MP BP 
do
  # echo "$NUM $ELEMENT_NAME $SYMBOL $TYPE $MASS $MP $BP "
  echo "The element with atomic number $NUM is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT_NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
done
