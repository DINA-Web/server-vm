# DINA-WEB server vm alpha delivery

Here we use `vagrant` to build the DINA-WEB system from scratch as a server that can be provisioned in a range of different providers, like your own VirtualBox or using third party services like Amazon Elastic Cloud etc.

## Usage instructions

To use this approach, install `vagrant` on your system. Also install `git` if you haven't already, and `VirtualBox`. Use these steps to build the server, start it in VirtualBox and connect to the server using ssh.

```console
mkdir -p ~/repos/dina-web
cd ~/repos/dina-web

# get the code to build the DINA-WEB server
git clone https://github.com/DINA-Web/server-vm.git

# remember to not use the default password
# change it to using the approach below
cd server-vm
echo "passw0rd12" > .bitnami-pass

# build the server and connect to it
vagrant up
vagrant ssh
```

Using `vagrant` you can also deploy your version of the DINA-WEB system directly on the Internet using third party services if you prefer not to use software such as Virtualbox to run it on your own hardware and network inside your existing infrastructure.

## Can I get the server in .ova format?

From within VirtualBox you can export an OVA file (Open Virtualization Appliance), which is excellent for sharing across other virtualization environments.

# Background - what is a Vagrantfile?

This text file outlines configuration steps starting with a base OS and specifies networking options etc. Change as you see fit! 

The Vagrantfile then calls a bootstrap script when building the server box. This bootstrap script installs all required OS dependencies along with all other required software and makes various configuration settings.

## Open source software stacks used

We make use of open source software server software stacks from bitnami to get required software such as web server (apache), application server (wildfly), databases (mysql, solr, mongodb) in place.

We then fetch DINA-WEB data and modules and load it on the system. 

Then we configure the system so it is becomes turn-key ready.

All steps are detailed in the `bootstrap.sh` file. Check it out!

## DINA-WEB datasets

We preload the Specify software test dataset in order to provide a system which runs with existing pre-loaded data (`SpecifyDB.sql`).

We preload a database with dummy user data (`UserDB`)

## DINA-WEB modules

A number of core modules are getting ready to be deployed in the platform:

* naturarv (https://www.dina-web.net/naturarv)
* loan (https://www.dina-web.net/loan)
* loan-admin (https://www.dina-web.net/loan-admin)
* inventory (https://www.dina-web.net/inventory)
* dna-key (https://www.dina-web.net/dnakey/) (work in progress, needs blastdb)

Support modules:

* dina-blast-creator-ear
* dina-exteral-datasource
* dina-new-publisher
* dina-inventory-service
* dina-searchindex-builder-ear

# Follow up / Future work / Known Issues

The following aspects are not part of the alpha delivery and are scheduled for the next release:

## Good sample datasets

The so called "fish dataset" doesn't currently give a fully functional system. Approaches for how to solve this are being discussed.

## E-mail connectivity

Most of the modules need to send email. Configuration and consolidation of email delivery approach is currently work in progress.

## Tuning

Additional configurations for security and large file uploads are required and planned for the next release.

## File-system settings

The loan module use policy documents and loan pdf stores which need to be configured in wildfly.

* .../wildfly/standalone/configuration needs `app.properties`
* security config in standalone.xml through `jbosscli.sh` commands
