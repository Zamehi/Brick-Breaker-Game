.286  
;.386
include struct.asm

.model small
.stack 0200h

.data
urow db 5,5,5,5,5,5,8,8,8,8,8,8,11,11,11,11,11,11,14,14,14,14,14,14
lcol db	8,20,32,44,56,68,8,20,32,44,56,68,8,20,32,44,56,68,8,20,32,44,56,68
brow db 6,6,6,6,6,6,9,9,9,9,9,9,12,12,12,12,12,12,15,15,15,15,15,15
rcol db 18,30,42,54,66,73,18,30,42,54,66,73,18,30,42,54,66,73,18,30,42,54,66,73 
color db 2,3, 4,14 ,2,3, 4,14,2,3, 4,14,2,3, 4,14,2,3,4,14,2,3,4,14; green, red , yellow
backup_color_level db 0

times_hit db 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
level db 3
next_level db 1
var1 dw 0
var2 dw 0
backup_rodleft db 0
backup_rodright db 0
num dw 0
count db 0
temp dw 0
score dw 0
gameoverbool db 1
gameresumebool db 0
delayCount dw 400
delayCount2 dw 400

boolvertical db 0
boolhorizontal1 db 0
boolhorizontal2 db 0
boolDead db 0


rodleft db 35
rodright db 60

; variables for ball 
  up db 20
  down db 20
  left db 10
  right db 11
  
  ; Back ups of the cordinates of the ball
  b_up db 20
  b_down db 20
  b_left db 10
  b_right db 11
  

score_arr db 2 dup('0')
  address dw ?
  p1 page1 <>
  p2 page2 <>
  p3 page3 <>
  rp3 reset_page3 <>
  lvl2 level2 <>
  lvl3 level3 <>
  p5 page5 <>
  hih high1score <>
  


; ****************************************************************************************************
.code


jmp main1


;[][][][[][][][][][][][][][][][][][][[][]]]
		        ;////////////////////Beep sound proc\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

				beep proc
        push ax
        push bx
        push cx
        push dx
        mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 600        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 1          ; Pause for duration of note.
pause1:
        mov     cx, 65535
pause2:
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.

        pop dx
        pop cx
        pop bx
        pop ax

ret
beep endp




; ********************************** Reset GamePage to new Page **********************************
reset_game_page proc
   mov bh, rp3.level
   mov p3.level, bl
   mov bl, rp3.bricks
   mov p3.bricks, bl
   mov bl, rp3.lcol
   mov p3.lcol, bl
   mov bl, rp3.rcol
   mov p3.rcol, bl
   mov bl, rp3.score_col
   mov p3.score_col, bl
   mov bl, rp3.drow
   mov p3.drow, bl
   mov bl, rp3.urow
   mov p3.urow, bl
   mov bx, rp3.backup
   mov p3.backup, bx
   mov bl, rp3.upboundcol
   mov p3.upboundcol, bl
   mov bl, rp3.heartcol
   mov p3.heartcol, bl
   ;******)()()()()()(********
   mov bx, rp3.var1
   mov var1, bx
   mov bx , rp3.var2
   mov var2, bx
   mov bl,rp3.backup_rodleft
   mov backup_rodleft, bl
   mov bl, rp3.backup_rodright
   mov backup_rodright, bl
   mov bx , rp3.num
   mov num, bx
   mov bl, rp3.count 
   mov count , bl
   
   mov bx, rp3.temp
   mov temp, bx
   mov bx, rp3.scored 
   mov score , bx
   mov bx, rp3.delayCount
   mov delayCount, bx
   mov bl, rp3.boolhorizontal1
   mov boolhorizontal1, bl
    mov bl, rp3.boolhorizontal2
   mov boolhorizontal2, bl
   mov bl, rp3.boolvertical
   mov boolvertical, bl
   mov bl, rp3. boolDead
   mov boolDead, bl
   mov bl, rp3.rodleft
   mov rodleft, bl
   mov bl, rp3.rodright
   mov rodright, bl
   mov bl, rp3.up
   mov up, bl
   mov bl, rp3.down
   mov down, bl
   mov bl, rp3.right
   mov right , bl
   mov bl, rp3.left
   mov left , bl
  ; mov al, 0
  ; mov p3.color_level, al

   ;)()()()()()()()(
    ; Resetting values of arrays
   mov cx ,24
   mov si, 0
   reset_arr:
      mov bl, lvl2.urow [si]
	  mov urow[si], bl
	  mov bl, lvl2.lcol [si]
	  mov lcol[si], bl
	  mov bl, lvl2.brow [si]
	  mov brow[si], bl
	  mov bl, lvl2.rcol [si]
	  mov rcol[si], bl
	  
	  mov bl, lvl2.color [si]
	  mov color[si], bl
	
	    .if (level == 2)
	         mov bl, lvl2.times_hit [si]
	         mov times_hit[si], bl
		.endif	 
        .if (level == 3)
	       
			mov bl, lvl3.times_hit [si]
	        mov times_hit[si], bl
        .endif
   loop reset_arr   
   
   .if (level == 2)
	        mov bl, lvl2.rodleft
			mov rodleft, bl
			mov bl, lvl2.rodright
			mov rodright, bl
			mov bx, lvl2.delaycount
			mov delayCount2, bx
			
      .elseif (level == 3)
	        mov bl, lvl3.rodleft
			mov rodleft, bl
			mov bl, lvl3.rodright
			mov rodright, bl
			mov bx, lvl3.delaycount
			mov delayCount2, bx

       .endif

 
   
   ret
reset_game_page endp
;*************************************

; ************************** Game Page ********************************

; **************************   ROD   ************************************

rod proc

; First printing in black then in 
mov ah, 6
mov al, 0
mov bh, 0     ;color
mov ch, 28     ;top row of window
mov cl, backup_rodleft    ;left most column of window
mov dh, 28   ;Bottom row of window
mov dl, backup_rodright     ;Right most column of window

int 10h



mov ah, 6
mov al, 0
mov bh, 14     ;color
mov ch, 28     ;top row of window
mov cl, rodleft    ;left most column of window
mov dh, 28    ;Bottom row of window
mov dl, rodright     ;Right most column of window

int 10h
ret
rod endp

movup proc		

mov ah, 6
mov al, 0
mov bh, 12     ;color
mov ch, up     ;top row of window
mov cl, left     ;left most column of window
mov dh, down     ;Bottom row of window
mov dl, right     ;Right most column of window

int 10h


ret
movup endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movdown proc

mov ah, 6
mov al, 0
mov bh, 12     ;color
mov ch, up     ;top row of window
mov cl, left     ;left most column of window
mov dh, down     ;Bottom row of window
mov dl, right     ;Right most column of window

int 10h

ret
movdown endp

movleft proc

mov ah, 6
mov al, 0
mov bh, 12     ;color
mov ch, up     ;top row of window
mov cl, left     ;left most column of window
mov dh, down     ;Bottom row of window
mov dl, right     ;Right most column of window

int 10h


ret
movleft endp


movright proc

mov ah, 6
mov al, 0
mov bh, 12     ;color
mov ch, up     ;top row of window
mov cl, left     ;left most column of window
mov dh, down     ;Bottom row of window
mov dl, right      ;Right most column of window

int 10h


ret
movright endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

movrightup proc
;)))))))))))))))))))))))))
mov ah, 6
mov al, 0
mov bh, 0     ;color
mov ch, up     ;top row of window
mov cl, left     ;left most column of window
mov dh, down     ;Bottom row of window
mov dl, right     ;Right most column of window
int 10h

;)))))))))))))))))))))))))
  inc left
  inc right
  dec up 
  dec down
call movright

ret
movrightup endp


movleftup proc
;)))))))))))))))))))))))))
mov ah, 6
mov al, 0
mov bh, 0    ;color
mov ch, up     ;top row of window
mov cl, left     ;left most column of window
mov dh, down     ;Bottom row of window
mov dl, right    ;Right most column of window
int 10h

;)))))))))))))))))))))))))
dec left
dec right
dec up 
dec down
call movleft

ret
movleftup endp

movrightdown proc
;)))))))))))))))))))))))))
mov ah, 6
mov al, 0
mov bh, 0    ;color
mov ch, up     ;top row of window
mov cl, left     ;left most column of window
mov dh, down     ;Bottom row of window
mov dl, right     ;Right most column of window
int 10h

;)))))))))))))))))))))))))
inc left
inc right
inc up
inc down
call movright


ret
movrightdown endp


movleftdown proc
;)))))))))))))))))))))))))
mov ah, 6
mov al, 0
mov bh, 0       ;color
mov ch, up       ;top row of window
mov cl, left     ;left most column of window
mov dh, down     ;Bottom row of window
mov dl, right    ;Right most column of window
int 10h

;)))))))))))))))))))))))))
dec left 
dec right
inc up
inc down
call movleft


ret
movleftdown endp

; (((((((((((((((((((((((((((   DELAY   )))))))))))))))))))))))))))
delay proc

	
	mov cx, delayCount  ; 0
	OUTER_DELAY:
		mov bx, delayCount2; 300 
		INNER_DELAY:
			dec bx
			jnz INNER_DELAY
	loop OUTER_DELAY
	

	ret

delay endp

;(((((((((((((((((((((((((()))))))))))))))))))))))))))))

;***************************************************************************** 
;                                     COLLISIONS CHECK
collisionCheck proc

mov cx, 24
mov var2,cx
mov si, 0
looop:



   mov bh, color[si]
   mov ch, urow[si]
   dec ch
   mov cl, lcol[si]
   dec cl
   mov dh, brow[si]
   mov dl, rcol[si]
   inc dl


;.while p3.color_level!= 24
; if not black color only then will the collision occur
.if left>=cl && right<=dl && up >=ch && down <= dh  && bh!= 16

   cmp boolvertical,1
   jne okay1
   mov boolvertical,0
   jmp okay


   okay1:
   mov boolvertical,1
   

   okay:
        ;((((((((((((  Level 1  ))))))))))))
   .if level == 1
        inc p3.score_num
        mov color[si],16  ; make bricks black
		call beep
	    inc p3.color_level
		;((((((((((((  Level 2  ))))))))))))
	.elseif level == 2
     	
        mov dl,times_hit[si]
       .if dl==0
  
           inc p3.score_num
           mov color[si],16
		   call beep 
	       inc p3.color_level; no. of bricks that have been hit

       .else 
           dec times_hit[si]

       .endif
	   
	    ;((((((((((((  Level 3  ))))))))))))
	.elseif level == 3
	       mov dl,times_hit[si]
       .if dl==0
  
           inc p3.score_num
           mov color[si],16
		   call beep
	       inc p3.color_level; no. of bricks that have been hit

       .else 
           dec times_hit[si]
	    .endif
		        
    .endif
	; Check for incrementing a level
	             .if p3.color_level== 24
				     inc level
					.if level == 2
					    jmp level_has_changed
					.elseif level == 3
					     jmp level_has_changed
					.endif 
	             .endif
   
.endif
  inc si
  dec var2
  mov cx,var2
  cmp cx,0
  jne looop

; {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{  LOOP 2  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
; For edges of bricks

mov cx,24
mov var1,cx
mov si,0

looop1:


   mov bh, color[si]
   mov ch, urow[si]
   mov cl, lcol[si]
   mov dh, brow[si]
   mov dl, rcol[si]
   inc dl
   dec cl

.if left>=cl && right<=dl && up >=ch && down <= dh  && bh!= 16 


  .if boolhorizontal1==0
   ;{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{  EDGES  LOOP 1  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
        mov boolhorizontal1,2
           ;((((((((((((  Level 1  ))))))))))))
   .if level == 1
        inc p3.score_num
        mov color[si],16  ; make bricks black
		call beep
	    inc p3.color_level
		;((((((((((((  Level 2  ))))))))))))
	.elseif level == 2
     	
        mov dl,times_hit[si]
       .if dl==0
  
           inc p3.score_num
           mov color[si],16
		   call beep
	       inc p3.color_level; no. of bricks that have been hit

       .else 
           dec times_hit[si]

       .endif
	   
	    ;((((((((((((  Level 3  ))))))))))))
	.elseif level == 3
	       mov dl,times_hit[si]
       .if dl==0
  
           inc p3.score_num
           mov color[si],16
		   call beep
	       inc p3.color_level; no. of bricks that have been hit

       .else 
           dec times_hit[si]
	    .endif
		        
    .endif
	; Check for incrementing a level
	             .if p3.color_level== 24
				     inc level
					.if level == 2
					    jmp level_has_changed
					.elseif level == 3
					     jmp level_has_changed
					.endif 
	             .endif
   .endif 
   ;{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{  EDGE LOOP 2  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
   .if boolhorizontal1==2
       mov boolhorizontal1,0
		         ;((((((((((((  Level 1  ))))))))))))
   .if level == 1
        inc p3.score_num
        mov color[si],16  ; make bricks black
		call beep
	    inc p3.color_level
		;((((((((((((  Level 2  ))))))))))))
	.elseif level == 2
     	
        mov dl,times_hit[si]
       .if dl==0
  
           inc p3.score_num
           mov color[si],16
		   call beep
	       inc p3.color_level; no. of bricks that have been hit

       .else 
           dec times_hit[si]

       .endif
	   
	    ;((((((((((((  Level 3  ))))))))))))
	.elseif level == 3
	       mov dl,times_hit[si]
       .if dl==0
  
           inc p3.score_num
           mov color[si],16
		   call beep
	       inc p3.color_level; no. of bricks that have been hit

       .else 
           dec times_hit[si]
	    .endif
		        
    .endif
	; Check for incrementing a level
	             .if p3.color_level== 24
				     inc level
					.if level == 2
					    jmp level_has_changed
					.elseif level == 3
					     jmp level_has_changed
					.endif 
	             .endif
   .endif
  
  
.endif


inc si
dec var1
mov cx,var1
cmp cx, 0
jne looop1

 ;.endw
 level_has_changed:
ret
collisionCheck endp


;************************************ SCORE PRINTING AND CALCULATION *********************************
int_to_arr proc 
mov si, 1
mov cx, 2
calculate:
mov p3.backup , cx
   mov ax, p3.score_num
   mov bl, 10
   div bl  ; remainder in ah 
   add ah ,48
   mov score_arr[si],ah
   dec si
   
   mov ax, p3.score_num
   div bl
   mov cl, al ; quotient in al
   mov ax, 0
   mov al, cl
   mov p3.score_num,ax ; quotient in al
   cmp ax, 0
   je get_out
   jmp calculate

get_out: 
ret

int_to_arr endp
;*************************
;*************************
print_score proc 

mov al, p3.num_score_col
mov p3.backup_2, al

	     call int_to_arr
         mov ah, 2
         mov dh, 1     ;row
         mov dl, p3.num_score_col ;column
         int 10h

         mov al,score_arr[0]   ;ASCII code of Character 
         mov bx,0
         mov bl,p3.score_color   ;Green color
         mov cx,1      ;repetition count
         mov ah,09h
         int 10h
		  inc p3.num_score_col


    	 mov ah, 2
         mov dh, 1     ;row
         mov dl, p3.num_score_col ;column
         int 10h

         mov al,score_arr[1]   ;ASCII code of Character 
         mov bx,0
         mov bl,p3.score_color    ;Green color
         mov cx,1      ;repetition count
         mov ah,09h
         int 10h
		
mov al, p3.backup_2
mov p3.num_score_col, al

  ret


print_score endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ballmove proc



cmp boolhorizontal2,1
je bouncefromedge
cmp boolvertical,1

jne down1


cmp boolhorizontal1,1
jne leftorright



call movup
jmp skip
leftorright:

cmp boolhorizontal1,0

jne rightup


call movleftup
jmp skip
rightup:

call movrightup
jmp skip


down1:


cmp boolhorizontal1,1
jne leftorrightdown


call movdown
jmp skip
leftorrightdown:

cmp boolhorizontal1,0
jne rightdown


call movleftdown
jmp skip
rightdown:

call movrightdown
jmp skip


;change the diraction of ball

skip:
cmp up,4
jl cup

cmp down,26
jng checklefright
cmp boolvertical,0
je cdown


jmp checklefright

cdown:	;change the diraction of ball
mov bl,left
mov bh,right
inc bl

dec bh
dec bh

;(((((((((((((((((((((())))))))))))))))))))))
.if bh<=rodright && bl >= rodleft
     mov boolvertical,1
.else 
    dec p3.lives
	; checking lives to cross the hearts
	.if p3.lives == 1
	       mov ah,  2
           mov dh,  1    ;row
           mov dl,  5    ;column
           int 10h
     
           mov al,03h    ;ASCII code of Character 
           mov bx,0
           mov bl,14;4;3;0010b   ;Green color
           mov cx,1     ;repetition count
           mov ah,09h
           int 10h
	     
	 .endif
	.if p3.lives == 2
	       mov ah,  2
           mov dh,  1    ;row
           mov dl, 11    ;column
           int 10h
     
           mov al,03h   ;ASCII code of Character 
           mov bx,0
           mov bl,11;3;0010b   ;Green color
           mov cx,1       ;repetition count
           mov ah,09h
           int 10h
		   
    .endif
	
	mov ah, 6
    mov al, 0
    mov bh, 0     ;color
    mov ch, up     ;top row of window
    mov cl, left     ;left most column of window
    mov dh, down     ;Bottom row of window
    mov dl, right     ;Right most column of window
    int 10h

    mov cl, b_up
	mov up, cl
	mov cl, b_down
	mov down , cl
	mov cl, b_left
	mov left, cl
	mov cl, b_right
	mov right, cl
	mov boolvertical, 1
	
	
	

.endif
    jmp checklefright

cup:	;change the diraction of ball
mov boolvertical,0
jmp checklefright


checklefright:

cmp left,3
jl cleft

jmp checkright

cleft:
mov boolhorizontal1,2

checkright:
; (((((((((((((((((((((())))))))))))))))))))))
cmp right,76
jg cright
ret
cright:
   mov boolhorizontal1,0
   jmp exit1

bouncefromedge:



cmp boolvertical,1

jne down11

cmp boolhorizontal1,1
jne leftorright1

call movup
jmp skip1
leftorright1:

cmp boolhorizontal1,0
jne rightup1


call movleftup
jmp skip1
rightup1:



call movrightup
jmp skip1


down11:


cmp boolhorizontal1,1
jne leftorrightdown1
call movdown
jmp skip1
leftorrightdown1:

cmp boolhorizontal1,0
jne rightdown1

call movleftdown
jmp skip1
rightdown1:

call movrightdown
jmp skip


;change the diraction of ball

skip1:
cmp up,3
jl cup1

cmp down,27
jg cdown1

jmp checklefright1

cdown1:	;change the diraction of ball
mov boolvertical,1
jmp checklefright1

cup1:	;change the diraction of ball
mov boolvertical,0
jmp checklefright1


checklefright1:

cmp left,1
jl cleft1

jmp checkright1

cleft1:
mov boolhorizontal1,2

checkright1:

cmp right,79
jg cright1
ret
cright1:
mov boolhorizontal1,0

exit1:
ret
ballmove endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Breaks proc
; ******* draw bricks 
mov cx, 24
mov si, 0
l12 :
mov var1, cx ; making backup 
   mov ah, 6
   mov al, 0
   mov bh, color[si]
   
   mov ch, urow[si]
   mov cl, lcol[si]
   mov dh, brow[si]
   mov dl, rcol[si]
   
   int 10h
   
   inc si
   
   
   mov cx, var1
   cmp cx, 0
   je downn
    

loop l12  
downn:

ret

breaks endp



;---------------------------------------------------------------------

;---------------------------------------------------------------------

; ---------------------------------------------------------------------
print_boundary proc 
   
   call print_score
   mov cx ,73
  upbound:
   mov p3.backup , cx
       ;setting cursor position
       mov ah, 2
       mov dh,  2    ;row
       mov dl, p3.upboundcol     ;column
       int 10h
     
       mov al,'-'    ;ASCII code of Character 
       mov bx,0
       mov bl,11;3;0010b   ;Green color
       mov cx,1       ;repetition count
       mov ah,09h
       int 10h
       inc p3.upboundcol
       
       mov cx, p3.backup 
	   
 loop upbound
   
       mov cx, 29
     	l1:
     	mov p3.backup , cx
       ;setting cursor position
       mov ah, 2
       mov dh,  p3.row    ;row
       mov dl, p3.lcol     ;column
       int 10h
     
       mov al,'|'    ;ASCII code of Character 
       mov bx,0
       mov bl,11;3;0010b   ;Green color
       mov cx,1       ;repetition count
       mov ah,09h
       int 10h
       inc p3.row
       
       mov cx, p3.backup 
     loop l1
     
     
     mov al, 1
     mov p3.row, al
     	 mov cx, 29
     	l2:
     	mov p3.backup , cx
       ;setting cursor position
       mov ah, 2
       mov dh,  p3.row    ;row
       mov dl, p3.rcol     ;column
       int 10h
     
       mov al,'|'    ;ASCII code of Character 
       mov bx,0
       mov bl,11;3;0010b   ;Green color
       mov cx,1       ;repetition count
       mov ah,09h
       int 10h
       inc p3.row
       
       mov cx, p3.backup 
     loop l2
     
  
     mov si, 0
     mov al, 1
     mov p3.row, al
         
     	
     	mov cx, lengthof p3.score
     	l3:
     ;setting cursor position
              mov p3.backup , cx
              mov ah, 2
              mov dh, p3.row      ;row
              mov dl, p3.score_col;column
              int 10h
     
              mov al,p3.score[si]    ;ASCII code of Character 
              mov bx,0
              mov bl,11;3;0010b   ;Green color
              mov cx,1      ;repetition count
              mov ah,09h
              int 10h
     		 inc p3.score_col
              mov cx, p3.backup 
     		 inc si
     		 
     		 cmp cx, 0
     		 je down2
     
     loop l3
	 mov cx, 3
	l4:
;setting cursor position
        mov p3.backup , cx
  ;setting cursor position
        mov ah, 2
        mov dh, 1   ;row
        mov dl, p3.heartcol     ;column
  int 10h

   mov al, 3h    ;ASCII code of Character 
   mov bx, 0
   mov bl,4   ;Green color
   mov cx,1       ;repetition count
   mov ah,09h
   int 10h
   inc p3.heartcol
   inc p3.heartcol
   
   mov cx, p3.backup
		 

loop l4
		 
     down2:
     
     ret

print_boundary endp

; --------------------------------------------------------------------
game_preview proc 


; Main
; making backup of the level in next level
    mov cl, level
    mov next_level, cl
	;call breaks
	; Printing Boundary
    call print_boundary
    back:
    
    
    mov ah,1
    int 16h
    jz skipTemp
    
    mov ah,0
    int 16h
    cmp al, 27	;chech for escape key
    je exit
    
    ; Making backup of rod variables 
    mov bh, rodleft
    mov backup_rodleft, bh
    mov bh, rodright
    mov backup_rodright, bh
    
    .IF ah==4bh		;check for left arrow key
    cmp rodleft,2
    jng skipTemp
    dec rodleft
    dec rodright
    dec rodleft
    dec rodright
    dec rodleft
    dec rodright
    dec rodleft
    dec rodright
    
    .ELSEIF ah==4dh
    
    cmp rodright,80		;check for right arrow key
    jnl skipTemp
    
    add rodleft,5
    add rodright,5
	
	.elseif al == 08h  ; Check for backspace 
	   scrollwindowpink
	   call print_pause_string
	   mov bl,1 
	   mov gameresumebool, bl
	   jmp exit2
	   ;jmp main1
	
    .endif
    
    
    
    skipTemp:
    call ballmove
	;call check_brick_color_lvl
    call CollisionCheck ;
	mov cl, level
	.if cl == next_level	
      call delay
      call breaks
      call rod
	
	
	; Checking lives exit if 0
    cmp p3.lives ,0
    je exit
    jmp back
    
    exit:
	    mov al,1
		mov gameoverbool, 1
	    scrolldown
		call print_game_over
		; taking input for a key
		mov ah, 0
		int 16h
		jnz key_pressed
		
		key_pressed:
		   scrollwindow
		   ; store score 
	.endif
    exit2:
	
		      mov al, p3.color_level
			  mov backup_color_level, al
		
		
    ret

game_preview endp

;----------------------------------

print_pause_string  proc
mov al, 30
mov lvl2.col, al
      mov si, 0
      mov cx , lengthof lvl2.pausestring
        l1 :
	    ; make backup 
		 mov lvl2.backup, cx 
	    ; using setcursor function
	     mov ah, 2
	     mov bh, 0
	     mov dl, lvl2.col; col
	     mov dh, lvl2.row; row
	     int 10h

		 
		 
	     mov ah, 9
	     mov al, lvl2.pausestring[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 12; color magenta 
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, lvl2.col
		 add al, 1
		 mov lvl2.col, al
		 
		 
	     mov cx, lvl2.backup 
		 	 
	 loop l1 
	
  ret

print_pause_string  endp


;----------------------------------
print_level1_string  proc
mov al, 30
mov lvl2.col, al
      mov si, 0
      mov cx , lengthof lvl2.showstring1
        l1 :
	    ; make backup 
		 mov lvl2.backup, cx 
	    ; using setcursor function
	     mov ah, 2
	     mov bh, 0
	     mov dl, lvl2.col; col
	     mov dh, lvl2.row; row
	     int 10h

		 
		 
	     mov ah, 9
	     mov al, lvl2.showstring1[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 11; color magenta 
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, lvl2.col
		 add al, 1
		 mov lvl2.col, al
		 
		 
	     mov cx, lvl2.backup 
		 	 
	 loop l1 
	
  ret

print_level1_string  endp


;----------------------------------
print_level2_string  proc
mov al, 30
mov lvl2.col, al
      mov si, 0
      mov cx , lengthof lvl2.showstring
        l1 :
	    ; make backup 
		 mov lvl2.backup, cx 
	    ; using setcursor function
	     mov ah, 2
	     mov bh, 0
	     mov dl, lvl2.col; col
	     mov dh, lvl2.row; row
	     int 10h

		 
		 
	     mov ah, 9
	     mov al, lvl2.showstring[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 11; color magenta 
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, lvl2.col
		 add al, 1
		 mov lvl2.col, al
		 
		 
		 
	     mov cx, lvl2.backup 
		 	 
	 loop l1 
	 MOV al,lvl2.b_col
	 mov lvl2.col, bl
  ret

print_level2_string  endp


;----------------------------------
print_level3_string  proc
mov al, 30
mov lvl2.col, al
      mov si, 0
      mov cx , lengthof lvl3.showstring
        l1 :
	    ; make backup 
		 mov lvl2.backup, cx 
	    ; using setcursor function
	     mov ah, 2
	     mov bh, 0
	     mov dl, lvl2.col; col
	     mov dh, lvl2.row; row
	     int 10h

		 
		 
	     mov ah, 9
	     mov al, lvl3.showstring[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 11; color magenta 
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, lvl2.col
		 add al, 1
		 mov lvl2.col, al
		 
		 
		 
	     mov cx, lvl2.backup 
		 	 
	 loop l1 
	 MOV al,lvl2.b_col
	 mov lvl2.col, bl
  ret

print_level3_string  endp
;----------------------------------

print_game_over proc
mov al, 30
mov lvl2.col, al
  mov cx , lengthof lvl2.game_over
	 mov si, 0
	 l1 :
	    ; make backup 
		 mov lvl2.backup, cx 
	    ; using setcursor function
	     mov ah, 2
	     mov bh, 0
	     mov dl, lvl2.col; col
	     mov dh, lvl2.row; row
	     int 10h

		 
		 
	     mov ah, 9
	     mov al, lvl2.game_over[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 11; color magenta 
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, lvl2.col
		 add al, 1
		 mov lvl2.col, al
		 
		 
		 
	     mov cx, lvl2.backup 
		 	 
	 loop l1 

  ret


print_game_over endp
; ************************** Set Cursor for page 1 ********************
setcursor_p1 proc

   
	mov ah, 2
	mov bh, 0
	mov dl, p1.col; col
	mov dh, p1.row; row
	int 10h

	ret
    
setcursor_p1 endp



; *************************** Print page 1 **********************

; *************************** Print Box ********************   
printbox proc 
   ;setting cursor position
mov ah, 2
mov dh, p2.row    ;row
mov dl, p2.col     ;column
int 10h

mov al,'>'    ;ASCII code of Character 
mov bx,0
mov bl,p2.color  ;Green color
mov cx,3       ;repetition count
mov ah,09h
int 10h
    ret 

printbox endp




; ************************** Set Cursor ********************
setcursor proc

   
	mov ah, 2
	mov bh, 0
	mov dl, p2.col; col
	mov dh, p2.row; row
	int 10h

	ret
    
setcursor endp





; ************************ Print Function ************************
print proc 

        ; /\/\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/  First array /\/\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\/\/\/
	 
     ; ******************* back up of row & column **********************
	 mov al, p2.row
	 mov p2.var1, al
	 mov ah, p2.col
	 mov p2.var2, ah
	 mov cx , lengthof p2.game_name
	 mov si, 0
	 l1 :
	    ; make backup 
		 mov p2.backup, cx 
	    ; using setcursor function
	     call setcursor
		 
		 
	     mov ah, 9
	     mov al, p2.game_name[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 3; color magenta 
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, p2.col
		 add al, 1
		 mov p2.col, al
		 
		 
	     mov cx, p2.backup 
		 	 
	 loop l1 
	 
	 ; /\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\\/\/\/\/\    second array    //\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\\
	 ; Printing second array
	 
	 mov al, p2.var1
	 add al, 4
	 mov p2.row, al
	 mov al, p2.var2
	 add al, 5
	 mov p2.col, al
	 
	  ; ******************* back up of row & column **********************
	 mov al, p2.row
	 mov p2.var1, al
	 
	 
	 mov cx , lengthof p2.newgame
	 mov si, 0
	 l2 :
	    ; make backup 
		 mov p2.backup, cx 
	    ; using setcursor function
	     call setcursor
		 
		 
	     mov ah, 9
	     mov al, p2.newgame[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 4; color
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, p2.col
		 add al, 1
		 mov p2.col, al
		 
		 
		 mov cx, p2.backup 
		 	 
	 loop l2
	 
	 
	 ; /\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\\/\/\/\/\    Third array    //\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\\
	 
	 
	 mov al, p2.var1
	 add al, 2
	 mov p2.row, al
	 mov al, p2.var2
	 add al, 6
	 mov p2.col, al
	 
	  ; ******************* back up of row & column **********************
	 mov al, p2.row
	 mov p2.var1, al
	
	 
	 mov cx , lengthof p2.resume
	 mov si, 0
	 l3 :
	    ; make backup 
		 mov p2.backup, cx 
	    ; using setcursor function
	     call setcursor
		 
		 
	     mov ah, 9
	     mov al, p2.resume[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 4; color
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, p2.col
		 add al, 1
		 mov p2.col, al
		 
		 
		 mov cx, p2.backup 
		 	 
	 loop l3
	 


 ; /\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\\/\/\/\/\    	Fourth array    //\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\\
	 
	 
	 mov al, p2.var1
	 add al, 2
	 mov p2.row, al
	 mov al, p2.var2
	 add al, 3
	 mov p2.col, al
	 
	  ; ******************* back up of row & column **********************
	 mov al, p2.row
	 mov p2.var1, al

	 
	 mov cx , lengthof p2.instruction
	 mov si, 0
	 l4 :
	    ; make backup 
		 mov p2.backup, cx 
	    ; using setcursor function
	     call setcursor
		 
		 
	     mov ah, 9
	     mov al, p2.instruction[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 4; color
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, p2.col
		 add al, 1
		 mov p2.col, al
		 
		 
		 mov cx, p2.backup 
		 	 
	 loop l4
	 
	 
	 
	  ; /\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\\/\/\/\/\    Fifth array    //\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\\
	 
	 
	 mov al, p2.var1
	 add al, 2
	 mov p2.row, al
	 mov al, p2.var2
	 add al, 4
	 mov p2.col, al
	 
	  ; ******************* back up of row & column **********************
	 mov al, p2.row
	 mov p2.var1, al

	 
	 mov cx , lengthof p2.score
	 mov si, 0
	 l5 :
	    ; make backup 
		 mov p2.backup, cx 
	    ; using setcursor function
	     call setcursor
		 
		 
	     mov ah, 9
	     mov al, p2.score[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 4; color
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, p2.col
		 add al, 1
		 mov p2.col, al
		 
		 
		 mov cx, p2.backup 
		 	 
	 loop l5
	 
	 
	 
	  ; /\/\/\/\/\/\/\/\\/\/\/\/\/\/\/\\/\/\/\/\    Sixth array    //\/\/\/\/\/\/\/\/\/\/\\/\/\/\/\\
	 
	 
	 mov al, p2.var1
	 add al, 2
	 mov p2.row, al
	 mov al, p2.var2
	 add al, 7
	 mov p2.col, al
	 
	  ; ******************* back up of row & column **********************
	 mov al, p2.row
	 mov p2.var1, al

	 
	 mov cx , lengthof p2.exit
	 mov si, 0
	 l6 :
	    ; make backup 
		 mov p2.backup, cx 
	    ; using setcursor function
	     call setcursor
		 
		 
	     mov ah, 9
	     mov al, p2.exit[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 4; color
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, p2.col
		 add al, 1
		 mov p2.col, al
		 
		 
		 mov cx, p2.backup 
		 	 
	 loop l6
	 
	 ; /\/\/\/\/\/\/\/\//\/\//\/\/\/\/\/\//\/\   	Print 	Cursor    /\/\/\/\/\\/\//\/\/\/\/\/\/\/\/\/\/\/\/
	 mov al, p2.var1; rows
	 mov  al, 12
	 
	 mov p2.row, al
	 mov al, p2.var2; col
	 sub al, 3
	 mov p2.col, al
	 
	
	 

     ret 
print endp

;************************ ----,  **********************
;************************     |  **********************
;************************    /   **********************
;************************   /    **********************
;************************  /____ **********************
setcursor2 proc 

    push bp
    mov bp, sp
	
	
	mov ah, 2
	mov dl, [bp+12]; col
	mov dh, [bp+14]; row
	mov bh, 0
	int 10h
	
	
	mov sp, bp
    pop bp
   

	ret


setcursor2 endp

printstring proc
   
 
   push bp
   mov bp, sp
   ; bp+4 address of array
   mov si, [bp+4]
  
   ; printing the string 
   
   mov cx, [bp+6]
   call setcursor2
   ab1:
       mov p2.backup, cx
       
	   
       mov ah, 9
	   mov al, [si]
	   mov bh, 0
	   mov bl, 3; color
	   mov cx, 1
	   int 10h  
	   inc si
	   
	   ; inc column
	   mov ax, [bp+8]
	   add ax, 1
	   mov [bp+8], ax
	   call setcursor2
       mov cx, p2.backup
    loop ab1
       ; inc row
       mov ax, [bp+10]
	   add ax, 2
	   mov [bp+10], ax
	   ; resaving col
	   mov ax, p5.col
	   mov [bp+8], ax
   
   mov sp, bp
   pop bp
   
   ret


printstring endp 





printinstr proc 
   push p5.row ; 7
   push p5.col ; 3
   mov di, lengthof p5.string
   push di
   mov di, offset p5.string
   push di
   call printstring
   pop address
   pop address
   mov di, lengthof p5.string1
   push di
   mov di, offset p5.string1
   push di
   call printstring
   pop address
   pop address
   mov di, lengthof p5.string2
   push di
   mov di,offset p5.string2 
   push di
   call printstring
   pop address
   pop address
   mov di, lengthof p5.string3
   push di
   mov di, offset p5.string3
   push di
   call printstring
   pop address
   pop address
   mov di, lengthof p5.string4
   push di
   mov di,  offset p5.string4 
   push di
   call printstring
   pop address
   pop address
   ; row and column still in stack
   
   
   ret

printinstr endp



page1_complete proc 

	
	; set cursor
	call setcursor_p1
	
	; output string
	
	mov dx, offset p1.enter_name
	mov ah, 9
	int 21h
	 	

	
	
	; set cursor
	
	mov ah, 2
	mov dl, 40; col
	mov dh, p1.row; row
	mov bh, 0
	int 10h
	
	mov dx, offset p1.your_name
	mov ah, 3fh
	int 21h
	
	;make a txt file
	
	
	; OPEN existing file 
		  mov ah, 3dh
		  mov al, 2
		  mov dx,  offset p1.file
		  int 21h
		  mov p1.filehandler, ax

		  ; APPEND A FILE 
			mov cx, 0
			mov dx, 0
			mov bx, p1.filehandler
			mov ah, 42h
			mov al, 2; 0 for file beginning 2 for file end 
			int 21h
			
		 ; WRITE IN THE FILE 
		  mov ah, 40h
		  mov bx, p1.filehandler
		  mov cx, lengthof p1.your_name
		  mov dx, offset p1.your_name
		  int 21h
		  
		  ; APPEND A FILE 
			mov cx, 0
			mov dx, 0
			mov ah, 42h
			mov al, 2; 0 for file beginning 2 for file end 
			int 21h
		  
		  ; close a file 
		  mov ah, 3eh
		  mov bx, p1.filehandler
		  int 21h
		  mov ah, 0
          mov al, 0 
          int 16h
	      cmp al, 10d
	      je take_input
	; take input in string
	      take_input:
	
		  scrollwindow
		  

    ret

page1_complete endp

;----------------------------   HIGH SCORE   ----------------------------------

show_high_score proc
    ; OPEN existing file 
		  mov ah, 3dh
		  mov al, 2
		  mov dx,  offset p1.file
		  int 21h
		  mov p1.filehandler, ax
	; READ from a file 
          mov ah, 3fh
          mov cx, 12
          mov dx, offset p1.data
          mov bx, p1.filehandler
          int 21h
		  
		  ; Output string naming highscore
		       	
	 mov al, p2.row
	 mov p2.var1, al
	 mov ah, p2.col
	 mov p2.var2, ah
      mov si, 0
      mov cx , lengthof hih.showstring
        l1 :
	    ; make backup 
		 mov lvl2.backup, cx 
	    ; using setcursor function
	     mov ah, 2
	     mov bh, 0
	     mov dl, p1.col; col
	     mov dh, p1.row; row
	     int 10h

		 
		 
	     mov ah, 9
	     mov al,  hih.showstring[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 11; color magenta 
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, p1.col
		 add al, 1
		 mov p1.col, al
		 
		 
	     mov cx, lvl2.backup 
		 	 
	 loop l1 
	   
	 mov ah, p2.var2
	 mov p2.col, ah
		  
    ; Output the high scores  	
           	
		  mov al, 30
mov lvl2.col, al
      mov si, 0
      mov cx , lengthof p1.data
        l11 :
	    ; make backup 
		 mov lvl2.backup, cx 
	    ; using setcursor function
	     mov ah, 2
	     mov bh, 0
	     mov dl, lvl2.col; col
	     mov dh, lvl2.row; row
	     int 10h

		 
		 
	     mov ah, 9
	     mov al, p1.data[si]; ASCII char to print
	     mov bh, 0  ; video page
	     mov bl, 11; color magenta 
	     mov cx, 1  ; repitition
	     int 10h
		 inc si
		 
		 ; restoring values of col and row 
		 mov al, lvl2.col
		 add al, 1
		 mov lvl2.col, al
		 
		 
	     mov cx, lvl2.backup 
		 	 
	 loop l11 
		  
ret
show_high_score endp

main1:
;jmp above1


; ******************************  |\    /|    /\    |  |\  |  ************************************************************|
; ******************************  | \  / |   /--\   |  | \ |  ************************************************************|
; ******************************  |  \/  |  /    \  |  |  \|  ************************************************************|


main proc 
     mov ax, @data
     mov ds,ax
	 mov ax, 0


     ; $ GRAPHIC MODE 

	 MOV AL, 12h
	 INT 10H
	 
	 
	 
	 call page1_complete
	 
	 ; Printing letter by letter and setting cursor 
	 
	 ; 1. set cursor
	 ; 2. Printing a character 
	
	
	
	; making backup of row and col
                               mov al, p2.row
	                           mov p2.cbrow, al
	                           mov al, p2.col
	                           mov p2.cbcol, al
							   
							   
	above1:	
	                           mov al, p2.cbrow
	                           mov p2.row, al
	                           mov al, p2.cbcol
	                           mov p2.col, al
	
	call print  
    call printbox
	
	; check which key is pressed
	
	; Back ground colour
	;mov ah,0BH
	;mov bx,9		;colouring the backgroung (9 for blue)
	;int 10h
	

	 
	  
above :

mov ah, 0
mov al, 0
int 16h


; check the scan code
cmp ah, 048h
je up1 
   cmp ah,50h
   je down21 
       cmp al, 00001101b
	   je has_entered
           jmp exit21
		 
		 
   
   
   down21 :
  MOV AL, p2.row
  cmp al, 20
  je exit21
  
      mov al, 0
      mov p2.color, al
      call printbox
	  
      mov al, 0010b 
      mov p2.color, al
	  mov al, p2.row
      add al, 2
      mov p2.row, al
      call printbox
	  ; comparing for enter key
	
	 
		   jmp exit21
      
   

up1 :

   MOV AL, p2.row
   cmp al, 12
   je exit21
   mov al, 0
   mov p2.color, al
   call printbox
   mov al, 0010b 
   mov p2.color, al
   mov al, p2.row
   sub al, 2
   mov p2.row, al
   call printbox
   
  
   jmp exit21
 
 
 has_entered:
    
      cmp p2.row, 12
	  je newgame
	     cmp p2.row, 14
		 je resume 
		    cmp p2.row, 16
			je instruction
			    cmp p2.row, 18
				je highscore
				    cmp p2.row, 20
					jmp exitting
					
					
				
				
			
			           exitting:
					   
					  
					   jmp exit
		        highscore:
				    scrollwindow
					; show highscore
					call show_high_score
					jmp exit2
				  
		    instruction:
			   
				scrollwindow
			    call printinstr
				jmp exit2
				
	     resume:
		      mov al, backup_color_level
		      mov p3.color_level, al
		      .while level<4
		    call reset_game_page
		    scrollwindow
		     MOV al,lvl2.b_col
	         mov lvl2.col, bl
		   .if level == 1
		      scrolldown
			  call print_level1_string
			  ; taking input for a key
			  mov ah, 0
			  int 16h
			  jnz key_pressed1b
			  
			  
			  key_pressed1b:
			  scrollwindow
			  ; call reset_game_page
              call game_preview
		   .elseif level == 2
		      scrolldown
		      call print_level2_string
			  ; taking input for a key
			  mov ah, 0
			  int 16h
			  jnz key_pressed2b
			  
			  
			  key_pressed2b:
			  scrollwindow
			  call reset_game_page ; changes dimension
              call game_preview
		  .elseif level== 3
		       scrolldown
			   call print_level3_string
			    ; taking input for a key
			    mov ah, 0
			    int 16h
			    jnz key_pressed3b
			  
			  
			     key_pressed3b:
			     scrollwindow
		        call reset_game_page
                call game_preview
			.endif
			.if gameoverbool == 1
		         jmp exit2
		     .endif
			 .if gameresumebool == 1
			     jmp exit2
			 .endif 
			    
         .endw		   
		 jmp exit2
			 ; scrollwindow
			  ;call game_preview		
			  ;jmp exit2
		 
	  newgame:
	     .while level<4
		   call reset_game_page
		   scrollwindow
		     MOV al,lvl2.b_col
	         mov lvl2.col, bl
		   .if level == 1
		      scrolldown
			  call print_level1_string
			  ; taking input for a key
			  mov ah, 0
			  int 16h
			  jnz key_pressed1
			  
			  
			  key_pressed1:
			  scrollwindow
			  ; call reset_game_page
              call game_preview
		   .elseif level == 2
		      scrolldown
		      call print_level2_string
			  ; taking input for a key
			  mov ah, 0
			  int 16h
			  jnz key_pressed2
			  
			  
			  key_pressed2:
			  scrollwindow
			  call reset_game_page ; changes dimension
              call game_preview
		  .elseif level== 3
		       scrolldown
			   call print_level3_string
			    ; taking input for a key
			    mov ah, 0
			    int 16h
			    jnz key_pressed3
			  
			  
			     key_pressed3:
			     scrollwindow
		        call reset_game_page
                call game_preview
			.endif
			.if gameoverbool == 1
		         jmp exit2
		     .endif
			 .if gameresumebool == 1
			     jmp exit2
			 .endif 
			    
         .endw		   
		 jmp exit2
	  
   exit2:
   
   ; compare for escape character
    mov ah, 0
	mov al, 0
	int 16h
	cmp al, 08h
    jne exit2
	   scrollwindow
       jmp above1
   
    ;call print
exit21:
   
   
   ; for backspace
   ; ascii
   cmp al, 08h
   jne above
   mov dx, ax
   mov ah, 2
   int 21h

   
equal :


comment %
; Speaker Sounds 
   in al,speaker ; get speaker status
   push ax ; save status
   or al,00000011b ; set lowest 2 bits
   out speaker,al ; turn speaker on
   mov al,60 ; starting pitch
   L21: 
   out timer,al ; timer port: pulses speaker
; Create a delay loop between pitches.
  mov cx,delay1
  L31:
  push cx ; outer loop
  mov cx,delay2
  L3a: ; inner loop
  loop L3a
  pop cx
  loop L31
  sub al,1 ; raise pitch
  jnz L21 ; play another note
  pop ax ; get original status
  and al,11111100b ; clear lowest 2 bits
  out speaker,al ; turn speaker off
  
  %
  exit:



	 
	
main endp
	 
	 
	 ; -=-=-=-=

; *****************************************************************************************************
mov ah, 4ch
int 21h

end