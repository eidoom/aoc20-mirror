#!/usr/bin/env julia

import Test

include("./com.jl")
include("./ca.jl")

function read_file(name)
    map(line -> BitArray(state === '#' for state in line), Com.file_lines(name))
end

#= 6 iterations of B3/S23 (Conway's Game of Life in N dimensions) =#
function cc(board, neighbours)
    life(board, neighbours, 6, (3,), (2, 3))
end

function one(data)
    conway = Set{NTuple{3,Int}}(
        (j, i, 0) for i = 1:length(data), j = 1:length(data[1]) if data[i][j]
    )
    dirs = [(a, b, c) for a = -1:1, b = -1:1, c = -1:1 if !all(i -> i === 0, (a, b, c))]  # 3d Moore neighbourhood
    cc(conway, dirs)
end

t = read_file("i17t0")
inp = read_file("i17")

Test.@test one(t) == 112

@time a = one(inp)
println(a)
Test.@test a == 218

function two(data)
    conway = Set{NTuple{4,Int}}(
        (j, i, 0, 0) for i = 1:length(data), j = 1:length(data[1]) if data[i][j]
    )
    dirs = [
        (a, b, c, d)
        for a = -1:1, b = -1:1, c = -1:1, d = -1:1 if !all(i -> i === 0, (a, b, c, d))
    ]  # 4d Moore neighbourhood
    cc(conway, dirs)
end

Test.@test two(t) == 848

@time b = two(inp)
println(b)
Test.@test b == 1908
