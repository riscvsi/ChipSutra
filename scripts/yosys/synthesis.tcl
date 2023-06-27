yosys -import

source setup.tcl 
set dirName "synthesis"
if {![file exists $designName]} {
  file mkdir "synthesis"
  puts "Creating directory synthesis"
}


# read design 
read_verilog $RTLFile

# elaborate design hierarchy
hierarchy -check -top $designName 

# the high-level stuff
opt; fsm; opt;

# mapping to internal cell library
techmap; opt

# cleanup
synth -top $designName 

dfflibmap -liberty $libFiles

abc -liberty $libFiles


# write synthesized design
write_verilog ${dirName}/${designName}.synth.v

