
main:
	lea.l   StrValue1(pc),a0
	bsr     ParseNum
	bkpt    #1
	rts

StrValue1:  DC.B '0'-1,0
StrValue2:  DC.B "0",0
StrValue3:  DC.B "6",0
StrValue4:  DC.B "1258a",0

;==========================================================
; ParseHexa (String to Number)
; Input  : A0 => Null-terminating string
; Output : D0 => 32-bit number
; Output : D1 => 0=Success, 1=Invalid
;==========================================================

	CNOP 0,4
ParseNum:
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
