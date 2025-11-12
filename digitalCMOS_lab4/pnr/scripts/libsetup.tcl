#######################################################
create_rc_corner -name rc_tt -qx_tech_file {/tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/cadence/v9_0/QRC_pvs/v9_0_1/XT018_1231/QRC-Typ/qrcTechFile}



# create_library_set -name tt -timing {../UMC180/Faraday/GENERIC_CORE/FrontEnd/synopsys/fsa0m_a_generic_core_tt1p8v25c.lib ../UMC180/Faraday/T33_GENERIC_IO/FrontEnd/synopsys/fsa0m_a_t33_generic_io_tt1p8v25c.lib ../ip/SJ180_1024X8X4CM8/SJ180_1024X8X4CM8_tt1p5v25c.lib}
# create_library_set -name ff -timing {../UMC180/Faraday/GENERIC_CORE/FrontEnd/synopsys/fsa0m_a_generic_core_ff1p98vm40c.lib ../UMC180/Faraday/T33_GENERIC_IO/FrontEnd/synopsys/fsa0m_a_t33_generic_io_ff1p98vm40c.lib ../ip/SJ180_1024X8X4CM8/SJ180_1024X8X4CM8_ff1p65vm40c.lib}
# create_library_set -name ss -timing {../UMC180/Faraday/GENERIC_CORE/FrontEnd/synopsys/fsa0m_a_generic_core_ss1p62v125c.lib ../UMC180/Faraday/T33_GENERIC_IO/FrontEnd/synopsys/fsa0m_a_t33_generic_io_ss1p62v125c.lib ../ip/SJ180_1024X8X4CM8/SJ180_1024X8X4CM8_ss1p35v125c.lib}


create_library_set -name tt -timing {/tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/D_CELLS_HD/v4_2/liberty_LP5MOS/v4_2_0/PVT_1_80V_range/D_CELLS_HD_LP5MOS_typ_1_80V_25C.lib /tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/IO_CELLS_F5V/v2_3/liberty_UPF_LP5MOS/v2_3_0/PVT_1_80V_5_00V_range/IO_CELLS_F5V_LP5MOS_UPF_typ_1_80V_5_00V_25C.lib }
create_library_set -name ff -timing {/tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/D_CELLS_HD/v4_2/liberty_LP5MOS/v4_2_0/PVT_1_80V_range/D_CELLS_HD_LP5MOS_fast_1_98V_m40C.lib /tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/IO_CELLS_F5V/v2_3/liberty_UPF_LP5MOS/v2_3_0/PVT_1_80V_5_00V_range/IO_CELLS_F5V_LP5MOS_UPF_fast_1_98V_5_50V_m40C.lib}
create_library_set -name ss -timing {/tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/D_CELLS_HD/v4_2/liberty_LP5MOS/v4_2_0/PVT_1_80V_range/D_CELLS_HD_LP5MOS_slow_1_62V_125C.lib /tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/IO_CELLS_F5V/v2_3/liberty_UPF_LP5MOS/v2_3_0/PVT_1_80V_5_00V_range/IO_CELLS_F5V_LP5MOS_UPF_slow_1_62V_4_50V_125C.lib}

create_constraint_mode -name default -sdc_files {../syn/output/r2g.normal.sdc}


create_delay_corner -name tt -library_set {tt} -rc_corner {rc_tt}
create_delay_corner -name ss -library_set {ss} -rc_corner {rc_tt}
create_delay_corner -name ff -library_set {ff} -rc_corner {rc_tt}


create_analysis_view -name av_tt -constraint_mode {default} -delay_corner {tt}
create_analysis_view -name av_ss -constraint_mode {default} -delay_corner {ss}
create_analysis_view -name av_ff -constraint_mode {default} -delay_corner {ff}


set_analysis_view -setup {av_tt av_ss av_ff} -hold {av_ss av_tt av_ff}

