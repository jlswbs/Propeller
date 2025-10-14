'' Saw oscillator and LP filter

CON
  _clkmode      = xtal1 + pll16x
  _xinfreq      = 5_000_000
  SAMPLE_RATE   = 200_000
  PIN           = 0

VAR

  long param[2], const, rand, freq, filt

PUB main

  const := 21474

  sample_rate_counts := clkfreq / SAMPLE_RATE

  cognew(@saw_entry, @param)
  
   repeat
    
    waitcnt(cnt + clkfreq / 5)

    freq := 110 + (?rand // 880)
    param[0] := freq * const
    
    filt := 50
    param[1] := filt

DAT
              org 0
saw_entry

              movs    ctra, #PIN
              movd    ctra, #1
              movi    ctra, #%00111_000
              mov     dira, dira_mask
              mov     frqa, bias_val

              mov     timestamp, cnt
              add     timestamp, sample_rate_counts
              mov     phase, #0
              mov     y, bias_val            

:loop
              mov     addr, par
              rdlong  phase_inc, addr
              add     addr, #4
              mov     filter_ptr, addr

              mov     addr, par
              rdlong  phase_inc, addr
              add     addr, #4
              mov     filter_ptr, addr

              rdlong  filter_val, filter_ptr

              add     phase, phase_inc
              mov     x, phase
              shr     x, #1
              add     x, bias_val

              mov     diff, x
              sub     diff, y

              mov     temp, filter_val
              shr     temp, #3
              add     temp, #1
              sar     diff, temp

              add     y, diff

              waitcnt timestamp, sample_rate_counts
              mov     frqa, y
              add     timestamp, sample_rate_counts
              jmp     #:loop

'----------------------------------------
phase_inc           long    0
filter_ptr          long    0
sample_rate_counts  long    0

phase               long    0
x                   long    0
y                   long    0
diff                long    0
filter_val          long    0
temp                long    0
addr                long    0
timestamp           long    0

dira_mask           long    |<PIN
bias_val            long    |<31