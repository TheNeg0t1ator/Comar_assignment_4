


create_clock [get_ports {clk}]  -name clk_i -period 90

set_clock_uncertainty 0.1 -setup -from [all_clocks] -to [all_clocks] 
set_clock_transition  0.5 [all_clocks]
set_clock_latency 0.5 [all_clocks]

set_load 0.05 [all_outputs]

set_max_transition 0.5 [current_design]
set_max_fanout 16 [current_design]

set_output_delay 0 [all_outputs]
set_input_delay 0 [all_inputs]
