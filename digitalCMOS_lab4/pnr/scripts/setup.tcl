set numCpu 12
setDesignMode -process 180
setMultiCpuUsage -cpuAutoAdjust true -localCpu $numCpu -keepLicense true

set conf_qxconf_file NULL
set init_import_mode { -keepEmptyModule 1 -treatUndefinedCellAsBbox 0}
set conf_qxlib_file NULL


set init_mmmc_file ../pnr/scripts/libsetup.tcl
set init_verilog ../syn/output/r2g.v

# set init_lef_file { \
# ../UMC180/Faraday/GENERIC_CORE/BackEnd/lef/header6_V55.lef \
# ../UMC180/Faraday/GENERIC_CORE/BackEnd/lef/FSA0M_A_GENERIC_CORE_ANT_V55.6.lef \
# ../UMC180/Faraday/GENERIC_CORE/BackEnd/lef/fsa0m_a_generic_core.lef \
# ../ip/SJ180_1024X8X4CM8/SJ180_1024X8X4CM8.lef
# }



set init_lef_file { \
/tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/cadence/v9_0/techLEF/v9_0_1/xt018_xx31_MET3_METMID.lef \
/tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/D_CELLS_HD/v4_2/LEF/v4_2_0/xt018_D_CELLS_HD.lef \
/tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/D_CELLS_HD/v4_2/LEF/v4_2_0/xt018_xx31_MET3_METMID_D_CELLS_HD_mprobe.lef \
/tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/diglibs/IO_CELLS_F5V/v2_3/LEF/v2_3_1/xt018_1231_MET3_METMID_IO_CELLS_F5V.lef \
}

setExtractRCMode -useQrcOAInterface true -effortLevel high -coupled true

#setExtractRCMode -useQrcOAInterface true -engine postRoute -effortLevel high -coupled true -lefTechFileMap {/tech/xfab_xh018/x_all/cadence/XFAB_Digital_MultiVoltage_RefKit-cadence/v1_1_1/pdk/xt018/cadence/v9_0/QRC_pvs/v9_0_1/XT018_1231/QRC-Typ/xx018_lef_qrc.map}
