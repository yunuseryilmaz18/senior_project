# Auto-generated project tcl file

create_project lowrisc_ibex_top_artya7_100_0.1

set_property part xc7a100tcsg324-1 [current_project]



set_property verilog_define {SRAM_INIT_FILE=../../../../../examples/sw/led/led.vmem } [get_filesets sources_1]
read_verilog -sv ../src/lowrisc_ibex_fpga_xilinx_shared_0/rtl/fpga/xilinx/prim_clock_gating.sv
read_verilog -sv ../src/lowrisc_ibex_fpga_xilinx_shared_0/rtl/fpga/xilinx/clkgen_xil7series.sv
read_verilog -sv ../src/lowrisc_ibex_fpga_xilinx_shared_0/rtl/ram_1p.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_pkg.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_alu.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_compressed_decoder.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_controller.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_cs_registers.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_decoder.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_ex_block.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_fetch_fifo.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_id_stage.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_if_stage.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_load_store_unit.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_multdiv_fast.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_multdiv_slow.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_prefetch_buffer.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_pmp.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_register_file_ff.sv
read_verilog -sv ../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_core.sv
read_verilog -sv ../src/lowrisc_ibex_top_artya7_100_0.1/rtl/top_artya7_100.sv
read_xdc ../src/lowrisc_ibex_top_artya7_100_0.1/data/pins_artya7.xdc

set_property include_dirs [list .] [get_filesets sources_1]
set_property top top_artya7_100 [current_fileset]
set_property source_mgmt_mode None [current_project]
