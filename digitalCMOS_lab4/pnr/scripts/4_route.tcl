

#################
# Route         #
#################


#settings
setNanoRouteMode -routeWithTimingDriven false
setNanoRouteMode -routeWithSiDriven false

# routing
routeDesign -globalDetail
puts "FLOW Route Completed"




# optimization settings
#set_analysis_view -setup {av_tt av_ss av_ff} -hold {av_ss av_tt av_ff}
setOptMode -effort high  -setupTargetSlack 0.1 -holdTargetSlack 0.1
#setAnalysisMode -analysisType onChipVariation
setAnalysisMode -cppr both

# analyze timing
#timeDesign -postRoute -pathReports -drvReports -prefix pre_hold_fix -outDir ../pnr/report/timingReports -timingDebugReport

# Optimize design postroute
#optDesign -postRoute 
#optDesign -postRoute  -drv
#optDesign -postRoute -hold
#optDesign -postRoute -incr
win


# Check timing
timeDesign -hold -postRoute -prefix postroute -outDir ../pnr/report/timingReports -timingDebugReport
timeDesign -postRoute -prefix postroute -outDir ../pnr/report/timingReports -timingDebugReport

checkDesign -all -outDir ../pnr/report/checkDesign/route

puts "FLOW Optdesign Completed"
