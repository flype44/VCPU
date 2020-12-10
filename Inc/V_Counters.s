************************************************************
*	
*	COUNTERS FUNCTIONS
*	
************************************************************
*	
*	XDEF Counters_Install
*	XDEF Counters_Uninstall
*	
************************************************************

	CNOP 0,4

MyCountersPort:   DS.L 1
MyCountersIOTV:   DS.L 1

TimerName:
	DC.B 'timer.device',0

************************************************************

	CNOP 0,4

Counters_Install:
	movem.l    a6,-(sp)                        ; Push
.createPort
	CALLEXEC   CreateMsgPort                   ; (void)()
	tst.l      d0                              ; Null ?
	beq.s      .exit                           ; Skip
	lea.l      MyCountersPort(pc),a0           ; MsgPort
	move.l     d0,(a0)                         ; MsgPort
.createIOReq
	move.l     d0,a0                           ; MsgPort
	move.l     #IOTV_SIZE,d0                   ; Size
	CALLEXEC   CreateIORequest                 ; (MsgPort,Size)(a0,d0)
	lea.l      MyCountersIOTV(pc),a0           ; ioReq
	move.l     d0,(a0)                         ; ioReq
.openDevice
	lea.l      TimerName(pc),a0                ; Name
	move.l     d0,a1                           ; ioReq
	moveq.l    #UNIT_MICROHZ,d0                ; Unit
	moveq.l    #0,d1                           ; Flags
	CALLEXEC   OpenDevice                      ; (Name,Unit,ioReq,Flags)(a0,d0,a1,d1)
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Counters_Uninstall:
	movem.l    a6,-(sp)                        ; Push
.closeDevice
	move.l     MyCountersIOTV(pc),a1           ; ioReq
	tst.l      a1                              ; Null ?
	beq.s      .deletePort                     ; Skip
	CALLEXEC   CloseDevice                     ; (ioReq)(a1)
.deleteIOReq
	move.l     MyCountersIOTV(pc),a0           ; ioReq
	CALLEXEC   DeleteIORequest                 ; (ioReq)(a0)
.deletePort
	tst.l      MyCountersPort(pc)              ; MsgPort
	beq.s      .exit                           ; Null ?
	move.l     MyCountersPort(pc),a0           ; MsgPort
	CALLEXEC   DeleteMsgPort                   ; (MsgPort)(a0)
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Counters_Begin:
	move.l     MyCountersIOTV(pc),a1           ; IOReq
	move.w     #TR_ADDREQUEST,IO_COMMAND(a1)   ; Command
	move.l     #5,IOTV_TIME+TV_SECS(a1)        ; Seconds
	move.l     #0,IOTV_TIME+TV_MICRO(a1)       ; MicroSeconds
	CALLEXEC   SendIO                          ; BeginIO
*	LINKLIB    DEV_BEGINIO,IO_DEVICE(a1)       ; BeginIO
	rts                                        ; Return

************************************************************

	CNOP 0,4

Counters_Events:
	movem.l    a2/a6,-(sp)                     ; Push
.getMsg
	move.l     MyCountersPort(pc),a0           ; MsgPort
	move.l     a0,a2                           ; MsgPort
	tst.l      a0                              ; Null ?
	beq.s      .exit                           ; Skip
	CALLEXEC   GetMsg                          ; (MsgPort)(a0)
	tst.l      d0                              ; Null ?
	beq.s      .exit                           ; Skip
	bchg       #1,$BFE001                      ; DEBUG
.loop
	move.l     MyCountersPort(pc),a0           ; MsgPort
	CALLEXEC   GetMsg                          ; (MsgPort)(a0)
	tst.l      d0                              ; Null ?
	bne.s      .loop                           ; Continue
.send
	move.l     MyCountersIOTV(pc),a1           ; IOReq
	bsr        Counters_Begin                  ; Restart
.exit
	movem.l    (sp)+,a2/a6                     ; Pop
	rts                                        ; Return

************************************************************

