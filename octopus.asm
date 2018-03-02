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

octopus EECS205BITMAP <50, 39, 255,, offset octopus + sizeof octopus>
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,024h,049h,049h,04eh,04eh,04eh,04eh,04eh,029h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,049h,06eh,06eh,072h,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 04eh,029h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,04eh,072h,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 06eh,06eh,06eh,06eh,04eh,025h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,04eh,072h,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,049h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,029h,072h,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,029h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,04eh,072h,06eh,06eh,06eh,072h
	BYTE 072h,072h,072h,072h,072h,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,024h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,025h,06eh,06eh,06eh,06eh
	BYTE 072h,072h,072h,072h,072h,072h,072h,072h,072h,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,029h,049h,072h,06eh
	BYTE 06eh,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,06eh,06eh,06eh,06eh
	BYTE 06eh,06eh,04eh,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,029h,049h
	BYTE 072h,06eh,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,029h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 029h,029h,06eh,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h
	BYTE 072h,072h,06eh,06eh,06eh,06eh,06eh,049h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,029h,029h,06eh,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h
	BYTE 072h,072h,072h,072h,06eh,06eh,06eh,06eh,06eh,049h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,025h,029h,04eh,072h,072h,072h,072h,072h,04eh,072h,072h,072h
	BYTE 072h,072h,072h,072h,072h,072h,072h,06eh,06eh,06eh,06eh,029h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,029h,049h,072h,072h,072h,072h,06eh,000h,06eh
	BYTE 072h,072h,072h,072h,072h,029h,04eh,072h,072h,06eh,06eh,06eh,06eh,024h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,029h,049h,06eh,072h,072h,072h,072h
	BYTE 049h,072h,072h,072h,072h,072h,072h,000h,029h,072h,072h,06eh,06eh,072h,04eh,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,004h,049h,04eh,072h,072h
	BYTE 072h,072h,072h,072h,072h,072h,072h,072h,072h,04dh,04eh,072h,072h,072h,06eh,072h
	BYTE 049h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,029h,049h
	BYTE 06eh,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,06eh
	BYTE 072h,06eh,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 024h,049h,04eh,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h
	BYTE 072h,06eh,072h,04eh,024h,004h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,049h,049h,072h,072h,072h,072h,072h,072h,072h,072h,072h,072h,04eh
	BYTE 072h,072h,072h,072h,06eh,029h,024h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,025h,049h,06eh,072h,072h,072h,04eh,06eh,072h,072h,06eh
	BYTE 049h,06eh,072h,072h,06eh,072h,04eh,024h,024h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,025h,049h,06eh,072h,072h,072h,06eh,049h,049h
	BYTE 049h,049h,06eh,072h,072h,072h,06eh,072h,049h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,025h,025h,049h,072h,06eh,072h,072h,072h
	BYTE 072h,06eh,06eh,072h,072h,072h,072h,06eh,072h,04eh,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 004h,004h,004h,000h,000h,000h,000h,000h,004h,025h,025h,049h,06eh,06eh,06eh,06eh
	BYTE 06eh,06eh,072h,072h,072h,072h,072h,072h,072h,06eh,072h,049h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 025h,025h,025h,025h,029h,029h,029h,025h,025h,025h,029h,029h,04eh,06eh,06eh,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,06eh,06eh,072h,072h,06eh,06eh,06eh,072h,049h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,004h,025h,025h,025h,000h,000h,000h,000h,000h,000h
	BYTE 000h,025h,025h,024h,049h,049h,049h,025h,024h,025h,025h,025h,049h,06eh,06eh,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 024h,024h,025h,025h,024h,025h,029h,029h,029h,029h,029h,025h,000h,000h,000h,000h
	BYTE 000h,000h,000h,024h,000h,049h,04eh,04eh,06eh,06eh,04eh,04eh,04eh,04eh,06eh,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 06eh,06eh,06eh,049h,029h,029h,029h,029h,029h,049h,04eh,04eh,04eh,04eh,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,049h,04eh,04eh,06eh,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,06eh,04eh,049h,04dh,04eh,04eh,04eh,04eh,029h,025h,024h
	BYTE 024h,029h,025h,029h,025h,000h,000h,000h,000h,000h,000h,024h,029h,049h,049h,04eh
	BYTE 04eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,06eh,06eh,04eh,049h,049h,049h,029h,024h,000h,000h,000h
	BYTE 000h,024h,025h,025h,025h,025h,004h,000h,000h,000h,025h,049h,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,04eh,04eh,04eh,04eh,04eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,04eh,06eh
	BYTE 06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,04eh,04eh,04eh,049h
	BYTE 049h,049h,04eh,04eh,04eh,04eh,04eh,04eh,049h,000h,000h,029h,04eh,04eh,049h,025h
	BYTE 024h,004h,024h,025h,025h,024h,000h,029h,04eh,06eh,06eh,06eh,06eh,06eh,06eh,029h
	BYTE 04dh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 06eh,06eh,06eh,04eh,04eh,04eh,04eh,04ah,04eh,04eh,04eh,024h,024h,025h,049h,004h
	BYTE 000h,000h,000h,000h,000h,000h,000h,025h,049h,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 049h,049h,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,04eh,049h
	BYTE 049h,049h,049h,049h,029h,025h,029h,024h,000h,024h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,024h,024h,000h,025h,029h,049h,04eh,04eh,06eh,04eh,04eh,06eh,06eh,06eh
	BYTE 06eh,04eh,000h,049h,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 06eh,04eh,049h,024h,000h,000h,000h,024h,029h,029h,029h,049h,025h,024h,000h,000h
	BYTE 000h,000h,000h,000h,000h,029h,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh
	BYTE 04eh,04eh,049h,000h,025h,024h,024h,049h,049h,04eh,06eh,06eh,06eh,06eh,06eh,06eh
	BYTE 04eh,04eh,06eh,06eh,06eh,06eh,04eh,04eh,049h,049h,029h,025h,024h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,049h,04eh,049h,025h,024h,024h,024h,024h,024h,024h
	BYTE 024h,024h,024h,024h,000h,000h,000h,025h,024h,000h,024h,024h,025h,029h,049h,04eh
	BYTE 04eh,06eh,06eh,04eh,049h,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,04eh,049h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,025h,024h,024h,025h,025h,025h,000h,024h
	BYTE 025h,025h,025h,029h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,004h,000h
	BYTE 000h,024h,025h,029h,04eh,06eh,049h,000h,000h,000h,004h,000h,000h,024h,025h,049h
	BYTE 04eh,049h,000h,000h,000h,000h,000h,000h,000h,000h,024h,029h,025h,004h,004h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,024h,024h,025h,024h,049h,06eh,049h,000h,024h,000h,000h,000h,025h
	BYTE 025h,025h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,024h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,029h,024h,029h,04eh,049h,025h,000h,000h
	BYTE 000h,000h,000h,004h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,029h,024h,025h,029h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,025h,025h
	BYTE 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h

.CODE

END
