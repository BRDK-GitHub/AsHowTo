
PROGRAM _INIT
	(* Insert code here *)
	data := 'Hello, I am some data that would like to be written to a file';
	fileName := 'testFile.txt';
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	CASE state OF
		0:
			// base case
			// waiting for command
			IF writeFile THEN
				writeFile := FALSE;
				state := 10;
			END_IF
			
			IF readFile THEN
				readFile := FALSE;
				state := 40;
			END_IF
			
			IF deleteFile THEN
				deleteFile := FALSE;
				state := 70;
			END_IF
			
		10:
			// open file
			FileOpen_0.enable 	:= TRUE;
			FileOpen_0.pDevice 	:= ADR('F');
			FileOpen_0.pFile 	:= ADR(fileName);
			FileOpen_0.mode 	:= fiREAD_WRITE;
			state := 15;
			
		15:
			// wait for response
			ident := FileOpen_0.ident;
			IF FileOpen_0.status = fiERR_FILE_NOT_FOUND THEN
				FileOpen_0.enable := FALSE;
				state := 20;
			ELSIF FileOpen_0.status = ERR_FUB_BUSY THEN
				// wait
			ELSIF FileOpen_0.status = ERR_OK THEN
				FileOpen_0.enable := FALSE;
				state := 30;
			ELSE // error
				FileOpen_0.enable := FALSE;
				state := 99;
			END_IF
			
		20:
			// create file
			FileCreate_0.enable		:= TRUE;
			FileCreate_0.pDevice 	:= ADR('F');
			FileCreate_0.pFile 		:= ADR(fileName);
			state := 25;
			
		25:
			// wait for creating
			ident := FileCreate_0.ident;
			IF FileCreate_0.status = ERR_FUB_BUSY THEN
				// wait
			ELSIF FileCreate_0.status = ERR_OK THEN
				FileCreate_0.enable	:= FALSE;
				state := 30;
			ELSE // error
				FileCreate_0.enable	:= FALSE;
				state := 99;	
			END_IF
			
			
		30:
			// write file
			FileWrite_0.enable := TRUE;
			FileWrite_0.ident := ident;
			FileWrite_0.pSrc := ADR(data);
			FileWrite_0.len := LEN(data); // could also be SIZEOF depending on the datatype
			state := 35;
			
		35:
			// waiting for writing
			IF FileWrite_0.status = ERR_FUB_BUSY THEN
				// wait
			ELSIF FileWrite_0.status = ERR_OK THEN
				FileWrite_0.enable := FALSE;
				state := 60;
			ELSE 
				FileWrite_0.enable := FALSE;
				state := 99;
			END_IF
			
		40:
			// read file
			// open file
			FileOpen_0.enable 	:= TRUE;
			FileOpen_0.pDevice 	:= ADR('F');
			FileOpen_0.pFile 	:= ADR(fileName);
			FileOpen_0.mode 	:= fiREAD_ONLY;
			state := 45;
			
		45:
			// wait for response
			ident := FileOpen_0.ident;
			IF FileOpen_0.status = fiERR_FILE_NOT_FOUND THEN
				FileOpen_0.enable := FALSE;
				state := 99;
			ELSIF FileOpen_0.status = ERR_FUB_BUSY THEN
				// wait
			ELSIF FileOpen_0.status = ERR_OK THEN
				state := 50;
			ELSE // error
				FileOpen_0.enable := FALSE;
				state := 99;
			END_IF
			
		50:
			FileRead_0.enable 	:= TRUE;
			FileRead_0.ident 	:= ident;
			FileRead_0.len 		:= FileOpen_0.filelen;
			FileRead_0.pDest 	:= ADR(data);
			state := 60;
			
		60:
			// close file
			FileClose_0.enable 	:= TRUE;
			FileClose_0.ident 	:= ident;
			state := 65;
			
		65:
			IF FileClose_0.status = ERR_FUB_BUSY THEN
				// wait
			ELSIF FileClose_0.status = ERR_OK THEN
				FileClose_0.enable := FALSE;
				state := 0;
			ELSE
				state := 99;
			END_IF
			
		70:
			// delete file
			FileDelete_0.enable 	:= TRUE;
			FileDelete_0.pDevice 	:= ADR('F');
			FileDelete_0.pName 		:= ADR(fileName);
			state := 75;
			
		75:
			IF FileDelete_0.status = ERR_FUB_BUSY THEN
				// wait	
			ELSIF FileDelete_0.status = ERR_OK THEN
				FileDelete_0.enable := FALSE;
				state := 0;
			ELSE
				state := 99;
			END_IF
			
			
		99:
		// error
			IF clear THEN
				clear 				:= FALSE;
				FileOpen_0.enable 	:= FALSE;
				FileCreate_0.enable := FALSE;
				FileWrite_0.enable 	:= FALSE;
				FileRead_0.enable 	:= FALSE;
				FileClose_0.enable 	:= FALSE;
				FileDelete_0.enable := FALSE;
			END_IF
	END_CASE	

	FileOpen_0();
	FileCreate_0();
	FileWrite_0();
	FileRead_0();
	FileClose_0();
	FileDelete_0();
	
	DirInfo_0.pDevice := ADR(deviceName);
	DirInfo_0.pPath := ADR(dirName);
	DirInfo_0();
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

