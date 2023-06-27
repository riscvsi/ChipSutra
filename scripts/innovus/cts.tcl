
source setup.tcl



set pnrDir "pnr"
if {![file exists $pnrDir]} {
  file mkdir "pnr"
  puts "Creating directory $pnrDir"
}
catch {cd $pnrDir}
read_db placeCompleted.inn
set_db design_process_node $technology
set_multi_cpu_usage -local_cpu 2
set_db timing_analysis_type ocv 
set_db timing_analysis_cppr both

create_route_rule -width {Metal1 0.12 Metal2 0.14 Metal3 0.14 Metal4 0.14 Metal5 0.14 Metal6 0.14 Metal7 0.14 Metal8 0.14 Metal9 0.14 } \
		-spacing {Metal1 0.12 Metal2 0.14 Metal3 0.14 Metal4 0.14 Metal5 0.14 Metal6 0.14 Metal7 0.14 Metal8 0.14 Metal9 0.14 } -name 2w2s
create_route_type -name clkroute -route_rule 2w2s -bottom_preferred_layer Metal5 -top_preferred_layer Metal6

set_db cts_route_type_trunk clkroute
set_db cts_route_type_leaf clkroute
set_db cts_buffer_cells {CLKBUFX8 CLKBUFX12}
set_db cts_inverter_cells {CLKINVX8 CLKINVX12}
set_db cts_clock_gating_cells TLATNTSCA*
create_clock_tree_spec -out_file ccopt_cui.spec
source  ccopt_cui.spec
ccopt_design

write_db ctsCompleted.inn

time_design -post_cts
opt_design -post_cts

write_db postCts.inn


exit

