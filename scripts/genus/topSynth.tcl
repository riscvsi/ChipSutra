
source setup.tcl
set synthDir "synthesis"
if {![file exists $synthDir]} {
  file mkdir "synthesis"
  puts "Creating directory $synthDir"
}
catch {cd $synthDir}

if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

##############################################################################
## Preset global variables and attributes
##############################################################################


set DESIGN $designName
set GEN_EFF $effort
set MAP_OPT_EFF $effort
set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set _OUTPUTS_PATH outputs_${DATE}
set _OUTPUTS_PATH outputs
set _REPORTS_PATH reports
set _LOG_PATH logs
##set ET_WORKDIR <ET work directory>
set_db / .init_lib_search_path {.} 
set_db / .script_search_path {.} 
set_db / .init_hdl_search_path {.} 
##Uncomment and specify machine names to enable super-threading.
##set_db / .super_thread_servers {<machine names>} 
##For design size of 1.5M - 5M gates, use 8 to 16 CPUs. For designs > 5M gates, use 16 to 32 CPUs
##set_db / .max_cpus_per_server 8

##Default undriven/unconnected setting is 'none'.  
##set_db / .hdl_unconnected_value 0 | 1 | x | none

set_db / .information_level 7 

###############################################################
## Library setup
###############################################################



if {$designName == "scr1_pipe_top"} {
lappend libFiles ../riscvCoreSyntaCore1/ramInputs/sram_32_1024_max_1p8V_25C.lib
lappend libFiles /nfs/site/disks/vmisd_vclp_efficiency/rcg/test/cadence/venvRcg/AsicMethadology/pnr/scr1_pipe_top.lib
}
read_libs  $libFiles


if {$designName == "scr1_pipe_top"} {
lappend lefFiles ../riscvCoreSyntaCore1/ramInputs/sram_32_1024.lef
lappend lefFiles /nfs/site/disks/vmisd_vclp_efficiency/rcg/test/cadence/venvRcg/AsicMethadology/pnr/scr1_pipe_top.lef
}
read_physical -lef $lefFiles

if {[file exists ../scripts/genus/block.upf]} {
read_power_intent -1801 ../scripts/genus/block.upf -module $DESIGN
apply_power_intent
commit_power_intent
}

read_hdl -sv {/nfs/site/disks/vmisd_vclp_efficiency/rcg/test/cadence/venvRcg/AsicMethadology/riscvCoreSyntaCore1/src/includes/scr1_arch_description.svh /nfs/site/disks/vmisd_vclp_efficiency/rcg/test/cadence/venvRcg/AsicMethadology/riscvCoreSyntaCore1/src/top/scr1_top_ahb.sv}
read_hdl -sv {/nfs/site/disks/vmisd_vclp_efficiency/rcg/test/cadence/venvRcg/AsicMethadology/riscvCoreSyntaCore1/src/top/scr1_top_ahb.sv}
elaborate ARAMB_RISCV_180_SOC


set_db / .syn_generic_effort $GEN_EFF
syn_generic

set_db / .syn_map_effort $MAP_OPT_EFF
syn_map

syn_opt
write_hdl topLevel.v
