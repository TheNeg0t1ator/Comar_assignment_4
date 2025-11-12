
#Set libraries, verilog file, LEF files
source ../pnr/scripts/setup.tcl

#### Import design
set init_pwr_net {vdd}
set init_gnd_net {gnd}

init_design


##### Floorplan

globalNetConnect vdd -type pgpin -pin vdd -inst *
globalNetConnect gnd -type pgpin -pin gnd -inst *

# Aspect ratio : 1 ; fill ratio : 0.35 ; Core-to-edge spacing 20 (each side)
floorPlan -r 1 0.35 20 20 20 20





#### Power routing

addRing -nets {vdd gnd} -type core_rings -follow core -layer {top METTP bottom METTP left MET3 right MET3} -width {top 6 bottom 6 left 6 right 6} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8}




#Add stripes
#addStripe -nets {vdd gnd} -layer MET3 -direction vertical -width 6 -spacing 1 -set_to_set_distance 500
#addStripe -nets {vdd gnd} -layer METTP -direction horizontal -width 6 -spacing 1 -set_to_set_distance 500



#### Special route supply rails

sroute -connect {corePin} -nets {vdd gnd} -allowJogging 0 -allowLayerChange 0  

#### Verify design

verify_drc -report ../pnr/report/drc/verifyGeometryFP.rpt

puts "FLOW Floorplan Completed"
