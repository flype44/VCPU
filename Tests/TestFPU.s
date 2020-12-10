
	machine mc68040
main:
	move.l  #(200*1000000),d0
.loop
	fmove.x fp0,fp1
	fmove.x fp1,fp0
	subq.l  #1,d0
	bne.s   .loop
	moveq.l #0,d0
	rts
