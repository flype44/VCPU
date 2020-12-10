************************************************************
*	
*	CPU FUNCTIONS
*	
************************************************************
*	
*	XDEF V_CPU_Detect080
*	XDEF V_CPU_DetectFPU
*	XDEF V_CPU_Revision
*	XDEF V_CPU_DFP_On
*	XDEF V_CPU_DFP_Off
*	XDEF V_CPU_ESS_On
*	XDEF V_CPU_ESS_Off
*	XDEF V_CPU_ICACHE_On
*	XDEF V_CPU_ICACHE_Off
*	
************************************************************

IllegalInstructionVector EQU $10

	CNOP 0,4

V_CPU_Detect080:
	movem.l    d1-a6,-(sp)                     ; Push
	move.l     $4.w,a6                         ; 
	move.w     AttnFlags(a6),d0                ; 
	and.w      #AFF_68010|AFF_68020|AFF_68030|AFF_68040,d0
	beq.s      .fail                           ; 
	jsr        _LVODisable(a6)                 ; 
	lea.l      .check(pc),a5                   ; 
	jsr        _LVOSupervisor(A6)              ; 
	jsr        _LVOEnable(A6)                  ; 
	cmp.w      #$0440,d0                       ; 
	bne.s      .fail                           ; 
	moveq.l    #1,d0                           ; 
	bra.s      .done                           ; 
.fail
	moveq.l    #0,d0                           ; 
.done
	movem.l    (sp)+,d1-a6                     ; Pop
	rts                                        ; Return
.check
	movec      VBR,a0                          ; 
	lea.l      .trapcatch(pc),a1               ; 
	move.l     IllegalInstructionVector(a0),a5 ; 
	move.l     a1,IllegalInstructionVector(a0) ; 
	moveq.l    #0,d0                           ; 
	movec      PCR,d0                          ; 
	swap       d0                              ; 
	move.l     a5,IllegalInstructionVector(a0) ; 
	rte                                        ; 
.trapcatch
	addq.l     #4,2(sp)                        ; 
	nop                                        ; Nop
	rte                                        ; Return

************************************************************

	CNOP 0,4

V_CPU_DetectFPU:
	moveq.l    #0,d0                           ; Result
	move.l     $4.w,a0                         ; ExecBase
	move.w     AttnFlags(a0),d1                ; AttnFlags
	btst       #AFB_68881,d1                   ; 68881 ?
	bne.s      .test                           ; 
	btst       #AFB_68882,d1                   ; 68882 ?
	bne.s      .test                           ; 
	btst       #AFB_FPU40,d1                   ; FPU40 ?
	beq.s      .exit                           ; 
.test
	moveq.l    #1,d0                           ; d0 = 1
	fmove.l    d0,fp0                          ; f0 = 1
	fadd.x     fp0,fp0                         ; f0 = 2
	fmove.l    fp0,d0                          ; d0 = 2
	tst.l      d0                              ; d0 = 0 ?
	sne        d0                              ; Bool
	and.l      #1,d0                           ; Result
.exit
	rts                                        ; Return

************************************************************

	CNOP 0,4

V_CPU_Revision:
	movem.l    a5/a6,-(sp)                     ; Push
	move.l     $4.w,a6                         ; ExecBase
	lea.l      .supv(pc),a5                    ; Code
	jsr        _LVOSupervisor(a6)              ; Supervisor(code)
	movem.l    (sp)+,a5/a6                     ; Pop
	rts                                        ; Return
.supv:
	movec      pcr,d0                          ; AAAABBCC
	lsr.l      #8,d0                           ; --AAAABB
	andi.l     #$ff,d0                         ; ------BB
	rte                                        ; Return

************************************************************

	CNOP 0,4

V_CPU_DFP_On:
	movem.l    a5/a6,-(sp)                     ; Push
	move.l     $4.w,a6                         ; ExecBase
	lea.l      .supv(pc),a5                    ; Code
	jsr        _LVOSupervisor(a6)              ; Supervisor(code)
	movem.l    (sp)+,a5/a6                     ; Pop
	rts                                        ; Return
.supv:
	movec      pcr,d0                          ; Read PCR
	bset       #1,d0                           ; DFP-bit = 1
	movec      d0,pcr                          ; Update PCR
	movec      pcr,d0                          ; Read back
	rte                                        ; Return

************************************************************

	CNOP 0,4

V_CPU_DFP_Off:
	movem.l    a5/a6,-(sp)                     ; Push
	move.l     $4.w,a6                         ; ExecBase
	lea.l      .supv(pc),a5                    ; Code
	jsr        _LVOSupervisor(a6)              ; Supervisor(code)
	movem.l    (sp)+,a5/a6                     ; Pop
	rts                                        ; Return
.supv:
	movec      pcr,d0                          ; Read PCR
	bclr       #1,d0                           ; DFP-bit = 0
	movec      d0,pcr                          ; Update PCR
	movec      pcr,d0                          ; Read back
	rte                                        ; Return

************************************************************

	CNOP 0,4

V_CPU_ESS_On:
	movem.l    a5/a6,-(sp)                     ; Push
	move.l     $4.w,a6                         ; ExecBase
	lea.l      .supv(pc),a5                    ; Code
	jsr        _LVOSupervisor(a6)              ; Supervisor(code)
	movem.l    (sp)+,a5/a6                     ; Pop
	rts                                        ; Return
.supv:
	movec      pcr,d0                          ; Read PCR
	bset       #0,d0                           ; ESS-bit = 1
	movec      d0,pcr                          ; Update PCR
	movec      pcr,d0                          ; Read back
	rte                                        ; Return

************************************************************

	CNOP 0,4

V_CPU_ESS_Off:
	movem.l    a5/a6,-(sp)                     ; Push
	move.l     $4.w,a6                         ; ExecBase
	lea.l      .supv(pc),a5                    ; Code
	jsr        _LVOSupervisor(a6)              ; Supervisor(code)
	movem.l    (sp)+,a5/a6                     ; Pop
	rts                                        ; Return
.supv:
	movec      pcr,d0                          ; Read PCR
	bclr       #0,d0                           ; ESS-bit = 0
	movec      d0,pcr                          ; Update PCR
	movec      pcr,d0                          ; Read back
	rte                                        ; Return

************************************************************

	CNOP 0,4

V_CPU_ICACHE_On:
	movem.l    a5/a6,-(sp)                     ; Push
	move.l     $4.w,a6                         ; ExecBase
	lea.l      .supv(pc),a5                    ; Code
	jsr        _LVOSupervisor(a6)              ; Supervisor(code)
	movem.l    (sp)+,a5/a6                     ; Pop
	rts                                        ; Return
.supv:
	movec      cacr,d0                         ; Read CACR
	bset       #15,d0                          ; ICache-bit = 1
	movec      d0,cacr                         ; Update CACR
	movec      pcr,d0                          ; Read back
	rte                                        ; Return

************************************************************

	CNOP 0,4

V_CPU_ICACHE_Off:
	movem.l    a5/a6,-(sp)                     ; Push
	move.l     $4.w,a6                         ; ExecBase
	lea.l      .supv(pc),a5                    ; Code
	jsr        _LVOSupervisor(a6)              ; Supervisor(code)
	movem.l    (sp)+,a5/a6                     ; Pop
	rts                                        ; Return
.supv:
	movec      cacr,d0                         ; Read CACR
	bclr       #15,d0                          ; ICache-bit = 0
	movec      d0,cacr                         ; Update CACR
	movec      pcr,d0                          ; Read back
	rte                                        ; Return

************************************************************
