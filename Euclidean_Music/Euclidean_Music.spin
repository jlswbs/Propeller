{{ 

 Euclidean Music Generator

}}

CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

  sound = 0  'audio pin

OBJ

  audio: "pm_synth_20" 
  
VAR

  long steps,hits,nx,ny,tx,ty,rnd

PUB start | i

  audio.start (sound,-1,1)
  
    steps := 4
    hits  := 8

       repeat

           nx := tx
           ny := ty
       
           if ny == 0
          
              tx := rnd?//steps
              ty := hits 
          
           else  
          
              tx := ny
              ty := nx // ny

          audio.prgChange(ny,0)
          audio.prgChange(nx,1)
          
          audio.noteOn(55+3*nx,0,100)
          audio.noteOn(55+3*ny,1,100)
          
          waitcnt (cnt+clkfreq/4)
          
          audio.allOFF
          