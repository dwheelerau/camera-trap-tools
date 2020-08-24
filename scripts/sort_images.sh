#!/bin/bash 

# sort images based on a csv file into true and false triggers

TRUETRIG="animal"
FALSETRIG="negative"
HUMAN="human"
BASE=$(pwd)
# cut off as a probability of successful image detection
cutoff=0.8

echo ${BASE}${TRUETRIG}
#mkdir -p $FALSETRIG
#mkdir -p $HUMAN

echo "Probability cut-off set at $cutoff"

IFS=","
while read file result col3 col4 col5
do
  TARGET=$(basename $file .JPG)_detections.jpg
  TARGETUP=$(echo $TARGET | tr A-Z a-z)
  if (( $(echo "$result > $cutoff" | bc -l) ))
  then
    if (( $(echo "$col4==1" | bc -l) ))
    then
      # true trigger
      #mv $TARGETUP $TRUETRIG
    else
      # prob greater cut off but cat 1/2 or 2 == human
      #mv $TARGETUP $FALSETRIG
    fi
  else
    #mv $TARGETUP $FALSETRIG
  fi
  TRUECOUNT=$(ls $TRUETRIG | wc -l)
  FALSECOUNT=$(ls $FALSETRIG | wc -l)
done<"$1"
# print out
echo "positive file count $TRUECOUNT"
echo "negative file count $FALSECOUNT"
