echo "Setting up bitnami services password"
cp /vagrant/.bitnami-pass .
chmod 600 .bitnami-pass

echo "Getting and installing bitnami open source server sw"
mkdir -p ~/dl ~/bitnami

# solr
wget https://bitnami.com/redirect/to/45225/bitnami-solr-4.10.2-0-linux-x64-installer.run \
-O ~/dl/solr.run
chmod +x ~/dl/solr.run
~/dl/solr.run \
  --mode unattended \
  --prefix ~/bitnami/solr \
  --apache_server_port 18080 \
  --apache_server_ssl_port 18443

# mongodb from the bitnami mean-stack
wget https://bitnami.com/redirect/to/45897/bitnami-meanstack-2.6.5-1-linux-x64-installer.run \
-O ~/dl/mean.run
chmod +x ~/dl/mean.run
~/dl/mean.run \
  --mode unattended \
  --prefix ~/bitnami/mean \
  --disable-components rockmongo \
  --mongodb_password `cat ~/.bitnami-pass` \
  --apache_server_port 28080 \
  --apache_server_ssl_port 28443

# wildfly, apache and mysql
wget https://bitnami.com/redirect/to/37031/bitnami-wildfly-8.1.0-0-linux-x64-installer.run \
-O ~/dl/wildfly.run
chmod +x ~/dl/wildfly.run
~/dl/wildfly.run \
  --mode unattended \
  --prefix ~/bitnami/wildfly \
  --mysql_database_name dina \
  --mysql_database_username dina \
  --mysql_database_password `cat ~/.bitnami-pass` \
  --jboss_manager_username manager \
  --jboss_manager_password `cat ~/.bitnami-pass`

# oracle jdk 8
wget --header "Cookie: oraclelicense=accept-securebackup-cookie" \
http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-x64.tar.gz \
-O ~/dl/jdk.tgz

# install Java 8 JDK system-wide, available at /opt/java/jdk
sudo /vagrant/oracle_jdk_8_setup.sh

# enable using the jdk v 8 from oracle in wildfly standalone.conf
~/bitnami/wildfly/ctlscript.sh stop
cd ~/bitnami/wildfly/wildfly/bin
cp standalone.conf standalone.conf.original
sed -e "s/#JAVA_HOME/JAVA_HOME/" standalone.conf.original > standalone.conf
~/bitnami/wildfly/ctlscript.sh start

# set up mysqldump to use default pwd to allow non-interactive scripting of backups
echo -e "[mysqldump]\n\
password=$(cat ~/.bitnami-pass)" > ~/.my.cnf
chmod 600 .my.cnf