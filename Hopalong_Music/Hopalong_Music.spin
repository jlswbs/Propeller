{{ 

 Hopalong Music Generator

}}

CON

   _clkmode  = xtal1 + pll16x
   _xinfreq  = 5_000_000

   sound = 0  'audio pin 
  
VAR

  long  scale
  long  size

OBJ

  audio: "pm_synth_20"
  
PUB start | r,s,m, i, j, a, b, c, d, x, y, xz, yz

  audio.start (sound,-1,1)

  scale := 1<<12
  size  := 2
  
  a:=scale*(-55)+500
  b:=scale*(-1)  
  c:=scale*(-42)+500

  x:=scale*0
  y:=scale*0

  repeat
  
    d := d+1
    i := x
    j := y
    r := (b*x)/scale
    r := -x+42*scale
'   r := -x+(b*scale)
    r := r-c
    r := ||r
    m := r//scale
    r := ^^(r/scale)
    r := scale*r+m
    s := x<0
    x := j-(r*s)
    y := a-i

    xz:= 80+((x/size/scale)/2)
    yz:= 60+((y/size/scale))

    audio.prgChange(xz,0)
    audio.prgChange(yz,1)
          
    audio.noteOn(xz,0,100)
    audio.noteOn(yz,1,100)
          
    waitcnt (cnt+clkfreq/4)
          
    audio.allOFF
                                           