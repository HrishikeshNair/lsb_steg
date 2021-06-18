module testbench0();

reg clk;
reg reset;
reg start;
wire done;
wire [7:0] out;
initial begin
    clk = 0;
end

initial begin
    reset = 0; #40
    reset = 1;
end

initial begin
    start = 1;
end

initial begin
    forever #20 clk = ~clk;    
end

embed0 v1(clk, start, reset, done, out);

endmodule