#!/usr/bin/env julia

import Test

include("./com.jl")

t = Com.file_lines("i05t0")

function seat1d(data)
    low = 0
    upp = (1 << length(data)) - 1
    for c in data
        if c in ['F', 'L']
            upp -= div(upp - low, 2) + 1
        else
            low += div(upp - low, 2) + 1
        end
    end
    upp
end

function id(data)
    seat1d(data[1:7]) * 8 + seat1d(data[8:10])
end

inp = Com.file_lines("i05")

Test.@test id(t[1]) === 357
Test.@test id(t[2]) === 567
Test.@test id(t[3]) === 119
Test.@test id(t[4]) === 820

ids = id.(inp)

@time a = maximum(ids)
println(a)
Test.@test a === 994

function mine(data)
    l = sort(data)
    p = first(l) - 1
    for n in l
        if n != p + 1
            return p + 1
        else
            p = n
        end
    end
end

@time b = mine(ids)
println(b)
Test.@test b === 741
