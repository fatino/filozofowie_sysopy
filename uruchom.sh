#!/bin/bash
#sprawdzanie czy zmienna VAR jest pusta if [ -z "${VAR+xxx}
SCIEZKA_STOLU=stol
PREFIX_WIDELCA=widelec
LICZBA_FILOZOFOW=5
LICZBA_POSILKOW=9
while getopts :s:w:f:n:k:r: ARG
do
 case $ARG in
  s) SCIEZKA_STOLU=$OPTARG;;
  w) PREFIX_WIDELCA=$OPTARG;;
  f) declare -i LICZBA_FILOZOFOW=$OPTARG;;
  n) declare -i LICZBA_POSILKOW=$OPTARG;;
  k) declare -i CZAS_KONUMOWANIA=$OPTARG;;
  r) declare -i CZAS_ROZMYSLANIA=$OPTARG;;
  *) echo Nieznana opcja $OPTARG; exit 2;;
 esac
done





echo "$($PWD/czas.sh) PID: $$ uruchom.sh : Generuje widelce"


if [ ! -d "$SCIEZKA_STOLU" ]; then
  mkdir "$SCIEZKA_STOLU"
fi




for j in $(seq $LICZBA_FILOZOFOW)
do
    touch $SCIEZKA_STOLU/$PREFIX_WIDELCA$j
done

echo "$($PWD/czas.sh) PID: $$ uruchom.sh : Odpalam filozofów"

for i in $(seq $LICZBA_FILOZOFOW)
do
    $PWD/FILOZOFOWIE $i $LICZBA_FILOZOFOW &
done
