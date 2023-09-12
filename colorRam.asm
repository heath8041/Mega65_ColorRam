
#import "../Mega65_System/System_Macros.s"
//#import "../Mega65_System/memorymap.asm"

System_BasicUpstart65(main) // autostart macro

*=$2015

main:
  System_Enable2KColorRamInBank0()
  lda #$00
  sta $D020
  sta $D021
  lda #'.'
  jsr fillScreen
loop:
  jsr fillColors
  jmp loop
  //rts

fillScreen:
  ldx #250
!:
  dex
  sta VIC.SCREEN, X  //store whatever is in acc to screen location plus index offset    
  sta VIC.SCREEN + 250, X //cover the next eighth
  sta VIC.SCREEN + 500, X // cover the 3rd 
  sta VIC.SCREEN + 750, X // this starts at $0300 - 24 bytes 
  sta VIC.SCREEN + 1000, X // 
  sta VIC.SCREEN + 1250, X // 
  sta VIC.SCREEN + 1500, X // 
  sta VIC.SCREEN + 1750, X // 
  bne !-    // branch  if x is not zero (falls through after 255 cycles)
  rts             //return to the calling routine


fillColors:
  ldy #250
  lda #$07
!:
  jsr getNextColor
  dey
  sta VIC.COLOR_RAM, y  //store whatever is in acc to screen location plus index offset    
  sta VIC.COLOR_RAM + 250, y //cover the next quarter
  sta VIC.COLOR_RAM + 500, y // cover the 3rd quarter
  sta VIC.COLOR_RAM + 750, y // this starts at $0300 - 24 bytes 
  sta VIC.COLOR_RAM + 1000, y //
  sta VIC.COLOR_RAM + 1250, y //
  sta VIC.COLOR_RAM + 1500, y //
  sta VIC.COLOR_RAM + 1750, y //
  jsr getNextColor
  //dey
  bne !-    // branch  if x is not zero (falls through after 255 cycles)
  rts             //return to the calling routine

getNextColor:
  ldx colorOffset
  cpx #13
  beq !+
  jmp !++
!: 
  ldx #$00
  stx colorOffset
!:
  lda gradientColor, x
  inc colorOffset
  rts

colorOffset:
  .byte $00
 
gradientColor: 
  .byte $01, $07, $0f, $0a, $0c, $04, $0b, $06, $06, $04, $0c, $0a, $03
