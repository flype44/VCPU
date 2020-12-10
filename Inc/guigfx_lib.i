	IFND	LIBRARIES_GUIGFX_LIB_I
LIBRARIES_GUIGFX_LIB_I	SET	1
**
**	$VER: guigfx_lib.i v9.00 (1.1.98)
**
**	guigfx.library vector offsets
**
**	© TEK neoscientists
**

	IFND    EXEC_LIBRARIES_I
	include "exec/libraries.i"
	ENDC

;==========================================================================
;===========================  LVO DEFINITIONS  ============================
;==========================================================================

	LIBINIT

	LIBDEF		_LVOMakePictureA
	LIBDEF		_LVOLoadPictureA
	LIBDEF		_LVOReadPictureA
	LIBDEF		_LVOClonePictureA
	LIBDEF		_LVODeletePicture
	LIBDEF		_LVOUpdatePicture

	LIBDEF		_LVOAddPictureA
	LIBDEF		_LVOAddPaletteA
	LIBDEF		_LVOAddPixelArrayA
	LIBDEF		_LVORemColorHandle
	
	LIBDEF		_LVOCreatePenShareMapA
	LIBDEF		_LVODeletePenShareMap
	
	LIBDEF		_LVOObtainDrawHandleA
	LIBDEF		_LVOReleaseDrawHandle

	LIBDEF		_LVODrawPictureA
	LIBDEF		_LVOMapPaletteA
	LIBDEF		_LVOMapPenA
	
	LIBDEF		_LVOCreatePictureBitMapA
	
	LIBDEF		_LVODoPictureMethodA
	LIBDEF		_LVOGetPictureAttrsA

	LIBDEF		_LVOLockPictureA
	LIBDEF		_LVOUnLockPicture

	LIBDEF		_LVOIsPictureA
	
	LIBDEF		_LVOCreateDirectDrawHandleA
	LIBDEF		_LVODeleteDirectDrawHandle
	LIBDEF		_LVODirectDrawTrueColorA
	
	LIBDEF		_LVOCreateAlphaMaskA

;==========================================================================

GUIGFX_NAME MACRO
	DC.B 'guigfx.library',0
	ENDM

CALLGUIGFX MACRO
	move.l _GuiGfxBase,a6
	jsr    _LVO\1(a6)
	ENDM

;==========================================================================

	ENDC
