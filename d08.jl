#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    a = map(line -> split(line), Com.file_lines(name))
    [(c, parse(Int,n)) for (c, n) in a]
end

function first(data)
    a = 0
    l = length(data)
    i = 1
    v = fill(0, l)
    while all(map(e -> e < 2, v))
        c, n = data[i]
        if c == "acc"
            a += n
            i += 1
        elseif c == "jmp"
            i += n
        elseif c == "nop"
            i += 1
        end
        v[i] += 1
    end
    a
end

t = read_file("i08t0")
inp = read_file("i08")

Test.@test first(t) == 5

@time a = first(inp)
println(a)
Test.@test a == 1331

#= function second(data) =#
#=     data =#
#= end =#

#= println(second(t)) =#
#= Test.@test second(t) == 0 =#

#= @time b = second(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
