# Docker for OpenMage Project
> Use it to manage an OpenMage project with docker and docker-compose.
>
>Originally forked from [andreaskoch/dockerized-magento](https://github.com/andreaskoch/dockerized-magento).


Table of Contents
=================

   * [Docker for OpenMage Project](#docker-for-openmage-project)
      * [Installing / Getting started](#installing--getting-started)
         * [Requirements](#requirements)
            * [Use Linux](#use-linux)
            * [Install Docker and docker-compose](#install-docker-and-docker-compose)
            * [Add the domain name](#add-the-domain-name)
         * [Installation](#installation)
            * [First build](#first-build)
            * [OpenMage installation](#openmage-installation)
               * [Option 1) : Quick install](#option-1--quick-install)
               * [Option 2) : Custom sources install](#option-2--custom-sources-install)
               * [Option 3) : Full custom install](#option-3--full-custom-install)
      * [Usage](#usage)
         * [Components Overview](#components-overview)
         * [Custom Configuration](#custom-configuration)
         * [Changing the domain name](#changing-the-domain-name)
         * [Change the MySQL Root User Password](#change-the-mysql-root-user-password)
         * [Working with X-debug and Phpstorm](#working-with-x-debug-and-phpstorm)
         * [Working with my <a href="https://github.com/julienloizelet/composer-magento1.git">OpenMage installation based on composer</a>](#working-with-my-openmage-installation-based-on-composer)
      * [Troubleshooting](#troubleshooting)
      * [Contributing](#contributing)
      * [Licensing](#licensing)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)


## Installing / Getting started

### Requirements

#### Use Linux

I gave up using docker on Mac OS. Never tried on Windows OS.

#### Install Docker and docker-compose

If you are on Linux you should install [docker and docker-compose](http://docs.docker.com/compose/install/)


#### Add the domain name

The web-server will be bound to your local ports 80 and 443. By default, host is set to be `openmage.local`. 
So, in order to access the shop you must add a hosts file entry for `openmage.local`.

For Linux Users, in order to access the shop you must add the domain name `openmage.local` to your hosts file (`/etc/hosts`).
If you are using docker **natively** you can use this command:

```bash
sudo su
echo "127.0.0.1    openmage.local" >> /etc/hosts
```
 

### Installation

We can divide the installation process in two step: `First build` and `OpenMage installation`. In the first step, you will have
to create and modify a `docker-compose.override.yml` file and your modification will depend on the way you want to install OpenMage. 
So please read the [OpenMage installation](#openmage-installation) paragraph to understand the 3 options you have.

#### First build


1. Create a  `docker-compose.override.yml` from the example `docker-compose.override.yml.dist` and make the necessary changes :
   - If you want to use the quick install process : uncomment the two lines : `- ./openmage-sources/:/var/www/html/web/`
   - If you want to use the custom install process or full custom install process : uncomment the two lines `- /some/path/for/your-project-sources/:/var/www/html/web/`
   and replace the example path with your custom sources path.
2. Start the projects using `sudo ./openmage start` (maybe you will have to do a `chmod +x openmage`).


**Note**: The build process will take a while if you start the project for the first time. After that, starting and stopping the project will be a matter of seconds.

#### OpenMage installation

Once you have created all your docker containers (i.e once the `sudo ./openmage start` command has finished), you have 3 options 
to have ready-to-use OpenMage project.

##### Option 1) : Quick install

This option should be use to install and try OpenMage quickly.

i) Ensure that all your volumes in your `docker-compose.override.yml` file are well configured : i.e `./openmage-sources/` 
will be mount in `/var/www/html/web`.

ii) `sudo ./openmage install quick`

This command will:

- download sources as specified by the `OPENMAGE_VERSION` environment variable (e.g `openmage-lts-1.9.4.x`) in the `openmage-sources` folder.
- create a database with a name specified by the `DATABASE_NAME` environment variable (e.g `openmage`).
- install the sample datas specified in the [magerun config file](conf/magerun/n98-magerun.yaml) (e.g `sample-data-1.9.2.4`).
- Configure your OpenMage instance with default value of the magerun script and values of the [magerun config file](conf/magerun/n98-magerun.yaml).

N.B : 

  - database must not exist prior to this quick install.

  - source code must not exist in the `openmage-sources` folder prior to this quick install.
      

##### Option 2) : Custom sources install

This option should be use to install and try OpenMage with custom sources and no custom database.
For example, if you want to contribute to the OpenMage github project by submitting a merge request or reviewing an 
existing one, you will be able to clone the project, switch to the branch you want test, and have ready-to-test OpenMage
instance.

i)  Get your sources ready :
 We will assume sources are in a directory called `/some/path/for/your-project-sources` and that
all your volumes in your `docker-compose.override.yml` file are well configured : i.e `/some/path/for/your-project-sources` will be mount in 
`/var/www/html/web`.

ii) `sudo ./openmage install custom`

This command will:

- create a database with a name specified by the `DATABASE_NAME` environment variable (e.g `openmage`).
- Configure your OpenMage instance with default value of the magerun script and values of the [magerun config file](conf/magerun/n98-magerun.yaml).

N.B : 
  -  database will be re-created if already exists
  
  - `app/etc/local.xml` must not be present in your custom sources
      

##### Option 3) : Full custom install

This is a full manual installation because you already have a custom database and custom sources.
For example, you could use it if you have to manage an already existing Magento 1 or OpenMage project and someone gave you access
to sources and database.

i)  Get your sources ready :
 We will assume sources are in a directory called `/some/path/for/your-project-sources` and that all your volumes in 
 your `docker-compose.override.yml` file are well configured : i.e `/some/path/for/your-project-sources` will be mount in 
 `/var/www/html/web`.
 
ii) Get your database ready :
   Copy a dump `yourdatabasedump.sql` in the path `data/dump`.

iii) Import the database
- Create a `yourdatabase` database (a simple way is to use `phpmyadmin` by going to the url : `http://localhost:8081`)
- We will the import the database with the following commands (use `pw` as root password when prompted.):
```sudo ./openmage enter mysql
cd /etc/dump
mysql -u root -h localhost -p yourdatabase < yourdatabase.sql
```
iv) Modify the `app/etc/local.xml` file

Go to the `/some/path/for/magento/sources` and edit the `app/etc/local.xml` file with the following content (replace `yourdatabase` name by yours):
```
<?xml version="1.0"?>
<config>
    <global>
        <install>
            <date><![CDATA[Sat, 11 Apr 2015 12:33:05 +0000]]></date>
        </install>
        <crypt>
            <key><![CDATA[731aea833710535779fe8c7c49bc6c4d]]></key>
        </crypt>
        <disable_local_modules>false</disable_local_modules>
        <resources>
            <db>
                <table_prefix><![CDATA[]]></table_prefix>
            </db>
            <default_setup>
                <connection>
                    <host><![CDATA[mysql]]></host>
                    <username><![CDATA[root]]></username>
                    <password><![CDATA[pw]]></password>
                    <dbname><![CDATA[yourdatabase]]></dbname>
                    <initStatements><![CDATA[SET NAMES utf8]]></initStatements>
                    <model><![CDATA[mysql4]]></model>
                    <type><![CDATA[pdo_mysql]]></type>
                    <pdoType><![CDATA[]]></pdoType>
                    <active>1</active>
                </connection>
            </default_setup>
        </resources>
        <session_save><![CDATA[files]]></session_save>
    </global>
    <admin>
        <routers>
            <adminhtml>
                <args>
                    <frontName><![CDATA[admin]]></frontName>
                </args>
            </adminhtml>
        </routers>
    </admin>
</config>
```

## Usage

You can control the project using the built-in `openmage`-script which is basically just a **wrapper for docker and docker-compose** that offers some **convenience features**:

```bash
sudo ./openmage <action>
```

**Available Actions**

- **start**: Starts the docker containers
- **stop**: Stops all docker containers
- **restart**: Restarts all docker containers and flushes the cache
- **status**: Prints the status of all docker containers
- **stats**: Displays live resource usage statistics of all containers
- **magerun**: Executes magerun in the magento root directory
- **composer**: Executes composer in the magento root directory
- **enter**: Enters the bash of a given container type (e.g. php, mysql, ...)
- **destroy**: Stops all containers and removes all data
- **install**: 2 possible options : 
   - quick (download OpenMage sources and create database with sample datas)
   - custom : create an empty database (sources has to be specified manually)
- **logs**: Show containers logs


### Components Overview

The dockerized OpenMage project consists of the following components:

- **[docker images](docker-images)**
  1. a [PHP 7.3 FPM](docker-images/php7.3-fpm/Dockerfile) image with magerun, composer and xdebug enabled
  1. a [Nginx 1.18](https://github.com/nginxinc/docker-nginx/blob/793319d7251c03eccecbf27b60e0cfbbd2d1f400/stable/buster/Dockerfile) image
  1. a [MySQL 5.7](https://hub.docker.com/_/mysql/) database server image
  1. a [phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/) image that allows you to access the database on port 8080
  1. a [Maildev](https://hub.docker.com/r/maildev/maildev) image to prevent sending email on test environnment.
- a **[shell script](openmage)** for controlling the project: [`./openmage <action>`](openmage)
- and the [docker-compose.yml](docker-compose.yml)-file which connects all components


### Custom Configuration

All parameters of the OpenMage installation are defined via environment variables that are set in the [docker-compose.yml](docker-compose.yml) file - if you want to tailor the OpenMage Shop installation to your needs you can do so **by modifying the environment variables** before you start the project.

If you have started the shop before you must **repeat the installation process** in order to apply changes:

1. Create a `docker-compose.override.yml` file from the example file `docker-compose.override.yml.dist`. 
2. Modify the parameters in the `docker-compose.override.yml`
3. Shutdown the containers and remove all data (`sudo ./openmage destroy`)
4. Start the containers again (`sudo ./openmage start`)

### Changing the domain name

I set the default domain name to `openmage.local`. To change the domain name, replace `openmage.local` with `your-domain.tld` in the `docker-compose.override.yml` file:

```yaml
nginx:
  environment:
    DOMAIN: your-domain.tld
```

### Change the MySQL Root User Password

I chose a very weak passwords for the MySQL root-user. You can change it by modifying the respective environment variables for the **mysql-container** because otherwise the installation will fail:

```yaml
mysql:
  environment:
    MYSQL_ROOT_PASSWORD: <your-mysql-root-user-password>
```

### Working with X-debug and Phpstorm
Here is what I am doing to configure X-debug on Phpstorm (tested on 2020.1.1 version)
1. First get your host local IP to put in your `docker-compose-override.yml`. (I obtain something like 172.19.0.1).
Find the name of your php container with `sudo docker ps`. Then run `sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}' php_container_name` to find it.
2. Install and configure a plugin for Firefox or Chrome: (I use [Xdebug-ext](https://addons.mozilla.org/en-US/firefox/addon/xdebug-ext-quantum/))  
   Go to Tools->Addons->Extensions->Xdebug-ext and change your IDE-key : `phpstorm-xdebug`.
3. Configure Phpstorm in Project Settings (where are the OpenMage sources) :
  - Settings -> Languages and Frameworks -> PHP -> Debug -> Set the port (9000 for me)
  - Settings -> Languages and Frameworks -> PHP -> Servers : Add server with name `openmage.local` and configuration of your site (`host = openmage.local`)
  and add the path mapping `/some/path/for/your-project-sources` to `/var/www/html/web`
  - Go to Run->Edit configurations. Add "PHP Remote Debug" configuration, select your server (that you just added) and enter an IDE-key : `phpstorm-xdebug`.
  - Select Run->Debug... and select your remote configuration name (as you named it above)
  
### Working with my [OpenMage installation based on composer](https://github.com/julienloizelet/composer-magento1.git)

If you are using composer with a repo like [mine](https://github.com/julienloizelet/composer-magento1.git) (i.e if you are me ...), beware that you have to create the `docker-compose.override.yml` with some specific volumes (see the `docker-compose.override.yml.dist` file).
You will then be able to run your composer commands once you will be in the `php` container :
- On a fresh install : run the following commands : 
  - `sudo ./openmage start`.
  - `sudo ./openmage enter php`
  - `composer install`
- As the `htdocs` folder is created at this moment, we have to restart container in order to have a functional volume (i.e a link between `htdocs` and `/var/www/html/web`).
So, just run `sudo ./openmage destroy` and then `sudo ./openmage start` again.
  
## Troubleshooting
  - Before running the command `sudo ./openmage start `, you must stop all programs that are listening to port 80 or 443 (e.g apache or nginx). For example : `sudo service apache2 stop`

  - On first `sudo ./openmage start`, you may have an error :
`for nginx  Cannot start service nginx: oci runtime error: container_linux.go:247: starting container process caused "exec: \"/bin/nginx.sh\": permission denied"`
Workaround : before launch it again : `sudo chmod -R 777 bin`

  - X-debug not working because of ufw firewall. Maybe you will have to open port 9000 on your machine if you are using ufw :
  `sudo ufw allow from any to any port 9000 proto tcp comment xdebug`

  

## Contributing
If you'd like to contribute, please fork the repository and use a feature
branch. Pull requests are warmly welcome.
If you found any issue, please go [there](https://github.com/julienloizelet/docker-openmage/issues).

## Licensing
[GNU General Public License, version 3 (GPLv3)](http://opensource.org/licenses/gpl-3.0)
