
# expects: export MSSQL_SA_PASSWORD='xxx'

##############
# SQL Server developer test
##############
curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2019.repo
yum install -y mssql-server

ACCEPT_EULA='Y' MSSQL_PID='Developer' MSSQL_TCP_PORT=1433 /opt/mssql/bin/mssql-conf setup

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
