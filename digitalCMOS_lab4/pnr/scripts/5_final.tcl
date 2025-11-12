#################
# FINISH        #
#################


# fillers
addFiller -cell FCNE2HD FCNE3HD FCNE4HD FCNE5HD FCNE6HD FCNE7HD FCNE8HD FCNE9HD FCNE10HD FCNE11HD FCNE12HD FCNE13HD FCNE14HD FCNE15HD FCNE16HD FCNE17HD FCNE18HD FCNE19HD FCNE20HD FCNE21HD FCNE22HD FCNE23HD FCNE24HD FCNE25HD FCNE26HD FCNE27HD FCNE28HD FCNE29HD FCNE30HD FCNE31HD FCNE32HD -prefix FILLER

# fix drc errors
clearDrc
verify_drc
ecoRoute -fix_drc

#### run Quantus RC extraction
timeDesign  -signoff  -prefix signoff -timingDebugReport -outDir ../pnr/report/timingReports
timeDesign  -signoff -hold -prefix signoff -timingDebugReport -outDir ../pnr/report/timingReports


clearDrc
verify_drc -report ../pnr/report/drc/verify_drc.rpt
verifyConnectivity -type all -report ../pnr/report/drc/connectivity.rpt
checkDesign -all -outDir ../pnr/report/checkDesign/export

saveDesign ../pnr/output/final.invs
saveNetlist ../pnr/output/final.v

puts "Power consumption"
report_power

puts "Timing report"

report_timing

puts "Area report"

report_area

verify_drc

streamOut ../pnr/report/gds/layout.gds -libName DesignLib

summaryReport

puts "FLOW Final Completed"



