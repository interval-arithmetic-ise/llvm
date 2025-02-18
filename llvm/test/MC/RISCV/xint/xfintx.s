# RUN: llvm-mc %s -triple=riscv32 -mattr=+xfintx -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+xfintx -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+xfintx %s \
# RUN:     | llvm-objdump --mattr=+xfintx -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+xfintx %s \
# RUN:     | llvm-objdump --mattr=+xfintx -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s

# Arithmetic instructions

# CHECK-ASM-AND-OBJ: intadd.s a0, a2, a4, dyn
# CHECK-ASM: encoding: [0x0b,0x75,0xe6,0x02]
intadd.s a0, a2, a4
# CHECK-ASM-AND-OBJ: intsub.s a2, a4, a6, dyn
# CHECK-ASM: encoding: [0x0b,0x76,0x07,0x0b]
intsub.s a2, a4, a6
# CHECK-ASM-AND-OBJ: intmul.s a6, a4, a0, dyn
# CHECK-ASM: encoding: [0x0b,0x78,0xa7,0x12]
intmul.s a6, a4, a0
# CHECK-ASM-AND-OBJ: intdiv.s a2, a6, a4, dyn
# CHECK-ASM: encoding: [0x0b,0x76,0xe8,0x1a]
intdiv.s a2, a6, a4

# Statistical instructions

# CHECK-ASM-AND-OBJ: intmid.s a0, a2, dyn
# CHECK-ASM: encoding: [0x0b,0x75,0x06,0x42]
intmid.s a0, a2
# CHECK-ASM-AND-OBJ: intwdt.s a2, a4, dyn
# CHECK-ASM: encoding: [0x0b,0x76,0x07,0x4a]
intwdt.s a2, a4
# CHECK-ASM-AND-OBJ: intrad.s a4, a6, dyn
# CHECK-ASM: encoding: [0x0b,0x77,0x08,0x52]
intrad.s a4, a6
# CHECK-ASM-AND-OBJ: intmin.s a6, a4, dyn
# CHECK-ASM: encoding: [0x0b,0x78,0x07,0x5a]
intmin.s a6, a4
# CHECK-ASM-AND-OBJ: intmax.s a2, a6, dyn
# CHECK-ASM: encoding: [0x0b,0x76,0x08,0x62]
intmax.s a2, a6

# Temporal logic instructions

# CHECK-ASM-AND-OBJ: intbfr.s t1, t3, t5
# CHECK-ASM: encoding: [0x0b,0x03,0xee,0x83]
intbfr.s t1, t3, t5
# CHECK-ASM-AND-OBJ: intmts.s t3, t5, t1
# CHECK-ASM: encoding: [0x0b,0x0e,0x6f,0x8a]
intmts.s t3, t5, t1
# CHECK-ASM-AND-OBJ: intovr.s t1, t3, t5
# CHECK-ASM: encoding: [0x0b,0x03,0xee,0x93]
intovr.s t1, t3, t5
# CHECK-ASM-AND-OBJ: intdur.s t3, t5, a2
# CHECK-ASM: encoding: [0x0b,0x0e,0xcf,0x9a]
intdur.s t3, t5, a2
# CHECK-ASM-AND-OBJ: intstr.s a2, a4, a6
# CHECK-ASM: encoding: [0x0b,0x06,0x07,0xa3]
intstr.s a2, a4, a6
# CHECK-ASM-AND-OBJ: intfin.s a4, a6, a4
# CHECK-ASM: encoding: [0x0b,0x07,0xe8,0xaa]
intfin.s a4, a6, a4
# CHECK-ASM-AND-OBJ: inteql.s t1, a2, a4
# CHECK-ASM: encoding: [0x0b,0x03,0xe6,0xb2]
inteql.s t1, a2, a4
