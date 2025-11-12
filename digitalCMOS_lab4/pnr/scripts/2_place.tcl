
#################
# PLACE         #
#################




#### Place standard cells
setPlaceMode  -timingDriven 1 -placeIOPins 1 -ignoreScan 1
place_opt_design


#### Add Tie-high Tie-low cells
setTieHiLoMode -maxDistance 20
addTieHiLo -cell "LOGIC0HD LOGIC1HD"

#### Check design

timeDesign -preCTS -prefix preCTS -outDir ../pnr/report/timingReports -timingDebugReport
checkDesign -all -outDir ../pnr/report/checkDesign/place

saveNetlist ../pnr/output/place.v
puts "FLOW Place Completed"
