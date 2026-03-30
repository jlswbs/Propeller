'' VGA scanline ROL scroller ''

CON
  _clkmode = XTAL1 | PLL16X
  _xinfreq = 5_000_000

  res_x = 400
  res_y = 300
  res_z = 412

  quads = res_x / 4

VAR
  long  frame, scan[quads]

PUB main
  cognew(@driver, @scan)
  cognew(@entry, @frame)

DAT             org     0

driver          jmpret  $, #setup

                mov     dira, mask

vsync           mov     lcnt, #0
                wrlong  lcnt, blnk

                mov     vscl, full
                waitvid sync, #%%0011

                xor     sync, #$0101

                mov     ecnt, #4
                waitvid sync, #%%0011
                djnz    ecnt, #$-1

                xor     sync, #$0101

                mov     ecnt, #23
                waitvid sync, #%%0011
                djnz    ecnt, #$-1

                mov     scnt, #res_y

:loop           call    #prefix
                jmpret  suffix_ret, #emit_0

                call    #prefix
                jmpret  suffix_ret, #emit_1

                djnz    scnt, #:loop

                jmp     #vsync

prefix          mov     vscl, slow
                waitvid sync, #%%2011

                mov     cnt, cnt
                add     cnt, #9{14}+(64 * 4)
                waitcnt cnt, #135

                mov     outa, idle
prefix_ret      ret

suffix          mov     vscl, hs_f
                waitvid sync, #%%02

                mov     vcfg, vcfg_sync
                mov     outa, #0

        if_nc   wrlong  lcnt, blnk
suffix_ret      ret

emit_0          waitcnt cnt, #0

                mov     vcfg, vcfg_norm
                mov     addr, base
                mov     vscl, hvis

                rdlong  pal+$00, addr
                cmp     pal+$00, #%%3210
                add     addr, #4
                rdlong  pal+$01, addr
                cmp     pal+$01, #%%3210
                add     addr, #4
                rdlong  pal+$02, addr
                cmp     pal+$02, #%%3210
                add     addr, #4
                rdlong  pal+$03, addr
                cmp     pal+$03, #%%3210
                add     addr, #4
                rdlong  pal+$04, addr
                cmp     pal+$04, #%%3210
                add     addr, #4
                rdlong  pal+$05, addr
                cmp     pal+$05, #%%3210
                add     addr, #4
                rdlong  pal+$06, addr
                cmp     pal+$06, #%%3210
                add     addr, #4
                rdlong  pal+$07, addr
                cmp     pal+$07, #%%3210
                add     addr, #4
                rdlong  pal+$08, addr
                cmp     pal+$08, #%%3210
                add     addr, #4
                rdlong  pal+$09, addr
                cmp     pal+$09, #%%3210
                add     addr, #4
                rdlong  pal+$0A, addr
                cmp     pal+$0A, #%%3210
                add     addr, #4
                rdlong  pal+$0B, addr
                cmp     pal+$0B, #%%3210
                add     addr, #4
                rdlong  pal+$0C, addr
                cmp     pal+$0C, #%%3210
                add     addr, #4
                rdlong  pal+$0D, addr
                cmp     pal+$0D, #%%3210
                add     addr, #4
                rdlong  pal+$0E, addr
                cmp     pal+$0E, #%%3210
                add     addr, #4
                rdlong  pal+$0F, addr
                cmp     pal+$0F, #%%3210
                add     addr, #4

                rdlong  pal+$10, addr
                cmp     pal+$10, #%%3210
                add     addr, #4
                rdlong  pal+$11, addr
                cmp     pal+$11, #%%3210
                add     addr, #4
                rdlong  pal+$12, addr
                cmp     pal+$12, #%%3210
                add     addr, #4
                rdlong  pal+$13, addr
                cmp     pal+$13, #%%3210
                add     addr, #4
                rdlong  pal+$14, addr
                cmp     pal+$14, #%%3210
                add     addr, #4
                rdlong  pal+$15, addr
                cmp     pal+$15, #%%3210
                add     addr, #4
                rdlong  pal+$16, addr
                cmp     pal+$16, #%%3210
                add     addr, #4
                rdlong  pal+$17, addr
                cmp     pal+$17, #%%3210
                add     addr, #4
                rdlong  pal+$18, addr
                cmp     pal+$18, #%%3210
                add     addr, #4
                rdlong  pal+$19, addr
                cmp     pal+$19, #%%3210
                add     addr, #4
                rdlong  pal+$1A, addr
                cmp     pal+$1A, #%%3210
                add     addr, #4
                rdlong  pal+$1B, addr
                cmp     pal+$1B, #%%3210
                add     addr, #4
                rdlong  pal+$1C, addr
                cmp     pal+$1C, #%%3210
                add     addr, #4
                rdlong  pal+$1D, addr
                cmp     pal+$1D, #%%3210
                add     addr, #4
                rdlong  pal+$1E, addr
                cmp     pal+$1E, #%%3210
                add     addr, #4
                rdlong  pal+$1F, addr
                cmp     pal+$1F, #%%3210
                add     addr, #4

                rdlong  pal+$20, addr
                cmp     pal+$20, #%%3210
                add     addr, #4
                rdlong  pal+$21, addr
                cmp     pal+$21, #%%3210
                add     addr, #4
                rdlong  pal+$22, addr
                cmp     pal+$22, #%%3210
                add     addr, #4
                rdlong  pal+$23, addr
                cmp     pal+$23, #%%3210
                add     addr, #4
                rdlong  pal+$24, addr
                cmp     pal+$24, #%%3210
                add     addr, #4
                rdlong  pal+$25, addr
                cmp     pal+$25, #%%3210
                add     addr, #4
                rdlong  pal+$26, addr
                cmp     pal+$26, #%%3210
                add     addr, #4
                rdlong  pal+$27, addr
                cmp     pal+$27, #%%3210
                add     addr, #4
                rdlong  pal+$28, addr
                cmp     pal+$28, #%%3210
                add     addr, #4
                rdlong  pal+$29, addr
                cmp     pal+$29, #%%3210
                add     addr, #4
                rdlong  pal+$2A, addr
                cmp     pal+$2A, #%%3210
                add     addr, #4
                rdlong  pal+$2B, addr
                cmp     pal+$2B, #%%3210
                add     addr, #4
                rdlong  pal+$2C, addr
                cmp     pal+$2C, #%%3210
                add     addr, #4
                rdlong  pal+$2D, addr
                cmp     pal+$2D, #%%3210
                add     addr, #4
                rdlong  pal+$2E, addr
                cmp     pal+$2E, #%%3210
                add     addr, #4
                rdlong  pal+$2F, addr
                cmp     pal+$2F, #%%3210
                add     addr, #4

                rdlong  pal+$30, addr
                cmp     pal+$30, #%%3210
                add     addr, #4
                rdlong  pal+$31, addr
                cmp     pal+$31, #%%3210
                add     addr, #4
                rdlong  pal+$32, addr
                cmp     pal+$32, #%%3210
                add     addr, #4
                rdlong  pal+$33, addr
                cmp     pal+$33, #%%3210
                add     addr, #4
                rdlong  pal+$34, addr
                cmp     pal+$34, #%%3210
                add     addr, #4
                rdlong  pal+$35, addr
                cmp     pal+$35, #%%3210
                add     addr, #4
                rdlong  pal+$36, addr
                cmp     pal+$36, #%%3210
                add     addr, #4
                rdlong  pal+$37, addr
                cmp     pal+$37, #%%3210
                add     addr, #4
                rdlong  pal+$38, addr
                cmp     pal+$38, #%%3210
                add     addr, #4
                rdlong  pal+$39, addr
                cmp     pal+$39, #%%3210
                add     addr, #4
                rdlong  pal+$3A, addr
                cmp     pal+$3A, #%%3210
                add     addr, #4
                rdlong  pal+$3B, addr
                cmp     pal+$3B, #%%3210
                add     addr, #4
                rdlong  pal+$3C, addr
                cmp     pal+$3C, #%%3210
                add     addr, #4
                rdlong  pal+$3D, addr
                cmp     pal+$3D, #%%3210
                add     addr, #4
                rdlong  pal+$3E, addr
                cmp     pal+$3E, #%%3210
                add     addr,#4
                rdlong  pal+$3F, addr
                cmp     pal+$3F, #%%3210
                add     addr, #4

                rdlong  pal+$40, addr
                cmp     pal+$40, #%%3210
                add     addr, #4
                rdlong  pal+$41, addr
                cmp     pal+$41, #%%3210
                add     addr, #4
                rdlong  pal+$42, addr
                cmp     pal+$42, #%%3210
                add     addr, #4
                rdlong  pal+$43, addr
                cmp     pal+$43, #%%3210
                add     addr, #4
                rdlong  pal+$44, addr
                cmp     pal+$44, #%%3210
                add     addr, #4
                rdlong  pal+$45, addr
                cmp     pal+$45, #%%3210
                add     addr, #4
                rdlong  pal+$46, addr
                cmp     pal+$46, #%%3210
                add     addr, #4
                rdlong  pal+$47, addr
                cmp     pal+$47, #%%3210
                add     addr, #4
                rdlong  pal+$48, addr
                cmp     pal+$48, #%%3210
                add     addr, #4
                rdlong  pal+$49, addr
                cmp     pal+$49, #%%3210
                add     addr, #4
                rdlong  pal+$4A, addr
                cmp     pal+$4A, #%%3210
                add     addr, #4
                rdlong  pal+$4B, addr
                cmp     pal+$4B, #%%3210
                add     addr, #4
                rdlong  pal+$4C, addr
                cmp     pal+$4C, #%%3210
                add     addr, #4
                rdlong  pal+$4D, addr
                cmp     pal+$4D, #%%3210
                add     addr, #4
                rdlong  pal+$4E, addr
                cmp     pal+$4E, #%%3210
                add     addr, #4
                rdlong  pal+$4F, addr
                cmp     pal+$4F, #%%3210
                add     addr, #4

                rdlong  pal+$50, addr
                cmp     pal+$50, #%%3210
                add     addr, #4
                rdlong  pal+$51, addr
                cmp     pal+$51, #%%3210
                add     addr, #4
                rdlong  pal+$52, addr
                cmp     pal+$52, #%%3210
                add     addr, #4
                rdlong  pal+$53, addr
                cmp     pal+$53, #%%3210
                add     addr, #4
                rdlong  pal+$54, addr
                cmp     pal+$54, #%%3210
                add     addr, #4
                rdlong  pal+$55, addr
                cmp     pal+$55, #%%3210
                add     addr, #4
                rdlong  pal+$56, addr
                cmp     pal+$56, #%%3210
                add     addr, #4
                rdlong  pal+$57, addr
                cmp     pal+$57, #%%3210
                add     addr, #4
                rdlong  pal+$58, addr
                cmp     pal+$58, #%%3210
                add     addr, #4
                rdlong  pal+$59, addr
                cmp     pal+$59, #%%3210
                add     addr, #4
                rdlong  pal+$5A, addr
                cmp     pal+$5A, #%%3210
                add     addr, #4
                rdlong  pal+$5B, addr
                cmp     pal+$5B, #%%3210
                add     addr, #4
                rdlong  pal+$5C, addr
                cmp     pal+$5C, #%%3210
                add     addr, #4
                rdlong  pal+$5D, addr
                cmp     pal+$5D, #%%3210
                add     addr, #4
                rdlong  pal+$5E, addr
                cmp     pal+$5E, #%%3210
                add     addr, #4
                rdlong  pal+$5F, addr
                cmp     pal+$5F, #%%3210
                add     addr, #4

                rdlong  pal+$60, addr
                cmp     pal+$60, #%%3210
                add     addr, #4
                rdlong  pal+$61, addr
                cmp     pal+$61, #%%3210
                add     addr, #4
                rdlong  pal+$62, addr
                cmp     pal+$62, #%%3210
                add     addr, #4
                rdlong  pal+$63, addr
                cmp     pal+$63, #%%3210
                add     lcnt, #1

                jmpret  $, #suffix wc,nr

emit_1          waitcnt cnt, #0

                mov     vcfg, vcfg_norm
                movd    :vid, #pal+$00
                mov     vscl, hvis

                mov     ecnt, #100 -1
                test    $, #1 wc
:vid            cmp     0-0, #%%3210
                addx    $-1, #511{+C}
                djnz    ecnt, #:vid -1

                cmp     pal+$63, #%%3210

                jmpret  zero, #suffix wc,nr

idle            long    (hv_idle & $00FF) << (sgrp * 8)
sync            long    (hv_idle ^ $0200)  & $FFFF

hvis            long     1 << 12 | 4
hs_f            long     1 << 12 | 20
slow            long    32 << 12 | 108
full            long    32 << 12 | 528

vcfg_norm       long    %0_01_1_00_000 << 23 | vgrp << 9 | vpin
vcfg_sync       long    %0_01_1_00_000 << 23 | sgrp << 9 | %11

mask            long    vpin << (vgrp * 8) | %11 << (sgrp * 8)

blnk            long    -4
base            long    +0

setup           rdlong  cnt, #0

                add     blnk, par
                neg     href, cnt
                add     base, par

                movi    ctra, #%0_00001_101
                movi    frqa, #%0001_00000

                mov     vscl, hvis
                mov     vcfg, vcfg_sync

                shr     cnt, #10
                add     cnt, cnt
                waitcnt cnt, #0

                waitvid zero, #0
                waitvid zero, #0

                add     href, cnt
                shr     href, #2
                neg     href, href
                and     href, #%11

                add     vscl, href
                waitvid zero, #0
                sub     vscl, href
                waitvid zero, #0

                jmp     %%0

                org     setup

href            res     1

ecnt            res     1
lcnt            res     1
scnt            res     1
addr            res     1

pal             res     100

tail            fit

CON
  zero    = $1F0
  vpin    = $0FC
  vgrp    = 2
  sgrp    = 2
  hv_idle = $01010101 * %00

DAT
                org     0

entry           mov     blnk_ptr, par
                mov     base_ptr, par           
                add     base_ptr, #4
                mov     offset, #0              

main_loop       

wait_vbl        rdlong  current, blnk_ptr
                cmp     current, #0 wz
        if_ne   jmp     #wait_vbl

                mov     y_coord, #0             

line_loop       mov     addr2, base_ptr
                mov     x_coord, #0
                mov     count, #quads           

pixel_gen       mov     temp_a, x_coord
                add     temp_a, offset
                and     temp_a, y_coord
                rol     temp_a, offset
                
                mov     pixel_data, temp_a
                shl     pixel_data, #8
                or      pixel_data, temp_a
                mov     temp_x, pixel_data
                shl     temp_x, #16
                or      pixel_data, temp_x

                wrlong  pixel_data, addr2
                add     addr2, #4
                add     x_coord, #4             
                djnz    count, #pixel_gen       

                add     y_coord, #2
                cmp     y_coord, #res_z wc
        if_c    jmp     #line_loop

                add     offset, #1
   
                jmp     #main_loop              

blnk_ptr        res     1
base_ptr        res     1
current         res     1
y_coord         res     1
x_coord         res     1
pixel_data      res     1
count           res     1
temp_a          res     1
temp_x          res     1
addr2           res     1
offset          res     1

                fit