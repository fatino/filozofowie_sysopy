#!/bin/bash 
##ZMIENNE
NUMER_FILOZOFA=$1
LICZBA_FILOZOFOW=$2
LICZBA_POSILKOW=$3
CZAS_KONSUMOWANIA=$4
CZAS_ROZMYSLANIA=$5
PREFIX_WIELCA=$6
SCIEZKA_STOLU=$7
zjadlem_polowe=0
liczba_polownikow=0
##
##FUNKCJE
function losowanie(){
    if [ "$1" = losuj ]
    then
        echo "0.$RANDOM"
    else
        echo "$1"
    fi
}
function komunikat(){ 
    echo "$(date +%H:%M.%S.%N) PID: $$ FILOZOF $NUMER_FILOZOFA : "
}

function jedzenie(){
    echo "$(komunikat) Probuje wziac $PREFIX_WIELCA$pierwszy"
    flock $pierw
    echo "$(komunikat) Wzialem $PREFIX_WIELCA$pierwszy wiec probuje wziac $PREFIX_WIELCA$drugi"
    flock $drug
    echo "$(komunikat) Wzialem $PREFIX_WIELCA$drugi wiec zaczynam jesc $ZP posilek  $1 sekund"
    sleep $1
    echo "$(komunikat) Zjadlem $ZP posilek wiec odstawiam widelce i rozmyslam $2 sekund"
    flock -u $drug
    flock -u $pierw
    sleep $2
    echo "$(komunikat) Namyslilem sie"
}
##
##Sprawdzam kim jestem i oznaczam kolejnosc brania widelcy
if [ $NUMER_FILOZOFA -eq 1 ] 
then
    pierwszy=$LICZBA_FILOZOFOW
    drugi=1
else
    pierwszy=$NUMER_FILOZOFA
    drugi=$(expr $NUMER_FILOZOFA - 1)
fi
##Desykryptory
pierw=$(expr $pierwszy + 3)
drug=$(expr $drugi + 3)
eval "exec $pierw>$SCIEZKA_STOLU/$PREFIX_WIELCA$pierwszy"
eval "exec $drug>$SCIEZKA_STOLU/$PREFIX_WIELCA$drugi"
eval "exec 3>blokada.txt"
##Zaczynam
echo "$(komunikat) +++START+++"
echo "$(komunikat) Numer filozofa: $NUMER_FILOZOFA"
echo "$(komunikat) Liczba filozofow: $LICZBA_FILOZOFOW"
echo "$(komunikat) Liczba posilkow: $LICZBA_POSILKOW"
echo "$(komunikat) Czas kosnumownia: $CZAS_KONSUMOWANIA"
echo "$(komunikat) Czas rozmyslania: $CZAS_ROZMYSLANIA"
echo "$(komunikat) Prefix widelca: $PREFIX_WIELCA"
echo "$(komunikat) Sciezka stolu: $SCIEZKA_STOLU"
echo "$(komunikat) Pierwszy widelec: $pierwszy"
echo "$(komunikat) Drugi widelec: $drugi"

flock -s 3 
for ZP in $(seq 1 $LICZBA_POSILKOW)
do
    if [[ "$ZP" -le "$(expr $(expr $LICZBA_POSILKOW + 1) / 2)" ]]
    then
        jedzenie $(losowanie $CZAS_KONSUMOWANIA) $(losowanie $CZAS_ROZMYSLANIA)
    else
        if [ $zjadlem_polowe -eq 0 ]
        then
            zjadlem_polowe=1
            echo "$(komunikat) ---POLOWA---"
            flock -u 3
        else
            flock -x 3
            flock -u 3
            jedzenie $(losowanie $CZAS_KONSUMOWANIA) $(losowanie $CZAS_ROZMYSLANIA)
        fi
    fi
done

if [ "$LICZBA_POSILKOW" -eq 2 ] || [ "$LICZBA_POSILKOW" -eq 3 ]
then
    flock -x 3
    flock -u 3
    jedzenie $(losowanie $CZAS_KONSUMOWANIA) $(losowanie $CZAS_ROZMYSLANIA) 
fi

echo "$(komunikat) ___STOP___"
