
************************************************************

SPR_CLK       EQU	$809	; Clock-Cycle Counter
SPR_IP1       EQU	$80A	; Instruction-Executed Pipe 1
SPR_IP2       EQU	$80B	; Instruction-Executed Pipe 2
SPR_BPC       EQU	$80C	; Branch-Predict Correct
SPR_BPW       EQU	$80D	; Branch-Predict Wrong
SPR_DCH       EQU	$80E	; Data-Cache Hit
SPR_DCM       EQU	$80F	; Data-Cache Miss
SPR_STR       EQU	$00A	; Stall-Registers
SPR_STC       EQU	$00B	; Stall-Cache
SPR_STH       EQU	$00C	; Stall-Hazard
SPR_STB       EQU	$00D	; Stall-Buffer
SPR_MWR       EQU	$00E	; Memory-Writes

************************************************************

ReadCounters:
	dc.w      $4e7a,SPR_CLK                  ; 
	move.l    d0,C_CLK                       ; 
	dc.w      $4e7a,SPR_IP1                  ; 
	move.l    d0,C_IP1                       ; 
	dc.w      $4e7a,SPR_IP2                  ; 
	move.l    d0,C_IP2                       ; 
	dc.w      $4e7a,SPR_BPC                  ; 
	move.l    d0,C_BPC                       ; 
	dc.w      $4e7a,SPR_BPW                  ; 
	move.l    d0,C_BPW                       ; 
	dc.w      $4e7a,SPR_DCH                  ; 
	move.l    d0,C_DCH                       ; 
	dc.w      $4e7a,SPR_DCM                  ; 
	move.l    d0,C_DCM                       ; 
	dc.w      $4e7a,SPR_STR                  ; 
	move.l    d0,C_STR                       ; 
	dc.w      $4e7a,SPR_STC                  ; 
	move.l    d0,C_STC                       ; 
	dc.w      $4e7a,SPR_STH                  ; 
	move.l    d0,C_STH                       ; 
	dc.w      $4e7a,SPR_STB                  ; 
	move.l    d0,C_STB                       ; 
	dc.w      $4e7a,SPR_MWR                  ; 
	move.l    d0,C_MWR                       ; 
	RTS

************************************************************

C_CLK:              DS.B C_SIZEOF
C_IP1:              DS.B C_SIZEOF
C_IP2:              DS.B C_SIZEOF
C_BPC:              DS.B C_SIZEOF
C_BPW:              DS.B C_SIZEOF
C_DCH:              DS.B C_SIZEOF
C_DCM:              DS.B C_SIZEOF
C_STR:              DS.B C_SIZEOF
C_STC:              DS.B C_SIZEOF
C_STH:              DS.B C_SIZEOF
C_STB:              DS.B C_SIZEOF
C_MWR:              DS.B C_SIZEOF

************************************************************
