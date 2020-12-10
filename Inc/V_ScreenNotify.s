************************************************************
*	
*	SCREENNOTIFY FUNCTIONS
*	
************************************************************
*	
*	XDEF ScreenNotify_Install
*	XDEF ScreenNotify_Uninstall
*	XDEF ScreenNotify_Events
*	
************************************************************

	CNOP 0,4

MyScreenNotifyPort:   DS.L 1
MyScreenNotifyHandle: DS.L 1

************************************************************

	CNOP 0,4

ScreenNotify_Install:
	movem.l    a6,-(sp)                        ; Push
.createPort
	CALLEXEC   CreateMsgPort                   ; (void)()
	tst.l      d0                              ; Null ?
	beq.s      .exit                           ; Skip
	lea.l      MyScreenNotifyPort(pc),a0       ; MsgPort
	move.l     d0,(a0)                         ; MsgPort
.addClient
	move.l     d0,a0                           ; MsgPort
	moveq.l    #0,d0                           ; Priority
	CALLSCN    AddWorkbenchClient              ; (MsgPort,Priority)(a0,d0)
	lea.l      MyScreenNotifyHandle(pc),a0     ; Handle
	move.l     d0,(a0)                         ; Handle
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

ScreenNotify_Uninstall:
	movem.l    a6,-(sp)                        ; Push
.remClient
	tst.l      MyScreenNotifyHandle(pc)        ; Handle
	beq.s      .exit                           ; Null ?
	move.l     MyScreenNotifyHandle(pc),a0     ; Handle
	CALLSCN    RemWorkbenchClient              ; (Handle)(a0)
	bne.s      .delPort                        ; Success ?
	move.l     #10,d1                          ; Ticks
	CALLDOS    Delay                           ; (Ticks)(d1)
	bra.s      .remClient                      ; Continue
.delPort
	tst.l      MyScreenNotifyPort(pc)          ; MsgPort
	beq.s      .exit                           ; Null ?
	move.l     MyScreenNotifyPort(pc),a0       ; MsgPort
	CALLEXEC   DeleteMsgPort                   ; (MsgPort)(a0)
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

ScreenNotify_Events:
	movem.l    a2/a6,-(sp)                     ; Pop
.getMsg
	tst.l      MyScreenNotifyPort(pc)          ; MsgPort
	beq.s      .exit                           ; Null ?
	move.l     MyScreenNotifyPort(pc),a0       ; MsgPort
	CALLEXEC   GetMsg                          ; (MsgPort)(a0)
	tst.l      d0                              ; Null ?
	beq.s      .exit                           ; Skip
	move.l     d0,a1                           ; Msg
	move.l     d0,a2                           ; Msg
	cmp.l      #3,snm_Type(a1)                 ; Msg->Type = WORKBENCH
	bne.s      .done                           ; Skip
	tst.l      snm_Value(a1)                   ; Msg->Value = BOOLEAN
	beq.s      .hide                           ; SHOW or HIDE ?
.show
	moveq.l    #50,d1                          ; Ticks
	CALLDOS    Delay                           ; (Ticks)(d1)
	lea.l      AppGuiState(pc),a0              ; 
	move.l     #APP_GUISTATE_SHOW,(a0)         ; 
	bra.s      .done                           ; GuiState
.hide
	lea.l      AppGuiState(pc),a0              ; 
	move.l     #APP_GUISTATE_HIDE,(a0)         ; GuiState
.done
	move.l     a2,a1                           ; Msg
	CALLEXEC   ReplyMsg                        ; (Msg)(a1)
.exit
	movem.l    (sp)+,a2/a6                     ; Pop
	rts                                        ; Return

************************************************************
