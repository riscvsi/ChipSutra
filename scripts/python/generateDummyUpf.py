
import argparse

parser = argparse.ArgumentParser(description='parse file to dump dummy upf file')

parser.add_argument("designName", help="display a square of a given number")
parser.add_argument("-D", dest = "designName", help="increase output verbosity", action="store_true")

args = parser.parse_args()

print(args.designName)
upfFile = "generatedInputs/"+args.designName + ".upf"

file1 = open(upfFile, 'w')
data = ''' # generating dummy upf file 
# creating top power domain
create_power_domain pd_top -include_scope

create_supply_port VDD -direction in -domain pd_top
create_supply_port VSS -direction in -domain pd_top

create_supply_net VDD -domain pd_top
create_supply_net VSS -domain pd_top

connect_supply_net VDD -ports VDD
connect_supply_net VSS -ports VSS

set_domain_supply_net pd_top -primary_power_net VSS -primary_ground_net VSS

add_port_state VDDH -state {HighVoltage 1.1}
add_port_state VSS -state {pwr_gnd 0.0}

create_pst pwr_state_table -supplies {VCCH VSS}

add_pst_state FUNC -pst pwr_state_table -state { HighVoltage pwr_gnd}

'''
file1.write(data)
file1.close()

