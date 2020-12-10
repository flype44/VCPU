************************************************************
*	
*	SENSORS (I2C) FUNCTIONS
*	
************************************************************
*	
*	XDEF Sensors_Install
*	XDEF Sensors_Uninstall
*	XDEF Sensors_FindTemp
*	XDEF Sensors_ReadTemp
*	XDEF Sensors_TempToString
*	
************************************************************

	INCLUDE inc/i2cclass.i
	INCLUDE inc/i2csensors.i
	INCLUDE inc/i2csensors_lib.i

************************************************************

	CNOP 0,4

MySensorsUnit:   DC.L 0
MySensorsName:   DC.L 0
MySensorsIndex:  DC.L 0
MySensorsValue:  DC.L 0
MySensorsBase:   DC.L 0
MySensorsArgs:   DS.B (4+2+2+4)
MySensorsTmpl:   DC.B '%s: %d.%d%s',0
MySensorsFile:   DC.B 'i2csensors.library',0

************************************************************

	CNOP 0,4

Sensors_Install:
	movem.l    a6,-(sp)                        ; Push
.openLib
	lea.l      MySensorsFile(pc),a1            ; Name
	moveq.l    #0,d0                           ; Version
	CALLEXEC   OpenLibrary                     ; (Name,Version)(a1,d0)
	lea.l      MySensorsBase(pc),a0            ; Base
	move.l     d0,(a0)                         ; Base
.findTemp
	bsr        Sensors_FindTemp                ; Find Temp sensor
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Sensors_Uninstall:
	movem.l    a6,-(sp)                        ; Push
	move.l     MySensorsBase(pc),a1            ; Base
	tst.l      a1                              ; Base
	beq.s      .exit                           ; Skip
	CALLEXEC   CloseLibrary                    ; (Base)(a1)
.exit
	movem.l    (sp)+,a6                        ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Sensors_FindTemp:
	movem.l    d2/a2/a6,-(sp)                  ; Push
	lea.l      MySensorsIndex(pc),a0           ; Index
	move.l     #$ffff,(a0)                     ; Index
	tst.l      MySensorsBase(pc)               ; Base
	beq.s      .exit                           ; Skip
	move.l     #I2C_TEMP,d0                    ; Type
	move.l     MySensorsBase(pc),a6            ; Base
	jsr        _LVOi2c_SensorNum(a6)           ; (Type)(d0)
	move.l     d0,d2                           ; Count
	beq.s      .exit                           ; Skip
	subq.l     #1,d2                           ; Count-1
.loop
	move.l     #I2C_TEMP,d0                    ; Type
	move.l     d2,d1                           ; Index
	lea.l      MySensorsUnit(pc),a1            ; Unit
	lea.l      MySensorsName(pc),a2            ; Name
	move.l     MySensorsBase(pc),a6            ; Base
	jsr        _LVOi2c_ReadSensor(a6)          ; (Type,Index,Unit,Name)(d0,d1,a1,a2)
	move.l     MySensorsName(pc),d0            ; Name
	dbne       d2,.loop                        ; Next
	lea.l      MySensorsIndex(pc),a0           ; Index
	move.l     d2,(a0)                         ; Index
.exit
	move.l     MySensorsIndex(pc),d0           ; Result
	cmpi.l     #$ffff,d0                       ; Check
	sne        d0                              ; Bool
	andi.l     #1,d0                           ; Bool
	movem.l    (sp)+,d2/a2/a6                  ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Sensors_ReadTemp:
	movem.l    a2/a6,-(sp)                     ; Push
	tst.l      MySensorsBase(pc)               ; Base
	beq.s      .exit                           ; Skip
	lea.l      MySensorsIndex(pc),a0           ; Index
	cmp.l      #$ffff,(a0)                     ; Index
	beq.s      .exit                           ; Skip
	move.l     #I2C_TEMP,d0                    ; Type
	move.l     MySensorsIndex(pc),d1           ; Index
	lea.l      MySensorsUnit(pc),a1            ; Unit
	lea.l      MySensorsName(pc),a2            ; Name
	move.l     MySensorsBase(pc),a6            ; Base
	jsr        _LVOi2c_ReadSensor(a6)          ; (Type,Index,Unit,Name)(d0,d1,a1,a2)
	lea.l      MySensorsValue(pc),a0           ; Result
	move.l     d0,(a0)                         ; Result
.exit
	movem.l    (sp)+,a2/a6                     ; Pop
	rts                                        ; Return

************************************************************

	CNOP 0,4

Sensors_TempToString:
	;----------------------------------
	; a0: string buffer
	;----------------------------------
	movem.l    d2/a2/a3/a6,-(sp)               ; Pop
	lea.l      MySensorsIndex(pc),a1           ; Index
	cmp.l      #$ffff,(a1)                     ; Index
	beq.s      .exit                           ; Skip
	move.l     MySensorsValue(pc),d0           ; Value
	move.w     d0,d1                           ; BB
	swap       d0                              ; AA
	andi.l     #65535,d1                       ; BB
	mulu.l     #100,d1                         ; BB * 100
	divu.l     #65536,d1                       ; BB * 100 / 65536
	move.l     a0,a3                           ; Data
	lea.l      MySensorsTmpl(pc),a0            ; Fmt
	lea.l      MySensorsArgs(pc),a1            ; Args
	lea.l      .mycb(pc),a2                    ; CB
	move.l     MySensorsName(pc),0(a1)         ; Args[0] = Name
	move.w     d0,4(a1)                        ; Args[1] = 16.##
	move.w     d1,6(a1)                        ; Args[2] = ##.16
	move.l     MySensorsUnit(pc),8(a1)         ; Args[3] = Unit
	CALLEXEC   RawDoFmt                        ; (Tmplt,Args,CB,Data)(a0,a1,a2,a3)
.exit
	movem.l    (sp)+,d2/a2/a3/a6               ; Pop
	rts                                        ; Return
.mycb
	cmp.b      #'°',d0                         ; Check
	bne.s      .push                           ; Skip
	move.b     #' ',d0                         ; Replace
.push
	move.b     d0,(a3)+                        ; Push char
	rts                                        ; Return

************************************************************
