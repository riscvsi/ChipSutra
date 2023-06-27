

proc padInsertion {} {
set padi "PADI"
set pado "PADO"
set padio "PADIO"
set cornerpad "PADCORNER"

foreach_in_collection port [get_ports * -filter "direction == in"] {
## methadology team should complete it
	#if size of collection of get_pin 
	if {[sizeof_collection [get_pins -of [get_nets -of [get_ports $port]]]] > 0} {
	    set pPort [get_object_name $port]
	    puts "create_inst -name pad_i_[get_object_name $port] -base_cell ${padi}"
	    create_inst -name pad_i_[get_object_name $port] -base_cell ${padi}
	    puts "in pad cell created cell pad_i_${pPort}"
	    set conPins [get_pins -of [get_nets $port]]
	    set conPins [add_to_collection [get_pins $conPins] [get_pins pad_i_${pPort}/OUT]]
	    puts "connected [get_object_name [get_pins $conPins]] with net name rcg_${pPort}_conNet"
	    puts "connect [get_pins $conPins] -net_name rcg_${pPort}_conNet"
	    #connect [get_pins $conPins] -net_name rcg_${pPort}_conNet
		    create_net rcg_${pPort}_conNet
	    foreach_in_collection pins [get_pins $conPins] {
		connect_pin -inst [get_object_name [get_cells -of $pins]] -pin [file tail [get_object_name $pins]] -net rcg_${pPort}_conNet
	    }
	 #   connect  [get_pins pad_i_${pPort}/PAD] -net $pPort
	    puts "connected  pad_i_${pPort}/PAD with ${pPort}"
	    puts "connect_pin -inst pad_i_${pPort} -pin PAD -net $pPort"
	    connect_pin -inst pad_i_${pPort} -pin PAD -net $pPort
    }
}

puts "\n\n\n"
foreach_in_collection port [get_ports * -filter "direction == out"] {

    set pPort [get_object_name $port]
   puts "create_inst -name pad_o_[get_object_name $port] -base_cell ${pado}"
   create_inst -name pad_o_[get_object_name $port] -base_cell ${pado}
   puts "out pad cell created cell pad_o_${pPort}"
   set conPins [get_pins -of [get_nets $port]]
   set conPins [add_to_collection [get_pins $conPins] [get_pins pad_o_${pPort}/IN]]
   puts "connected [get_object_name [get_pins $conPins]] with net name rcg_${pPort}_conNet"
   puts "connect [get_pins $conPins] -net_name rcg_${pPort}_conNet"
   connect [get_pins $conPins] -net_name rcg_${pPort}_conNet
#   connect  [get_pins pad_i_${pPort}/PAD] -net $pPort
   puts "connected  pad_o_${pPort}/PAD with ${pPort}"
    puts "connect_pin -inst pad_o_${pPort} -pin PAD -net $pPort"
    connect_pin -inst pad_o_${pPort} -pin PAD -net $pPort

}

create_inst -name corner1 -base_cell $cornerpad
create_inst -name corner2 -base_cell $cornerpad
create_inst -name corner3 -base_cell $cornerpad
create_inst -name corner4 -base_cell $cornerpad

create_inst -name powerpad1 -base_cell PADVDD1
create_inst -name powerpad2 -base_cell PADVDD1
create_inst -name powerpad3 -base_cell PADVDD1
create_inst -name powerpad4 -base_cell PADVDD1

create_inst -name groundpad1 -base_cell PADVSS1
create_inst -name groundpad2 -base_cell PADVSS1
create_inst -name groundpad3 -base_cell PADVSS1
create_inst -name groundpad4 -base_cell PADVSS1
}


set  designName  "scr1_pipe_top" 
set  technology  "45"
set  RTLFile  "../riscvCoreSyntaCore1/src/includes/scr1_ahb.svh ../riscvCoreSyntaCore1/src/includes/scr1_arch_description.svh ../riscvCoreSyntaCore1/src/includes/scr1_arch_types.svh ../riscvCoreSyntaCore1/src/includes/scr1_csr.svh ../riscvCoreSyntaCore1/src/includes/scr1_dm.svh ../riscvCoreSyntaCore1/src/includes/scr1_hdu.svh ../riscvCoreSyntaCore1/src/includes/scr1_ipic.svh ../riscvCoreSyntaCore1/src/includes/scr1_memif.svh ../riscvCoreSyntaCore1/src/includes/scr1_riscv_isa_decoding.svh ../riscvCoreSyntaCore1/src/includes/scr1_scu.svh ../riscvCoreSyntaCore1/src/includes/scr1_search_ms1.svh ../riscvCoreSyntaCore1/src/includes/scr1_tapc.svh ../riscvCoreSyntaCore1/src/includes/scr1_tdu.svh ../riscvCoreSyntaCore1/src/core/pipeline/scr1_pipe_exu.sv ../riscvCoreSyntaCore1/src/core/pipeline/scr1_pipe_ialu.sv ../riscvCoreSyntaCore1/src/core/pipeline/scr1_pipe_idu.sv ../riscvCoreSyntaCore1/src/core/pipeline/scr1_pipe_ifu.sv ../riscvCoreSyntaCore1/src/core/pipeline/scr1_pipe_lsu.sv ../riscvCoreSyntaCore1/src/core/pipeline/scr1_pipe_mprf.sv ../riscvCoreSyntaCore1/src/core/pipeline/scr1_pipe_top.sv ../riscvCoreSyntaCore1/src/core/scr1_core_top.sv" 
set  sdcFile  "../riscvCoreSyntaCore1/constraints/scr1_pipe_top.sdc" 
set  effort  "medium" 
set  libFiles  "../technology/${technology}/lib/max/MEM2_4096X32_slow.lib ../technology/${technology}/lib/max/MEM2_2048X32_slow.lib ../technology/${technology}/lib/max/pdkIO.lib ../technology/${technology}/lib/max/MEM2_512X32_slow.lib ../technology/${technology}/lib/max/MEM2_136X32_slow.lib ../technology/${technology}/lib/max/MEM2_128X16_slow.lib ../technology/${technology}/lib/max/MEM2_1024X32_slow.lib ../technology/${technology}/lib/max/MEM1_4096X32_slow.lib ../technology/${technology}/lib/max/MEM1_256X32_slow.lib ../technology/${technology}/lib/max/MEM1_1024X32_slow.lib ../technology/${technology}/lib/max/slow.lib ../technology/${technology}/lib/max/MEM2_128X32_slow.lib" 
set  libMinFiles  "../technology/${technology}/lib/min/pdkIO.lib ../technology/${technology}/lib/min/MEM2_512X32_slow.lib ../technology/${technology}/lib/min/MEM2_4096X32_slow.lib ../technology/${technology}/lib/min/MEM2_2048X32_slow.lib ../technology/${technology}/lib/min/MEM2_136X32_slow.lib ../technology/${technology}/lib/min/MEM2_128X16_slow.lib ../technology/${technology}/lib/min/MEM2_1024X32_slow.lib ../technology/${technology}/lib/min/MEM1_4096X32_slow.lib ../technology/${technology}/lib/min/MEM1_256X32_slow.lib ../technology/${technology}/lib/min/MEM1_1024X32_slow.lib ../technology/${technology}/lib/min/fast.lib ../technology/${technology}/lib/min/MEM2_128X32_slow.lib" 
set  lefFiles  "../technology/${technology}/lef/gsclib045.fixed2.lef ../technology/${technology}/lef/pdkIO.lef" 
set  capTableMin  "../technology/${technology}/captbl/best/capTable" 
set  capTableMax  "../technology/${technology}/captbl/worst/capTable" 
set  qxMapFile  "../technology/${technology}/qx/mapFile" 
set  qxTechFile  "../technology/${technology}/qx/qrcTechFile" 
set  qxConfFile  "../technology/${technology}/qx/qrc.conf" 
 


lappend libFiles ../riscvCoreSyntaCore1/ramInputs/sram_32_1024_max_1p8V_25C.lib
lappend libMinFiles ../riscvCoreSyntaCore1/ramInputs/sram_32_1024_max_1p8V_25C.lib
lappend libFiles ../riscvCoreSyntaCore1/ramInputs/scr1_pipe_top.lib
lappend libMinFiles ../riscvCoreSyntaCore1/ramInputs/scr1_pipe_top.lib
lappend lefFiles ../riscvCoreSyntaCore1/ramInputs/scr1_pipe_top.lef
lappend lefFiles ../riscvCoreSyntaCore1/ramInputs/sram_32_1024.lef



set conf_qxconf_file {NULL}
set conf_qxlib_file {NULL}
set defHierChar {/}
set init_design_settop 0
set init_gnd_net {VSS}
set init_lef_file $lefFiles
set init_mmmc_file [file normalize scripts/innovus/mmmc${technology}.tcl]
set init_pwr_net {VDD}
set init_verilog [file normalize synthesis/outputs/${designName}_synth.v]
set powerIntent [file normalize synthesis/outputs/${designName}_synth1.upf]
set lsgOCPGainMult 1.000000
set init_design_setup ${designName}

set pnrDir "pnr"
if {![file exists $pnrDir]} {
  file mkdir "pnr"
  puts "Creating directory $pnrDir"
}
catch {cd $pnrDir}


set_multi_cpu_usage -local_cpu 2 -verbose

### need to generated viewDefinition_cui.tcl and use it here
read_mmmc ../scripts/innovus/mmmc45Soc.tcl
#$init_mmmc_file
###


if {$designName == "scr1_pipe_top"} {
    lappend lefFiles ../riscvCoreSyntaCore1/ramInputs/sram_32_1024.lef
}
read_physical -lef $lefFiles

read_netlist ../riscvCoreSyntaCore1/src/top/scr1_top_ahb.v

init_design
#create_floorplan -site CoreSite -core_density_size 1 0.7 10 10 10 10

read_power_intent -1801 ../scripts/genus/block.upf
commit_power_intent -verbose



check_power_domains -nets_missing_iso
check_power_domains -nets_missing_shifter

padInsertion
create_io_row -site Corner
create_io_row -site Pad

create_floorplan -core_margins_by die -site CoreSite -core_density_size 1 0.4 10.0 0.0 0.0 0.0

write_db top.inn

exit
