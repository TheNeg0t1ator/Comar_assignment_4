module b128bitCounter(clk,out);

input clk;
output reg [127:0] out;

reg [7:0] ct;

always @(posedge clk)
	ct<=ct+1;

always @(posedge clk)
	if(ct==0) out<=out+1;

endmodule
