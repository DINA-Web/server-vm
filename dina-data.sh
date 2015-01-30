source ~/bitnami/wildfly/use_wildfly

pass=$(cat ~/.bitnami-pass)

mysql -uroot -e "create user 'dina'@'localhost' identified by '$pass';"
mysql -uroot -e "grant all on *.* to 'dina'@'localhost';"
#mysql -uroot -e "grant all on *.* to 'dina'@'%';"
mysql -uroot -e "flush privileges;"

# create databases to be used by all DINA modules
if mysql -udina -p$pass -e "create database dina_web; create database userdb;"
then
    echo "Importing DINA-WEB data..."
#    mysql -udina -p$pass dina_web < /vagrant/dina-data/dina-web-db.sql
#    mysql -udina -p$pass userdb < /vagrant/dina-data/userdb.sql
fi
