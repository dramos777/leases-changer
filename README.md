# leases-changer
Organizador de Leases DHCP para aplicação em RouterOS Mikrotik
 Github:     https://github.com/dramos777/leases-changer
 Autor:      Emanuel Dramos
 Manutenção: Dramos

    Inicialmente criado para gerar um script com uma lista de leases DHCP a ser
aplicada no RouterOS Mikrotik.

### Testado em:
    BASH versão 5.0.3

### Forma de usar

    Para a correta utilização do programa é necessário que o conteúdo do arquivo
de origem tenha a seguinte estrutura:

```
58:10:8c:00:00:00 192.168.0.10 DESCRICAO_1 dhcp-adm
58:10:8c:00:00:00 192.168.0.11 SETOR_NOME_1_NOME_2 dhcp-adm
00:00:00:00:00:00#192.168.0.12#DISPOSITIVO1
11:11:11:11:11:11#192.168.0.13#DISPOSITIVO2
22:22:22:22:22:22#192.168.0.14#DISPOSITIVO3
```
### Exemplos

```
cd ~/
git clone https://github.com/dramos777/leases-change.git
cd leases-change
./ldh.sh -c ~/arquivo-origem.txt
```
    Neste exemplo o script exibirá o resultado das alterações na tela.
```
./ldh.sh -c ~/arquivo-origem.txt -o -T arquivo-destino.txt
```
    Neste segundo exemplo o script irá gerar o arquivo arquivo-destino.txt com o
campo MAC e DESCRIÇÃO em Caixa Alta no diretório corrente.

### Histórico:

    v1.0 16/07/2021, Emanuel Dramos:
       - Criação da estrutura inicial do script
