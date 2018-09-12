module ALU(ALUOp,ReadData1,sa,ReadData2,immediate,ALUSrcA,ALUSrcB,result,zero,sign);
input [2:0] ALUOp;
input [31:0] ReadData1;
input [4:0] sa;
input [31:0] ReadData2;
input [31:0] immediate;
input ALUSrcA,ALUSrcB;
output reg [31:0] result;
output zero;
output sign;
wire [31:0] opA;
wire [31:0] opB;
assign opA = ALUSrcA == 0 ? ReadData1 : {{27{1'b0}},sa[4:0]};
assign opB = ALUSrcB == 0 ? ReadData2 : immediate;
assign zero = result == 0 ? 1 : 0;
assign sign = result > 0 ? 1 : 0;
always @(ALUOp or ReadData1 or sa or ReadData2 or immediate or ALUSrcA or ALUSrcB) begin
	case(ALUOp)
		3'b000:
			result <= opA + opB;
		3'b001:
			result <= opA - opB;
		3'b010:
			result <= opA < opB ? 1: 0;
		3'b011:
			result <= (((opA<opB) && (opA[31] == opB[31] )) ||( ( opA[31] ==1 && opB[31] == 0))) ? 1:0;
		3'b100:
			result <= opB << opA;
			
		3'b101:
			result <= opA | opB;
		3'b110:
			result <= opA & opB;
		3'b111:
			result <= opA ^~ opB;
	endcase
end
endmodule