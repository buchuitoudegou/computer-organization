module IR(CLK,state,IDataOut,op,rs,rt,rd,immediate16,sa);
input CLK;
input [2:0] state;
input [31:0] IDataOut;
output [4:0] sa;
output [5:0] op;
output [4:0] rs;
output [4:0] rt;
output [4:0] rd;
output [15:0] immediate16;
wire [31:0] IR;
assign IR = IDataOut;
assign op = IR[31:26];
assign rs = IR[25:21];
assign rt = IR[20:16];
assign rd = IR[15:11];
assign immediate16 = IR[15:0];
assign sa = IR[10:6];

endmodule