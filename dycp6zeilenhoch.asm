
//-----------------------------------------------------------------------------------
//
// Code by TWILIGHT / Excess 2019 - ...
// Kick Assembler V5.14
//
//-----------------------------------------------------------------------------------


.pc = $0801 "Basic Program"

:BasicUpstart($4000)

.pc = $4000	"maincode"

				lda #$00
				sta $0286
				jsr $e544
				lda #$00					
				sta $d020
				sta $d021
				ldy #$00
				ldx #$00
				lda #$00
				tay
!:				tya
				sta $0400,x
				iny
				tya
				sta $0400+40,x
				iny
				tya
				sta $0400+40*2,x
				iny
				tya
				sta $0400+40*3,x
				iny
				tya
				sta $0400+40*4,x
				iny
				tya
				sta $0400+40*5,x
				inx
				iny
				cpx #$28
				bne !-
					
					ldx #$00				
!:					lda #$ff
					sta $5300,x
					sta $5400,x
					sta $3800,x
					sta $3900,x
					sta $3a00,x
					sta $3b00,x
					sta $3c00,x
					sta $3d00,x
					sta $3e00,x
					sta $3f00,x
					inx
					bne !-

					sei
					lda #$7F
					sta $DC0D    
					sta $DD0D    
					lda $DC0D    
					lda $DD0D    
					lda #$01
					sta $D01A    
					lda #$32
					sta $D012    
					lda #<irq1
					sta $0314    
					lda #>irq1
					sta $0315    
					cli
					jmp *

//------------------------------------------------------------------------
irq1:	//scroller			
					nop
					nop
					nop
					lda #$01
					sta $d021
					lda #$1e
					sta $d018
					lda $02
					sta $d016
					
					lda #$62
					sta $D012    
					lda #<irq2
					sta $0314    
					lda #>irq2
					sta $0315    
					inc $d019
					jmp $ea7e
					

irq2:			
					nop
					nop
					nop
					lda #$00
					sta $d021
					sta $d020
					lda #$14
					sta $d018
					lda #$c8
					sta $d016
					
					lda #$32
					sta $D012    
					lda #<irq1
					sta $0314    
					lda #>irq1
					sta $0315    
					inc $d019
					
					lda #$0f
					sta $d020
					
					jsr scroll
					dec dmov2
					jsr schreiben
					
					lda #$00
					sta $d020
					sta $d021
					jmp $ea7e

//------------------------------------------------------------------------
sinus: //dycp
 .byte 15,17,19,21,23,25
      .byte 27,29,30,32,33,34
      .byte 34,35,35,35,35,34
      .byte 33,32,31,29,28,26
      .byte 24,22,20,18,16,14
      .byte 12,10,8,7,5,4
      .byte 3,2,1,1,1,1
      .byte 2,2,3,4,6,7
      .byte 9,11,13,15,17,19
      .byte 21,23,25,27,28,30
      .byte 31,33,34,34,35,35
      .byte 35,35,34,33,32,31
      .byte 30,28,26,25,23,21
      .byte 18,16,14,12,10,9
      .byte 7,5,4,3,2,2
      .byte 1,1,1,1,2,3
      .byte 4,5,7,9,10,12
      .byte 14,16,18,20,22,24
      .byte 26,28,30,31,32,33
      .byte 34,35,35,35,35,34
      .byte 34,33,31,30,28,27
      .byte 25,23,21,19,17,15
      .byte 13,11,9,7,6,4
      .byte 3,2,2,1,1,1
      .byte 1,2,3,4,5,7
      .byte 8,10,12,14,16,18
      .byte 20,22,24,26,28,29
      .byte 31,32,33,34,35,35
      .byte 35,35,34,34,33,32
      .byte 30,29,27,25,23,21
      .byte 19,17,15,13,11,9
      .byte 8,6,5,3,2,2
      .byte 1,1,1,1,2,3
      .byte 4,5,6,8,10,11
      .byte 13,15,18,20,22,24
      .byte 26,27,29,31,32,33
      .byte 34,34,35,35,35,35
      .byte 34,33,32,31,29,27
      .byte 26,24,22,20,18,16
      .byte 14,12,10,8,6,5
      .byte 4,3,2,1,1,1
      .byte 1,2,2,3,5,6
      .byte 8,9,11,13      
      
      //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

dmov2:.byte $00

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
scroll:			

scroller:				
				lda #$40							// stop routine
				cmp #$00
				beq !+
				dec scroller+1
				rts


	!:			lda $02				//d016
				sec
scrspeed:		sbc #$02
				pha
				and #$08
				beq !+
				jsr scr1
!:				pla
				and #$07
				ora #$00
				sta $02
				rts
scr1:				
				ldx #$00				
          .for (var i=0; i<256; i++) {
!:				lda $5308+i			//charset scroll in mem		
				sta $5300+i				
				}			
							
          .for (var i=0; i<56; i++) {
!:				lda $5408+i
				sta $5400+i
				}
				
				ldy #$00
!:				lda ($a3),y
				bne !+
				lda #<scrolltext    		//scrolltext
				ldx #>scrolltext
				sta $a3
				stx $a4
				jmp !-
				
!:								
				cmp #$40							// stop "command"
				bne !+
				lda #$60							// "zeitverzÃ¶gerung", kann indv. angepasst werden
				sta scroller+1
				jmp loop1

!:				cmp #$41							// speed "command"
				bcc !+
				sec
				sbc #$40
				sta scrspeed+1
				lda #$20							// "command" mit leerzeichen ersetzen
loop1:
!:
				cmp #$40						// stop und speed "commands" ignorieren
				bcc !+
				lda #$20						// und mit einem leerzeichen ersetzen
				
				
!:				inc $a3
				bne !+
				inc $a4
!:				sty $a6
				asl
				rol $a6
				asl
				rol $a6
				asl
				rol $a6
				sta $a5
				lda $a6
				clc
				adc #$20			// hibyte 1x1 charset
				sta $a6
!:				lda ($a5),y
				sta $5438,y
				iny
				cpy #$08
				bne !-
				rts
				
scrolltext: 
.text "            more than you deserve     CBA"							
.byte $40
.text "ABC"
			.byte $00
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.var high = 8*6    //charhöhe * 6 zeilen

//----------------------------------------------------
.pc = $6000

schreiben:
				ldx dmov2
				
				ldy sinus,x
				lda #$ff
				sta $3800+0,y
				sta $3800+1,y
				sta $3800+2,y
				sta $3800+11,y
				sta $3800+12,y
				sta $3800+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+i		//scrolltext in Mem
				sta $3803+i,y		//dycp charset on screen
				
				}
				inx
				
				ldy sinus,x
				lda #$ff
				sta $3800+high+0,y
				sta $3800+high+1,y
				sta $3800+high+2,y
				sta $3800+high+11,y
				sta $3800+high+12,y
				sta $3800+high+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8+i		//scrolltext in Mem
				sta $3803+high+i,y		//dycp charset on screen
				
				}
				inx
				
				ldy sinus,x
				lda #$ff
				sta $3800+high*2+0,y
				sta $3800+high*2+1,y
				sta $3800+high*2+2,y
				sta $3800+high*2+11,y
				sta $3800+high*2+12,y
				sta $3800+high*2+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*2+i		//scrolltext in Mem
				sta $3803+high*2+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*3+0,y
				sta $3800+high*3+1,y
				sta $3800+high*3+2,y
				sta $3800+high*3+11,y
				sta $3800+high*3+12,y
				sta $3800+high*3+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*3+i		//scrolltext in Mem
				sta $3803+high*3+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*4+0,y
				sta $3800+high*4+1,y
				sta $3800+high*4+2,y
				sta $3800+high*4+11,y
				sta $3800+high*4+12,y
				sta $3800+high*4+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*4+i		//scrolltext in Mem
				sta $3803+high*4+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*5+0,y
				sta $3800+high*5+1,y
				sta $3800+high*5+2,y
				sta $3800+high*5+11,y
				sta $3800+high*5+12,y
				sta $3800+high*5+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*5+i		//scrolltext in Mem
				sta $3803+high*5+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*6+0,y
				sta $3800+high*6+1,y
				sta $3800+high*6+2,y
				sta $3800+high*6+11,y
				sta $3800+high*6+12,y
				sta $3800+high*6+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*6+i		//scrolltext in Mem
				sta $3803+high*6+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*7+0,y
				sta $3800+high*7+1,y
				sta $3800+high*7+2,y
				sta $3800+high*7+11,y
				sta $3800+high*7+12,y
				sta $3800+high*7+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*7+i		//scrolltext in Mem
				sta $3803+high*7+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*8+0,y
				sta $3800+high*8+1,y
				sta $3800+high*8+2,y
				sta $3800+high*8+11,y
				sta $3800+high*8+12,y
				sta $3800+high*8+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*8+i		//scrolltext in Mem
				sta $3803+high*8+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*9+0,y
				sta $3800+high*9+1,y
				sta $3800+high*9+2,y
				sta $3800+high*9+11,y
				sta $3800+high*9+12,y
				sta $3800+high*9+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*9+i		//scrolltext in Mem
				sta $3803+high*9+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*10+0,y
				sta $3800+high*10+1,y
				sta $3800+high*10+2,y
				sta $3800+high*10+11,y
				sta $3800+high*10+12,y
				sta $3800+high*10+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*10+i		//scrolltext in Mem
				sta $3803+high*10+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*11+0,y
				sta $3800+high*11+1,y
				sta $3800+high*11+2,y
				sta $3800+high*11+11,y
				sta $3800+high*11+12,y
				sta $3800+high*11+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*11+i		//scrolltext in Mem
				sta $3803+high*11+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*12+0,y
				sta $3800+high*12+1,y
				sta $3800+high*12+2,y
				sta $3800+high*12+11,y
				sta $3800+high*12+12,y
				sta $3800+high*12+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*12+i		//scrolltext in Mem
				sta $3803+high*12+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*13+0,y
				sta $3800+high*13+1,y
				sta $3800+high*13+2,y
				sta $3800+high*13+11,y
				sta $3800+high*13+12,y
				sta $3800+high*13+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*13+i		//scrolltext in Mem
				sta $3803+high*13+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*14+0,y
				sta $3800+high*14+1,y
				sta $3800+high*14+2,y
				sta $3800+high*14+11,y
				sta $3800+high*14+12,y
				sta $3800+high*14+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*14+i		//scrolltext in Mem
				sta $3803+high*14+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*15+0,y
				sta $3800+high*15+1,y
				sta $3800+high*15+2,y
				sta $3800+high*15+11,y
				sta $3800+high*15+12,y
				sta $3800+high*15+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*15+i		//scrolltext in Mem
				sta $3803+high*15+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*16+0,y
				sta $3800+high*16+1,y
				sta $3800+high*16+2,y
				sta $3800+high*16+11,y
				sta $3800+high*16+12,y
				sta $3800+high*16+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*16+i		//scrolltext in Mem
				sta $3803+high*16+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*17+0,y
				sta $3800+high*17+1,y
				sta $3800+high*17+2,y
				sta $3800+high*17+11,y
				sta $3800+high*17+12,y
				sta $3800+high*17+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*17+i		//scrolltext in Mem
				sta $3803+high*17+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*18+0,y
				sta $3800+high*18+1,y
				sta $3800+high*18+2,y
				sta $3800+high*18+11,y
				sta $3800+high*18+12,y
				sta $3800+high*18+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*18+i		//scrolltext in Mem
				sta $3803+high*18+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*19+0,y
				sta $3800+high*19+1,y
				sta $3800+high*19+2,y
				sta $3800+high*19+11,y
				sta $3800+high*19+12,y
				sta $3800+high*19+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*19+i		//scrolltext in Mem
				sta $3803+high*19+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*20+0,y
				sta $3800+high*20+1,y
				sta $3800+high*20+2,y
				sta $3800+high*20+11,y
				sta $3800+high*20+12,y
				sta $3800+high*20+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*20+i		//scrolltext in Mem
				sta $3803+high*20+i,y		//dycp charset on screen
				
				}
				inx
				
				ldy sinus,x
				lda #$ff
				sta $3800+high*21+0,y
				sta $3800+high*21+1,y
				sta $3800+high*21+2,y
				sta $3800+high*21+11,y
				sta $3800+high*21+12,y
				sta $3800+high*21+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*21+i		//scrolltext in Mem
				sta $3803+high*21+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*22+0,y
				sta $3800+high*22+1,y
				sta $3800+high*22+2,y
				sta $3800+high*22+11,y
				sta $3800+high*22+12,y
				sta $3800+high*22+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*22+i		//scrolltext in Mem
				sta $3803+high*22+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*23+0,y
				sta $3800+high*23+1,y
				sta $3800+high*23+2,y
				sta $3800+high*23+11,y
				sta $3800+high*23+12,y
				sta $3800+high*23+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*23+i		//scrolltext in Mem
				sta $3803+high*23+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*24+0,y
				sta $3800+high*24+1,y
				sta $3800+high*24+2,y
				sta $3800+high*24+11,y
				sta $3800+high*24+12,y
				sta $3800+high*24+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*24+i		//scrolltext in Mem
				sta $3803+high*24+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*25+0,y
				sta $3800+high*25+1,y
				sta $3800+high*25+2,y
				sta $3800+high*25+11,y
				sta $3800+high*25+12,y
				sta $3800+high*25+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*25+i		//scrolltext in Mem
				sta $3803+high*25+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*26+0,y
				sta $3800+high*26+1,y
				sta $3800+high*26+2,y
				sta $3800+high*26+11,y
				sta $3800+high*26+12,y
				sta $3800+high*26+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*26+i		//scrolltext in Mem
				sta $3803+high*26+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*27+0,y
				sta $3800+high*27+1,y
				sta $3800+high*27+2,y
				sta $3800+high*27+11,y
				sta $3800+high*27+12,y
				sta $3800+high*27+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*27+i		//scrolltext in Mem
				sta $3803+high*27+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*28+0,y
				sta $3800+high*28+1,y
				sta $3800+high*28+2,y
				sta $3800+high*28+11,y
				sta $3800+high*28+12,y
				sta $3800+high*28+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*28+i		//scrolltext in Mem
				sta $3803+high*28+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*29+0,y
				sta $3800+high*29+1,y
				sta $3800+high*29+2,y
				sta $3800+high*29+11,y
				sta $3800+high*29+12,y
				sta $3800+high*29+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*29+i		//scrolltext in Mem
				sta $3803+high*29+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*30+0,y
				sta $3800+high*30+1,y
				sta $3800+high*30+2,y
				sta $3800+high*30+11,y
				sta $3800+high*30+12,y
				sta $3800+high*30+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*30+i		//scrolltext in Mem
				sta $3803+high*30+i,y		//dycp charset on screen
				
				}
				inx
				
				ldy sinus,x
				lda #$ff
				sta $3800+high*31+0,y
				sta $3800+high*31+1,y
				sta $3800+high*31+2,y
				sta $3800+high*31+11,y
				sta $3800+high*31+12,y
				sta $3800+high*31+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*31+i		//scrolltext in Mem
				sta $3803+high*31+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*32+0,y
				sta $3800+high*32+1,y
				sta $3800+high*32+2,y
				sta $3800+high*32+11,y
				sta $3800+high*32+12,y
				sta $3800+high*32+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*32+i		//scrolltext in Mem
				sta $3803+high*32+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*33+0,y
				sta $3800+high*33+1,y
				sta $3800+high*33+2,y
				sta $3800+high*33+11,y
				sta $3800+high*33+12,y
				sta $3800+high*33+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*33+i		//scrolltext in Mem
				sta $3803+high*33+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*34+0,y
				sta $3800+high*34+1,y
				sta $3800+high*34+2,y
				sta $3800+high*34+11,y
				sta $3800+high*34+12,y
				sta $3800+high*34+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*34+i		//scrolltext in Mem
				sta $3803+high*34+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*35+0,y
				sta $3800+high*35+1,y
				sta $3800+high*35+2,y
				sta $3800+high*35+11,y
				sta $3800+high*35+12,y
				sta $3800+high*35+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*35+i		//scrolltext in Mem
				sta $3803+high*35+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*36+0,y
				sta $3800+high*36+1,y
				sta $3800+high*36+2,y
				sta $3800+high*36+11,y
				sta $3800+high*36+12,y
				sta $3800+high*36+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*36+i		//scrolltext in Mem
				sta $3803+high*36+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*37+0,y
				sta $3800+high*37+1,y
				sta $3800+high*37+2,y
				sta $3800+high*37+11,y
				sta $3800+high*37+12,y
				sta $3800+high*37+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*37+i		//scrolltext in Mem
				sta $3803+high*37+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*38+0,y
				sta $3800+high*38+1,y
				sta $3800+high*38+2,y
				sta $3800+high*38+11,y
				sta $3800+high*38+12,y
				sta $3800+high*38+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*38+i		//scrolltext in Mem
				sta $3803+high*38+i,y		//dycp charset on screen
				
				}
				inx
				ldy sinus,x
				lda #$ff
				sta $3800+high*39+0,y
				sta $3800+high*39+1,y
				sta $3800+high*39+2,y
				sta $3800+high*39+11,y
				sta $3800+high*39+12,y
				sta $3800+high*39+13,y
          .for (var i=0; i<8; i++) {
				lda $5300+8*39+i		//scrolltext in Mem
				sta $3803+high*39+i,y		//dycp charset on screen
				
				}
				inx
				
				rts





//----------------------------------------------------------------------------				

.pc = $2000	"1x1char"
charset:  // 1x1char & bigtextlinechar
.byte $00, $00, $00, $00, $00, $00, $00, $00, $c1, $9c, $9c, $80, $9c, $9c, $9c, $9c, $81, $9c, $9c, $81, $9c, $9c, $9c, $81
.byte $c1, $9c, $9f, $9f, $9f, $9f, $9c, $c1, $83, $99, $9c, $9c, $9c, $9c, $99, $83, $c0, $9f, $9f, $83, $9f, $9f, $9f, $c0
.byte $c0, $9f, $9f, $83, $9f, $9f, $9f, $9f, $c1, $9c, $9f, $9f, $98, $9c, $9c, $c1, $9c, $9c, $9c, $80, $9c, $9c, $9c, $9c
.byte $81, $e7, $e7, $e7, $e7, $e7, $e7, $00, $80, $fc, $fc, $fc, $fc, $fc, $9c, $c1, $9c, $9c, $99, $93, $83, $99, $9c, $9c
.byte $9f, $9f, $9f, $9f, $9f, $9f, $9f, $c0, $18, $00, $24, $24, $24, $24, $24, $24, $81, $9c, $9c, $9c, $9c, $9c, $9c, $9c
.byte $c1, $9c, $9c, $9c, $9c, $9c, $9c, $c1, $81, $9c, $9c, $9c, $81, $9f, $9f, $9f, $c1, $9c, $9c, $9c, $9c, $9a, $9c, $c2
.byte $81, $9c, $9c, $9c, $81, $9c, $9c, $9c, $c0, $9f, $9f, $c1, $fc, $fc, $fc, $01, $00, $e7, $e7, $e7, $e7, $e7, $e7, $e7
.byte $1c, $9c, $9c, $9c, $9c, $9c, $9c, $c1, $9c, $9c, $9c, $9c, $9c, $9c, $c9, $e3, $24, $24, $24, $24, $24, $24, $00, $18
.byte $9c, $9c, $9c, $c9, $e3, $c9, $9c, $9c, $3c, $3c, $3c, $99, $c3, $e7, $e7, $e7, $80, $fc, $f9, $f3, $e7, $cf, $9f, $80
.byte $c3, $9f, $9f, $9f, $9f, $9f, $9f, $c3, $ff, $c3, $81, $18, $00, $f0, $81, $c3, $c3, $f9, $f9, $f9, $f9, $f9, $f9, $c3
.byte $e7, $c3, $99, $3c, $e7, $e7, $e7, $e7, $e7, $cf, $9f, $20, $20, $9f, $cf, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
.byte $e3, $e3, $e3, $e3, $e7, $ff, $e7, $e7, $99, $99, $bb, $ff, $ff, $ff, $ff, $ff, $99, $99, $00, $99, $00, $99, $99, $ff
.byte $f7, $c0, $97, $c1, $f6, $f6, $81, $f7, $fe, $9c, $99, $f3, $e7, $cc, $9c, $3f, $c3, $99, $99, $c3, $98, $99, $99, $c0
.byte $f3, $f3, $f7, $ff, $ff, $ff, $ff, $ff, $f1, $e7, $cf, $cf, $cf, $cf, $e7, $f1, $8f, $e7, $f3, $f3, $f3, $f3, $e7, $8f
.byte $ff, $99, $c3, $18, $c3, $99, $ff, $ff, $ff, $e7, $e7, $81, $e7, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e7, $ef
.byte $ff, $ff, $ff, $81, $f1, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e7, $e7, $fe, $fc, $f9, $f3, $e7, $cf, $9f, $3f
.byte $c1, $9c, $9c, $9c, $9c, $9c, $9c, $c1, $f3, $f3, $e3, $f3, $f3, $f3, $f3, $e1, $c1, $9c, $fc, $fc, $c1, $9f, $9f, $80
.byte $c1, $9c, $fc, $e1, $fc, $fc, $9c, $c1, $9c, $9c, $9c, $9c, $c0, $fc, $fc, $fc, $80, $9f, $9f, $80, $fc, $fc, $fc, $81
.byte $c1, $9c, $9f, $81, $9c, $9c, $9c, $c1, $81, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $c1, $9c, $9c, $c1, $9c, $9c, $9c, $c1
.byte $c1, $9c, $9c, $9c, $c0, $fc, $fc, $fc, $ff, $ff, $e7, $e7, $ff, $e7, $e7, $ff, $ff, $ff, $e7, $ff, $ff, $e7, $e7, $ef
.byte $f1, $e7, $cf, $9f, $9f, $cf, $e7, $f1, $ff, $ff, $81, $f1, $ff, $81, $f1, $ff, $8f, $e7, $f3, $f9, $f9, $f3, $e7, $8f
.byte $c1, $9c, $fc, $f1, $e7, $e7, $ff, $e7, $7f, $55, $aa, $00, $00, $3f, $25, $2a, $ff, $95, $9a, $9c, $9f, $95, $9a, $9c
.byte $f3, $62, $a2, $02, $c2, $c2, $c2, $02, $ff, $55, $79, $79, $79, $79, $79, $79, $cf, $c9, $c9, $c9, $c9, $c9, $c9, $c9
.byte $fc, $57, $e7, $e7, $e7, $57, $dc, $e7, $03, $02, $02, $00, $00, $00, $00, $00, $ff, $55, $a6, $27, $27, $27, $27, $27
.byte $ff, $55, $a9, $09, $09, $09, $09, $09, $ff, $e6, $e6, $e6, $e6, $56, $e6, $e6, $ff, $55, $6a, $70, $7f, $57, $6b, $70
.byte $c0, $c0, $c0, $00, $00, $00, $00, $00, $ff, $95, $9e, $9e, $9d, $95, $9d, $9e, $c3, $72, $72, $72, $72, $c2, $72, $72
.byte $ff, $55, $a7, $27, $27, $25, $2a, $00, $ff, $55, $aa, $00, $fc, $5c, $9c, $9c, $ff, $55, $a7, $27, $27, $27, $27, $27
.byte $f0, $70, $f0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $95, $a9, $00, $00, $00, $00, $00, $ff, $55, $aa
.byte $00, $00, $00, $00, $00, $ff, $55, $79, $00, $00, $00, $00, $00, $0f, $c9, $c9, $00, $00, $00, $00, $00, $ff, $56, $e6
.byte $00, $00, $00, $00, $00, $ff, $55, $7d, $9c, $9c, $ac, $00, $00, $cf, $79, $79, $02, $02, $02, $00, $00, $ff, $57, $ab
.byte $79, $55, $aa, $00, $00, $0f, $09, $09, $c9, $c9, $ca, $00, $00, $cf, $c9, $c9, $e7, $e7, $ef, $00, $00, $cf, $c9, $c9
.byte $27, $27, $2b, $00, $00, $ff, $55, $6a, $09, $09, $0a, $00, $00, $ff, $5e, $9e, $e6, $e6, $ea, $00, $00, $f0, $70, $70
.byte $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $c0, $00, $00, $ff, $55, $6a, $9e, $95, $aa, $00, $00, $ff, $79, $79
.byte $72, $72, $82, $00, $00, $ff, $95, $9a, $7f, $55, $aa, $00, $00, $fc, $5c, $ac, $ff, $55, $aa, $00, $00, $0f, $09, $09
.byte $9c, $5c, $ac, $00, $00, $fc, $57, $e7, $27, $27, $2b, $00, $00, $3f, $25, $26, $00, $00, $00, $00, $00, $ff, $55, $6a
.byte $00, $00, $00, $00, $00, $ff, $57, $7f, $00, $00, $00, $00, $00, $0f, $09, $09, $00, $00, $00, $00, $00, $c0, $c0, $c0
.byte $09, $09, $09, $09, $09, $09, $09, $0a, $c2, $c2, $c2, $c2, $c2, $c2, $c2, $c2, $79, $79, $55, $77, $79, $79, $79, $ba
.byte $c9, $c9, $c9, $09, $c9, $c9, $c9, $ca, $e6, $e6, $56, $e6, $e6, $e6, $e6, $ea, $72, $72, $72, $72, $72, $7d, $55, $aa
.byte $79, $79, $79, $79, $79, $79, $79, $8a, $c0, $fc, $5c, $ac, $c0, $ff, $57, $ab, $09, $09, $09, $09, $09, $09, $0a, $02
.byte $c9, $c9, $c9, $c9, $75, $55, $66, $8a, $c9, $c9, $c9, $c9, $c9, $c9, $c9, $0a, $70, $70, $70, $70, $70, $70, $70, $b0
.byte $9e, $95, $9e, $9e, $9e, $9e, $9e, $ae, $02, $02, $02, $02, $02, $02, $02, $02, $72, $72, $72, $72, $72, $72, $72, $b2
.byte $79, $55, $79, $79, $79, $79, $79, $ba, $9c, $9f, $95, $9a, $9c, $9f, $95, $aa, $00, $f0, $70, $b0, $00, $fc, $5c, $ac
.byte $e7, $d7, $5c, $d7, $e7, $e7, $57, $a8, $27, $27, $25, $26, $27, $27, $25, $2a, $02, $f2, $72, $b2, $00, $ff, $55, $aa
.byte $70, $7f, $55, $a9, $09, $f9, $55, $aa, $02, $c2, $c2, $c2, $c2, $c2, $c2, $c2, $09, $09, $09, $09, $0a, $00, $0b, $0a
.byte $c0, $c0, $c0, $c0, $c0, $00, $c0, $c0, $0f, $3d, $25, $25, $27, $27, $27, $27, $3c, $df, $57, $97, $27, $27, $27, $27
.byte $0f, $25, $27, $27, $27, $27, $27, $27, $fc, $57, $a7, $27, $27, $27, $27, $27, $3f, $25, $27, $27, $27, $27, $25, $26
.byte $fc, $57, $f7, $27, $27, $a7, $5c, $a7, $3f, $25, $26, $27, $27, $25, $26, $27, $fc, $5c, $ac, $00, $f0, $70, $b0, $00
.byte $ff, $95, $a9, $09, $09, $09, $09, $09, $fc, $5c, $ac, $c0, $c0, $c0, $c0, $c0, $fc, $9c, $9c, $9c, $9e, $95, $9a, $9c
.byte $fc, $9c, $9c, $9c, $9c, $5c, $9c, $9c, $3f, $95, $9e, $9c, $9e, $95, $9a, $9c, $f0, $5c, $9c, $9c, $9c, $5c, $9c, $9c
.byte $ff, $95, $9e, $9c, $9c, $9c, $9c, $9c, $f0, $5c, $9c, $9c, $9c, $9c, $9c, $9c, $fc, $9c, $9c, $9c, $9c, $9c, $9e, $95
.byte $fc, $9c, $9c, $9c, $9c, $9c, $9c, $5c, $3f, $95, $9e, $9c, $9c, $9c, $9c, $9c, $fc, $9c, $9c, $9c, $9c, $9c, $9c, $9c
.byte $f3, $72, $b2, $02, $c2, $c2, $c2, $00, $ff, $55, $6a, $70, $7f, $55, $a9, $09, $cf, $c9, $c9, $09, $c9, $c9, $c9, $c9
.byte $ff, $57, $ab, $c0, $fc, $5c, $ac, $c0, $3f, $27, $27, $27, $27, $27, $27, $27, $27, $27, $2b, $00, $00, $00, $00, $00
.byte $27, $25, $0a, $00, $00, $00, $00, $00, $f7, $57, $a8, $00, $00, $00, $00, $00, $27, $27, $2f, $00, $00, $00, $00, $00
.byte $27, $25, $2a, $00, $00, $00, $00, $00, $fc, $5c, $ac, $00, $00, $00, $00, $00, $09, $09, $0a, $00, $00, $00, $00, $00
.byte $9c, $9c, $ac, $00, $00, $00, $00, $00, $2a, $00, $00, $00, $00, $00, $00, $00, $9f, $95, $2a, $00, $00, $00, $00, $00
.byte $dc, $5c, $a0, $00, $00, $00, $00, $00, $9f, $95, $aa, $00, $00, $00, $00, $00, $f3, $72, $b2, $00, $00, $00, $00, $00
.byte $f9, $55, $aa, $00, $00, $00, $00, $00, $c9, $c9, $ca, $00, $00, $00, $00, $00, $ff, $57, $ab, $00, $00, $00, $00, $00
.byte $25, $09, $02, $00, $00, $00, $00, $00, $d7, $5c, $a0, $00, $00, $00, $00, $00

