#java download
yum -y install java-1.8.0-openjdk.x86_64

#elasticsearch download
rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch
cp elasticsearch.repo.txt /etc/yum.repos.d/elasticsearch.repo
yum -y install elasticsearch-1.7.0
chkconfig --add elasticsearch
chkconfig elasticsearch on
service elasticsearch start
service elasticsearch status
#curl 'http://localhost:9200/?pretty'

#plugin
/usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.7.0
/usr/share/elasticsearch/bin/plugin -install elasticsearch/marvel/latest
/usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-kuromoji/2.3.0
/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
