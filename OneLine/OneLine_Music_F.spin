{{ 

 One Line Music Generator F - VGA

}}

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

  tiles    = vga#xtiles * vga#ytiles
  tiles32  = tiles * 32
  SET_XY   = %00000001
  CLEAR_XY = %00000010
  
  sound = 0

OBJ
  vga : "vga_512x384_bitmap"
  
VAR
  word  colors[tiles]
  long  sync, pixels[tiles32]
  long  graphicCmd
  long  baseAdd
  long  stX
  long  stY
  long width, height, x, y, t
  byte val   

PUB start | i

  vga.start(16, @colors, @pixels, @sync)
   repeat i from 0 to tiles - 1
     colors[i] := %11111100_00000000

   graphicCmd := 99               
   baseAdd := @pixels[0]           
   cognew(@plotDriver,@graphicCmd) 
    repeat while(graphicCmd <> 0)

   DIRA[sound]~~
   CTRA:= %00110 << 26 + 0<<9 + sound

   width  := 255
   height := 383
     
  repeat

    longfill(@pixels,0,tiles32)

    repeat y from 0 to height
        
      repeat x from 0 to width
      
          val := t*(t>>9&t>>13)//(t|t>>9)
   
          FRQA:=(val)<<24
          FRQB:=FRQA

          t++
          
          stX := 2 * val
          stY := y

          graphicCmd := SET_XY

DAT
                        ORG     0
plotDriver              mov     pblock,par
Re_Entry                mov     gCmd, #0
                        wrlong  gCmd, pblock

getCmd                  rdlong  gCmd, pblock wz
           if_z         jmp     #getCmd
                        cmp     gCmd, #SET_XY  wz
           if_e         jmp     #plotXY
                        cmp     gCmd, #CLEAR_XY  wz
           if_e         jmp     #plotXY

                        jmp     #Re_Entry

plotXY                  mov     temp, pblock
                        add     temp,#4
                        rdlong  pixelAdd, temp
                        add     temp,#4
                        rdlong  plotX, temp
                        add     temp,#4
                        rdlong  plotY, temp
                        call    #plotPoint
                        jmp     #Re_Entry

plotPoint
                        mov     temp,plotX
                        mov     pX,plotX
                        mov     pY,plotY
                        shl     plotY,#4
                        shr     plotX,#5
                        add     plotX,plotY
                        shl     plotX,#2
                        mov     calcAdd,pixelAdd
                        add     calcAdd,plotX
                        mov     plotX,temp                      
                        mov     mask, #1
                        shl     mask,plotX                       
                                                       
                        rdlong  temp, calcAdd
                        and     gCmd,#2 wz
           if_z         or      temp,mask
           if_nz        andn    temp,mask
                        wrlong  temp, calcAdd
plotPoint_ret           ret

pblock                  res     1
gCmd                    res     1
pixelAdd                res     1
calcAdd                 res     1
plotX                   res     1
plotY                   res     1
pX                      res     1
pY                      res     1
temp                    res     1
mask                    res     1

                        FIT