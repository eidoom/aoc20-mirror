#!/usr/bin/env julia

import Test

include("./com.jl")

function get_data(name)
    a = []
    for b in Com.file_lines(name)
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
    a
end

function valid(data)
    count(c -> c["low"] <= count(i -> (i == c["ltr"]), c["pas"]) <= c["upp"], data)
end

t = get_data("i02t0")
inp = get_data("i02")

Test.@test valid(t) == 2

@time a = valid(inp)
println(a)
Test.@test a == 467

function valid2(data)
    count(c -> xor(c["pas"][c["low"]] == c["ltr"], c["pas"][c["upp"]] == c["ltr"]), data)
end

Test.@test valid2(t) == 1

@time b = valid2(inp)
println(b)
Test.@test b == 441
