{{ 

 Gingerbread Music Generator

}}

CON
   _clkmode  = xtal1 + pll16x
   _xinfreq  = 5_000_000

   sound = 0  'audio pin 
  
VAR

  long  scale

OBJ

  audio: "pm_synth_20"
  
PUB start | i, a, x, y, xz, yz

  audio.start (sound,-1,1) 

  scale:=1<<20
  x:=scale*355/113   
  y:=scale*355/113

  repeat
  
    a:=a+1
    i:=x
    x:=scale-y+||x
    y:=i

    xz:= 36+((-(x*10/scale)+90)/2)
    yz:= 24+((-(y*10/scale)+90)/2)

    audio.prgChange(xz,0)
    audio.prgChange(yz,1)
          
    audio.noteOn(xz,0,100)
    audio.noteOn(yz,1,100)
          
    waitcnt (cnt+clkfreq/4)
          
    audio.allOFF
                                           