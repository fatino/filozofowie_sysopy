#!/bin/bash 
#sprawdzanie czy zmienna VAR jest pusta if [ -z "${VAR+xxx}" ]
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
        k) declare CZAS_KONSUMOWANIA=$OPTARG;;
        r) declare CZAS_ROZMYSLANIA=$OPTARG;;
        *) echo Nieznana opcja $OPTARG; exit 2;;
    esac
done

echo "$(date +%H:%M.%S.%N) PID: $$ uruchom.sh : Generuje widelce"

if [ ! -d "$SCIEZKA_STOLU" ]; then
    mkdir "$SCIEZKA_STOLU"
fi

echo "$(date +%H:%M.%S.%N) PID: $$ uruchom.sh : Touchuje kontrola_posilkow.txt"

touch blokada.txt

for j in $(seq $LICZBA_FILOZOFOW)
do
    touch $SCIEZKA_STOLU/$PREFIX_WIDELCA$j
done

echo "$(date +%H:%M.%S.%N) PID: $$ uruchom.sh : Odpalam filozofów"

if [ -z "${CZAS_KONSUMOWANIA+xxx}" ] ; then
    for NUMER_FILOZOFA in $(seq $LICZBA_FILOZOFOW)
    do
        $PWD/filozof.sh $NUMER_FILOZOFA $LICZBA_FILOZOFOW $LICZBA_POSILKOW losuj losuj $PREFIX_WIDELCA $SCIEZKA_STOLU &
    done
else
    for NUMER_FILOZOFA in $(seq $LICZBA_FILOZOFOW)
    do
        $PWD/filozof.sh $NUMER_FILOZOFA $LICZBA_FILOZOFOW $LICZBA_POSILKOW $CZAS_KONSUMOWANIA $CZAS_ROZMYSLANIA $PREFIX_WIDELCA $SCIEZKA_STOLU &
    done
fi    

wait

echo "$(date +%H:%M.%S.%N) PID: $$ uruchom.sh : Posprzatac?(Tt/anythingelse)"
read czysc
case "$czysc" in
    [tT])
        rm $SCIEZKA_STOLU -r
        rm blokada.txt;;
    *)
    ;;
esac    
