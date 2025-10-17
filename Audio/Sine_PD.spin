'' Sine wave phase distortion

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
    
    freq2 := 1 + (?rand // 10)
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

              mov       phase_carrier, #0
              mov       phase_mod, #0

loop

              rdlong    freq_1, par
              mov       addr, par
              add       addr, #4
              rdlong    freq_2, addr

              add       phase_carrier, freq_1
              add       phase_mod, freq_2

              mov       sin, phase_mod
              shr       sin, #(32 - 13)
              call      #getsin
              shl       sin, #12
              mov       mod_signal, sin

              mov       pd_phase, phase_carrier
              shr       pd_phase, #(32 - 13)
              add       pd_phase, mod_signal
              and       pd_phase, phase_mask

              mov       sin, pd_phase
              call      #getsin
              shl       sin, #14
              add       sin, bias_val

              waitcnt   timestamp, sample_rate_counts
              mov       frqa, sin
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

' ---- Konstanty ----
sin_90                  long    $0800
sin_180                 long    $1000
sin_table               long    $E000 >> 1
phase_mask              long    $1FFF

timestamp               long    0
sample_rate_counts      long    0
addr                    long    0

freq_1                  long    0
freq_2                  long    0

phase_carrier           long    0
phase_mod               long    0
mod_signal              long    0
pd_phase                long    0

dira_val                long    |<PIN
bias_val                long    |<31

sin                     res     1