	IFND	LIBRARIES_VAMPIRELIB_I
LIBRARIES_VAMPIRELIB_I	SET	1
**
** $VER: vampire_lib.i 1.0 (01.11.2019)
** 
** vampire.library definitions
** 

	IFND    EXEC_LIBRARIES_I
	INCLUDE "exec/exec.i"
	ENDC

;================================================

	LIBINIT
	LIBDEF		_LVOVampireLib1 ;
	LIBDEF		_LVOVampireLib2 ;
	LIBDEF		_LVOVampireLib3 ;
	LIBDEF		_LVOVampireLib4 ;
	LIBDEF		_LVOVampireLib5 ;
	LIBDEF		_LVOVampireLib6 ;

;================================================

VAMPIRELIB_VERSION EQU 1

VAMPIRELIB_NAME MACRO
	DC.B 'vampire.library',0
	ENDM

CALLVAMPIRE MACRO
	move.l _VampireBase,a6
	jsr    _LVO\1(a6)
	ENDM

;================================================

	ENDC ; LIBRARIES_VAMPIRELIB_I
