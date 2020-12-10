	IFND	LIBRARIES_VAMPIRE_I
LIBRARIES_VAMPIRE_I	SET	1
**
** $VER: vampire.i 1.0 (01.11.2019)
**
** vampire.library definitions
** 

;--------------------------------------
; Vampire AttnFlags
;--------------------------------------

	IFND AFB_68080
AFB_68080            EQU 10
AFF_68080            EQU (1<<AFB_68080)
	ENDC

;--------------------------------------
; Vampire Registers
;--------------------------------------

VREG_BOARD           EQU $00DFF3FC
VREG_FASTIDE         EQU $00DD1020
VREG_SDCLKDIV        EQU $00DE000C

;--------------------------------------
; Vampire Board Models
;--------------------------------------

VREG_BOARD_Unknown   EQU $00
VREG_BOARD_V600      EQU $01
VREG_BOARD_V500      EQU $02
VREG_BOARD_V4        EQU $03
VREG_BOARD_V666      EQU $04
VREG_BOARD_V4SA      EQU $05
VREG_BOARD_V1200     EQU $06
VREG_BOARD_Future    EQU $07

;--------------------------------------
; Vampire FastIDE modes
;--------------------------------------

VREG_FASTIDE_NORMAL  EQU 0
VREG_FASTIDE_FAST    EQU 1
VREG_FASTIDE_FASTER  EQU 2
VREG_FASTIDE_FASTEST EQU 3

;--------------------------------------
; Vampire Special Purpose Registers
;--------------------------------------

VREG_SPR_CLK         EQU $809	; Clock-Cycle Counter
VREG_SPR_IP1         EQU $80A	; Instruction-Executed Pipe 1
VREG_SPR_IP2         EQU $80B	; Instruction-Executed Pipe 2
VREG_SPR_BPC         EQU $80C	; Branch-Predict Correct
VREG_SPR_BPW         EQU $80D	; Branch-Predict Wrong
VREG_SPR_DCH         EQU $80E	; Data-Cache Hit
VREG_SPR_DCM         EQU $80F	; Data-Cache Miss
VREG_SPR_STR         EQU $00A	; Stall-Registers
VREG_SPR_STC         EQU $00B	; Stall-Cache
VREG_SPR_STH         EQU $00C	; Stall-Hazard
VREG_SPR_STB         EQU $00D	; Stall-Buffer
VREG_SPR_MWR         EQU $00E	; Memory-Writes

;--------------------------------------
; Vampire Macros
;--------------------------------------

GETBOARDID MACRO
	move.w     VREG_BOARD,\1
	lsr.l      #8,\1
	andi.l     #$FF,\1
	ENDM

GETCPUMULT MACRO
	move.w     VREG_BOARD,\1
	andi.l     #$FF,\1
	ENDM

SETFASTIDE MACRO
	move.b     \1,VREG_FASTIDE
	ENDM

SETSDCLOCKDIV MACRO
	move.b     \1,VREG_SDCLKDIV
	ENDM

;--------------------------------------
; END OF FILE
;--------------------------------------

	ENDC ; LIBRARIES_VAMPIRE_I
