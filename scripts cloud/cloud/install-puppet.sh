#!/usr/bin/bash

VERS=$1

if [[ -z $VERS ]]
then
    VERSION=7
else
    VERSION=$VERS
fi

echo "10.10.1.7       srvpuppetmaster.aaa.ccfa" >> /etc/hosts
echo "10.10.1.92      yum.aaa.ccfa" >> /etc/hosts

cd ~ 

hostn=`hostname -s`
re="^([^-]+)-(.*)$"
[[ $hostn =~ $re  ]] && var1="${BASH_REMATCH[1]}" && var2="${BASH_REMATCH[2]}" 
if [[ -z $var2 ]]
then
    env="production"
elif [ $var2 = dev ] || [ $var2 = int ]
then
    env="developpement"
elif [ $var2 = tst ]
then
    env="test"
elif [ $var2 = rec ]
then
    env="recette"
fi

if [[ -n $env ]]
then
    cd /etc/yum.repos.d/ && wget http://yum.aaa.ccfa/rhel-puppetlabs-${VERSION}-x86_64.repo -O puppetlabs.repo
    yum -y install puppet
    puppet agent -t --pluginsync --server=srvpuppetmaster.aaa.ccfa --certname=`hostname -s`.aaa.ccfa --environment=$env --waitforcert 60 --tags aaa::puppetclient
    puppet agent -t --pluginsync --server=srvpuppetmaster.aaa.ccfa --certname=`hostname -s`.aaa.ccfa --environment=$env --tags aaa::puppetclient
    puppet agent -t --pluginsync --server=srvpuppetmaster.aaa.ccfa --certname=`hostname -s`.aaa.ccfa --environment=$env --tags yum
    puppet agent -t --pluginsync --server=srvpuppetmaster.aaa.ccfa --certname=`hostname -s`.aaa.ccfa --environment=$env --tags aaa::users::deploy
    puppet agent -t --pluginsync --server=srvpuppetmaster.aaa.ccfa --certname=`hostname -s`.aaa.ccfa --environment=$env
fi
