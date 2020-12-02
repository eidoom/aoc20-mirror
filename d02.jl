#!/usr/bin/env julia

import Test

function read(name)
    a = []
    f = open(name, "r")
    for b in readlines(f)
        pol, pas = split(b, ": ")
        lim, ltr = split(pol, " ")
        low, upp = split(lim, "-")
        d = Dict("low"=>parse(UInt, low), "upp"=>parse(UInt, upp), "ltr"=>first(ltr), "pas"=>pas)
        push!(a, d)
    end
    close(f)
    a
end

function valid(data)
    v = 0
    for c in data
        n = count(i->(i==c["ltr"]), c["pas"])
        if n >= c["low"] && n <= c["upp"]
            v += 1
        end
    end
    v
end

Test.@test valid(read("i02t0")) == 2

@time println(valid(read("i02")))
