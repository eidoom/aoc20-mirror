#!/usr/bin/env julia

import Test

include("./com.jl")

function trees(data, di, dj)
    r = length(first(data))
    j = 1
    t = 0
    for i = 1:di:length(data)
        if data[i][j] === '#'
            t += 1
        end
        j = mod(j + dj, 1:r)
    end
    t
end

t = Com.file_lines("i03t0")
display(t)
@time inp = Com.file_lines("i03")

Test.@test trees(t, 1, 3) === 7

@time a = trees(inp, 1, 3)
println(a)
Test.@test a === 207

function trees2(data)
    trees(data, 1, 1) *
    trees(data, 1, 3) *
    trees(data, 1, 5) *
    trees(data, 1, 7) *
    trees(data, 2, 1)
end

Test.@test trees2(t) === 336

@time b = trees2(inp)
println(b)
Test.@test b === 2655892800
