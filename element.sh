#!/bin/bash

# Define the PSQL command for querying the database
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Get the input argument for the database with elements
INPUT=$1

# Function to fetch and display element data
fetch_and_display_element_data() {
  local query="$1"
  local data=$($PSQL "$query")

  if [[ -z $data ]]; then
    echo "I could not find that element in the database."
    exit 0
  fi

  # Parse and format the data for output
  echo "$data" | while read -r _ _ atomic_number _ symbol _ name _ weight _ melting_point _ boiling_point _ type; do
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $weight amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
  done
}

# Determine the type of input and query accordingly
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  # Input is an atomic number
  QUERY="SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number='$INPUT'"
elif [[ ${#INPUT} -le 2 ]]; then
  # Input is an atomic symbol
  QUERY="SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$INPUT'"
else
  # Input is a full element name
  QUERY="SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE name='$INPUT'"
fi

# Fetch and display the data
fetch_and_display_element_data "$QUERY"
