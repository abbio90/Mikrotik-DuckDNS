{
#----------SCRIPT INFORMATION---------------------------------------------------
#
# Script:  DUCKDNS script BY foisfabio.it
# Version: 2.0
# RouterOS v.7.11
# Created: 29/07/2020
# Updated: 03/09/2023
# Author:  Fabio Fois
# Website: https://foisfabio.it
# Email: consulenza@foisfabio.it

#----------MODIFY THIS SECTION AS NEEDED----------------------------------------


# DuckDNS Sub Domain
:local duckdnsSubDomain "mario-red.duckdns.org"

# DuckDNS Token
:local duckdnsToken "12345678-abcd-efgh-ilmno-pqrstuvz"

#SET ONLY IF YOU HAVE TWO STATIC PUBLIC IP'S
:local TwoStaticIP "yes";
:local ISP1Name "myNET"
:local ISP2Name "EOLO"
:local PublicIPISP1 "1.2.3.4"
:local PublicIPISP2 "5.6.7.8"
#------------------------------------------
#----------NO MODIFY THIS SECTION----------
#------------------------------------------
:local defaultISP
# Set true if you want to use IPv6
:local ipv6mode false;

# Online services which respond with your IPv4, two for redundancy
:local ipDetectService1 "https://api.ipify.org/"
:local ipDetectService2 "https://api4.my-ip.io/ip.txt"

# Online services which respond with your IPv6, two for redundancy
:local ipv6DetectService1 "https://api64.ipify.org"
:local ipv6DetectService2 "https://api6.my-ip.io/ip.txt"


#-------------------------------------------------------------------------------

:local previousIP; :local currentIP
# DuckDNS Full Domain (FQDN)
:local duckdnsFullDomain "$duckdnsSubDomain"

#:log warning message="START: DuckDNS.org DDNS Update"

if ($ipv6mode = true) do={
	:set ipDetectService1 $ipv6DetectService1;
	:set ipDetectService2 $ipv6DetectService2;
	:log error "DuckDNS: ipv6 mode enabled"
}

# Resolve current DuckDNS subdomain ip address
:do {:set previousIP [:resolve $duckdnsFullDomain]} 

# Detect our public IP adress useing special services
:do {:set currentIP ([/tool fetch url=$ipDetectService1 output=user as-value]->"data")} on-error={
		#Second try in case the first one is failed
		:do {:set currentIP ([/tool fetch url=$ipDetectService2 output=user as-value]->"data")} 
	};
	


:if ($currentIP != $previousIP) do={
	:local duckRequestUrl "https://www.duckdns.org/update\?domains=$duckdnsSubDomain&token=$duckdnsToken&ip=$currentIP&verbose=true"


	:local duckResponse
	:do {:set duckResponse ([/tool fetch url=$duckRequestUrl output=user as-value]->"data")} on-error={
		:delay 5m;
			:do {:set duckResponse ([/tool fetch url=$duckRequestUrl output=user as-value]->"data")} 
	}
    :if ($TwoStaticIP = yes) do={
	    :if ($currentIP = $PublicIPISP1) do={
		    :set $defaultISP $ISP1Name	} else={
				:if ($currentIP != $PublicIPISP1) do={
		        :set $defaultISP $ISP2Name	

	}
	    
}
}
:log warning "CONNESSIONE DI DEFAULT $defaultISP"
#:log warning message="END: DuckDNS.org DDNS Update finished"

}
}
