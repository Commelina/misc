#!/bin/bash

function perf-offcputime(){
    /usr/share/bcc/tools/offcputime -df $2 > offcpu_$1.stacks
    flamegraph.pl --color=io --title="Off-CPU Time: $1" --countname=us < offcpu_$1.stacks > offcpu_$1.svg
}

function perf-pagefault(){
    perf record -e page-faults -a -g -o pagefault_$1.perf.data -- sleep $2
    perf script -i pagefault_$1.perf.data --header > pagefault_$1.stacks
    stackcollapse-perf.pl < pagefault_$1.stacks | flamegraph.pl --hash --bgcolor=green --count=pages --title="Page Faults: $1" > pagefault_$1.svg
}

function perf-major-pagefault(){
    perf record -e major-faults -a -g -o major_pagefault_$1.perf.data -- sleep $2
    perf script -i major_pagefault_$1.perf.data --header > major_pagefault_$1.stacks
    stackcollapse-perf.pl < major_pagefault_$1.stacks | flamegraph.pl --hash --bgcolor=green --count=pages --title="Major Faults: $1" > major_pagefault_$1.svg
}

function perf-hotspot(){
    perf record -e cycles -e sched:sched_switch --switch-events --sample-cpu -m 8M --aio -z --call-graph dwarf -a -o hotspot_$1.perf.data -- sleep $2
}
