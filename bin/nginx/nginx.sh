#!/bin/bash
function setNginxHost(){
    substitute-env-vars.sh /etc /etc/default.conf.tmpl;
    cp -v /etc/default.conf /etc/nginx/conf.d/default.conf;
}

function runForever() {
	while :
	do
		sleep 1
	done
}

setNginxHost &&
service nginx start &&
runForever
exit 0