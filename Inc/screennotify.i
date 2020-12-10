	IFND	LIBRARIES_SCREENNOTIFY_I
LIBRARIES_SCREENNOTIFY_I	SET	1
**
** $VER: screennotify.i 1.0 (26.03.95)
**
** screennotify.library definitions
** 

	IFND    EXEC_LIBRARIES_I
	INCLUDE "exec/exec.i"
	ENDC

; Name and version

SCREENNOTIFY_VERSION EQU 1

SCREENNOTIFY_NAME MACRO
	DC.B 'screennotify.library',0
	ENDM

; Message sent to clients

	RSRESET
snm_Message RS.B MN_SIZE ; Exec Message
snm_Type    RS.L 1       ; READ ONLY!!
snm_Value   RS.L 1       ; READ ONLY!!
snm_SIZEOF  RS.L 0       ; 

; CloseScreen() called, 
; snm_Value contains pointer to Screen structure

SCREENNOTIFY_TYPE_CLOSESCREEN   EQU 0

; PubScreenStatus() called to make screen public, 
; snm_Value contains pointer to PubScreenNode structure

SCREENNOTIFY_TYPE_PUBLICSCREEN  EQU 1

; PubScreenStatus() called to make screen private, 
; snm_Value contains pointer to PubScreenNode structure

SCREENNOTIFY_TYPE_PRIVATESCREEN EQU 2

; CloseWorkBench() called, please close windows on WB
; snm_Value contains FALSE (0)
; OpenWorkBench() called, windows can be opened again
; snm_Value contains TRUE (1)

SCREENNOTIFY_TYPE_WORKBENCH     EQU 3

	ENDC
