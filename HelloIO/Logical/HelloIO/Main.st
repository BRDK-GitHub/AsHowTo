
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	do1 := FALSE;
	do2 := FALSE;
	do3 := FALSE;
	do4 := FALSE;
	do5 := FALSE;
	do6 := FALSE;
	
	CASE state OF
		0:
			do1 := TRUE;
			state := 5;
		5:
			do2 := TRUE;
			state := 10;
		10:
			do3 := TRUE;
			state := 15;
		15:
			do4 := TRUE;
			state := 20;
		20:
			do5 := TRUE;
			state := 25;
		25:
			do6 := TRUE;
			state := 0;		
	END_CASE
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

