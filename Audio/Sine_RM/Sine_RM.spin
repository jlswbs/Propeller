'' Sine wave ring modulation

CON
  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000

  SAMPLE_RATE   = 200_000
  PIN           = 0

VAR

  long param[2], const, rand, freq1, freq2

PUB main

  const := 21474

  sample_rate_counts := clkfreq / SAMPLE_RATE

  cognew(@sine_entry, @param)
  
   repeat
    
    waitcnt(cnt + clkfreq / 5)

    freq1 := 110 + (?rand // 440)
    param[0] := freq1 * const
    
    freq2 := 220 + (?rand // 880)
    param[1] := freq2 * const

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

              mov       sine_index1, #0
              mov       sine_index2, #0

loop

              rdlong    freq_1, par
              mov       addr, par
              add       addr, #4
              rdlong    freq_2, addr

              add       sine_index1, freq_1
              mov       sin, sine_index1
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #14
              mov       sample1, sin

              add       sine_index2, freq_2
              mov       sin, sine_index2
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #14
              mov       sample2, sin

              mov       temp1, offset_val
              add       sample2, temp1
              sar       sample2, #7
              sar       sample1, #8
              add       sample1, bias_val
              mov       combined_sample, sample1
              shr       combined_sample, #8
              add       combined_sample, sample2
              sar       combined_sample, #1

              waitcnt   timestamp, sample_rate_counts
              mov       frqa, combined_sample
              add       timestamp, sample_rate_counts

              jmp       #loop

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

freq_1                   long    0
freq_2                   long    0

sine_index1             long    0
sine_index2             long    0

dira_val                long    |<PIN
bias_val                long    |<31

offset_val              long    $2000

addr                    res     1
sin                     res     1
sample1                 res     1
sample2                 res     1
combined_sample         res     1
temp1                   res     1