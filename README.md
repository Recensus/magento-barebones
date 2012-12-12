#Barebones Magento Development Setup 

##Install

This repo contains two Magento installations (one with the sample data and one 
without it). It also contains a VagrantFile which sets up the LAMP stack on
ubuntu 12.04, creates the relevant databases, populates one with sample data and 
grants remote root access. 

1) Download this repository as a zip.

2) Add a ubuntu 12.04 basebox (vagrant box add ubuntu1204 <path_to_box>)

3) Add the following to your hosts file:

192.168.50.5 dev.magento-test.com
192.168.50.5 dev.magento-test-data.com

4) vagrant up

5) Complete the Magento installations by navigating to 

dev.magento-test.com
dev.magento-test-data.com

6) If you require shell access - vagrant ssh

##Creds

mysql: U root p ''