;Program compiled by Great Cow BASIC (0.98.06 2019-06-12 (Windows 32 bit))
;Need help? See the GCBASIC forums at http://sourceforge.net/projects/gcbasic/forums,
;check the documentation or email w_cholmondeley at users dot sourceforge dot net.

;********************************************************************************

;Set up the assembler options (Chip type, clock source, other bits and pieces)
 LIST p=18F13K22, r=DEC
#include <P18F13K22.inc>
 CONFIG WRTD = OFF, LVP = OFF, MCLRE = OFF, WDTEN = OFF, PLLEN = OFF, FOSC = IRC

;********************************************************************************

;Vectors
	ORG	0
	goto	BASPROGRAMSTART
	ORG	8
	retfie

;********************************************************************************

;Start of program memory page 0
	ORG	12
BASPROGRAMSTART
;Call initialisation routines
	rcall	INITSYS

;Start of the main program
;''A demonstration program for GCGB and GCB.
;''--------------------------------------------------------------------------------------------------------------------------------
;''This program
;''
;''
;''@author
;''@licence	GPL
;''@version
;''@date   	01.11.2015
;''********************************************************************************
;----- Configuration
;#include '[todo]
;----- Constants
;#define DeviceAddressRead 10100001
;#define DeviceAddresswrite 10100000
;----- Define Hardware settings
;[todo]
;----- Variables
;Dim EEpromAddress as Word
;Dim EEpromData as Byte
;----- Quick Command Reference:
;[todo]
;----- Main body of program commences here.
;end
	bra	BASPROGRAMEND
;----- Support methods.  Subroutines and Functions
BASPROGRAMEND
	sleep
	bra	BASPROGRAMEND

;********************************************************************************

INITSYS
;The section now handles two true tables for frequency
;Supports 16f and 18f (type1 max frq of 8mhz) classes and 18f (type2 max frq of 16mhz) classes
;Assumes that testing the ChipMaxMHz >= 48 is a valid test for type2 microcontrollers
;Supports IntOsc MaxMhz of 64 and not 64 ... there may be others true tables that GCB needs to support in the future
;asm showdebug OSCCON type is 104' NoBit(SPLLEN) And NoBit(IRCF3) Or Bit(INTSRC)) and ifdef Bit(HFIOFS)
;osccon type is 104
;OSCCON = OSCCON AND b'10001111'
	movlw	143
	andwf	OSCCON,F,ACCESS
;Address the two true tables for IRCF
;[canskip] IRCF2, IRCF1, IRCF0 = b'101'    ;101 = 4 MHz
	bsf	OSCCON,IRCF2,ACCESS
	bcf	OSCCON,IRCF1,ACCESS
	bsf	OSCCON,IRCF0,ACCESS
;Clear BSR on ChipFamily16 MCUs
;BSR = 0
	clrf	BSR,ACCESS
;Clear TBLPTRU on MCUs with this bit as this must be zero
;TBLPTRU = 0
	clrf	TBLPTRU,ACCESS
;Ensure all ports are set for digital I/O and, turn off A/D
;SET ADFM OFF
	bcf	ADCON2,ADFM,ACCESS
;Switch off A/D Var(ADCON0)
;SET ADCON0.ADON OFF
	bcf	ADCON0,ADON,ACCESS
;Commence clearing any ANSEL variants in the part
;ANSEL = 0
	clrf	ANSEL,ACCESS
;ANSELH = 0
	clrf	ANSELH,ACCESS
;End clearing any ANSEL variants in the part
;Set comparator register bits for many MCUs with register CM2CON0
;C2ON = 0
	bcf	CM2CON0,C2ON,ACCESS
;C1ON = 0
	bcf	CM1CON0,C1ON,ACCESS
;Turn off all ports
;PORTA = 0
	clrf	PORTA,ACCESS
;PORTB = 0
	clrf	PORTB,ACCESS
;PORTC = 0
	clrf	PORTC,ACCESS
	return

;********************************************************************************


 END
