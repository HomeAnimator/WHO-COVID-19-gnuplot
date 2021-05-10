#!/usr/bin/env bash 
for i in `awk -F '|'  '/[0123456789-]{2}/{print $1}'  ${1} | sort | uniq | awk '{printf "%s ",$0}'` ;do  gawk -F '|' -v aaaa=$i  'BEGIN{s5=0;s6=0;s7=0;s8=0}{if($1==aaaa) { s5+=$5; s6+=$6; s7+=$7; s8+=$8 }}END{print aaaa "|"s5 "|"s6 "|"s7 "|"s8 }' ${1} ; done
