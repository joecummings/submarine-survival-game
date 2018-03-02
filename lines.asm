; #########################################################################
;
;   lines.asm - Assembly file for EECS205 Assignment 2
;   Joe Cummings: jrc1161
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA

	;; If you need to, you can place global variables here

.CODE


DrawLine PROC USES eax ebx ecx esi x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD

	LOCAL delta_x:DWORD, delta_y:DWORD, inc_x:DWORD, inc_y:DWORD, error:DWORD, curr_x:DWORD, curr_y:DWORD, prev_error:DWORD


    mov eax, x1 ;; delta_x comparison
    cmp eax, x0
    jl FLIP_X
    sub eax, x0
    mov delta_x, eax
    jmp RESUME  ;; skip over the flipping part
FLIP_X:
    mov ebx, x0
    sub ebx, x1
    mov delta_x, ebx ;; move delta_x into local variable


RESUME:
    mov eax, y1 ;; delta_y comparison
    cmp eax, y0
    jl FLIP_Y
    sub eax, y0
    mov delta_y, eax
    jmp RESUME_2 ;; skip over flipping part
FLIP_Y:
    mov ebx, y0
    sub ebx, y1
    mov delta_y, ebx ;; move delta_y into a local variable


RESUME_2:
    mov eax, x0
    cmp eax, x1 ;; is (x0 < x1)?
    jge ELSE_X  ;; it isn't so skip over to else statement
    mov inc_x, 1
    jmp RESUME_3 ;; skip over else statement
ELSE_X:
    mov inc_x, -1


RESUME_3:
    mov eax, y0
    cmp eax, y1 ;; is (y0 < y1)?
    jge ELSE_Y ;; it isn't so skip over to else statement
    mov inc_y, 1
    jmp RESUME_4 ;; skip over else statement
ELSE_Y:
    mov inc_y, -1

RESUME_4:
    mov eax, delta_x
    cmp eax, delta_y
    mov ebx, 2  ;; this will be the divisor
    jle ELSE_DELTA
    idiv ebx ;; delta_x/2
    mov error, eax  ;; store eax value (result) in error
    jmp RESUME_5
ELSE_DELTA:
    mov eax, delta_y
    idiv ebx ;; delta_y/2
    neg eax ;; - result
    mov error, eax ; store eax value (result) in error


RESUME_5:
    mov eax, x0
    mov curr_x, eax ;; curr_x = x0
    mov eax, y0
    mov curr_y, eax ;; curr_y = y0
    invoke DrawPixel, curr_x, curr_y, color  ;; calling DrawPixel function
    jmp WHILE_CHECK
LOOPSTER:
    invoke DrawPixel, curr_x, curr_y, color  ;; calling DrawPixel function
    mov eax, error
    mov prev_error, eax ;; prev_error = error
    mov ecx, delta_x
    neg ecx    ;; negate ecx
    cmp prev_error, ecx ;; is (prev_error < - delta_x)?
    jle REST_LOOP ;; skip over the first if statement
    mov eax, error
    sub eax, delta_y
    mov error, eax
    mov eax, curr_x
    add eax, inc_x
    mov curr_x, eax
REST_LOOP:
    mov ecx, delta_y
    cmp prev_error, ecx ;; is (prev_error < delta_y)?
    jge WHILE_CHECK ;; skip over last if statement
    mov eax, error
    add eax, delta_x
    mov error, eax
    mov eax, curr_y
    add eax, inc_y
    mov curr_y, eax
WHILE_CHECK:         ;; evaluation function
    mov eax, curr_x
    cmp eax, x1
    jne LOOPSTER ;; short-circuit or loop into while loop
    mov eax, curr_y
    cmp eax, y1
    jne LOOPSTER ;; jump into while loop

	ret        	;;  GETTTTT OUTTTA HEEERE
DrawLine ENDP




END
