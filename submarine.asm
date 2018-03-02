; #########################################################################
;
;   submarine.asm - Assembly file for EECS205 Assignment 4/5
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc

include keys.inc

.DATA

; submarine EECS205BITMAP <50, 40, 0ffh,, offset submarine + sizeof submarine>
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,092h,092h,092h,092h,092h,092h,092h,092h
; 	BYTE 092h,092h,092h,092h,092h,092h,092h,092h,092h,092h,092h,092h,092h,0b6h,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h,000h
; 	BYTE 000h,000h,000h,000h,000h,000h,044h,08ch,068h,009h,000h,000h,000h,000h,000h,06dh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,000h,024h,000h
; 	BYTE 000h,000h,000h,000h,000h,000h,000h,08ch,0f8h,0f4h,08ch,049h,004h,000h,000h,024h
; 	BYTE 000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,000h
; 	BYTE 000h,000h,000h,000h,000h,000h,020h,000h,08ch,0f8h,0f8h,0d0h,08dh,052h,004h,000h
; 	BYTE 000h,000h,000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 049h,000h,000h,000h,000h,000h,000h,020h,000h,048h,0f4h,0f4h,088h,044h,024h,029h
; 	BYTE 000h,000h,000h,000h,000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,049h,000h,000h,000h,000h,000h,000h,020h,000h,0b0h,0f8h,088h,000h,000h
; 	BYTE 000h,000h,000h,000h,000h,000h,000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,049h,000h,000h,000h,000h,000h,000h,020h,000h,0d0h,0f4h,000h
; 	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,000h,000h,000h,000h,000h,020h,000h,000h,08ch
; 	BYTE 0b0h,068h,068h,068h,000h,000h,000h,000h,000h,000h,000h,092h,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,000h,000h,000h,000h,000h,000h,000h
; 	BYTE 068h,0b0h,0d0h,0f4h,0f4h,0f0h,08ch,000h,000h,000h,000h,000h,000h,092h,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,000h,000h,000h,000h,000h
; 	BYTE 044h,0ach,0d0h,0f4h,0f8h,0f8h,0f4h,0f4h,0d0h,044h,000h,000h,000h,000h,000h,092h
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,000h,020h,000h
; 	BYTE 000h,08ch,0d0h,0d5h,0b6h,0b5h,0f4h,0f4h,0f4h,0f4h,0f0h,068h,000h,000h,000h,000h
; 	BYTE 000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,000h
; 	BYTE 000h,000h,088h,0f4h,0f4h,091h,072h,0b6h,0f4h,0f4h,0f4h,0f4h,0f0h,068h,000h,000h
; 	BYTE 000h,000h,000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 049h,000h,000h,020h,0d0h,0f8h,0d4h,06dh,072h,0b6h,0f4h,0f4h,0f4h,0f4h,0f0h,068h
; 	BYTE 000h,000h,000h,000h,000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,049h,000h,000h,044h,0d0h,0f8h,0d4h,092h,072h,0b1h,0f4h,0f4h,0f4h,0f4h
; 	BYTE 0f0h,068h,000h,020h,000h,000h,000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0dbh,049h,000h,000h,068h,0f4h,0f8h,0f4h,0d5h,0d5h,0f4h,0f8h,0f4h
; 	BYTE 0f4h,0f4h,0d0h,020h,000h,000h,000h,000h,000h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,092h,024h,06dh,049h,069h,0b1h,0d5h,0d1h,08dh,049h,049h,049h,049h,049h
; 	BYTE 049h,049h,049h,049h,049h,049h,000h,000h,000h,088h,0f4h,0f8h,0f4h,0f4h,0d4h,0d0h
; 	BYTE 0d0h,0d0h,0b0h,0b0h,0ach,08ch,08ch,048h,048h,000h,000h,072h,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,092h,000h,000h,000h,0b0h,0f8h,0f8h,0f8h,0f4h,08ch,000h,000h
; 	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,088h,0d0h,0d0h,0d0h,0d0h
; 	BYTE 0d0h,0d4h,0f4h,0f4h,0f4h,0f4h,0f4h,0f8h,0d4h,0d0h,0d0h,0ach,0b0h,08dh,0b6h,0b6h
; 	BYTE 0b6h,0dbh,0ffh,0ffh,0ffh,0ffh,092h,000h,000h,068h,0f8h,0f8h,0f8h,0f8h,0f8h,0f4h
; 	BYTE 08ch,000h,024h,024h,024h,024h,024h,024h,024h,000h,000h,000h,044h,0ach,0d0h,0f4h
; 	BYTE 0f4h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0b0h,0f4h,0d0h,0f4h,0f8h,0f4h
; 	BYTE 0ach,000h,000h,092h,0ffh,0ffh,0ffh,0ffh,092h,000h,000h,068h,0f8h,0f8h,0f8h,0f8h
; 	BYTE 0f8h,0f8h,0d0h,000h,000h,020h,000h,000h,000h,000h,000h,044h,08ch,0d0h,0f4h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0d5h,0d5h,0f4h,0f8h,0d4h,0d0h,0d4h,0d0h,0f8h
; 	BYTE 0f8h,0f8h,0d4h,0ach,040h,092h,0ffh,0ffh,0ffh,0ffh,092h,049h,000h,068h,0f8h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0f8h,0f4h,068h,000h,020h,000h,000h,020h,020h,0ach,0f4h,0f8h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0f8h,0f4h,0f8h,0f8h,0f8h,0d5h,0bah,0dbh,0d5h,0f8h,0d0h,0f4h,0d0h
; 	BYTE 0d4h,0f8h,0f8h,0f4h,0d0h,0f4h,0ach,06eh,0ffh,0ffh,0ffh,092h,06dh,0b6h,049h,044h
; 	BYTE 0f4h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0ach,000h,000h,024h,068h,0ach,0ach,0f4h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0d5h,0dah,0d5h,0f8h,0f8h,0dah,096h,0b6h,0dah,0d4h,0d0h
; 	BYTE 0f4h,0b0h,0f4h,0f8h,0f8h,0d4h,0d0h,0f4h,08ch,044h,0dbh,0ffh,0ffh,049h,024h,0b6h
; 	BYTE 092h,020h,0d4h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0ach,024h,0b0h,0d4h,0ach,0ach,0d0h
; 	BYTE 0f8h,0f8h,0d5h,0d6h,0f5h,0f8h,0f9h,0b6h,0bbh,0b6h,0f5h,0f4h,0dah,096h,092h,0dah
; 	BYTE 0b1h,0d0h,0f4h,0d0h,0f8h,0f8h,0f8h,0d4h,0d4h,0f4h,0ach,088h,0dbh,0ffh,0ffh,049h
; 	BYTE 000h,092h,0b6h,049h,0d4h,0f8h,0f8h,0f8h,0f8h,0f8h,0d4h,0d4h,0f8h,0f8h,0d4h,0ach
; 	BYTE 0ach,0d4h,0f8h,0f4h,0b6h,0b6h,0d6h,0f4h,0f9h,0b6h,092h,0b6h,0f5h,0f4h,0dah,096h
; 	BYTE 097h,0dah,0b0h,0d4h,0f4h,0d0h,0f8h,0f8h,0f8h,0d4h,0d4h,0f4h,0ach,0ach,0dbh,0ffh
; 	BYTE 0ffh,0b6h,000h,049h,0b6h,06dh,08ch,0f8h,0d4h,0d4h,0d0h,08ch,0b0h,0f8h,0f8h,0f8h
; 	BYTE 0b0h,0ach,0ach,0f4h,0f8h,0f5h,0b6h,092h,0d6h,0f4h,0f9h,0b6h,092h,0bbh,0f5h,0d4h
; 	BYTE 0dah,096h,0bbh,0dah,0b0h,0d4h,0d4h,0d0h,0f8h,0f8h,0f8h,0f4h,0d0h,0f4h,0ach,088h
; 	BYTE 0dbh,0ffh,0ffh,0ffh,049h,000h,049h,06dh,08ch,08ch,088h,0ach,0ach,0d0h,0d0h,0ach
; 	BYTE 0b0h,0f4h,0b0h,0ach,0b0h,0f8h,0f8h,0d5h,0b6h,096h,0d6h,0f4h,0f9h,0b6h,097h,0dbh
; 	BYTE 0f5h,0f4h,0d6h,0b6h,0dbh,0d6h,0b0h,0d4h,0d4h,0d0h,0f8h,0f8h,0f8h,0f8h,0b0h,0f4h
; 	BYTE 0d4h,044h,0dbh,0ffh,0ffh,0dbh,068h,068h,08ch,0b0h,0d0h,0d0h,0d0h,0f0h,0f0h,0f0h
; 	BYTE 0d0h,0ach,088h,0d4h,0d0h,0ach,0d0h,0f8h,0f8h,0f4h,0b6h,0bbh,0d6h,0f8h,0f8h,0b6h
; 	BYTE 0dbh,0dah,0f4h,0f8h,0d4h,0dah,0dah,0f5h,0d4h,0d4h,0d4h,0d0h,0f8h,0f8h,0f8h,0f8h
; 	BYTE 0d4h,0d0h,0f4h,068h,0bbh,0ffh,0ffh,0b1h,0b0h,0d0h,0f0h,0f4h,0f4h,0f4h,0f4h,0f0h
; 	BYTE 0d0h,0d0h,0d0h,0d0h,0d4h,0f4h,0b0h,0ach,0d0h,0f8h,0f8h,0f8h,0f5h,0dah,0f5h,0f8h
; 	BYTE 0f8h,0f5h,0d6h,0f5h,0f8h,0f8h,0f8h,0f4h,0d4h,0f8h,0d4h,0d4h,0f4h,0d0h,0f8h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0d4h,0ach,040h,0dbh,0ffh,0ffh,06dh,0ach,0d0h,0f0h,0f0h,0f0h,0d0h
; 	BYTE 0d0h,0d0h,0d0h,0d4h,0f4h,0f8h,0f8h,0f4h,0ach,0ach,0d0h,0f8h,0f8h,0f8h,0f8h,0f4h
; 	BYTE 0f8h,0f8h,0f8h,0f8h,0f4h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0d4h,0d0h,0f4h,0d0h
; 	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,08ch,000h,0dbh,0ffh,0ffh,04dh,000h,068h,08dh,08ch
; 	BYTE 08ch,0b0h,0d4h,0f4h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0b0h,0ach,0d0h,0f8h,0f8h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f4h,0d0h
; 	BYTE 0f4h,0d0h,0f4h,0f8h,0f8h,0f8h,0f8h,0d4h,044h,000h,0dbh,0ffh,0ffh,06dh,000h,04dh
; 	BYTE 092h,04dh,08ch,0f4h,0d0h,0d0h,0d0h,0d4h,0f4h,0f4h,0f8h,0f8h,0b0h,0ach,0b0h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h
; 	BYTE 0f8h,0b0h,0f4h,0d0h,0d4h,0f8h,0f8h,0f8h,0d0h,020h,000h,000h,0dbh,0ffh,0ffh,06dh
; 	BYTE 000h,091h,0b6h,06dh,0d0h,0f8h,0f4h,0f4h,0d0h,0d0h,0d0h,0b0h,0b0h,0d0h,08ch,0a8h
; 	BYTE 0ach,0f4h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0d4h,0d4h,0f4h,0d0h,0f8h,0f4h,0b0h,06dh,04dh,06dh,06dh,0dbh,0ffh
; 	BYTE 0ffh,049h,000h,092h,092h,020h,0d4h,0f8h,0f8h,0f8h,0f8h,0f8h,0f4h,0d1h,092h,025h
; 	BYTE 000h,044h,044h,0b0h,0d4h,0f4h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0d0h,0f4h,0ach,0ach,044h,06eh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,049h,000h,092h,029h,044h,0f4h,0f8h,0f8h,0f8h,0f8h,0f8h,0f8h,0b1h
; 	BYTE 06dh,004h,000h,000h,004h,04dh,024h,044h,068h,08ch,0ach,0d0h,0d0h,0f4h,0f4h,0f4h
; 	BYTE 0f4h,0f4h,0f4h,0f4h,0f4h,0d0h,0d0h,0d0h,068h,040h,000h,000h,000h,06dh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,06dh,049h,06dh,000h,068h,0f4h,0f8h,0f8h,0f8h,0f8h,0f8h
; 	BYTE 0f4h,068h,000h,020h,000h,000h,000h,024h,000h,000h,06eh,06eh,06eh,092h,092h,0b2h
; 	BYTE 0b2h,0b2h,0b2h,0b6h,0b2h,0b2h,0b6h,0d6h,0b6h,092h,092h,072h,072h,092h,06dh,0b6h
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,06dh,049h,048h,000h,068h,0f8h,0f8h,0f8h,0f8h
; 	BYTE 0f8h,0f8h,0d0h,020h,000h,020h,000h,000h,000h,000h,000h,06dh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,06dh,000h,024h,000h,068h,0f8h,0f8h
; 	BYTE 0f8h,0f8h,0f8h,0f4h,08ch,000h,024h,000h,000h,000h,000h,024h,000h,06dh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,049h,000h,000h,000h,000h
; 	BYTE 0d0h,0f8h,0f8h,0f8h,0f4h,0ach,000h,000h,000h,000h,000h,000h,000h,000h,000h,06dh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,06dh,024h,049h
; 	BYTE 049h,049h,06dh,0b1h,0d5h,0d5h,08dh,049h,049h,049h,049h,049h,049h,049h,049h,049h
; 	BYTE 024h,092h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
; 	BYTE 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
submarine EECS205BITMAP <63, 41, 255,, offset submarine + sizeof submarine>
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,020h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,049h,069h,049h,049h,049h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,044h,08ch,06dh,049h,044h,048h,045h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,044h,0d0h,088h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,024h,049h,020h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,049h,025h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,049h,044h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 049h,004h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,020h,000h,000h,000h,000h,000h,000h,048h
	BYTE 044h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,064h,088h,0ach,0ach,0ach,0ach
	BYTE 0ach,088h,044h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,068h,0ach,0ach,0ach,0ach,0ach,08dh,069h,069h,069h
	BYTE 088h,088h,064h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,088h,0ach,0ach,0ach,08dh,069h,049h,029h,029h,029h,029h,04dh,06dh
	BYTE 06dh,069h,020h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,044h,08ch,069h,049h,029h,029h,049h,049h,049h,049h,049h,049h,06dh,08dh,092h
	BYTE 072h,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h
	BYTE 049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,092h,092h
	BYTE 049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,044h,049h
	BYTE 049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,049h,049h,049h
	BYTE 049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,024h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,049h,049h,049h,049h
	BYTE 06dh,06dh,06dh,069h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,024h,024h
	BYTE 020h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,068h,08ch,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,024h,049h,06dh,06dh,06dh,092h,092h,092h,092h,092h
	BYTE 092h,06dh,06dh,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h
	BYTE 08ch,088h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,020h,0f0h,0f5h,0d5h,08ch,000h,000h,000h,000h,044h,044h
	BYTE 024h,049h,06dh,06dh,092h,092h,092h,092h,092h,06dh,06dh,06dh,06dh,049h,049h,049h
	BYTE 049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,0d0h
	BYTE 0b1h,049h,044h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,068h,0f4h,0f4h,0f5h,0f5h,08ch,024h,049h,049h,0d0h,08dh,029h
	BYTE 08dh,092h,092h,06dh,04dh,049h,029h,049h,049h,049h,049h,049h,049h,029h,029h,029h
	BYTE 049h,049h,049h,049h,049h,049h,049h,029h,029h,049h,049h,049h,049h,06dh,0d0h,08dh
	BYTE 092h,091h,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,020h,000h,068h,0f4h,0d0h,0adh,08dh,091h,092h,072h,06dh,0d0h,06dh,049h,049h
	BYTE 049h,029h,049h,08ch,08dh,069h,029h,049h,049h,049h,049h,049h,08dh,08dh,06dh,049h
	BYTE 049h,049h,049h,049h,029h,069h,08dh,08dh,069h,049h,049h,029h,08dh,0d0h,049h,06dh
	BYTE 06dh,06dh,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,068h,020h
	BYTE 000h,000h,048h,08dh,06dh,072h,072h,06dh,06dh,049h,08dh,0d0h,049h,049h,049h,029h
	BYTE 069h,0d0h,0d0h,0d0h,0f0h,0adh,029h,049h,049h,049h,0d0h,0f0h,0d0h,0f0h,0d0h,049h
	BYTE 049h,049h,029h,08dh,0f0h,0d0h,0d0h,0f0h,08dh,029h,029h,0adh,0d0h,029h,049h,049h
	BYTE 049h,049h,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,044h,0d0h,044h,000h
	BYTE 044h,049h,049h,06dh,06dh,069h,049h,049h,029h,08dh,0d0h,049h,049h,049h,069h,0d0h
	BYTE 0b1h,04eh,04eh,08dh,0d0h,0ach,029h,049h,0d0h,0d1h,06dh,02eh,06eh,0d1h,0d0h,049h
	BYTE 029h,08ch,0d0h,0adh,04eh,04eh,0adh,0d0h,08dh,005h,0b0h,0b0h,029h,049h,049h,049h
	BYTE 049h,049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,0ach,044h,000h,049h
	BYTE 049h,029h,029h,005h,029h,029h,049h,029h,0adh,0d0h,029h,049h,029h,0ach,0d1h,00ah
	BYTE 00eh,00eh,00fh,0adh,0d0h,029h,08dh,0f0h,06dh,00ah,00eh,00fh,06eh,0f0h,06dh,005h
	BYTE 0d0h,0d1h,00ah,00eh,013h,00eh,0d1h,0d0h,005h,0d0h,0b1h,009h,049h,049h,049h,049h
	BYTE 049h,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,069h,044h,024h,049h,069h
	BYTE 08dh,0adh,0adh,0adh,0adh,069h,009h,0adh,0d0h,029h,049h,029h,0b0h,0adh,00ah,02eh
	BYTE 02ah,00ah,06dh,0d1h,049h,08dh,0d1h,00ah,02eh,02ah,00eh,02ah,0d1h,08dh,029h,0d0h
	BYTE 08dh,00ah,02eh,02eh,00ah,08dh,0d0h,029h,0ach,0ach,009h,049h,049h,049h,049h,049h
	BYTE 024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,049h,044h,044h,049h,069h,0d0h
	BYTE 0f0h,0d0h,0f0h,0d0h,08ch,005h,0ach,0b0h,029h,049h,005h,0d0h,0d1h,00ah,00ah,02ah
	BYTE 00ah,08dh,0f0h,025h,08ch,0f0h,00ah,00ah,02ah,00ah,049h,0f0h,08ch,005h,0d0h,0b1h
	BYTE 00ah,02ah,00ah,006h,0b1h,0d0h,005h,0ach,08ch,029h,049h,049h,049h,049h,049h,024h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,088h,040h,000h,049h,049h,048h,068h
	BYTE 068h,068h,049h,049h,029h,088h,0ach,029h,049h,029h,08ch,0d1h,08dh,00ah,00ah,049h
	BYTE 0d1h,0b0h,005h,049h,0d0h,0b1h,009h,00ah,009h,0b1h,0d0h,049h,005h,08ch,0d1h,06dh
	BYTE 00ah,00ah,06dh,0d1h,0ach,005h,0ach,08ch,029h,049h,049h,049h,049h,049h,024h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,020h,0ach,044h,000h,044h,049h,029h,029h,029h
	BYTE 029h,029h,049h,029h,088h,0ach,049h,049h,049h,005h,08ch,0f4h,0d1h,0b1h,0f0h,0b0h
	BYTE 025h,049h,029h,069h,0f0h,0d1h,0b1h,0f0h,0d0h,049h,029h,049h,025h,0ach,0f4h,0b1h
	BYTE 0d1h,0f0h,0ach,025h,029h,08ch,0ach,029h,049h,049h,049h,049h,049h,020h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,020h,088h,024h,000h,000h,044h,049h,029h,049h,049h
	BYTE 049h,049h,029h,068h,0ach,049h,049h,049h,049h,025h,08ch,0ach,0ach,08ch,049h,049h
	BYTE 049h,049h,029h,068h,0ach,0ach,0ach,069h,029h,049h,049h,049h,029h,08ch,0ach,0ach
	BYTE 08ch,029h,049h,029h,088h,0ach,029h,049h,049h,049h,049h,024h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,020h,000h,000h,000h,064h,0ach,068h,029h,029h,049h
	BYTE 049h,049h,049h,0ach,069h,029h,049h,049h,049h,029h,005h,005h,005h,049h,049h,049h
	BYTE 049h,049h,029h,005h,025h,005h,029h,049h,049h,049h,049h,049h,005h,025h,005h,005h
	BYTE 049h,049h,029h,068h,0ach,049h,049h,049h,049h,044h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,064h,0d0h,0cch,0ach,08ch,048h,049h
	BYTE 049h,049h,0ach,088h,029h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h
	BYTE 049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h
	BYTE 049h,029h,069h,0ach,069h,029h,049h,024h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,024h,0cch,0f0h,0d0h,0ach,044h,000h,024h
	BYTE 004h,088h,088h,029h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h
	BYTE 049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h
	BYTE 049h,049h,0ach,08ch,005h,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,088h,0ach,064h,000h,000h,000h,000h,000h
	BYTE 000h,020h,024h,024h,024h,044h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h
	BYTE 049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h
	BYTE 029h,068h,068h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,020h,024h,024h,024h,024h,044h,049h,049h,049h,049h
	BYTE 049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,049h,024h,024h,020h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,020h,020h,024h,024h
	BYTE 024h,024h,024h,024h,024h,024h,024h,024h,024h,024h,020h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h

	.CODE
	
	END