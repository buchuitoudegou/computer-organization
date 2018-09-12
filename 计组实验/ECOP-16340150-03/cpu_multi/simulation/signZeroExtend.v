module signZeroExtend(ExtSel,immediate16,immediate32);
input ExtSel;
input [15:0] immediate16;
output [31:0] immediate32;
assign immediate32 = ExtSel == 0 ? {{16{1'b0}},immediate16} : {{16{immediate16[15]}},immediate16};
endmodule