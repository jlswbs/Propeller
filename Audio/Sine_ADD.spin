'' Additive oscillator 6x

CON

  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000

  SAMPLE_RATE   = 140_000
  PIN           = 0

VAR

  long param[6], const, rand, freq[6], i

PUB main
  
  const := 21474
  sample_rate_counts := clkfreq / SAMPLE_RATE

  cognew(@sine_entry, @param)
  
  repeat
    waitcnt(cnt + clkfreq / 5)
    repeat i from 0 to 5
      freq[i] := 400 + (?rand // 7600)
      param[i] := freq[i] * const

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

              mov       sine_index0, #0
              mov       sine_index1, #0
              mov       sine_index2, #0
              mov       sine_index3, #0
              mov       sine_index4, #0
              mov       sine_index5, #0

loop
              mov       addr, par
              rdlong    freq_0, addr
              add       addr, #4
              rdlong    freq_1, addr
              add       addr, #4
              rdlong    freq_2, addr
              add       addr, #4
              rdlong    freq_3, addr
              add       addr, #4
              rdlong    freq_4, addr
              add       addr, #4
              rdlong    freq_5, addr

              add       sine_index0, freq_0
              add       sine_index1, freq_1
              add       sine_index2, freq_2
              add       sine_index3, freq_3
              add       sine_index4, freq_4
              add       sine_index5, freq_5

              mov       combined_sample, #0

              mov       sin, sine_index0
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #11
              add       combined_sample, sin

              mov       sin, sine_index1
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #11
              add       combined_sample, sin

              mov       sin, sine_index2
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #11
              add       combined_sample, sin

              mov       sin, sine_index3
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #11
              add       combined_sample, sin

              mov       sin, sine_index4
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #11
              add       combined_sample, sin

              mov       sin, sine_index5
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #11
              add       combined_sample, sin

              sar       combined_sample, #0
              add       combined_sample, bias_val

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

freq_0                  long    0
freq_1                  long    0
freq_2                  long    0
freq_3                  long    0
freq_4                  long    0
freq_5                  long    0

sine_index0             long    0
sine_index1             long    0
sine_index2             long    0
sine_index3             long    0
sine_index4             long    0
sine_index5             long    0

dira_val                long    |<PIN
bias_val                long    |<31

addr                    res     1
sin                     res     1
combined_sample         res     1