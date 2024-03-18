#Find file locked

To find PID and executable that is "locking" or "holding" a file

Edit target file in lock.ps1>line #1
	eg, $fileToCheck = "C:\log\sys_log.txt"
	$fileToCheck = "C:\log\BLAH_TEST.log"
	
Place both .cmd and .ps1 onto target and execute the cmd file

CMD file is needed to bypass any disabling of PowerShell scripts


Report Output will be found at location given at end of execution.

UPDATE:  
Linux `SH` file provided untested.