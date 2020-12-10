	ifnd	_LIBRARIES_I2CSENSORS_I
_LIBRARIES_I2CSENSORS_I	EQU	1

;******************************************************************************************
;*
;* $id: i2csensors.i $
;*
;* Definitions for I2C Sensors Library interface
;*
;*
;* author: (C) 2018 Henryk Richter
;*
;******************************************************************************************
	IFND	EXEC_TYPES_I
	include	"exec/types.i"
	ENDC
	IFND	EXEC_LIBRARIES_I
	include	"exec/libraries.i"
	ENDC
	IFND	_INC_I2CCLASS_I
	include "libraries/i2cclass.i"
	ENDC

;*
;* Name
;*
SENSORSNAME	MACRO
		dc.b	"i2csensors.library",0
		ENDM

	endc	;_LIBRARIES_I2CSENSORS_I
