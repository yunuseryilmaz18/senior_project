`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2021 09:22:32 AM
// Design Name: 
// Module Name: ROTR32
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


module ROTR32(
    input [31:0] x,
    input [31:0] n,
    output [31:0] result
    );
    
    assign result = (((x) >> (n)) | ((x) << (32 - (n))));
    
endmodule
