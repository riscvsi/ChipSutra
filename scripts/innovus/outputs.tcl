


source setup.tcl



set pnrDir "pnr"
if {![file exists $pnrDir]} {
  file mkdir "pnr"
  puts "Creating directory $pnrDir"
}
catch {cd $pnrDir}
read_db postroute.inn

write_lef_abstract ${designName}.lef -top_layer 9 -stripe_pins 
cp ../synthesis/outputs/${designName}.lib .

exit
