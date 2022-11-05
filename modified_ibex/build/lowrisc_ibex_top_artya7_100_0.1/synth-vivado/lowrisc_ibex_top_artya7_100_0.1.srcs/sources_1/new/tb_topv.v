`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2020 02:56:26 PM
// Design Name: 
// Module Name: tb_topv
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



module tb_top;
    
   
        reg IO_CLK;
        reg IO_RST_N;
        wire[31:0] LED1;
    
        localparam TbPeriod = 10;
    
        top_artya7_100 dut
        (
            IO_CLK, 
            IO_RST_N,
            LED1
        );
    
        // Clock generation
        always
        begin
            IO_CLK = 0;
            #TbPeriod;
            
            IO_CLK = 1;
            #TbPeriod;
        end

        //always #TbPeriod IO_CLK = ! IO_CLK;
        initial
        begin
        
            IO_RST_N = 0;
            #TbPeriod;
            #TbPeriod;
            
            IO_RST_N = 1;
            #TbPeriod;
            #TbPeriod;
            
            
         end

    
endmodule
