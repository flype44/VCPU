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
* [X] Settings->Skins...
* [X] Settings->Backdrop
* [X] Settings->Borderless
* [X] Settings->RefreshRate
* [X] ToolTypes Load
* [_] ToolTypes Save
* [X] Iconify
* [X] Commodity General
* [_] Commodity HotKeys
* [_] Handle CTRL+C
* [_] Use Wait(signals)
* [_] Use Checkboxes in MenuItems
* [_] Skin engine
* 
************************************************************

	INCDIR     progdir:include

	INCLUDE    dos/dos.i
	INCLUDE    dos/dosextens.i
	INCLUDE    dos/dos_lib.i
	INCLUDE    exec/exec.i
	INCLUDE    exec/exec_lib.i
	INCLUDE    devices/clipboard.i
	INCLUDE    devices/timer.i
	INCLUDE    devices/timer_lib.i
	INCLUDE    diskfont/diskfont.i
	INCLUDE    diskfont/diskfont_lib.i
	INCLUDE    graphics/gfxbase.i
	INCLUDE    graphics/rastport.i
	INCLUDE    graphics/graphics_lib.i
	INCLUDE    graphics/layers_lib.i
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
	INCLUDE    workbench/wb_lib.i

	INCLUDE    inc/guigfx.i
	INCLUDE    inc/guigfx_lib.i
	INCLUDE    inc/reqtools.i
	INCLUDE    inc/reqtools_lib.i
	INCLUDE    inc/screennotify.i
	INCLUDE    inc/screennotify_lib.i
	INCLUDE    inc/vampire.i
	INCLUDE    inc/vampire_lib.i
	INCLUDE    inc/V_Macros.i

************************************************************
*
* CONSTANTS
*
************************************************************

WIN_LEFT       EQU   0
WIN_TOP        EQU  18
WIN_WIDTH      EQU 200
WIN_HEIGHT     EQU 200

APP_GUISTATE_NONE     EQU 0
APP_GUISTATE_SHOW     EQU 1
APP_GUISTATE_HIDE     EQU 2

APP_RUNSTATE_NONE     EQU 0
APP_RUNSTATE_ENABLED  EQU 1
APP_RUNSTATE_DISABLED EQU 2
APP_RUNSTATE_QUIT     EQU 3

************************************************************
*
* STRUCTURES
*
************************************************************

	RSRESET
ggt_Tag0       RS.L 1
ggt_SrcX       RS.L 1
ggt_Tag1       RS.L 1
ggt_SrcY       RS.L 1
ggt_Tag2       RS.L 1
ggt_SrcW       RS.L 1
ggt_Tag3       RS.L 1
ggt_SrcH       RS.L 1
ggt_Tag4       RS.L 1
ggt_DstW       RS.L 1
ggt_Tag5       RS.L 1
ggt_DstH       RS.L 1
ggt_SIZEOF     RS.L 0

	RSRESET
bar_Cnt        RS.L 1   ; Counter
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
.wbStart
	suba.l     a1,a1                           ; Name
	CALLEXEC   FindTask                        ; (Name)(a1)
	move.l     d0,a4                           ; Process
	move.l     pr_CLI(a4),d0                   ; Process->CLI
	bne.s      .openLibs                       ; Skip
	lea.l      pr_MsgPort(a4),a0               ; Process->MsgPort
	CALLEXEC   WaitPort                        ; (MsgPort)(a0)
	lea.l      pr_MsgPort(a4),a0               ; Process->MsgPort
	CALLEXEC   GetMsg                          ; (MsgPort)(a0)
	move.l     d0,WBStartMsg                   ; WBStart message
.openLibs
	LIBOPEN    DOS                             ; Open all
	LIBOPEN    AmigaGuide                      ; libraries
	LIBOPEN    Commodities                     ; 
	LIBOPEN    Diskfont                        ; 
	LIBOPEN    Icon                            ; 
	LIBOPEN    Intuition                       ; 
	LIBOPEN    Gadtools                        ; 
	LIBOPEN    Gfx                             ; 
	LIBOPEN    GuiGfx                          ; 
	LIBOPEN    Layer                           ; 
	LIBOPEN    Reqtools                        ; 
	LIBOPEN    ScreenNotify                    ; 
	LIBOPEN    Utility                         ; 
	LIBOPEN    Workbench                       ; 
.checkCPU
	bsr        V_CPU_Detect080                 ; AC68080 ?
	tst.l      d0                              ; 
	bne.s      .checkDone                      ; 
	lea.l      StrError1(pc),a0                ; 
	move.l     a0,d1                           ; 
	CALLDOS    PutStr                          ; 
	bra.s      .closeLibs                      ; 
.checkDone
	bsr        APP_OPEN                        ; 
	bsr        APP_LOOP                        ; 
	bsr        APP_CLOSE                       ; 
	move.l     #RETURN_OK,_RC                  ; Return Code
.closeLibs
	LIBCLOSE   Workbench                       ; Close all
	LIBCLOSE   Utility                         ; libraries
	LIBCLOSE   ScreenNotify                    ; 
	LIBCLOSE   Reqtools                        ; 
	LIBCLOSE   Layer                           ; 
	LIBCLOSE   GuiGfx                          ; 
	LIBCLOSE   Gfx                             ; 
	LIBCLOSE   Gadtools                        ; 
	LIBCLOSE   Intuition                       ; 
	LIBCLOSE   Icon                            ; 
	LIBCLOSE   Diskfont                        ; 
	LIBCLOSE   Commodities                     ; 
	LIBCLOSE   AmigaGuide                      ; 
	LIBCLOSE   DOS                             ; 
.closeWB
	move.l     WBStartMsg(pc),d0               ; Msg
	beq.s      .exit                           ; Skip
	CALLEXEC   Forbid                          ; (void)
	move.l     WBStartMsg(pc),a1               ; Msg
	CALLEXEC   ReplyMsg                        ; (Msg)(a1)
.exit
	move.l     _RC,d0                          ; DOS Result
	rts                                        ; Exit Program

************************************************************
*
* APPLICATION FUNCTIONS
*
************************************************************

APP_OPEN:
	bsr        ScreenNotify_Install            ; Install
	bsr        CxBroker_Install                ; Components
	bsr        Counters_Install                ; 
	bsr        Iconify_Install                 ; 
	bsr        Sensors_Install                 ; 
	bsr        ToolTypes_Load                  ; 
	bsr        Diskfonts_Open                  ; 
	bsr        APP_SHOW                        ; SHOW
	rts                                        ; Return

;-----------------------------------------------------------

APP_CLOSE:
	bsr        APP_HIDE                        ; HIDE
	bsr        Diskfonts_Close                 ; 
	bsr        ToolTypes_Save                  ; 
	bsr        Sensors_Uninstall               ; 
	bsr        Iconify_Uninstall               ; Uninstall
	bsr        Counters_Uninstall              ; 
	bsr        CxBroker_Uninstall              ; Components
	bsr        ScreenNotify_Uninstall          ; 
	rts                                        ; Return

;-----------------------------------------------------------

APP_SHOW:

	lea.l      BarCP1(pc),a0                   ; 
	move.l     #0,bar_Val1(a0)                 ; 
	move.l     #1,bar_Val2(a0)                 ; 

	lea.l      BarCP2(pc),a0                   ; 
	move.l     #0,bar_Val1(a0)                 ; 
	move.l     #1,bar_Val2(a0)                 ; 

	lea.l      BarCFP(pc),a0                   ; 
	move.l     #0,bar_Val1(a0)                 ; 
	move.l     #1,bar_Val2(a0)                 ; 

	bsr        GetAvailMem                     ; infos
	bsr        GetHWInfos                      ; infos
	move.l     #4,d2
	bsr        MenuItem_Setting_RefreshRate    ; rate

	bsr        Sensors_ReadTemp                ; 
	lea.l      StrTEMP(pc),a0                  ; 
	bsr        Sensors_TempToString            ; 

	bsr        Iconify_Remove                  ; 
	bsr        Window_Open                     ; 
	bsr        Window_ObtainPens               ; 
	bsr        Diskfonts_CenterIText           ; 
	bsr        GuiGfx_OpenAll                  ; 
	bsr        GuiGfx_DrawBack                 ; 
	bsr        Counters_Draw                   ; 

	clr.l      d0                              ; 
	clr.l      d1                              ; 
	move.l     MyScreenNotifyPort(pc),a0       ; scn
	move.b     MP_SIGBIT(a0),d1                ; 
	bset.l     d1,d0                           ; 
	lea.l      AppSignalSCN(pc),a0             ; 
	move.l     d0,(a0)                         ; 

	move.l     MyCountersPort(pc),a0           ; cnt
	move.b     MP_SIGBIT(a0),d1                ; 
	bset.l     d1,d0                           ; 

	move.l     MyCxPort(pc),a0                 ; cxb
	move.b     MP_SIGBIT(a0),d1                ; 
	bset.l     d1,d0                           ; 

	move.l     MyAppIconPort(pc),a0            ; ico
	move.b     MP_SIGBIT(a0),d1                ; 
	bset.l     d1,d0                           ; 

	move.l     MyWindow(pc),a0                 ; win
	move.l     wd_UserPort(a0),a0              ; 
	move.b     MP_SIGBIT(a0),d1                ; 
	bset.l     d1,d0                           ; 

	lea.l      AppSignalSet(pc),a0             ; 
	move.l     d0,(a0)                         ; 

	rts                                        ; Return

;-----------------------------------------------------------

APP_HIDE:
	bsr        GuiGfx_CloseAll                 ; 
	bsr        Window_Close                    ; 
	rts                                        ; Return

;-----------------------------------------------------------

APP_REOPEN:
	bsr        APP_HIDE                        ; 
	bsr        APP_SHOW                        ; 
	rts                                        ; Return

;-----------------------------------------------------------

APP_LOOP:
	movem.l    d0-a6,-(sp)                     ; Push
.loop
	move.l     AppSignalSet(pc),d0             ; SignalSet
	CALLEXEC   Wait                            ; (SignalSet)(d0)
	btst       
	bra.s      .exit
*	bsr        Counters_Events                 ; MsgPort -> Counters
*	bsr        ScreenNotify_Events             ; MsgPort -> ScreenNotify
*	bsr        CxBroker_Events                 ; MsgPort -> Commodities
*	bsr        Iconify_Events                  ; MsgPort -> AppIcon
*	bsr        Window_Events                   ; MsgPort -> Window
.guistate
	move.l     AppGuiState(pc),d0              ; GuiState
	cmp.l      #APP_GUISTATE_NONE,d0           ; 
	beq.s      .runstate                       ; 
	cmp.l      #APP_GUISTATE_HIDE,d0           ; 
	beq.s      .guistatehide                   ; 
	cmp.l      #APP_GUISTATE_SHOW,d0           ; 
	beq.s      .guistateshow                   ; 
.guistatehide
	bsr        APP_HIDE                        ; 
	clr.l      AppGuiState                     ; 
	bra.s      .skip                           ; 
.guistateshow
	bsr        APP_SHOW                        ; 
	clr.l      AppGuiState                     ; 
	bra.s      .skip                           ; 
.runstate
	move.l     AppRunState(pc),d0              ; RunState
	cmp.l      #APP_RUNSTATE_QUIT,d0           ; 
	beq.s      .exit                           ; 
	cmp.l      #APP_RUNSTATE_DISABLED,d0       ; 
	beq.s      .skip                           ; 
.update
	bsr        LED1_Update                     ; 
	bsr        Counters_Update                 ; 
	bsr        Counters_Draw                   ; 
*	bsr        Window_UpdateTXT                ; Update Infos
.skip
	moveq.l    #2,d1                           ; ticks
	CALLDOS    Delay                           ; (ticks)(d1)
	bra.w      .loop                           ; continue
.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; Return

************************************************************
*
* MENUITEM FUNCTIONS
*
************************************************************

MenuItem_Quit:
	lea.l      AppRunState(pc),a0              ; RunState
	move.l     #APP_RUNSTATE_QUIT,(a0)         ; RunState = QUIT
	rts                                        ; Return

;-----------------------------------------------------------

MenuItem_About:
	movem.l    a2/a3/a4/a6,-(sp)               ; Push
	lea.l      ReqAboutTags(pc),a0             ; Tags
	move.l     MyWindow(pc),4+(0*8)(a0)        ; Window
	lea.l      ReqAboutBody(pc),a1             ; Body
	lea.l      ReqAboutGads(pc),a2             ; Gadgets
	suba.l     a3,a3                           ; ReqInfo
	lea.l      ValBUFFER(pc),a4                ; Args
	move.l     #APP_NAME,0*4(a4)               ; Args[0]
	move.l     #APP_VERSION,1*4(a4)            ; Args[1]
	move.l     #APP_RELEASEDATE,2*4(a4)        ; Args[2]
	move.l     #APP_DESCRIPTION,3*4(a4)        ; Args[3]
	move.l     #APP_AUTHOR,4*4(a4)             ; Args[4]
	move.l     #APP_COMMENT,5*4(a4)            ; Args[5]
	move.l     #APP_COPYRIGHT,6*4(a4)          ; Args[6]
	CALLRT     rtEZRequestA                    ; (Tags,Body,Gads,ReqInfo,Args)(a0,a1,a2,a3,a4)
	movem.l    (sp)+,a2/a3/a4/a6               ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

MenuItem_Help:
	movem.l    a2/a3/a6,-(sp)                  ; Push
.lock
	bsr        Window_Lock                     ; Lock
.guide
	lea.l      APP_NAME(pc),a1                 ; Basename
	lea.l      APP_GUIDE(pc),a2                ; Filename
	lea.l      MyNewAmigaGuide(pc),a0          ; NewAmigaGuide
	move.l     a1,nag_BaseName(a0)             ; Nag.nag_BaseName
	move.l     a2,nag_Name(a0)                 ; Nag.nag_Name
	suba.l     a1,a1                           ; Tags
	CALLAG     OpenAmigaGuideA                 ; (Nag,Tags)(a0,a1)
	tst.l      d0                              ; Null ?
	beq.s      .unlock                         ; Skip
	move.l     d0,a0                           ; Handle
	CALLAG     CloseAmigaGuide                 ; (Handle)(a0)
.unlock
	bsr        Window_Unlock                   ; Unlock
.exit
	movem.l    (sp)+,a2/a3/a6                  ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

MenuItem_Iconify:
	bsr        Iconify_Add                     ; AddAppIcon
	rts                                        ; return

;-----------------------------------------------------------

MenuItem_FPUSwitch:
	movem.l    d2/a2/a3/a4/a6,-(sp)            ; Push
.request
	lea.l      ReqFPUBody(pc),a1               ; Body
	lea.l      ReqFPUGads(pc),a2               ; Gadgets
	suba.l     a3,a3                           ; ReqInfo
	tst.w      d2                              ; MenuNum->Sub
	bne.s      1$                              ; Skip
	lea.l      StrDisable(pc),a0               ; String
	bra.s      2$                              ; Skip
1$	lea.l      StrEnable(pc),a0                ; String
2$	lea.l      ValBUFFER(pc),a4                ; Array
	move.l     a0,(a4)                         ; Array[0]
	lea.l      ReqFPUTags(pc),a0               ; Tags
	move.l     MyWindow(pc),4(a0)              ; Tags[0]
	CALLRT     rtEZRequestA                    ; (a0,a1,a2,a3,a4)
	cmp.l      #1,d0                           ; Result
	bne.s      .exit                           ; Skip
.switch
	CALLEXEC   Disable                         ; Multitask Off
	tst.w      d2                              ; MenuNum->Sub
	bne.s      3$                              ; Skip
	bsr        V_CPU_DFP_On                    ; Disable FPU
	bra.s      4$                              ; Skip
3$	bsr        V_CPU_DFP_Off                   ; Enable FPU
4$	CALLEXEC   ColdReboot                      ; Reboot
	CALLEXEC   Enable                          ; Multitask On
.exit
	movem.l    (sp)+,d2/a2/a3/a4/a6            ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

MenuItem_SuperScalar:
	movem.l    d2-d7/a2-a6,-(sp)               ; Push
.item
	cmp.w      #0,d2                           ; MenuNum->sub
	beq.s      .item0                          ; Goto
	cmp.w      #1,d2                           ; MenuNum->sub
	beq.s      .item1                          ; Goto
	bra.s      .exit                           ; Skip
.item0
	bsr        V_CPU_ESS_Off                   ; Poke
	bra.s      .exit                           ; Skip
.item1
	bsr        V_CPU_ESS_On                    ; Poke
.exit
	movem.l    (sp)+,d2-d7/a2-a6               ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

MenuItem_TurtleMode:
	movem.l    d2-d7/a2-a6,-(sp)               ; Push
.item
	cmp.w      #0,d2                           ; MenuNum->Sub
	beq.s      .item0                          ; Goto
	cmp.w      #1,d2                           ; MenuNum->Sub
	beq.s      .item1                          ; Goto
	bra.s      .exit                           ; Skip
.item0
	bsr        V_CPU_ICACHE_On                 ; Poke
	bra.s      .exit                           ; Skip
.item1
	bsr        V_CPU_ICACHE_Off                ; Poke
.exit
	movem.l    (sp)+,d2-d7/a2-a6               ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

MenuItem_FastIDE:
	movem.l    d2-d7/a2-a6,-(sp)               ; Push
.getValue
	move.l     d2,d0                           ; MenuNum->Sub
	andi.l     #$ff,d0                         ; UByte
	cmp.l      #VREG_FASTIDE_FASTEST,d0        ; Max ?
	bls.s      .setValue                       ; Skip
	move.l     #VREG_FASTIDE_FASTEST,d0        ; Max
.setValue
	SETFASTIDE d0                              ; Poke
.exit
	movem.l    (sp)+,d2-d7/a2-a6               ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

MenuItem_SDClockDivider:
	movem.l    d2-d7/a2-a6,-(sp)               ; Push
	cmp.w      #5,d2                           ; MenuNum->Sub
	bne.s      .fromMenu                       ; Skip
.fromUser
	lea.l      ValSDValue(pc),a1               ; Num
	lea.l      ReqSDTitle(pc),a2               ; Title
	sub.l      a3,a3                           ; ReqInfo
	lea.l      ReqSDSelectTags(pc),a0          ; Tags
	move.l     MyWindow(pc),4(a0)              ; Tags[0]
	CALLRT     rtGetLongA                      ; (Num,Title,ReqInfo,Tags)(a1,a2,a3,a0)
	tst.l      d0                              ; Result
	beq.s      .exit                           ; Cancelled
	bra.s      .checkZero                      ; Accepted
.fromMenu
	andi.l     #$ff,d2                         ; UByte
	move.l     d2,ValSDValue                   ; Num
.checkZero
	tst.l      ValSDValue(pc)                  ; Num
	bne.s      .apply                          ; Num > 0 is ok
	lea.l      ReqSDAcceptBody(pc),a1          ; Body
	lea.l      ReqSDAcceptGads(pc),a2          ; Gadgets
	suba.l     a3,a3                           ; ReqInfo
	suba.l     a4,a4                           ; Array
	lea.l      ReqSDAcceptTags(pc),a0          ; Tags
	move.l     MyWindow(pc),4(a0)              ; Tags[0]
	CALLRT     rtEZRequestA                    ; (a0,a1,a2,a3,a4)
	cmp.l      #1,d0                           ; Result
	bne.s      .exit                           ; Skip
.apply
	move.l     ValSDValue(pc),d0               ; Num
	SETSDCLOCKDIV d0                           ; Poke
.exit
	movem.l    (sp)+,d2-d7/a2-a6               ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

MenuItem_SerialNumber:
	movem.l    d2-d7/a2-a6,-(sp)               ; Push
.readsn
	lea.l      ReqSNBuffer(pc),a5              ; Buffer
	move.l     a5,a0                           ; Buffer
	bsr        _v_read_sn                      ; Read S/N
	tst.l      d0                              ; Success ?
	beq.s      .exit                           ; Skip
.request
	lea.l      ReqSNBody(pc),a1                ; Body
	lea.l      ReqSNGads(pc),a2                ; Gadgets
	suba.l     a3,a3                           ; ReqInfo
	lea.l      ValBUFFER(pc),a4                ; Array
	move.l     a5,(a4)                         ; Array[0]
	lea.l      ReqSNTags(pc),a0                ; Tags
	move.l     MyWindow(pc),4(a0)              ; Tags[0]
	CALLRT     rtEZRequestA                    ; (a0,a1,a2,a3,a4)
	tst.l      d0                              ; Result
	bne.s      .exit                           ; Skip
.copy
	lea.l      ReqSNBuffer(pc),a0              ; Buffer
	bsr        Clipboard_Write                 ; Copy to clipboard
.exit
	movem.l    (sp)+,d2-d7/a2-a6               ; Pop
	rts                                        ; Return

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
	andi.l     #$ffff,d2                       ; menunum->sub
	lea.l      MyOpenWindowTags(pc),a0         ; taglist
	move.l     d2,4+(6*8)(a0)                  ; taglist[] -> WA_Backdrop
	bsr        APP_REOPEN                      ; close & reopen
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

MenuItem_Setting_Borderless:
	movem.l    d0-a6,-(sp)                     ; push
	andi.l     #$ffff,d2                       ; menunum->sub
	move.l     d2,d1                           ; !bool
	neg.l      d1                              ; !bool
	not.l      d1                              ; !bool
	lea.l      MyOpenWindowTags(pc),a0         ; taglist
	move.l     d2,4+(07*8)(a0)                 ; taglist[] -> WA_Borderless
	move.l     d1,4+(08*8)(a0)                 ; taglist[] -> WA_CloseGadget
	move.l     d1,4+(09*8)(a0)                 ; taglist[] -> WA_DepthGadget
	move.l     d1,4+(10*8)(a0)                 ; taglist[] -> WA_DragBar
	bsr        APP_REOPEN                      ; close & reopen
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
	bsr        APP_REOPEN                      ; close & reopen
.exit
	movem.l    (sp)+,d0-a6                     ; pop
	rts                                        ; return

;-----------------------------------------------------------

MenuItem_Setting_ForeColor:

	movem.l    d0-a6,-(sp)                     ; Push

	lea.l      StrMenu3E(pc),a2                ; Gadgets
	suba.l     a3,a3                           ; ReqInfo
	lea.l      ReqPaletteTags(pc),a0           ; Tags
	move.l     MyWindow(pc),4(a0)              ; Tags[0]
	CALLRT     rtPaletteRequestA               ; (Title,ReqInfo,Tags)(a2,a3,a0)
	lea.l      ForegroundPen(pc),a0            ; Pen
	move.l     d0,(a0)                         ; Pen

	move.l     MyWindow(pc),a0                 ; Window
	move.l     wd_WScreen(a0),a0               ; Window->Screen
	adda.l     #sc_ViewPort,a0                 ; Screen.ViewPort
	adda.l     #vp_ColorMap,a0                 ; ViewPort.ColorMap
	move.l     (a0),a0                         ; ColorMap
	move.l     ForegroundPen(pc),d0            ; FirstColor
	moveq.l    #1,d1                           ; NColors
	lea.l      ForegroundRGB32(pc),a1          ; Table
	CALLGRAF   GetRGB32                        ; (ColorMap,FirstColor,NColors,Table)(a0,d0,d1,a1)

	bsr        APP_REOPEN                      ; close & reopen
	
.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

MenuItem_Setting_BackColor:

	movem.l    d0-a6,-(sp)                     ; Push

	lea.l      StrMenu3F(pc),a2                ; Gadgets
	suba.l     a3,a3                           ; ReqInfo
	lea.l      ReqPaletteTags(pc),a0           ; Tags
	move.l     MyWindow(pc),4(a0)              ; Tags[0]
	CALLRT     rtPaletteRequestA               ; (Title,ReqInfo,Tags)(a2,a3,a0)
	lea.l      BackgroundPen(pc),a0            ; Pen
	move.l     d0,(a0)                         ; Pen

	move.l     MyWindow(pc),a0                 ; Window
	move.l     wd_WScreen(a0),a0               ; Window->Screen
	adda.l     #sc_ViewPort,a0                 ; Screen.ViewPort
	adda.l     #vp_ColorMap,a0                 ; ViewPort.ColorMap
	move.l     (a0),a0                         ; ColorMap
	move.l     BackgroundPen(pc),d0            ; FirstColor
	moveq.l    #1,d1                           ; NColors
	lea.l      BackgroundRGB32(pc),a1          ; Table
	CALLGRAF   GetRGB32                        ; (ColorMap,FirstColor,NColors,Table)(a0,d0,d1,a1)

	bsr        APP_REOPEN                      ; close & reopen
	
.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; Return

************************************************************
*
* WINDOW FUNCTIONS
*
************************************************************

GuiGfx_OpenAll:

	movem.l    d1-a6,-(sp)                     ; Push

.psmcreate
	lea.l      GuiGfxTags(pc),a0               ; tags
	CALLGUIGFX CreatePenShareMapA              ; (tags)(a0)
	tst.l      d0                              ; 
	beq        .exit                           ; 
	move.l     d0,GuiGfxPenShareMap            ; psm

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

.picload1
	move.l     FileWinBG(pc),a0                ; filename
	lea.l      LoadPicTags(pc),a1              ; tags
	CALLGUIGFX LoadPictureA                    ; (filename,tags)(a0,a1)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 
	move.l     d0,GuiGfxPic1                   ; pic

.picload1ori
	move.l     FileWinBG(pc),a0                ; filename
	lea.l      LoadPicTags(pc),a1              ; tags
	CALLGUIGFX LoadPictureA                    ; (filename,tags)(a0,a1)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 
	move.l     d0,GuiGfxPic1ori                ; pic

.picload2
	lea.l      FileBarBG1(pc),a0               ; filename
	lea.l      LoadPicTags(pc),a1              ; tags
	CALLGUIGFX LoadPictureA                    ; (filename,tags)(a0,a1)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 
	move.l     d0,GuiGfxPic2                   ; pic

.picload3
	lea.l      FileBarFG1(pc),a0               ; filename
	lea.l      LoadPicTags(pc),a1              ; tags
	CALLGUIGFX LoadPictureA                    ; (filename,tags)(a0,a1)
	tst.l      d0                              ; 
	beq        .psmdel                         ; 
	move.l     d0,GuiGfxPic3                   ; pic

.picmethod1
	move.l     GuiGfxPic1(pc),a0               ; Picture
	move.l     #PICMTHD_TINT,d0                ; Method
	lea.l      ForegroundRGB32(pc),a1          ; Color
	move.l     0(a1),d1                        ; RRRR
	move.l     4(a1),d2                        ; GGGG
	move.l     8(a1),d3                        ; BBBB
	andi.l     #$ff0000,d1                     ; 0R--
	andi.l     #$00ff00,d2                     ; 0-G-
	andi.l     #$0000ff,d3                     ; 0--B
	or.l       d2,d1                           ; 0RG-
	or.l       d3,d1                           ; 0RGB
	lea.l      ValBUFFER(pc),a1                ; Args
	move.l     d1,0(a1)                        ; Args[0] = Color
	move.l     #0,4(a1)                        ; Args[1] = Tags
	CALLGUIGFX DoPictureMethodA                ; (Picture,Method,Args)(a0,d0,a1)

.picmethod1a
	move.l     GuiGfxPic1(pc),a0               ; Picture
	move.l     #PICMTHD_INSERT,d0                 ; Method
	lea.l      BackTags1(pc),a1                ; Args
	move.l     GuiGfxPic1ori(pc),(a1)             ; Args[0]
	CALLGUIGFX DoPictureMethodA                ; (Picture,Method,Args)(a0,d0,a1)

.picbitmap
	move.l     GuiGfxDrawHandle(pc),a0         ; Array
	move.l     GuiGfxPic1(pc),a1               ; Picture
	suba.l     a2,a2                           ; Tags
	CALLGUIGFX CreatePictureBitMapA            ; (DrawHandle,Picture,Tags)(a0,a1,a2)
	move.l     d0,BackBitMap                   ; BitMap

.picmethod1b
	move.l     GuiGfxPic1(pc),a0               ; Picture
	move.l     #PICMTHD_MAPDRAWHANDLE,d0       ; Method
	lea.l      ValBUFFER(pc),a1                ; Args
	move.l     GuiGfxDrawHandle(pc),0(a1)      ; Args[0]
	move.l     #$00000000,4(a1)                ; Args[1]
	CALLGUIGFX DoPictureMethodA                ; (Picture,Method,Args)(a0,d0,a1)

.picmethod1c
	move.l     GuiGfxPic2(pc),a0               ; Picture
	move.l     #PICMTHD_MAPDRAWHANDLE,d0       ; Method
	lea.l      ValBUFFER(pc),a1                ; Args
	move.l     GuiGfxDrawHandle(pc),0(a1)      ; Args[0]
	move.l     #$00000000,4(a1)                ; Args[1]
	CALLGUIGFX DoPictureMethodA                ; (Picture,Method,Args)(a0,d0,a1)

.picmethod1d
	move.l     GuiGfxPic3(pc),a0               ; Picture
	move.l     #PICMTHD_MAPDRAWHANDLE,d0       ; Method
	lea.l      ValBUFFER(pc),a1                ; Args
	move.l     GuiGfxDrawHandle(pc),0(a1)      ; Args[0]
	move.l     #$00000000,4(a1)                ; Args[1]
	CALLGUIGFX DoPictureMethodA                ; (Picture,Method,Args)(a0,d0,a1)

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
	movem.l    (sp)+,d1-a6                     ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

GuiGfx_CloseAll:

	movem.l    d0-a6,-(sp)                     ; Push

.pic1ori
	tst.l      GuiGfxPic1ori(pc)               ; Null ?
	beq.s      .pic1                           ; Skip
	move.l     GuiGfxPic1ori(pc),a0            ; Picture
	CALLGUIGFX DeletePicture                   ; (Picture)(a0)
	clr.l      GuiGfxPic1ori                   ; Clear

.pic1
	tst.l      GuiGfxPic1(pc)                  ; Null ?
	beq.s      .pic2                           ; Skip
	move.l     GuiGfxPic1(pc),a0               ; Picture
	CALLGUIGFX DeletePicture                   ; (Picture)(a0)
	clr.l      GuiGfxPic1                      ; Clear

.pic2
	tst.l      GuiGfxPic2(pc)                  ; Null ?
	beq.s      .pic3                           ; Skip
	move.l     GuiGfxPic2(pc),a0               ; Picture
	CALLGUIGFX DeletePicture                   ; (Picture)(a0)
	clr.l      GuiGfxPic2                      ; Clear

.pic3
	tst.l      GuiGfxPic3(pc)                  ; Null ?
	beq.s      .drawhandle                     ; Skip
	move.l     GuiGfxPic3(pc),a0               ; Picture
	CALLGUIGFX DeletePicture                   ; (Picture)(a0)
	clr.l      GuiGfxPic3                      ; Clear

.drawhandle
	tst.l      GuiGfxDrawHandle(pc)            ; Null ?
	beq.s      .exit                           ; Skip
	move.l     GuiGfxDrawHandle(pc),a0         ; DrawHandle
	CALLGUIGFX ReleaseDrawHandle               ; (DrawHandle)(a0)
	clr.l      GuiGfxDrawHandle                ; Clear

.exit
	movem.l    (sp)+,d0-a6                     ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

GuiGfx_DrawBack:

	movem.l    d2-d7/a2-a6,-(sp)               ; Push

	tst.l      MyWindow(pc)                    ; Null ?
	beq.w      .exit                           ; Skip
	tst.l      BackBitMap(pc)                  ; Null ?
	beq.w      .exit                           ; Skip
	tst.l      GuiGfxPic1(pc)                  ; Null ?
	beq.w      .exit                           ; Skip
	tst.l      GuiGfxDrawHandle(pc)            ; Null ?
	beq.w      .exit                           ; Skip

	move.l     MyWindow(pc),a1                 ; win
	move.l     wd_RPort(a1),a1                 ; rp
	moveq.b    #0,d0                           ; mode.b
	CALLGRAF   SetDrMd                         ; (rp,mode)(a1,d0)
	move.l     BackgroundPen(pc),d0            ; Pen.b
	CALLGRAF   SetAPen                         ; (rp,pen)(a1,d0)
	move.w     #000,d0                         ; x1.w
	move.w     #000,d1                         ; y1.w
	move.w     #200,d2                         ; x2.w
	move.w     #200,d3                         ; y2.w
	CALLGRAF   RectFill                        ; (rp,x1,y1,x2,y2)(a1,d0,d1,d2,d3)

	move.l     BackBitMap(pc),a0               ; SrcBM
	moveq.w    #000,d0                         ; SrcX.w
	moveq.w    #000,d1                         ; SrcY.w
	move.l     MyWindow(pc),a1                 ; Window
	move.l     wd_RPort(a1),a1                 ; Window->RastPort
	moveq.w    #000,d2                         ; DestX.w
	moveq.w    #000,d3                         ; DestY.w
	move.w     #200,d4                         ; DestW.w
	move.w     #200,d5                         ; DestH.w
	move.l     #~0,d6                          ; MinTerms.b
	lea.l      WinBGMask(pc),a2                ; BltMask
	CALLGRAF   BltMaskBitMapRastPort           ; ()(a0,d0,d1,a1,d2,d3,d4,d5,d6,a2)

	move.l     MyWindow(pc),a0                 ; Window
	move.l     wd_RPort(a0),a0                 ; RastPort
	lea.l      MyIText1(pc),a1                 ; TextFont
	moveq.w    #0,d0                           ; X.w
	moveq.w    #0,d1                           ; Y.w
	CALLINT    PrintIText                      ; (RastPort,IText,X,Y)(a0,a1,d0,d1)

.exit
	movem.l    (sp)+,d2-d7/a2-a6               ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

GuiGfx_DrawBar:

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

Counters_Draw:

	tst.l      MyWindow(pc)                    ; Null ?
	beq.w      .exit                           ; Skip
	tst.l      GuiGfxPic1(pc)                  ; Null ?
	beq.w      .exit                           ; Skip
	tst.l      GuiGfxPic2(pc)                  ; Null ?
	beq.w      .exit                           ; Skip
	tst.l      GuiGfxPic3(pc)                  ; Null ?
	beq.w      .exit                           ; Skip
	tst.l      GuiGfxDrawHandle(pc)            ; Null ?
	beq.w      .exit                           ; Skip

*	lea.l      TxtCounterCol(pc),a0            ; Color array
*	lea.l      MyITextCP1(pc),a1               ; color0: zero
*	move.b     (a0,d2.L*1),it_FrontPen(a1)     ; color1: non-zero
*	lea.l      MyITextCP2(pc),a1               ; color0: zero
*	move.b     (a0,d2.L*1),it_FrontPen(a1)     ; color1: non-zero
*	lea.l      MyITextCFP(pc),a1               ; color0: zero
*	move.b     (a0,d2.L*1),it_FrontPen(a1)     ; color1: non-zero

	lea.l      FmtIPC(pc),a0                   ; Fmt
	lea.l      ValIPC(pc),a1                   ; IPC
	lea.l      RawDoFmtCallback(pc),a2         ; CB
	lea.l      StrIPC(pc),a3                   ; Data
	CALLEXEC   RawDoFmt                        ; (Fmt,Args,CB,Data)(a0,a1,a2,a3)

	move.l     GuiGfxDrawHandle(pc),a0         ; handle
	move.l     GuiGfxPic1(pc),a1               ; picture
	move.w     #128,d0                         ; x.w
	move.w     #114,d1                         ; y.w
	lea.l      CntTags(pc),a2                  ; tags
	CALLGUIGFX DrawPictureA                    ; (handle,pic,x,y,tags)(a0,a1,d0,d1,a2)

	move.l     MyWindow(pc),a0                 ; Window
	move.l     wd_RPort(a0),a0                 ; RastPort
	lea.l      MyITextCP1(pc),a1               ; TextFont
	moveq.w    #0,d0                           ; X.w
	moveq.w    #0,d1                           ; Y.w
	CALLINT    PrintIText                      ; (RastPort,IText,X,Y)(a0,a1,d0,d1)

	lea.l      BarCP1(pc),a0                   ; Bar CPU1
	bsr        GuiGfx_DrawBar                  ; 
	lea.l      BarCP2(pc),a0                   ; Bar CPU2
	bsr        GuiGfx_DrawBar                  ; 
	lea.l      BarCFP(pc),a0                   ; Bar FPU1
	bsr        GuiGfx_DrawBar                  ; 

.exit
	rts                                        ; Return

;-----------------------------------------------------------

Counters_Update:

	movem.l    d2/d3,-(sp)                     ; Push

	;------------------------------------------
	; Time Slice
	;------------------------------------------

	move.l     ValRATE(pc),d3                  ; Refresh rate
	tst.l      d3                              ; Zero ?
	beq.w      .exit                           ; Skip
	lea.l      ValCCC(pc),a0                   ; T1
	dc.w       $4e7a,$1809                     ; Clock
	move.l     d1,d2                           ; T0
	sub.l      (a0),d1                         ; T0-T1
	cmp.l      d3,d1                           ; T0-T1 > Delay ?
	blo        .exit                           ; Skip
	move.l     d2,(a0)                         ; Clock
*	bchg       #1,$BFE001                      ; DEBUG
	
	;------------------------------------------
	; Processor Counter Pipe 1
	;------------------------------------------
	
	lea.l      BarCP1(pc),a0                   ; (old)
	move.l     bar_Cnt(a0),d1                  ; (old)
	dc.w       $4e7a,VREG_SPR_IP1              ; (new)
	move.l     d0,bar_Cnt(a0)                  ; (new)
	sub.l      d1,d0                           ; (new-old)
	mulu.l     #100,d0                         ; (new-old)*100
	divu.l     d3,d0                           ; (new-old)*100/rate
	move.l     d0,d2                           ; total
	move.l     d0,bar_Val1(a0)                 ; new

	;------------------------------------------
	; Processor Counter Pipe 2
	;------------------------------------------

	lea.l      BarCP2(pc),a0                   ; (old)
	move.l     bar_Cnt(a0),d1                  ; (old)
	dc.w       $4e7a,VREG_SPR_IP2              ; (new)
	move.l     d0,bar_Cnt(a0)                  ; (new)
	sub.l      d1,d0                           ; (new-old)
	mulu.l     #100,d0                         ; (new-old)*100
	divu.l     d3,d0                           ; (new-old)*100/rate
	add.l      d0,d2                           ; total
	move.l     d0,bar_Val1(a0)                 ; new

	;------------------------------------------
	; Processor Counter FPU
	;------------------------------------------

	lea.l      BarCFP(pc),a0                   ; (old)
	move.l     bar_Cnt(a0),d1                  ; (old)
	dc.w       $4e7a,VREG_SPR_STH              ; (new)
	move.l     d0,bar_Cnt(a0)                  ; (new)
	sub.l      d1,d0                           ; (new-old)
	mulu.l     #100,d0                         ; (new-old)*100
	divu.l     d3,d0                           ; (new-old)*100/rate
	move.l     d0,bar_Val1(a0)                 ; new

	;------------------------------------------
	; Calculate IPC
	;------------------------------------------

.ipc1
	lea.l      ValIPC(pc),a0                   ; IPC
	moveq.l    #000,d1                         ; --.##
	divul.l    #100,d1:d2                      ; ##.--
	cmp.l      #099,d2                         ; Max ?
	blt.s      .ipc2                           ; Skip
	move.l     #099,d2                         ; Max
.ipc2
	move.l     d2,0*4(a0)                      ; IPC[0]
	move.l     d1,1*4(a0)                      ; IPC[1]

.exit
	movem.l    (sp)+,d2/d3                     ; Pop
	rts                                        ; Return

;-----------------------------------------------------------

LED1_Update:

	movem.l    d2/d3/a6,-(sp)                  ; Push

	tst.l      MyWindow(pc)                    ; Null ?
	beq.s      .exit                           ; Skip

	dc.w       $4e7a,$1809                     ; Clock
	move.l     ValCLOCK_LED(pc),d0             ; T0
	move.l     d1,d2                           ; T1
	sub.l      d0,d1                           ; T1-T0
	cmp.l      #(100*1000000),d1               ; T1-T0 < 100M
	blo        .exit                           ; Skip
	move.l     d2,ValCLOCK_LED                 ; T1
	move.l     PenLEDColor(pc),d0              ; Color
	cmp.l      MyWindowPen1(pc),d0             ; 
	beq.s      .color2                         ; 
	move.l     MyWindowPen1(pc),PenLEDColor    ; Color1
	bra.s      .draw                           ; 
.color2
	move.l     MyWindowPen2(pc),PenLEDColor    ; Color2

.draw
	move.l     MyWindow(pc),a1                 ; Window
	move.l     wd_RPort(a1),a1                 ; RastPort
	moveq.b    #0,d0                           ; Mode.b
	CALLGRAF   SetDrMd                         ; (RastPort,Mode)(a1,d0)
	move.l     PenLEDColor(pc),d0              ; Pen.b
	CALLGRAF   SetAPen                         ; (RastPort,Pen)(a1,d0)
	move.w     #(49+0),d0                      ; X1.w
	move.w     #(30+0),d1                      ; Y1.w
	move.w     #(49+2),d2                      ; X2.w
	move.w     #(30+2),d3                      ; Y2.w
	CALLGRAF   RectFill                        ; (RastPort,X1,Y1,X2,Y2)(a1,d0,d1,d2,d3)

.exit
	movem.l    (sp)+,d2/d3/a6                  ; Pop
	rts                                        ; Return

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
	move.l     MyWindowPen3(pc),d0             ; pen.b
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
	move.l     MyWindowPen1(pc),d0             ; pen.b
	move.l     d0,PenTXTColor                  ; pen.b
	CALLGRAF   SetAPen                         ; (rp,pen)(a1,d0)
	move.w     #(35+0),d0                      ; x1.w
	move.w     #(47+0),d1                      ; y1.w
	move.w     #(35+1),d2                      ; x2.w
	move.w     #(47+2),d3                      ; y2.w
	CALLGRAF   RectFill                        ; (rp,x1,y1,x2,y2)(a1,d0,d1,d2,d3)

	bsr        Sensors_ReadTemp                ; infos
	lea.l      StrTEMP(pc),a0                  ; infos
	bsr        Sensors_TempToString            ; infos

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
* INCLUDE FILES
*
************************************************************

	INCLUDE    Inc/V_Board.s
	INCLUDE    Inc/V_Clipboard.s
	INCLUDE    Inc/V_Commodities.s
	INCLUDE    Inc/V_Counters.s
	INCLUDE    Inc/V_CPU.s
	INCLUDE    Inc/V_Diskfonts.s
	INCLUDE    Inc/V_Iconify.s
	INCLUDE    Inc/V_MenuItems.s
	INCLUDE    Inc/V_ParseNumber.s
	INCLUDE    Inc/V_ReqTools.s
	INCLUDE    Inc/V_Sensors.s
	INCLUDE    Inc/V_Serial.s
	INCLUDE    Inc/V_ScreenNotify.s
	INCLUDE    Inc/V_ToolTypes.s
	INCLUDE    Inc/V_Utils.s
	INCLUDE    Inc/V_Window.s

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
_LayerBase:          DS.L 1
_ReqtoolsBase:       DS.L 1
_ScreenNotifyBase:   DS.L 1
_UtilityBase:        DS.L 1
_WorkbenchBase:      DS.L 1

;-----------------------------------------------------------

	CNOP 0,4
	
WBStartMsg:          DS.L 1
AppGuiState:         DS.L 1
AppRunState:         DS.L 1
AppSignalSet:        DS.L 1

ValCCC:              DS.L 1
ValIPC:              DS.L 2
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

ForegroundPen:       DS.L 1
ForegroundRGB32:     DS.L 3
BackgroundPen:       DS.L 1
BackgroundRGB32:     DS.L 3

;-----------------------------------------------------------

	CNOP 0,4

MyAmigaGuide:        DS.L 1
MyNewAmigaGuide:     DS.B AmigaGuideMsg_SIZEOF

;-----------------------------------------------------------

	CNOP 0,4

GuiGfxPenShareMap:   DS.L 1
GuiGfxDrawHandle:    DS.L 1
GuiGfxPic1:          DS.L 1
GuiGfxPic1ori:       DS.L 1
GuiGfxPic2:          DS.L 1
GuiGfxPic3:          DS.L 1
BackBitMap:          DS.L 1
GuiGfxTags:          DC.L TAG_DONE

;-----------------------------------------------------------

	CNOP 0,4

MyPointerTags1:
	DC.L WA_BusyPointer,1
	DC.L WA_PointerDelay,1
MyPointerTags2:
	DC.L TAG_DONE

;-----------------------------------------------------------

	CNOP 0,4

BarCP1:      ; PIPE1 counter
	DC.L   0 ; bar_Cnt
	DC.L   0 ; bar_Val1
	DC.L   0 ; bar_Val2
	DC.L  50 ; bar_DstX
	DC.L 121 ; bar_DstY
	DC.L   0 ; bar_PicW
	DC.L   0 ; bar_PicH
	DC.L   0 ; bar_hPic1
	DC.L   0 ; bar_hPic2
	DC.L   0 ; bar_hDraw
	DC.L   0 ; bar_hTags

BarCP2:      ; PIPE2 counter
	DC.L   0 ; bar_Cnt
	DC.L   0 ; bar_Val1
	DC.L   0 ; bar_Val2
	DC.L  50 ; bar_DstX
	DC.L 127 ; bar_DstY
	DC.L   0 ; bar_PicW
	DC.L   0 ; bar_PicH
	DC.L   0 ; bar_hPic1
	DC.L   0 ; bar_hPic2
	DC.L   0 ; bar_hDraw
	DC.L   0 ; bar_hTags

BarCFP:      ; FLOAT counter
	DC.L   0 ; bar_Cnt
	DC.L   0 ; bar_Val1
	DC.L   0 ; bar_Val2
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

BackTags:
*	DC.L GGFX_SourceX,0 ;43
*	DC.L GGFX_SourceY,0 ;36
*	DC.L GGFX_SourceWidth,200  ; 114
*	DC.L GGFX_SourceHeight,200 ; 112
*	DC.L GGFX_DestWidth,200    ; 114
*	DC.L GGFX_DestHeight,200   ; 112
*	DC.L GGFX_DitherMode,DITHERMODE_RANDOM
*	DC.L GGFX_DitherAmount,255
*	DC.L GGFX_AutoDither,1
*	DC.L RND_DestCoordinates,Coords
	DC.L TAG_DONE

BackTags1:
	DC.L 0
	DC.L GGFX_Ratio,255
	DC.L GGFX_SourceX,43
	DC.L GGFX_SourceY,37
	DC.L GGFX_SourceWidth,114
	DC.L GGFX_SourceHeight,110
	DC.L GGFX_DestX,43
	DC.L GGFX_DestY,37
	DC.L GGFX_DestWidth,114
	DC.L GGFX_DestHeight,110
	DC.L TAG_DONE

Coords:
	DC.W 000,000
	DC.W 200,000
	DC.W 200,200
	DC.W 000,200

LoadPicTags:
	DC.L GGFX_ErrorCode,LoadPicError
*	DC.L GGFX_UseMask,1
	DC.L TAG_DONE
LoadPicError:
	DC.L 0

MySkin1:
	DC.L 000,020 ; BoardName
	DC.L 000,030 ; BoardRevision
	DC.L 000,040 ; CPUFrequency
	DC.L 000,050 ; CPUMultiplier
	DC.L 080,060 ; CounterIPC1
	DC.L 090,070 ; CounterIPC2
	DC.L 005,080 ; CounterCP1
	DC.L 005,085 ; CounterCP2
	DC.L 005,090 ; CounterCFP
	DC.L 000,095 ; RTCTemperature

;-----------------------------------------------------------

	CNOP 0,4

MyIText1:   ITEXT 1,1,0,000,044,MyTextAttr1,StrCPU1,MyIText2
MyIText2:   ITEXT 2,1,1,014,154,MyTextAttr1,StrBoard0,MyIText3
MyIText3:   ITEXT 2,1,0,000,061,MyTextAttr2,StrFREQ,MyIText4
MyIText4:   ITEXT 2,1,0,000,069,MyTextAttr2,StrMULT,MyIText5
MyIText5:   ITEXT 2,1,0,014,170,MyTextAttr3,StrCHIP,MyIText6
MyIText6:   ITEXT 2,1,0,014,176,MyTextAttr3,StrFAST,MyIText7
MyIText7:   ITEXT 2,1,0,014,182,MyTextAttr3,StrSLOW,MyIText8
MyIText8:   ITEXT 1,1,0,000,140,MyTextAttr3,StrTEMP,MyIText9
MyIText9:   ITEXT 1,1,0,000,055,MyTextAttr3,StrREV,MyITextA
MyITextA:   ITEXT 2,1,0,114,114,MyTextAttr3,StrIPC1,0

MyITextCP1: ITEXT 4,1,0,046,121,MyTextAttr3,StrCP1,MyITextCP2
MyITextCP2: ITEXT 4,1,0,046,127,MyTextAttr3,StrCP2,MyITextCFP
MyITextCFP: ITEXT 4,1,0,046,133,MyTextAttr3,StrCFP,MyITextIPC
MyITextIPC: ITEXT 2,1,0,130,114,MyTextAttr3,StrIPC,0

;-----------------------------------------------------------

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
StrEnable:        DC.B "enable",0
StrDisable:       DC.B "disable",0

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

AmigaGuideName:   DC.B "amigaguide.library",0
CommoditiesName:  DC.B "commodities.library",0
DiskfontName:     DC.B "diskfont.library",0
DOSName:          DC.B "dos.library",0
GadtoolsName:     DC.B "gadtools.library",0
GfxName:          DC.B "graphics.library",0
GuiGfxName:       DC.B "guigfx.library",0
IconName:         DC.B "icon.library",0
IntuitionName:    DC.B "intuition.library",0
LayerName:        DC.B "layers.library",0
ReqtoolsName:     DC.B "reqtools.library",0
ScreenNotifyName: DC.B "screennotify.library",0
UtilityName:      DC.B "utility.library",0
WorkbenchName:    DC.B "workbench.library",0

;-----------------------------------------------------------

	CNOP 0,4

SkinArray:
	DC.L FileWinBG1,FileWinBG2
	DC.L FileWinBG3,FileWinBG4
	DC.L FileWinBG5,FileWinBG6
	DC.L FileWinBG7,FileWinBG8

FileWinBG:        DC.L FileWinBG1
FileWinBG1:       DC.B "PROGDIR:Gfx/WinBG.png",0
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

WinBGMask:
	INCLUDE Gfx/WinMask.raw

;-----------------------------------------------------------

	CNOP 0,4

APP_NAME:         DC.B "VCPU",0
APP_GUIDE:        DC.B "VCPU.guide",0
APP_VERSION:      DC.B "0.1c",0
APP_RELEASEDATE:  DC.B "17.11.2019",0
APP_AUTHOR:       DC.B "flype",0
APP_DESCRIPTION:  DC.B "Vampire CPU monitor tool",0
APP_COMMENT:      DC.B "· In memory of Gouky ·",0

APP_VERSTRING:
	DC.B "$VER: VCPU 0.1c (17.11.2019) "
APP_COPYRIGHT:
	DC.B "© 2016-2019 APOLLO-Team.",0,0,0

************************************************************
*
* END OF FILE
*
************************************************************

	END
