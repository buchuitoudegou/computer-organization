module PC(CLK,reset,PCWre,state,PCSrc,immediate,ReadData1,IDataOut,address);
input CLK,reset;
input PCWre;
input [2:0] state;
input [1:0] PCSrc;
input [31:0] immediate;
input [31:0] ReadData1;
input [31:0] IDataOut;
output [31:0] address;
wire [1:0] PCSrc;
wire PCWre;
reg [31:0] address;
wire [31:0] addressPlu4;
assign addressPlu4 = address + 4;
initial begin
	address <= 0;
end
always @(negedge CLK or negedge reset) begin
	if(reset == 0)
		address <= 0;
	else if(PCWre && state == 3'b000) begin
		case(PCSrc)
			2'b00:
				address <= address + 4;
			2'b01:
				address <= address + 4 + immediate * 4;
			2'b10: begin
				address <= ReadData1;
			end
			2'b11: begin
				address[31:28]<=addressPlu4[31:28];
				address[27:2]<=IDataOut[25:0];
				address[1:0]<=2'b00;
			end
		endcase
	end
end
endmodule