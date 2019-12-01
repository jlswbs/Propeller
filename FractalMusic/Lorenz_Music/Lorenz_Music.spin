{{ 

 Lorenz Music Generator

}}

CON

  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000

  sound = 0
  
OBJ

  f:     "Float32"
  audio: "pm_synth_20"

VAR

  long dt,s,r,b,x,y,z,oldx,oldy,oldz,xn,yn,zn,xnn,ynn,znn
  long cntr,val1,val2
  
PUB main

   f.start
   audio.start (sound,-1,1)
   
   s := 10.0
   r := 28.0 
   b := f.FDiv(8.0,3.0)

   dt := 0.005

   x := 0.0                                  
   y := 1.0
   z := 0.0
    
   repeat

      oldx := x
      oldy := y
      oldz := z
                                                                         
      xn := f.FMul(s,f.FSub(oldy,oldx))               ' x = s*(y-x)
      yn := f.FSub(f.Fmul(oldx,f.FSub(r,z)),oldy)     ' y = x*(r-z)-y   
      zn := f.FSub(f.FMul(oldx,oldy),f.FMul(b,oldz))  ' z = (x*y)-(b*z)

      x := f.FAdd(x,f.FMul(xn,dt)) 
      y := f.FAdd(y,f.FMul(yn,dt))  
      z := f.FAdd(z,f.FMul(zn,dt))  
      
      xnn := f.FTrunc(f.FMul(x,1000.0))
      ynn := f.FTrunc(f.FMul(y,1000.0))
      znn := f.FTrunc(f.FMul(z,1000.0))
      
      cntr++
      
      val1 := ||(xnn/800)
      val2 := ||(ynn/700)

         if cntr > 120
         
            cntr := 0
            
            audio.prgChange(val1,0)
            audio.prgChange(val2,1)
            
            audio.noteOn(52+val1,0,100)
            audio.noteOn(36+val2,1,100)
            
            waitcnt (cnt+clkfreq/10)
            
            audio.allOFF