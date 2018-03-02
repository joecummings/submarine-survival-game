; #########################################################################
;
;   game.asm - Assembly file for EECS205 Assignment 4/5
;    jrc1161, Joe Cummings
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
include game.inc

;; Has keycodes
include keys.inc

	
.DATA
;; declaring variables in memory to be used later in the program

  submarineX DWORD 150
  submarineY DWORD 150 
  submarineAddr DWORD offset submarine
  
  ; submarine1X DWORD 300
  ; submarine1Y DWORD 150
  ; submarine1Addr DWORD offset submarine

  torpedoX DWORD 150
  torpedoY DWORD 150
  torpedoAddr DWORD offset torpedo
  
  octopusX DWORD 300
  octopusY DWORD 350
  octopusAddr DWORD offset octopus
  
  ;; message to be displayed upon losing
  loseString BYTE "You lose!", 0
  
  ;; how much to rotate by
  rotation DWORD 0h
  
.CODE
	
;; Check if two bitmaps are colliding
CheckIntersect PROC STDCALL USES ebx esi ecx oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP

  LOCAL x_right:DWORD, x_left:DWORD, y_down:DWORD, y_up:DWORD, bit_right:PTR EECS205BITMAP, bit_left:PTR EECS205BITMAP, bit_up:PTR EECS205BITMAP, bit_down:PTR EECS205BITMAP
  
  mov eax, oneX
  mov ebx, twoX
  mov esi, oneBitmap
  mov ecx, twoBitmap
  cmp eax, ebx
  jl assign_otherX
  mov x_right, eax  ;; set onex to be the rightmost bitmap
  mov bit_right, esi
  mov x_left, ebx  ;; set twox to be the leftmost bitmap
  mov bit_left, ecx
  jmp continue
assign_otherX:
  mov x_right, ebx  ;; set twox to be the rightmost bitmap
  mov bit_right, ecx
  mov x_left, eax   ;; set onex to be the leftmost bitmap
  mov bit_left, esi

continue:
  mov eax, oneY
  mov ebx, twoY
  mov esi, oneBitmap
  mov ecx, twoBitmap
  cmp eax, ebx
  jl assign_otherY
  mov y_down, eax   ;; set oney to be above 
  mov bit_down, esi
  mov y_up, ebx   ;; set twoy to be below
  mov bit_up, ecx
  jmp continue_2
assign_otherY:
  mov y_down, ebx   ;; set twoy to be above
  mov bit_down, ecx
  mov y_up, eax   ;; set oney to be below
  mov bit_up, esi
  
continue_2:
  mov ebx, bit_right
  mov eax, (EECS205BITMAP PTR [ebx]).dwWidth
  shr eax, 1
  mov esi, x_right
  sub esi, eax    ;; (x_right - .5 * bit_right.width)
  mov ebx, bit_left
  mov eax, (EECS205BITMAP PTR [ebx]).dwWidth
  shr eax, 1
  mov ecx, x_left
  add ecx, eax    ;; (x_left + .5 * bit_left.width)
  cmp ecx, esi
  jnl maybe_boom_boom
  jmp no_boom_boom

maybe_boom_boom:
  mov ebx, bit_down
  mov eax, (EECS205BITMAP PTR [ebx]).dwHeight
  shr eax, 1
  mov esi, y_down
  sub esi, eax    ;; (y_down - .5 * bit_down.height)
  mov ebx, bit_up
  mov eax, (EECS205BITMAP PTR [ebx]).dwHeight
  shr eax, 1
  mov ecx, y_up
  add ecx, eax    ;; (y_up + .5 * bit_up.height)
  cmp ecx, esi
  jnl def_boom_boom

no_boom_boom:
  mov eax, 0
  jmp done    ;; they are not colliding so return 0

def_boom_boom:
  mov eax, 1  ;; they are colliding so return 1

done:
  ret
CheckIntersect ENDP

GameInit PROC
  ;; how will the screen look initially
  mov eax, offset submarine
  invoke BasicBlit, submarineAddr, submarineX, submarineY
  ; invoke BasicBlit, torpedoAddr, torpedoX, torpedoY
  ; invoke BasicBlit, submarine1Addr, submarine1X, submarine1Y
  invoke BasicBlit, octopusAddr, octopusX, octopusY
	
	ret         ;; Do not delete this line!!!
GameInit ENDP


GamePlay PROC USES ebx
  
;; have the octopus spinning endlessly
  add rotation, 00003000h

try_mouse_stuff:
  mov eax, MouseStatus.buttons  ;; detecting mouse input
  cmp eax, 0001h
  jne try_the_keys
  mov eax, MouseStatus.horiz
  mov octopusX, eax       ;; moving the octopus X based on mouse
  mov eax, MouseStatus.vert
  mov octopusY, eax   ;; moving the octopus Y based on mouse

try_the_keys:
  mov eax, KeyPress   ;; detecting key press
  cmp eax, 20h      ;; fire torpedo on space
  jne sub_sub
  add torpedoX, 6   ;; making the torpedo move quickly
  
;; submarine movement
sub_sub:
  cmp eax, 25h    ;; left arrow
  je go_left
  cmp eax, 27h    ;; right arrow
  je go_right
  cmp eax, 26h    ;; up arrow
  je go_up
  cmp eax, 28h    ;; down arrow
  je go_down
  jmp draw_that_ish

go_left:
  mov eax, 4
  sub submarineX, eax
  jmp draw_that_ish

go_right:
  mov eax, 4
  add submarineX, eax
  jmp draw_that_ish

go_down:
  mov eax, 4
  add submarineY, eax
  jmp draw_that_ish
  
go_up:
  mov eax, 4
  sub submarineY, eax
  jmp draw_that_ish
  
draw_that_ish:
  invoke BlackStarField   ;; clear screen
  invoke BasicBlit, submarineAddr, submarineX, submarineY   ;; new position and drawing of submarine
  ; invoke BasicBlit, torpedoAddr, torpedoX, torpedoY
  invoke RotateBlit, octopusAddr, octopusX, octopusY, rotation    ;; new position of spinning octopus
  ; invoke CheckIntersect, torpedoX, torpedoY, torpedoAddr, octopusX, octopusY, octopusAddr
  invoke CheckIntersect, submarineX, submarineY, submarineAddr, octopusX, octopusY, octopusAddr   ;; checking whether the two are colliding
  
  cmp eax, 0
  je done
  ;; oh snap it is colliding
  invoke BlackStarField     
  invoke DrawStr, offset loseString, 25, 25, 0ffh   ;; display losing message
  
done:
  ret         ;; Do not delete this line!!!
GamePlay ENDP

END