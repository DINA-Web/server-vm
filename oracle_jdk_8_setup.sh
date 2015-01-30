mkdir -p /opt/jdk
tar -zxf /home/dina/dl/jdk.tgz -C /opt/jdk

# set oracle jdk as default java

update-alternatives --install /usr/bin/java java \
/opt/jdk/jdk1.8.0_05/bin/java 100

update-alternatives --install /usr/bin/javac javac \
/opt/jdk/jdk1.8.0_05/bin/javac 100

# add symlink to be used by bitnami sw

mkdir /opt/java
ln -s /opt/jdk/jdk1.8.0_05 /opt/java/jdk
