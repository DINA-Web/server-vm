source ~/bitnami/wildfly/use_wildfly

mysql -uroot -e "create user 'dina'@'localhost' identified by '$(cat ~/.bitnami-pass)';"
mysql -uroot -e "grant all on *.* to 'dina'@'localhost';"
mysql -uroot -e "grant all on *.* to 'dina'@'%';"

# create databases to be used by all DINA modules
if mysql -udina -p$(cat ~/.bitnami-pass) -e "create database dina_web; \
create database userdb;"
then
    echo "Importing DINA-WEB data..."
    mysql -uMasterUser -pMasterPassword dina_web < /vagrant/dina-data/dina-web-db.sql
    mysql -uMasterUser -pMasterPassword userdb < /vagrant/dina-data/userdb.sql
fi
