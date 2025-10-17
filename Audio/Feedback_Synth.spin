'' Feedback synth with filter

CON

  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000
  
  SAMPLE_RATE   = 180_000
  PIN           = 0

VAR

  long param[6], const, rand, basefreq, form1, form2, form3, filt, fb_gain

PUB main

  const := 21474
  sample_rate_counts := clkfreq / SAMPLE_RATE
  cognew(@formant_entry, @param)

  repeat
    waitcnt(cnt + clkfreq / 5)
    basefreq := 80 + (?rand // 200)
    form1 := 600 + (?rand // 300)
    form2 := 1100 + (?rand // 400)
    form3 := 2500 + (?rand // 700)
    filt := 5
    fb_gain := 4

    param[0] := basefreq * const
    param[1] := form1 * const
    param[2] := form2 * const
    param[3] := form3 * const
    param[4] := filt
    param[5] := fb_gain

DAT
org 0

formant_entry
              movs      ctra, #PIN
              movd      ctra, #1
              movi      ctra, #%00111_000
              mov       dira, dira_val
              mov       frqa, bias_val

              mov       timestamp, cnt
              add       timestamp, sample_rate_counts

              mov       exc_phase, #0
              mov       form1_idx, #0
              mov       form2_idx, #0
              mov       form3_idx, #0
              mov       y, bias_val

loop
              mov       addr, par
              rdlong    exc_freq, addr
              add       addr, #4
              rdlong    form1_freq, addr
              add       addr, #4
              rdlong    form2_freq, addr
              add       addr, #4
              rdlong    form3_freq, addr
              add       addr, #4
              rdlong    filt_val, addr
              add       addr, #4
              rdlong    fb_val, addr

              mov       fb, y
              sub       fb, bias_val
              sar       fb, fb_val
              add       exc_phase, fb

              add       exc_phase, exc_freq
              mov       tmp, exc_phase
              shr       tmp, #(32 - 13)
              call      #getsin
              mov       exc, sin
              sar       exc, #2

              add       form1_idx, form1_freq
              add       form2_idx, form2_freq
              add       form3_idx, form3_freq

              mov       combined_sample, #0

              mov       tmp, form1_idx
              shr       tmp, #(32 - 13)
              call      #getsin
              sar       sin, #2
              add       combined_sample, sin

              mov       tmp, form2_idx
              shr       tmp, #(32 - 13)
              call      #getsin
              sar       sin, #3
              add       combined_sample, sin

              mov       tmp, form3_idx
              shr       tmp, #(32 - 13)
              call      #getsin
              sar       sin, #4
              add       combined_sample, sin

              add       combined_sample, exc
              shl       combined_sample, #15
              add       combined_sample, bias_val

              mov       diff, combined_sample
              sub       diff, y
              sar       diff, filt_val
              add       y, diff

              waitcnt   timestamp, sample_rate_counts
              mov       frqa, y
              add       timestamp, sample_rate_counts
              jmp       #loop

getsin
              test      tmp, sin_90 wc
              test      tmp, sin_180 wz
              negc      tmp, tmp
              or        tmp, sin_table
              shl       tmp, #1
              rdword    sin, tmp
              negnz     sin, sin
getsin_ret
              ret

sin_90        long    $0800
sin_180       long    $1000
sin_table     long    $E000 >> 1

timestamp     long    0
sample_rate_counts long 0

exc_phase     long    0
form1_idx     long    0
form2_idx     long    0
form3_idx     long    0
exc_freq      long    0
form1_freq    long    0
form2_freq    long    0
form3_freq    long    0
bias_val      long    |<31
dira_val      long    |<PIN
addr          res     1
tmp           res     1
sin           res     1
exc           res     1
combined_sample res   1
diff          res     1
y             res     1
filt_val      res     1
fb_val        res     1
fb            res     1