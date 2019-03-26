#!/bin/bash

usage="$(basename "$0") [-h] COMPUTERNAME FRAME MAXDERIVATIVE

where:
    -h         show this help and exit"

while getopts ':h' option; do
    case "$option" in
        h) 	echo "$usage"
                exit
                ;;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2
              echo "$usage" >&2
                exit 1
                ;;
    esac
done
shift $((OPTIND-1))

base=$(date "+%H_%M_%S")
filename="$base".mat

ssh "$1".cs.dartmouth.edu "tmux send-keys -t MAIN.0 './scripts/script.sh "$2" "$3" "$filename" "$base"' ENTER" &&
echo RUNNING ON $1
echo "scp $1.cs.dartmouth.edu:~/Development/Physics/Superadiabaticity/brute_force/$filename ." >> scripts/runafter.sh
