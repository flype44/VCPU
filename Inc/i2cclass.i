;******************************************************************************************
;*
;* $id: i2cclass.i $
;*
;* proposal for I2C class system
;*
;*
;* author: (C) 2018 Henryk Richter
;*
;******************************************************************************************
	ifnd	_INC_I2CCLASS_I
_INC_I2CCLASS_I	EQU	1

	IFND UTILITY_TAGITEM_I
	include	"utility/tagitem.i"
	ENDC

;open stuff 
;   - devices that fall into several classes like RTC with Temp Sensor
;   -> Q: Do we provide a generic interface for specific functions
;         like "get all temps" instead of concentrating on devices
;	 to be polled?
;   - I2C addresses apply to different devices.
;   -> Q: is it better to "guess" the chip type or rather offer
;         the user a choice of possible chips and save the result
;	 in a set of ENV Variables?


;/* ------------------------------------------------------------------------ */
;/* I2C Device capabilies                                                    */
I2C_BASE 	EQU	TAG_USER+$012c0000

I2C_CUSTOM   	EQU	(I2C_BASE+$00) ;/* unspecified chip */
I2C_RDID     	EQU	(I2C_BASE+$01) ;/* read ID, i.e. chip supports read    */
I2C_WRID     	EQU	(I2C_BASE+$02) ;/* write ID, i.e. chip supports write  */
I2C_DEVENTRY 	EQU	(I2C_BASE+$02) ;/* this points to a taglist            */

;/* sensors */
I2C_VOLTAGE	EQU	(I2C_BASE+$10)
I2C_CURRENT	EQU	(I2C_BASE+$11)
I2C_TEMP	EQU	(I2C_BASE+$12)
I2C_FAN		EQU	(I2C_BASE+$13)
I2C_PRESSURE	EQU	(I2C_BASE+$14)
I2C_RTC		EQU	(I2C_BASE+$15)
I2C_POWER	EQU	(I2C_BASE+$16)
I2C_HUMIDITY	EQU	(I2C_BASE+$17)


;/* ------------------------------------------------------------------------ */

;/* vendors in here */
I2C_VIDBASE	EQU	(I2C_BASE+$100)
I2C_VID_UNKNOWN EQU	(I2C_VIDBASE+0)
I2C_VID_PHILIPS EQU	(I2C_VIDBASE+1)
I2C_VID_DALLAS  EQU	(I2C_VIDBASE+2)
I2C_VID_RICOH   EQU	(I2C_VIDBASE+3)
I2C_VID_BOSCH   EQU	(I2C_VIDBASE+4)

;/* ------------------------------------------------------------------------ */
;/* error codes                                                              */
;/* ------------------------------------------------------------------------ */
I2C_OK           EQU  1
I2C_ERR_NOTFOUND EQU -1 ;/* chip does not respond */
I2C_ERR_BADID    EQU -2 ;/* chip ID unknown */
I2C_ERR_BADARG   EQU -3 ;/* */


;/* ------------------------------------------------------------------------ */
	endc	;_INC_I2CCLASS_I
