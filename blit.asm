; #########################################################################
;
;   blit.asm - Assembly file for EECS205 Assignment 3
;   Joe Cummings; jrc1161
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc


.DATA

	;; If you need to, you can place global variables here

.CODE

DrawPixel PROC uses ebx ecx x:DWORD, y:DWORD, color:DWORD

    mov ebx, x
    mov ecx, y

    cmp ebx, 640  ;; check if greater than 649
    jge get_outta_here          ;; don't draw
    cmp ebx, 0 ;; check if less than 0
    jl get_outta_here      ;; don't draw

    cmp ecx, 480 ;; check if greater than 479
    jge get_outta_here     ;; don't draw
    cmp ecx, 0      ;; check if less than 0
    jl get_outta_here      ;; don't draw

    xor eax, eax
    mov ecx, color
    mov eax, y
    imul eax, 640
    add eax, ebx
    mov ebx, ScreenBitsPtr
    mov BYTE PTR[ebx + eax], cl

get_outta_here:
	ret 			; Don't delete this line!!!
DrawPixel ENDP

BasicBlit PROC ptrBitmap:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD

    ;; using rotate blit but with no angle 
    INVOKE RotateBlit, ptrBitmap, xcenter, ycenter, 0

	ret 			; Don't delete this line!!!	
BasicBlit ENDP


RotateBlit PROC USES esi ecx ebx edi lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
    LOCAL cosa:FXPT, sina:FXPT, shiftx:FXPT, shifty:FXPT, dstWidth:DWORD, dstHeight:DWORD, dstX:FXPT,
            dstY:FXPT, srcX:FXPT, srcY:FXPT

    ;; cosine and sine of angle 
    INVOKE FixedCos, angle
    mov cosa, eax
    INVOKE FixedSin, angle
    mov sina, eax

    mov esi, lpBmp

    ;; computing shiftx
    mov eax, (EECS205BITMAP PTR [esi]).dwWidth
    mov ecx, cosa
    sar ecx, 1
    sal eax, 16  ;; shifts to account for fxpt
    imul ecx
    mov shiftx, edx
    mov eax, (EECS205BITMAP PTR [esi]).dwHeight
    mov ecx, sina
    sar ecx, 1
    sal eax, 16
    imul ecx
    sub shiftx, edx

    ;; computing shifty
    mov eax, (EECS205BITMAP PTR [esi]).dwHeight
    mov ecx, cosa
    sar ecx, 1
    sal eax, 16
    imul ecx
    mov shifty, edx
    mov eax, (EECS205BITMAP PTR [esi]).dwWidth
    mov ecx, sina
    sar ecx, 1
    sal eax, 16
    imul ecx
    add shifty, edx

    ;; dstWidth and dstHeight
    mov eax, (EECS205BITMAP PTR [esi]).dwWidth
    add eax, (EECS205BITMAP PTR [esi]).dwHeight
    mov dstWidth, eax
    mov dstHeight, eax

    mov ebx, dstWidth
    neg ebx
    mov dstX, ebx
    mov dstY, ebx

;; outer loop
x_check:
    mov edi, dstWidth
    cmp dstX, edi
    jge coo_coo_kachoo
    mov ebx, dstHeight
    neg ebx
    mov dstY, ebx

;; inner loop
y_check:
    mov edi, dstHeight
    cmp dstY, edi
    jge inkedx

    ;; computing srcX
    mov eax, dstX
	shl eax,16
    mov ecx, cosa
	imul ecx
	mov srcX, edx
	mov eax, dstY
    shl eax,16
	mov ecx, sina
	imul ecx
	add srcX, edx

    ;; computing srcY
    mov eax, dstY
    shl eax,16
	mov ecx, cosa
	imul ecx
	mov srcY, edx
	mov eax, dstX
    shl eax,16
	mov ecx, sina
	imul ecx
	sub srcY, edx	

    ;; now lots of checks to see if we can draw it or not
    cmp srcX, 0
    jl inkedy
    mov esi, lpBmp ;; necessary?
    mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
    cmp srcX, ebx
    jge inkedy

    cmp srcY, 0
    jl inkedy
    mov esi, lpBmp ;; necessary?
    mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
    cmp srcY, ebx
    jge inkedy

    mov eax, xcenter
    add eax, dstX
    sub eax, shiftx     ;; eax holds the value here
    cmp eax, 0
    jl inkedy
    cmp eax, 639
    jg inkedy

    mov ebx, ycenter
    add ebx, dstY
    sub ebx, shifty     ;; ebx holds the value here
    cmp ebx, 0
    jl inkedy
    cmp ebx, 479
    jg inkedy

    ;; Draw pixel bit
    mov edi, (EECS205BITMAP PTR [esi]).lpBytes
    xor ebx, ebx
    mov bl, (EECS205BITMAP PTR [esi]).bTransparent	
    mov eax, (EECS205BITMAP PTR [esi]).dwWidth
    imul srcY
    add eax, srcX
    xor ecx, ecx
    mov cl, BYTE PTR[edi + eax]
    cmp bl, cl      ;; should the pixel be there or nahh
    je inkedy

    mov eax, xcenter
    add eax, dstX
    sub eax, shiftx            
    mov ebx, ycenter
    add ebx, dstY
    sub ebx, shifty  
    INVOKE DrawPixel, eax, ebx, ecx

inkedy:
    inc dstY
    jmp y_check

inkedx:
    inc dstX
    jmp x_check

coo_coo_kachoo:
	ret 			; Don't delete this line!!!		
RotateBlit ENDP



END
