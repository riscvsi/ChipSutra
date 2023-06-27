
source setup.tcl



set pnrDir "pnr"
if {![file exists $pnrDir]} {
  file mkdir "pnr"
  puts "Creating directory $pnrDir"
}
catch {cd $pnrDir}
read_db postCts.inn
set_db design_process_node $technology
set_multi_cpu_usage -local_cpu 2
set_db timing_analysis_type ocv 
set_db timing_analysis_cppr both

create_route_rule -width {Metal1 0.12 Metal2 0.14 Metal3 0.14 Metal4 0.14 Metal5 0.14 Metal6 0.14 Metal7 0.14 Metal8 0.14 Metal9 0.14 } \
		-spacing {Metal1 0.12 Metal2 0.14 Metal3 0.14 Metal4 0.14 Metal5 0.14 Metal6 0.14 Metal7 0.14 Metal8 0.14 Metal9 0.14 } -name rcgNDR2w2s
create_route_type -name rcgRoute -route_rule rcgNDR2w2s -bottom_preferred_layer Metal4 -top_preferred_layer Metal7

route_design
write_db route.inn
set_db extract_rc_engine post_route
set_db extract_rc_effort_level medium
time_design -post_route
time_design -post_route -hold
opt_design -post_route -setup -hold
write_db postroute.inn


exit

