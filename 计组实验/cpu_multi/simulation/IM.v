module IM(IAddr,RW,IDataOut);
input [31:0] IAddr;
input RW;
output [31:0]IDataOut;
reg [7:0] im [0:100];
initial begin
	$readmemb ("C:/Users/75654/Desktop/cpu_multi/ins_data.txt", im); 
end
assign IDataOut[7:0]= RW == 1 ? im[IAddr+3] : 8'bz;
assign IDataOut[15:8]= RW == 1 ? im[IAddr+2] : 8'bz;
assign IDataOut[23:16]= RW == 1 ? im[IAddr+1] : 8'bz;
assign IDataOut[31:24]= RW == 1 ? im[IAddr] : 8'bz;
endmodule