module RegFile(
input CLK,
input RST,
input RegWre,
input [1:0] RegDst,
input DBDataSrc,
input WrRegDSrc,
input [4:0] rs,
input [4:0] rt,
input [4:0] rd,
input [31:0] alu_result,
input [31:0] ram_dataout,
input [31:0] address,
input [2:0] state,
output [31:0] ReadData1,
output [31:0] ReadData2
);
reg [31:0] regFile[0:31];
integer i;
reg [4:0] WriteReg;
wire [31:0] WriteData;

assign WriteData = DBDataSrc==0?alu_result:ram_dataout;
initial begin
	WriteReg <= 0;
	for(i=0;i<32;i=i+1)
			regFile[i] <= 0;
end
assign ReadData1 = (rs == 0) ? 0 : regFile[rs];
assign ReadData2 = (rt == 0) ? 0 : regFile[rt];

always @ (negedge CLK or negedge RST) begin
	/*case(RegDst)
		2'b00: WriteReg = 2'h1f;
		2'b01: WriteReg = rt;
		2'b10: WriteReg = rd;
		2'b11: WriteReg = 0;
	endcase*/
	if (RegDst == 2'b00)
		WriteReg = 2'h1f;
	else if (RegDst == 2'b01)
		WriteReg = rt;
	else if (RegDst == 2'b10)
		WriteReg = rd;
	else
		WriteReg = 0;
	if (RST==0) begin
		for(i=1;i<32;i=i+1)
			regFile[i] <= 0;
	end
	else if(RegWre == 1 && WriteReg != 0 && state == 3'b011)
		regFile[WriteReg] <= WriteData;
	else if (RegWre == 1 && state == 3'b001 && RegDst == 2'b00)
		regFile[31] <= address + 4;
end
endmodule