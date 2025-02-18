class FmtField<bits<2> val, string suffix> {
  bits<2> Value = val;
  string Suffix = suffix;
}

def FmtFieldH : FmtField<0b00, ".h">;
def FmtFieldS : FmtField<0b01, ".s">;

//===----------------------------------------------------------------------===//
// Instruction base classes
//===----------------------------------------------------------------------===//

class XintInstId {}
class XintArithInstId : XintInstId;
class XintStatsInstId : XintInstId;
class XintTempInstId : XintInstId;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1 in
class XintArithInstBase<bits<5> funct5, FmtField fmt, string opcodestr,
                        DAGOperand rty, bit Commutable = 0>
    : RVInstRFrm<!or(!shl(funct5, 2), fmt.Value), OPC_CUSTOM_0, (outs rty:$rd),
                 (ins rty:$rs1, rty:$rs2, frmarg:$frm),
                 !strconcat(opcodestr, fmt.Suffix), "$rd, $rs1, $rs2$frm"> {
  let isCommutable = Commutable;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1 in
class XintStatsInstBase<bits<5> funct5, FmtField fmt, string opcodestr,
                             DAGOperand rty>
    : RVInstRFrm<!or(!shl(funct5, 2), fmt.Value), OPC_CUSTOM_0, (outs rty:$rd),
                 (ins rty:$rs1, frmarg:$frm), !strconcat(opcodestr, fmt.Suffix),
                 "$rd, $rs1$frm"> {
  let rs2 = 0b00000;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, mayRaiseFPException = 1,
    IsSignExtendingOpW = 1 in
class XintTempInstBase<bits<5> funct5, FmtField fmt, string opcodestr,
                            DAGOperand rty, bit Commutable = 0>
    : RVInstR<!or(!shl(funct5, 2), fmt.Value), 0b000, OPC_CUSTOM_0,
              (outs GPR:$rd), (ins rty:$rs1, rty:$rs2),
              !strconcat(opcodestr, fmt.Suffix), "$rd, $rs1, $rs2"> {
  let isCommutable = Commutable;
}

//===----------------------------------------------------------------------===//
// Instruction multiclasses 
//===----------------------------------------------------------------------===//

multiclass XintArithInst<bits<5> funct5, string opcodestr, bit Commutable = 0> {
  def "" : XintArithInstId;

  let isCommutable = Commutable in {
    let Predicates = [HasCustomXhintf] in
    def _H_FPR : XintArithInstBase<funct5, FmtFieldH, opcodestr, FPR32>;

    let Predicates = [HasCustomXfintf] in
    def _S_FPR : XintArithInstBase<funct5, FmtFieldS, opcodestr, FPR64>;

    let DecoderNamespace = "Xintx" in {
      let Predicates = [HasCustomXhintx] in
      def _H_GPR : XintArithInstBase<funct5, FmtFieldH, opcodestr, FPR32INX>;

      let Predicates = [HasCustomXfintx, IsRV64] in
      def _S_GPR : XintArithInstBase<funct5, FmtFieldS, opcodestr, FPR64INX>;
    }

    // TODO: Add register pairing for Xfintx on RV32.
  }
}

multiclass XintStatsInst<bits<5> funct5, string opcodestr> {
  def "" : XintStatsInstId;

  let Predicates = [HasCustomXhintf] in
  def _H_FPR : XintStatsInstBase<funct5, FmtFieldH, opcodestr, FPR32>;

  let Predicates = [HasCustomXfintf] in
  def _S_FPR : XintStatsInstBase<funct5, FmtFieldS, opcodestr, FPR64>;

  let DecoderNamespace = "Xintx" in {
    let Predicates = [HasCustomXhintx] in
    def _H_GPR : XintStatsInstBase<funct5, FmtFieldH, opcodestr, FPR32INX>;

    let Predicates = [HasCustomXfintx, IsRV64] in
    def _S_GPR : XintStatsInstBase<funct5, FmtFieldS, opcodestr, FPR64INX>;
  }

  // TODO: Add register pairing for Xfintx on RV32.
}

multiclass XintTempInst<bits<5> funct5, string opcodestr, bit Commutable = 0> {
  def "" : XintTempInstId;

  let isCommutable = Commutable in {
    let Predicates = [HasCustomXhintf] in
    def _H_FPR : XintTempInstBase<funct5, FmtFieldH, opcodestr, FPR32>;

    let Predicates = [HasCustomXfintf] in
    def _S_FPR : XintTempInstBase<funct5, FmtFieldS, opcodestr, FPR64>;

    let DecoderNamespace = "Xintx" in {
      let Predicates = [HasCustomXhintx] in
      def _H_GPR : XintTempInstBase<funct5, FmtFieldH, opcodestr, FPR32INX>;

      let Predicates = [HasCustomXfintx, IsRV64] in
      def _S_GPR : XintTempInstBase<funct5, FmtFieldS, opcodestr, FPR64INX>;
    }

    // TODO: Add register pairing for Xfintx on RV32.
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
// Codegen patterns
//===----------------------------------------------------------------------===//

// TODO: Define ops with static FRM modes

class PatXintArithBase<SDPatternOperator OpNode, RVInst Inst, DAGOperand Reg>
    : Pat<(OpNode Reg:$rs1, Reg:$rs2), (Inst Reg:$rs1, Reg:$rs2, FRM_DYN)>;

class PatXintStatsBase<SDPatternOperator OpNode, RVInst Inst, DAGOperand Reg>
    : Pat<(OpNode Reg:$rs1), (Inst Reg:$rs1, FRM_DYN)>;

class PatXintTempBase<SDPatternOperator OpNode, RVInst Inst, DAGOperand Reg>
    : Pat<(OpNode Reg:$rs1, Reg:$rs2), (Inst Reg:$rs1, Reg:$rs2)>;

multiclass PatXintArith<XintArithInstId Inst> {
  defvar lower = !tolower(!cast<string>(Inst));
  defvar upper = !toupper(!cast<string>(Inst));

  defvar intrin_h = !cast<SDPatternOperator>("int_riscv_"#lower#"_h");
  defvar intrin_s = !cast<SDPatternOperator>("int_riscv_"#lower#"_s");

  let Predicates = [HasCustomXhintf] in
  def : PatXintArithBase<intrin_h, !cast<RVInst>(upper#"_H_FPR"), FPR32>;

  let Predicates = [HasCustomXfintf] in
  def : PatXintArithBase<intrin_s, !cast<RVInst>(upper#"_S_FPR"), FPR64>;

  let Predicates = [HasCustomXhintx] in
  def : PatXintArithBase<intrin_h, !cast<RVInst>(upper#"_H_GPR"), FPR32INX>;

  let Predicates = [HasCustomXfintx, IsRV64] in
  def : PatXintArithBase<intrin_s, !cast<RVInst>(upper#"_S_GPR"), FPR64INX>;
}

multiclass PatXintStats<XintStatsInstId Inst> {
  defvar lower = !tolower(!cast<string>(Inst));
  defvar upper = !toupper(!cast<string>(Inst));

  defvar intrin_h = !cast<SDPatternOperator>("int_riscv_"#lower#"_h");
  defvar intrin_s = !cast<SDPatternOperator>("int_riscv_"#lower#"_s");

  let Predicates = [HasCustomXhintf] in
  def : PatXintStatsBase<intrin_h, !cast<RVInst>(upper#"_H_FPR"), FPR32>;

  let Predicates = [HasCustomXfintf] in
  def : PatXintStatsBase<intrin_s, !cast<RVInst>(upper#"_S_FPR"), FPR64>;

  let Predicates = [HasCustomXhintx] in
  def : PatXintStatsBase<intrin_h, !cast<RVInst>(upper#"_H_GPR"), FPR32INX>;

  let Predicates = [HasCustomXfintx, IsRV64] in
  def : PatXintStatsBase<intrin_s, !cast<RVInst>(upper#"_S_GPR"), FPR64INX>;
}

multiclass PatXintTemp<XintTempInstId Inst> {
  defvar lower = !tolower(!cast<string>(Inst));
  defvar upper = !toupper(!cast<string>(Inst));

  defvar intrin_h = !cast<SDPatternOperator>("int_riscv_"#lower#"_h");
  defvar intrin_s = !cast<SDPatternOperator>("int_riscv_"#lower#"_s");

  let Predicates = [HasCustomXhintf] in
  def : PatXintTempBase<intrin_h, !cast<RVInst>(upper#"_H_FPR"), FPR32>;

  let Predicates = [HasCustomXfintf] in
  def : PatXintTempBase<intrin_s, !cast<RVInst>(upper#"_S_FPR"), FPR64>;

  let Predicates = [HasCustomXhintx] in
  def : PatXintTempBase<intrin_h, !cast<RVInst>(upper#"_H_GPR"), FPR32INX>;

  let Predicates = [HasCustomXfintx, IsRV64] in
  def : PatXintTempBase<intrin_s, !cast<RVInst>(upper#"_S_GPR"), FPR64INX>;
}

defm : PatXintArith<INTADD>;
defm : PatXintArith<INTSUB>;
defm : PatXintArith<INTMUL>;
defm : PatXintArith<INTDIV>;

defm : PatXintStats<INTMID>;
defm : PatXintStats<INTWDT>;
defm : PatXintStats<INTRAD>;
defm : PatXintStats<INTMIN>;
defm : PatXintStats<INTMAX>;

defm : PatXintTemp<INTBFR>;
defm : PatXintTemp<INTMTS>;
defm : PatXintTemp<INTOVR>;
defm : PatXintTemp<INTDUR>;
defm : PatXintTemp<INTSTR>;
defm : PatXintTemp<INTFIN>;
defm : PatXintTemp<INTEQL>;
