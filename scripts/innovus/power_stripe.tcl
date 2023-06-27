

source setup.tcl



set pnrDir "pnr"
if {![file exists $pnrDir]} {
  file mkdir "pnr"
  puts "Creating directory $pnrDir"
}
catch {cd $pnrDir}
read_db setupComplete.inn

set_multi_cpu_usage -local_cpu 2 -verbose



if {$technology == "45"} {

### create a supply ring around the block
add_rings -nets {vdd vss} -type core_rings -follow core -layer {top Metal8 bottom Metal8 left Metal9 right Metal9} -width {top 2 bottom 2 left 2 right 2} -spacing {top 2 bottom 2 left 2 right 2} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

### create full dense top 2 layer power mesh we dont use these 2 layers for routing

add_stripes -nets {vdd vss} -layer Metal9 -direction vertical -width 1 -spacing 2 -set_to_set_distance 10 -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit Metal9 -pad_core_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal9 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid none
add_stripes -nets {vdd vss} -layer Metal8 -direction horizontal -width 1 -spacing 2 -set_to_set_distance 10 -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit Metal9 -pad_core_ring_bottom_layer_limit Metal1 -block_ring_top_layer_limit Metal9 -block_ring_bottom_layer_limit Metal1 -use_wire_group 0 -snap_wire_center_to_grid none

### connect the global pg connection andcreate follow pins
connect_global_net vdd -type pg_pin -pin VDD -inst_base_name *
connect_global_net vss -type pg_pin -pin VSS -inst_base_name *

set_db route_special_via_connect_to_shape { stripe }
route_special -connect {core_pin} -layer_change_range { Metal1(1) Metal9(9) } -block_pin_target {nearest_target} -core_pin_target {first_after_row_end} -allow_jogging 1 -crossover_via_layer_range { Metal1(1) Metal9(9) } -nets { vdd vss } -allow_layer_change 1 -target_via_layer_range { Metal1(1) Metal9(9) }

}

#set_db place_global_place_io_pins true
#place_design
#set_db place_global_place_io_pins false

read_io_file ../scripts/innovus/ioPlacementStrategy1.tcl

write_db powermeshCompleted.inn
exit
