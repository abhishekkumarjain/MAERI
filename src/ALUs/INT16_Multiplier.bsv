/******************************************************************************
Copyright (c) 2018 Georgia Instititue of Technology

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Author: Hyoukjun Kwon (hyoukjun@gatech.edu)

*******************************************************************************/

import Fifo::*;
import INT16::*;

(* synthesize *)
module mkLI_INT16Multiplier(LI_INT16ALU);
  Fifo#(1, INT16) argA <- mkBypassFifo;
  Fifo#(1, INT16) argB <- mkBypassFifo;

  Fifo#(1, INT16) res <- mkBypassFifo;

  rule doMultiplication;
    let operandA = argA.first;
    let operandB = argB.first;
    argA.deq;
    argB.deq;

    ExtendedINT16 extendedA = signExtend(operandA);
    ExtendedINT16 extendedB = signExtend(operandB);

    ExtendedINT16 extendedRes = extendedA * extendedB;

    INT16 resValue = {extendedRes[31], extendedRes[26:24], extendedRes[23:12]};

    res.enq(resValue);
  endrule

  method Action putArgA(INT16 newArg);
    argA.enq(newArg);
  endmethod

  method Action putArgB(INT16 newArg);
    argB.enq(newArg);
  endmethod

  method ActionValue#(INT16) getRes;
    res.deq;
    return res.first;
  endmethod

endmodule


(* synthesize *)
module mkSC_INT16Multiplier(SC_INT16ALU);

  method INT16 getRes(INT16 argA, INT16 argB);

    ExtendedINT16 extendedA = signExtend(argA);
    ExtendedINT16 extendedB = signExtend(argB);

    ExtendedINT16 extendedRes = extendedA * extendedB;

    INT16 resValue = {extendedRes[31], extendedRes[26:24], extendedRes[23:12]};

    return resValue;

  endmethod

endmodule
