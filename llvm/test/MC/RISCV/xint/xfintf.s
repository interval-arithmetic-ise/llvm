# RUN: llvm-mc %s -triple=riscv32 -mattr=+xfintf -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+xfintf -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+xfintf %s \
# RUN:     | llvm-objdump --mattr=+xfintf -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+xfintf %s \
# RUN:     | llvm-objdump --mattr=+xfintf -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s

# Arithmetic instructions

# CHECK-ASM-AND-OBJ: intadd.s fa0, fa1, fa2
# CHECK-ASM: encoding: [0x43,0xf5,0xc5,0x68]
intadd.s fa0, fa1, fa2
# CHECK-ASM-AND-OBJ: intsub.s fa0, fa1, fa2
# CHECK-ASM: encoding: [0x43,0xf5,0xc5,0x68]
intsub.s fa3, fa4, fa5
# CHECK-ASM-AND-OBJ: intmul.s fa0, fa1, fa2
# CHECK-ASM: encoding: [0x43,0xf5,0xc5,0x68]
intmul.s fa6, fa7, fa0
# CHECK-ASM-AND-OBJ: intdiv.s fa0, fa1, fa2
# CHECK-ASM: encoding: [0x43,0xf5,0xc5,0x68]
intdiv.s fa1, fa2, fa3

# Statistical instructions
; intmid.s fa0, fa2
; intwdt.s fa3, fa6
; intrad.s fa2, fa1
; intmin.s fa7, fa4
; intmax.s fa3, fa6

# Temporal logic instructions
; intbfr.s ft1, ft2, ft3
; intmts.s ft4, ft5, ft6
; intovr.s ft7, ft8, ft9
; intdur.s ft10, ft11, fa1
; intstr.s fa2, fa3, fa5
; intfin.s fa5, fa6, fa7
; inteql.s ft1, fa2, fa3

; 00000 00   rs2 rs1  rm rd 0001011 INTADD.H
; 00001 00   rs2 rs1  rm rd 0001011 INTSUB.H
; 00010 00   rs2 rs1  rm rd 0001011 INTMUL.H
; 00011 00   rs2 rs1  rm rd 0001011 INTDIV.H
; 01000 00 00000 rs1  rm rd 0001011 INTMID.H
; 01001 00 00000 rs1  rm rd 0001011 INTWDT.H
; 01010 00 00000 rs1  rm rd 0001011 INTRAD.H
; 01011 00 00000 rs1  rm rd 0001011 INTMIN.H
; 01100 00 00000 rs1  rm rd 0001011 INTMAX.H
; 10000 00   rs2 rs1 000 rd 0001011 INTBFR.H
; 10001 00   rs2 rs1 000 rd 0001011 INTMTS.H
; 10010 00   rs2 rs1 000 rd 0001011 INTOVR.H
; 10011 00   rs2 rs1 000 rd 0001011 INTDUR.H
; 10100 00   rs2 rs1 000 rd 0001011 INTSTR.H
; 10101 00   rs2 rs1 000 rd 0001011 INTFIN.H
; 10110 00   rs2 rs1 000 rd 0001011 INTEQL.H
