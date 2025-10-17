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
      lfrt := (rndm & 511) + 700
      sah := rndm
      
    bp2 := (sah/2 - bp2/160 - lp2) + bp2
    lp2 := bp2/2 + lp2 + sah                   
    lowns += (rndm-lowns) / 5  + rndm/40
    lp1 += (rndm~>1-lp1)  /  9

    frqa := lp1/2 + bp2/3 + lowns/50 + $8000_0000