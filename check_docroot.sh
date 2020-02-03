#!/bin/bash

# Script to check Document Root of domains in cPanel and CWP
# Author: Ananda Raj
# Date: 08 Sep 2019

DOMAIN=$1
CP_HTTP_CONF=/usr/local/apache/conf/httpd.conf
CWP_HTTP_CONF=/usr/local/apache/conf.d/vhosts

##For cPanel
if [ -f "/usr/local/cpanel/cpanel" ]; then
	{
        echo "CPANEL VERSION: `/usr/local/cpanel/cpanel -V`"
	if [ -z $DOMAIN ]; then
		read -p "Enter domain name: " DOMAIN
		if [ -z $DOMAIN ]; then
			echo "ERROR: Required Data Missing!"
		exit 1
		fi
	fi
	
	DOC_ROOT=`grep -A2 " $DOMAIN" $CP_HTTP_CONF | grep DocumentRoot | awk {'print $2'} | awk 'NR == 1'`

	if [ "$DOC_ROOT" ]; then
		echo "Document Root of $DOMAIN: $DOC_ROOT"
	else
		echo "ERROR: Domain $DOMAIN not found in this server!"
	fi
	}


##For CWP
elif [ -f "/usr/local/cwpsrv/htdocs/resources/admin/include/version.php" ]; then
	{
        echo "CWP VERSION: `grep version /usr/local/cwpsrv/htdocs/resources/admin/include/version.php | awk '{print $NF}'| tr -d '"|;'`"
	if [ -z $DOMAIN ];
		then
		read -p "Enter domain name: " DOMAIN;
		if [ -z $DOMAIN ];
		        then
		        echo "ERROR: Required Data Missing!";
		exit 1;
		fi
	fi

	DOC_ROOT=`grep DocumentRoot $CWP_HTTP_CONF/$DOMAIN.conf 2> /dev/null | awk '{print $2}'`;
	
	if [ "$DOC_ROOT" ]; then
	        echo "Document Root of $DOMAIN: $DOC_ROOT";
	else
	        echo "ERROR: Domain $DOMAIN not found in this server!";
	fi
	}


##Others
else
        echo -e "\nCouldn't Find cPanel / CWP\n"
fi

