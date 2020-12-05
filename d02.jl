#!/usr/bin/env julia

import Test

function read(name)
    a = []
    f = open(name, "r")
    for b in readlines(f)
        pol, pas = split(b, ": ")
        lim, ltr = split(pol, " ")
        low, upp = split(lim, "-")
        d = Dict(
            "low" => parse(UInt, low),
            "upp" => parse(UInt, upp),
            "ltr" => first(ltr),
            "pas" => pas,
        )
        push!(a, d)
    end
    close(f)
    a
end

function valid(data)
    v = 0
    for c in data
        if c["low"] <= count(i -> (i == c["ltr"]), c["pas"]) <= c["upp"]
            v += 1
        end
    end
    v
end

t = read("i02t0")
inp = read("i02")

Test.@test valid(t) == 2

@time println(valid(inp))

function valid2(data)
    v = 0
    for c in data
        if xor(c["pas"][c["low"]] == c["ltr"], c["pas"][c["upp"]] == c["ltr"])
            v += 1
        end
    end
    v
end

Test.@test valid2(t) == 1

@time println(valid2(inp))
