
; Created By: Patrick Cossette
; 2013 Red Lamp Arts
;
; www.TheOubliette.net
; www.DigitalDiscrepancy.com
;
; License: The MIT License (MIT)
;
; PIC10F200 @ 4MHz
; PWM Fading LED code
;
; Generates PWM triangle wave
; Frequency is based on clock speed


list P = 10F200
include "P10F200.INC"

;Variable Declarations

time1 equ 10h
time2 equ 11h
flag  equ 12h
ledBrightness equ 13h

org 000h   ;Reset vector
goto Start
org 2

;Subroutines

Init
	__config _CP_ON & _WDTE_OFF & _OSC_IntRC

	movlw b'0000100'
	option

	movlw b'00000000'
	tris GPIO

	retlw 0

Start
	call Init
	clrf ledBrightness
	bsf flag, 1 ;start led at full brightness, fade out
	bcf GPIO, 2

Main
	movfw TMR0

	btfss STATUS, Z
	goto done
	goto inc

	inc
	incf TMR0
	bsf GPIO, 2

	btfss flag, 0
	goto drop
	goto rise

	rise ;Increase LED brightness
		incf ledBrightness
		btfss STATUS, Z
		goto done

		bcf flag,0
		goto done

	drop ;Decrease LED brightness
		decf ledBrightness
		btfss STATUS, Z
		goto done

		movlw .1
		movwf ledBrightness
		bsf flag,0
		goto done

	done
		movfw ledBrightness
		subwf TMR0, W
		btfss STATUS, Z ;ledBrightness == timer value
		goto Main
		bcf GPIO, 2

	goto Main

END