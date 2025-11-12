

#### Set the name of your design: top level module name
set DESIGN DataPath


#### clock gating
set_db / .lp_insert_clock_gating false
#set_db / .lp_insert_clock_gating true


#### show GUI
gui_show

#### Loads HDL files

read_hdl $RTL_LIST



#### Creates design from HDL entity
elaborate $DESIGN


#### Check for unresolved instances
check_design -unresolved

#### Check design
check_design

#### Creat mode "normal" and Read constraints
read_sdc $SDC_file


report_timing -lint
report_timing


