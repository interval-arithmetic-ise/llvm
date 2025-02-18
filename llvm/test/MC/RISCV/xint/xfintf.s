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

# CHECK-ASM-AND-OBJ: intadd.s fa0, fa1, fa2, dyn
# CHECK-ASM: encoding: [0x0b,0xf5,0xc5,0x02]
intadd.s fa0, fa1, fa2
# CHECK-ASM-AND-OBJ: intsub.s fa3, fa4, fa5, dyn
# CHECK-ASM: encoding: [0x8b,0x76,0xf7,0x0a]
intsub.s fa3, fa4, fa5
# CHECK-ASM-AND-OBJ: intmul.s fa6, fa7, fa0, dyn
# CHECK-ASM: encoding: [0x0b,0xf8,0xa8,0x12]
intmul.s fa6, fa7, fa0
# CHECK-ASM-AND-OBJ: intdiv.s fa1, fa2, fa3, dyn
# CHECK-ASM: encoding: [0x8b,0x75,0xd6,0x1a]
intdiv.s fa1, fa2, fa3

# Statistical instructions

# CHECK-ASM-AND-OBJ: intmid.s fa0, fa2, dyn
# CHECK-ASM: encoding: [0x0b,0x75,0x06,0x42]
intmid.s fa0, fa2
# CHECK-ASM-AND-OBJ: intwdt.s fa3, fa6, dyn
# CHECK-ASM: encoding: [0x8b,0x76,0x08,0x4a]
intwdt.s fa3, fa6
# CHECK-ASM-AND-OBJ: intrad.s fa2, fa1, dyn
# CHECK-ASM: encoding: [0x0b,0xf6,0x05,0x52]
intrad.s fa2, fa1
# CHECK-ASM-AND-OBJ: intmin.s fa7, fa4, dyn
# CHECK-ASM: encoding: [0x8b,0x78,0x07,0x5a]
intmin.s fa7, fa4
# CHECK-ASM-AND-OBJ: intmax.s fa3, fa6, dyn
# CHECK-ASM: encoding: [0x8b,0x76,0x08,0x62]
intmax.s fa3, fa6

# Temporal logic instructions

# CHECK-ASM-AND-OBJ: intbfr.s t1, ft2, ft3
# CHECK-ASM: encoding: [0x0b,0x03,0x31,0x82]
intbfr.s t1, ft2, ft3
# CHECK-ASM-AND-OBJ: intmts.s t4, ft5, ft6
# CHECK-ASM: encoding: [0x8b,0x8e,0x62,0x8a]
intmts.s t4, ft5, ft6
# CHECK-ASM-AND-OBJ: intovr.s t6, ft8, ft9
# CHECK-ASM: encoding: [0x8b,0x0f,0xde,0x93]
intovr.s t6, ft8, ft9
# CHECK-ASM-AND-OBJ: intdur.s t2, ft11, fa1
# CHECK-ASM: encoding: [0x8b,0x83,0xbf,0x9a]
intdur.s t2, ft11,fa1
# CHECK-ASM-AND-OBJ: intstr.s a2, fa3, fa5
# CHECK-ASM: encoding: [0x0b,0x86,0xf6,0xa2]
intstr.s a2, fa3, fa5
# CHECK-ASM-AND-OBJ: intfin.s a5, fa6, fa7
# CHECK-ASM: encoding: [0x8b,0x07,0x18,0xab]
intfin.s a5, fa6, fa7
# CHECK-ASM-AND-OBJ: inteql.s t1, fa2, fa3
# CHECK-ASM: encoding: [0x0b,0x03,0xd6,0xb2]
inteql.s t1, fa2, fa3
