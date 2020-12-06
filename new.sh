#!/usr/bin/env bash

n=$1
if (( $n < 10 )); then
    n="0$n"
fi
f=d$n.jl
if [ ! -f $f ]; then
    perl -p -e "s|NN|$n|g" template.jl >$f
    chmod +x $f
fi
