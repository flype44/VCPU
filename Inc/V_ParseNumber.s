************************************************************
*	
*	PARSE FUNCTIONS
*	
************************************************************
*	
*	XDEF ParseNumber
*	
************************************************************

	CNOP 0,4

ParseNumber:
	;-------------------------------------------------------
	; ParseNumber (String to Number)
	; Input  : A0 => Null-terminating string
	; Output : D0 => 32-bit number
	; Output : D1 => 0=Success, 1=Invalid
	;-------------------------------------------------------
	move.l     a0,-(sp)                ; Push
	moveq.l    #0,d0                   ; Reset result
	moveq.l    #0,d1                   ; Reset char
.loop
	move.b     (a0)+,d1                ; Read char
	beq.s      .success                ; Exit if Null-char
.getc
	cmpi.b     #'0',d1                 ; x < '0'
	blt.s      .invalid                ; 
	cmpi.b     #'9',d1                 ; x > '9'
	bgt.s      .invalid                ; 
	subi.b     #'0',d1                 ; 0..9
	mulu.l     #10,d0                  ; Result * 10
	add.l      d1,d0                   ; Result + Digit
	bra.s      .loop                   ; Next char
.invalid
	moveq.l    #1,d1                   ; Invalid
	bra.s      .exit                   ; 
.success
	moveq.l    #0,d1                   ; Success
.exit
	move.l     (sp)+,a0                ; Pop
	rts                                ; Return

************************************************************
