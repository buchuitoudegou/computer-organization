module ControlUnit(clk,op,zero,sign,PCWre,ALUSrcA,ALUSrcB,DBDataSrc,RegWre,
WrRegDSrc,InsMemRW,mRD,mWR,IRWre,RegDst,ExlSel,PCSrc,ALUOp,state);
input clk;
input [5:0] op;
input zero;
input sign;
output reg PCWre,ALUSrcA,ALUSrcB,DBDataSrc,RegWre,InsMemRW,mRD,mWR,
ExlSel,WrRegDSrc,IRWre;
output reg [1:0] RegDst;
output reg [1:0] PCSrc;
output reg [2:0] ALUOp;
output reg [2:0] state;
reg [2:0] next_state;
wire add, sub, addi, _or, _and, _ori, sll, slt, sltiu, sw, lw, beq, bltz, j, jr,
jal, halt;
assign add = (op == 6'b000000) ? 1 : 0;
assign sub = (op == 6'b000001) ? 1 : 0;
assign addi = (op == 6'b000010) ? 1 : 0;
assign _or = (op == 6'b010000) ? 1 : 0;
assign _and = (op == 6'b010001) ? 1 : 0;
assign _ori = (op == 6'b010010) ? 1 : 0;
assign sll = (op == 6'b011000) ? 1 : 0;
assign slt = (op == 6'b100110) ? 1 : 0;
assign sltiu = (op == 6'b100111) ? 1 : 0;
assign sw = (op == 6'b110000) ? 1 : 0;
assign lw = (op == 6'b110001) ? 1 : 0;
assign beq = (op == 6'b110100) ? 1 : 0;
assign bltz = (op == 6'b110110) ? 1 : 0;
assign j = (op == 6'b111000) ? 1 : 0;
assign jr = (op == 6'b111001) ? 1 : 0;
assign jal = (op == 6'b111010) ? 1 : 0;
assign halt = (op == 6'b111111) ? 1 : 0;

initial begin
  PCWre = 0;
  ALUSrcA = 0;
  ALUSrcB = 0;
  ALUOp = 3'b000;
  DBDataSrc = 0;
  RegWre = 0;
  InsMemRW = 0;
  mRD = 0;
  mWR = 0;
  RegDst = 0;
  ExlSel = 0;
  WrRegDSrc = 0;
  IRWre = 0;
  PCSrc = 2'b00;
  state = 3'b000;
  next_state = 3'b001;
end
always @(posedge clk) begin
    state <= next_state;
end
always @(state or op) begin
  case(state)
    3'b000: next_state = 3'b001;
	3'b001: begin
	  if (add || sub || addi || _or || _and || _ori || sll || slt || sltiu || beq
	  || bltz || sw || lw) begin
	    next_state = 3'b010;
	  end
	  else begin
	    next_state = 3'b000;
	  end
	end
	3'b010: begin
	  if (beq || bltz) begin
	  	next_state = 3'b000;
	  end
	  else if (sw || lw) begin
	  	next_state = 3'b100;
	  end
	  else begin
	  	next_state = 3'b011;
	  end
	end
	3'b011: next_state = 3'b000;
	3'b100: begin
	  if (lw) begin
	    next_state = 3'b011;
	  end
	  else begin
	  	next_state = 3'b000;
	  end
	end
  endcase
end
always @(state) begin
  if (state == 3'b000 && !halt) begin
    PCWre = 1;
	  IRWre = 1;
  end
  else 
    PCWre = 0;
  InsMemRW = 1;
  if (add || sub || addi || _or || _and || _ori || beq || bltz || slt || sltiu || sw || lw)
    ALUSrcA = 0;
  else 
    ALUSrcA = 1;
  if (add || sub || _or || _and || beq || bltz || slt || sll) 
    ALUSrcB = 0;
  else
    ALUSrcB = 1;
  if (add || addi || sub || _or || _and || _ori || slt || sltiu || sll)
	  DBDataSrc = 0;
  else 
	DBDataSrc = 1;
  if (beq || bltz || j || sw || jr || halt)
    RegWre = 0;
  else 
	RegWre = 1;
  if (jal)
    WrRegDSrc = 0;
  else 
	WrRegDSrc = 1;
  if (lw)
    mRD = 1;
  else 
    mRD = 0;
  if (sw)
    mWR = 1;
  else
    mWR = 0;
  if (_ori || sltiu)
    ExlSel = 0;
  else
    ExlSel = 1;
  if (add || addi || sub || _or || _ori || _and || slt || sltiu || sll || sw || lw)
    PCSrc = 2'b00;
  else if ((beq && zero == 0) || (bltz && zero == 1) || (bltz && sign == 0))
	  PCSrc = 2'b00;
  else if ((beq && zero == 1) || (bltz && zero == 0) || (bltz && sign == 1))
	  PCSrc = 2'b01;
  else if (jr)
	  PCSrc = 2'b10;
  else if(j || jal)
    PCSrc = 2'b11;
  if (jal)
    RegDst = 2'b00;
  else if (addi || _ori || sltiu || lw)
    RegDst = 2'b01;
  else if (add || sub || _or | _and || slt || sll)
    RegDst = 2'b10;
  else
    RegDst = 2'b11;
  if (add || addi || lw || sw)
    ALUOp = 3'b000;
  else if (sub || beq || bltz)
    ALUOp = 3'b001;
  else if (sltiu)
    ALUOp = 3'b010;
  else if (slt)
    ALUOp = 3'b011;
  else if (sll)
	  ALUOp = 3'b100;
  else if (_or || _ori)
    ALUOp = 3'b101;
  else if (_and)
    ALUOp = 3'b110;
  else
    ALUOp = 3'b111;
end
endmodule