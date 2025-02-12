class FmtField<bits<2> val, string suffix> {
  bits<2> Value = val;
  string Suffix = suffix;
}

def FmtFieldH : FmtField<0b00, ".h">;
def FmtFieldS : FmtField<0b01, ".s">;

//===----------------------------------------------------------------------===//
// Instruction base classes
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1 in
class XintArithInstBase<bits<5> funct5, FmtField fmt, string opcodestr,
                        DAGOperand rty, bit Commutable = 0>
    : RVInstRFrm<{ funct5, fmt.Value }, OPC_CUSTOM_0, (outs rty:$rd),
                 (ins rty:$rs1, rty:$rs2, frmarg:$frm),
                 !strconcat(opcodestr, fmt.Suffix), "$rd, $rs1, $rs2$frm"> {
  let isCommutable = Commutable;
};

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1 in
multiclass XintStatsInstBase<bits<5> funct5, FmtField fmt, string opcodestr,
                             DAGOperand rty>
         : RVInstRFrm<{ funct5, fmt }, OPC_CUSTOM_0, (outs rty:$rd),
                      (ins rty:$rs1, frmarg:$frm), opcodestr, "$rd, $rs1$frm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1,
    IsSignExtendingOpW = 1 in
multiclass XintTempInstBase<bits<5> funct5, bits<2> fmt, string opcodestr,
                            DAGOperand rty bit Commutable = 0>
         : RVInstR<{ funct5, fmt }, 0b000, OPC_CUSTOM_0, (outs GPR:$rd),
                   (ins rty:$rs1, rty:$rs2), opcodestr, "$rd, $rs1, $rs2"> {
  let isCommutable = Commutable;
}
//===----------------------------------------------------------------------===//
// Instruction multiclasses 
//===----------------------------------------------------------------------===//

multiclass XintArithInst<bits<5> funct5, string opcodestr bit Commutable = 0> {
  let isCommutable = Commutable {
    let Predicates = [HasCustomXhintf] in
    def _H_FPR : XintArithInstBase<funct5, FmtFieldH, opcodestr, FPR32>;

    let Predicates = [HasCustomXfintf] in
    def _S_FPR : XintArithInstBase<funct5, FmtFieldS, opcodestr, FPR64>;

    let Predicates = [HasCustomXhintx] in
    def _H_GPR : XintArithInstBase<funct5, FmtFieldH, opcodestr, FPR32INX>;

    let Predicates = [HasCustomXfintx, IsRV64] in
    def _S_GPR : XintArithInstBase<funct5, FmtFieldS, opcodestr, FPR64INX>;

    // TODO: Add register pairing for Zfintx in RV32.
  }
}

multiclass XintStatsInst<bits<5> funct5, string opcodestr> {
  let Predicates = [HasCustomXhintf] in
  def _H_FPR : XintStatsInstBase<funct5, FmtFieldH, opcodestr, FPR32>;

  let Predicates = [HasCustomXfintf] in
  def _S_FPR : XintStatsInstBase<funct5, FmtFieldS, opcodestr, FPR64>;

  let Predicates = [HasCustomXhintx] in
  def _H_GPR : XintStatsInstBase<funct5, FmtFieldH, opcodestr, FPR32INX>;

  let Predicates = [HasCustomXfintx, IsRV64] in
  def _S_GPR : XintStatsInstBase<funct5, FmtFieldS, opcodestr, FPR64INX>;

  // TODO: Add register pairing for Zfintx in RV32.
}

multiclass XintTempInst<bits<5> funct5, string opcodestr bit Commutable = 0> {
  let isCommutable = Commutable {
    let Predicates = [HasCustomXhintf] in
    def _H_FPR : XintTempInstBase<funct5, FmtFieldH, opcodestr, FPR32>;

    let Predicates = [HasCustomXfintf] in
    def _S_FPR : XintTempInstBase<funct5, FmtFieldS, opcodestr, FPR64>;

    let Predicates = [HasCustomXhintx] in
    def _H_GPR : XintTempInstBase<funct5, FmtFieldH, opcodestr, FPR32INX>;

    let Predicates = [HasCustomXfintx, IsRV64] in
    def _S_GPR : XintTempInstBase<funct5, FmtFieldS, opcodestr, FPR64INX>;

  // TODO: Add register pairing for Zfintx in RV32.
  }
}

//===----------------------------------------------------------------------===//
// Instruction definitions
//===----------------------------------------------------------------------===//

defm INTADD : XintArithInst<0b00000, "intadd", Commutable = 1>;
defm INTSUB : XintArithInst<0b00001, "intsub">;
defm INTMUL : XintArithInst<0b00010, "intmul", Commutable = 1>;
defm INTDIV : XintArithInst<0b00011, "intdiv">;

defm INTMID : XintStatsInst<0b01000, "intmid">;
defm INTWDT : XintStatsInst<0b01001, "intwdt">;
defm INTRAD : XintStatsInst<0b01010, "intrad">;
defm INTMIN : XintStatsInst<0b01011, "intmin">;
defm INTMAX : XintStatsInst<0b01100, "intmax">;

defm INTBFR : XintTempInst<0b10000, "intbfr">;
defm INTMTS : XintTempInst<0b10001, "intmts">;
defm INTOVR : XintTempInst<0b10010, "intovr">; // TODO: Is this commutative?
defm INTDUR : XintTempInst<0b10011, "intdur">;
defm INTSTR : XintTempInst<0b10100, "intstr">;
defm INTFIN : XintTempInst<0b10101, "intfin">;
defm INTEQL : XintTempInst<0b10110, "inteql", Commutable = 1>;

//===----------------------------------------------------------------------===//
// Patterns
//===----------------------------------------------------------------------===//

// Xfintf

// Xhintf

// Xfintx

// Xhintx

//def : Pat<(int_riscv_intadd_s FPR64:$rs1, FPR64:$rs2),
//          (INTADD_S FPR64:$rs1, FPR64:$rs2)>;


