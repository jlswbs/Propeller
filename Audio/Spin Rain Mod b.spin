'' Spin Rain
'' ---------
'' (c)2013 Andy Schenk

CON  _clkmode      = xtal1 + pll16x                                    
     _xinfreq      = 5_000_000

     DAC_PIN  = 0

VAR
  long  rndm, lp1, lp2, bp2, sah, lfrt, lowns
       
PUB Main  
  rndm := cnt
  dira[DAC_PIN] := 1                         'Set up DAC
  ctra := %00110 << 26 + DAC_PIN             'counter A in DUTY mode
  
  repeat
    rndm?
    if lfrt-- == 0
      lfrt := (rndm & 511) + 700             'Sample & Hold with random rate
      sah := rndm
    bp2 := (sah/2 - bp2/160 - lp2) + bp2       'BP filter for S&H
    lp2 := bp2/2 + lp2 + sah                   
    lowns += (rndm-lowns) / 5  + rndm/40     'low noise
    lp1 += (rndm~>1-lp1)  /  9               'LP filter for rndm
    frqa := lp1/2 + bp2/3 + lowns/50 + $8000_0000    'mix all
'