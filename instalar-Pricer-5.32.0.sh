#!/bin/bash
# Agnaldo Fernandes 26/05/2022
# versão 1.0
clear
echo
Menu(){
   clear
   echo;echo;echo
   echo "       -----------------------------------------------------------------"
   echo "\033[40;1m	             Bem vindo a instalação do Pricer Server \033[m"
   echo "           		        Versão 5.32 Linux"
   echo "       -----------------------------------------------------------------"
   echo
   echo "\033[33;1m     Coloque o instalador:\033[32;1m installer-R5.jar \033[33;1mna mesma pasta deste arquivo. \033[m"
   echo
   echo
   echo
   echo
   echo "\033[40;1m			[ 1 ] Instalar o Pricer \033[m"
   echo "			[ 2 ] Desinstalar o Mysql"
   echo "			[ 3 ] Status do Serviço Pricer"
   echo "			[ 4 ] Status Mysql"
   echo "                        [ 5 ] Desinstalar o Pricer"
   echo
   echo "			[ 6 ] SAIR."
   echo
   echo
   echo
   echo
   echo -n "\033[33;1m 		Escolha uma função:  \033[m"
	read resp
	case $resp in
		1) InstalaPricer ;;
		2) DelMysql ;;
		3) StPricer ;;
		4) StMysql ;;
		5) sudo /usr/local/Pricer/ ;;
                6) exit ;;
		*) Menu ;;
	esac
}

StMysql(){
sudo service mysql status;
echo -n "\033[33;1m          Digite qq tecla para continuar...  \033[m"
read resp
Menu
}

StPricer(){
clear

echo;echo;echo
   echo "       -----------------------------------------------------------------"
   echo "\033[31;1m			Status do Pricer Server \033[m"
   echo "			Iniciar,Parar e Reiniciar"
   echo "       -----------------------------------------------------------------"
echo;echo;echo
   echo "	               [ 1 ] Ver Status do Serviço Pricer"
   echo "	               [ 2 ] Parar Serviço Pricer"
   echo "	               [ 3 ] Iniciar Serviço Pricer"
   echo "	               [ 4 ] Reiniciar Serviço Pricer"
   echo
   echo "	               [ 5 ] Voltar."

   echo;echo;echo
   echo -n "\033[33;1m 	         Escolha uma função:  \033[m"

read resp
	case $resp in
	1) sudo service PricerServer status ;;
	2) sudo service PricerServer stop ;;
	3) sudo service PricerServer start ;;
	4) sudo service PricerServer restart ;;
	5) Menu ;;
	*) StPricer ;;
	esac
echo
echo
echo;echo;echo
echo -n "\033[33;1m          Digite qq tecla para continuar...  \033[m"
read resp
StPricer
}

DelMysql(){
clear
echo;echo
echo "\033[33;1m  Deletando o MYSQL completamente\033[m"
echo
echo
#MySql : Desinstalar o MySql completamente de um servidor Linux (Ubuntu)

# Primeiro passo é verificar se está instalado o programa com o seguinte comando:

# dpkg -l mysql-server
echo

echo "\033[33;1m 	Vamos parar o serviço do MySQL.\033[m"

sudo /etc/init.d/mysql stop

echo "\033[33;1m Agora vamos remover mais um pacote do MySQL.\033[m"
echo
echo
sudo apt-get remove --purge mysql-common

# Por ultimo apague a pasta mysql que fica localizada em /var/lib/ com o comando abaixo e pressione enter:

sudo rm -rf /var/lib/mysql

# Depois de fazer todos os passos acima digite um comando de cada vez no terminal:

    sudo apt-get autoremove --purge
    sudo apt-get autoclean
    sudo apt-get clean


echo "\033[33;1m Verificando novamente se o MySQL está instalado.\033[m"
echo;echo;echo
dpkg -l mysql-server
echo
echo
echo
echo
echo "\033[33;1m  		Mysql desinstalado com sucesso! \033[m"
echo
echo "\033[33;1m 		É necessário a reinicialização do Linux \033[m"
echo
echo
echo
echo -n "\033[33;1m          Digite qq tecla para continuar...  \033[m"
read resp

Menu
}

InstalaPricer()
{
echo "\033[33;1m 1. Atualizar as correções e sistema operacional\033[m"
        sudo apt update && sudo apt upgrade

echo "\033[33;1m 2. Criar diretórios /mysql e/mysql.conf.d\033[m"
        sudo  mkdir /etc/mysql
        sudo mkdir /etc/mysql/mysql.conf.d

echo
echo "\033[33;1m 3. Adicionar  “lower_case_table_names = 1” na sessão [mysqld]\033[1"

        dadosMysqld="[mysqld]\n lower_case_table_names = 1 \n"
        echo $dadosMysqld > mysqld.cnf
        echo
        echo
        sudo cp mysqld.cnf /etc/mysql/mysql.conf.d/
	sudo rm -rf mysqld.cnf
echo "\033[33;1m 4. Instalar o mysql com o comando:\033[m"
        sudo apt install mysql-server
echo "Durante o processo de instalação o mysql tentará sobrepor o arquivo mysqld.cnf,   digite N ou O para manter o arquivo anterior."


echo "\033[33;1m 5. Criar o usuário Pricer no MySQL e definir os privilégios:\033[m"
echo "DROP USER `pricer`;" >> uPricer.sql
echo "CREATE USER 'pricer'@'%' IDENTIFIED BY 'pricer';" >> uPricer.sql
echo "GRANT ALL PRIVILEGES ON *.* TO 'pricer'@'%';" >> uPricer.sql
echo "SHOW GRANTS FOR 'pricer'@'%';" >> uPricer.sql
echo "FLUSH PRIVILEGES;" >> uPricer.sql
echo "quit" >> uPricer.sql

        sudo mysql -u root < uPricer.sql
	sudo rm -rf uPricer.sql


echo "\033[33;1m 6. Reiniciar o serviço do MySQL com o comando:\033[m"
        sudo systemctl restart mysql
echo "\033[33;1m 7. Instalar o java com o commando:\033[m"
        sudo apt install openjdk-11-jdk
echo "\033[33;1m 8. Alterar o PATH no arquivo /etc/environment:\033[m"

echo "\033[33;1m 9. Inserindo o Path do java em /etc/enviroment:\033[m"

	jhome='JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64" \n PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"'

echo  ${jhome} >> /etc/environment
echo 
echo "\033[33;1m 10. Instalar as fontes para os relatórios com o comando\033[m"
        sudo apt install ttf-mscorefonts-installer
        sudo apt-get install libcanberra-gtk-module

echo "\033[33;1m 11. Instalar o rng-tools commysq o comando:\033[m"
        sudo apt install rng-tools

echo "\033[33;1m 12. Instalar o software Pricer com o comando:\033[m"
        sudo java -jar installer-R5.jar

}
Menu

