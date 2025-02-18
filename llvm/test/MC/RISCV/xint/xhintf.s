# RUN: llvm-mc %s -triple=riscv32 -mattr=+xhintf -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+xhintf -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+xhintf %s \
# RUN:     | llvm-objdump --mattr=+xhintf -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+xhintf %s \
# RUN:     | llvm-objdump --mattr=+xhintf -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s

# Arithmetic instructions

# CHECK-ASM-AND-OBJ: intadd.h fa0, fa1, fa2, dyn
# CHECK-ASM: encoding: [0x0b,0xf5,0xc5,0x00]
intadd.h fa0, fa1, fa2
# CHECK-ASM-AND-OBJ: intsub.h fa3, fa4, fa5, dyn
# CHECK-ASM: encoding: [0x8b,0x76,0xf7,0x08]
intsub.h fa3, fa4, fa5
# CHECK-ASM-AND-OBJ: intmul.h fa6, fa7, fa0, dyn
# CHECK-ASM: encoding: [0x0b,0xf8,0xa8,0x10]
intmul.h fa6, fa7, fa0
# CHECK-ASM-AND-OBJ: intdiv.h fa1, fa2, fa3, dyn
# CHECK-ASM: encoding: [0x8b,0x75,0xd6,0x18]
intdiv.h fa1, fa2, fa3

# Statistical instructions

# CHECK-ASM-AND-OBJ: intmid.h fa0, fa2, dyn
# CHECK-ASM: encoding: [0x0b,0x75,0x06,0x40]
intmid.h fa0, fa2
# CHECK-ASM-AND-OBJ: intwdt.h fa3, fa6, dyn
# CHECK-ASM: encoding: [0x8b,0x76,0x08,0x48]
intwdt.h fa3, fa6
# CHECK-ASM-AND-OBJ: intrad.h fa2, fa1, dyn
# CHECK-ASM: encoding: [0x0b,0xf6,0x05,0x50]
intrad.h fa2, fa1
# CHECK-ASM-AND-OBJ: intmin.h fa7, fa4, dyn
# CHECK-ASM: encoding: [0x8b,0x78,0x07,0x58]
intmin.h fa7, fa4
# CHECK-ASM-AND-OBJ: intmax.h fa3, fa6, dyn
# CHECK-ASM: encoding: [0x8b,0x76,0x08,0x60]
intmax.h fa3, fa6

# Temporal logic instructions

# CHECK-ASM-AND-OBJ: intbfr.h t1, ft2, ft3
# CHECK-ASM: encoding: [0x0b,0x03,0x31,0x80]
intbfr.h t1, ft2, ft3
# CHECK-ASM-AND-OBJ: intmts.h t4, ft5, ft6
# CHECK-ASM: encoding: [0x8b,0x8e,0x62,0x88]
intmts.h t4, ft5, ft6
# CHECK-ASM-AND-OBJ: intovr.h t6, ft8, ft9
# CHECK-ASM: encoding: [0x8b,0x0f,0xde,0x91]
intovr.h t6, ft8, ft9
# CHECK-ASM-AND-OBJ: intdur.h t2, ft1, fa1
# CHECK-ASM: encoding: [0x8b,0x83,0xb0,0x98]
intdur.h t2, ft1, fa1
# CHECK-ASM-AND-OBJ: intstr.h a2, fa3, fa5
# CHECK-ASM: encoding: [0x0b,0x86,0xf6,0xa0]
intstr.h a2, fa3, fa5
# CHECK-ASM-AND-OBJ: intfin.h a5, fa6, fa7
# CHECK-ASM: encoding: [0x8b,0x07,0x18,0xa9]
intfin.h a5, fa6, fa7
# CHECK-ASM-AND-OBJ: inteql.h t1, fa2, fa3
# CHECK-ASM: encoding: [0x0b,0x03,0xd6,0xb0]
inteql.h t1, fa2, fa3
