BEGIN{
	FS=",";
	OFS=",";
	split(arr,m,",") 
}
{
	print $1 / m[1]
}
END{
}
