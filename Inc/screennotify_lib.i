	IFND	LIBRARIES_SCREENNOTIFY_LIB_I
LIBRARIES_SCREENNOTIFY_LIB_I	SET	1
**
** $VER: screennotify_lib.i 1.0 (26.03.95)
**
** screennotify.library vector offset
** 

	IFND    EXEC_LIBRARIES_I
	INCLUDE "exec/exec.i"
	ENDC

_LVOAddCloseScreenClient EQU -30
_LVORemCloseScreenClient EQU -36
_LVOAddPubScreenClient   EQU -42
_LVORemPubScreenClient   EQU -48
_LVOAddWorkbenchClient   EQU -54
_LVORemWorkbenchClient   EQU -60

CALLSCN MACRO
	move.l _ScreenNotifyBase,a6
	jsr    _LVO\1(a6)
	ENDM

	ENDC
