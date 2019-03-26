#!/bin/bash

filename=$3
matsc=$4

awk -v fn="$filename" -v fm="$1" -v md="$2" -f scripts/change.awk brute_force/generate_pulse.m > brute_force/"$matsc".m &&
matlab -nodisplay -nojvm -nosplash -nodesktop -r "cd brute_force;${matsc};exit" &&
echo DONE: $filename $matsc.m
