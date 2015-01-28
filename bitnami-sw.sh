echo "Setting system user password"
echo "passw0rd12" > ~/.bitnami-pass
chmod 600 ~/.bitnami-pass

echo "Getting bitnami open source server sw"
mkdir -p ~/bitnami
cd ~/dl

# DO WE NEED LAMPSTACK?
wget https://bitnami.com/redirect/to/46525/bitnami-lampstack-5.4.35-0-linux-x64-installer.run

chmod +x bitnami-lampstack-5.4.35-0-linux-x64-installer.run

./bitnami-lampstack-5.4.35-0-linux-x64-installer.run \
  --mode unattended \
  --base_user dina \
  --base_password `cat ~/.bitnami-pass` \
  --disable-components varnish,zendframework,symfony,codeigniter,cakephp,smarty,laravel,phpmyadmin \
  --mysql_database_username dina \
  --mysql_password `cat ~/.bitnami-pass`
  
ln -s ~/lampstack-5.4.36-0/ ~/bitnami/lamp
~/bitnami/lamp/ctlscript.sh stop

# solr

wget https://bitnami.com/redirect/to/45225/bitnami-solr-4.10.2-0-linux-x64-installer.run

chmod +x bitnami-solr-4.10.2-0-linux-x64-installer.run

./bitnami-solr-4.10.2-0-linux-x64-installer.run \
  --mode unattended \
  --apache_server_port 18080 \
  --apache_server_ssl_port 18443

ln -s ~/solr-4.10.3-0/ ~/bitnami/solr
~/bitnami/solr/ctlscript.sh stop apache

# mongodb from bitnami mean-stack

wget https://bitnami.com/redirect/to/45897/bitnami-meanstack-2.6.5-1-linux-x64-installer.run

chmod +x bitnami-meanstack-2.6.5-1-linux-x64-installer.run

./bitnami-meanstack-2.6.5-1-linux-x64-installer.run \
  --mode unattended \
  --disable-components rockmongo \
  --mongodb_password `cat ~/.bitnami-pass`

ln -s ~/meanstack-2.6.7-0 ~/bitnami/mongodb
~/bitnami/mongodb/ctlscript.sh status

# wildfly, apache and mysql

wget https://bitnami.com/redirect/to/37031/bitnami-wildfly-8.1.0-0-linux-x64-installer.run

chmod +x bitnami-wildfly-8.1.0-0-linux-x64-installer.run

./bitnami-wildfly-8.1.0-0-linux-x64-installer.run \
  --mode unattended \
  --mysql_database_name dina \
  --mysql_database_username dina \
  --mysql_database_password `cat ~/.bitnami-pass` \
  --jboss_manager_username manager \
  --jboss_manager_password `cat ~/.bitnami-pass`

ln -s ~/wildfly-8.2.0-1/ ~/bitnami/wildfly
~/bitnami/wildfly/ctlscript.sh status

# install Java 8 JDK

wget --header "Cookie: oraclelicense=accept-securebackup-cookie" \
http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-x64.tar.gz

sudo mkdir -p /opt/jdk
sudo tar -zxf jdk-8u5-linux-x64.tar.gz -C /opt/jdk

# set oracle jdk as default java

sudo update-alternatives --install /usr/bin/java java \
/opt/jdk/jdk1.8.0_05/bin/java 100

sudo update-alternatives --install /usr/bin/javac javac \
/opt/jdk/jdk1.8.0_05/bin/javac 100

# point bitnami wildfly to use the jdk v 8 from oracle

sudo mkdir /opt/java
sudo ln -s /opt/jdk/jdk1.8.0_05 /opt/java/jdk
cd ~/bitnami/wildfly/wildfly/bin

# enable using the jdk v 8 from oracle in wildfly standalone.conf
cp standalone.conf standalone.conf.original
sed -e "s/#JAVA_HOME/JAVA_HOME/" standalone.conf.original > standalone.conf

# set up mysqldump default pwd
echo -e "[mysqldump]\n\
password=$(cat ~/.bitnami-pass)" > ~/.my.cnf
chmod 600 .my.cnf


