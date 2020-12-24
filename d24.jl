#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(
        line -> map(i -> line[i], findall(r"(e|se|sw|w|nw|ne)", line)),
        split(Com.file_slurp(name)),
    )
end

function one(data)
    # white: false (default), black: true
    hexmap::Dict{Tuple{Int,Int},Bool} = Dict()
    for line in data
        pos = (0, 0)
        for dir in line
            if dir == "w"
                pos = pos .+ (0, -1)
            elseif dir == "e"
                pos = pos .+ (0, 1)
            elseif dir == "ne"
                pos = pos .+ (-1, 1)
            elseif dir == "nw"
                pos = pos .+ (-1, 0)
            elseif dir == "se"
                pos = pos .+ (1, 0)
            elseif dir == "sw"
                pos = pos .+ (1, -1)
            end
        end
        if haskey(hexmap, pos)
            hexmap[pos] = !hexmap[pos]
        else
            hexmap[pos] = true
        end
    end
    count(values(hexmap))
end

t0 = read_file("i24t0")
@time inp = read_file("i24")

Test.@test one(t0) === 10

@time a = one(inp)
println(a)
Test.@test a === 382

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t0)) =#
#= Test.@test two(t0) === 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b === 0 =#
