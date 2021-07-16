#!/usr/bin/env bash
#
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 16/07/2021, Emanuel Dramos:
#       - Criação da estrutura inicial do script
# ------------------------------------------------------------------------ #
# Testado em:
#   BASH versão 5.0.3
# ------------------------------------------------------------------------ #
#
# ------------------------------- VARIÁVEIS ----------------------------------------- #
# LDH_CH=0
# #LDH_FILEIN=0
# LDH_FILEOUT=0
# LDH_SORT=0
# LDH_TR=0
VERSION="v1.0"
LDH_CMD="/ip dhcp-server lease add address=ipaddress comment=description mac-address=macaddress server=dhserver"
LDH_HELP="

##################################################################

  $(basename $0) - [OPÇÕES]

    -c Muda o leases dhcp do arquivo de origem e imprime na tela
    -h Exibe este menu de ajuda
    -o Define onde o arquivo com as alterações será salvo
    -s Organiza o arquivo de a-z com base na descrição
    -S Organiza o arquivo com base no IP
    -t Traduz MAC e Descrição de [A-Z] para [a-z]
    -T Traduz MAC e Descrição de [a-z] para [A-Z]
    -v Exibe a versão

##################################################################
"
# ------------------------------- EXECUÇÃO ----------------------------------------- #

#########ldh -c arquivo-origem
if [ "$1" = "-c" ] && [ -f "$2" ] && [ -z "$3" ]; then

   a=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')

  for d in $a
    do
      echo "$LDH_CMD" | \
      sed "s/ipaddress/$d/g; s/description/$d/g; s/macaddress/$d/g; s/dhserver/$d/g" | \
      sed "s/=/@/g" | sed "s/@/=/g" | \
      awk -F "=" '{print $1 "=" $3 " " $5 "=" $8 " " $9 "=" $10}' | \
      awk -F " " '{print $1 " " $2 " " $3 " " $4 " "$5 " " $7 " " $9}' \

    done
    exit 0
fi

#########ldh -h
if [ "$1" = -h ]; then
  echo "$LDH_HELP" && exit 0
fi

#########ldh -c arquivo-origem -o -T arquivo-destino (se arquivo-destino existir cancela)
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ "$4" = "-T" ] && \
   [ -n "$5" ] && [ -f "$5" ]; then
  echo "ALERTA - Destino inválido. Já existe um arquivo "$5"! Ecolha um nome diferente." && exit 0
fi

#########ldh -c arquivo-origem -o -T arquivo-destino
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ "$4" = "-T" ] && [ -n "$5" ] && \
   [ ! -f "$5" ]; then
  a=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}' | tr [a-z] [A-Z])

 for d in $a
   do
     echo "$LDH_CMD" | \
     sed "s/ipaddress/$d/g; s/description/$d/g; s/macaddress/$d/g; s/dhserver/$d/g" | \
     sed "s/=/@/g" | sed "s/@/=/g" | \
     awk -F "=" '{print $1 "=" $3 " " $5 "=" $8 " " $9 "=" $10}' | \
     awk -F " " '{print $1 " " $2 " " $3 " " $4 " "$5 " " $7 " " $9}' \
     >> $5
   done
    exit 0
fi

#########ldh -c arquivo-origem -o -t arquivo-destino (se arquivo-destino existir cancela)
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ "$4" = "-t" ] && \
   [ -n "$5" ] && [ -f "$5" ]; then
  echo "ALERTA - Destino inválido. Já existe um arquivo "$5"! Ecolha um nome diferente." && exit 0
fi

#########ldh -c arquivo-origem -o -t arquivo-destino
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ "$4" = "-t" ] && [ -n "$5" ] && \
   [ ! -f "$5" ]; then
  a=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}' | tr [A-Z] [a-z])

 for d in $a
   do
     echo "$LDH_CMD" | \
     sed "s/ipaddress/$d/g; s/description/$d/g; s/macaddress/$d/g; s/dhserver/$d/g" | \
     sed "s/=/@/g" | sed "s/@/=/g" | \
     awk -F "=" '{print $1 "=" $3 " " $5 "=" $8 " " $9 "=" $10}' | \
     awk -F " " '{print $1 " " $2 " " $3 " " $4 " "$5 " " $7 " " $9}' \
     >> $5
   done
    exit 0
fi

#########ldh -c arquivo-origem -o -S arquivo-destino (se arquivo-destino existir cancela)
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ "$4" = "-S" ] && \
   [ -f "$5" ]; then
  echo "ALERTA - Destino inválido. Já existe um arquivo "$5"! Ecolha um nome diferente." && exit 0
fi

#########ldh -c arquivo-origem -o -S arquivo-destino
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ "$4" = "-S" ] && \
   [ -n "$5" ] && [ ! -f "$5" ]; then
  a=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')

 for d in $a
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
fi

#########ldh -c arquivo-origem -o -s arquivo-destino (se arquivo-destino existir cancela)
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ "$4" = "-s" ] && \
   [ -f "$5" ]; then
  echo "ALERTA - Destino inválido. Já existe um arquivo "$5"! Ecolha um nome diferente." && exit 0
fi

#########ldh -c arquivo-origem -o -s arquivo-destino
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ "$4" = "-s" ] && \
   [ -n "$5" ] && [ ! -f "$5" ]; then
  a=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')

 for d in $a
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
fi

#########ldh -c arquivo-origem -o arquivo-destino (se arquivo-destino existir cancela)
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ -n "$4" ] && [ -f "$4" ]; then
  echo "ALERTA - Destino inválido. Já existe um arquivo "$4"! Ecolha um nome diferente." && exit 0
fi

#########ldh -c arquivo-origem -o arquivo-destino
if [ "$1" = "-c" ] && [ -f "$2" ] && [ "$3" = "-o" ] && [ -n "$4" ] && \
   [ ! -f "$4" ]; then
  a=$(sed -n '1,$p' "$2" | awk -F " " '{print $1 "@" $2 "@" $3 "@" $4}')

 for d in $a
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

#########ldh -v
if [ "$1" = -v ]; then
  echo "$VERSION" && exit 0
fi

#########Nenhuma opção válida
echo "
################################
Versão: $VERSION
Utilize a opção -h para ajuda.
################################
"
