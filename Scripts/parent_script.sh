#!/bin/bash
base=$(date "+%H_%M_%S")
matsc=$(date "+opt%H%M%S")
filename="$base".mat
scriptname="$base".m

ssh "$1".cs.dartmouth.edu "tmux send-keys -t MAIN.0 './script.sh "$2" "$3" "$4" "$filename" "$matsc" "$scriptname"' ENTER" &&
echo RUNNING ON $1
echo "scp $1.cs.dartmouth.edu:~/Development/Physics/Research/Code/NumericalExploration/$filename ." >> runafter.sh
