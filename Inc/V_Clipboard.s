************************************************************
*	
*	CLIPBOARD FUNCTIONS
*	
************************************************************
*	
*	XDEF Clipboard_Write
*	
************************************************************

	CNOP 0,4

MyClipboardSIZE:  DS.L 1
MyClipboardIOCR:  DS.B iocr_SIZEOF
MyClipboardFORM:  DC.B 'FORM'
MyClipboardFTXT:  DC.B 'FTXT'
MyClipboardCHRS:  DC.B 'CHRS'
MyClipboardNAME:  DC.B 'clipboard.device',0

************************************************************

	CNOP 0,4

Clipboard_Write:
	movem.l    d2/a2/a3/a6,-(sp)               ; Push
	move.l     a0,a2                           ; String
	move.l     a0,a3                           ; String
.open
	lea.l      MyClipboardNAME(pc),a0          ; Name
	lea.l      MyClipboardIOCR(pc),a1          ; IOReq
	moveq.l    #0,d0                           ; Unit
	moveq.l    #0,d1                           ; Flags
	move.l     $4.w,a6                         ; ExecBase
	jsr        _LVOOpenDevice(a6)              ; (Name,Unit,IOReq,Flags)(a0,d0,a1,d1)
	tst.l      d0                              ; Error
	bne.s      .exit                           ; Skip
.slen
	tst.b      (a3)+                           ; StrLen(string)
	bne.s      .slen                           ; 
	suba.l     a2,a3                           ; 
	subq.l     #1,a3                           ; 
	move.l     a3,d2                           ; Length
.head
	lea.l      MyClipboardFORM(pc),a0          ; FORM
	bsr.s      .writeLong                      ; 
	lea.l      MyClipboardSIZE(pc),a0          ; FORM->length
	move.l     #(4+4+4),(a0)                   ; 
	add.l      d2,(a0)                         ; 
	bsr.s      .writeLong                      ; 
	lea.l      MyClipboardFTXT(pc),a0          ; FTXT
	bsr.s      .writeLong                      ; 
	lea.l      MyClipboardCHRS(pc),a0          ; CHRS
	bsr.s      .writeLong                      ; 
	lea.l      MyClipboardSIZE(pc),a0          ; CHRS->length
	move.l     d2,(a0)                         ; 
	bsr.s      .writeLong                      ; 
.body
	lea.l      MyClipboardIOCR(pc),a1          ; IOClipReq
	move.l     a2,io_Data(a1)                  ; IOClipReq->io_Data
	move.l     d2,io_Length(a1)                ; IOClipReq->io_Length
	move.w     #CMD_WRITE,io_Command(a1)       ; IOClipReq->io_Command
	jsr        _LVODoIO(a6)                    ; (IOReq)(a1)
.done
	lea.l      MyClipboardIOCR(pc),a1          ; IOClipReq
	move.w     #CMD_UPDATE,io_Command(a1)      ; IOClipReq->io_Command
	jsr        _LVODoIO(a6)                    ; (IOReq)(a1)
.free
	lea.l      MyClipboardIOCR(pc),a1          ; IOReq
	jsr        _LVOCloseDevice(a6)             ; (IOReq)(a1)
.exit
	movem.l    (sp)+,d2/a2/a3/a6               ; Pop
	rts                                        ; Return
.writeLong
	lea.l      MyClipboardIOCR(pc),a1          ; IOClipReq
	move.l     a0,io_Data(a1)                  ; IOClipReq->io_Data
	move.l     #4,io_Length(a1)                ; IOClipReq->io_Length
	move.w     #CMD_WRITE,io_Command(a1)       ; IOClipReq->io_Command
	jsr        _LVODoIO(a6)                    ; (IOReq)(a1)
	rts

************************************************************

