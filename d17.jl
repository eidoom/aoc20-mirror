#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(line -> BitArray(state === '#' for state in line), Com.file_lines(name))
end

function one(data)
    conway =
        Set{Tuple}((j, i, 0) for i = 1:length(data), j = 1:length(data[1]) if data[i][j])
    dirs = [(a, b, c) for a = -1:1, b = -1:1, c = -1:1 if !all(i -> i === 0, (a, b, c))]
    for _ = 1:6
        prev = deepcopy(conway)
        conway = Set{Tuple}()
        for on in prev
            if count(dir -> on .+ dir in prev, dirs) in 2:3
                push!(conway, on)
            end
            for pos in map(dir -> on .+ dir, dirs)
                if pos in prev
                    continue
                end
                if count(dir -> pos .+ dir in prev, dirs) === 3
                    push!(conway, pos)
                end

            end
        end
    end
    length(conway)
end

t = read_file("i17t0")
inp = read_file("i17")

Test.@test one(t) == 112

@time a = one(inp)
println(a)
Test.@test a == 218

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t)) =#
#= Test.@test two(t) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
