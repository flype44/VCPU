
;----------------------------------------------------------

	INCDIR     progdir:include/
	INCLUDE    dos/dosextens.i
	INCLUDE    dos/dos_lib.i
	INCLUDE    exec/exec_lib.i
	INCLUDE    intuition/intuition.i
	INCLUDE    intuition/intuition_lib.i
	INCLUDE    workbench/startup.i

;----------------------------------------------------------

LIBOPEN MACRO
	lea.l      \1Name(pc),a1
	moveq.l    #0,d0
	CALLEXEC   OpenLibrary
	tst.l      d0
	beq.w      .closeLibs
	move.l     d0,_\1Base
	ENDM

LIBCLOSE MACRO
	move.l     _\1Base(pc),a1
	CALLEXEC   CloseLibrary
	ENDM

;----------------------------------------------------------

MAIN:

.wbStart
	suba.l     a1,a1                   ; Name
	CALLEXEC   FindTask                ; (Name)(a1)
	move.l     d0,a4                   ; Process
	move.l     pr_CLI(a4),d0           ; Process->CLI
	bne.s      .openLibs               ; Skip
	lea.l      pr_MsgPort(a4),a0       ; Process->MsgPort
	CALLEXEC   WaitPort                ; (MsgPort)(a0)
	lea.l      pr_MsgPort(a4),a0       ; Process->MsgPort
	CALLEXEC   GetMsg                  ; (MsgPort)(a0)
	lea.l      WBStartMsg(pc),a0       ; Msg
	move.l     d0,(a0)                 ; Msg

.openLibs
	LIBOPEN    DOS                     ; 
	LIBOPEN    Intuition               ; 

.getname
	bsr        GetTaskName             ; Name
	suba.l     a0,a0                   ; Window
	lea.l      MyEasyStruct(pc),a1     ; EasyStruct
	move.l     d0,es_TextFormat(a1)    ; Name
	suba.l     a2,a2                   ; pIDCMP
	suba.l     a3,a3                   ; Args
	CALLINT    EasyRequestArgs         ; (Window,EasyStruct,pIDCMP,Args)(a0,a1,a2,a3)

.closeLibs
	LIBCLOSE   Intuition               ; 
	LIBCLOSE   DOS                     ; 

.closeWB
	move.l     WBStartMsg(pc),d0       ; Msg
	beq.s      .exit                   ; Skip
	CALLEXEC   Forbid                  ; (void)
	move.l     WBStartMsg(pc),a1       ; Msg
	CALLEXEC   ReplyMsg                ; (Msg)(a1)

.exit
	moveq.l    #0,d0
	rts

;----------------------------------------------------------

GetTaskName:
	movem.l    d2/a6,-(sp)             ; Push
	suba.l     a1,a1                   ; Name
	CALLEXEC   FindTask                ; (Name)(a1)
	move.l     d0,a0                   ; Process
	move.l     LN_NAME(a0),d0          ; Process->Name
	move.l     pr_CLI(a0),d1           ; Process->CLI
	beq.s      .exit                   ; Skip
	lea.l      .buffer(pc),a0          ; Buffer
	move.l     a0,d1                   ; Buffer
	move.l     #256,d2                 ; Length
	CALLDOS    GetProgramName          ; (Buffer,Length)(d1,d2)
	lea.l      .buffer(pc),a0          ; Buffer
	move.l     a0,d0                   ; Result
.exit
	movem.l    (sp)+,d2/a6             ; Pop
	rts                                ; Return
.buffer:
	ds.b 256

;----------------------------------------------------------

_DOSBase:       ds.l 1
_IntuitionBase: ds.l 1
WBStartMsg:     ds.l 1

MyEasyStruct:
	dc.l es_SIZEOF  ; SizeOf
	dc.l 0          ; Flags
	dc.l StrTitle   ; *Title
	dc.l StrTitle   ; *TextFormat
	dc.l StrGadget  ; *GadgetFormat

StrTitle:       dc.b "TaskName",0
StrGadget:      dc.b "OK",0
DOSName:        dc.b "dos.library",0
IntuitionName:  dc.b "intuition.library",0

;----------------------------------------------------------
