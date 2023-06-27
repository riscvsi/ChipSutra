source setup.tcl
read_liberty $libFiles
read_lef $lefFiles
read_verilog $RTLFile
link_design $designName
read_sdc -echo ../synthesis/outputs/${designName}_synth.sdc
unset_propagated_clock [all_clocks]

if {$technology == 180} {
    echo "seting x,y units"
    set yUnit 2.72
    set xUnit 0.46
} else {
    echo "seting x,y units"
    set yUnit 2.72
    set xUnit 0.46
}

set bottom_margin  [expr $yUnit * 1]
set top_margin  [expr $yUnit * 1]
set left_margin [expr $xUnit * 1]
set right_margin [expr $xUnit * 1]

echo "initializing floorplan"
initialize_floorplan -utilization 30 \
    -aspect_ratio 1 \
    -core_space "$bottom_margin $top_margin $left_margin $right_margin" \
    -site unithd

### do not edit this this is to get the units in tech file
    set ::tech [[::ord::get_db] getTech]
    set dbu [$tech getDbUnitsPerMicron]

### need to generate config tracks 
echo "reading config.tracks"
source  config.tracks

echo "writing def, sdc"

write_def floorplan.def
write_sdc floorplan.sdc

place_pins -random -hor_layers met3 -ver_layers met4

tapcell -distance 13 -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1 -endcap_master sky130_fd_sc_hd__decap_3 -halo_width_x 10 -halo_width_y 10

set powerNet VDD
set groundNet VSS
echo "logical supply connection "
### logical supply connection 
add_global_connection -net $powerNet -inst_pattern .* -pin_pattern "VPWR" -power
add_global_connection -net $powerNet -inst_pattern .* -pin_pattern "VPB" -power

add_global_connection -net $groundNet -inst_pattern .* -pin_pattern "VGND" -ground
add_global_connection -net $groundNet -inst_pattern .* -pin_pattern "VNB" -ground

echo "create voltage domain"
#### create voltage domain
set_voltage_domain -name CORE -power VDD -ground VSS

### create power stripes
echo "create power stripes"
define_pdn_grid -name stdcell_grid -starts_with POWER -voltage_domain CORE -pins "met4 met5"

add_pdn_stripe -grid stdcell_grid -layer "met4" -width 1.6 -pitch 153.6 -offset 7 -starts_with POWER -extend_to_core_ring

add_pdn_stripe -grid stdcell_grid -layer "met5" -width 1.6 -pitch 153.18 -offset 7 -starts_with POWER -extend_to_core_ring

add_pdn_connect -grid stdcell_grid -layers "met4 met5"

add_pdn_stripe -grid stdcell_grid -layer "met1" -width 0.48 -followpins -starts_with POWER

add_pdn_connect -grid stdcell_grid -layers "met1 met4"

### generate pdngrid
echo "generate pdngrid"
pdngen
#####
#
#
#
##### placement
echo "placement"
set_wire_rc -signal -layer "met1"
set_wire_rc -clock -layer "met1"

set_routing_layers -signal 2-10 -clock 2-10
set_placement_padding -global -right 4

set_placement_padding -masters {sky130_fd_sc_hd__tap* sky130_fd_sc_hd__decap* sky130_ef_sc_hd__decap* sky130_fd_sc_hd__fill*} -right 0 -left 0

global_placement -verbose_level 1

estimate_parasitics -placement

buffer_ports -inputs
buffer_ports -outputs

repair_design -slew_margin 20 -cap_margin 20 
detailed_placement

### CTS for design
#
echo "CTS"
### need to load cts libs here

set max_slew [expr {0.75 * 1e-9}]; # must convert to seconds
set max_cap [expr {0.75 * 1e-12}]; # must convert to farad

repair_clock_inverters
configure_cts_characterization -max_slew $max_slew -max_cap $max_cap

#clock_tree_synthesis -buf_list {sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_2} -root_buf sky130_fd_sc_hd__clkbuf_16 -sink_clustering_size 25 -sink_clustering_max_diameter 50 -sink_clustering_enable
clock_tree_synthesis -buf_list {sky130_fd_sc_hd__buf_2 sky130_fd_sc_hd__buf_4 sky130_fd_sc_hd__buf_6 sky130_fd_sc_hd__buf_8} -root_buf sky130_fd_sc_hd__buf_4 -sink_clustering_size 25 -sink_clustering_max_diameter 50 -sink_clustering_enable

set_propagated_clock [all_clocks]

puts "repair_timing -setup -setup_margin 0.05 -max_buffer_percent 50"
repair_timing -setup -setup_margin 0.05 -max_buffer_percent 50

echo "placement"
detailed_placement

echo "route"
detailed_route -droute_end_iter 10 -verbose 1

echo "exit"
gui::show
exit
