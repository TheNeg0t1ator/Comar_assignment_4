
#### Pre CTS optimisation

place_opt_design -incremental

#################
# CTS           #
#################

#settings
#set_ccopt_mode -cts_buffer_cells {BUF2CK BUF3CK BUF4CK BUF6CK BUF8CK BUF12CK}
#set_ccopt_mode -cts_inverter_cells { INV2CK INV3CK INV6CK INV8CK INV12CK}
set_ccopt_mode -cts_buffer_cells {BUHDX0 BUHDX1 BUHDX2 BUHDX3 BUHDX4 BUHDX6 BUHDX8 BUHDX12}
set_ccopt_mode -cts_inverter_cells {INHDX0 INHDX1 INHDX2 INHDX3 INHDX4 INHDX6 INHDX8 INHDX12}
set_ccopt_property source_max_capacitance 0.01
set_ccopt_property target_skew 0.35
set_ccopt_property target_max_trans 0.5
set_ccopt_property max_fanout 16


# Build clock tree
create_ccopt_clock_tree_spec -filename ccopt.spec
source ccopt.spec

ccopt_design -check_prerequisites

setOptMode -effort high -setupTargetSlack 0.1 -holdTargetSlack 0.1  -usefulSkewCCOpt medium
ccopt_design 

report_ccopt_clock_trees -file ../pnr/report/clocktree.rpt


# Check timing both setup and hold
timeDesign -postCTS -prefix postCTS -outDir ../pnr/report/timingReports -timingDebugReport
timeDesign -hold -postCTS -prefix postCTS -outDir ../pnr/report/timingReports -timingDebugReport

# timing optimization post CTS
set_interactive_constraint_modes [ all_constraint_modes -active ]
set_propagated_clock [ all_clocks ]

optDesign -postCTS  
win

puts "FLOW CTS Completed"


