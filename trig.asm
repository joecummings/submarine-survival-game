; #########################################################################
;
;   trig.asm - Assembly file for EECS205 Assignment 3
;   Joe Cummings, JRC1161
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI
TWO_PI	= 411774                ;;  2 * PI
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)

	;; If you need to, you can place global variables here

.CODE

FixedSin PROC USES edx ebx esi angle:FXPT
    LOCAL flag:DWORD
    
    mov ebx, angle
    mov flag, 0

; basic beginning
Start:
    cmp ebx, 0
    jl Negative
    cmp ebx, PI_HALF
    jg Pos_Over_PI_HALF
    jmp Good_To_Go

; checks when neg
Negative:
    add ebx, TWO_PI
    jmp Start

; checks when over pi/2
Pos_Over_PI_HALF:
    cmp ebx, PI
    jg Pos_Over_PI
    mov eax, PI
    sub eax, ebx
    mov ebx, eax
    jmp Good_To_Go

; checks when over pi
Pos_Over_PI:
    cmp ebx, TWO_PI
    jg Pos_Over_TWO_PI
    sub ebx, PI
    mov flag, 1         ;; sets that it needs to be flipped
    jmp Start

;; checks when its over two pi
Pos_Over_TWO_PI:
    sub ebx, TWO_PI
    jmp Start

;; does the actual computation
Good_To_Go:
    mov eax, 0                  ; clear eax
    mov eax, PI_INC_RECIP       ; mov reciprical to eax
    mul ebx                    ; angle * recip
    add edx, edx
    mov eax, 0
    mov esi, OFFSET SINTAB
    mov ax, WORD PTR[esi + edx]     
    cmp flag, 0
    je Something_else
    neg eax

Something_else:
	ret			; Don't delete this line!!!
FixedSin ENDP

FixedCos PROC uses ebx angle:FXPT
    
    ;; uses trig rules to compute cosine
	mov ebx, angle        
    add ebx, PI_HALF
    INVOKE FixedSin, ebx
	
    ret			; Don't delete this line!!!
FixedCos ENDP
END
