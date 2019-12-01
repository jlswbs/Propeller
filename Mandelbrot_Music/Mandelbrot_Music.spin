{{ 

 Mandelbrot Music Generator

}}

CON
   _clkmode  = xtal1 + pll16x
   _xinfreq  = 5_000_000

   sound = 0
  
VAR
  long  scale
  long  size
  long xs,ys,xmin,ymin,xmax,ymax
  long p,q,i,x,y,xn,y0,x0 


OBJ

  audio: "pm_synth_20"
  
PUB start | color, t1

  audio.start (sound,-1,1)

  t1 := 0

  xmin := -2500
  ymin := -1500
  xmax := 1500  
  ymax := 1500
  
  xs   := (xmax-xmin)/200
  ys   := (ymax-ymin)/200


  repeat
  
     if y > 158
     
        p := xmin+x*xs
        y := 10
        xn := 0
        x0 := 0
        y0 := 0
        
    y++
    q := ymin+y*ys
     
     repeat x from 0 to 158
     
        p := xmin+x*xs
        xn :=0
        x0 :=0
        y0 :=0
        
         repeat i from 0 to 15
       
           if (xn*xn+y0*y0 > 4_000_000)
           
             quit
          
           xn := (x0+y0)*(x0-y0)/1000+p
           y0 := (x0*y0/500)+q
           x0 := xn
           
           t1++
              
           if i == 12
           
             if t1 > 2000
             
               t1:=0

               audio.prgChange(0,0) 
               audio.noteOn((30+(-30+x)/2),0,100)   
              
          if i == 15
            
              audio.allOFF 
                                           