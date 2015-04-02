copy C:\Users\o_belyanski\Desktop\*.doc D:\TZ\Archive\
	if exist \\AL\_tz_qa_2015\2015\*.doc GOTO Last 
move C:\Users\o_belyanski\Desktop\*.doc D:\TZ\Upload_TZ\
GOTO EOF
	:Last
copy C:\Users\o_belyanski\Desktop\*.doc D:\TZ\Archive\
copy C:\Users\o_belyanski\Desktop\*.doc D:\TZ\Upload_TZ\
move D:\TZ\Upload_TZ\*.doc \\AL\_tz_qa_2015\2015\
	:EOF
