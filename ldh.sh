#!/usr/bin/env bash
#
# ldh.sh - Organizador de Leases DHCP para aplicação em RouterOS Mikrotik
#
# Github:     https://github.com/dramos777/
# Autor:      Emanuel Dramos
# Manutenção: Dramos
#
# ------------------------------------------------------------------------ #
#  Inicialmente criado para gerar um script com uma lista de leases DHCP
# a ser aplicada no RouterOS Mikrotik.
#
#  Exemplos:
#      $ ./nomeDoScript.sh -d 1
#      Neste exemplo o script será executado no modo debug nível 1.
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 14/07/2021, Emanuel Dramos:
#       -
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 4.4.19
# ------------------------------------------------------------------------ #
# Agradecimentos:
#
# Joãozinho - Encontrou um bug na parte de login.
# Mariazinha - Enviou uma sugestão de adicionar o -h.
# ------------------------------------------------------------------------ #
# ------------------------------- VARIÁVEIS ----------------------------------------- #
# LDH_FILEOUT=0
# LDH_SORT=0
# LDH_TR=0
#LDH_CH=0

ALERT_ARQ=$(echo "
    ALERTA! O script não pôde ser executado. Possíveis causas:

        1 - Opção selecionada é inválida
        2 - Argumento inválido
        3 - Arquivo de destino existente.

    Para ajuda utlize o comando com a opção -h
    " && exit 1)

LDH_FILEIN=0

VERSION="v1.0"

LDH_CMD="/ip dhcp-server lease add address=ipaddress comment=description mac-address=macaddress server=dhserver"

LDH_HELP="

##################################################################

  $(basename $0) - [OPÇÕES]

    -c Muda o leases dhcp do arquivo de origem e imprime na tela
    -h Exibe este menu de ajuda
    -o Define onde o arquivo com as alterações será salvo
    -s Utilizado com a opção -o para organizar o arquivo de a-z com base na descrição
    -S Utilizado com a opção -o para organizar o arquivo do menor para o maior IP
    -t Utilizado com a opção -o para traduzir MAC e Descrição de [A-Z] para [a-z]
    -T Utilizado com a opção -o para traduzir MAC e Descrição de [a-z] para [A-Z]
    -v Exibe a versão

    Ex1: ldh.sh -c arquivo_origem.txt
    Ex2: ldh.sh -c arquivo_origem.txt -o -S arquivo-destino.txt

##################################################################
"
# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #


case "$1" in
#########ldh -c arquivo-origem
  -c) if [ -f "$2" ] && [ -z "$3" ]; then
        LDH_FILEIN=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')
        echo $LDH_FILEIN
        for d in $LDH_FILEIN
          do
            echo "$LDH_CMD" | \
            sed "s/ipaddress/$d/g; s/description/$d/g; s/macaddress/$d/g; s/dhserver/$d/g" | \
            sed "s/=/@/g" | sed "s/@/=/g" | \
            awk -F "=" '{print $1 "=" $3 " " $5 "=" $8 " " $9 "=" $10}' | \
            awk -F " " '{print $1 " " $2 " " $3 " " $4 " "$5 " " $7 " " $9}'
          done
          exit 0

      fi

       case "$3" in
# #########ldh -c arquivo-origem -o arquivo-destino (se arquivo-destino existir cancela)
         -o)
# #########ldh -c arquivo-origem -o arquivo-destino
             if [ -n "$4" ] && [ ! -f "$4" ] && [ -z $5 ]; then
#
               LDH_FILEIN=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')
#
               for d in $LDH_FILEIN
                 do
                   echo "$LDH_CMD" | \
                   sed "s/ipaddress/$d/g; s/description/$d/g; s/macaddress/$d/g; s/dhserver/$d/g" | \
                   sed "s/=/@/g" | sed "s/@/=/g" | \
                   awk -F "=" '{print $1 "=" $3 " " $5 "=" $8 " " $9 "=" $10}' | \
                   awk -F " " '{print $1 " " $2 " " $3 " " $4 " "$5 " " $7 " " $9}' \
                   >> $4
                 done
                   exit 0

             fi

             case "$4" in
 #########ldh -c arquivo-origem -o -s arquivo-destino (se arquivo-destino existir cancela)
                -s) if [ -f "$5" ]; then
                      echo "$ALERT_ARQ" && exit 0
                    fi
 #########ldh -c arquivo-origem -o -s arquivo-destino
                   if [ -n "$5" ] && [ ! -f "$5" ]; then

                     LDH_FILEIN=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')

                     for d in $LDH_FILEIN
                       do
                         echo "$LDH_CMD" | \
                         sed "s/ipaddress/$d/g; s/description/$d/g; s/macaddress/$d/g; s/dhserver/$d/g" | \
                         sed "s/=/@/g" | sed "s/@/=/g" | \
                         awk -F "=" '{print $1 "=" $3 " " $5 "=" $8 " " $9 "=" $10}' | \
                         awk -F " " '{print $1 " " $2 " " $3 " " $4 " "$5 " " $7 " " $9}' \
                         >> $5.tmp
                         sort -t "=" -k3 "$5.tmp" > $5
                       done
                       rm "$5.tmp"
                       exit 0

                   fi ;;

  #########ldh -c arquivo-origem -o -S arquivo-destino (se arquivo-destino existir cancela)
                -S) if [ -f "$5" ]; then
                      echo "$ALERT_ARQ" && exit 0
                    fi
 #########ldh -c arquivo-origem -o -S arquivo-destino
                     if [ -n "$5" ] && [ ! -f "$5" ]; then
                     LDH_FILEIN=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')

                     for d in $LDH_FILEIN
                       do
                         echo "$LDH_CMD" | \
                         sed "s/ipaddress/$d/g; s/description/$d/g; s/macaddress/$d/g; s/dhserver/$d/g" | \
                         sed "s/=/@/g" | sed "s/@/=/g" | \
                         awk -F "=" '{print $1 "=" $3 " " $5 "=" $8 " " $9 "=" $10}' | \
                         awk -F " " '{print $1 " " $2 " " $3 " " $4 " "$5 " " $7 " " $9}' \
                         >> $5.tmp
                         sort -n -t "=" -k2 "$5.tmp" > $5
                       done
                       rm "$5.tmp"
                       exit 0

               fi ;;

 #########ldh -c arquivo-origem -o -t arquivo-destino (se arquivo-destino existir cancela)
                -t) if [ -f "$5" ]; then
                      echo "$ALERT_ARQ" && exit 0
                    fi
 #########ldh -c arquivo-origem -o -t arquivo-destino
                   if [ -n "$5" ] && [ ! -f "$5" ]; then
                     LDH_FILEIN=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')

                     for d in $a $(echo "$LDH_FILEIN"  | tr [A-Z] [a-z])
                       do
                         echo "$LDH_CMD" | \
                         sed "s/ipaddress/$d/g; s/description/$d/g; s/macaddress/$d/g; s/dhserver/$d/g" | \
                         sed "s/=/@/g" | sed "s/@/=/g" | \
                         awk -F "=" '{print $1 "=" $3 " " $5 "=" $8 " " $9 "=" $10}' | \
                         awk -F " " '{print $1 " " $2 " " $3 " " $4 " "$5 " " $7 " " $9}' \
                         >> $5
                       done
                         exit 0
                   fi ;;

 #########ldh -c arquivo-origem -o -T arquivo-destino (se arquivo-destino existir cancela)
                -T) if [ -f "$5" ]; then
                      echo "$ALERT_ARQ" && exit 0
                    fi
 #########ldh -c arquivo-origem -o -T arquivo-destino
                   if [ -n "$5" ] && [ ! -f "$5" ]; then
                     LDH_FILEIN=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')

                     for d in $(echo "$LDH_FILEIN"  | tr [a-z] [A-Z])
                       do
                         echo "$LDH_CMD" | \
                         sed "s/ipaddress/$d/g; s/description/$d/g; s/macaddress/$d/g; s/dhserver/$d/g" | \
                         sed "s/=/@/g" | sed "s/@/=/g" | \
                         awk -F "=" '{print $1 "=" $3 " " $5 "=" $8 " " $9 "=" $10}' | \
                         awk -F " " '{print $1 " " $2 " " $3 " " $4 " "$5 " " $7 " " $9}' \
                         >> $5
                       done
                       exit 0
                   fi ;;

             esac

             if [ -n "$4" ] && [ -f "$4" ]; then
                   echo "$ALERT_ARQ" && exit 0
             fi ;;

         *) echo "$ALERT_ARQ" && exit 0

       esac ;;

 #########ldh -h
   -h) echo "$LDH_HELP" && exit 0 ;;

 #########ldh -v
   -v) echo "$VERSION" && exit 0 ;;

esac

 #########Nenhuma opção válida
echo "$ALERT_ARQ"
