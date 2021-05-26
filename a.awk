BEGIN{
	FS=",";
	OFS=",";
	m=0;
}
{
	if( m < $1 ) m=$1
}
END{
	if( m==0 ) m=1
	print m
}
