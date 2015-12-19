#!/bin/bash
# Date: 29-12-2015
# Author: "lapipaplena" <lapipaplena@gmail.com>
# Disseny menú: "Catplus" <info@catplus.cat>
# Version: 1.0
# Licence: GPL v3.0
# Description: Programa de gestió d'associacions de linux
# Require: ccrypt
#
#
COLUMNS=`tput cols`-2 export COLUMNS # Get screen width.
COLUMNA=`tput cols`-7 export COLUMNA # Get screen width.
####
function center {
awk ' { spaces = ('$COLUMNS' - length) / 2
while (spaces-- > 0) printf (" ")
	print
}'
}
####
function centera {
awk ' { spaces = ('$COLUMNA' - length) / 2
while (spaces-- > 0) printf (" ")
	print
}'
}
####
function centrar {
printf '%.s=' {1..77} | center
echo
COLS=`tput cols`
COLA=$((COLS/2-9))
tput cup 22 $COLA
tput bold
    }
#### COMENÇA ##########
#######################
#
#
while :
do
    clear
    echo
    printf '=%.s' {1..77} | center
    tput bold
    echo " **** Menú d'administració de La Pipa Plena****" | center
    tput sgr0
    tput dim
    tput sgr0
    printf '%.s-' {1..77} | center
    echo
    echo "MAIN MENU" | center
    cat<<EOF|centera

Entrades contables............ a	Consultar saldo............... b
Últimes entrades contabilitat. c	Tot el regitre contable....... d
Esborrar entrada contable..... e	Nom i correu dels socis ...... f
Mostrar dades soci concret.... g	Entrar un nou soci............ h
Donar de baixa un soci........ i	Llistat exsocis............... j
Fer copies seguretat.......... k	Consultar backup anterior..... l
Entrar quota soci............. m	Revisar codi.................. n
Tancar gestió................. Q	Prova d'edicio amb vim ....... 2
Sortida del servidor ......... q	Visualització .................n
EOF
echo
centrar
read -n1 -s -p "Tria una opció: "
tput sgr0
## Definir directoris de treball
#
PIPA=~/pipa
BACKUPS=~/backups
#
cd $PIPA
    case "$REPLY" in
        "a")## Entrades i surtides contables
            clear
            MES_IMPORTS=s
            while [ $MES_IMPORTS = s ]
            do
                DATE=`date +"%d-%m-%Y"`
                if [ -f contabilitat.txt ]; then
                    echo
                else
                    touch contabilitat.txt
                fi
                echo
                ## Crear linia amb les dades d'entrada i si en falta una et fot fora
                read -p "Import: " IMPORT
                read -p "Concepta: " CONCEPTA
                if [[ -z $IMPORT ]] || [[ -z $CONCEPTA ]] ; then
                    echo
                    echo "falten algunes dades..."
                    echo
                else
                    printf "%-10s\t %-25s\t %s\n" "$IMPORT" "$CONCEPTA" "$DATE" >> contabilitat.txt
                    echo
                    ## Mostrar el saldo
                    awk 'BEGIN { FS = "\t" };{ sum += $1; } END { print "Saldo: " sum; }' contabilitat.txt
                    echo
                fi
                sed '/^$/d' contabilitat.txt > /tmp/conta.txt
                cp /tmp/conta.txt contabilitat.txt
                read -n1 -p "Entrar més imports? (s/n): " MES_IMPORTS
                clear
            done ;;
        "b")## Mostrar el saldo
            clear
            echo
            awk 'BEGIN { FS = "\t" };{ sum += $1; } END { print "Saldo: " sum " Euros"; }' contabilitat.txt
            echo ;;
        "c")## Mostrar les 20 darreres entrades en el llibre contable
            clear
            echo
            tail -n 20 contabilitat.txt
            echo ;;
        "d")## Mostrar tot el registre de contabilitat
            echo
            cat contabilitat.txt | less
            clear
            echo ;;
        "e")## Esborrar la última entrada contable
            clear
            echo
            read -n1 -p "Esborrar última entrada contable de l'arxiu contabilitat.txt? (s/n) " ESBORRAR
            echo
            if [ $ESBORRAR = "s" ]; then
                sed '$d' contabilitat.txt > /tmp/contabilitat
                cp /tmp/contabilitat contabilitat.txt
                rm /tmp/contabilitat
                echo
                echo "Fet"
            fi
            clear
            echo ;;
        "f")## Mostrar nom dels socis i correu
            clear
            echo
            awk 'BEGIN { FS = ";" };{ printf "%-5s %-10s %-10s %-10s %s\n", $1, $2, $3, $4, $13 }' socis.txt > /tmp/socis.txt
            echo
            cat /tmp/socis.txt
            echo
            NUM=`wc -l socis.txt | cut -d " " -f 1`
            echo "Hi han $NUM socis actius"
            echo ;;
        "g")## Mostrar dades d'un soci concret
            clear
            echo
            read -p "De quin soci vols les dades? " SOCI
            echo
            NOM=`grep -i $SOCI socis.txt`
            if [ $? -eq 0 ]; then
                grep -i $SOCI socis.txt | cut -d ";" -f 2,3,4,5,6,7,9,13 | sed 'y/;/ /'
                echo
            else
                echo "Aquest soci no existeix"
                fi
            echo ;;
        "h")## Entrar un nou soci
            echo
            REPETIR=s
            while [ $REPETIR = s ]
            do
                clear
                CONTADOR=`tail -n1 socis.txt | awk 'BEGIN { FS = ";" };{ printf$1 }'`
                # CONTADOR=`cat socis.txt | tail -n 1 | cut -d ";" -f 1`
                echo
                let CONTADOR+=1
                read -p "Nom: " NOM
                read -p "1er cognom: " COGNOM1
                read -p "2on cognom: " COGNOM2
                read -p "Carrer i número: " CARRER
                read -p "Població: " POBLACIO
                read -p "Codi postal: " CODI
                read -p "Telèfon fix: " FIX
                read -p "Telèfon movil: " MOVIL
                # sexe
                read -p "Correu electrónic: " CORREU
                # número soci
                # foto
                # date d'alta
                # date pagament
                # actiu
                # rang
                # rebre noticies
                echo
                echo "${CONTADOR};${NOM};${COGNOM1};${COGNOM2};${CARRER};${POBLACIO};${CODI};${FIX};${MOVIL};;${CORREU};;;;;;1" > /tmp/nou_soci
                echo
                echo "Les dades entrades son: "
                echo
                tail -1 /tmp/nou_soci
                echo
                read -n1 -p "Son correctes? (s/n) " CORRECTES
                echo
                if [ $CORRECTES = s ]; then
                    echo
                    cat /tmp/nou_soci >> socis.txt
                    echo "Dades entrades a l'arxiu socis.txt..."
                    echo
                    break
                else
                    echo
                    read -n1 -p "repetirles? (s/n) " REPETIR
                    echo
                fi
            done
            echo ;;
        "i")## Donar de baixa un soci
            clear
            echo
            read -p "Baixa del soci NÚMERO?: " NUM_BAIXA
            #
            BAIXA=`sed -n "/^${NUM_BAIXA}/p" socis.txt`
            #
            if [[ -z $BAIXA ]]; then
                echo
                echo "No hi ha cap soci amb aquest número"
                echo
            else
                # posar la baixa a baixes.txt
                echo $BAIXA >> baixes.txt
                sed '/^$/d' baixes.txt >> /tmp/baixes
                sort -u -t ";" -k1n /tmp/baixes > baixes.txt
                rm /tmp/baixes
                echo
                # treure soci d l'arxiu socis.txt
                sed -e "/${BAIXA}/d" socis.txt > /tmp/socis
                sort -u -t ";" -k1n /tmp/socis > socis.txt
                rm /tmp/socis
                echo
                echo "fet"
                echo
            fi
            echo ;;
        "j")## Llistat d'exsocis
            echo
            clear
            echo
            awk 'BEGIN { FS = ";" };{ printf "%-5s %-10s %-10s %-10s %s\n", $1, $2, $3, $4, $13 }' baixes.txt > /tmp/baixes
            echo
            cat /tmp/baixes | sed '/^$/d'
            echo
            EX=`wc -l /tmp/baixes | cut -d " " -f 1`
            echo "S'han donat de baixa $EX socis"
            rm /tmp/baixes
            echo ;;
        "k")## fer copies seguretat dels fixer .txt i .sh
            clear
            echo
            FILES=(`date +%d%m%Y%M%S`.tar.bz2)
            if [ -d $BACKUPS ]; then
                echo
            else
                mkdir $BACKUPS
            fi
            tar -c *.txt *.sh | bzip2 > $BACKUPS/$FILES
            echo "Realitzada copia de seguretat a ~/backups dels arxius: "
            echo
            ls *.txt *.sh
            ## Guardar només les darreres 5 copies de seguretat i anar suprimint la més antiga.
            #
            ANTIC=`ls -lt $BACKUPS | tail -n 1 | cut -d " " -f 9`
            if [ `ls $BACKUPS | wc -l` -lt 6 ]; then
                echo
            else
                rm $BACKUPS/$ANTIC
            fi
            echo ;;
        "l")## Consultar les dades de l'anterior backup
            echo
            clear
            cd $BACKUPS
            echo
            tar -xf `ls -ltr | tail -n 1 | cut -d " " -f 9`
            TORNAR=s
            while [ $TORNAR = s ]
            do
                ls *.{sh,txt}
                echo
                read -p "Quin arxiu vols veure?: " LLEGIR
                echo
                if [ $LLEGIR == socis.txt ]; then
                    cat socis.txt
                    echo
                elif [ $LLEGIR == contabilitat.txt ]; then
                    cat contabilitat.txt
                    echo
                elif [ $LLEGIR == baixes.txt ]; then
                    cat baixes.txt
                    echo
                elif [ $LLEGIR == gespip.sh ]; then
                    cat gespip.sh | less
                else
                    echo "Opció no valida."
                fi
                echo
                read -n1 -p "Fer nova consulta? (s/n): " TORNAR
                clear
            done
            rm *.txt *.sh 2>/dev/null
#            cd ~/pipa
            cd $PIPA
            clear
            echo ;;
        "m")## Entrar quotas, veure pendents i socis al corrent de pagament
            echo
            clear
            read -p "Quotes de l'any?: " QUOTES
            if [ -f ${QUOTES}.txt ]; then
                echo
            else
                touch ${QUOTES}.txt
                awk 'BEGIN { FS = ";" };{ printf "%-10s %-10s %s\n", $2, $3, $4 }' socis.txt  > /tmp/quotes
                sed = /tmp/quotes | sed 'N;s/\n/\t/' > ${QUOTES}.txt
            fi
            echo
            read -n 1 -p "Entrar la quota d'un soci? (s/n): " ENTRAR
            echo
            while [ $ENTRAR = s ]
            do
                echo
                cat ${QUOTES}.txt
                echo
                read -p "Número de soci que ha fet el pagament?: " NUM
                echo
                clear
                awk '{print$1}' ${QUOTES}.txt > /tmp/num
                grep $NUM /tmp/num
                if [ $? -eq 0 ]; then
                    let A=$NUM
                    echo
                    sed -i "$A s|$| --> Pagat|" ${QUOTES}.txt
                    echo
                    cat ${QUOTES}.txt
                    echo
                    echo
                else
                    echo
                    echo "Soci inexisten o entrada incorrecte "
                    echo
                fi
                echo
                read -n 1 -p "Entrar un altre pagament? (s/n): " ENTRAR
                clear
            done
            clear
            echo
            read -n 1 -p "Llistar socis al corrent de pagament? (s/n): " CORRENT
            echo
            if [ $CORRENT = s ]; then
                echo
                cat ${QUOTES}.txt | grep "Pagat"
                echo
            fi
            echo
            read -n 1 -p "Llistar pendents? (s/n): " PENDENT
            echo
            if [ $PENDENT = s ]; then
                echo
                cat ${QUOTES}.txt | grep -v "Pagat"
                echo
            fi
            echo ;;
        "n")## Revisar el codi
            echo
            nano gespip.sh
            clear
            echo ;;

        "Q")  clear; exit ;;
        "*")## coses no contemplades
            clear
            echo
            echo "Opció no contemplada"
            echo ;;
    esac
    echo
    echo "----> Pulsa ENTER per tornar al menú..."
    read
done
clear
echo
