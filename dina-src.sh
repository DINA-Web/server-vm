# get the mysql driver
wget http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar \
-O ~/dl/mysql-connector-java-5.1.34.jar

# configure data sources in wildfly
source ~/bitnami/wildfly/use_wildfly
cd ~/bitnami/wildfly/wildfly/bin

# deploy the mysql driver to wildfly
./jboss-cli.sh --connect --command="deploy ~/dl/mysql-connector-java-5.1.34.jar"

# add the data source pointing to the specify database populated with test data
./jboss-cli.sh --connect --command="data-source add --name=DinaDS --jndi-name=java:/jdbc/DinaDS --driver-name=mysql-connector-java-5.1.34.jar_com.mysql.jdbc.Driver_5_1 --connection-url=jdbc:mysql://127.0.0.1:3306/dina_web --user-name=dina --password=$(cat ~/.bitnami-pass)"

# add the data source pointing to the user database
./jboss-cli.sh --connect  --command="data-source add --name=UserDS --jndi-name=java:/jdbc/UserDS  --driver-name=mysql-connector-java-5.1.34.jar_com.mysql.jdbc.Driver_5_1  --connection-url=jdbc:mysql://127.0.0.1:3306/userdb --user-name=dina  --password=$(cat ~/.bitnami-pass)"

# TODO add all the github repo URLs for the DINA WEB modules
git clone git@github.com:DINA-WEB/taxonomy-drf.git