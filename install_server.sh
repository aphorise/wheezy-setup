#!/bin/bash
#// debian:wheezy install essentials for a common tool stacked dev / desktop setup. 
#// "usermod -a -G sudo YOUR_USER" <-- executing user must be of sudo
#// "dpkg-reconfigure tzdata"  <-- ensure correct TimeZone is set
#// "dpkg-reconfigure locales" <-- ensure all

#// 0 - include contrib non-free packages IF NOT present
if line=$(grep -s -m 1 -e "contrib non-free" /etc/apt/sources.list.d/wheezy-extras.list) ; then
	echo "Already have contrib & non-free in source.list"
else
	sudo sh -c "echo 'deb http://http.debian.net/debian wheezy stable contrib non-free' > /etc/apt/sources.list.d/wheezy-extras.list"
fi
#//////////////
#// enable 32-bit multi-arch if not already
#// COMMENT - IF NO: 32-bit (TeamViewer) is needed
#//////////////
if dpkg --print-foreign-architectures | grep -i "i386" ; then
 echo "Already have 32-bit Arch"
else
 sudo dpkg --add-architecture i386
fi

#// 1 - update & upgrade
sudo apt-get update -y && sudo apt-get upgrade -y

#// allow root ssh? - NO!
sudo sh -c "sed 's/^PermitRootLogin .*/PermitRootLogin no/g' /etc/ssh/sshd_config >> /etc/ssh/sshd_config.new && mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old && mv /etc/ssh/sshd_config.new /etc/ssh/sshd_config"

#// install all system essentials
sudo apt-get install -y \
debconf procps systemd ntp ntpdate build-essential \
gdb pkg-config autoconf libtool automake pkg-config cmake \
software-properties-common python-software-properties openssh-server \
git libncurses5-dev libudev-dev libcurl4-openssl-dev libcurl3-dev \
tcl dialog gpm aptitude rcconf nano vim sysstat mc wget curl \
unzip nload htop screen nmap less rsync tree links2 byobu \
apache2 php5 memcached php5-memcached php5-mysqlnd php5-adodb php5-gd php-apc php5-pgsql \
rubygems ruby-full rkhunter lynis
#//for production servers & stats: 
#// fail2ban psad	//iptables & anti-port (.conf adjustments)
#// munin munin-node munin-plugins-core munin-plugins-extra	//for proc / monitoring. 


#// ADJUST grub / boot for systemd IF NOT present
sudo sh -c "sed 's/\"quiet\"/\"quiet nomodeset init=\/bin\/systemd\"/' /etc/default/grub >> grub && mv /etc/default/grub /etc/default/grub.old && mv grub /etc/default/grub"
sudo update-grub 

#// OPTIONAL - show line numbers in nano by removing "#" for "set const"
sudo sh -c "sed '/set const/s/^# //g' /etc/nanorc >> nanorc && mv nanorc /etc/."

echo " "
echo "**************************************************"
echo " "
echo -n "Continue extra: Postgre, GO, Docker.io & Webmin - installs? - (Y/n) :" && read YESNO
if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) || [ "$YESNO" == "" ] ; then
echo " "
 echo -n "Postgre 9.1+ & contrib plugins -install? - (Y/n) :" && read YESNO
 if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) || [ "$YESNO" == "" ] ; then
	wget https://www.postgresql.org/media/keys/ACCC4CF8.asc
	sudo apt-key add ACCC4CF8.asc && rm -f ACCC4CF8.asc
	sudo apt-get update -y && sudo apt-get install -y postgresql postgresql-contrib
 fi
echo " "
 echo -n "GO 1.4 programming language install? - (Y/n) :" && read YESNO
 if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) || [ "$YESNO" == "" ] ; then
	wget https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go1.4.linux-amd64.tar.gz && rm -f go1.4*
	sudo sh -c "echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile"
 fi
echo " "
 echo -n "Node.js 1.4.x+ - install? - (Y/n) :" && read YESNO
 if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) || [ "$YESNO" == "" ] ; then
	wget https://deb.nodesource.com/setup -O node.js_repo.sh && chmod +x node.js_repo.sh
	apt-get install -y nodejs && rm -f node.js_repo.sh
 fi
echo " "
 echo -n "RealVNC 5.2.2 - install? - (Y/n) :" && read YESNO
 if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) || [ "$YESNO" == "" ] ; then
	wget https://www.realvnc.com/download/binary/1655/ -O realvnc.tar.gz
	tar -xzf realvnc.tar.gz
	sudo dpkg -i VNC-Server-5.2.2-Linux-x64.deb VNC-Viewer-5.2.2-Linux-x64.deb && sudo rm -f VNC-* && sudo rm -f realvnc*
	sudo vnclicense -add MRB7B-6H3KX-SECFB-7GNTP-83KEA
 fi
echo " "
 echo -n "TeamViewer 10 - install? - (Y/n) :" && read YESNO
 if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) || [ "$YESNO" == "" ] ; then
	wget http://download.teamviewer.com/download/teamviewer_linux.deb -O teamviewer.deb
	sudo apt-get install -fy && sudo apt-get install -fy ia32-libs-gtk && sudo dpkg -i teamviewer.deb && rm -f teamviewer.deb
 fi
echo " "
 echo -n "Tomcat 7 - install? - (y/N) :" && read YESNO
 if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) && [ "$YESNO" != "" ] ; then
	sudo apt-get install tomcat7-admin tomcat7-examples tomcat7-docs ant default-jdk
	sudo nano /etc/tomcat7/tomcat-users.xml
 fi
echo " "
 echo -n "Docker.io - install? - (Y/n) :" && read YESNO
 if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) || [ "$YESNO" == "" ] ; then
	#// add .list wheezy-backports for docker.io
	sudo sh -c "echo 'deb http://http.debian.net/debian wheezy-backports main' > /etc/apt/sources.list.d/wheezy-backports.list"
	sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get -q -y -o DPkg::Options::=--force-confold -o DPkg::Options::=--force-confdef install -t wheezy-backports linux-image-amd64
	wget https://get.docker.com/ -O install_docker.io.sh && chmod +x install_docker.io.sh && ./install_docker.io.sh && rm -f install_docker.io.sh
	#// add current user (YOU) to docker group
	sudo gpasswd -a $(whoami) docker
	sudo service docker restart
 fi
echo " "
 echo -n "Webmin - install? - (Y/n) :" && read YESNO
 if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) || [ "$YESNO" == "" ] ; then
	#// add .list Repo's for Webmin IF NOT present
	if line=$(grep -s -m 1 -e "repository sarge contrib" /etc/apt/sources.list.d/webmin.list) ; then
	 echo "Webmin repo's in sources already."
	else
	 sudo sh -c "echo '#webmin repo:' > /etc/apt/sources.list.d/webmin.list"
	 sudo sh -c "echo 'deb http://download.webmin.com/download/repository sarge contrib' >> /etc/apt/sources.list.d/webmin.list"
	 sudo sh -c "echo 'deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib' >> /etc/apt/sources.list.d/webmin.list"
	 cd /root && sudo wget http://www.webmin.com/jcameron-key.asc && sudo apt-key add jcameron-key.asc
	fi
	 sudo apt-get update -y && sudo apt-get install webmin -y --force-yes
 fi
echo " "
fi
echo "-----------------------------------"
echo "DONE!" && echo " "

#// lynis SECURITY checks
echo -n "RUN * lynis * system security check? - (y/N) :" && read YESNO
if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) && [ "$YESNO" != "" ] ; then
	sudo lynis -c
fi

echo -n "Do you want to append bash commands immediately to history? not after logout - (y/N) :" && read YESNO
if ( echo $YESNO | grep -iq "Y\|Ye|\Yes" ) && [ "$YESNO" != "" ] ; then
 shopt -s histappend
fi
#EOF