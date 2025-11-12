#!/bin/bash

if [ -f "../clean.sh" ]; then

	rm -rf ../pnr/output
	rm -rf ../pnr/report
	rm -rf ./*

	mkdir ../pnr/output
	mkdir ../pnr/report
	mkdir ../pnr/report/checkDesign
	mkdir ../pnr/report/timingReports
	mkdir ../pnr/report/drc

	rm -rf ../syn/output
	rm -rf ../syn/report

	mkdir ../syn/output
	mkdir ../syn/report

else
	echo "Run clean from work directory"
fi



