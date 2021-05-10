#!/usr/bin/env bash
export tm=`date +%Y-%m-%d.%H_%M_%S`
mkdir -p ${tm}
curl https://covid19.who.int/WHO-COVID-19-global-data.csv > ${tm}/WHO-COVID-19-global-data.${tm}.csv
./no_declimer.sh ${tm}/WHO-COVID-19-global-data.${tm}.csv > ${tm}/WHO-COVID-19-global-data.${tm}
./sum.WHO.5678.sh ${tm}/WHO-COVID-19-global-data.${tm} > ${tm}/WHO-COVID-19-global-data.${tm}.sum.5678 
awk -F ',' '{print $2}'  ${tm}/WHO-COVID-19-global-data.${tm}.csv | sort | uniq > ${tm}/WHO-COVID-19-global-data.${tm}.Country_Code.csv
awk '{a=FILENAME;b=a;gsub("[.]Country_Code","",a);gsub("Country_Code",$1,b);;if(length($0)==2) printf "grep \",%s,\" %s > %s \n",$1,a,b}'  ${tm}/WHO-COVID-19-global-data.${tm}.Country_Code.csv | bash
cd  ${tm}
for i in WHO-COVID-19-global-data.${tm}.[A-Z][A-Z].csv ;
do 
	awk -F ',' '{printf "%s\n",$5}' $i >${i%%.csv}.1.csv
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.csv}.1.png\" ;\n plot \"${i%%.csv}.1.csv\"  with lines\n" > data1
	gnuplot data1 &
	awk -F ',' '{printf "%s\n",$6}' $i >${i%%.csv}.2.csv
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.csv}.2.png\" ;\n plot \"${i%%.csv}.2.csv\"  with lines\n" > data2
	gnuplot data2 &
	awk -F ',' '{printf "%s\n",$7}' $i >${i%%.csv}.3.csv
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.csv}.3.png\" ;\n plot \"${i%%.csv}.3.csv\"  with lines\n" > data3
	gnuplot data3 &
	awk -F ',' '{printf "%s\n",$8}' $i >${i%%.csv}.4.csv
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.csv}.4.png\" ;\n plot \"${i%%.csv}.4.csv\"  with lines\n" > data4
	gnuplot data4 &
	awk -F ',' '{if($5==0) printf "0\n";else printf "%s\n",$7/$5}' $i >${i%%.csv}.5.csv
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.csv}.5.png\" ;\n plot \"${i%%.csv}.5.csv\"  with lines\n" > data5
	gnuplot data5 &
	awk -F ',' '{if($6==0) printf "0\n";else printf "%s\n",$8/$6}' $i >${i%%.csv}.6.csv
	echo -e "set term png size 1920 ,1080;\nset output \"${i%%.csv}.6.png\" ;\n plot \"${i%%.csv}.6.csv\"  with lines\n" > data6
	gnuplot data6 &
	wait
done
cd ../


