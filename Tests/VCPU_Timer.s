
************************************************************

.openTimer
	;
	lea       SoftIntData(pc),a4             ; SoftIntData struct
	;
	lea       MySoftInt(pc),a0               ; Soft Interrupt
	move.l    #SoftIntCode,IS_CODE(a0)       ; 
	move.l    #SoftIntData,IS_DATA(a0)       ; 
	move.b    #32,LN_PRI(a0)                 ; 
	;
	CALLEXEC  CreateMsgPort                  ; Message Port
	tst.l     d0                             ; 
	beq       .closeDOS                      ; 
	move.l    d0,I_MsgPort(a4)               ; 
	move.l    d0,a0                          ; 
	move.b    #NT_MSGPORT,LN_TYPE(a0)        ; 
	move.b    #PA_SOFTINT,MP_FLAGS(a0)       ; 
	move.l    #MySoftInt,MP_SIGTASK(a0)      ; 
	;
	lea       MyTimeReq,a0                   ; Time Request
	move.b    #NT_REPLYMSG,LN_TYPE(a0)       ; 
	move.w    #IOTV_SIZE,MN_LENGTH(a0)       ; 
	move.l    I_MsgPort(a4),MN_REPLYPORT(a0) ; 
	;
	lea       TimerName,a0                   ; Open Timer
	moveq.l   #UNIT_MICROHZ,d0               ; 
	lea       MyTimeReq,a1                   ; 
	move.l    #0,d1                          ; 
	CALLEXEC  OpenDevice                     ; 
	tst.l     d0                             ; 
	bne.w     .delPort                       ; 
	;
    move.l    #1,I_Running(a4)               ; One-Shot timer
    lea       MyTimeReq,a1                   ; 
    move.w    #TR_ADDREQUEST,IO_COMMAND(a1)  ; 
    move.l    #0,IOTV_TIME+TV_SECS(a1)       ; 
    move.l    #(1000000/10),d0               ; 
    move.l    d0,IOTV_TIME+TV_MICRO(a1)      ; 
    LINKLIB   DEV_BEGINIO,IO_DEVICE(a1)      ; 
    dc.w      $4e7a,($0000+SPR_CLK)          ; 
    move.l    d0,I_CPUFreq(a4)               ; 
	;
.wait
    tst.l     I_Running(a4)                  ; 
    beq.s     .done                          ; 
    move.l    #5,d1                          ; 
    CALLDOS   Delay                          ; 
    bra.s     .wait                          ; 
.done
	lea       StrCPUFreq(pc),a1              ; 
	lea       I_CPUFreq(a4),a2               ; 
	move.l    a1,d1                          ; 
	move.l    a2,d2                          ; 
	CALLDOS   VPrintf                        ; 
	move.l    #RETURN_OK,_RC                 ; Return Code

.closeDev
	lea       MyTimeReq(pc),a1               ; Close timer
	CALLEXEC  CloseDevice                    ; 

.delPort
	move.l    I_MsgPort(a4),a0               ; Delete port
	CALLEXEC  DeleteMsgPort                  ; 

************************************************************
* Software Interrupt Routine
* void SoftIntCode(a1:intData, a5:intRoutine)
* scratch: d0-d1/a0-a1/a5
************************************************************

SoftIntCode:
	movem.l   d2-d7/a2-a4,-(sp)              ; Push
.getMsg    
	move.l    a1,a4                          ; d0:*TimeRequest = GetMsg(a0:*port)
	move.l    I_MsgPort(a4),a0               ; 
	CALLEXEC  GetMsg                         ; 
	tst.l     d0                             ; Is Null-Message ?
	beq.s     .done                          ; 
	tst.l     I_Running(a4)                  ; Is Running ?
	beq.s     .done                          ; 
.freq
	dc.w      $4e7a,($0000+SPR_CLK)          ; CPU Clock
	sub.l     I_CPUFreq(a4),d0               ; T2 - T1
	move.l    d0,d1                          ; T2 - T1
	divu.l    #(1000000/10),d0               ; Mega-Hertz
	move.l    d0,I_CPUFreq(a4)               ; Store CPU frequency
.mult
	divu.l    ex_EClockFrequency(a6),d1      ; ExecBase -> EClock
	move.l    d1,I_CPUMult(a4)               ; Store CPU multiplier
.done
	clr.l     I_Running(a4)                  ; Running = False
.exit
	movem.l   (sp)+,d2-d7/a2-a4              ; Pop
	moveq.l   #0,d0                          ; Return Code
	rts                                      ; Return

************************************************************
