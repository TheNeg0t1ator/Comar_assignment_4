

set DATE [clock format [clock seconds] -format "%b%d-%T"]
set synpath ../syn/
#set UMC_HOME ../UMC180/Faraday

#set LIB_PATH "${UMC_HOME}/GENERIC_CORE/FrontEnd/synopsys ${UMC_HOME}/GENERIC_CORE/BackEnd/lef ../ip/SJ180_1024X8X4CM8"

set XFAB_HOME /tech/xfab_xh018
set LIB_PATH "${XFAB_HOME}/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/D_CELLS_HD/v4_2/liberty_LP5MOS/v4_2_0/PVT_1_80V_range ${XFAB_HOME}/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/D_CELLS_HD/v4_2/LEF/v4_2_0 ${XFAB_HOME}/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/cadence/v9_0/techLEF/v9_0_1/"

#### PAth to the RTL files
set RTL_PATH ". ../rtl"
set RTL_LIST [glob -dir ../rtl *.v *.sv *.vhd]


#### Path to the SDC constraints files
set SDC_PATH "../constraints"

#### Synthesis efforts
set_db / .syn_generic_effort medium
set_db / .syn_map_effort high
set_db / .syn_opt_effort high

#### Path to the directory where the outputs will be stored
set OUTPUTS_PATH ../syn/output
set REPORTS_PATH ../syn/report/${DATE}




set SDC_file  "${SDC_PATH}/constraints.sdc"

set_db super_thread_servers {localhost localhost localhost localhost localhost localhost}


#set LIB_LIST { \
#fsa0m_a_generic_core_ss1p62v125c.lib \
#SJ180_1024X8X4CM8_ss1p35v125c.lib
#}

set LIB_LIST { \
D_CELLS_HD_LP5MOS_typ_1_80V_25C.lib \
}

#set LEF_LIST { \
#header6_V55.lef \
#FSA0M_A_GENERIC_CORE_ANT_V55.6.lef \
#fsa0m_a_generic_core.lef \
#SJ180_1024X8X4CM8.lef
#}

set LEF_LIST { \
xt018_xx31_MET3_METMID.lef \
xt018_D_CELLS_HD.lef \
xt018_xx31_MET3_METMID_D_CELLS_HD_mprobe.lef \
}



set CAPTABLE "${XFAB_HOME}/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/cadence/v9_0/capTbl/v9_0_1/xt018_xx31_MET3_METMID_typ.capTbl"


#### Setup the library and RTL search paths
set_db / .hdl_language vhdl
set_db / .init_lib_search_path "."
set_db / .script_search_path ". ${synpath}/scripts"
set_db / .init_hdl_search_path ". $RTL_PATH"
set_db / .init_lib_search_path "$LIB_PATH"


#### Load libraries
read_libs -max_libs $LIB_LIST
read_physical -lef $LEF_LIST
set_db / .lef_library $LEF_LIST
set_db / .cap_table_file $CAPTABLE


#### Clock gate settings
set_db / .lp_clock_gating_prefix "LP_Gating_"
set_db / .lp_insert_discrete_clock_gating_logic false

set_db / .lp_power_analysis_effort medium

#max memory address range limit
set_db hdl_max_memory_address_range 265535

#Creating output directories, if they dont exist


if {![file exists ${OUTPUTS_PATH}]} {
        file mkdir ${OUTPUTS_PATH}
        puts "Creating directory ${OUTPUTS_PATH}"
}

if {![file exists ${REPORTS_PATH}]} {
        file mkdir ${REPORTS_PATH}
        puts "Creating directory ${REPORTS_PATH}"
}


