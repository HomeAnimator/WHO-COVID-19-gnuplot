#!/usr/bin/env bash
#export tm=2021-05-26.16_50_35
export tm=`date +%Y-%m-%d.%H_%M_%S`
mkdir -p ${tm}
cd  ${tm}
curl https://covid19.who.int/WHO-COVID-19-global-data.csv > WHO-COVID-19-global-data.${tm}.csv
../no_declimer.sh WHO-COVID-19-global-data.${tm}.csv > WHO-COVID-19-global-data.${tm} 
../sum.WHO.5678.sh WHO-COVID-19-global-data.${tm} > WHO-COVID-19-global-data.${tm}.sum.5678  &
awk -F '|' '{print $2}'  WHO-COVID-19-global-data.${tm} | sort | uniq > WHO-COVID-19-global-data.${tm}.Country_Code.csv &
awk -F '|' '{print $2,$3}'  WHO-COVID-19-global-data.${tm} | sort | uniq > WHO-COVID-19-global-data.${tm}.Country_Code_Name.csv &
wait
awk '{a=FILENAME;b=a;gsub("[.]Country_Code.csv","",a);gsub("Country_Code.csv",$1,b);;if(length($0)==2) printf "grep \"|%s|\" %s > %s.data \n",$1,a,b}'  WHO-COVID-19-global-data.${tm}.Country_Code.csv | bash &
wait 
for i in WHO-COVID-19-global-data.${tm}.[A-Z][A-Z].data ;
do 

	export CC1=${i%%.data}
	export CC=${CC1##WHO-COVID-19-global-data.${tm}.} 
	echo ${CC}


	awk 'BEGIN{FS="|";OFS=","}{printf "%s\n",$5}' $i >${i%%.data}.1.data & 
	awk 'BEGIN{FS="|";OFS=","}{printf "%s\n",$6}' $i >${i%%.data}.2.data &
	awk 'BEGIN{FS="|";OFS=","}{printf "%s\n",$7}' $i >${i%%.data}.3.data &
	awk 'BEGIN{FS="|";OFS=","}{printf "%s\n",$8}' $i >${i%%.data}.4.data &
	awk 'BEGIN{FS="|";OFS=","}{if($5==0) printf "0\n";else printf "%s\n",$7/$5}' $i >${i%%.data}.5.data &
	awk 'BEGIN{FS="|";OFS=","}{if($6==0) printf "0\n";else printf "%s\n",$8/$6}' $i >${i%%.data}.6.data &

	wait

	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.data}.1.png\" ;\n plot \"${i%%.data}.1.data\"  with lines title \"${CC}1\"\n" > data1 & 
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.data}.2.png\" ;\n plot \"${i%%.data}.2.data\"  with lines title \"${CC}2\" \n" > data2 & 
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.data}.3.png\" ;\n plot \"${i%%.data}.3.data\"  with lines title \"${CC}3\" \n" > data3 & 
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.data}.4.png\" ;\n plot \"${i%%.data}.4.data\"  with lines title \"${CC}4\" \n" > data4 & 
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.data}.5.png\" ;\n plot \"${i%%.data}.5.data\"  with lines title \"${CC}5\"\n" > data5 & 
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.data}.6.png\" ;\n plot \"${i%%.data}.6.data\"  with lines title \"${CC}6\" \n" > data6 & 
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.data}.0.png\" ;\n plot \"${i%%.data}.01.data\"  with lines title \"${CC}1\" , \"${i%%.data}.02.data\" with lines title \"${CC}2\" , \"${i%%.data}.03.data\"  with lines title \"${CC}3\", \"${i%%.data}.04.data\" with lines title \"${CC}4\", \"${i%%.data}.05.data\"  with lines title \"${CC}5\", \"${i%%.data}.06.data\"  with lines title \"${CC}6\"\n " > data0  & 

	awk -v arr=`awk   -f ../a.awk ${i%%.data}.1.data` -f ../b.awk   ${i%%.data}.1.data > ${i%%.data}.01.data &
	awk -v arr=`awk   -f ../a.awk ${i%%.data}.2.data` -f ../b.awk   ${i%%.data}.2.data > ${i%%.data}.02.data &
	awk -v arr=`awk   -f ../a.awk ${i%%.data}.3.data` -f ../b.awk   ${i%%.data}.3.data > ${i%%.data}.03.data &
	awk -v arr=`awk   -f ../a.awk ${i%%.data}.4.data` -f ../b.awk   ${i%%.data}.4.data > ${i%%.data}.04.data &
	awk -v arr=`awk   -f ../a.awk ${i%%.data}.5.data` -f ../b.awk   ${i%%.data}.5.data > ${i%%.data}.05.data &
	awk -v arr=`awk   -f ../a.awk ${i%%.data}.6.data` -f ../b.awk   ${i%%.data}.6.data > ${i%%.data}.06.data &
	wait
	gnuplot data0 &
	gnuplot data1 &
	gnuplot data2 &
	gnuplot data3 &
	gnuplot data4 &
	gnuplot data5 &
	gnuplot data6 &
	wait
done
cd ../


