# DINA-WEB server vm alpha delivery

Here we use `Vagrant` to build the DINA-WEB server VM from scratch.

This approach can deliver an OVA file (Open Virtualization Appliance), which is excellent for testing purposes and which also means you can deploy your version of the DINA-WEB system on the Internet using third party services if you prefer not to use software such as Virtualbox to run it on your own hardware and network inside your existing infrastructure.

## What is a Vagrantfile?

This file outlines all configuration steps starting with a base linux OS. It calls a bootstrap script which installs all required OS dependencies along with all other required software and makes settings.

# Building the server from scratch

We make use of open source software server software stacks from bitnami to get required software such as web server (apache), application server (wildfly), databases (mysql, solr, mongodb) in place.

We then fetch DINA-WEB data and modules and load it on the system. Then we configure the system so it is becomes turn-key ready.

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



# Follow up

The following aspects are not part of the alpha delivery and are scheduled for the next release:

## E-mail connectivity

Most of the modules need to send email. Configuration and consolidation of email delivery approach is currently work in progress.

## Tuning

Additional configurations for security and large file uploads are required and planned for the next release.

## File-system settings

The loan module use policy documents and loan pdf stores which need to be configured in wildfly.

* .../wildfly/standalone/configuration needs `app.properties`
* security config in standalone.xml through `jbosscli.sh` commands


