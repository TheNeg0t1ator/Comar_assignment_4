module b8bitCounter(clk,ctr);

input clk;
output reg [7:0] ctr;


always @(posedge clk)
	ctr<=ctr+1;


endmodule
