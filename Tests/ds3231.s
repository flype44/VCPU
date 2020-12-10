************************************************************

	INCDIR     progdir:include
	INCLUDE    exec/exec_lib.i
	INCLUDE    inc/i2csensors.i
	INCLUDE    inc/i2csensors_lib.i

************************************************************

MAIN:
	rts

I2CSensorsName:
	DC.B 'i2csensors.library',0

************************************************************

DeviceName: DC.B 'DS3231',0
SensorName: DC.B 'Temperature',0

************************************************************

	END
