#!/bin/bash

cd modelsim
rm -rf work

declare -i SECONDS
declare -i min
declare -i min_sec
declare -i sec

SECONDS=0
vsim -c -immedassert -do sim.fdo -hazards
if [ "$?" = "1" ]; then
    echo "SIM FAILED. WE ALL GONNA DIE"
    exit 1
fi

min=$SECONDS/60
min_sec=$min*60
sec=$SECONDS-$min_sec
echo "done in $min minutes and $sec seconds"
