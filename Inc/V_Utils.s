************************************************************
*	
*	UTILS FUNCTIONS
*	
************************************************************
*	
*	XDEF GetTaskName
*	XDEF RawDoFmtCallback
*	
************************************************************

	CNOP 0,4

GetTaskName:
	movem.l    d2/a6,-(sp)                     ; Push
	suba.l     a1,a1                           ; Name
	CALLEXEC   FindTask                        ; (Name)(a1)
	move.l     d0,a0                           ; Process
	move.l     LN_NAME(a0),d0                  ; Process->Name
	move.l     pr_CLI(a0),d1                   ; Process->CLI
	beq.s      .exit                           ; Null ?
	lea.l      .buffer(pc),a0                  ; Buffer
	move.l     a0,d1                           ; Buffer
	move.l     #256,d2                         ; Length
	CALLDOS    GetProgramName                  ; (Buffer,Length)(d1,d2)
	lea.l      .buffer(pc),a0                  ; Buffer
	move.l     a0,d0                           ; Result
.exit
	movem.l    (sp)+,d2/a6                     ; Pop
	rts                                        ; Return
.buffer        ds.b 256                        ; Buffer

************************************************************

	CNOP 0,4

RawDoFmtCallback:
	move.b     d0,(a3)+                        ; Push char
	rts                                        ; Return

************************************************************

