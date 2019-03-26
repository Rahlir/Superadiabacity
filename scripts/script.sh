#!/bin/bash

filename=$4
matsc=$5
matsc_fn=$6

awk -v fn="$filename" -v pl="$1" -v fm="$2" -v md="$3" -f change.awk generate_pulse.m > "$matsc".m &&
matlab -nodisplay -nojvm -nosplash -nodesktop -r "${matsc};exit" &&
mv "$matsc".m "$matsc_fn"
echo DONE: $filename $matsc_fn
