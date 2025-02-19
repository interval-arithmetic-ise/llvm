# RUN: llvm-mc %s -triple=riscv32 -mattr=+xhintx -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+xhintx -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+xhintx %s \
# RUN:     | llvm-objdump --mattr=+xhintx -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+xhintx %s \
# RUN:     | llvm-objdump --mattr=+xhintx -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s

# Arithmetic instructions

# CHECK-ASM-AND-OBJ: intadd.h a0, a2, a4, dyn
# CHECK-ASM: encoding: [0x0b,0x75,0xe6,0x00]
intadd.h a0, a2, a4
# CHECK-ASM-AND-OBJ: intsub.h a2, a4, a6, dyn
# CHECK-ASM: encoding: [0x0b,0x76,0x07,0x09]
intsub.h a2, a4, a6
# CHECK-ASM-AND-OBJ: intmul.h a6, a4, a0, dyn
# CHECK-ASM: encoding: [0x0b,0x78,0xa7,0x10]
intmul.h a6, a4, a0
# CHECK-ASM-AND-OBJ: intdiv.h a2, a6, a4, dyn
# CHECK-ASM: encoding: [0x0b,0x76,0xe8,0x18]
intdiv.h a2, a6, a4

# Statistical instructions

# CHECK-ASM-AND-OBJ: intmid.h a0, a2, dyn
# CHECK-ASM: encoding: [0x0b,0x75,0x06,0x40]
intmid.h a0, a2
# CHECK-ASM-AND-OBJ: intwdt.h a2, a4, dyn
# CHECK-ASM: encoding: [0x0b,0x76,0x07,0x48]
intwdt.h a2, a4
# CHECK-ASM-AND-OBJ: intrad.h a4, a6, dyn
# CHECK-ASM: encoding: [0x0b,0x77,0x08,0x50]
intrad.h a4, a6
# CHECK-ASM-AND-OBJ: intmin.h a6, a4, dyn
# CHECK-ASM: encoding: [0x0b,0x78,0x07,0x58]
intmin.h a6, a4
# CHECK-ASM-AND-OBJ: intmax.h a2, a6, dyn
# CHECK-ASM: encoding: [0x0b,0x76,0x08,0x60]
intmax.h a2, a6

# Temporal logic instructions

# CHECK-ASM-AND-OBJ: intbfr.h t1, t3, t5
# CHECK-ASM: encoding: [0x0b,0x03,0xee,0x81]
intbfr.h t1, t3, t5
# CHECK-ASM-AND-OBJ: intmts.h t3, t5, t1
# CHECK-ASM: encoding: [0x0b,0x0e,0x6f,0x88]
intmts.h t3, t5, t1
# CHECK-ASM-AND-OBJ: intovr.h t1, t3, t5
# CHECK-ASM: encoding: [0x0b,0x03,0xee,0x91]
intovr.h t1, t3, t5
# CHECK-ASM-AND-OBJ: intdur.h t3, t5, a2
# CHECK-ASM: encoding: [0x0b,0x0e,0xcf,0x98]
intdur.h t3, t5, a2
# CHECK-ASM-AND-OBJ: intstr.h a2, a4, a6
# CHECK-ASM: encoding: [0x0b,0x06,0x07,0xa1]
intstr.h a2, a4, a6
# CHECK-ASM-AND-OBJ: intfin.h a4, a6, a4
# CHECK-ASM: encoding: [0x0b,0x07,0xe8,0xa8]
intfin.h a4, a6, a4
# CHECK-ASM-AND-OBJ: inteql.h t1, a2, a4
# CHECK-ASM: encoding: [0x0b,0x03,0xe6,0xb0]
inteql.h t1, a2, a4
