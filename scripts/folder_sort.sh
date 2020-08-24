#!/bin/bash 

# sort images based on a csv file into true and false triggers

# this is the basename server path that we want to remove
DIRREMOVE="/media/usb/dave"
# run the script from the place you want the three folders created
BASE=$(pwd)
TRUETRIG=${BASE}/animal
FALSETRIG=${BASE}/negative
HUMAN=${BASE}/human
# cut off as a probability of successful image detection
cutoff=0.8

mkdir -p $TRUETRIG
mkdir -p $FALSETRIG
mkdir -p $HUMAN

echo "Probability cut-off set at $cutoff"

IFS=","
while read file result col3 col4 col5
do
  DIRTARGET=$(dirname $file)
  # only proc images over cutoff
  if (( $(echo "$result >= $cutoff" | bc -l) ))
  then
    if (( $(echo "$col4==1" | bc -l) ))
    then
      # true trigger
      DEST=${TRUETRIG}${DIRTARGET#"$DIRREMOVE"}
      mkdir -p $DEST
      echo "mv $file $DEST/"
      mv $file $DEST/
    else
      # prob greater cut off but cat 1/2 or 2 == human
      DEST=${HUMAN}${DIRTARGET#"$DIRREMOVE"}
      mkdir -p $DEST
      echo "mv $file $DEST/"
      mv $file $DEST/
    fi
  else
    DEST=${FALSETRIG}${DIRTARGET#"$DIRREMOVE"}
    mkdir -p $DEST
    echo "mv $file $DEST/"
    mv $file $DEST/
  fi
done<"$1"
