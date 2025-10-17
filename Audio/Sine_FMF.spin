'' Sine wave frequency modulation with feedback

CON

  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000
  
  SAMPLE_RATE   = 200_000
  PIN           = 0

VAR

  long param[3], const, rand, freq1, freq2, feedback

PUB main
  
  const := 21474

  sample_rate_counts := clkfreq / SAMPLE_RATE

  cognew(@sine_entry, @param)
  
   repeat
    
    waitcnt(cnt + clkfreq / 5)

    freq1 := 220 + (?rand // 440)
    freq2 := 110 + (?rand // 880)
    feedback := 7
    
    param[0] := freq1 * const
    param[1] := freq2 * const
    param[2] := feedback

DAT
              org 0

sine_entry
              movs      ctra, #PIN
              movd      ctra, #1
              movi      ctra, #%00111_000
              mov       dira, dira_val
              mov       frqa, bias_val

              mov       timestamp, sample_rate_counts
              add       timestamp, cnt

              mov       fb_val, #0
              mov       mod_index, #0
              mov       car_index, #0

:loop

              mov       addr, par
              rdlong    freq_1, addr
              add       addr, #4
              rdlong    freq_2, addr
              add       addr, #4
              rdlong    fb_gain, addr

              mov       tmp, fb_val
              sar       tmp, fb_gain

              add       mod_index, freq_2
              mov       sin, mod_index
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #10
              mov       mod_out, sin

              add       car_index, freq_1
              add       car_index, mod_out
              add       car_index, tmp

              mov       sin, car_index
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #15
              mov       out_val, sin

              mov       fb_val, out_val

              add       out_val, bias_val
              waitcnt   timestamp, sample_rate_counts
              mov       frqa, out_val
              add       timestamp, sample_rate_counts

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
addr                    long    0
freq_1                  long    0
freq_2                  long    0
fb_gain                 long    0
mod_index               long    0
car_index               long    0
mod_out                 long    0
fb_val                  long    0
tmp                     long    0
out_val                 long    0
sin                     long    0

dira_val                long    |<PIN
bias_val                long    |<31