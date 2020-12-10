************************************************************

	INCDIR     progdir:include
	INCLUDE    exec/exec_lib.i
	INCLUDE    devices/clipboard.i

************************************************************

MAIN:
	lea.l      MyString(pc),a0                 ; string to write
	bsr        ClipWrite                       ; write to clipboard
	move.l     #0,d0                           ; rc
	rts                                        ; return

************************************************************

ClipWrite:
	movem.l    d2-d7/a2-a6,-(sp)               ; push
	move.l     a0,a2                           ; string
	move.l     a0,a3                           ; string
.open
	lea.l      .name(pc),a0                    ; name
	lea.l      .clip(pc),a1                    ; ioreq
	moveq.l    #0,d0                           ; unit
	moveq.l    #0,d1                           ; flags
	CALLEXEC   OpenDevice                      ; (name,unit,ioreq,flags)(a0,d0,a1,d1)
	tst.l      d0                              ; error
	bne.s      .exit                           ; skip
.size
	tst.b      (a3)+                           ; strlen(string)
	bne.s      .size                           ; 
	suba.l     a2,a3                           ; 
	subq.l     #1,a3                           ; 
	move.l     a3,d2                           ; length
.head
	lea.l      .form(pc),a0                    ; FORM
	bsr.s      .write                          ; 
	lea.l      .len1(pc),a0                    ; FORM->length
	add.l      d2,(a0)                         ; 
	bsr.s      .write                          ; 
	lea.l      .ftxt(pc),a0                    ; FTXT
	bsr.s      .write                          ; 
	lea.l      .chrs(pc),a0                    ; CHRS
	bsr.s      .write                          ; 
	lea.l      .len2(pc),a0                    ; CHRS->length
	move.l     d2,(a0)                         ; 
	bsr.s      .write                          ; 
.body
	lea.l      .clip(pc),a1                    ; IOClipReq
	move.l     a2,io_Data(a1)                  ; IOClipReq->io_Data
	move.l     d2,io_Length(a1)                ; IOClipReq->io_Length
	move.w     #CMD_WRITE,io_Command(a1)       ; IOClipReq->io_Command
	CALLEXEC   DoIO                            ; (ioreq)(a1)
.done
	lea.l      .clip(pc),a1                    ; IOClipReq
	move.w     #CMD_UPDATE,io_Command(a1)      ; IOClipReq->io_Command
	CALLEXEC   DoIO                            ; (ioreq)(a1)
.free
	lea.l      .clip(pc),a1                    ; ioreq
	CALLEXEC   CloseDevice                     ; (ioreq)(a1)
.exit
	movem.l    (sp)+,d2-d7/a2-a6               ; pop
	rts                                        ; return
.write
	lea.l      .clip(pc),a1                    ; IOClipReq
	move.l     a0,io_Data(a1)                  ; IOClipReq->io_Data
	move.l     #4,io_Length(a1)                ; IOClipReq->io_Length
	move.w     #CMD_WRITE,io_Command(a1)       ; IOClipReq->io_Command
	CALLEXEC   DoIO                            ; (ioreq)(a1)
	rts

.clip DS.B iocr_SIZEOF
.name DC.B 'clipboard.device',0
.form DC.B 'FORM'
.ftxt DC.B 'FTXT'
.chrs DC.B 'CHRS'
.len1 DC.L 12
.len2 DC.L 0

************************************************************

MyString:
	DC.B 'ABCDEFGHIJKLMNOP-Z..',0

************************************************************

	END
