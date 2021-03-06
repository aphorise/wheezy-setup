# Debian Wheezy Initial System Installer
Script for executing after initial install / login to a new Debian Wheezy OS (amd64/x86). Includes ``sed`` commands to make _configuration_ adjustments such as eg: ``PermitRootLogin no`` as part of **_sshd_** properties & **_grub_** update to launch **_systemd_** on boot in your kernel image. 

Adds three source .list files (based on selection) to  ``/etc/apt/sources.list.d/``:
* ``webmin.list``
* ``wheezy-extras.list``
* ``wheezy-backports.list``

The following applications are installed by default:
```
debconf procps systemd ntp ntpdate build-essential \
gdb pkg-config autoconf libtool automake pkg-config \
cmake software-properties-common python-software-properties \
openssh-server git libncurses5-dev libudev-dev libcurl4-openssl-dev l \
ibcurl3-dev tcl dialog gpm aptitude rcconf nano vim sysstat mc wget curl \
unzip nload htop screen nmap less rsync tree links2 byobu apache2 php5 memcached \
php5-memcached php5-mysqlnd php5-adodb php5-gd php-apc php5-pgsql \
rubygems ruby-full rkhunter lynis
```
Thereafter additional application may be installed (via _**Y**es_ / _**N**o_ prompts that follow) including:
  - [Postgre 9.1+ (or < later release)](http://www.postgresql.org/download/linux/debian/ "postgre-website")
  - [GO (1.4) Programming Language](https://golang.org/dl/ "go-website") 
  - [Node.js (1.4.x+) Node.js](http://nodejs.org/ "node.js-website") 
  - [RealVNC 5.2.2](https://www.realvnc.com/download/vnc/ "RealVNC-website") - (not tightvnc) 
  - [TeamViewer 10](http://www.teamviewer.com/en/download/linux.aspx "TeamViewer-website") - (also installs: ia32-libs-gtk)
  - [Webmin](http://www.webmin.com/ "webmin-website") 
  - [Docker.io](https://docs.docker.com/installation/debian/ "docker.io-website")
  - [Tomcat 7](https://packages.debian.org/wheezy/java/tomcat7 debian-packages)

>confirmed working with Debian 7.7 (Jan 2015) 

## Bare-Metal
Many packages are arguably preferential; a minimal install could be as such:
```
debconf procps systemd software-properties-common python-software-properties tcl dialog aptitude nano vim
```

## Credits:
----
Many thanks to all the fine folks @ [irc://freenode.net#debian](http://freenode.net) including _babilen_ & _abrotman_ for their input & suggetions.

------
