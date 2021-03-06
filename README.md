# leases-changer
Inicialmente criado para gerar um script com uma lista de leases DHCP a ser
aplicada no RouterOS Mikrotik.

### Testado em
BASH versão 5.0.3

### Forma de usar

Para a correta utilização do programa é necessário que o conteúdo do arquivo
de origem tenha a seguinte estrutura:

```
58:10:8c:00:00:00 192.168.0.10 DESCRICAO_1 dhcp-server
58:10:8c:00:00:00 192.168.0.11 DESCRICAO_2 dhcp-server
00:00:00:00:00:00 192.168.0.12 DESCRICAO_3 dhcp-server
11:11:11:11:11:11 192.168.0.13 DESCRICAO_4 dhcp-server
22:22:22:22:22:22 192.168.0.14 DESCRICAO_5 dhcp-server
```
- Coluna 1 = Endereço MAC
- Coluna 2 = Endereço IP
- Coluna 3 = Descrição do dispositivo
- Coluna 4 = Nome do servidor dhcp
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

### Histórico

v1.0 16/07/2021, Emanuel Dramos:
- Criação da estrutura inicial do script

### Autor e mantenedor
Emanuel Dramos
- **Github:** https://github.com/dramos777
