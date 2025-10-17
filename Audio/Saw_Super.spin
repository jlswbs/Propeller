'' Supersaw oscillator 6x

CON

  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000
  
  SAMPLE_RATE   = 200_000
  PIN           = 0

VAR

  long param[2], const, rand, freq, detune, i

PUB main

  const := 21474
  sample_rate_counts := clkfreq / SAMPLE_RATE
  cognew(@saw_entry, @param)

  repeat
  
    waitcnt(cnt + clkfreq / 5)
    
    freq := 220 + (?rand // 880)
    detune := 100
    
    param[0] := freq * const
    param[1] := detune * const

DAT
org 0

saw_entry
              movs      ctra, #PIN
              movd      ctra, #1
              movi      ctra, #%00111_000
              mov       frqa, bias_val
              mov       dira, dira_val
              mov       timestamp, sample_rate_counts
              add       timestamp, cnt
              mov       saw_index0, #0
              mov       saw_index1, #0
              mov       saw_index2, #0
              mov       saw_index3, #0
              mov       saw_index4, #0
              mov       saw_index5, #0

loop
              mov       addr, par
              rdlong    base_freq, addr
              add       addr, #4
              rdlong    detune_val, addr

              mov       freq_0, base_freq
              mov       freq_1, base_freq
              mov       freq_2, base_freq
              mov       freq_3, base_freq
              mov       freq_4, base_freq
              mov       freq_5, base_freq

              sub       freq_0, detune_val
              sub       freq_1, detune_val >> 1
              add       freq_4, detune_val >> 1
              add       freq_5, detune_val

              add       saw_index0, freq_0
              add       saw_index1, freq_1
              add       saw_index2, freq_2
              add       saw_index3, freq_3
              add       saw_index4, freq_4
              add       saw_index5, freq_5

              mov       combined_sample, #0

              mov       tmp, saw_index0
              shr       tmp, #20
              add       combined_sample, tmp

              mov       tmp, saw_index1
              shr       tmp, #20
              add       combined_sample, tmp

              mov       tmp, saw_index2
              shr       tmp, #20
              add       combined_sample, tmp

              mov       tmp, saw_index3
              shr       tmp, #20
              add       combined_sample, tmp

              mov       tmp, saw_index4
              shr       tmp, #20
              add       combined_sample, tmp

              mov       tmp, saw_index5
              shr       tmp, #20
              add       combined_sample, tmp

              shl       combined_sample, #16
              add       combined_sample, bias_val
              waitcnt   timestamp, sample_rate_counts
              mov       frqa, combined_sample
              add       timestamp, sample_rate_counts
              jmp       #loop

timestamp       long    0
sample_rate_counts long 0
base_freq        long    0
detune_val       long    0
freq_0           long    0
freq_1           long    0
freq_2           long    0
freq_3           long    0
freq_4           long    0
freq_5           long    0
saw_index0       long    0
saw_index1       long    0
saw_index2       long    0
saw_index3       long    0
saw_index4       long    0
saw_index5       long    0
tmp              long    0
dira_val         long    |<PIN
bias_val         long    |<31
addr             res     1
combined_sample  res     1