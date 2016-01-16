#bento/centos-6.7
#vagrant ssh-config --host kyaw >> ~/.ssh/config
#config.vm.provision :shell, :path => "bash.sh"
yum -y update
yum -y install httpd
service httpd start
chkconfig httpd on
service iptables stop
chkconfig iptables off
yum -y install php php-devel php-mysql php-mbstring php-gd
yum -y install vim
yum -y install git
yum -y install curl
yum -y install mysql-server
cp /etc/php.ini /etc/php.ini.org
cp php.ini.txt /etc/php.ini
cp /etc/localtime /etc/localtime.org
ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
cp httpd.conf.txt /etc/httpd/conf/httpd.conf
service httpd restart
cp /etc/my.cnf /etc/my.cnf.org
cp my.cnf.txt /etc/my.cnf
service mysqld restart
chkconfig mysqld on
cp clock.txt /etc/sysconfig/clock
#rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
#yum install php55w php55w-opcache
#yum install yum-plugin-replace
#yum replace php-common --replace-with=php55w-common
