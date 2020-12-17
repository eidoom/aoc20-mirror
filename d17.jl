#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(line -> BitArray(state === '#' for state in line), Com.file_lines(name))
end

#= B3/S23 (Conway's Game of Life in N D) =#
function cc(board, neighbours)
    for _ = 1:6
        prev = deepcopy(board)
        board = Set{Tuple}()
        for on in prev
            if count(dir -> on .+ dir in prev, neighbours) in 2:3
                push!(board, on)
            end
            for pos in map(dir -> on .+ dir, neighbours)
                if !(pos in prev) && count(dir -> pos .+ dir in prev, neighbours) === 3
                    push!(board, pos)
                end

            end
        end
    end
    length(board)
end

function one(data)
    conway = Set{Tuple}((j, i, 0) for i = 1:length(data), j = 1:length(data[1]) if data[i][j])
    dirs = [(a, b, c) for a = -1:1, b = -1:1, c = -1:1 if !all(i -> i === 0, (a, b, c))]
    cc(conway, dirs)
end

t = read_file("i17t0")
inp = read_file("i17")

Test.@test one(t) == 112

@time a = one(inp)
println(a)
Test.@test a == 218

function two(data)
    conway = Set{Tuple}((j, i, 0, 0) for i = 1:length(data), j = 1:length(data[1]) if data[i][j])
    dirs = [(a, b, c, d) for a = -1:1, b = -1:1, c = -1:1, d = -1:1 if !all(i -> i === 0, (a, b, c, d))]
    cc(conway, dirs)
end

Test.@test two(t) == 848

@time b = two(inp)
println(b)
Test.@test b == 1908
