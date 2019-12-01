{{ 

 Lorenz chaotic sine oscillator

}}

CON
  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000

  SAMPLE_RATE   = 200_000      ' Hz...must be an integer
  
  PIN1 = 0
  PIN2 = 1
  
OBJ

  f:    "Float32"

VAR

  long dt,s,r,b,x,y,z,oldx,oldy,oldz,xn,yn,zn,xnn,ynn,znn
  long freq, const
  
PUB main

   f.start

   const := 21474

   s := 10.0
   r := 28.0 
   b := f.FDiv(8.0,3.0)

   dt := 0.005

   x := 0.0                                  
   y := 1.0
   z := 0.0

   sample_rate_counts := clkfreq / SAMPLE_RATE

   cognew( @sine_entry, @freq )

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

      freq := xnn * const

DAT
org       0

sine_entry
              movs      ctra,#PIN1                
              movd      ctra,#PIN2
              movi      ctra,#%00111_000
              mov       frqa, bias_val
              mov       left, dira_val
              mov       right, dira_val2
              add       left,right
              mov       dira,left
              
              mov       timestamp, sample_rate_counts
              add       timestamp, cnt

:loop
              rdlong    sine_step, par wz 
        if_z  mov       sine_index, #0
        if_nz add       sine_index, sine_step

              mov       sin, sine_index
              shr       sin, #(32 - 13)
              
              call      #getsin

              shl       sin, #15    
              add       sin, bias_val
              waitcnt   timestamp, sample_rate_counts   

              mov       frqa,sin

              jmp       #:loop


getsin
              test      sin, sin_90 wc          'get quadrant 2|4 into c
              test      sin, sin_180 wz         'get quadrant 3|4 into nz
              negc      sin, sin                'if quadrant 2|4, negate offset
              or        sin, sin_table          'or in sin table address >> 1
              shl       sin, #1                 'shift left to get final word address
              rdword    sin, sin                'read word sample from $E000 to $F000
              negnz     sin, sin                'if quadrant 3|4, negate sample
getcos_ret
getsin_ret
              ret                               '39..54 clocks (variance due to HUB sync on RDWORD)
sin_90                  long    $0800
sin_180                 long    $1000
sin_table               long    $E000 >> 1 'sine table base shifted right
                   

{ Timing }
timestamp               long    0
sample_rate_counts      long    0

{ Sine Wave Variables }
sine_index              long    0
sine_step               long    0

left                    long    0
right                   long    0

{ Counters }
dira_val                long    |<PIN1                                          
dira_val2               long    |<PIN2 
bias_val                long    |<31

{ Scratch Values }
sin                     res     0