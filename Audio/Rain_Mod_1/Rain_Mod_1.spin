'' Modified Spin Rain base a (c)2013 Andy Schenk

CON

  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000
  
  PIN = 0

VAR

  long  rndm, lp1, lp2, bp2, sah, lfrt, lowns
       
PUB Main
  
  rndm := cnt
  dira[PIN] := 1
  ctra := %00110 << 26 + PIN
  
  repeat
  
    rndm?
    
    if lfrt-- == 0
      lfrt := (rndm & 511) + 512
      sah := rndm
      
    bp2 := (sah/5 - bp2/16 - lp2) / 2 + bp2
    lp2 := bp2/2 * lp2                    
    lowns += (rndm-lowns) / 5  + rndm / 32
    lp1 += (rndm~>1-lp1)  /  8

    frqa := lp1/2 + bp2/4 + lowns/50 + $8000_0000