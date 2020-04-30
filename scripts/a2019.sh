#!/usr/bin/env bash

cd ~opc

# Normal box urls expire after use
#wget -O AutomationAnywhereEnterprise_A2019_el7.bin 'https://public.boxcloud.com/d/1/......'
# page doesn't redirect
# curl https://automationanywhere-support.app.box.com/s/9tx948vtyi9qsxn2cr5k1en5ntgvd5ed/file/643956731765

# add sensible retry flags?
wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/Fl_8n_q4zz_477PMI31mol6CquUCyujMFL6dhHDRETU/n/idmmwyjidb5r/b/installers/o/AutomationAnywhereEnterprise_A2019_el7.bin
chmod 755 AutomationAnywhereEnterprise_A2019_el7.bin

##############
# SQL Server developer test
##############
curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2019.repo
yum install -y mssql-server

ACCEPT_EULA='Y' MSSQL_PID='Developer' MSSQL_SA_PASSWORD='FooBar1234!!' MSSQL_TCP_PORT=1433 /opt/mssql/bin/mssql-conf setup

systemctl status mssql-server

systemctl stop firewalld
echo "systemctl is-active firewalld"
systemctl is-active firewalld
echo "Open port 1433"
firewall-offline-cmd --zone=public --add-port=1433/tcp
echo "Enable and start firewalld"
systemctl enable firewalld
systemctl start firewalld


curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/7/prod.repo
ACCEPT_EULA='Y' yum install -y mssql-tools unixODBC-devel

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~opc/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~opc/.bashrc
##############


# force a silent install
yum install -y expect

cat << EOF > a2019_silent_install
#!/usr/bin/expect -f

set timeout -1

spawn ~opc/AutomationAnywhereEnterprise_A2019_el7.bin

# storage warning
expect "   DEFAULT:"
send "\r"

# intro
expect "PRESS <ENTER> TO CONTINUE:"
send "\r"

# eula
expect "   TO END:"
send "0\r"
expect "DO YOU ACCEPT THE TERMS OF THIS LICENSE AGREEMENT? (Y/N):"
send "Y\r"

# default ports
expect "HTTP Port (Default: 80):"
send "\r"
expect "HTTPS Port (Default: 443):"
send "\r"

# self signed cert
expect "ENTER THE NUMBER FOR YOUR CHOICE, OR PRESS <ENTER> TO ACCEPT THE DEFAULT:"
send "\r"

# http -> https redirect
expect "ENTER THE NUMBER FOR YOUR CHOICE, OR PRESS <ENTER> TO ACCEPT THE DEFAULT:"
send "2\r"

# non-cluster
expect "ENTER THE NUMBER FOR YOUR CHOICE, OR PRESS <ENTER> TO ACCEPT THE DEFAULT:"
send "1\r"

# sql on localhost
expect "Server (Default: localhost):"
send "\r"

# sql port to default 1433
expect "Port (Default: 1433):"
send "\r"

# db name
expect "Database Name (Default: AAE-Database):"
send "\r"

# db user
expect "Login ID :"
send "SA\r"

# db pw
expect "Please Enter the Password:"
send "FooBar1234!!\r"

# db secure conn
expect "ENTER THE NUMBER FOR YOUR CHOICE, OR PRESS <ENTER> TO ACCEPT THE DEFAULT:"
send "\r"

# continue and install
expect "PRESS <ENTER> TO CONTINUE:"
send "\r"
expect "PRESS <ENTER> TO INSTALL:"
send "\r"

# 302 code warning
expect "PRESS <ENTER> TO ACCEPT THE FOLLOWING (OK):"
send "\r"

# exit
expect "PRESS <ENTER> TO EXIT THE INSTALLER:"
send "\r"
EOF

chmod 755 a2019_silent_install
./a2019_silent_install

# Testing local shared dir
mkdir /mnt/test
chmod 777 /mnt/test

systemctl stop firewalld
systemctl is-active firewalld
firewall-offline-cmd --zone=public --add-port=443/tcp
systemctl enable firewalld
systemctl start firewalld
