#!/usr/bin/env julia

import Test

include("./com.jl")

function trees(data, di, dj)
    j = 1
    t = 0
    for i = 1:di:size(data, 1)
        if data[i, j] === '#'
            t += 1
        end
        j = mod(j + dj, 1:size(data, 2))
    end
    t
end

t = Com.file_2d("i03t0")
@time inp = Com.file_2d("i03")

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
