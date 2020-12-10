************************************************************
*	
*	WINDOW FUNCTIONS
*	
************************************************************
*	
*	XDEF Window_Open
*	XDEF Window_Close
*	XDEF Window_Events
*	XDEF Window_Refresh
*	XDEF Window_ObtainPens
*	XDEF Window_SetBackdrop
*	XDEF Window_SetBorderless
*	XDEF Window_Lock
*	XDEF Window_Unlock
*	
************************************************************

	CNOP 0,4

MyWindow:      DS.L 1
MyWindowX:     DS.L 1
MyWindowY:     DS.L 1
MyWindowLock:  DS.L 1
MyWindowPen1:  DS.L 1
MyWindowPen2:  DS.L 1
MyWindowPen3:  DS.L 1
MyMenuStrip:   DS.L 1
MyVisualInfo:  DS.L 1

************************************************************

	CNOP 0,4

MyObtainBestPenTags:
	DC.L OBP_Precision,PRECISION_IMAGE
	DC.L OBP_FailIfBad,0
	DC.L TAG_DONE

************************************************************

	CNOP 0,4

MyLayoutMenusTags:
	DC.L GTMN_NewLookMenus,1
	DC.L TAG_DONE

************************************************************

	CNOP 0,4

MyOpenWindowTags:
	DC.L WA_Left,0
	DC.L WA_Top,0
	DC.L WA_InnerWidth,WIN_WIDTH
	DC.L WA_InnerHeight,WIN_HEIGHT
	DC.L WA_IDCMP,IDCMP_CLOSEWINDOW!IDCMP_MENUPICK!IDCMP_RAWKEY!IDCMP_REFRESHWINDOW
	DC.L WA_Activate,1
	DC.L WA_Backdrop,0
	DC.L WA_Borderless,0
	DC.L WA_CloseGadget,1
	DC.L WA_DepthGadget,1
	DC.L WA_DragBar,1
	DC.L WA_GimmeZeroZero,1
	DC.L WA_NewLookMenus,1
*	DC.L WA_NoCareRefresh,1
*	DC.L WA_SimpleRefresh,1
	DC.L WA_SmartRefresh,1
	DC.L TAG_DONE

************************************************************

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

************************************************************

	CNOP 0,4

Window_Open:
	movem.l    a2/a6,-(sp)                     ; Push
.open
	tst.l      MyWindow(pc)                    ; Null ?
	bne        .exit                           ; Skip
	suba.l     a0,a0                           ; NewWindow
	lea.l      MyOpenWindowTags(pc),a1         ; Tags
	move.l     MyWindowX(pc),4+(0*8)(a1)       ; Tags[0]
	move.l     MyWindowY(pc),4+(1*8)(a1)       ; Tags[1]
	CALLINT    OpenWindowTagList               ; (NewWindow,Tags)(a0,a1)
	tst.l      d0                              ; Null ?
	beq        .exit                           ; Skip
	lea.l      MyWindow(pc),a0                 ; Window
	move.l     d0,(a0)                         ; Window
.titles
	move.l     d0,a0                           ; Window
	lea.l      APP_NAME(pc),a1                 ; Window title
	lea.l      APP_VERSTRING+6(pc),a2          ; Screen title
	CALLINT    SetWindowTitles                 ; (Window,WinTitle,ScrTitle)(a0,a1,a2)
.visualinfo
	move.l     MyWindow(pc),a0                 ; Window
	move.l     wd_WScreen(a0),a0               ; Window->Screen
	suba.l     a1,a1                           ; Tags
	CALLGT     GetVisualInfoA                  ; (Screen,Tags)(a0,a1)
	lea.l      MyVisualInfo(pc),a0             ; VisualInfo
	move.l     d0,(a0)                         ; VisualInfo
.gadgets
	move.l     MyWindow(pc),a0                 ; Window
	lea.l      MyDragGadget(pc),a1             ; Gadget
	move.w     #~0,d0                          ; Position.w
	CALLINT    AddGadget                       ; (Window,Gadget,Position)(a0,a1,d0)
.createmenus
	lea.l      MyNewMenu(pc),a0                ; NewMenu
	suba.l     a1,a1                           ; Tags
	CALLGT     CreateMenusA                    ; (NewMenu,Tags)(a0,a1)
	lea.l      MyMenuStrip(pc),a0              ; MenuStrip
	move.l     d0,(a0)                         ; MenuStrip
.layoutmenus
	move.l     MyMenuStrip(pc),a0              ; MenuStrip
	move.l     MyVisualInfo(pc),a1             ; VisualInfo
	lea.l      MyLayoutMenusTags(pc),a2        ; Tags
	CALLGT     LayoutMenusA                    ; (MenuStrip,VisualInfo,Tags)(a0,a1,a2)
.setmenustrip
	move.l     MyWindow(pc),a0                 ; Window
	move.l     MyMenuStrip(pc),a1              ; MenuStrip
	CALLINT    SetMenuStrip                    ; (Window,MenuStrip)(a0,a1)
.exit
	movem.l    (sp)+,a2/a6                     ; Pop
	move.l     MyWindow(pc),d0                 ; Window
	rts                                        ; Return

************************************************************

	CNOP 0,4

Window_Close:
	movem.l    a6,-(sp)                        ; Push
.menustrip
	tst.l      MyWindow(pc)                    ; Null ?
	beq.s      .menus                          ; Skip
	move.l     MyWindow(pc),a0                 ; Window
	CALLINT    ClearMenuStrip                  ; (Window)(a0)
.menus
	tst.l      MyMenuStrip(pc)                 ; Null ?
	beq.s      .visualinfo                     ; Skip
	move.l     MyMenuStrip(pc),a0              ; MenuStrip
	CALLGT     FreeMenus                       ; (MenuStrip)(a0)
	clr.l      MyMenuStrip                     ; Clear
.visualinfo
	tst.l      MyVisualInfo(pc)                ; Null ?
	beq.s      .window                         ; Skip
	move.l     MyVisualInfo(pc),a0             ; VisualInfo
	CALLGT     FreeVisualInfo                  ; (VisualInfo)(a0)
	clr.l      MyVisualInfo                    ; Clear
.window
	tst.l      MyWindow(pc)                    ; Null ?
	beq.s      .exit                           ; Skip
	move.l     MyWindow(pc),a0                 ; Window
	moveq.l    #0,d0                           ; Clear
	move.w     wd_LeftEdge(a0),d0              ; Window->X
	move.l     d0,MyWindowX                    ; Store
	move.w     wd_TopEdge(a0),d0               ; Window->Y
	move.l     d0,MyWindowY                    ; Store
	CALLINT    CloseWindow                     ; (Window)(a0)
	clr.l      MyWindow                        ; Clear
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Window_Events:
	movem.l    d2/d3/d4/a6,-(sp)               ; Push
.getMsg
	move.l     MyWindow(pc),a0                 ; Window
	tst.l      a0                              ; Null ?
	beq.w      .exit                           ; Skip
	move.l     wd_UserPort(a0),a0              ; MsgPort
	tst.l      a0                              ; Null ?
	beq.w      .exit                           ; Skip
	CALLEXEC   GetMsg                          ; (MsgPort)(a0)
	tst.l      d0                              ; Null ?
	beq.w      .exit                           ; Skip
	move.l     d0,a1                           ; Msg
	move.l     im_Class(a1),d3                 ; Msg->class
	move.w     im_Code(a1),d4                  ; Msg->code
	CALLEXEC   ReplyMsg                        ; (Msg)(a1)
.getClass
	cmp.l      #IDCMP_REFRESHWINDOW,d3         ; REFRESHWINDOW
	beq.s      .classRefreshWindow             ; 
	cmp.l      #IDCMP_CLOSEWINDOW,d3           ; CLOSEWINDOW
	beq.s      .classCloseWindow               ; 
	cmp.l      #IDCMP_MENUPICK,d3              ; MENUPICK
	beq.s      .classMenuPick                  ; 
	cmp.l      #IDCMP_RAWKEY,d3                ; RAWKEY
	beq.s      .classRawKey                    ; 
	bra.s      .exit                           ; 
.classRawKey
	cmp.w      #$40,d4                         ; SPACE
	beq.s      .classRawKey40                  ; 
	cmp.w      #$45,d4                         ; ESCAPE
	beq.s      .classRawKey45                  ; 
	bra.s      .exit                           ; 
.classRawKey40
	bsr        Counters_Begin                  ; 
	bra.s      .exit                           ; 
.classRawKey45
.classCloseWindow
	lea.l      AppRunState(pc),a0              ; CLOSEWINDOW
	move.l     #APP_RUNSTATE_QUIT,(a0)         ; 
	bra.s      .exit                           ; 
.classRefreshWindow
	bsr        Window_Refresh                  ; REFRESHWINDOW
	bra.s      .exit                           ; 
.classMenuPick
	move.l     MyMenuStrip(pc),a0              ; MenuStrip
	move.w     d4,d0                           ; MenuNum
	CALLINT    ItemAddress                     ; (MenuStrip,MenuNum)(a0,d0)
	tst.l      d0                              ; Null ?
	beq.s      .exit                           ; Skip
	move.l     d0,a0                           ; MenuItem
	move.l     mi_SIZEOF(a0),a0                ; MenuItem->mi_UserData
	tst.l      a0                              ; Null ?
	beq.s      .exit                           ; Skip
	MENUNUM    d4,d0                           ; MenuNum->Menu
	ITEMNUM    d4,d1                           ; MenuNum->MenuItem
	SUBNUM     d4,d2                           ; MenuNum->MenuItemSub
	jsr        (a0)                            ; MenuItem->SubRoutine
.exit
	movem.l    (sp)+,d2/d3/d4/a6               ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Window_Refresh:
 	movem.l    a2/a6,-(sp)                     ; Push
.lock
	move.l     MyWindow(pc),a0                 ; Window
	move.l     wd_WScreen(a0),a0               ; Window->Screen
	adda.l     #sc_LayerInfo,a0                ; Screen->LayerInfo
	move.l     a0,a2                           ; LayerInfo
	CALLLAYER  LockLayerInfo                   ; (LayerInfo)(a0)
.refresh
	move.l     MyWindow(pc),a0                 ; Window
	CALLINT    BeginRefresh                    ; (Window)(a0)
	bsr        GuiGfx_DrawBack                 ; Redraw
	move.l     MyWindow(pc),a0                 ; Window
	moveq.l    #1,d0                           ; Complete
	CALLINT    EndRefresh                      ; (Window,Complete)(a0,d0)
.unlock
	move.l     a2,a0                           ; LayerInfo
	CALLLAYER  UnlockLayerInfo                 ; (LayerInfo)(a0)
.exit
 	movem.l    (sp)+,a2/a6                     ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Window_ObtainPens:
	movem.l    d2/d3/a2/a6,-(sp)               ; Push
.cm
	tst.l      MyWindow(pc)                    ; Null ?
	beq.w      .exit                           ; Skip
	move.l     MyWindow(pc),a0                 ; Window
	move.l     wd_WScreen(a0),a0               ; Window->Screen
	adda.l     #sc_ViewPort,a0                 ; Screen.ViewPort
	adda.l     #vp_ColorMap,a0                 ; ViewPort.ColorMap
	move.l     (a0),a2                         ; ColorMap
.p1
	move.l     a2,a0                           ; CM
	move.l     #$ffffffff,d1                   ; R
	move.l     #$00000000,d2                   ; G
	move.l     #$00000000,d3                   ; B
	lea.l      MyObtainBestPenTags(pc),a1      ; Tags
	CALLGRAF   ObtainBestPenA                  ; (CM,R,G,B,Tags)(a0,d1,d2,d3,a1)
	move.l     d0,MyWindowPen1                 ; Store
.p2
	move.l     a2,a0                           ; CM
	move.l     #$ffffffff,d1                   ; R
	move.l     #$ffffffff,d2                   ; G
	move.l     #$00000000,d3                   ; B
	lea.l      MyObtainBestPenTags(pc),a1      ; Tags
	CALLGRAF   ObtainBestPenA                  ; (CM,R,G,B,Tags)(a0,d1,d2,d3,a1)
	move.l     d0,MyWindowPen2                 ; Store
.p3
	move.l     a2,a0                           ; CM
	move.l     #$ffffffff,d1                   ; R
	move.l     #$ffffffff,d2                   ; G
	move.l     #$ffffffff,d3                   ; B
	lea.l      MyObtainBestPenTags(pc),a1      ; Tags
	CALLGRAF   ObtainBestPenA                  ; (CM,R,G,B,Tags)(a0,d1,d2,d3,a1)
	move.l     d0,MyWindowPen3                 ; Store
.exit
	movem.l    (sp)+,d2/d3/a2/a6               ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Window_SetBackdrop:
	lea.l      MyOpenWindowTags(pc),a0         ; Tags
	move.l     d0,4+(06*8)(a0)                 ; Tags[] -> WA_Backdrop
	rts                                        ; Return
	
************************************************************

	CNOP 0,4

Window_SetBorderless:
	lea.l      MyOpenWindowTags(pc),a0         ; Tags
	move.l     d0,4+(07*8)(a0)                 ; Tags[] -> WA_Borderless
	tst.l      d0
	seq        d0
	move.l     d0,4+(08*8)(a0)                 ; Tags[] -> WA_CloseGadget
	move.l     d0,4+(09*8)(a0)                 ; Tags[] -> WA_DepthGadget
	move.l     d0,4+(10*8)(a0)                 ; Tags[] -> WA_DragBar
	rts                                        ; Return

************************************************************

	CNOP 0,4

Window_Lock:
	move.l     MyWindow(pc),a0                 ; Window
	tst.l      a0                              ; Null ?
	beq.s      .exit                           ; Skip
	CALLRT     rtLockWindow                    ; (Window)(a0)
	lea.l      MyWindowLock(pc),a0             ; WindowLock
	move.l     d0,(a0)                         ; WindowLock
.exit
	rts                                        ; Return

************************************************************

	CNOP 0,4

Window_Unlock:
	move.l     MyWindow(pc),a0                 ; Window
	tst.l      a0                              ; Null ?
	beq.s      .exit                           ; Skip
	move.l     MyWindowLock(pc),a1             ; WindowLock
	tst.l      a1                              ; Null ?
	beq.s      .exit                           ; Skip
	CALLRT     rtUnlockWindow                  ; (Window,WindowLock)(a0,a1)
.exit
	rts                                        ; Return

************************************************************
