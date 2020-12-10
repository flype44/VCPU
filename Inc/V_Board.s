************************************************************
*	
*	BOARD FUNCTIONS
*	
************************************************************
*	
*	XDEF Board_GetModelID
*	XDEF Board_GetModelString
*	XDEF Board_GetSerialNumber
*	
************************************************************

	CNOP 0,4

BoardArray:
	DC.L StrBoard0,StrBoard1
	DC.L StrBoard2,StrBoard3
	DC.L StrBoard4,StrBoard5
	DC.L StrBoard6,StrBoard7

StrBoard0:     DC.B "Vxxx",0
StrBoard1:     DC.B "V600",0
StrBoard2:     DC.B "V500",0
StrBoard3:     DC.B "·V4·",0
StrBoard4:     DC.B "V666",0
StrBoard5:     DC.B "V4SA",0
StrBoard6:     DC.B "V1K2",0
StrBoard7:     DC.B "Vxxx",0

************************************************************

	CNOP 0,4

Board_GetModelID:
	movem.l    d2/d3/d4/a6,-(sp)               ; Push
.exit
	movem.l    (sp)+,d2/d3/d4/a6               ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Board_GetModelString:
	movem.l    d2/d3/d4/a6,-(sp)               ; Push
.exit
	movem.l    (sp)+,d2/d3/d4/a6               ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Board_GetSerialNumber:
	movem.l    d2/d3/d4/a6,-(sp)               ; Push
.exit
	movem.l    (sp)+,d2/d3/d4/a6               ; Pop
	rts                                        ; Return

************************************************************
