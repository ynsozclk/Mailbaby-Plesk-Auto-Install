#!/bin/bash

#-------VARIABLES-------
RED='\033[31m' # Kırmızı
BLUE='\033[34m' # Mavi
YELLOW='\033[33m' # Sarı
GREEN='\033[32m' # Yeşil
NC='\033[0m' # Renksiz

#--------ANA MENU--------
header() {
	clear
	echo -e "$GREEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$NC"	
	echo -e "$NC->" "$YELLOW""Yunus Özçelik MailBaby Plesk Auto İnstall <-$NC"
	echo -e "$GREEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
	}	
ana_menu() {
	echo -e "$YELLOW 1) -$NC English"
	echo -e "$YELLOW 2) -$NC Türkçe"
	echo -e "$YELLOW 3) -$NC Exit\n"
}
ana_siklar(){
	local choice
	read -p "[ 1 - 3] Choose between: " choice
	case $choice in
		1) en_menu ;;
		2) tr_menu ;;
		3) exit 0;;
		*) echo -e "${RED}Incorrect entry..." && sleep 2
	esac
}
#--------ANA MENU--------

#--------TR ANA MENU--------
tr_menu() {

tr_anamenu() {
	echo -e "$YELLOW 1) -$NC Kurulumu Başlat"
	echo -e "$YELLOW 2) -$NC Çıkış\n"
}

tr_siklar(){
	local choice
	read -p "[ 1 - 2] Arası seçim yapın : " choice
	case $choice in
		1) proccess_start_tr ;;
		2) exit 0;;
		*) echo -e "${RED}Hatalı Giriş..." && sleep 2
	esac
	}
	
	while true
	do
		header
		tr_anamenu
		tr_siklar
	done
}
#--------TR ANA MENU--------

#--------EN ANA MENU--------
en_menu() {

en_anamenu() {
	echo -e "$YELLOW 1) -$NC Install"
	echo -e "$YELLOW 2) -$NC Exit\n"
}

en_siklar(){
	local choice
	read -p "[ 1 - 2] Choose between: " choice
	case $choice in
		1) proccess_start_en ;;
		2) exit 0;;
		*) echo -e "${RED}Incorrect entry..." && sleep 2
	esac
	}
	
	while true
	do
		header
		en_anamenu
		en_siklar
	done
}
#--------EN ANA MENU--------

#--------EN ANA FONKSIYON--------
function proccess_start_en(){
# Kullanıcıdan username ve password'u al
# Kullanıcıdan username ve password'u al
read -p "Enter MailBaby connection username: " username
read -sp "Enter MailBaby connection password: " password
echo

# Dosyaya yazılacak içerik
content="relay.mailbaby.net $username:$password"

# Dosyayı oluştur ve içeriği yaz
echo $content | sudo tee /etc/postfix/password >/dev/null

# Dosyayı kaydet
sudo postmap /etc/postfix/password

echo "/etc/postfix/password $content information added."

sudo chown root:root /etc/postfix/password
sudo chmod 0600 /etc/postfix/password
sudo postmap hash:/etc/postfix/password

content2="/^Received: (.*Authenticated sender:)([^)]*)(.*)/i PREPEND X-Sender-id: $2"

echo $content2 | sudo tee /etc/postfix/header_custom >/dev/null


content3="relayhost = relay.mailbaby.net
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/password
smtp_sasl_security_options = noanonymous
smtpd_sasl_authenticated_header = yes
smtp_tls_security_level = encrypt
smtp_header_checks = regexp:/etc/postfix/header_custom"

echo "$content3" | sudo tee -a /etc/postfix/main.cf >/dev/null

sudo service postfix restart

echo -e "$YELLOW~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$NC"	
	echo -e "$NC->" "$GREEN""Mailbaby has been successfully installed and is usable. <-$NC"
	echo -e "$YELLOW~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
exit 0

}
#--------EN ANA FONKSIYON--------


#--------TR ANA FONKSIYON--------
function proccess_start_tr(){
# Kullanıcıdan username ve password'u al
read -p "MailBaby bağlantı kullanıcı adını girin: " username
read -sp "MailBaby bağlantı şifresini girin: " password
echo

# Dosyaya yazılacak içerik
content="relay.mailbaby.net $username:$password"

# Dosyayı oluştur ve içeriği yaz
echo $content | sudo tee /etc/postfix/password >/dev/null

# Dosyayı kaydet
sudo postmap /etc/postfix/password

echo "İşlem tamamlandı. /etc/postfix/password dosyasına $content eklendi."

sudo chown root:root /etc/postfix/password
sudo chmod 0600 /etc/postfix/password
sudo postmap hash:/etc/postfix/password

content2="/^Received: (.*Authenticated sender:)([^)]*)(.*)/i PREPEND X-Sender-id: $2"

echo $content2 | sudo tee /etc/postfix/header_custom >/dev/null


content3="relayhost = relay.mailbaby.net
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/password
smtp_sasl_security_options = noanonymous
smtpd_sasl_authenticated_header = yes
smtp_tls_security_level = encrypt
smtp_header_checks = regexp:/etc/postfix/header_custom"

echo "$content3" | sudo tee -a /etc/postfix/main.cf >/dev/null

sudo service postfix restart



echo -e "$YELLOW~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$NC"	
	echo -e "$NC->" "$GREEN""Mailbaby başarılı bir şekilde kuruldu <-$NC"
	echo -e "$YELLOW~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
exit 0
}
#--------TR ANA FONKSIYON--------

	while true
	do
		header
		ana_menu
		ana_siklar
	done