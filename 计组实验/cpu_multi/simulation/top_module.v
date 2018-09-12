module top_module(
input wire CLK,
output PCWre,ALUSrcA,ALUSrcB,DBDataSrc,RegWre,
InsMemRW,mRD,mWR,ExtSel,WrRegDSrc,IRWre,
output pc_reset,regfile_reset,
output [1:0] RegDst,
output [1:0] PCSrc,
output [2:0] ALUOp,
output [2:0] state,
output [15:0] immediate16,
output [31:0] immediate32,
output [4:0] sa,
output [5:0] op,
output [4:0] rs,
output [4:0] rt,
output [4:0] rd,
output [31:0] adress,
output [31:0] IDataOut,
output [31:0] reg_writedata,
output [31:0] ram_writedata,
output [31:0] ram_dataout,
output zero,
output [31:0] alu_result,
output [31:0] ReadData1,
output [31:0] ReadData2,
output sign
);
reg clk;
reg rw;
assign InsMemRW = rw;
always @(InsMemRW) begin
    rw = InsMemRW;
end
assign CLK = clk;
assign pc_reset = 1;
assign regfile_reset = 1;
initial begin
    clk=1;
    rw=1;
    // state = 3b'000;
    forever #100 clk=~clk;
end
/*
assign op = IDataOut[31:26];
assign rs = IDataOut[25:21];
assign rt = IDataOut[20:16];
assign rd = IDataOut[15:11];
assign immediate16 = IDataOut[15:0];
assign sa = IDataOut[10:6];
*/
IR ir(CLK,state,IDataOut,op,rs,rt,rd,immediate16,sa);
PC pc(CLK,pc_reset,PCWre,state,PCSrc,immediate32,ReadData1,IDataOut,adress);
RegFile regFile(CLK,regfile_reset,RegWre,RegDst,
DBDataSrc,WrRegDSrc,rs,rt,rd,alu_result,ram_dataout,adress,
state,ReadData1,ReadData2);
RAM ram(CLK,alu_result,ReadData2,mRD,mWR,state,ram_dataout);
IM im(adress,rw,IDataOut);
ALU alu(ALUOp,ReadData1,sa,ReadData2,immediate32,ALUSrcA,ALUSrcB,alu_result,zero,sign);
ControlUnit control(CLK,op,zero,sign,PCWre,ALUSrcA,ALUSrcB,
DBDataSrc,RegWre,WrRegDSrc,InsMemRW,mRD,mWR,IRWre,RegDst,ExtSel,PCSrc,
ALUOp,state);
signZeroExtend extend(ExtSel,immediate16,immediate32);
endmodule