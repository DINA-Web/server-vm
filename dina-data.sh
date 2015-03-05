source ~/bitnami/wildfly/use_wildfly

pass=$(cat ~/.bitnami-pass)

mysql -uroot -e "create user 'dina'@'localhost' identified by '$pass';"
mysql -uroot -e "grant all on *.* to 'dina'@'localhost';"
#mysql -uroot -e "grant all on *.* to 'dina'@'%';"
mysql -uroot -e "flush privileges;"

# create databases to be used by all DINA modules
# specify utf8 for database creation to be safe
if mysql -udina -p$pass -e "create database dina_web default character set utf8 default collate utf8_general_ci; create database userdb default character set utf8 default collate utf8_general_ci;"
then
    echo "Importing DINA-WEB data..."
#    mysql -udina -p$pass dina_web < /repos/dina-web/datasets/dina_web.sql
# TODO: remove the use of shared folder once demo dataset has been pushed to repo
    mysql -udina -p$pass dina_web < /vagrant_data/dina_web.sql
    mysql -udina -p$pass userdb < ~/repos/dina-web/datasets/userdb.sql
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

# extend wildfly max-post-size to allow big file uploading (required by inventory.war)
./jboss-cli.sh --connect --command="/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=max-post-size, value=974247881)"
./jboss-cli.sh --connect --command="/subsystem=undertow/server=default-server/https-listener=https:write-attribute(name=max-post-size, value=974247881)"


# Configuring dnakey.war module and blast.ear module
# (which in turn depends on...)
	# dina-external-datasource.war
	# dina-news-publisher.war
mkdir -p ~/bitnami/wildfly/dnakey
cd ~/bitnami/wildfly/dnakey
mkdir -p bin db data/tempfastafiles
tar xvfz ~/repos/dina-web/datasets/sequence-data.tgz data
tar xvfz ~/repos/dina-web/datasets/blast-data.tgz db
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/dina-external-datasource.war"
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/dina-news-publisher.war"
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/blast.ear"
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/dnakey.war"

# Configuring loan.war and loan-admin.war
# (which in turn depends on...)
	# dina-external-datasource.war
cd ~/bitnami/wildfly
mkdir -p loans
tar xvfz ~/repos/dina-web/datasets/loan-data.tgz
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/loan.war"
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/loan-admin.war"

# Configuring inventory.war
# (which in turn depends on...)
	# inventoryservice.war
cd ~/bitnami/wildfly
mkdir -p inventory_group_list excel
tar xvfz ~/repos/dina-web/datasets/inventory-data.tgz
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/inventoryservice.war"
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/inventory.war"

# Configuring naturarv.war
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/naturarv.war"

# TODO: Configuring Login function
cp ~/repos/dina-web/datasets/app.properties ~/bitnami/wildfly/standalone/configuration
keytool -genkey -alias wildfly_mgmt -keyalg RSA -keystore wildfly.jks \
-storepass $pass -keypass $pass --dname "CN=Admin,OU=BI,O=NRM,L=Stockholm,S=ST,C=SE"
# TODO various wildfly configurations in standalone.xml (see email)

# Configuring solr (searchindex) module
# note that the schema.xml used is matched to the Specify database schema
cp ~/bitnami/solr/apache-solr/solr/collection1/conf/schema.xml ~/schema.xml.backup
cp ~/repos/dina-web/datasets/schema.xml ~/bitnami/solr/apache-solr/solr/collection1/conf
./jboss-cli.sh --connect --command="deploy ~/repos/dina-web/modules/search-index.war"
# TODO: put this into the github repo

# TODO:

# java options in wildfly/bin/standalone.conf ie make these changes too
# do a diff versus standalone.conf.original
##if [ "x$JAVA_OPTS" = "x" ]; then
#   JAVA_OPTS="-Xms64m -Xmx4096m -XX:MaxPermSize=4096m -Djava.net.preferIPv4Stack=true"
#   JAVA_OPTS="$JAVA_OPTS -Djboss.modules.system.pkgs=$JBOSS_MODULES_SYSTEM_PKGS -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=
#UTF-8 -Dsun.io.unicode.encoding=UnicodeBig"
##else
##   echo "JAVA_OPTS already set in environment; overriding default settings with values: $JAVA_OPTS"
##fi

# import of dyntaxa certificate (keytool and make available to JRE)
# TERENA_SSL_CA_2.cer
# use script from @as in /bin/
#sudo /opt/java/jdk/bin/keytool -import -trustcacerts -alias dyntaxa \
#-file ~/bin/TERENA_SSL_CA_2.cer -keystore /opt/java/jdk/jre/lib/security/cacerts





