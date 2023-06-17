scrollwindow macro 
   mov ah, 6; scroll window up
   mov al, 0;entire window
   mov ch, 0; upper left row
   mov cl, 0; upper left col
   mov dh, 32; lower right row
   mov dl, 79; lower right col
   mov bh, 0;9; color for blanked area (blue)
   int 10h   ; call bios

endm

scrollwindowpink macro 
   mov ah, 6; scroll window up
   mov al, 0;entire window
   mov ch, 0; upper left row
   mov cl, 0; upper left col
   mov dh, 32; lower right row
   mov dl, 79; lower right col
   mov bh, 12;9; color for blanked area (blue)
   int 10h   ; call bios

endm


scrolldown macro

   mov ah, 7; scroll window up
   mov al, 0; entire window
   mov ch, 0; upper left row
   mov cl, 0; upper left col
   mov dh, 32;lower right row
   mov dl, 79;lower right col
   mov bh, 11 ;color for blanked area  (blue)
   int 10h   ;call bios

endm



; ********************** PAGES STRUCTURES *****************
; ********************** Structure Page 1 *****************
page1 STRUCT 
  row db 10
  col db 15
  enter_name db "Enter Your Name: "
  your_name db 10 dup("$") 
  file db "highscor.txt", 0
  filehandler dw ?
  var1 dw 0
  backup dw 0
  data db 10 dup ("$")


page1 ENDS


; ********************** Structure Page 2 *****************
page2 STRUCT

    game_name db 'B','R','I','C','K',' ', 'B','R','E','A','K','E','R',' ', 'G','A','M','E'
    newgame db "NEW GAME" 
    resume db "RESUME"
	instruction db "INSTRUCTIONS"
	score db "HIGH SCORE"
	exit db "EXIT"
	row db 8
	col db 30
	var1 db 0
	var2 db 0
	backup dw 0
	color db 0010b 
	cbrow db 0
	cbcol db 0

page2 ENDS 


; ********************** Structure Page 3 *****************
page3 STRUCT 

     level db 0
	 bricks db 24
	 ; for drawing the boundary
     colors db 2,3, 4,14 ,2,3, 4,14,  2,3, 4,14,  2,3, 4,14,  2,3, 4,14, 2,3, 4,14; green, red , yellow
     lcol db 1 
     rcol db 78
     score_col db 67
     drow db 29
     urow db 1
     backup dw 0
     score db "Score: "
	 upboundcol db 3
	 heartcol db 7
	 num_score_col db 73
	 score_color db 11
	 ; Score 
	 score_num dw 0
	 ; To check if all bricks have been hit
	 color_level db 0
     lives db 3 
     row db 1
     backup_2 db 0

page3 ENDS

high1score struct
     showstring db "HIGH SCORES"

high1score ends

; (((((((((((((((((((((((((((((((((((((((    RESET  PAGE 3    )))))))))))))))))))))))))))))))))))))))
reset_page3 STRUCT 
    
     level db 0
	 bricks db 24
	 ; for drawing the boundary
     colors db 2,3, 4,14 ,2,3, 4,14,  2,3, 4,14,  2,3, 4,14,  2,3, 4,14, 2,3, 4,14; green, red , yellow
     lcol db 1 
     rcol db 78
     score_col db 67
     drow db 29
     urow db 1
     backup dw 0
     score db "Score: "
	 upboundcol db 3
	 heartcol db 7
	 
     var1 dw 0
     var2 dw 0
     backup_rodleft db 0
     backup_rodright db 0
     num dw 0
     count db 0
     temp dw 0
     scored dw 0

     delayCount dw 400
     boolvertical db 0
     boolhorizontal1 db 0
     boolhorizontal2 db 0
     boolDead db 0
     rodleft db 45
     rodright db 60
	 score_arr db 2 dup('0')
	 num_score_col db 75

; variables for ball 
     up db 20
     down db 20
     left db 10
     right db 11
     row db 1
   

reset_page3 ENDS

;((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))
;(((((((((((((((((((((((((((((((((((((   LEVEL 2   )))))))))))))))))))))))))))))))))))))
;((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))

level2 struct
   pausestring db "* || PAUSED || *"
   showstring1 db " LEVEL 1 (^o^)/"
   showstring db  " LEVEL 2 (^o^)/"
   urow       db 5,5,5,5,5,5,8,8,8,8,8,8,11,11,11,11,11,11,14,14,14,14,14,14
   lcol       db 8,20,32,44,56,68,8,20,32,44,56,68,8,20,32,44,56,68,8,20,32,44,56,68
   brow       db 6,6,6,6,6,6,9,9,9,9,9,9,12,12,12,12,12,12,15,15,15,15,15,15
   rcol       db 18,30,42,54,66,73,18,30,42,54,66,73,18,30,42,54,66,73,18,30,42,54,66,73 
   color      db 2,3, 4,14 ,2,3, 4,14,  2,3, 4,14,  2,3, 4,14,  2,3, 4,14, 2,3, 4,14; green, red , yellow
   
   times_hit  db 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
   rodleft    db  40
   rodright   db  55
  
   	row db 11
	col db 29
	b_col db 29
	game_over db "(T_T) Game Over (Q_Q)"
	backup dw 0
	delayCount dw  300
level2 ends



;((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))
;(((((((((((((((((((((((((((((((((((((   LEVEL 3   )))))))))))))))))))))))))))))))))))))
;((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))

level3 struct
   showstring db " LEVEL 3 (^o^)/"
   times_hit db 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
   
   urow       db 5,5,5,5,5,5,8,8,8,8,8,8,11,11,11,11,11,11,14,14,14,14,14,14
   lcol       db 8,20,32,44,56,68,8,20,32,44,56,68,8,20,32,44,56,68,8,20,32,44,56,68
   brow       db 6,6,6,6,6,6,9,9,9,9,9,9,12,12,12,12,12,12,15,15,15,15,15,15
   rcol       db 18,30,42,54,66,73,18,30,42,54,66,73,18,30,42,54,66,73,18,30,42,54,66,73 
   color      db 2,3, 4,14 ,2,3, 4,14,  2,3, 4,14,  2,3, 4,14,  2,3, 4,14, 2,3, 4,14; green, red , yellow
   rodleft    db  40
   rodright   db  50
   delayCount dw  200
level3 ends
; ********************** Structure Page 5 *****************
page5 STRUCT 
  ; INSTRUCTIONS
  string db   "INSTRUCTIONS : "
  string1 db  "> In this game, the player moves a PADDLE from side-to-side to hit a BALL."
  string2 db  "> The games objective is to eliminate all of the BRICKS at the top"
  string3 db  "> If the ball hits the bottom ,the player loses and the game ENDS! "
  string4 db  "> To win the game, all the BRICKS must be eliminated." 
  row dw 7
  col dw 3
  
  

page5 ENDS
; **********************       END       *******************
