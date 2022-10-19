#!/usr/bin/env bash
#
# ldh.sh - Organizador de Leases DHCP para aplicação em RouterOS Mikrotik
#
# Github:     https://github.com/dramos777/
# Autor:      Emanuel Dramos
# Manutenção: Dramos
#
#  Exemplos:
#      $ ./ldh.sh -c arquivo.txt -o novo-arquivo.txt
#      Neste exemplo o script irá gerar o arquivo novo-arquivo.txt com as alterações.
#
# Histórico:
#
#   v1.0 14/07/2021, Emanuel Dramos
#   v2.0 18/10/2022, Emanuel Dramos
#
# Testado em:
#   bash 4.4.19
#   bash 5.1.4
# ------------------------------- VARIÁVEIS ----------------------------------------- #
IP="/ip dhcp-server lease add address="
COMMENT="comment="
MAC="mac-address="
SERVER="server="

ARQ_FILE=""
CREATE=0
MENUSC=0
MENUSS=0
MENUSSS=0
MENUST=0
MENUSTT=0
VERSION="v2.0"
LDH_HELP="
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
"
ALERT_ARQ=$(echo "
    ALERTA! O script não pôde ser executado. 
    Para ajuda utlize a opção -h
    " && exit 1)
# ------------------------------- TESTES ----------------------------------------- #
[ ! $1 ] && echo "$LDH_HELP"
[ $1 = "-v" ] || [ $1 = "-h" ] && [ -n $2 ] && echo "$LDH_HELP" && exit 1
# ------------------------------- FUNÇÕES ----------------------------------------- #
Changer1 () {

file1="$1"

while IFS= read -r linha; do
  echo $(echo -n $IP && echo -n $linha | cut -d " " -f2) \
       $(echo -n $COMMENT && echo -n $linha | cut -d " " -f3) \
       $(echo -n $MAC && echo -n $linha | cut -d " " -f1) \
       $(echo -n $SERVER && echo -n $linha | cut -d " " -f4)
done < "$file1"
}

Changer2 () {

file1="$1"

while IFS= read -r linha; do
  echo $(echo -n $IP && echo -n $linha | cut -d " " -f2) \
       $(echo -n $COMMENT && echo -n $(echo -n $linha | cut -d " " -f3 | tr [a-z] [A-Z])) \
       $(echo -n $MAC && echo $(echo -n $linha | cut -d " " -f1 | tr [a-z] [A-Z])) \
       $(echo -n $SERVER && echo -n $linha | cut -d " " -f4)
done < "$file1"
}

Changer3 () {

file1="$1"

while IFS= read -r linha; do
  echo $(echo -n $IP && echo -n $linha | cut -d " " -f2) \
       $(echo -n $COMMENT && echo -n $(echo -n $linha | cut -d " " -f3 | tr [A-Z] [a-z])) \
       $(echo -n $MAC && echo $(echo -n $linha | cut -d " " -f1 | tr [A-Z] [a-z])) \
       $(echo -n $SERVER && echo -n $linha | cut -d " " -f4)
done < "$file1"
}
# ------------------------------- EXECUÇÃO ----------------------------------------- #
while [ -n "$1" ]; do
    case $1 in
        -c) MENUSC=1 && [ -f $2 ] && ARQ_FILE=$(echo "$2") ;;
        -h) echo "$LDH_HELP" && exit 0 ;;
        -o) CREATE=1 && [ ! -f $2 ] && DST=$(echo "$2") ;;
        -s) MENUSS=1 && [ -f $2 ] && ARQ_FILE=$(echo "$2") ;;
        -S) MENUSSS=1 && [ -f $2 ] && ARQ_FILE=$(echo "$2") ;;
        -t) MENUST=1 && [ -f $2 ] && ARQ_FILE=$(echo "$2") ;;
        -T) MENUSTT=1 && [ -f $2 ] && ARQ_FILE=$(echo "$2") ;;
        -v) echo "$VERSION" && exit 0 ;;
    esac
    shift
done

[ $MENUSC -eq 1 ] && CHANGER="$(Changer1 $(echo "$ARQ_FILE"))"
[ $MENUST -eq 1 ] && CHANGER="$(Changer3 $(echo "$ARQ_FILE"))"
[ $MENUSTT -eq 1 ] && CHANGER="$(Changer2 $(echo "$ARQ_FILE"))"
[ $MENUSS -eq 1 ] && CHANGER="$(echo "$CHANGER" | sort -t "=" -k3)"
[ $MENUSSS -eq 1 ] && CHANGER="$(echo "$CHANGER" | sort -n -t "=" -k2)"
[ $CREATE -eq 1 ] && echo "$CHANGER" > $DST
echo "$CHANGER"
