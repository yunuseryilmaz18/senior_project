// Copyright lowRISC contributors.
// Copyright 2018 ETH Zurich and University of Bologna, see also CREDITS.md.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * Execution stage
 *
 * Execution block: Hosts ALU and MUL/DIV unit
 */
module ibex_ex_block #(
    parameter bit    RV32M                    = 1,
    parameter        MultiplierImplementation = "fast"
) (
    input  logic              clk_i,
    input  logic              rst_ni,
    
    //Custom module
    input logic [31:0] custom_in_RS1_i ,
    input logic [31:0] custom_in_RS2_i ,
    input logic custom_en_i,
    input logic [31:0] ram_data_ex_i, //data coming from RAM
    output logic [31:0] ram_addr_out , //address send to the RAM 
    output logic custom_valid,
    output logic [31:0] custom_data,
    
    // ALU
    input  ibex_pkg::alu_op_e alu_operator_i,
    input  logic [31:0]       alu_operand_a_i,
    input  logic [31:0]       alu_operand_b_i,

    // Multiplier/Divider
    input  ibex_pkg::md_op_e  multdiv_operator_i,
    input  logic              mult_en_i,
    input  logic              div_en_i,
    input  logic  [1:0]       multdiv_signed_mode_i,
    input  logic [31:0]       multdiv_operand_a_i,
    input  logic [31:0]       multdiv_operand_b_i,

    // Outputs
    output logic [31:0]       alu_adder_result_ex_o, // to LSU
    output logic [31:0]       regfile_wdata_ex_o,
    output logic [31:0]       jump_target_o,         // to IF
    output logic              branch_decision_o,     // to ID

    output logic              ex_valid_o             // EX has valid output
);

  import ibex_pkg::*;

  logic [31:0] alu_result, multdiv_result;

  logic [32:0] multdiv_alu_operand_b, multdiv_alu_operand_a;
  logic [33:0] alu_adder_result_ext;
  logic        alu_cmp_result, alu_is_equal_result;
  logic        multdiv_valid, multdiv_en_sel;
  logic        multdiv_en;
  
  logic [31:0] ram_data_ex;
  logic custom_valid_ex;
  logic custom_final;
  logic [31:0] ram_addr_out_k;
  logic [31:0] custom_data_ex;
  logic [31:0] custom_result;
  
  /*
    The multdiv_i output is never selected if RV32M=0
    At synthesis time, all the combinational and sequential logic
    from the multdiv_i module are eliminated
  */
  if (RV32M) begin : gen_multdiv_m
    assign multdiv_en_sel = MultiplierImplementation == "fast" ? div_en_i : mult_en_i | div_en_i;
    assign multdiv_en     = mult_en_i | div_en_i;
  end else begin : gen_multdiv_no_m
    assign multdiv_en_sel = 1'b0;
    assign multdiv_en     = 1'b0;
  end

  assign regfile_wdata_ex_o = custom_en_i ? custom_result: ( multdiv_en ? multdiv_result : alu_result);

    
  assign custom_valid = custom_valid_ex;
  assign custom_data = custom_data_ex;
  assign ram_addr_out = ram_addr_out_k;
  assign ram_data_ex = ram_data_ex_i;

  // branch handling
  assign branch_decision_o  = alu_cmp_result;
  assign jump_target_o      = alu_adder_result_ex_o;
  
  //04.09.2021'de eklendi.
  sboxExtension se0(
      .enable(custom_en_i),
      .clock(clk_i),
      .op_a_i(custom_in_RS1_i),
      .op_b_i(custom_in_RS2_i),
      .ram_data_i(ram_data_ex),
      .write_enable(custom_valid_ex),
      .done(custom_final),
      .ram_addr_o(ram_addr_out_k),
      .ram_data_o(custom_data_ex),
      .result(custom_result)
      );

  /////////
  // ALU //
  /////////

  ibex_alu alu_i (
      .operator_i          ( alu_operator_i            ),
      .operand_a_i         ( alu_operand_a_i           ),
      .operand_b_i         ( alu_operand_b_i           ),
      .multdiv_operand_a_i ( multdiv_alu_operand_a     ),
      .multdiv_operand_b_i ( multdiv_alu_operand_b     ),
      .multdiv_en_i        ( multdiv_en_sel            ),
      .adder_result_o      ( alu_adder_result_ex_o     ),
      .adder_result_ext_o  ( alu_adder_result_ext      ),
      .result_o            ( alu_result                ),
      .comparison_result_o ( alu_cmp_result            ),
      .is_equal_result_o   ( alu_is_equal_result       )
  );

  ////////////////
  // Multiplier //
  ////////////////

  if (MultiplierImplementation == "slow") begin : gen_multdiv_slow
    ibex_multdiv_slow multdiv_i (
        .clk_i              ( clk_i                 ),
        .rst_ni             ( rst_ni                ),
        .mult_en_i          ( mult_en_i             ),
        .div_en_i           ( div_en_i              ),
        .operator_i         ( multdiv_operator_i    ),
        .signed_mode_i      ( multdiv_signed_mode_i ),
        .op_a_i             ( multdiv_operand_a_i   ),
        .op_b_i             ( multdiv_operand_b_i   ),
        .alu_adder_ext_i    ( alu_adder_result_ext  ),
        .alu_adder_i        ( alu_adder_result_ex_o ),
        .equal_to_zero      ( alu_is_equal_result   ),
        .valid_o            ( multdiv_valid         ),
        .alu_operand_a_o    ( multdiv_alu_operand_a ),
        .alu_operand_b_o    ( multdiv_alu_operand_b ),
        .multdiv_result_o   ( multdiv_result        )
    );
  end else if (MultiplierImplementation == "fast") begin : gen_multdiv_fast
    ibex_multdiv_fast multdiv_i (
        .clk_i              ( clk_i                 ),
        .rst_ni             ( rst_ni                ),
        .mult_en_i          ( mult_en_i             ),
        .div_en_i           ( div_en_i              ),
        .operator_i         ( multdiv_operator_i    ),
        .signed_mode_i      ( multdiv_signed_mode_i ),
        .op_a_i             ( multdiv_operand_a_i   ),
        .op_b_i             ( multdiv_operand_b_i   ),
        .alu_operand_a_o    ( multdiv_alu_operand_a ),
        .alu_operand_b_o    ( multdiv_alu_operand_b ),
        .alu_adder_ext_i    ( alu_adder_result_ext  ),
        .alu_adder_i        ( alu_adder_result_ex_o ),
        .equal_to_zero      ( alu_is_equal_result   ),
        .valid_o            ( multdiv_valid         ),
        .multdiv_result_o   ( multdiv_result        )
    );
  end

  // ALU output valid in same cycle, multiplier/divider may require multiple cycles
  assign ex_valid_o = custom_en_i ? custom_final : (multdiv_en ? multdiv_valid : 1'b1);

endmodule
