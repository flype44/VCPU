************************************************************
* 
* Program:      VCPU
* Short:        Vampire CPU monitor tool.
* Author:       flype
* Type:         util/moni
* Version:      0.1 (Novembre 2019)
* Architecture: m68k-amigaos
* Requires:     AmigaOS V36+, AC68080
* Copyright:    (C) 2016-2019 APOLLO-Team
* Compiler:     HiSoft Devpac 3.18 for AmigaOS
* 
************************************************************
* 
* TODO:
* 
* [X] CPU revision
* [X] IPC: 0.00 instead of 000%
* [X] Menu->Settings->Skins...
* [X] Menu->Settings->Backdrop
* [X] Menu->Settings->Borderless
* [X] Menu->Settings->RefreshRate
* [X] ToolTypes Load
* [_] ToolTypes Save
* [_] Iconify
* [X] Commodity General
* [_] Commodity HotKeys
* [_] Skin engine
* 
************************************************************

	INCDIR     progdir:include/

	; AmigaOS libraries

	INCLUDE    dos/dos.i
	INCLUDE    dos/dosextens.i
	INCLUDE    dos/dos_lib.i
	INCLUDE    exec/exec.i
	INCLUDE    exec/exec_lib.i
	INCLUDE    devices/timer.i
	INCLUDE    devices/timer_lib.i
	INCLUDE    diskfont/diskfont.i
	INCLUDE    diskfont/diskfont_lib.i
	INCLUDE    graphics/gfxbase.i
	INCLUDE    graphics/rastport.i
	INCLUDE    graphics/graphics_lib.i
	INCLUDE    graphics/text.i
	INCLUDE    intuition/intuition.i
	INCLUDE    intuition/intuition_lib.i
	INCLUDE    libraries/amigaguide.i
	INCLUDE    libraries/amigaguide_lib.i
	INCLUDE    libraries/commodities.i
	INCLUDE    libraries/commodities_lib.i
	INCLUDE    libraries/gadtools.i
	INCLUDE    libraries/gadtools_lib.i
	INCLUDE    utility/utility.i
	INCLUDE    utility/utility_lib.i
	INCLUDE    workbench/icon_lib.i
	INCLUDE    workbench/startup.i
	INCLUDE    workbench/workbench.i

	; Third-party libraries

	INCLUDE    inc/guigfx.i
	INCLUDE    inc/guigfx_lib.i
	INCLUDE    inc/reqtools.i
	INCLUDE    inc/reqtools_lib.i
	INCLUDE    inc/screennotify.i
	INCLUDE    inc/screennotify_lib.i
	INCLUDE    inc/vampire.i
	INCLUDE    inc/vampire_lib.i
	INCLUDE    inc/V_MACROS.i

************************************************************
*
* CONSTANTS
*
************************************************************

WIN_LEFT       EQU   0
WIN_TOP        EQU  18
WIN_WIDTH      EQU 200
WIN_HEIGHT     EQU 200

************************************************************
*
* STRUCTURES
*
************************************************************

	RSRESET
ggt_Tag0        RS.L 1
ggt_SrcX        RS.L 1
ggt_Tag1        RS.L 1
ggt_SrcY        RS.L 1
ggt_Tag2        RS.L 1
ggt_SrcW        RS.L 1
ggt_Tag3        RS.L 1
ggt_SrcH        RS.L 1
ggt_Tag4        RS.L 1
ggt_DstW        RS.L 1
ggt_Tag5        RS.L 1
ggt_DstH        RS.L 1
ggt_SIZEOF      RS.L 0

	RSRESET
bar_Val1       RS.L 1	; New value
bar_Val2       RS.L 1	; Old value
bar_DstX       RS.L 1	; Destination X
bar_DstY       RS.L 1	; Destination Y
bar_PicW       RS.L 1	; Picture Width
bar_PicH       RS.L 1	; Picture Height
bar_PicBg      RS.L 1	; Picture handle
bar_PicFg      RS.L 1	; Picture handle
bar_hDraw      RS.L 1	; Draw handle
bar_hTags      RS.L 1	; Tags handle
bar_SIZEOF     RS.L 0	; SizeOf

************************************************************
*
* ENTRY POINT
*
************************************************************

	MACHINE    MC68060

MAIN:

	move.l     #RETURN_FAIL,_RC                ; Return Code

	;----------------------------------------
	; Workbench Start
	;----------------------------------------

.wbStart
	suba.l     a1,a1                           ; name
	CALLEXEC   FindTask                        ; (name)(a1)
	move.l     d0,a4                           ; process
	move.l     pr_CLI(a4),d0                   ; process->pr_CLI
	bne.s      .openLibs                       ; skip
	lea.l      pr_MsgPort(a4),a0               ; process->msgport
	CALLEXEC   WaitPort                        ; (msgport)(a0)
	lea.l      pr_MsgPort(a4),a0               ; process->msgport
	CALLEXEC   GetMsg                          ; (msgport)(a0)
	move.l     d0,WBStartMsg                   ; WBStart message

	;----------------------------------------
	; Open libraries
	;----------------------------------------

.openLibs
	LIBOPEN    DOS                             ; 
	LIBOPEN    Diskfont                        ; 
	LIBOPEN    Icon                            ; 
	LIBOPEN    Intuition                       ; 
	LIBOPEN    Gadtools                        ; 
	LIBOPEN    Gfx                             ; 
	LIBOPEN    GuiGfx                          ; 
	LIBOPEN    Reqtools                        ; 
	LIBOPEN    ScreenNotify                    ; 
	LIBOPEN    Utility                         ; 
	LIBOPEN    AmigaGuide                      ; 
	LIBOPEN    Commodities                     ; 
	
	;----------------------------------------
	; Hardware informations
	;----------------------------------------

.checkCPU
	bsr        V_CPU_Detect080                 ; AC68080 ?
	tst.l      d0                              ; 
	bne.s      .checkDone                      ; 
	lea        StrError1(pc),a0                ; 
	move.l     a0,d1                           ; 
	CALLDOS    PutStr                          ; 
	bra.w      .closeLibs                      ; 
.checkDone
	bsr        GetAvailMem                     ; infos
	bsr        GetHWInfos                      ; infos
	move.l     #4,d2
	bsr        MenuItem_Setting_RefreshRate    ; rate

	;----------------------------------------
	; Open program
	;----------------------------------------

.handleEvents

	bsr        LoadToolTypes                   ; 

	bsr        Window_Open                     ; 
	tst.l      d0                              ; 
	beq        .closeLibs                      ; 

	bsr        Fonts_Open                      ; 
  	bsr        CxBroker_Install                ; 
	bsr        ScreenNotify_Install            ; 

	bsr        V_TemperatureInit               ; 
	bsr        V_TemperatureFind               ; 
	bsr        V_TemperatureRead               ; 

	lea.l      StrTEMP(pc),a0                  ; 
	bsr        V_TemperatureToString           ; 
	
	bsr        CenterTexts                     ; 
	
	bsr        Window_ObtainPens               ; 
	bsr        Window_Redraw                   ; 
	bsr        Window_Events                   ; 
	bsr        Window_ReleasePens              ; 
	bsr        Window_Close                    ; 
	
	bsr        V_TemperatureFree               ; 
	
	bsr        ScreenNotify_Uninstall          ; 
  	bsr        CxBroker_Uninstall              ; 
	bsr        Fonts_Close                     ; 

	move.l     #RETURN_OK,_RC                  ; Return Code

	;----------------------------------------
	; Exit program
	;----------------------------------------
	
.closeLibs
	LIBCLOSE   Commodities                     ; 
	LIBCLOSE   AmigaGuide                      ; 
	LIBCLOSE   Utility                         ; 
	LIBCLOSE   ScreenNotify                    ; 
	LIBCLOSE   Reqtools                        ; 
	LIBCLOSE   GuiGfx                          ; 
	LIBCLOSE   Gfx                             ; 
	LIBCLOSE   Gadtools                        ; 
	LIBCLOSE   Intuition                       ; 
	LIBCLOSE   Icon                            ; 
	LIBCLOSE   Diskfont                        ; 
	LIBCLOSE   DOS                             ; 

.closeWB
	move.l     WBStartMsg(pc),d0               ; WBStart message
	beq.s      .exit                           ; skip
	CALLEXEC   Forbid                          ; (void)
	move.l     WBStartMsg(pc),a1               ; WBStart message
	CALLEXEC   ReplyMsg                        ; (msg)(a1)

.exit
	move.l     _RC,d0                          ; DOS Result
	rts                                        ; Exit Program

************************************************************
*
* FONTS FUNCTIONS
*
************************************************************

ta_TextFont EQU ta_SIZEOF

Fonts_Open:

.font1
	lea.l      MyTextA1(pc),a0                 ; textattr
	CALLDISKFONT OpenDiskFont                  ; (textattr)(a0)
	lea.l      MyTextA1(pc),a0                 ; textattr
	move.l     d0,ta_TextFont(a0)              ; store

.font2
	lea.l      MyTextA2(pc),a0                 ; textattr
	CALLDISKFONT OpenDiskFont                  ; (textattr)(a0)
	lea.l      MyTextA2(pc),a0                 ; textattr
	move.l     d0,ta_TextFont(a0)              ; store

.font3
	lea.l      MyTextA3(pc),a0                 ; textattr
	CALLDISKFONT OpenDiskFont                  ; (textattr)(a0)
	lea.l      MyTextA3(pc),a0                 ; textattr
	move.l     d0,ta_TextFont(a0)              ; store

	rts                                        ; Return

;-----------------------------------------------------------

Fonts_Close:

.font1
	lea.l      MyTextA1(pc),a0                 ; textattr
	tst.l      ta_TextFont(a0)                 ; textfont
	beq.s      .font2                          ; 
	move.l     ta_TextFont(a0),a1              ; 
	CALLGRAF   CloseFont                       ; (textfont)(a1)

.font2
	lea.l      MyTextA2(pc),a0                 ; textattr
	tst.l      ta_TextFont(a0)                 ; textfont
	beq.s      .font3                          ; 
	move.l     ta_TextFont(a0),a1              ; 
	CALLGRAF   CloseFont                       ; (textfont)(a1)

.font3
	lea.l      MyTextA3(pc),a0                 ; textattr
	tst.l      ta_TextFont(a0)                 ; textfont
	beq.s      .exit                           ; 
	move.l     ta_TextFont(a0),a1              ; 
	CALLGRAF   CloseFont                       ; (textfont)(a1)

.exit
	rts

;-----------------------------------------------------------

CenterTexts:
	movem.l    d0-a6,-(sp)                     ; Push
	lea.l      MyIText1(pc),a2                 ; first item
.loop
	tst.w      it_LeftEdge(a2)                 ; zero ?
	bne.s      .next                           ; skip
	move.l     MyWindow(pc),a1                 ; window
	move.l     wd_RPort(a1),a1                 ; rastport
	move.l     it_ITextFont(a2),a0             ; itext->textattr
	move.l     ta_TextFont(a0),a0              ; textfont
	tst.l      a0
	beq.s      .next
	CALLGRAF   SetFont                         ; (rp,textfont)(a1,a0)
	move.l     it_IText(a2),a0                 ; itext->string
	moveq.l    #-1,d0                          ; reset count
.size
	addq.l     #1,d0                           ; count++
	tst.b      (a0)+                           ; test char
	bne.s      .size                           ; next char
	move.l     MyWindow(pc),a1                 ; window
	move.l     wd_RPort(a1),a1                 ; rastport
	move.l     it_IText(a2),a0                 ; itext->string
	CALLGRAF   TextLength                      ; (rp,string,count)(a1,a0,d0)
	move.w     #WIN_WIDTH,d1                   ; (W)
	sub.w      d0,d1                           ; (W-w)
	lsr.w      #1,d1                           ; (W-w)/2
	move.w     d1,it_LeftEdge(a2)              ; itext->leftedge
.next
	move.l     it_NextText(a2),a2              ; next item
	tst.l      a2                              ; last item ?
	bne.s      .loop                           ; continue
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; Return

************************************************************
*
* MENUITEM FUNCTIONS
*
************************************************************

MenuItem_Quit:
	lea.l      ExitRequested(pc),a0            ; Exit
	move.l     #1,(a0)                         ; TRUE
	rts                                        ; return

;-----------------------------------------------------------

MenuItem_About:
	movem.l    d0-a6,-(sp)                     ; push
	lea.l      ReqAboutBody(pc),a1             ; body
	lea.l      ReqAboutGads(pc),a2             ; gadgets
	suba.l     a3,a3                           ; reqinfo
	lea.l      ValBUFFER(pc),a4                ; array
	move.l     #APP_VERSION,0*4(a4)            ; array[0]
	move.l     #APP_RELEASEDATE,1*4(a4)        ; array[1]
	move.l     #APP_DESCRIPTION,2*4(a4)        ; array[2]
	move.l     #APP_AUTHOR,3*4(a4)             ; array[3]
	move.l     #APP_COMMENT,4*4(a4)            ; array[4]
	move.l     #APP_COPYRIGHT,5*4(a4)          ; array[5]
	lea.l      ReqAboutTags(pc),a0             ; tags
	move.l     MyWindow(pc),4(a0)              ; tags[0]
	CALLRT     rtEZRequestA                    ; (a0,a1,a2,a3,a4)
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

MenuItem_Help:

	movem.l    d0-a6,-(sp)                     ; Push

	move.l     MyWindow(pc),a0                 ; window
	lea.l      .pointerTags1(pc),a1            ; tags
	CALLINT    SetWindowPointerA               ; (win,tags)(a0,a1)
		
	lea.l      APP_NAME(pc),a1                 ; Basename
	lea.l      APP_GUIDE(pc),a2                ; Filename
	lea.l      MyNewAmigaGuide(pc),a0          ; NewAmigaGuide
	move.l     a1,nag_BaseName(a0)             ; nag.nag_BaseName
	move.l     a2,nag_Name(a0)                 ; nag.nag_Name
	suba.l     a1,a1                           ; tags
	CALLAG     OpenAmigaGuideA                 ; (nag,tags)(a0,a1)
	move.l     d0,MyAmigaGuide                 ; handle
	tst.l      d0                              ; null ?
	beq.s      .exit                           ; skip

	move.l     MyAmigaGuide(pc),a0             ; handle
	CALLAG     CloseAmigaGuide                 ; (handle)(a0)

	move.l     MyWindow(pc),a0                 ; window
	lea.l      .pointerTags2(pc),a1            ; tags
	CALLINT    SetWindowPointerA               ; (win,tags)(a0,a1)

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts

.pointerTags1:
	DC.L WA_BusyPointer,1
	DC.L WA_PointerDelay,1
.pointerTags2:
	DC.L TAG_DONE

;-----------------------------------------------------------

MenuItem_Iconify:
	movem.l    d2-d7/a2-a6,-(sp)               ; push
	movem.l    (sp)+,d2-d7/a2-a6               ; pop
	rts

;-----------------------------------------------------------

MenuItem_FPUSwitch:

	movem.l    d0-a6,-(sp)                     ; push
	
	lea.l      ReqFPUBody(pc),a1               ; body
	lea.l      ReqFPUGads(pc),a2               ; gadgets
	suba.l     a3,a3                           ; reqinfo
	tst.w      d2                              ; menunum->sub
	bne.s      1$                              ; skip
	lea.l      .disable(pc),a0                 ; string
	bra.s      2$                              ; skip
1$	lea.l      .enable(pc),a0                  ; string
2$	lea.l      ValBUFFER(pc),a4                ; array
	move.l     a0,(a4)                         ; array[0]
	lea.l      ReqFPUTags(pc),a0               ; tags
	move.l     MyWindow(pc),4(a0)              ; tags[0]
	CALLRT     rtEZRequestA                    ; (a0,a1,a2,a3,a4)
	cmp.l      #1,d0                           ; result
	bne.s      .exit                           ; skip

	CALLEXEC   Disable                         ; multitask off
	tst.w      d2                              ; menunum->sub
	bne.s      3$                              ; skip
	bsr        V_CPU_DFP_On                    ; disable fpu
	bra.s      4$                              ; skip
3$	bsr        V_CPU_DFP_Off                   ; enable fpu
4$	CALLEXEC   ColdReboot                      ; reboot
	CALLEXEC   Enable                          ; multitask on

.exit
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

.enable:  DC.B "enable",0
.disable: DC.B "disable",0
	CNOP 0,4

;-----------------------------------------------------------

MenuItem_SuperScalar:

	movem.l    d0-a6,-(sp)                     ; Push
	
	cmp.w      #0,d2                           ; menunum->sub
	beq.s      .item0                          ; 
	cmp.w      #1,d2                           ; menunum->sub
	beq.s      .item1                          ; 
	bra.s      .exit                           ; skip

.item0
	bsr        V_CPU_ESS_Off                   ; poke hardware
	bra.s      .exit                           ; skip

.item1
	bsr        V_CPU_ESS_On                    ; poke hardware

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts

;-----------------------------------------------------------

MenuItem_TurtleMode:

	movem.l    d0-a6,-(sp)                     ; Push
	
	cmp.w      #0,d2                           ; menunum->sub
	beq.s      .item0                          ; 
	cmp.w      #1,d2                           ; menunum->sub
	beq.s      .item1                          ; 
	bra.s      .exit                           ; skip

.item0
	bsr        V_CPU_ICACHE_On                 ; poke hardware
	bra.s      .exit                           ; skip

.item1
	bsr        V_CPU_ICACHE_Off                ; poke hardware

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts

;-----------------------------------------------------------

MenuItem_FastIDE:

	movem.l    d0-a6,-(sp)                     ; Push
	
	move.l     d2,d0                           ; menunum->sub
	andi.l     #$000000ff,d0                   ; ubyte
	cmp.l      #VREG_FASTIDE_FASTEST,d0        ; max ?
	bls.s      .apply                          ; 
	move.l     #VREG_FASTIDE_FASTEST,d0        ; max

.apply
	bsr        V_SetFastIDE                    ; poke hardware

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts

;-----------------------------------------------------------

MenuItem_SDClockDivider:

	movem.l    d0-a6,-(sp)                     ; Push

	cmp.w      #5,d2                           ; menunum->sub
	bne.s      .fromMenu                       ; skip

.fromUser
	lea.l      ValSDValue(pc),a1               ; &num
	lea.l      ReqSDTitle(pc),a2               ; title
	sub.l      a3,a3                           ; reqinfo
	lea.l      ReqSDSelectTags(pc),a0          ; tags
	move.l     MyWindow(pc),4(a0)              ; tags[0]
	CALLRT     rtGetLongA                      ; (&num,title,reqinfo,tags)(a1,a2,a3,a0)
	tst.l      d0                              ; result
	beq.s      .exit                           ; cancelled
	bra.s      .checkzero                      ; accepted

.fromMenu
	andi.l     #$000000ff,d2                   ; ubyte
	move.l     d2,ValSDValue                   ; &num

.checkzero
	tst.l      ValSDValue(pc)                  ; &num
	bne.s      .apply                          ; &num > 0 is ok
	lea.l      ReqSDAcceptBody(pc),a1          ; body
	lea.l      ReqSDAcceptGads(pc),a2          ; gadgets
	suba.l     a3,a3                           ; reqinfo
	suba.l     a4,a4                           ; array
	lea.l      ReqSDAcceptTags(pc),a0          ; tags
	move.l     MyWindow(pc),4(a0)              ; tags[0]
	CALLRT     rtEZRequestA                    ; (a0,a1,a2,a3,a4)
	cmp.l      #1,d0                           ; result
	bne.s      .exit                           ; skip

.apply
	move.l     ValSDValue(pc),d0               ; &num
	bsr        V_SetSDClockDivider             ; poke hardware

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts

;-----------------------------------------------------------

MenuItem_SerialNumber:

	movem.l    d0-a6,-(sp)                     ; Push

	lea.l      ReqSNBuffer(pc),a5              ; buffer
	move.l     a5,a0                           ; buffer
	bsr        _v_read_sn                      ; read S/N
	tst.l      d0                              ; success ?
	beq.s      .exit                           ; skip

	lea.l      ReqSNBody(pc),a1                ; body
	lea.l      ReqSNGads(pc),a2                ; gadgets
	suba.l     a3,a3                           ; reqinfo
	lea.l      ValBUFFER(pc),a4                ; array
	move.l     a5,(a4)                         ; array[0]
	lea.l      ReqSNTags(pc),a0                ; tags
	move.l     MyWindow(pc),4(a0)              ; tags[0]
	CALLRT     rtEZRequestA                    ; (a0,a1,a2,a3,a4)
	tst.l      d0                              ; result
	bne.s      .exit                           ; skip

	lea.l      ReqSNBuffer(pc),a0              ; buffer
	bsr        V_ClipWrite                     ; copy to clipboard

.exit
	movem.l    (sp)+,d0-a6                     ; Push
	rts

;-----------------------------------------------------------

MenuItem_Setting_RefreshRate:
	cmp.w      #20,d2                          ; max ?
	bgt.s      .exit                           ; skip
	move.l     d2,d1                           ; menunum->sub
	andi.l     #$ffff,d1                       ; n
	move.l     #1,d0                           ; 1
	lsl.l      d1,d0                           ; 1 << n
	move.l     $4.w,a0                         ; execbase
	move.l     ValMULT(pc),d1                  ; mult
	mulu.l     ex_EClockFrequency(a0),d1       ; mult*eclock
	mulu.l     #10,d1                          ; mult*eclock*10
	divu.l     d0,d1                           ; new rate
	lea.l      ValRATE(pc),a0                  ; new rate
	move.l     d1,(a0)                         ; new rate
.exit
	rts                                        ; return

;-----------------------------------------------------------

MenuItem_Setting_Backdrop:
	movem.l    d0-a6,-(sp)                     ; push
	andi.l     #$0000ffff,d2                   ; menunum->sub
	lea.l      OpenWindowTags(pc),a0           ; taglist
	move.l     d2,4+(6*8)(a0)                  ; taglist[] -> WA_Backdrop
	bsr        Window_Reopen                   ; close & reopen
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

MenuItem_Setting_Borderless:
	movem.l    d0-a6,-(sp)                     ; push
	andi.l     #$0000ffff,d2                   ; menunum->sub
	move.l     d2,d1                           ; !bool
	neg.l      d1                              ; !bool
	not.l      d1                              ; !bool
	lea.l      OpenWindowTags(pc),a0           ; taglist
	move.l     d2,4+(07*8)(a0)                 ; taglist[] -> WA_Borderless
	move.l     d1,4+(08*8)(a0)                 ; taglist[] -> WA_CloseGadget
	move.l     d1,4+(09*8)(a0)                 ; taglist[] -> WA_DepthGadget
	move.l     d1,4+(10*8)(a0)                 ; taglist[] -> WA_DragBar
	bsr        Window_Reopen                   ; close and reopen
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

MenuItem_Setting_Skin:
	movem.l    d0-a6,-(sp)                     ; push
	cmp.w      #7,d2                           ; max ?
	bgt.s      .exit                           ; skip
	lea.l      FileWinBG(pc),a0                ; background
	lea.l      SkinArray(pc),a1                ; table
	move.l     (a1,d2.w*4),(a0)                ; store new
	bsr        Window_Reopen                   ; close and reopen
.exit
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

************************************************************
*
* WINDOW FUNCTIONS
*
************************************************************

Window_Reopen:
	bsr        Window_ReleasePens              ; 
	bsr        Window_Close                    ; 
	bsr        Window_Open                     ; 
	bsr        Window_ObtainPens               ; 
	bsr        Window_Redraw                   ; 
	bsr        BarDraw                         ; 
	rts

;-----------------------------------------------------------

Window_Open:

	movem.l    d1-a6,-(sp)                     ; Push

	;----------------------------------------
	; Open Window
	;----------------------------------------

.winopen
	tst.l      MyWindow(pc)                    ; window
	bne        .exit                           ; 
	suba.l     a0,a0                           ; newwindow
	lea.l      OpenWindowTags(pc),a1           ; tags
	move.l     MyWindowX(pc),4+(0*8)(a1)       ; tags[0]
	move.l     MyWindowY(pc),4+(1*8)(a1)       ; tags[1]
	CALLINT    OpenWindowTagList               ; (newwindow,tags)(a0,a1)
	tst.l      d0                              ; null ?
	beq.w      .exit                           ; skip
	move.l     d0,MyWindow                     ; window

	;----------------------------------------
	; Window and screen titles
	;----------------------------------------

.wintitles	
	move.l     d0,a0                           ; win
	lea.l      APP_NAME(pc),a1                 ; wintitle
	lea.l      APP_VERSTRING+6(pc),a2          ; scrtitle
	CALLINT    SetWindowTitles                 ; (win,wintitle,scrtitle)(a0,a1,a2)

	;----------------------------------------
	; Window gadgets and menus list
	;----------------------------------------

.wingadgets
	move.l     MyWindow(pc),a0                 ; win
	lea.l      MyDragGadget(pc),a1             ; gad
	move.w     #~0,d0                          ; pos.w
	CALLINT    AddGadget                       ; (win,gad,pos)(a0,a1,d0)

.winmenus

	move.l     MyWindow(pc),a0                 ; win
	move.l     wd_WScreen(a0),a0               ; win->scr
	suba.l     a1,a1                           ; tags
	CALLGT     GetVisualInfoA                  ; (screen,tags)(a0,a1)
	move.l     d0,MyVisualInfo                 ; visualInfo

	lea.l      MyNewMenu(pc),a0                ; newmenu
	suba.l     a1,a1                           ; tags
	CALLGT     CreateMenusA                    ; (newmenu,tags)(a0,a1)
	move.l     d0,MyMenuStrip                  ; visualInfo

	move.l     MyMenuStrip(pc),a0              ; menustrip
	move.l     MyVisualInfo(pc),a1             ; visualinfo
	lea.l      LayoutMenusTags(pc),a2          ; tags
	CALLGT     LayoutMenusA                    ; (menustrip,visualinfo,tags)(a0,a1,a2)

	move.l     MyWindow(pc),a0                 ; win
	move.l     MyMenuStrip(pc),a1              ; menustrip
	CALLINT    SetMenuStrip                    ; (win,menustrip)(a0,a1)

	move.l     MyWindow(pc),a0                 ; win
	move.l     #$F820,d0                       ; menunumber.w -> iconify
	CALLINT    OffMenu                         ; (win,menunumber)(a0,d0)
	
	;----------------------------------------
	; Initialize GuiGfx stuff
	;----------------------------------------

.psmcreate
	lea.l      GuiGfxTags(pc),a0               ; tags
	CALLGUIGFX CreatePenShareMapA              ; (tags)(a0)
	tst.l      d0                              ; 
	beq        .exit                           ; 
	move.l     d0,GuiGfxPenShareMap            ; psm

.picload1
	move.l     FileWinBG(pc),a0                ; filename
	lea.l      GuiGfxTags(pc),a1               ; tags
	CALLGUIGFX LoadPictureA                    ; (filename,tags)(a0,a1)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 
	move.l     d0,GuiGfxPic1                   ; pic

.picload2
	lea.l      FileBarBG1(pc),a0               ; filename
	lea.l      GuiGfxTags(pc),a1               ; tags
	CALLGUIGFX LoadPictureA                    ; (filename,tags)(a0,a1)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 
	move.l     d0,GuiGfxPic2                   ; pic

.picload3
	lea.l      FileBarFG1(pc),a0               ; filename
	lea.l      GuiGfxTags(pc),a1               ; tags
	CALLGUIGFX LoadPictureA                    ; (filename,tags)(a0,a1)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 
	move.l     d0,GuiGfxPic3                   ; pic

.picadd1
	move.l     GuiGfxPenShareMap(pc),a0        ; psm
	move.l     GuiGfxPic1(pc),a1               ; picture
	lea.l      GuiGfxTags(pc),a2               ; tags
	CALLGUIGFX AddPictureA                     ; (psm,pic,tags)(a0,a1,a2)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 

.picadd2
	move.l     GuiGfxPenShareMap(pc),a0        ; psm
	move.l     GuiGfxPic2(pc),a1               ; picture
	lea.l      GuiGfxTags(pc),a2               ; tags
	CALLGUIGFX AddPictureA                     ; (psm,pic,tags)(a0,a1,a2)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 

.picadd3
	move.l     GuiGfxPenShareMap(pc),a0        ; psm
	move.l     GuiGfxPic3(pc),a1               ; picture
	lea.l      GuiGfxTags(pc),a2               ; tags
	CALLGUIGFX AddPictureA                     ; (psm,pic,tags)(a0,a1,a2)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 

.gethandle
	move.l     GuiGfxPenShareMap(pc),a0        ; psm
	move.l     MyWindow(pc),a1                 ; win
	move.l     wd_RPort(a1),a1                 ; win->rp
	move.l     MyWindow(pc),a2                 ; win
	move.l     wd_WScreen(a2),a2               ; win->scr
	adda.l     #sc_ViewPort,a2                 ; win->scr->vp
	adda.l     #vp_ColorMap,a2                 ; win->scr->vp.cm
	move.l     (a2),a2                         ; cm
	lea.l      GuiGfxTags(pc),a3               ; tags
	CALLGUIGFX ObtainDrawHandleA               ; (psm,rp,cm,tags)(a0,a1,a2,a3)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 
	move.l     d0,GuiGfxDrawHandle             ; handle

.barinit

	lea.l      BarCP1(pc),a0                   ; bar mips1
	lea.l      BarTags(pc),a1                  ; bar tags
	move.l     #100,bar_PicW(a0)               ; 
	move.l     #010,bar_PicH(a0)               ; 
	move.l     GuiGfxPic2(pc),bar_PicBg(a0)    ; 
	move.l     GuiGfxPic3(pc),bar_PicFg(a0)    ; 
	move.l     GuiGfxDrawHandle(pc),bar_hDraw(a0)
	move.l     a1,bar_hTags(a0)                ; 

	lea.l      BarCP2(pc),a0                   ; bar mips2
	lea.l      BarTags(pc),a1                  ; bar tags
	move.l     #100,bar_PicW(a0)               ; 
	move.l     #010,bar_PicH(a0)               ; 
	move.l     GuiGfxPic2(pc),bar_PicBg(a0)    ; 
	move.l     GuiGfxPic3(pc),bar_PicFg(a0)    ; 
	move.l     GuiGfxDrawHandle(pc),bar_hDraw(a0)
	move.l     a1,bar_hTags(a0)                ; 

	lea.l      BarCFP(pc),a0                   ; bar flops
	lea.l      BarTags(pc),a1                  ; bar tags
	move.l     #100,bar_PicW(a0)               ; 
	move.l     #010,bar_PicH(a0)               ; 
	move.l     GuiGfxPic2(pc),bar_PicBg(a0)    ; 
	move.l     GuiGfxPic3(pc),bar_PicFg(a0)    ; 
	move.l     GuiGfxDrawHandle(pc),bar_hDraw(a0)
	move.l     a1,bar_hTags(a0)                ; 

.psmdel
	move.l     GuiGfxPenShareMap(pc),a0        ; psm
	CALLGUIGFX DeletePenShareMap               ; (psm)(a0)

.exit
	move.l     MyWindow(pc),d0                 ; window
	movem.l    (sp)+,d1-a6                     ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

Window_Close:

	movem.l    d0-a6,-(sp)                     ; push

	;----------------------------------------
	; Release GuiGfx stuff
	;----------------------------------------

.delpic1
	tst.l      GuiGfxPic1(pc)                  ; picture
	beq.s      .delpic2                        ; 
	move.l     GuiGfxPic1(pc),a0               ; 
	CALLGUIGFX DeletePicture                   ; (picture)(a0)
	clr.l      GuiGfxPic1                      ; 

.delpic2
	tst.l      GuiGfxPic2(pc)                  ; picture
	beq.s      .delpic3                        ; 
	move.l     GuiGfxPic2(pc),a0               ; 
	CALLGUIGFX DeletePicture                   ; (picture)(a0)
	clr.l      GuiGfxPic2                      ; 

.delpic3
	tst.l      GuiGfxPic3(pc)                  ; picture
	beq        .deldrawhandle                  ; 
	move.l     GuiGfxPic3(pc),a0               ; 
	CALLGUIGFX DeletePicture                   ; (picture)(a0)
	clr.l      GuiGfxPic3                      ; 

.deldrawhandle
	tst.l      GuiGfxDrawHandle(pc)            ; drawhandle
	beq        .clearmenus                     ; 
	move.l     GuiGfxDrawHandle(pc),a0         ; 
	CALLGUIGFX ReleaseDrawHandle               ; (drawhandle)(a0)
	clr.l      GuiGfxDrawHandle                ; 

	;----------------------------------------
	; Close Menus
	;----------------------------------------

.clearmenus
	tst.l      MyWindow(pc)                    ; window
	beq.s      .freemenus                      ; 
	move.l     MyWindow(pc),a0                 ; 
	CALLINT    ClearMenuStrip                  ; (window)(a0)

.freemenus
	tst.l      MyMenuStrip(pc)                 ; menustrip
	beq.s      .freevisualinfo                 ; 
	move.l     MyMenuStrip(pc),a0              ; 
	CALLGT     FreeMenus                       ; (menustrip)(a0)
	clr.l      MyMenuStrip                     ; 

.freevisualinfo
	tst.l      MyVisualInfo(pc)                ; visualinfo
	beq.s      .closewindow                    ; 
	move.l     MyVisualInfo(pc),a0             ; 
	CALLGT     FreeVisualInfo                  ; (visualinfo)(a0)
	clr.l      MyVisualInfo                    ; 

	;----------------------------------------
	; Close Window
	;----------------------------------------

.closewindow
	tst.l      MyWindow(pc)                    ; window
	beq.s      .exit                           ; 
	move.l     MyWindow(pc),a0                 ; 
	moveq.l    #0,d0                           ; 
	move.w     wd_LeftEdge(a0),d0              ; window->x
	move.l     d0,MyWindowX                    ; 
	move.w     wd_TopEdge(a0),d0               ; window->y
	move.l     d0,MyWindowY                    ; 
	CALLINT    CloseWindow                     ; (window)(a0)
	clr.l      MyWindow                        ; 

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; 

;-----------------------------------------------------------

Window_Redraw:

	movem.l    d0-a6,-(sp)                     ; push

	tst.l      MyWindow(pc)                    ; window
	beq.s      .exit                           ; 
	tst.l      GuiGfxDrawHandle(pc)            ; drawhandle
	beq.s      .exit                           ; 

	;----------------------------------------
	; Draw pictures
	;----------------------------------------

	bsr        Window_DrawBack                 ; background

	;----------------------------------------
	; Draw Texts
	;----------------------------------------

	move.l     MyWindow(pc),a0                 ; window
	move.l     wd_RPort(a0),a0                 ; rastport
	lea.l      MyIText1(pc),a1                 ; textfont
	moveq.w    #0,d0                           ; x.w
	moveq.w    #0,d1                           ; y.w
	CALLINT    PrintIText                      ; (rp,itext,x,y)(a0,a1,d0,d1)
	
.exit
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

Window_DrawBack:

	movem.l    d0-a6,-(sp)                     ; push

	tst.l      GuiGfxDrawHandle(pc)            ; drawhandle
	beq.s      .exit                           ; 
	tst.l      GuiGfxPic1(pc)                  ; picture
	beq.s      .exit                           ; 
	
	move.l     GuiGfxDrawHandle(pc),a0         ; handle
	move.l     GuiGfxPic1(pc),a1               ; picture
	moveq.w    #0,d0                           ; x.w
	moveq.w    #0,d1                           ; y.w
	lea.l      GuiGfxTags(pc),a2               ; tags
	CALLGUIGFX DrawPictureA                    ; (handle,pic,x,y,tags)(a0,a1,d0,d1,a2)

.exit
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

BarDraw:
	lea.l      BarCP1(pc),a0                   ; 
	move.l     #100,bar_Val1(a0)               ; 
	bsr        BarDraw1                        ; 
	lea.l      BarCP2(pc),a0                   ; 
	move.l     #100,bar_Val1(a0)               ; 
	bsr        BarDraw1                        ; 
	lea.l      BarCFP(pc),a0                   ; 
	move.l     #100,bar_Val1(a0)               ; 
	bsr        BarDraw1                        ; 
	rts                                        ; return

;-----------------------------------------------------------

BarDraw1:

	movem.l    d0-a6,-(sp)                     ; push

	move.l     a0,a3                           ; bar

	move.l     bar_Val1(a3),d2                 ; newval
	move.l     bar_DstX(a3),d3                 ; dstx
	move.l     bar_DstY(a3),d4                 ; dsty
	move.l     bar_PicW(a3),d5                 ; picw
	move.l     bar_PicH(a3),d6                 ; pich

.bound0
	cmp.l      #0,d2                           ; newval > 0 ?
	bgt.s      .bound1                         ; skip
	moveq.l    #0,d2                           ; newval = 0
	move.l     #0,bar_Val1(a3)                 ; newval = 0
	bra.s      .bound2                         ; skip
.bound1
	cmp.l      d5,d2                           ; newval < picw ?
	blt.s      .bound2                         ; skip
	move.l     d5,d2                           ; newval = picw
	move.l     d5,bar_Val1(a3)                 ; newval = picw
.bound2
	move.l     bar_Val1(a3),d0                 ; newval
	cmp.l      bar_Val2(a3),d0                 ; newval = oldval ?
	beq        .exit                           ; skip

.picFG
	move.l     d3,d0                           ; dstx
	move.l     d4,d1                           ; dsty
	tst.l      d2                              ; newval = 0 ?
	beq.s      .picBG                          ; skip
	move.l     bar_hDraw(a3),a0                ; hdraw
	move.l     bar_PicFg(a3),a1                ; hpic
	move.l     bar_hTags(a3),a2                ; tags
	move.l     #0,ggt_SrcX(a2)                 ; srcx
	move.l     #0,ggt_SrcY(a2)                 ; srcy
	move.l     d2,ggt_SrcW(a2)                 ; srcw
	move.l     d6,ggt_SrcH(a2)                 ; srch
	move.l     d2,ggt_DstW(a2)                 ; dstw
	move.l     #5,ggt_DstH(a2)                 ; dsth
	CALLGUIGFX DrawPictureA                    ; (hdraw,hpic,x,y,tags)(a0,a1,d0,d1,a2)

.picBG
	move.l     d3,d0                           ; dstx
	add.l      d2,d0                           ; dstx
	move.l     d4,d1                           ; dsty
	sub.l      d2,d5                           ; dstw
	tst.l      d5                              ; dstw = 0 ?
	beq.s      .picDone                        ; skip
	move.l     bar_hDraw(a3),a0                ; hdraw
	move.l     bar_PicBg(a3),a1                ; hpic
	move.l     bar_hTags(a3),a2                ; tags
	move.l     d2,ggt_SrcX(a2)                 ; srcx
	move.l     #0,ggt_SrcY(a2)                 ; srcy
	move.l     d5,ggt_SrcW(a2)                 ; srcw
	move.l     d6,ggt_SrcH(a2)                 ; srch
	move.l     d5,ggt_DstW(a2)                 ; dstw
	move.l     #5,ggt_DstH(a2)                 ; dsth
	CALLGUIGFX DrawPictureA                    ; (hdraw,hpic,x,y,tags)(a0,a1,d0,d1,a2)

.picDone
	move.l     bar_Val1(a3),d0                 ; newval
	move.l     d0,bar_Val2(a3)                 ; oldval

.exit
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

Window_Events:

	movem.l    d0-a6,-(sp)                     ; Push

.loop

.cxEvents
	;----------------------------------------
	; Commodities Events
	;----------------------------------------
	tst.l      MyCxPort(pc)                    ; MsgPort
	beq        .scnEvents                      ; 
	move.l     MyCxPort(pc),a0                 ; MsgPort
	CALLEXEC   GetMsg                          ; (MsgPort)(a0)
	tst.l      d0                              ; CxMsg
	beq        .scnEvents                      ; Skip
	move.l     d0,a2                           ; CxType
	move.l     a2,a0                           ; CxMsg
	CALLCX     CxMsgType                       ; (CxMsg)(a0)
	move.l     d0,d3                           ; CxType
	move.l     a2,a0                           ; CxMsg
	CALLCX     CxMsgID                         ; (CxMsg)(a0)
	move.l     d0,d4                           ; CxID
	move.l     a2,a1                           ; Msg
	CALLEXEC   ReplyMsg                        ; (Msg)(a1)
.cxTypeCommand
	cmp.l      #CXM_COMMAND,d3
	bne.s      .cxTypeIEvent
	cmp.l      #CXCMD_KILL,d4
	beq.s      .cxCmdKill
	cmp.l      #CXCMD_ENABLE,d4
	beq.s      .cxCmdEnable
	cmp.l      #CXCMD_DISABLE,d4
	beq.s      .cxCmdDisable
	cmp.l      #CXCMD_APPEAR,d4
	beq.s      .cxCmdAppear
	cmp.l      #CXCMD_DISAPPEAR,d4
	beq.s      .cxCmdDisappear
	bra.s      .cxDone
.cxTypeIEvent
	cmp.l      #CXM_IEVENT,d3
	bne.s      .cxDone
	bra.s      .cxDone
.cxCmdKill
	lea.l      ExitRequested(pc),a0
	move.l     #1,(a0)
	bra.s      .cxDone
.cxCmdEnable
	lea.l      IsPaused(pc),a0
	move.l     #0,(a0)
	bra.s      .cxDone
.cxCmdDisable
	lea.l      IsPaused(pc),a0
	move.l     #1,(a0)
	bra.s      .cxDone
.cxCmdAppear
	bsr        Window_Open                     ; 
	bsr        Window_ObtainPens               ; 
	bsr        Window_Redraw                   ; 
	bra.s      .cxDone
.cxCmdDisappear
	bsr        Window_Close                    ; [WB-Close]
.cxDone
	
.scnEvents
	;----------------------------------------
	; ScreenNotify Events
	;----------------------------------------
	tst.l      ScreenNotifyPort(pc)            ; msgport
	beq.s      .winEvents                      ; 
	move.l     ScreenNotifyPort(pc),a0         ; msgport
	CALLEXEC   GetMsg                          ; (msgport)(a0)
	tst.l      d0                              ; 
	beq.s      .winEvents                      ; 
	move.l     d0,a2                           ; msg
	cmp.l      #3,snm_Type(a2)                 ; msg->type = WORKBENCH
	bne.s      .scnDone                        ; 
	tst.l      snm_Value(a2)                   ; msg->value = TRUE/FALSE
	beq.s      .scnClose                       ; 
.scnOpen
	moveq.l    #50,d1                          ; [WB-Open]
	CALLDOS    Delay                           ; (ticks)(d1)
	bsr        Window_Open                     ; 
	bsr        Window_ObtainPens               ; 
	bsr        Window_Redraw                   ; 
	bra.s      .scnDone                        ; 
.scnClose
	bsr        Window_ReleasePens              ; 
	bsr        Window_Close                    ; [WB-Close]
.scnDone
	move.l     a2,a1                           ; message
	CALLEXEC   ReplyMsg                        ; (msg)(a1)
	bra        .continue                       ; 
	
.winEvents
	;----------------------------------------
	; Window Events
	;----------------------------------------
	move.l     MyWindow(pc),a0                 ; window
	tst.l      a0                              ; 
	beq        .continue                       ; 
	move.l     wd_UserPort(a0),a0              ; msgport
	tst.l      a0                              ; 
	beq        .continue                       ; 
	CALLEXEC   GetMsg                          ; (msgport)(a0)
	tst.l      d0                              ; 
	beq        .continue                       ; 
	move.l     d0,a1                           ; msg
	move.w     im_Code(a1),d5                  ; msg->code
	move.l     im_Class(a1),d6                 ; msg->class
	CALLEXEC   ReplyMsg                        ; 

.winClose
	;----------------------------------------
	; Window CLOSE
	;----------------------------------------
	cmp.l      #IDCMP_CLOSEWINDOW,d6           ; [CloseWindow]
	beq        .exit                           ; exit

.winRawKey
	;----------------------------------------
	; Window RAWKEY
	;----------------------------------------
	cmp.l      #IDCMP_RAWKEY,d6                ; [RawKey]
	bne.s      .winMenu                        ; 
	cmp.w      #$45,d5                         ; [RawKey:ESC] 
	beq.s      .exit                           ; 

.winMenu
	;----------------------------------------
	; Window MENUPICK
	;----------------------------------------
	cmp.l      #IDCMP_MENUPICK,d6              ; [MenuItems]
	bne.s      .continue                       ; 
	move.l     MyMenuStrip(pc),a0              ; menustrip
	move.w     d5,d0                           ; menunum
	CALLINT    ItemAddress                     ; (menustrip,menunum)(a0,d0)
	tst.l      d0                              ; null ?
	beq.s      .continue                       ; 
	move.l     d0,a0                           ; menuitem
	move.l     mi_SIZEOF(a0),a0                ; menuitem->mi_userdata
	tst.l      a0                              ; null ?
	beq.s      .continue                       ; 
	MENUNUM    d5,d0                           ; menunum->menu
	ITEMNUM    d5,d1                           ; menunum->item
	SUBNUM     d5,d2                           ; menunum->sub
	jsr        (a0)                            ; subroutine

.continue

	;----------------------------------------
	; Ticks
	;----------------------------------------

	lea.l      ExitRequested(pc),a0            ; Exit
	tst.l      (a0)                            ; TRUE ?
	bne.s      .exit                           ; 

	move.l     IsPaused(pc),d0                 ; Paused
	bne.s      .skip                           ; Skip
	move.l     MyWindow(pc),a0                 ; Window
	tst.l      a0                              ; Null ?
	beq.s      .skip                           ; Skip
	bsr        Window_UpdateCNT                ; Update Counters
	bsr        Window_UpdateLED                ; Update LEDS
	bsr        Window_UpdateTXT                ; Update Infos

.skip
	moveq.l    #2,d1                           ; ticks
	CALLDOS    Delay                           ; (ticks)(d1)
	bra.w      .loop                           ; continue

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

Window_UpdateCNT:

	movem.l    d0-a6,-(sp)                     ; Push

	;------------------------------------------
	; Time Slice
	;------------------------------------------

	move.l     ValRATE(pc),d4                  ; Refresh rate
	tst.l      d4                              ; Zero ?
	beq        .exit                           ; Skip

	lea.l      ValCCC(pc),a0                   ; T1
	dc.w       $4e7a,$1809                     ; Clock
	move.l     d1,d2                           ; T0
	sub.l      (a0),d1                         ; T0-T1
	cmp.l      d4,d1                           ; T0-T1 > Delay ?
	blo        .exit                           ; Skip
	move.l     d2,(a0)                         ; Clock
	
	lea.l      TxtCounterCol(pc),a3            ; Color array

	;------------------------------------------
	; Processor Counter Pipe 1
	;------------------------------------------
	
	lea.l      ValCP1(pc),a0                   ; (old)
	move.l     (a0),d1                         ; (old)
	dc.w       $4e7a,SPR_IP1                   ; (new)
	move.l     d0,(a0)                         ; (new)
	sub.l      d1,d0                           ; (new-old)
	mulu.l     #100,d0                         ; (new-old)*100
	divu.l     d4,d0                           ; (new-old)*100/rate
	sne        d2                              ; non-zero
	andi.l     #1,d2                           ; non-zero bool
	move.l     d0,d3                           ; total

	lea.l      BarCP1(pc),a0                   ; bar
	move.l     d0,bar_Val1(a0)                 ; new
	bsr        BarDraw1                        ; update

	lea.l      MyITextCP1(pc),a2               ; color0: zero
	move.b     (a3,d2.L*1),it_FrontPen(a2)     ; color1: non-zero

	;------------------------------------------
	; Processor Counter Pipe 2
	;------------------------------------------

	lea.l      ValCP2(pc),a0                   ; (old)
	move.l     (a0),d1                         ; (old)
	dc.w       $4e7a,SPR_IP2                   ; (new)
	move.l     d0,(a0)                         ; (new)
	sub.l      d1,d0                           ; (new-old)
	mulu.l     #100,d0                         ; (new-old)*100
	divu.l     d4,d0                           ; (new-old)*100/rate
	sne        d2                              ; non-zero
	andi.l     #1,d2                           ; non-zero bool
	add.l      d0,d3                           ; total

	lea.l      BarCP2(pc),a0                   ; bar
	move.l     d0,bar_Val1(a0)                 ; new
	bsr        BarDraw1                        ; update

	lea.l      MyITextCP2(pc),a2               ; color0: zero
	move.b     (a3,d2.L*1),it_FrontPen(a2)     ; color1: non-zero

	;------------------------------------------
	; Processor Counter FPU
	;------------------------------------------

	lea.l      ValCFP(pc),a0                   ; (old)
	move.l     (a0),d1                         ; (old)
	dc.w       $4e7a,SPR_STH                   ; (new)
	move.l     d0,(a0)                         ; (new)
	sub.l      d1,d0                           ; (new-old)
	mulu.l     #100,d0                         ; (new-old)*100
	divu.l     d4,d0                           ; (new-old)*100/rate
	sne        d2                              ; non-zero
	andi.l     #1,d2                           ; non-zero

	lea.l      BarCFP(pc),a0                   ; bar
	move.l     d0,bar_Val1(a0)                 ; new
	bsr        BarDraw1                        ; update

	lea.l      MyITextCFP(pc),a2               ; color0: zero
	move.b     (a3,d2.L*1),it_FrontPen(a2)     ; color1: non-zero

	;------------------------------------------
	; Draw Texts
	;------------------------------------------

	moveq.l    #0,d2                           ; ipc ##.##
	divul.l    #100,d2:d3                      ; ipc ##.##
	cmp.l      #99,d3                          ; max ?
	blt.s      .ipc                            ; skip
	move.l     #99,d3                          ; max
.ipc
	lea.l      FmtIPC(pc),a0                   ; fmt
	lea.l      ValBUFFER(pc),a1                ; args
	move.l     d3,0(a1)                        ; args[0]
	move.l     d2,4(a1)                        ; args[1]
	lea.l      RawDoFmtCallback(pc),a2         ; cb
	lea.l      StrIPC(pc),a3                   ; data
	CALLEXEC   RawDoFmt                        ; (fmt,args,cb,data)

	move.l     GuiGfxDrawHandle(pc),a0         ; handle
	move.l     GuiGfxPic1(pc),a1               ; picture
	move.w     #128,d0                         ; x.w
	move.w     #114,d1                         ; y.w
	lea.l      CntTags(pc),a2                  ; tags
	CALLGUIGFX DrawPictureA                    ; (handle,pic,x,y,tags)(a0,a1,d0,d1,a2)

	move.l     MyWindow(pc),a0                 ; window
	move.l     wd_RPort(a0),a0                 ; rastport
	lea.l      MyITextCP1(pc),a1               ; textfont
	moveq.w    #0,d0                           ; x.w
	moveq.w    #0,d1                           ; y.w
	CALLINT    PrintIText                      ; (rp,itext,x,y)(a0,a1,d0,d1)

.exit
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

Window_UpdateTXT:

	movem.l    d0-a6,-(sp)                     ; Push

	tst.l      MyWindow(pc)                    ; window
	beq        .exit                           ; 

	tst.l      PenTXTColor(pc)                 ; pen.b
	beq.s      .next
	dc.w       $4e7a,$1809                     ; clock
	move.l     ValCLOCK_TXT(pc),d0             ; 
	move.l     d1,d2                           ; 
	sub.l      d0,d1                           ; 
	cmp.l      #(10*1000000),d1                ; 10 M cycles
	blo        .exit                           ; 
	move.l     MyWindow(pc),a1                 ; win
	move.l     wd_RPort(a1),a1                 ; rp
	moveq.b    #0,d0                           ; mode.b
	CALLGRAF   SetDrMd                         ; (rp,mode)(a1,d0)
	move.l     PenLEDColor3(pc),d0             ; pen.b
	CALLGRAF   SetAPen                         ; (rp,pen)(a1,d0)
	move.w     #(35+0),d0                      ; x1.w
	move.w     #(47+0),d1                      ; y1.w
	move.w     #(35+1),d2                      ; x2.w
	move.w     #(47+2),d3                      ; y2.w
	CALLGRAF   RectFill                        ; (rp,x1,y1,x2,y2)(a1,d0,d1,d2,d3)
	move.l     #0,PenTXTColor                  ; pen.b

.next
	dc.w       $4e7a,$1809                     ; clock
	move.l     ValCLOCK_TXT(pc),d0             ; 
	move.l     d1,d2                           ; 
	sub.l      d0,d1                           ; 
	cmp.l      #(500*1000000),d1               ; 500 M cycles
	blo        .exit                           ; 
	move.l     d2,ValCLOCK_TXT                 ; 

	move.l     MyWindow(pc),a1                 ; win
	move.l     wd_RPort(a1),a1                 ; rp
	moveq.b    #0,d0                           ; mode.b
	CALLGRAF   SetDrMd                         ; (rp,mode)(a1,d0)
	move.l     PenLEDColor1(pc),d0             ; pen.b
	move.l     d0,PenTXTColor                  ; pen.b
	CALLGRAF   SetAPen                         ; (rp,pen)(a1,d0)
	move.w     #(35+0),d0                      ; x1.w
	move.w     #(47+0),d1                      ; y1.w
	move.w     #(35+1),d2                      ; x2.w
	move.w     #(47+2),d3                      ; y2.w
	CALLGRAF   RectFill                        ; (rp,x1,y1,x2,y2)(a1,d0,d1,d2,d3)

	bsr        V_TemperatureRead               ; infos
	lea.l      StrTEMP(pc),a0                  ; infos
	bsr        V_TemperatureToString           ; infos

	bsr        GetAvailMem                     ; infos

	move.l     GuiGfxDrawHandle(pc),a0         ; handle
	move.l     GuiGfxPic1(pc),a1               ; picture
	move.w     #055,d0                         ; x.w
	move.w     #140,d1                         ; y.w
	lea.l      RtcTags(pc),a2                  ; tags
	CALLGUIGFX DrawPictureA                    ; (handle,pic,x,y,tags)(a0,a1,d0,d1,a2)

	move.l     GuiGfxDrawHandle(pc),a0         ; handle
	move.l     GuiGfxPic1(pc),a1               ; picture
	move.w     #020,d0                         ; x.w
	move.w     #170,d1                         ; y.w
	lea.l      TxtTags(pc),a2                  ; tags
	CALLGUIGFX DrawPictureA                    ; (handle,pic,x,y,tags)(a0,a1,d0,d1,a2)

	move.l     MyWindow(pc),a0                 ; window
	move.l     wd_RPort(a0),a0                 ; rastport
	lea.l      MyIText5(pc),a1                 ; textfont
	moveq.w    #0,d0                           ; x.w
	moveq.w    #0,d1                           ; y.w
	CALLINT    PrintIText                      ; (rp,itext,x,y)(a0,a1,d0,d1)

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

Window_UpdateLED:

	movem.l    d0-a6,-(sp)                     ; Push

	tst.l      MyWindow(pc)                    ; window
	beq        .exit                           ; 

	dc.w       $4e7a,$1809                     ; clock
	move.l     ValCLOCK_LED(pc),d0             ; 
	move.l     d1,d2                           ; 
	sub.l      d0,d1                           ; 
	cmp.l      #(100*1000000),d1               ; 100 M cycles
	blo        .exit                           ; 
	move.l     d2,ValCLOCK_LED                 ; 
	move.l     PenLEDColor(pc),d0              ; color
	cmp.l      PenLEDColor1(pc),d0             ; 
	beq.s      .color2                         ; 
	move.l     PenLEDColor1(pc),PenLEDColor    ; color1
	bra.s      .color1                         ; 
.color2
	move.l     PenLEDColor2(pc),PenLEDColor    ; color2
.color1
	move.l     MyWindow(pc),a1                 ; win
	move.l     wd_RPort(a1),a1                 ; rp
	moveq.b    #0,d0                           ; mode.b
	CALLGRAF   SetDrMd                         ; (rp,mode)(a1,d0)
	move.l     PenLEDColor(pc),d0              ; pen.b
	CALLGRAF   SetAPen                         ; (rp,pen)(a1,d0)
	move.w     #(49+0),d0                      ; x1.w
	move.w     #(30+0),d1                      ; y1.w
	move.w     #(49+2),d2                      ; x2.w
	move.w     #(30+2),d3                      ; y2.w
	CALLGRAF   RectFill                        ; (rp,x1,y1,x2,y2)(a1,d0,d1,d2,d3)

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

Window_ReleasePens:

	movem.l    d0-a6,-(sp)                     ; push

	bra.s      .exit                           ; skip

	tst.l      MyWindow(pc)                    ; window
	beq        .exit                           ; skip

	move.l     MyWindow(pc),a2                 ; win
	move.l     wd_WScreen(a2),a2               ; win->scr
	add.l      #sc_ViewPort,a2                 ; win->scr->vp
	add.l      #vp_ColorMap,a2                 ; win->scr->vp.cm

	move.l     a2,a0                           ; cm
	move.l     PenLEDColor1(pc),d0             ; n
	CALLGRAF   ReleasePen                      ; (cm,n)(a0,d0)

	move.l     a2,a0                           ; cm
	move.l     PenLEDColor2(pc),d0             ; n
	CALLGRAF   ReleasePen                      ; (cm,n)(a0,d0)

	move.l     a2,a0                           ; cm
	move.l     PenLEDColor3(pc),d0             ; n
	CALLGRAF   ReleasePen                      ; (cm,n)(a0,d0)

.exit
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

Window_ObtainPens:

	movem.l    d0-a6,-(sp)                     ; Push

	tst.l      MyWindow(pc)                    ; window
	beq        .exit                           ; 

.pen1
	move.l     MyWindow(pc),a0                 ; win
	move.l     wd_WScreen(a0),a0               ; win->scr
	add.l      #sc_ViewPort,a0                 ; win->scr->vp
	add.l      #vp_ColorMap,a0                 ; win->scr->vp.cm
	move.l     (a0),a0                         ; cm
	move.l     #$ffffffff,d1                   ; r
	move.l     #$00000000,d2                   ; g
	move.l     #$00000000,d3                   ; b
	lea.l      ObtainBestPenTags(pc),a1        ; tags
	CALLGRAF   ObtainBestPenA                  ; (cm,r,g,b,tags)(a0,d1,d2,d3,a1)
	move.l     d0,PenLEDColor1                 ; store

.pen2
	move.l     MyWindow(pc),a0                 ; win
	move.l     wd_WScreen(a0),a0               ; win->scr
	add.l      #sc_ViewPort,a0                 ; win->scr->vp
	add.l      #vp_ColorMap,a0                 ; win->scr->vp.cm
	move.l     (a0),a0                         ; cm
	move.l     #$ffffffff,d1                   ; r
	move.l     #$ffffffff,d2                   ; g
	move.l     #$00000000,d3                   ; b
	lea.l      ObtainBestPenTags(pc),a1        ; tags
	CALLGRAF   ObtainBestPenA                  ; (cm,r,g,b,tags)(a0,d1,d2,d3,a1)
	move.l     d0,PenLEDColor2                 ; store

.pen3
	move.l     MyWindow(pc),a0                 ; win
	move.l     wd_WScreen(a0),a0               ; win->scr
	add.l      #sc_ViewPort,a0                 ; win->scr->vp
	add.l      #vp_ColorMap,a0                 ; win->scr->vp.cm
	move.l     (a0),a0                         ; cm
	move.l     #$ffffffff,d1                   ; r
	move.l     #$ffffffff,d2                   ; g
	move.l     #$ffffffff,d3                   ; b
	lea.l      ObtainBestPenTags(pc),a1        ; tags
	CALLGRAF   ObtainBestPenA                  ; (cm,r,g,b,tags)(a0,d1,d2,d3,a1)
	move.l     d0,PenLEDColor3                 ; store

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; Return

************************************************************
*
* COMMODITIES FUNCTIONS
*
************************************************************

CxBroker_Install:

	lea.l      MyCxFmtTitle(pc),a0             ; fmt
	lea.l      ValBUFFER(pc),a1                ; buf
	lea.l      RawDoFmtCallback(pc),a2         ; cb
	lea.l      MyCxStrTitle(pc),a3             ; buf
	move.l     #APP_NAME,0*4(a1)               ; array[0]
	move.l     #APP_VERSION,1*4(a1)            ; array[1]
	move.l     #APP_COPYRIGHT,2*4(a1)          ; array[2]
	CALLEXEC   RawDoFmt                        ; (fmt,args,cb,data)

	CALLEXEC   CreateMsgPort                   ; (void)()
	tst.l      d0                              ; Null ?
	beq.s      .exit                           ; Skip
	lea.l      MyCxPort(pc),a0                 ; MsgPort
	move.l     d0,(a0)                         ; MsgPort
	move.l     d0,a0                           ; MsgPort
	lea.l      APP_NAME(pc),a1                 ; MsgPort name
	move.l     a1,LN_NAME(a0)                  ; MsgPort->ln_Name

	lea.l      MyNewBroker(pc),a0              ; NewBroker
	move.l     d0,nb_Port(a0)                  ; NewBroker->Port
	moveq.l    #0,d0                           ; &error
	CALLCX     CxBroker                        ; (nb,error)(a0,d0)
	lea.l      MyCxBroker(pc),a0               ; CxBroker
	move.l     d0,(a0)                         ; CxBroker
	move.l     d0,a0                           ; CxBroker
	moveq.l    #1,d0                           ; true
	CALLCX     ActivateCxObj                   ; (co,bool)
	
.exit
	rts                                        ; Return

;-----------------------------------------------------------

CxBroker_Uninstall:

	tst.l      MyCxBroker(pc)                  ; CxObj
	beq.s      .exit                           ; Skip
	move.l     MyCxBroker(pc),a0               ; CxObj
	CALLCX     DeleteCxObjAll                  ; (CxObj)(a0)

	tst.l      MyCxPort(pc)                    ; MsgPort
	beq.s      .exit                           ; Skip
	move.l     MyCxPort(pc),a0                 ; MsgPort
	CALLEXEC   DeleteMsgPort                   ; (MsgPort)(a0)

.exit
	rts                                        ; Return

************************************************************
*
* SCREENNOTIFY FUNCTIONS
*
************************************************************

ScreenNotify_Install:

.createPort
	CALLEXEC   CreateMsgPort                   ; CreateMsgPort(void)
	tst.l      d0                              ; 
	beq.s      .exit                           ; 
	move.l     d0,ScreenNotifyPort             ; 

.addClient
	move.l     d0,a0                           ; port
	moveq.l    #0,d0                           ; priority
	CALLSCN    AddWorkbenchClient              ; 
	move.l     d0,ScreenNotifyHandle           ; 

.exit
	rts                                        ; Return

;-----------------------------------------------------------

ScreenNotify_Uninstall:

.remClient
	tst.l      ScreenNotifyHandle(pc)          ; handle
	beq.s      .exit                           ; 
	move.l     ScreenNotifyHandle(pc),a0       ; handle
	CALLSCN    RemWorkbenchClient              ; 
	bne.s      .delPort                        ; 
	move.l     #10,d1                          ; ticks
	CALLDOS    Delay                           ; 
	bra.s      .remClient                      ; 

.delPort
	tst.l      ScreenNotifyPort(pc)            ; handle
	beq.s      .exit                           ; 
	move.l     ScreenNotifyPort(pc),a0         ; msgport
	CALLEXEC   DeleteMsgPort                   ; 

.exit
	rts                                        ; Return

************************************************************
*
* MISC FUNCTIONS
*
************************************************************

RawDoFmtCallback:
	move.b     d0,(a3)+                        ; Push char
	rts                                        ; Return

;-----------------------------------------------------------

MEMFLAGS_CHIP EQU (MEMF_CHIP)
MEMFLAGS_FAST EQU (MEMF_FAST)
MEMFLAGS_SLOW EQU (MEMF_FAST!MEMF_24BITDMA)

GetAvailMem:

	movem.l    a2/a3,-(sp)                     ; Push

.getChip
	move.l     $4.w,a0                         ; execbase
	moveq.l    #MEMFLAGS_CHIP,d1               ; flags
	CALLEXEC   AvailMem                        ; (flags)(d1)
	divu.l     #(1024*1024),d0                 ; size
	lea.l      FmtCHIP(pc),a0                  ; fmt
	lea.l      ValBUFFER(pc),a1                ; buf
	move.l     d0,(a1)                         ; size
	lea.l      RawDoFmtCallback(pc),a2         ; cb
	lea.l      StrCHIP(pc),a3                  ; data
	CALLEXEC   RawDoFmt                        ; (fmt,args,cb,data)

.getFast
	move.l     $4.w,a0                         ; execbase
	moveq.l    #MEMFLAGS_FAST,d1               ; flags
	CALLEXEC   AvailMem                        ; (flags)(d1)
	divu.l     #(1024*1024),d0                 ; size
	lea.l      FmtFAST(pc),a0                  ; fmt
	lea.l      ValBUFFER(pc),a1                ; buf
	move.l     d0,(a1)                         ; size
	lea.l      RawDoFmtCallback(pc),a2         ; cb
	lea.l      StrFAST(pc),a3                  ; data
	CALLEXEC   RawDoFmt                        ; (fmt,args,cb,data)

.getSlow
	move.l     $4.w,a0                         ; execbase
	move.l     #MEMFLAGS_SLOW,d1               ; flags
	CALLEXEC   AvailMem                        ; (flags)(d1)
	divu.l     #(1024*1024),d0                 ; size
	lea.l      FmtSLOW(pc),a0                  ; fmt
	lea.l      ValBUFFER(pc),a1                ; buf
	move.l     d0,(a1)                         ; size
	lea.l      RawDoFmtCallback(pc),a2         ; cb
	lea.l      StrSLOW(pc),a3                  ; data
	CALLEXEC   RawDoFmt                        ; (fmt,args,cb,data)

.exit
	movem.l    (sp)+,a2/a3                     ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

GetHWInfos:

	movem.l    d1-a6,-(sp)                     ; Push

.getCPU
	GETCPUMULT d0                              ; multiplier
	move.l     d0,ValMULT                      ; store
	move.l     $4.w,a0                         ; execbase
	move.l     ex_EClockFrequency(a0),d1       ; eclock
	divu.l     #100000,d1                      ; eclock/100000
	mulu.l     d1,d0                           ; eclock/100000*mult
	move.l     d0,ValFREQ                      ; store
	lea.l      FmtFREQ(pc),a0                  ; fmt
	lea.l      ValFREQ(pc),a1                  ; args
	lea.l      RawDoFmtCallback(pc),a2         ; cb
	lea.l      StrFREQ(pc),a3                  ; data
	CALLEXEC   RawDoFmt                        ; (fmt,args,cb,data)
	lea.l      FmtMULT(pc),a0                  ; fmt
	lea.l      ValMULT(pc),a1                  ; args
	lea.l      RawDoFmtCallback(pc),a2         ; cb
	lea.l      StrMULT(pc),a3                  ; data
	CALLEXEC   RawDoFmt                        ; (fmt,args,cb,data)

.getCPURev
	bsr        V_CPU_Revision                  ; Revision
	lea.l      FmtREV(pc),a0                   ; fmt
	lea.l      ValBUFFER(pc),a1                ; args
	move.l     d0,(a1)                         ; store
	lea.l      RawDoFmtCallback(pc),a2         ; cb
	lea.l      StrREV(pc),a3                   ; data
	CALLEXEC   RawDoFmt                        ; (fmt,args,cb,data)

.getFPU
	bsr        V_CPU_DetectFPU                 ; fpu
	lea.l      MyIText1(pc),a0                 ; itext
	tst.l      d0                              ; enable ?
	beq.s      .getFPU_off                     ; skip
.getFPU_on
	lea.l      StrCPU1(pc),a1                  ; string
	move.l     a1,it_IText(a0)                 ; itext->text
	bra.s      .getFPU_done                    ; skip
.getFPU_off
	lea.l      StrCPU2(pc),a1                  ; string
.getFPU_done
	move.l     a1,it_IText(a0)                 ; itext->text

.getBoard
	GETBOARDID d0                              ; board
	cmp.l      #VREG_BOARD_Future,d0           ; board < max ?
	blo.s      .getBoard2                      ; board < max
	move.l     #VREG_BOARD_Future,d0           ; board = max
.getBoard2
	lea.l      BoardArray(pc),a0               ; array[0]
	lea.l      MyIText2(pc),a1                 ; itext
	move.l     (a0,d0.L*4),d1                  ; array[n]
	move.l     d1,it_IText(a1)                 ; itext->text

.exit
	movem.l    (sp)+,d1-a6                     ; Pop
	rts                                        ; Return

************************************************************
*
* TOOLTYPES
*
************************************************************

TTYes:         DC.B "Yes",0
TTNo:          DC.B "No",0
TTPosX:        DC.B "Left",0
TTPosY:        DC.B "Top",0
TTBackdrop:    DC.B "Backdrop",0
TTBorderless:  DC.B "Borderless",0
TTRefreshRate: DC.B "RefreshRate",0
TTSkin:        DC.B "Skin",0

	CNOP 0,4

LoadToolTypes:
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
	lea.l      OpenWindowTags(pc),a0           ; taglist
	move.l     #0,4+(06*8)(a0)                 ; taglist[] -> WA_Backdrop
	bra        .tt1                            ; return

.backdropYes
	lea.l      OpenWindowTags(pc),a0           ; taglist
	move.l     #1,4+(06*8)(a0)                 ; taglist[] -> WA_Backdrop
	bra        .tt1                            ; return

.borderlessNo
	lea.l      OpenWindowTags(pc),a0           ; taglist
	move.l     #0,4+(07*8)(a0)                 ; taglist[] -> WA_Borderless
	move.l     #1,4+(08*8)(a0)                 ; taglist[] -> WA_CloseGadget
	move.l     #1,4+(09*8)(a0)                 ; taglist[] -> WA_DepthGadget
	move.l     #1,4+(10*8)(a0)                 ; taglist[] -> WA_DragBar
	bra        .tt2                            ; return

.borderlessYes
	lea.l      OpenWindowTags(pc),a0           ; taglist
	move.l     #1,4+(07*8)(a0)                 ; taglist[] -> WA_Borderless
	move.l     #0,4+(08*8)(a0)                 ; taglist[] -> WA_CloseGadget
	move.l     #0,4+(09*8)(a0)                 ; taglist[] -> WA_DepthGadget
	move.l     #0,4+(10*8)(a0)                 ; taglist[] -> WA_DragBar
	bra        .tt2                            ; return

************************************************************
*
* INCLUDE FILES
*
************************************************************

	INCLUDE    Inc/V_CPU.s
	INCLUDE    Inc/V_SERIAL.s
	INCLUDE    Inc/V_SDPORT.s
	INCLUDE    Inc/V_FASTIDE.s
	INCLUDE    Inc/V_CLIPBOARD.s
	INCLUDE    Inc/V_COUNTERS.s
	INCLUDE    Inc/V_SENSORS.s
	INCLUDE    Inc/V_PARSENUM.s

************************************************************
*
* DATA SECTION
*
************************************************************

	CNOP 0,4
	
_RC:                 DS.L 1
_AmigaGuideBase:     DS.L 1
_CommoditiesBase:    DS.L 1
_DiskfontBase:       DS.L 1
_DOSBase:            DS.L 1
_GadtoolsBase:       DS.L 1
_GfxBase:            DS.L 1
_GuiGfxBase:         DS.L 1
_IconBase:           DS.L 1
_IntuitionBase:      DS.L 1
_ReqtoolsBase:       DS.L 1
_ScreenNotifyBase:   DS.L 1
_UtilityBase:        DS.L 1

;-----------------------------------------------------------

	CNOP 0,4
	
WBStartMsg:          DS.L 1
IsPaused:            DS.L 1
ExitRequested:       DS.L 1

MyWindow:            DS.L 1
MyWindowX:           DC.L WIN_LEFT
MyWindowY:           DC.L WIN_TOP
MyVisualInfo:        DS.L 1
MyMenuStrip:         DS.L 1

ValCCC:              DS.L 1  ; Counter Clock Cycle
ValCP1:              DS.L 1  ; Counter EIP1
ValCP2:              DS.L 1  ; Counter EIP2
ValCFP:              DS.L 1  ; Counter EFP1

ValRATE:             DC.L 1000000
ValFREQ:             DS.L 1
ValMULT:             DS.L 1
ValBUFFER:           DS.L 20
ValSDValue:          DC.L 1
ValCLOCK_LED:        DS.L 1
ValCLOCK_TXT:        DS.L 1

TxtCounterCol:       DC.B 4,2

PenTXTColor:         DS.L 1
PenLEDColor:         DS.L 1
PenLEDColor1:        DS.L 1
PenLEDColor2:        DS.L 1
PenLEDColor3:        DS.L 1

;-----------------------------------------------------------

	CNOP 0,4

MyAmigaGuide:        DS.L 1
MyNewAmigaGuide:     DS.B NewAmigaGuide_SIZEOF

;-----------------------------------------------------------

	CNOP 0,4

ScreenNotifyPort:    DS.L 1
ScreenNotifyHandle:  DS.L 1

;-----------------------------------------------------------

	CNOP 0,4

GuiGfxPenShareMap:   DS.L 1
GuiGfxDrawHandle:    DS.L 1
GuiGfxPic1:          DS.L 1
GuiGfxPic2:          DS.L 1
GuiGfxPic3:          DS.L 1
GuiGfxTags:          DC.L TAG_DONE

;-----------------------------------------------------------

	CNOP 0,4

MyCxPort:            DS.L 1
MyCxBroker:          DS.L 1

MyNewBroker:
	DC.B NB_VERSION      ; nb_Version
	DC.B 0               ; nb_Reserve1
	DC.L APP_NAME        ; nb_Name
	DC.L MyCxStrTitle    ; nb_Title
	DC.L APP_DESCRIPTION ; nb_Descr
	DC.W NBU_DUPLICATE   ; nb_Unique
	DC.W COF_SHOW_HIDE   ; nb_Flags (showhide+active)
	DC.B 0               ; nb_Pri
	DC.B 0               ; nb_Reserve2
	DC.L 0               ; nb_Port
	DC.W 0               ; nb_ReservedChannel

MyCxStrTitle: DS.B 50
MyCxFmtTitle: DC.B "%s %s %s",0

;-----------------------------------------------------------

	CNOP 0,4

BarCP1:      ; PIPE1 counter
	DC.L  50 ; bar_Val1
	DC.L  50 ; bar_Val2
	DC.L  50 ; bar_DstX
	DC.L 121 ; bar_DstY
	DC.L   0 ; bar_PicW
	DC.L   0 ; bar_PicH
	DC.L   0 ; bar_hPic1
	DC.L   0 ; bar_hPic2
	DC.L   0 ; bar_hDraw
	DC.L   0 ; bar_hTags

BarCP2:      ; PIPE2 counter
	DC.L  50 ; bar_Val1
	DC.L  50 ; bar_Val2
	DC.L  50 ; bar_DstX
	DC.L 127 ; bar_DstY
	DC.L   0 ; bar_PicW
	DC.L   0 ; bar_PicH
	DC.L   0 ; bar_hPic1
	DC.L   0 ; bar_hPic2
	DC.L   0 ; bar_hDraw
	DC.L   0 ; bar_hTags

BarCFP:      ; FLOAT counter
	DC.L  50 ; bar_Val1
	DC.L  50 ; bar_Val2
	DC.L  50 ; bar_DstX
	DC.L 133 ; bar_DstY
	DC.L   0 ; bar_PicW
	DC.L   0 ; bar_PicH
	DC.L   0 ; bar_hPic1
	DC.L   0 ; bar_hPic2
	DC.L   0 ; bar_hDraw
	DC.L   0 ; bar_hTags

BarTags:
	DC.L GGFX_SourceX,0
	DC.L GGFX_SourceY,0
	DC.L GGFX_SourceWidth,0
	DC.L GGFX_SourceHeight,0
	DC.L GGFX_DestWidth,0
	DC.L GGFX_DestHeight,0
	DC.L TAG_DONE

RtcTags:
	DC.L GGFX_SourceX,55
	DC.L GGFX_SourceY,140
	DC.L GGFX_SourceWidth,90
	DC.L GGFX_SourceHeight,5
	DC.L GGFX_DestWidth,90
	DC.L GGFX_DestHeight,5
	DC.L TAG_DONE

TxtTags:
	DC.L GGFX_SourceX,20
	DC.L GGFX_SourceY,170
	DC.L GGFX_SourceWidth,18
	DC.L GGFX_SourceHeight,17
	DC.L GGFX_DestWidth,18
	DC.L GGFX_DestHeight,17
	DC.L TAG_DONE

CntTags:
	DC.L GGFX_SourceX,128
	DC.L GGFX_SourceY,114
	DC.L GGFX_SourceWidth,22
	DC.L GGFX_SourceHeight,5
	DC.L GGFX_DestWidth,22
	DC.L GGFX_DestHeight,5
	DC.L TAG_DONE

;-----------------------------------------------------------

	CNOP 0,4

ObtainBestPenTags:
	DC.L OBP_Precision,PRECISION_IMAGE
	DC.L OBP_FailIfBad,0
	DC.L TAG_DONE

;-----------------------------------------------------------

	CNOP 0,4

OpenWindowTags:
	DC.L WA_Left,0
	DC.L WA_Top,0
	DC.L WA_InnerWidth,WIN_WIDTH
	DC.L WA_InnerHeight,WIN_HEIGHT
	DC.L WA_IDCMP,IDCMP_CLOSEWINDOW!IDCMP_MENUPICK!IDCMP_RAWKEY
	DC.L WA_Activate,1
	DC.L WA_Backdrop,1
	DC.L WA_Borderless,1
	DC.L WA_CloseGadget,0
	DC.L WA_DepthGadget,0
	DC.L WA_DragBar,0
	DC.L WA_GimmeZeroZero,1
	DC.L WA_NewLookMenus,1
	DC.L WA_SmartRefresh,1
	DC.L TAG_DONE

;-----------------------------------------------------------

	CNOP 0,4

MyDragGadget:
	DC.L 0              ; gg_NextGadget
	DC.W 0,0            ; gg_LeftEdge,gg_TopEdge
	DC.W WIN_WIDTH      ; gg_Width
	DC.W WIN_HEIGHT     ; gg_Height
	DC.W GFLG_GADGHNONE ; gg_Flags
	DC.W 0              ; gg_Activation
	DC.W GTYP_WDRAGGING ; gg_GadgetType
	DC.L 0              ; gg_GadgetRender
	DC.L 0              ; gg_SelectRender
	DC.L 0              ; gg_GadgetText
	DC.L 0              ; gg_MutualExclude
	DC.L 0              ; gg_SpecialInfo
	DC.W 0              ; gg_GadgetID
	DC.L 0              ; gg_UserData

;-----------------------------------------------------------

	CNOP 0,4

LayoutMenusTags:
	DC.L GTMN_NewLookMenus,1
	DC.L TAG_DONE

MyNewMenu:
	MENUITEM NM_TITLE,StrMenu1
	MENUITEM  NM_ITEM,StrMenu1A,StrMenu1A_,MenuItem_Help
	MENUITEM  NM_ITEM,StrMenu1B,StrMenu1B_,MenuItem_Iconify
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu1C,StrMenu1C_,MenuItem_About
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu1D,StrMenu1D_,MenuItem_Quit
	MENUITEM NM_TITLE,StrMenu2
	MENUITEM  NM_ITEM,StrMenu2A
	MENUITEM   NM_SUB,StrMenu2A1,0,MenuItem_FPUSwitch
	MENUITEM   NM_SUB,StrMenu2A2,0,MenuItem_FPUSwitch
	MENUITEM  NM_ITEM,StrMenu2B
	MENUITEM   NM_SUB,StrMenu2B1,0,MenuItem_SuperScalar
	MENUITEM   NM_SUB,StrMenu2B2,0,MenuItem_SuperScalar
	MENUITEM  NM_ITEM,StrMenu2C
	MENUITEM   NM_SUB,StrMenu2C1,0,MenuItem_TurtleMode
	MENUITEM   NM_SUB,StrMenu2C2,0,MenuItem_TurtleMode
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu2D
	MENUITEM   NM_SUB,StrMenu2D1,0,MenuItem_FastIDE
	MENUITEM   NM_SUB,StrMenu2D2,0,MenuItem_FastIDE
	MENUITEM   NM_SUB,StrMenu2D3,0,MenuItem_FastIDE
	MENUITEM   NM_SUB,StrMenu2D4,0,MenuItem_FastIDE
	MENUITEM  NM_ITEM,StrMenu2E
	MENUITEM   NM_SUB,StrMenu2E1,0,MenuItem_SDClockDivider
	MENUITEM   NM_SUB,StrMenu2E2,0,MenuItem_SDClockDivider
	MENUITEM   NM_SUB,StrMenu2E3,0,MenuItem_SDClockDivider
	MENUITEM   NM_SUB,StrMenu2E4,0,MenuItem_SDClockDivider
	MENUITEM   NM_SUB,NM_BARLABEL
	MENUITEM   NM_SUB,StrMenu2E5,0,MenuItem_SDClockDivider
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu2F,0,MenuItem_SerialNumber
	MENUITEM NM_TITLE,StrMenu3
	MENUITEM  NM_ITEM,StrMenu3A
	MENUITEM   NM_SUB,StrMenu3A1,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A2,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A3,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A4,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A5,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A6,0,MenuItem_Setting_RefreshRate
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu3B
	MENUITEM   NM_SUB,StrMenu3B1,0,MenuItem_Setting_Backdrop
	MENUITEM   NM_SUB,StrMenu3B2,0,MenuItem_Setting_Backdrop
	MENUITEM  NM_ITEM,StrMenu3C
	MENUITEM   NM_SUB,StrMenu3C1,0,MenuItem_Setting_Borderless
	MENUITEM   NM_SUB,StrMenu3C2,0,MenuItem_Setting_Borderless
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu3D
	MENUITEM   NM_SUB,StrMenu3D1,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D2,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D3,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D4,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D5,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D6,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D7,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D8,0,MenuItem_Setting_Skin
	MENUITEM NM_END,0

;-----------------------------------------------------------

	CNOP 0,4

MyTextA1:   TEXTATTR TextFontName1,13,FSF_BOLD
MyTextA2:   TEXTATTR TextFontName2,10,FS_NORMAL
MyTextA3:   TEXTATTR TextFontName3,06,FS_NORMAL

MyIText1:   ITEXT 1,1,0,000,044,MyTextA1,StrCPU1,MyIText2
MyIText2:   ITEXT 2,1,1,014,154,MyTextA1,StrBoard0,MyIText3
MyIText3:   ITEXT 2,1,0,000,061,MyTextA2,StrFREQ,MyIText4
MyIText4:   ITEXT 2,1,0,000,069,MyTextA2,StrMULT,MyIText5
MyIText5:   ITEXT 2,1,0,014,170,MyTextA3,StrCHIP,MyIText6
MyIText6:   ITEXT 2,1,0,014,176,MyTextA3,StrFAST,MyIText7
MyIText7:   ITEXT 2,1,0,014,182,MyTextA3,StrSLOW,MyIText8
MyIText8:   ITEXT 1,1,0,000,140,MyTextA3,StrTEMP,MyIText9
MyIText9:   ITEXT 1,1,0,000,055,MyTextA3,StrREV,MyITextA
MyITextA:   ITEXT 2,1,0,114,114,MyTextA3,StrIPC1,0

MyITextCP1: ITEXT 4,1,0,046,121,MyTextA3,StrCP1,MyITextCP2
MyITextCP2: ITEXT 4,1,0,046,127,MyTextA3,StrCP2,MyITextCFP
MyITextCFP: ITEXT 4,1,0,046,133,MyTextA3,StrCFP,MyITextIPC
MyITextIPC: ITEXT 2,1,0,130,114,MyTextA3,StrIPC,0

;-----------------------------------------------------------

	CNOP 0,4

BoardArray:
	DC.L StrBoard0,StrBoard1,StrBoard2,StrBoard3
	DC.L StrBoard4,StrBoard5,StrBoard6,StrBoard7

StrBoard0:        DC.B "Vxxx",0
StrBoard1:        DC.B "V600",0
StrBoard2:        DC.B "V500",0
StrBoard3:        DC.B "·V4·",0
StrBoard4:        DC.B "V666",0
StrBoard5:        DC.B "V4SA",0
StrBoard6:        DC.B "V1K2",0
StrBoard7:        DC.B "Vxxx",0

;-----------------------------------------------------------

	CNOP 0,4

StrMenu1:         DC.B "Project",0
StrMenu1A:        DC.B "Help...",0
StrMenu1A_:       DC.B "H",0
StrMenu1B:        DC.B "Iconify",0
StrMenu1B_:       DC.B "I",0
StrMenu1C:        DC.B "About...",0
StrMenu1C_:       DC.B "?",0
StrMenu1D:        DC.B "Quit",0
StrMenu1D_:       DC.B "Q",0

StrMenu2:         DC.B "Edit",0
StrMenu2A:        DC.B "FPU switch",0
StrMenu2A1:       DC.B "0: Disable",0
StrMenu2A2:       DC.B "1: Enable",0
StrMenu2B:        DC.B "SuperScalar",0
StrMenu2B1:       DC.B "0: Disable",0
StrMenu2B2:       DC.B "1: Enable",0
StrMenu2C:        DC.B "Turtle mode",0
StrMenu2C1:       DC.B "0: Disable",0
StrMenu2C2:       DC.B "1: Enable",0
StrMenu2D:        DC.B "FastIDE speed",0
StrMenu2D1:       DC.B "0: Slow",0
StrMenu2D2:       DC.B "1: Fast",0
StrMenu2D3:       DC.B "2: Faster",0
StrMenu2D4:       DC.B "3: Fastest",0
StrMenu2E:        DC.B "MicroSD speed",0
StrMenu2E1:       DC.B "0: Fastest",0
StrMenu2E2:       DC.B "1: Faster",0
StrMenu2E3:       DC.B "2: Slow",0
StrMenu2E4:       DC.B "3: Slower",0
StrMenu2E5:       DC.B "Set Divider value...",0
StrMenu2F:        DC.B "Get Serial-Number...",0

StrMenu3:         DC.B "Settings",0
StrMenu3A:        DC.B "Refresh rate",0
StrMenu3A1:       DC.B "Hz / (2^0) (slowest)",0
StrMenu3A2:       DC.B "Hz / (2^1)",0
StrMenu3A3:       DC.B "Hz / (2^2)",0
StrMenu3A4:       DC.B "Hz / (2^3)",0
StrMenu3A5:       DC.B "Hz / (2^4)",0
StrMenu3A6:       DC.B "Hz / (2^5) (fastest)",0
StrMenu3B:        DC.B "Backdrop",0
StrMenu3B1:       DC.B "0: Disable",0
StrMenu3B2:       DC.B "1: Enable",0
StrMenu3C:        DC.B "Borderless",0
StrMenu3C1:       DC.B "0: Disable",0
StrMenu3C2:       DC.B "1: Enable",0
StrMenu3D:        DC.B "Skin...",0
StrMenu3D1:       DC.B "Skin Black",0
StrMenu3D2:       DC.B "Skin Blue",0
StrMenu3D3:       DC.B "Skin Orange",0
StrMenu3D4:       DC.B "Skin Red",0
StrMenu3D5:       DC.B "Skin Grey dark",0
StrMenu3D6:       DC.B "Skin Grey light",0
StrMenu3D7:       DC.B "Skin White",0
StrMenu3D8:       DC.B "Skin Yellow",0

StrREV:           DS.B 16
StrIPC:           DS.B 16
StrTEMP:          DS.B 32
StrFREQ:          DS.B 16
StrMULT:          DS.B 16
StrCHIP:          DS.B 16
StrFAST:          DS.B 16
StrSLOW:          DS.B 16
StrCP1:           DC.B "1",0
StrCP2:           DC.B "2",0
StrCFP:           DC.B "F",0
StrIPC1:          DC.B "IPC:",0
StrCPU1:          DC.B "AC68RC080",0
StrCPU2:          DC.B "AC68LC080",0

FmtREV:           DC.B "REV%lu",0
FmtFREQ:          DC.B "%luMHz",0
FmtMULT:          DC.B "x%lu",0
FmtCHIP:          DC.B "C: %3luMB",0
FmtFAST:          DC.B "F: %3luMB",0
FmtSLOW:          DC.B "S: %3luMB",0
FmtIPC:           DC.B "%2ld.%02ld",0

StrError1:        DC.B "This program requires an AC68080 !",10,0

;-----------------------------------------------------------

	CNOP 0,4

ReqAboutTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTEZ_DefaultResponse,1
	DC.L RTEZ_Flags,EZREQF_CENTERTEXT
	DC.L RTEZ_ReqTitle,ReqAboutTitle
	DC.L TAG_DONE

ReqAboutTitle:
	DC.B "About",0

ReqAboutBody:
	DC.B "VCPU %s (%s)",10,10
	DC.B "%s",10
	DC.B "Written by %s",10,10
	DC.B "%s",10,10
	DC.B "Copyright %s",10,10
	DC.B "Enjoy your Vampire :)",0

ReqAboutGads:
	DC.B "_Okay",0

;-----------------------------------------------------------

	CNOP 0,4

ReqSDSelectTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTGL_Min,0
	DC.L RTGL_Max,255
	DC.L RTGL_TextFmt,ReqSDSelectText
	DC.L TAG_DONE

ReqSDAcceptTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTEZ_DefaultResponse,1
	DC.L RTEZ_ReqTitle,ReqSDTitle
	DC.L TAG_DONE

ReqSDTitle:
	DC.B "MicroSD Speed",0

ReqSDSelectText:
	DC.B "To modify the speed of the MicroSD port,",10
	DC.B "Enter a new value for the SDClockDivider.",10,10
	DC.B "The lowest value (0), the fastest.",10
	DC.B "The highest value (255), the slowest.",10,10

ReqSDAcceptBody:
	DC.B "WARNING:",10
	DC.B "A value of '0' may NOT work on your media !",10
	DC.B "Always test with read operations before you",10
	DC.B "start write any data to your SDCard media.",10,10
	DC.B "No warranty is provided,",10
	DC.B "use this feature at your own risk.",0

ReqSDAcceptGads:
	DC.B "_Accept|_Cancel",0

;-----------------------------------------------------------

	CNOP 0,4

ReqFPUTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTEZ_DefaultResponse,1
	DC.L RTEZ_ReqTitle,ReqFPUTitle
	DC.L RTEZ_Flags,EZREQF_CENTERTEXT
	DC.L TAG_DONE

ReqFPUTitle:
	DC.B "Request",0

ReqFPUBody:
	DC.B "In order to %s the Floating-Point Unit,",10,10
	DC.B "AmigaOS Exec needs to be fully reinitialized.",10,10
	DC.B "Please wait until all disk activity has ended !",0

ReqFPUGads:
	DC.B "_Reboot|_Cancel",0

;-----------------------------------------------------------

	CNOP 0,4

ReqSNTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTEZ_DefaultResponse,1
	DC.L RTEZ_Flags,EZREQF_CENTERTEXT
	DC.L RTEZ_ReqTitle,ReqSNTitle
	DC.L TAG_DONE

ReqSNBuffer:      DC.B "0000000000000000-0",0
ReqSNTitle:       DC.B "Hardware information",0
ReqSNBody:        DC.B "Serial-Number of your Vampire",10,10,"0x%s",0
ReqSNGads:        DC.B "_Okay|_Copy to clipboard",0

;-----------------------------------------------------------

	CNOP 0,4

AmigaGuideName:   DC.B "amigaguide.library",0
CommoditiesName:  DC.B "commodities.library",0
DiskfontName:     DC.B "diskfont.library",0
DOSName:          DC.B "dos.library",0
GadtoolsName:     DC.B "gadtools.library",0
GfxName:          DC.B "graphics.library",0
GuiGfxName:       DC.B "guigfx.library",0
IconName:         DC.B "icon.library",0
IntuitionName:    DC.B "intuition.library",0
ReqtoolsName:     DC.B "reqtools.library",0
ScreenNotifyName: DC.B "screennotify.library",0
UtilityName:      DC.B "utility.library",0

;-----------------------------------------------------------

	CNOP 0,4

TextFontName1:    DC.B "Apparent.font",0
TextFontName2:    DC.B "Dina.font",0
TextFontName3:    DC.B "Condensed60.font",0

;-----------------------------------------------------------

	CNOP 0,4

SkinArray:
	DC.L FileWinBG1,FileWinBG2
	DC.L FileWinBG3,FileWinBG4
	DC.L FileWinBG5,FileWinBG6
	DC.L FileWinBG7,FileWinBG8

FileWinBG:        DC.L FileWinBG1
FileWinBG1:       DC.B "PROGDIR:Gfx/WinBG1.png",0
FileWinBG2:       DC.B "PROGDIR:Gfx/WinBG2.png",0
FileWinBG3:       DC.B "PROGDIR:Gfx/WinBG3.png",0
FileWinBG4:       DC.B "PROGDIR:Gfx/WinBG4.png",0
FileWinBG5:       DC.B "PROGDIR:Gfx/WinBG5.png",0
FileWinBG6:       DC.B "PROGDIR:Gfx/WinBG6.png",0
FileWinBG7:       DC.B "PROGDIR:Gfx/WinBG7.png",0
FileWinBG8:       DC.B "PROGDIR:Gfx/WinBG8.png",0
FileBarFG1:       DC.B "PROGDIR:Gfx/BarFG1.png",0
FileBarBG1:       DC.B "PROGDIR:Gfx/BarBG1.png",0

;-----------------------------------------------------------

	CNOP 0,4

APP_NAME:         DC.B "VCPU",0
APP_GUIDE:        DC.B "VCPU.guide",0
APP_VERSION:      DC.B "0.1c",0
APP_RELEASEDATE:  DC.B "15.11.2019",0
APP_AUTHOR:       DC.B "flype",0
APP_DESCRIPTION:  DC.B "Vampire CPU monitor tool",0
APP_COMMENT:      DC.B "· In memory of Gouky ·",0
APP_COPYRIGHT:    DC.B "© 2016-2019 APOLLO-Team",0

APP_VERSTRING:
	DC.B "$VER: VCPU 0.1c (15.11.2019) "
	DC.B "(C) 2016-2019 APOLLO-Team.",0,0,0

************************************************************
*
* END OF FILE
*
************************************************************

	END
