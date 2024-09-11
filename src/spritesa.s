; ----------------------------------------------------------------------
#define wrd .word
#define byt .byte
#define dsb .dsb

; ----------------------------------------------------------------------
_elementSrc   wrd   0
_elementDst   wrd   0
; ----------------------------------------------------------------------
_printElementA
              .(
              lda   _elementSrc
              sta   asrc+1
              lda   _elementSrc+1
              sta   asrc+2

              lda   _elementDst
              sta   adst+1
              lda   _elementDst+1
              sta   adst+2

              ldx   #0
loop          ldy   #0
asrc:loopy    lda   $f00d,y
adst          sta   $f00d,y
              iny
              cpy   #1
              bne   loopy

              clc
              lda   #<40
              adc   adst+1
              sta   adst+1
              lda   #>40
              adc   adst+2
              sta   adst+2

;           @ clc
              lda   #<40
              adc   asrc+1
              sta   asrc+1
              lda   #>40
              adc   asrc+2
              sta   asrc+2

              inx
              cpx   #6
              bne   loop

              rts
              .)

; ----------------------------------------------------------------------
mapx          byt   6
              byt   5
              byt   4
              byt   3
              byt   2
              byt   1
              byt   0

_elementWidth byt   1
_elementHight byt   6
_elementOffset byt  0
; ----------------------------------------------------------------------
_printElementAXOR
              .(
;           @ Load the input element into the target memory registers
              lda   _elementSrc
              sta   xorsprite+1
              sta   xorsprite2+1
              lda   _elementSrc+1
              sta   xorsprite+2
              sta   xorsprite2+2

;           @ Load the source item into the target memory registers
              lda   _elementDst
              sta   xorbg+1
              sta   adst+1
              sta   xorbg2+1
              sta   adst2+1
              lda   _elementDst+1
              sta   xorbg+2
              sta   adst+2
              sta   xorbg2+2
              sta   adst2+2

;           @ Initialization of registers
              ldx   #0
loop          ldy   #0
              txa
              pha

loopy
;           @ Right shift the first byte
xorsprite     lda   $1234,y
              and   #63
              ldx   _elementOffset
rRight        beq   xorbg
              lsr
              dex
              jmp   rRight

xorbg         eor   $1234,y
              ora   #64
adst          sta   $1234,y

;           @ Left shift second byte
              ldx   _elementOffset
              lda   mapx,x
              tax
xorsprite2    lda   $1234,y
              and   #63
              iny
              cpx   #0
rLeft         beq   xorbg2
              asl
              dex
              jmp   rLeft

xorbg2        eor   $1234,y
              and   #63
              ora   #64
adst2         sta   $1234,y


;           @ Check and continue the displacement cycle

              cpy   _elementWidth
              bne   loopy

;           @ Increasing memory addresses
              clc
              lda   #<40
              adc   adst+1
              sta   adst+1
              sta   adst2+1
              bcc   skip1
              inc   adst+2
              inc   adst2+2
              clc
skip1
              lda   #<40
              adc   xorbg+1
              sta   xorbg+1
              sta   xorbg2+1
              bcc   skip2
              inc   xorbg+2
              inc   xorbg2+2
              clc
skip2
              lda   #<40
              adc   xorsprite+1
              sta   xorsprite+1
              sta   xorsprite2+1
              bcc   skip3
              inc   xorsprite+2
              inc   xorsprite2+2
skip3
;           @ Restoring x and checking for the end of the loop
              pla
              tax
              inx
              cpx   _elementHight
              beq   exit
              jmp   loop

exit          rts
              .)
