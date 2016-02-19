#!/bin/bash
# Date: 19-02-2016
# Author: "lapipaplena" <lapipaplena@gmail.com>
# Disseny menú: "Catplus" <info@catplus.cat>
# Version: 4.0
# Licence: GPL v3.0
# Description: Programa de gestió d'associacions de linux
# Require: ccrypt sendemail libnet-ssleay-perl libio-socket-ssl-perl
#
## Crear directoris de treball i arxius
if [ -z $1 ]; then
    echo
    echo "La sintaxis es: gespip Nom_associació (gespip pipa, gespip Catplus...)"
    echo
    exit
fi
DIR=~/$1
BACKUPS=~/backups
if [[ -d $DIR ]] && [[ -d $BACKUPS ]]; then
    echo
else
    mkdir $DIR
    touch $DIR/{contabilitat.txt,baixes.txt,socis.txt}
    mkdir $BACKUPS
fi
#
cd $DIR
DATE=`date +"%d-%m-%Y"`
ANY=$(date +%Y)
if [ -f ${ANY}.txt ]; then
    echo
else
    touch ${ANY}.txt
    awk 'BEGIN { FS = ";" };{ printf "%-5s %-10s %-10s %s\n", $1, $2, $3, $4 }' socis.txt > ${ANY}.txt
fi
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
####
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
    echo " **** Menú d'administració de "$1" ****" | center
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
Editar privat................. o	Editar arxius mestres......... p
Enviar correu als socis....... r	Historial de missatges........ s
Tancar gestió................. Q
EOF
echo
centrar
read -n1 -s -p "Tria una opció: "
tput sgr0
## Opcions del menú
#
    case "$REPLY" in
        "a")## Entrades i surtides contables
            clear
            MES_IMPORTS=s
            while [ $MES_IMPORTS = s ]
            do
                echo
                ## Crear linia amb les dades d'entrada i si en falta una et fot fora
                read -p "Import: " IMPORT
                read -p "Concepta: " CONCEPTA
                if [[ -z $IMPORT ]] || [[ -z $CONCEPTA ]] ; then
                    echo
                    echo "falten algunes dades..."
                    echo
                else
                    let NUM1=$IMPORT
                    let NUM1*=1
                    NUM2=`echo $NUM1`
                    ## comprobar que l'IMPORT sigui un número
                    if [ $NUM2 -eq 0 ]; then
                        echo
                        echo "$IMPORT no es un número"
                        echo
                    else
                        printf "%-10s\t %-25s\t %s\n" "$IMPORT" "$CONCEPTA" "$DATE" >> contabilitat.txt
                        echo
                        ## Mostrar el saldo
                        awk 'BEGIN { FS = "\t" };{ sum += $1; } END { print "Saldo: " sum; }' contabilitat.txt
                        echo
                    fi
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
            clear
            cat contabilitat.txt
            echo ;;
        "e")## Esborrar la última entrada contable
            echo
            clear
            echo
            read -n1 -p "Esborrar última entrada contable de l'arxiu contabilitat.txt? (s/n) " ESBORRAR
            echo
            while [ $ESBORRAR = s ]
            do
                sed '$d' contabilitat.txt > /tmp/contabilitat
                cp /tmp/contabilitat contabilitat.txt
                rm /tmp/contabilitat
                echo
                read -n 1 -p "Esborrar més linies? (s/n) " ESBORRAR
                clear
            done
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
                    if [ $REPETIR = s ]; then
                        echo
                    else
                        echo
 #                       read -n1 -p "repetirles? (s/n) " REPETIR
 #                       echo
                    fi
                    echo
                fi
            done
            echo ;;
        "i")## Donar de baixa un soci
            echo
            MES_BAIXES=s
            while [ $MES_BAIXES = s ]
            do
                clear
                echo
                awk 'BEGIN { FS = ";" };{ printf "%-5s %-10s %-10s %-10s %s\n", $1, $2, $3, $4, $13 }' socis.txt
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
                    sort -u -t ";" -k1n baixes.txt > /tmp/baixes
                    cp /tmp/baixes baixes.txt
                    rm /tmp/baixes
                    echo
                    # treure soci d l'arxiu socis.txt
                    sed -e "/^${NUM_BAIXA}/d" socis.txt > /tmp/socis
                    cp /tmp/socis socis.txt
                    rm /tmp/socis
                    echo
                    echo "fet"
                    echo
                fi
                echo
                read -n 1 -p "Entrar més baixes? (s/n) " MES_BAIXES
                echo
            done
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
        "k")## fer copies seguretat dels fixer .txt
            clear
            echo
            FILES=(`date +%d%m%Y%M%S`.tar.bz2)
            tar -c *.txt | bzip2 > $BACKUPS/$FILES
            echo "Realitzada copia de seguretat a ~/backups dels arxius: "
            echo
            ls *.txt
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
            clear
            TORNAR=s
            while [ $TORNAR = s ]
            do
                ls *.txt
                echo
                read -p "Quin arxiu vols veure?: " LLEGIR
                echo
                cat $LLEGIR
                echo
                read -n1 -p "Fer nova consulta? (s/n): " TORNAR
                clear
            done
            rm *.txt
            cd $DIR
            clear
            echo ;;
        "m")## Entrar quotas, veure pendents i socis al corrent de pagament
            echo
            clear
            read -n 1 -p "Entrar la quota d'un soci? (s/n): " ENTRAR
            echo
            while [ $ENTRAR = s ]
            do
                clear
                cat ${ANY}.txt
                echo
                read -p "Número de soci que ha fet el pagament?: " NUM
                echo
                awk '{print$1}' ${ANY}.txt > /tmp/num
                grep $NUM /tmp/num
                if [ $? -eq 0 ]; then
                    echo
                    sed -i "/^$NUM/ s|$| --> Pagat|" ${ANY}.txt
                    clear
                    echo
                    cat ${ANY}.txt
                    echo
                else
                    echo
                    echo "Soci inexisten o entrada incorrecte "
                    echo
                fi
                echo
                read -n 1 -p "Entrar un altre pagament? (s/n): " ENTRAR
                echo
            done
            clear
            echo
            read -n 1 -p "Llistar socis al corrent de pagament? (s/n): " CORRENT
            echo
            if [ $CORRENT = s ]; then
                echo
                cat ${ANY}.txt | grep "Pagat"
                echo
            fi
            echo
            read -n 1 -p "Llistar pendents? (s/n): " PENDENT
            echo
            if [ $PENDENT = s ]; then
                echo
                cat ${ANY}.txt | grep -v "Pagat"
                echo
            fi
            echo ;;
        "n")## Revisar el codi del gespip.sh
            echo
            nano ~/gespip/gespip.sh
            clear
            echo ;;
        "o")## Editar arxiu de contrasenyes de La Pipa Plena (privat)
            clear
            echo
            if [ -f privat.cpt ]; then
                ccrypt -c privat.cpt
            else
                echo
                echo "No hi ha arxius privats."
            fi
            echo ;;
        "p")## Editar arxius mestres (contabilitat.txt, socis.txt, baixes.txt...)
            echo
            clear
            array=($(ls *.txt))
            echo "Editar l'arxiu..."
            echo
            CON=0
            EDITAR=s
            while [ $EDITAR = s ]
            do
                for i in `ls *.txt`
                do
                    echo "[$CON] $i"
                    ((CON+=1))
                done
                echo
                read -n 1 ARX
                echo
                if [ -z ${array[ARX]} ]; then
                    clear
                    echo
                    echo "L'arxiu no existeix. Pulsar INTRO per continuar"
                    read
                else
                    nano ${array[ARX]}
                fi
                clear
                echo
                read -n 1 -p "Editar un altre arxiu?(s/n): " EDITAR
                CON=0
                clear
            done
            echo ;;
        "r")## Enviar correu al tots els socis
            echo
            if [ -f missatges.txt ]; then
                echo
            else
                touch missatges.txt
            fi
            DATE=`date +"%d-%m-%Y"`
            echo
            clear
            #awk 'BEGIN { FS = ";" };{ print$13 }' socis.txt > correus.txt
            read -p "Assumpte del correu: " ASSUMPTE
            echo
            read -p "Text del missatge: " TEXT
            echo
            touch /tmp/missatge
            echo $TEXT | sed G > /tmp/missatge
            read -n 1 -p "Vols entrar més paragrafs? (s/n): " CONTINUAR
            echo
            clear
            while [ $CONTINUAR = s ]
            do
                echo
                read -p "Continua escribint... " TEXT
                echo $TEXT | sed G >> /tmp/missatge
                echo
                read -n 1 -p "Vols entrar un altre paràgrafs? (s/n):  " CONTINUAR
                echo
                clear
            done
            echo
            cat /tmp/missatge
            echo
            ## Editar amb nano:
            read -n 1 -p "Editar el missatge per modificar-lo? (s/n): " MODIFICAR
            echo
            if [ $MODIFICAR = s ];then
                echo
                nano /tmp/missatge
                echo
            else
                echo
            fi
            read -n 1 -p "Confirma l'enviament del missatge (s/n): " CONFIRMAR
            echo
            if [ $CONFIRMAR = s ]; then
                i=0
                while read line
                do i=$(($i+1));
                   mail -s "$ASSUMPTE" $line < /tmp/missatge
                done < correus.txt
                echo
                echo "Enviats $i correus"
                ## Grabar els missatges a l'arxiu missatges.txt
                echo "*****************************************" >> missatges.txt
                echo -e "${DATE}\t${ASSUMPTE}\n" >> missatges.txt
                cat /tmp/missatge >> missatges.txt
                echo
            else
                echo
                echo "Abortat enviament... "
                echo
            fi
            rm /tmp/missatge
            echo ;;
        "s")## Revisar historial de missatges
            echo
            clear
            if [ -f missatges.txt ]; then
                echo
                cat missatges.txt
                echo
            else
                echo "No hi ha historial de missatges..."
                echo
            fi
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
