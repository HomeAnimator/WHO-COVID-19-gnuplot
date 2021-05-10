#!/usr/bin/env bash 
gawk '{ l=length($0); d=0; for(i=1;i<=l;i++){ s=substr($0,i,1);if(s=="\x22") {d=d+1;} if(s==",") {if(d%2==1) printf ",";else printf "|" }else printf "%s", s }; print "" }' ${1}
