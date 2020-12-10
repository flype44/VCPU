************************************************************
*	
*	TOOLTYPES FUNCTIONS
*	
************************************************************
*	
*	XDEF ToolTypes_Load
*	XDEF ToolTypes_Save
*	
************************************************************

	CNOP 0,4

TTYes:         DC.B "Yes",0
TTNo:          DC.B "No",0
TTPosX:        DC.B "Left",0
TTPosY:        DC.B "Top",0
TTBackdrop:    DC.B "Backdrop",0
TTBorderless:  DC.B "Borderless",0
TTRefreshRate: DC.B "RefreshRate",0
TTSkin:        DC.B "Skin",0

************************************************************

	CNOP 0,4

ToolTypes_Load:
	movem.l    d2-d7/a2-a6,-(sp)               ; pop
	move.l     WBStartMsg(pc),a2               ; WBStartMsg
	tst.l      a2                              ; null ?
	bne.s      .wbstart                        ; 
	lea.l      APP_NAME(pc),a0                 ; name
	bra.s      .geticon                        ; 
.wbstart
	move.l     sm_ArgList(a2),a3               ; Msg->Arg[0]
	move.l     wa_Lock(a3),d1                  ; Msg->Arg[0]->Lock
	CALLDOS    CurrentDir                      ; (lock)(a0)
	move.l     wa_Name(a3),a0                  ; name
.geticon
	CALLICON   GetDiskObject                   ; (name)(a0)
	tst.l      d0                              ; DiskObject
	beq        .exit                           ; skip
	move.l     d0,a0                           ; DiskObject
	move.l     d0,a5                           ; DiskObject
.tt0
	move.l     do_ToolTypes(a5),a0             ; toolTypeArray
	lea.l      TTBackdrop(pc),a1               ; typeName
	CALLICON   FindToolType                    ; (arr,name)(a0,a1)
	move.l     d0,a0                           ; string1
	lea.l      TTYes(pc),a1                    ; string2
	CALLUTIL   Stricmp                         ; (str1,str2)(a0,a1)
	beq        .backdropYes                    ; Yes
	bra        .backdropNo                     ; No
.tt1
	move.l     do_ToolTypes(a5),a0             ; toolTypeArray
	lea.l      TTBorderless(pc),a1             ; typeName
	CALLICON   FindToolType                    ; (arr,name)(a0,a1)
	move.l     d0,a0                           ; string1
	lea.l      TTYes(pc),a1                    ; string2
	CALLUTIL   Stricmp                         ; (str1,str2)(a0,a1)
	beq        .borderlessYes                  ; Yes
	bra        .borderlessNo                   ; No
.tt2
	move.l     do_ToolTypes(a5),a0             ; toolTypeArray
	lea.l      TTRefreshRate(pc),a1            ; typeName
	CALLICON   FindToolType                    ; (arr,name)(a0,a1)
	move.l     d0,a0                           ; string
	tst.l      d0                              ; null ?
	beq.s      .tt3                            ; skip
	bsr        ParseNumber                     ; parse
	tst.l      d1                              ; error ?
	bne.s      .tt3                            ; skip
	move.l     d0,d2                           ; 
	bsr        MenuItem_Setting_RefreshRate    ; 
.tt3
	move.l     do_ToolTypes(a5),a0             ; toolTypeArray
	lea.l      TTSkin(pc),a1                   ; typeName
	CALLICON   FindToolType                    ; (arr,name)(a0,a1)
	move.l     d0,a0                           ; string
	tst.l      d0                              ; null ?
	beq.s      .tt4                            ; skip
	bsr        ParseNumber                     ; parse
	tst.l      d1                              ; error ?
	bne.s      .tt4                            ; skip
	cmp.w      #7,d0                           ; max ?
	bgt.s      .tt4                            ; skip
	lea.l      FileWinBG(pc),a0                ; background
	lea.l      SkinArray(pc),a1                ; table
	move.l     (a1,d0.w*4),(a0)                ; store new
.tt4
	move.l     do_ToolTypes(a5),a0             ; toolTypeArray
	lea.l      TTPosX(pc),a1                   ; typeName
	CALLICON   FindToolType                    ; (arr,name)(a0,a1)
	move.l     d0,a0                           ; string
	tst.l      d0                              ; null ?
	beq.s      .tt5                            ; skip
	bsr        ParseNumber                     ; parse
	tst.l      d1                              ; error ?
	bne.s      .tt5                            ; skip
	lea.l      MyWindowX(pc),a0                ; window left
	move.l     d0,(a0)                         ; window left
.tt5
	move.l     do_ToolTypes(a5),a0             ; toolTypeArray
	lea.l      TTPosY(pc),a1                   ; typeName
	CALLICON   FindToolType                    ; (arr,name)(a0,a1)
	move.l     d0,a0                           ; string
	tst.l      d0                              ; null ?
	beq.s      .tt6                            ; skip
	bsr        ParseNumber                     ; parse
	tst.l      d1                              ; error ?
	bne.s      .tt6                            ; skip
	lea.l      MyWindowY(pc),a0                ; window top
	move.l     d0,(a0)                         ; window top
.tt6
.free
	move.l     a5,a0                           ; DiskObject
	CALLICON   FreeDiskObject                  ; (DiskObject)(a0)

.exit
	movem.l    (sp)+,d2-d7/a2-a6               ; pop
	rts                                        ; return

.backdropNo
	lea.l      MyOpenWindowTags(pc),a0         ; taglist
	move.l     #0,4+(06*8)(a0)                 ; taglist[] -> WA_Backdrop
	bra        .tt1                            ; return

.backdropYes
	lea.l      MyOpenWindowTags(pc),a0         ; taglist
	move.l     #1,4+(06*8)(a0)                 ; taglist[] -> WA_Backdrop
	bra        .tt1                            ; return

.borderlessNo
	lea.l      MyOpenWindowTags(pc),a0         ; taglist
	move.l     #0,4+(07*8)(a0)                 ; taglist[] -> WA_Borderless
	move.l     #1,4+(08*8)(a0)                 ; taglist[] -> WA_CloseGadget
	move.l     #1,4+(09*8)(a0)                 ; taglist[] -> WA_DepthGadget
	move.l     #1,4+(10*8)(a0)                 ; taglist[] -> WA_DragBar
	bra        .tt2                            ; return

.borderlessYes
	lea.l      MyOpenWindowTags(pc),a0         ; taglist
	move.l     #1,4+(07*8)(a0)                 ; taglist[] -> WA_Borderless
	move.l     #0,4+(08*8)(a0)                 ; taglist[] -> WA_CloseGadget
	move.l     #0,4+(09*8)(a0)                 ; taglist[] -> WA_DepthGadget
	move.l     #0,4+(10*8)(a0)                 ; taglist[] -> WA_DragBar
	bra        .tt2                            ; return

************************************************************

	CNOP 0,4

ToolTypes_Save:
	movem.l    d2-d7/a2-a6,-(sp)               ; Push
	nop
	nop
	nop
.exit
	movem.l    (sp)+,d2-d7/a2-a6               ; Pop
	rts                                        ; Return

************************************************************
