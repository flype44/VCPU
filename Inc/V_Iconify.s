************************************************************
*	
*	ICONIFY FUNCTIONS
*	
************************************************************
*	
*	XDEF Iconify_Install
*	XDEF Iconify_Uninstall
*	XDEF Iconify_Add
*	XDEF Iconify_Remove
*	XDEF Iconify_Events
*	
************************************************************

	CNOP 0,4

MyAppIcon:     DS.L 1
MyAppIconPort: DS.L 1
MyAppIconDisk: DS.L 1
MyAppIconText: DC.B 'VCPU',0
MyAppIconName: DC.B 'PROGDIR:VCPU',0

************************************************************

	CNOP 0,4

Iconify_Install:
	movem.l    a6,-(sp)                        ; Push
.createPort
	CALLEXEC   CreateMsgPort                   ; (void)()
	tst.l      d0                              ; Null ?
	beq.s      .exit                           ; Skip
	lea.l      MyAppIconPort(pc),a0            ; MsgPort
	move.l     d0,(a0)                         ; MsgPort
.diskObject
	lea.l      MyAppIconName(pc),a0            ; Name
	CALLICON   GetDiskObject                   ; (Name)(a0)
	tst.l      d0                              ; DiskObject
	beq.s      .exit                           ; skip
	lea.l      MyAppIconDisk(pc),a0            ; DiskObject
	move.l     d0,(a0)                         ; DiskObject
	move.l     #0,do_Type(a0)                  ; DiskObject->Type
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Iconify_Uninstall:
	movem.l    a6,-(sp)                        ; Push
.remAppIcon
	tst.l      MyAppIcon(pc)                   ; Null ?
	beq.s      .deletePort                     ; Skip
	move.l     MyAppIcon(pc),a0                ; AppIcon
	CALLWB     RemoveAppIcon                   ; (AppIcon)(a0)
	clr.l      MyAppIcon                       ; Clear
.deletePort
	tst.l      MyAppIconPort(pc)               ; Null ?
	beq.s      .freeDiskObject                 ; Skip
	move.l     MyAppIconPort(pc),a0            ; MsgPort
	CALLEXEC   DeleteMsgPort                   ; (MsgPort)(a0)
	clr.l      MyAppIconPort                   ; Clear
.freeDiskObject
	tst.l      MyAppIconDisk(pc)               ; Null ?
	beq.s      .exit                           ; Skip
	move.l     MyAppIconDisk(pc),a0            ; DiskObject
	CALLICON   FreeDiskObject                  ; (DiskObject)(a0)
	clr.l      MyAppIconDisk                   ; Clear
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

Iconify_Add:
	movem.l    a2/a3/a4/a6,-(sp)               ; Push
.check
	tst.l      MyAppIcon(pc)                   ; Null ?
	bne.s      .guiState                       ; Skip
	tst.l      MyAppIconPort(pc)               ; Null ?
	beq.s      .exit                           ; Skip
	tst.l      MyAppIconDisk(pc)               ; Null ?
	beq.s      .exit                           ; Skip
.addIcon
	moveq.l    #0,d0                           ; Id
	moveq.l    #0,d1                           ; UserData
	lea.l      MyAppIconText(pc),a0            ; Text
	move.l     MyAppIconPort(pc),a1            ; MsgPort
	suba.l     a2,a2                           ; Lock
	move.l     MyAppIconDisk(pc),a3            ; DiskObject
	suba.l     a4,a4                           ; Tags
	CALLWB     AddAppIconA                     ; (Id,UserData,Txt,MsgPort,Lock,DiskObj,Tags)(d0,d1,a0,a1,a2,a3,a4)
	lea.l      MyAppIcon(pc),a0                ; AppIcon
	move.l     d0,(a0)                         ; AppIcon
.guiState
	lea.l      AppGuiState(pc),a0              ; GuiState
	move.l     #APP_GUISTATE_HIDE,(a0)         ; HIDE
.exit
	movem.l    (sp)+,a2/a3/a4/a6               ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Iconify_Remove:
	movem.l    a6,-(sp)                        ; Push
.remIcon
	tst.l      MyAppIcon(pc)                   ; Null ?
	beq.s      .exit                           ; Skip
	move.l     MyAppIcon(pc),a0                ; AppIcon
	CALLWB     RemoveAppIcon                   ; (AppIcon)(a0)
	clr.l      MyAppIcon                       ; Clear
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Iconify_Events:
	movem.l    d2/a6,-(sp)                     ; Push
.getMsg
	move.l     MyAppIconPort(pc),a0            ; MsgPort
	tst.l      a0                              ; Null ?
	beq.s      .exit                           ; Skip
	CALLEXEC   GetMsg                          ; (MsgPort)(a0)
	tst.l      d0                              ; Null ?
	beq.s      .exit                           ; Skip
	move.l     d0,a1                           ; Msg
	move.w     am_Type(a1),d2                  ; Msg->class
	CALLEXEC   ReplyMsg                        ; (Msg)(a1)
.getType
	cmpi.w     #MTYPE_APPICON,d2               ; APPICON
	bne.s      .exit                           ; Skip
	bsr        Iconify_Remove                  ; RemoveAppIcon
	lea.l      AppGuiState(pc),a0              ; GuiState
	move.l     #APP_GUISTATE_SHOW,(a0)         ; SHOW
.exit
	movem.l    (sp)+,d2/a6                     ; Pop
	rts                                        ; Return

************************************************************

