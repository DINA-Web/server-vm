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
#    mysql -udina -p$pass dina_web < /vagrant_data/SpecifyDB.sql
#    mysql -udina -p$pass userdb < /vagrant_data/userdb.sql
fi

# wildfly data source configuration
wget http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar \
-O ~/dl/mysql-connector-java-5.1.34.jar

cd ~/bitnami/wildfly/wildfly/bin

# deploy the mysql driver to wildfly
./jboss-cli.sh --connect --command="deploy ~/dl/mysql-connector-java-5.1.34.jar"

# add the data source pointing to the specify database populated with test data
./jboss-cli.sh --connect --command="data-source add --name=DinaDS --jndi-name=java:/jdbc/DinaDS --driver-name=mysql-connector-java-5.1.34.jar_com.mysql.jdbc.Driver_5_1 --connection-url=jdbc:mysql://127.0.0.1:3306/dina_web --user-name=dina --password=$(cat ~/.bitnami-pass)"

# add the data source pointing to the user database
./jboss-cli.sh --connect  --command="data-source add --name=UserDS --jndi-name=java:/jdbc/UserDS  --driver-name=mysql-connector-java-5.1.34.jar_com.mysql.jdbc.Driver_5_1  --connection-url=jdbc:mysql://127.0.0.1:3306/userdb --user-name=dina  --password=$(cat ~/.bitnami-pass)"
