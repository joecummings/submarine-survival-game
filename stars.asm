; #########################################################################
;
;   stars.asm - Assembly file for EECS205 Assignment 1
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include stars.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc

	;; Place your code here

    DrawStar proto x:DWORD, y:DWORD
    
    INVOKE DrawStar, 032h, 032h
    INVOKE DrawStar, 032h, 064h
    INVOKE DrawStar, 032h, 096h
    INVOKE DrawStar, 032h, 0c8h 
    INVOKE DrawStar, 032h, 0fah 
    INVOKE DrawStar, 032h, 012ch 
    INVOKE DrawStar, 064h, 032h 
    INVOKE DrawStar, 096h, 032h 
    INVOKE DrawStar, 0c8h, 032h 
    INVOKE DrawStar, 0fah, 032h 
    INVOKE DrawStar, 012ch, 032h 
    INVOKE DrawStar, 064h, 064h 
    INVOKE DrawStar, 064h, 096h 
    INVOKE DrawStar, 064h, 0c8h 
    INVOKE DrawStar, 096h, 064h
    INVOKE DrawStar, 096h, 096h  
    

	ret  			; Careful! Don't remove this line
DrawStarField endp



END
