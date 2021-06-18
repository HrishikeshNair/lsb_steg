`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 23.04.2021 13:07:51
// Design Name:
// Module Name: steg
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module embed0(
input CLK,
input start,
input reset,
output reg done,
output reg [7:0]out
);

reg [15:0]counter;     
//reg [7 : 0] total_memory [0:512 - 1 ];   //has the cover_image hex values
//reg [1 : 0] txt_block[0:512-1];     //has the text that needs to be embedded (440 values)
//reg [7:0] output_memory [0:512 - 1];
/*top u2(.clk(S_AXI_ACLK), .wea(slv_reg1[0]), .ena(slv_reg1[1]), .addra(slv_reg1[5:2]), .dina(slv_reg1[13:6]), .dout(dataout));*/
reg wea1;
reg wea2;
reg wea0;
reg ena1;
reg ena2;
reg ena0;
reg [7:0] dina1;
reg [1:0]dina2;
reg [7:0] dina3;
reg [8:0] addra1;
reg [8:0] addra2;
reg [8:0] addra3;
wire [7:0] dout1;
wire [1:0] dout2;
wire [7:0] dout3;



blk_mem_gen_0 u1(.clka(CLK), .wea(wea1), .ena(ena1),.addra(addra1),.dina(dina1), .douta(dout1));
blk_mem_gen_1 u2(.clka(CLK), .wea(wea2), .ena(ena2),.addra(addra2),.dina(dina2), .douta(dout2));
/*blk_mem_gen_2 u3(.clka(CLK), .wea(wea0), .ena(ena0),.addra(addra3),.dina(dina3), .douta(dout3));*/

/*reading inputs from two brams (for image values and text values)*/
initial ena1 = 1; initial wea1 = 0; initial addra1 = 16'b0; initial dina1 = 8'b0;initial dina2 = 2'b0;
always @(posedge CLK) begin
    if(!reset) begin
        ena1 = 1;
        wea1 = 0;
        addra1 = 16'b0;
        dina1 = 8'b0;
        dina2 = 2'b0;  
    end
    else begin  
        wea1 = 0; addra1 = addra1 + 1; 
    end
end
/*
always @(posedge CLK) begin
if(!wea1)
     total_memory[addra1] = dout1;
end
*/
initial ena2=1; initial wea2=1; initial addra2 = 9'b0;
always @(posedge CLK) begin
    if(!reset) begin
        ena2 = 1;
        wea2 = 0; 
        addra2 = 9'b0;  
    end
    else begin
            wea2 = 0; addra2 = addra2 + 1;
    end
end
/*
always @(posedge CLK) begin
if(!wea2)
    txt_block[addra2] = dout2;
end
*/
//computation
always@(posedge CLK) begin
        out = dout1 ^ ((dout1 % 2) ^ dout2);
end

always @(posedge CLK) begin
    if(!reset)
        counter = 0;
    else 
        counter = counter + 1;
end
//writing output to a bram
initial ena0= 1; initial addra3=0; initial done=0;
always @(posedge CLK) begin
   if(!reset) begin
        ena0 = 1;
        addra3 =  0;  
        wea0 = 0;
    end 
    else begin
        ena0 = 1;
        wea0 = 1;
        addra3 = addra3+1;
    end  
end 
/*always @(posedge CLK) begin
    if(wea0) begin
    //out = output_memory[addra3];
         dina3 = out;   
    end           
end*/

//done signal
always @(posedge CLK) begin
    if(counter>0)
        done = 1; 
    else 
        done = 0;     
end

endmodule
