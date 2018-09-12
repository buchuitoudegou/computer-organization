module RAM(
input clk,
input [31:0] address,
input [31:0] writeData,
input RD,
input WR,
input [2:0] state,
output [31:0] Dataout
);
reg [7:0] ram [0:60];
// 读
assign Dataout[7:0] = (RD==1)?ram[address + 3]:8'bz;
assign Dataout[15:8] = (RD==1)?ram[address + 2]:8'bz;
assign Dataout[23:16] = (RD==1)?ram[address + 1]:8'bz;
assign Dataout[31:24] = (RD==1)?ram[address ]:8'bz;
// 写
always@( negedge clk ) begin
	if( WR==1 && state == 3'b100) begin
		ram[address] <= writeData[31:24];
		ram[address+1] <= writeData[23:16];
		ram[address+2] <= writeData[15:8];
		ram[address+3] <= writeData[7:0];
	end
end
endmodule