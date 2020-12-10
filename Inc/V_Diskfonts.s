************************************************************
*	
*	DISKFONT FUNCTIONS
*	
************************************************************
*	
*	XDEF Diskfonts_Open
*	XDEF Diskfonts_Close
*	XDEF Diskfonts_CenterIText
*	
************************************************************

	CNOP 0,4

ta_TextFont    EQU ta_SIZEOF

TextFontName1: DC.B 'Apparent.font',0
TextFontName2: DC.B 'Dina.font',0
TextFontName3: DC.B 'Condensed60.font',0

************************************************************

	CNOP 0,4

MyTextAttr1:   TEXTATTR TextFontName1,13,FSF_BOLD
MyTextAttr2:   TEXTATTR TextFontName2,10,FS_NORMAL
MyTextAttr3:   TEXTATTR TextFontName3,06,FS_NORMAL

************************************************************

	CNOP 0,4

Diskfonts_Open:
	movem.l    a6,-(sp)                        ; Push
.font1
	lea.l      MyTextAttr1(pc),a0              ; TextAttr
	CALLDF     OpenDiskFont                    ; (TextAttr)(a0)
	lea.l      MyTextAttr1(pc),a0              ; TextAttr
	move.l     d0,ta_TextFont(a0)              ; Store
.font2
	lea.l      MyTextAttr2(pc),a0              ; TextAttr
	CALLDF     OpenDiskFont                    ; (TextAttr)(a0)
	lea.l      MyTextAttr2(pc),a0              ; TextAttr
	move.l     d0,ta_TextFont(a0)              ; Store
.font3
	lea.l      MyTextAttr3(pc),a0              ; TextAttr
	CALLDF     OpenDiskFont                    ; (TextAttr)(a0)
	lea.l      MyTextAttr3(pc),a0              ; TextAttr
	move.l     d0,ta_TextFont(a0)              ; Store
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Diskfonts_Close:
	movem.l    a6,-(sp)                        ; Push
.font1
	lea.l      MyTextAttr1(pc),a0              ; TextAttr
	tst.l      ta_TextFont(a0)                 ; TextFont
	beq.s      .font2                          ; Skip
	move.l     ta_TextFont(a0),a1              ; TextFont
	CALLGRAF   CloseFont                       ; (TextFont)(a1)
.font2
	lea.l      MyTextAttr2(pc),a0              ; TextAttr
	tst.l      ta_TextFont(a0)                 ; TextFont
	beq.s      .font3                          ; Skip
	move.l     ta_TextFont(a0),a1              ; TextFont
	CALLGRAF   CloseFont                       ; (TextFont)(a1)
.font3
	lea.l      MyTextAttr3(pc),a0              ; TextAttr
	tst.l      ta_TextFont(a0)                 ; TextFont
	beq.s      .exit                           ; Skip
	move.l     ta_TextFont(a0),a1              ; TextFont
	CALLGRAF   CloseFont                       ; (TextFont)(a1)
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Diskfonts_CenterIText:
	movem.l    a2/a6,-(sp)                     ; Push
	lea.l      MyIText1(pc),a2                 ; First item
.loop
	tst.w      it_LeftEdge(a2)                 ; Zero ?
	bne.s      .next                           ; Skip
	move.l     MyWindow(pc),a1                 ; Window
	move.l     wd_RPort(a1),a1                 ; RastPort
	move.l     it_ITextFont(a2),a0             ; IText->TextAttr
	move.l     ta_TextFont(a0),a0              ; TextFont
	tst.l      a0
	beq.s      .next
	CALLGRAF   SetFont                         ; (RastPort,TextFont)(a1,a0)
	move.l     it_IText(a2),a0                 ; IText->string
	moveq.l    #-1,d0                          ; Reset count
.size
	addq.l     #1,d0                           ; Count++
	tst.b      (a0)+                           ; Test char
	bne.s      .size                           ; Next char
	move.l     MyWindow(pc),a1                 ; Window
	move.l     wd_RPort(a1),a1                 ; RastPort
	move.l     it_IText(a2),a0                 ; IText->string
	CALLGRAF   TextLength                      ; (RastPort,String,Count)(a1,a0,d0)
	move.w     #WIN_WIDTH,d1                   ; (W)
	sub.w      d0,d1                           ; (W-w)
	lsr.w      #1,d1                           ; (W-w)/2
	move.w     d1,it_LeftEdge(a2)              ; IText->LeftEdge
.next
	move.l     it_NextText(a2),a2              ; Next item
	tst.l      a2                              ; Last item ?
	bne.s      .loop                           ; Continue
	movem.l    (sp)+,a2/a6                     ; Pop
	rts                                        ; Return

************************************************************
