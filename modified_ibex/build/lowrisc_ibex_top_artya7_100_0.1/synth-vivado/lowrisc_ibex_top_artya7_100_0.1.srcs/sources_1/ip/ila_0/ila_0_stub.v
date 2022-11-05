// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Tue Mar 10 23:06:56 2020
// Host        : topalc-S551LB running 64-bit Ubuntu 16.04.6 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/topalc/Desktop/projeler/temiz_ibex/unmodified/build/lowrisc_ibex_top_artya7_100_0.1/synth-vivado/lowrisc_ibex_top_artya7_100_0.1.srcs/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2018.1" *)
module ila_0(clk, probe0, probe1, probe2)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[31:0],probe1[31:0],probe2[31:0]" */;
  input clk;
  input [31:0]probe0;
  input [31:0]probe1;
  input [31:0]probe2;
endmodule
