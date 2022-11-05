`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2021 08:42:57 PM
// Design Name: 
// Module Name: sbox
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


module sboxExtension(
    input logic enable,
    input logic clock,
    input logic [31:0] op_a_i,
    input logic [31:0] op_b_i,
    input logic [31:0] ram_data_i,
    output logic write_enable,
    output logic done,
    output logic [31:0] ram_addr_o,
    output logic [31:0] ram_data_o,
    output logic [31:0] result
    );
    
    logic [31:0] sbox_in [5:0];
    logic [31:0] sbox_out [4:0];
    logic [3:0] state;
    logic [3:0] nextState;
    logic [31:0] address = 0;
    logic [31:0] addrNext = 0;
    integer count = 0, countNext = 0;
    
    sbox_primitive sp01 (
    .x0(sbox_in[1]),
    .x1(sbox_in[2]),
    .x2(sbox_in[3]),
    .x3(sbox_in[4]),
    .x4(sbox_in[5]),
    .x0_o(sbox_out[0]),
    .x1_o(sbox_out[1]),
    .x2_o(sbox_out[2]),
    .x3_o(sbox_out[3]),
    .x4_o(sbox_out[4]) );
    
    always @(posedge clock) begin
        state <= nextState;
        count <= countNext;
        address <= addrNext;
    end

    always @(*) begin
        case (state)
            0: begin
                addrNext <= op_a_i;
                write_enable <= 0;
                ram_addr_o <= 0;
                ram_data_o <= 0;
                result <= 0;
                done <= 0;
                countNext <= 0;
                if (enable)
                    nextState <= 1;
                else
                    nextState <= 0;
            end
            
            1: begin
               write_enable <= 0;
               ram_data_o <= 0;
               result <= 0;
               done <= 0;
               addrNext <= address;
               if (count < 2) begin
                countNext <= count + 1;
                ram_addr_o <= 0;
                nextState <= 1;
               end
               else if (count < 8) begin
                countNext <= count + 1;
                ram_addr_o <= address + (count-2)*4;
                sbox_in[count-2] <= ram_data_i;
                nextState <= 1;
               end
               else begin
                countNext <= count;
                ram_addr_o <= 0;
                nextState <= 2;
               end
            end
            
            2:begin
               addrNext <= address;
               write_enable <= 0;
               ram_addr_o <= 0;
               ram_data_o <= 0;
               result <= 0;
               done <= 0;
               countNext <= 0;
               nextState <= 3;
            end
            
            3: begin
               write_enable <= 1;
               result <= 0;
               done <= 0;
               addrNext <= address;
               if (count < 5) begin
                ram_addr_o <= address + count*4;
                ram_data_o <= sbox_out[count];
                countNext <= count + 1;
                nextState <= 3;
               end
               else begin
                ram_addr_o <= 0;
                ram_data_o <= 0;
                countNext <= count;
                done <= 1;
                nextState <= 4;
               end
            end
            
            4: begin
                write_enable <= 0;
                countNext <= 0;
                done <= 0;
                ram_addr_o <= 0;
                ram_data_o <= 0;
                result <= 0;
                nextState <= 5;
                addrNext <= address;
            end
            
            default: begin
               addrNext <= 0;
               done <= 0;
               write_enable <= 0;
               ram_addr_o <= 0;
               countNext <= 0;
               ram_data_o <= 0;
               result <= 0;
               nextState <= 0;
            end
        endcase
    end
    
endmodule

module sbox_primitive
(
    input logic [31:0] x0,x1,x2,x3,x4,
    output logic [31:0] x0_o,x1_o, x2_o, x3_o, x4_o
);

logic [31:0] t0, t1, t2, t3, t4;
logic [31:0] x0_temp, x1_temp, x2_temp, x3_temp, x4_temp;

always @(*) begin
    x0_temp = x0;
    x1_temp = x1;
    x2_temp = x2;
    x3_temp = x3;
    x4_temp = x4;
    
    x0_temp ^= x4_temp;
    x4_temp ^= x3_temp;
    x2_temp ^= x1_temp;
    
    t0 = x0_temp;
    t1 = x1_temp;
    t2 = x2_temp;
    t3 = x3_temp;
    t4 = x4_temp;
    
    x0_temp = t0 ^ (~t1 & t2);
    x2_temp = t2 ^ (~t3 & t4);
    x4_temp = t4 ^ (~t0 & t1);
    x1_temp = t1 ^ (~t2 & t3);
    x3_temp = t3 ^ (~t4 & t0);
    
    x1_temp ^= x0_temp;
    x3_temp ^= x2_temp;
    x0_temp ^= x4_temp;
    
    x0_o = x0_temp;
    x1_o = x1_temp;
    x2_o = x2_temp;
    x3_o = x3_temp;
    x4_o = x4_temp;
    
end //Always end

endmodule