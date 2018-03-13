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

;  all these files access new files
include Z:\Users\joecummings\wine-masm\drive_c\masm32\include\windows.inc
include Z:\Users\joecummings\wine-masm\drive_c\masm32\include\masm32.inc
includelib Z:\Users\joecummings\wine-masm\drive_c\masm32\lib\masm32.lib
include Z:\Users\joecummings\wine-masm\drive_c\masm32\include\user32.inc
includelib Z:\Users\joecummings\wine-masm\drive_c\masm32\lib\user32.lib
include Z:\Users\joecummings\wine-masm\drive_c\masm32\include\winmm.inc
includelib Z:\Users\joecummings\wine-masm\drive_c\masm32\lib\winmm.lib


;; Has keycodes
include keys.inc


.DATA
;; declaring variables in memory to be used later in the program

  ;; submarine object variables
  submarineX DWORD 100
  submarineY DWORD 300
  submarineAddr DWORD offset submarine

  ;; torpedo object variables
  torpedoX DWORD 150
  torpedoY DWORD 150
  torpedoAddr DWORD offset torpedo

  ;; army of octopi object variables
  octopusX DWORD 700
  octopusY DWORD 245
  octopusAddr DWORD offset octopus
  octopus1X DWORD 800
  octopus1Y DWORD 245
  octopus1Addr DWORD offset octopus
  octopus2X DWORD 850
  octopus2Y DWORD 245
  octopus2Addr DWORD offset octopus
  octopus3X DWORD 900
  octopus3Y DWORD 245
  octopus3Addr DWORD offset octopus
  octopus4X DWORD 750
  octopus4Y DWORD 245
  octopus4Addr DWORD offset octopus
  big_octopusX DWORD 1500
  big_octopusY DWORD 245
  big_octopusAddr DWORD offset big_octopus

  ;; background bitmap object variables
  underwaterleftX DWORD 426
  underwaterleftY DWORD 240
  underwaterleftAddr DWORD offset underwaterleft
  underwaterrightX DWORD 1278
  underwaterrightY DWORD 240
  underwaterrightAddr DWORD offset underwater

  ;; game instructions
  moveString BYTE "Use W,A,S,D to move the submarine to avoid the octopi", 0
  spaceString BYTE "Press Spacebar to fire the torpedo and destoy the octopi", 0
  pString BYTE "Press P to pause at any time", 0
  infoString BYTE "Some octopi are worth more points than others -- but they are harder to kill", 0
  stayString BYTE "Try to stay alive for as long as possible and go for the high score!", 0
  enterString BYTE "Press Enter to continue", 0


  ;; losing messages
  loseString BYTE "You lose! Press R to restart the game", 0

  ;; pause instruction
  pauseString BYTE "Press U to resume the game at any time", 0

  ;; flags to mark game states
  pauseFlag DWORD 0
  loseFlag DWORD 0
  torpedosAwayFlag DWORD 0
  speedFlag DWORD 2
  counterFlag DWORD 0
  startedFlag DWORD 1
  oneHitFlag DWORD 0

  ;; octopus rotation variable
  rotation DWORD 0h

  ;; score and displaying score
  score DWORD 0
  score_str BYTE "Score: %d", 0
  score_out BYTE 32 DUP (0)

  ;; sounds for game
  sonarSound BYTE "sonar_x.wav", 0
  gameSound BYTE "Fast_Ace.wav", 0

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

;; this sets a constant scrolling for the background
BackgroundBitmap PROC USES ebx ecx

  ;; create the first bitmap on the screen
	invoke BasicBlit, underwaterleftAddr, underwaterleftX, underwaterleftY
	mov ebx, underwaterleftX
	sub ebx, speedFlag
	mov underwaterleftX, ebx

  ;; create the second bitmap off the screen
	invoke BasicBlit, underwaterrightAddr, underwaterrightX, underwaterrightY
	mov ebx, underwaterrightX
	sub ebx, speedFlag
	mov underwaterrightX, ebx

  ;; check if the first bitmap is off the screen
	cmp underwaterleftX, -426
	jnle next
  mov ebx, 1278
	mov underwaterleftX, ebx

next:
  ;; check if the second bitmap is off the screen
	cmp underwaterrightX, -426
	jnle away
	mov ecx, 1278
	mov underwaterrightX, ecx

away:

	ret
BackgroundBitmap ENDP

;; makes a variable into a string
toString PROC var:DWORD, format_str:DWORD, out_str:DWORD, x:DWORD, y:DWORD
  push var
  push format_str
  push out_str
  call wsprintf
  add esp, 12
  invoke DrawStr, out_str, x, y, 0ffh
  ret
toString ENDP

;; how will the screen look initially
GameInit PROC

  ;; reset all the flag variables
  mov score, 0
  mov counterFlag, 0
  mov speedFlag, 2
  mov pauseFlag, 0
  mov loseFlag, 0
  mov torpedosAwayFlag, 0
  mov eax, offset submarine

  ;; clear the screen and draw the first two bitmap
  invoke BackgroundBitmap
  invoke BasicBlit, submarineAddr, submarineX, submarineY
  invoke PlaySound, offset gameSound, 0, SND_FILENAME OR SND_ASYNC OR SND_LOOP

  ;; create random Y positions
  rdtsc
  invoke nseed, eax
  invoke nrandom, 450
  mov octopusY, eax
  invoke nrandom, 450
  mov octopus1Y, eax
  invoke nrandom, 450
  mov octopus2Y, eax
  invoke nrandom, 450
  mov octopus3Y, eax
  invoke nrandom, 450
  mov octopus4Y, eax
  invoke nrandom, 450
  mov big_octopusY, eax
  ;; draw all the sprites in the Y directions
  invoke BasicBlit, octopusAddr, octopusX, octopusY
  invoke BasicBlit, octopus1Addr, octopus1X, octopus1Y
  invoke BasicBlit, octopus2Addr, octopus2X, octopus2Y
  invoke BasicBlit, octopus3Addr, octopus3X, octopus3Y
  invoke BasicBlit, octopus4Addr, octopus4X, octopus4Y
  invoke BasicBlit, big_octopusAddr, big_octopusX, big_octopusY

  ;; score
  invoke toString, score, offset score_str, offset score_out, 10, 425
	ret         ;; Do not delete this line!!!
GameInit ENDP

GamePlay PROC USES ebx

  mov eax, 0
  cmp startedFlag, eax
  je body_stuff
starting_screen:
  ;; instructions on how to play the game
  invoke BlackStarField
  invoke DrawStr, offset moveString, 10, 100, 0ffh
  invoke DrawStr, offset spaceString, 10, 130, 0ffh
  invoke DrawStr, offset pString, 10, 160, 0ffh
  invoke DrawStr, offset stayString, 10, 220, 0ffh
  invoke DrawStr, offset infoString, 10, 190, 0ffh
  invoke DrawStr, offset enterString, 220, 350, 0ffh
  mov eax, KeyPress
  cmp eax, 0Dh
  jne done
  mov startedFlag, 0

;; checking the basic flags
body_stuff:
  mov eax, 1
  add counterFlag, eax
  mov ebx, 25
  cmp counterFlag, ebx
  jl outta
  add score, 1
  mov ebx, 0
  mov counterFlag, ebx

;; is it paused??
outta:
  mov eax, 0
  cmp pauseFlag, eax
  jne pause_play

  cmp loseFlag, eax
  jne lose

  cmp torpedosAwayFlag, eax
  jne damn_the_torpedos

;; fire the torpdo
try_the_keys:
  mov ebx, submarineX
  mov torpedoX, ebx
  mov ebx, submarineY
  mov torpedoY, ebx
  mov eax, KeyPress   ;; detecting key press
  cmp eax, 20h      ;; fire torpedo on space
  jne body
  mov torpedosAwayFlag, 1

;; the torpedo has been fired
damn_the_torpedos:
  add torpedoX, 10   ;; making the torpedo move quickly

body:
  ;; have the octopus spinning endlessly
  add rotation, 00003000h
  mov eax, speedFlag
  sub octopusX, eax
  sub octopus1X, eax
  sub octopus2X, eax
  sub octopus3X, eax
  sub octopus4X, eax
  sub big_octopusX, eax

pause_it:
  mov eax, KeyDown
  cmp eax, 50h
  jne sub_sub

;; keeps the game paused and unpauses if necessary
pause_play:
  mov pauseFlag, 1
  invoke BlackStarField
  invoke DrawStr, offset pauseString, 175, 225, 0ffh
  mov eax, KeyDown  ;; detecting mouse input
  cmp eax, 55h
  jne done
  mov pauseFlag, 0
  jmp done

;; submarine movement
sub_sub:
  mov eax, KeyPress   ;; detecting key press
  cmp eax, 41h    ;; A (go left)
  je go_left
  cmp eax, 44h    ;; D (go right)
  je go_right
  cmp eax, 57h    ;; W (go up)
  je go_up
  cmp eax, 53h    ;; S (go down)
  je go_down
  jmp draw_that_ish

go_left:
  mov eax, 6
  sub submarineX, eax
  jmp draw_that_ish

go_right:
  mov eax, 6
  add submarineX, eax
  jmp draw_that_ish

go_down:
  mov eax, 6
  add submarineY, eax
  jmp draw_that_ish

go_up:
  mov eax, 6
  sub submarineY, eax
  jmp draw_that_ish

draw_that_ish:
  invoke BlackStarField
  ; invoke BasicBlit, underwaterleftAddr, underwaterleftX, underwaterleftY   ;; clear screen
  invoke BackgroundBitmap
  invoke BasicBlit, torpedoAddr, torpedoX, torpedoY
  invoke BasicBlit, submarineAddr, submarineX, submarineY   ;; new position and drawing of submarine
  invoke RotateBlit, octopusAddr, octopusX, octopusY, rotation    ;; new position of spinning octopus
  invoke RotateBlit, octopus1Addr, octopus1X, octopus1Y, rotation
  invoke RotateBlit, octopus2Addr, octopus2X, octopus2Y, rotation
  invoke RotateBlit, octopus3Addr, octopus3X, octopus3Y, rotation
  invoke RotateBlit, octopus4Addr, octopus4X, octopus4Y, rotation
  invoke RotateBlit, big_octopusAddr, big_octopusX, big_octopusY, rotation
  INVOKE toString, score, OFFSET score_str, OFFSET score_out, 10, 425
  invoke CheckIntersect, torpedoX, torpedoY, torpedoAddr, octopusX, octopusY, octopusAddr
  cmp eax, 0
  je next1
  jmp octopus_go_boom
next1:
  invoke CheckIntersect, torpedoX, torpedoY, torpedoAddr, octopus4X, octopus4Y, octopus4Addr
  cmp eax, 0
  je next2
  jmp octopus4_go_boom
next2:
  invoke CheckIntersect, torpedoX, torpedoY, torpedoAddr, octopus1X, octopus1Y, octopus1Addr
  cmp eax, 0
  je next3
  jmp octopus1_go_boom
next3:
  invoke CheckIntersect, torpedoX, torpedoY, torpedoAddr, octopus2X, octopus2Y, octopus2Addr
  cmp eax, 0
  je next4
  jmp octopus2_go_boom
next4:
  invoke CheckIntersect, torpedoX, torpedoY, torpedoAddr, octopus3X, octopus3Y, octopus3Addr
  cmp eax, 0
  je next44
  jmp octopus3_go_boom
next44:
  invoke CheckIntersect, torpedoX, torpedoY, torpedoAddr, big_octopusX, big_octopusY, big_octopusAddr
  cmp eax, 0
  je submarine_intersect
  jmp big_go_boom

octopus_go_boom:
  ; add speedFlag, 2
  mov eax, 10
  add score, eax
  invoke nrandom, 450
  mov octopusY, eax
  mov eax, 700
  mov octopusX, 700
  jmp reset_torpedo

octopus1_go_boom:
  ; add speedFlag, 2
  mov eax, 10
  add score, eax
  invoke nrandom, 450
  mov octopus1Y, eax
  mov eax, 700
  mov octopus1X, 700
  jmp reset_torpedo

octopus2_go_boom:
  add speedFlag, 2
  mov eax, 10
  add score, eax
  invoke nrandom, 450
  mov octopus2Y, eax
  mov eax, 700
  mov octopus2X, 700
  jmp reset_torpedo

octopus3_go_boom:
  ; inc speedFlag
  mov eax, 10
  add score, eax
  invoke nrandom, 450
  mov octopus3Y, eax
  mov eax, 700
  mov octopus3X, 700
  jmp reset_torpedo

octopus4_go_boom:
  add speedFlag, 2
  mov eax, 10
  add score, eax
  invoke nrandom, 450
  mov octopus4Y, eax
  mov eax, 700
  mov octopus4X, 700
  jmp reset_torpedo

big_go_boom:
  inc oneHitFlag
  cmp oneHitFlag, 1
  je reset_torpedo
  mov eax, 30
  mov oneHitFlag, 0
  add score, eax
  invoke nrandom, 450
  mov big_octopusY, eax
  mov eax, 2500
  mov big_octopusX, eax
  jmp reset_torpedo

reset_torpedo:
  mov ebx, submarineX
  mov torpedoX, ebx
  mov ebx, submarineY
  mov torpedoY, ebx
  mov torpedosAwayFlag, 0

submarine_intersect:

;; all of these checks are if the octopi are off the screen
check_if_octopus_gone:
  mov ebx, octopusX
  cmp ebx, 0
  jge oct1_gone
  mov octopusX, 850
  invoke nrandom, 450
  mov octopusY, eax
oct1_gone:
  mov ebx, octopus1X
  cmp ebx, 0
  jge oct2_gone
  mov octopus1X, 850
  invoke nrandom, 450
  mov octopus1Y, eax
oct2_gone:
  mov ebx, octopus2X
  cmp ebx, 0
  jge oct3_gone
  mov octopus2X, 850
  invoke nrandom, 450
  mov octopus2Y, eax
oct3_gone:
  mov ebx, octopus3X
  cmp ebx, 0
  jge oct4_gone
  mov octopus3X, 850
  invoke nrandom, 450
  mov octopus3Y, eax
oct4_gone:
  mov ebx, octopus4X
  cmp ebx, 0
  jge big_gone
  mov octopus4X, 850
  invoke nrandom, 450
  mov octopus4Y, eax
big_gone:
  mov ebx, big_octopusX
  cmp ebx, 0
  jge check_if_torpedo_gone
  mov big_octopusX, 2500
  invoke nrandom, 450
  mov big_octopusY, eax

;; check if the torpedo went off the screen
check_if_torpedo_gone:
  mov ebx, torpedoX
  cmp ebx, 650
  jge reset_torpedo

  invoke CheckIntersect, submarineX, submarineY, submarineAddr, octopusX, octopusY, octopusAddr   ;; checking whether the two are colliding
  cmp eax, 0
  je next5
  mov loseFlag, 1
  jmp lose
next5:
  invoke CheckIntersect, submarineX, submarineY, submarineAddr, octopus1X, octopus1Y, octopus1Addr   ;; checking whether the two are colliding
  cmp eax, 0
  je next6
  mov loseFlag, 1
  jmp lose
next6:
  invoke CheckIntersect, submarineX, submarineY, submarineAddr, octopus2X, octopus2Y, octopus2Addr   ;; checking whether the two are colliding
  cmp eax, 0
  je next7
  mov loseFlag, 1
  jmp lose
next7:
  invoke CheckIntersect, submarineX, submarineY, submarineAddr, octopus3X, octopus3Y, octopus3Addr   ;; checking whether the two are colliding
  cmp eax, 0
  je next8
  mov loseFlag, 1
  jmp lose
next8:
  invoke CheckIntersect, submarineX, submarineY, submarineAddr, octopus4X, octopus4Y, octopus4Addr   ;; checking whether the two are colliding
  cmp eax, 0
  je next9
  mov loseFlag, 1
next9:
  invoke CheckIntersect, submarineX, submarineY, submarineAddr, big_octopusX, big_octopusY, big_octopusAddr
  cmp eax, 0
  je done
  mov loseFlag, 1

lose:
  ;; you lost!!!
  invoke BlackStarField       ;; oh snap it is colliding
  invoke DrawStr, offset loseString, 175, 190, 0ffh   ;; display losing message
  invoke toString, score, offset score_str, offset score_out, 275, 250 ;; display score
  add octopusX, 1   ;; stop the octopus movement
  mov counterFlag, 0
  mov eax, KeyPress
  cmp eax, 52h
  je restart
  jmp done

;; restart the game
restart:
  mov octopusX, 700     ;; reset octopus
  mov octopus1X, 800
  mov octopus2X, 850
  mov octopus3X, 900
  mov octopus4X, 1000
  mov big_octopusX, 2500
  mov submarineX, 100   ;; reset submarine
  mov submarineY, 300
  invoke GameInit

done:
  ret         ;; Do not delete this line!!!
GamePlay ENDP

END
