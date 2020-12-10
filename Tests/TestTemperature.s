
	INCDIR     progdir:include

************************************************************

main:
	bsr        V_TemperatureInit
*	tst.l      d0
*	beq.s      .exit
	bsr        V_TemperatureFind
*	tst.l      d0
*	beq.s      .free
	bsr        V_TemperatureRead

	lea.l      Buffer(pc),a0
	bsr        V_TemperatureToString
	lea.l      Buffer(pc),a0
*	bkpt       #1
*.free
	bsr        V_TemperatureFree
.exit
	moveq.l    #0,d0
	rts

Buffer: DS.B 1024

************************************************************

	include    Inc/V_SENSORS.s

************************************************************

	END
