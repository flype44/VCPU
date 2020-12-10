************************************************************
*	
*	COMMODITIES FUNCTIONS
*	
************************************************************
*	
*	XDEF CxBroker_Install
*	XDEF CxBroker_Uninstall
*	XDEF CxBroker_Events
*	
************************************************************

	CNOP 0,4

MyNewBroker:
	DC.B NB_VERSION      ; nb_Version
	DC.B 0               ; nb_Reserve1
	DC.L CXBROKER_NAME   ; nb_Name
	DC.L CXBROKER_TITLE  ; nb_Title
	DC.L CXBROKER_DESCR  ; nb_Descr
	DC.W NBU_UNIQUE      ; nb_Unique
	DC.W COF_SHOW_HIDE   ; nb_Flags
	DC.B 0               ; nb_Pri
	DC.B 0               ; nb_Reserve2
	DC.L 0               ; nb_Port
	DC.W 0               ; nb_ReservedChannel

MyCxPort:       DS.L 1
MyCxBroker:     DS.L 1
CXBROKER_NAME:  DC.B 'VCPU',0
CXBROKER_TITLE: DC.B 'VCPU 0.1c © 2016-2019 APOLLO-Team',0
CXBROKER_DESCR: DC.B 'Vampire CPU monitor tool',0

************************************************************

	CNOP 0,4

CxBroker_Install:
	movem.l    a6,-(sp)                        ; Push
.createPort
	CALLEXEC   CreateMsgPort                   ; (void)()
	tst.l      d0                              ; Null ?
	beq.s      .exit                           ; Skip
	lea.l      MyCxPort(pc),a0                 ; MsgPort
	move.l     d0,(a0)                         ; MsgPort
	move.l     d0,a0                           ; MsgPort
	lea.l      CXBROKER_NAME(pc),a1            ; MsgPort name
	move.l     a1,LN_NAME(a0)                  ; MsgPort->ln_Name
.addBroker
	lea.l      MyNewBroker(pc),a0              ; NewBroker
	move.l     d0,nb_Port(a0)                  ; NewBroker->Port
	moveq.l    #0,d0                           ; Error
	CALLCX     CxBroker                        ; (Nb,Error)(a0,d0)
	lea.l      MyCxBroker(pc),a0               ; CxBroker
	move.l     d0,(a0)                         ; CxBroker
	move.l     d0,a0                           ; CxBroker
	moveq.l    #1,d0                           ; True
	CALLCX     ActivateCxObj                   ; (CxObj,Bool)
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

CxBroker_Uninstall:
	movem.l    a6,-(sp)                        ; Push
.delObjs
	tst.l      MyCxBroker(pc)                  ; CxObj
	beq.s      .delPort                        ; Skip
	move.l     MyCxBroker(pc),a0               ; CxObj
	CALLCX     DeleteCxObjAll                  ; (CxObj)(a0)
.delPort
	tst.l      MyCxPort(pc)                    ; MsgPort
	beq.s      .exit                           ; Skip
	move.l     MyCxPort(pc),a0                 ; MsgPort
	CALLEXEC   DeleteMsgPort                   ; (MsgPort)(a0)
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

CxBroker_Events:
	movem.l    d2/d3/a2/a6,-(sp)               ; Push
.getMsg
	tst.l      MyCxPort(pc)                    ; MsgPort
	beq        .exit                           ; Null ?
	move.l     MyCxPort(pc),a0                 ; MsgPort
	CALLEXEC   GetMsg                          ; (MsgPort)(a0)
	tst.l      d0                              ; Null ?
	beq        .exit                           ; Skip
	move.l     d0,a0                           ; Msg
	move.l     d0,a2                           ; Msg
	CALLCX     CxMsgType                       ; (Msg)(a0)
	move.l     d0,d2                           ; Type
	move.l     a2,a0                           ; Msg
	CALLCX     CxMsgID                         ; (Msg)(a0)
	move.l     d0,d3                           ; Command
.getType
	cmp.l      #CXM_COMMAND,d2                 ; 
	bne.s      .done                           ; 
.getCommand
	cmp.l      #CXCMD_KILL,d3                  ; 
	beq.s      .cmdKill                        ; 
	cmp.l      #CXCMD_APPEAR,d3                ; 
	beq.s      .cmdAppear                      ; 
	cmp.l      #CXCMD_DISAPPEAR,d3             ; 
	beq.s      .cmdDisappear                   ; 
	cmp.l      #CXCMD_ENABLE,d3                ; 
	beq.s      .cmdEnable                      ; 
	cmp.l      #CXCMD_DISABLE,d3               ; 
	beq.s      .cmdDisable                     ; 
	bra.s      .done                           ; 
.cmdKill
	lea.l      AppRunState(pc),a0              ; KILL
	move.l     #APP_RUNSTATE_QUIT,(a0)         ; 
	bra.s      .done                           ; 
.cmdEnable
	lea.l      AppRunState(pc),a0              ; ENABLE
	move.l     #APP_RUNSTATE_ENABLED,(a0)      ; 
	bra.s      .done                           ; 
.cmdDisable
	lea.l      AppRunState(pc),a0              ; DISABLE
	move.l     #APP_RUNSTATE_DISABLED,(a0)     ; 
	bra.s      .done                           ; 
.cmdAppear
	lea.l      AppGuiState(pc),a0              ; APPEAR
	move.l     #APP_GUISTATE_SHOW,(a0)         ; 
	bra.s      .done                           ; 
.cmdDisappear
	lea.l      AppGuiState(pc),a0              ; DISAPPEAR
	move.l     #APP_GUISTATE_HIDE,(a0)         ; 
.done
	move.l     a2,a1                           ; Msg
	CALLEXEC   ReplyMsg                        ; (Msg)(a1)
.exit
	movem.l    (sp)+,d2/d3/a2/a6               ; Pop
	rts                                        ; Return

************************************************************
