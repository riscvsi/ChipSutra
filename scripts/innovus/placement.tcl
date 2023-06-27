
source setup.tcl



set pnrDir "pnr"
if {![file exists $pnrDir]} {
  file mkdir "pnr"
  puts "Creating directory $pnrDir"
}
catch {cd $pnrDir}
read_db powermeshCompleted.inn
set_db design_process_node 45
set_multi_cpu_usage -local_cpu 16
set_db timing_analysis_type ocv 
set_db timing_analysis_cppr both

place_opt_design

check_place ${designName}.checkPlace
write_db placeCompleted.inn

exit

