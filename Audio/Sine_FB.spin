'' Sine oscillator with feedback

CON

  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000
  SAMPLE_RATE   = 200_000
  PIN = 0

VAR

  long freq, const, rand

PUB main

   const := 21474
   sample_rate_counts := clkfreq / SAMPLE_RATE
   
   cognew(@sine_entry, @freq)
   
   repeat
     waitcnt(cnt + clkfreq / 5)
     freq := (200 + (?rand // 550)) * const

DAT
org 0

sine_entry
              movs      ctra, #PIN
              movd      ctra, #1
              movi      ctra, #%00111_000
              mov       frqa, bias_val
              mov       dira, dira_val

              mov       timestamp, sample_rate_counts
              add       timestamp, cnt

              mov       fb_val, #0

:loop
              rdlong    sine_step, par wz
        if_z  mov       sine_index, #0
        if_nz add       sine_index, sine_step

              mov       tmp, fb_val
              sar       tmp, #9
              add       sine_index, tmp

              mov       sin, sine_index
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #15

              mov       fb_val, sin

              add       sin, bias_val
              waitcnt   timestamp, sample_rate_counts
              mov       frqa, sin
              jmp       #:loop

getsin
              test      sin, sin_90 wc
              test      sin, sin_180 wz
              negc      sin, sin
              or        sin, sin_table
              shl       sin, #1
              rdword    sin, sin
              negnz     sin, sin
getsin_ret
              ret

sin_90                  long    $0800
sin_180                 long    $1000
sin_table               long    $E000 >> 1

timestamp               long    0
sample_rate_counts      long    0
sine_index              long    0
sine_step               long    0
fb_val                  long    0
tmp                     long    0

dira_val                long    |<PIN
bias_val                long    |<31

sin                     res     0