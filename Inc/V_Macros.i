	IFND	V_MACROS_I
V_MACROS_I	SET	1

************************************************************

LIBOPEN MACRO
	lea.l      \1Name(pc),a1
	moveq.l    #0,d0
	CALLEXEC   OpenLibrary
	tst.l      d0
	beq.w      .closeLibs
	move.l     d0,_\1Base
	ENDM

************************************************************

LIBCLOSE MACRO
	move.l     _\1Base(pc),a1
	CALLEXEC   CloseLibrary
	ENDM

************************************************************

CALLAG MACRO
	move.l     _AmigaGuideBase(pc),a6
	jsr        _LVO\1(a6)
	ENDM

************************************************************

CALLCX MACRO
	move.l     _CommoditiesBase(pc),a6
	jsr        _LVO\1(a6)
	ENDM

************************************************************

CALLDF MACRO
	move.l     _DiskfontBase(pc),a6
	jsr        _LVO\1(a6)
	ENDM

************************************************************

CALLGT MACRO
	move.l     _GadtoolsBase(pc),a6
	jsr        _LVO\1(a6)
	ENDM

************************************************************

CALLLAYER MACRO
	move.l     _LayerBase(pc),a6
	jsr        _LVO\1(a6)
	ENDM

************************************************************

CALLRT MACRO
	move.l     _ReqtoolsBase(pc),a6
	jsr        _LVO\1(a6)
	ENDM

************************************************************

CALLUTIL MACRO
	move.l     _UtilityBase(pc),a6
	jsr        _LVO\1(a6)
	ENDM

************************************************************

CALLWB MACRO
	move.l     _WorkbenchBase(pc),a6
	jsr        _LVO\1(a6)
	ENDM

************************************************************

TEXTATTR MACRO
	DC.L \1           ; ta_Name
	DC.W \2           ; ta_YSize
	DC.B \3           ; ta_Style
	DC.B FPF_DISKFONT ; ta_Flags
	DC.L  0           ; ta_SIZEOF
	ENDM

************************************************************

ITEXT MACRO
	DC.B \1           ; it_FrontPen
	DC.B \2           ; it_BackPen
	DC.B \3           ; it_DrawMode
	DC.B  0           ; it_KludgeFill
	DC.W \4           ; it_LeftEdge
	DC.W \5           ; it_TopEdge
	DC.L \6           ; it_ITextFont
	DC.L \7           ; it_Text
	DC.L \8           ; it_NextText
	ENDM

************************************************************

MENUNUM MACRO
	move.w   \1,\2    ; (n & 0x001F)
	andi.w   #$1F,\2  ; 
	ENDM

ITEMNUM MACRO
	move.w   \1,\2    ; ((n >> 5) & 0x003F)
	lsr.w    #5,\2    ; 
	andi.w   #$3F,\2  ; 
	ENDM

SUBNUM MACRO
	move.w   \1,\2    ; ((n >> 11) & 0x001F)
	lsr.w    #8,\2    ; 
	lsr.w    #3,\2    ; 
	andi.w   #$1F,\2  ; 
	ENDM

************************************************************

MENUITEM MACRO
	DC.B \1           ; nm_Type
	DC.B  0           ; nm_Pad
	DC.L \2           ; nm_Label
	IFC '','\3'
	DC.L  0           ; nm_CommKey
	ELSEIF
	DC.L \3           ; nm_CommKey
	ENDC
	DC.W  0           ; nm_Flags
	DC.L  0           ; nm_MutualExclude
	IFC '','\4'
	DC.L  0           ; nm_UserData
	ELSEIF
	DC.L \4           ; nm_UserData
	ENDC
	ENDM

************************************************************

	ENDC	; V_MACROS_I
