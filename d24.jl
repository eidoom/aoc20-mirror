#!/usr/bin/env julia

import Test

include("./com.jl")
include("./ca.jl")

function read_file(name::String)::Vector{Vector{String}}
    map(
        line -> map(i -> line[i], findall(r"(e|se|sw|w|nw|ne)", line)),
        split(Com.file_slurp(name)),
    )
end

function seed(data::Vector{Vector{String}})::Set{NTuple{2,Int}}
    # white: not in set/dead (default), black: in set/alive
    hexmap::Set{NTuple{2,Int}} = Set()
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
        if pos in hexmap
            setdiff!(hexmap, [pos])
        else
            push!(hexmap, pos)
        end
    end
    hexmap
end

function one(hexmap::Set{NTuple{2,Int}})::Int
    length(hexmap)
end

t0 = read_file("i24t0")
println("Parse input")
@time inp = read_file("i24")
init_t = seed(t0)
println("Build CA initial state")
@time init = seed(inp)

Test.@test one(init_t) === 10

println("Count alive")
@time a = one(init)
println("Day 0: ", a)
Test.@test a === 382

#= B2/S12 on hexagonal lattice =#
function two(hexmap::Set{NTuple{2,Int}})::Int
    dirs = [(-1, 1), (1, -1), (-1, 0), (1, 0), (0, 1), (0, -1)]
    life(hexmap, dirs, 100, (2,), (1,2))
end

Test.@test two(init_t) === 2208

println("Run CA")
@time b = two(init)
println("Day 100: ", b)
Test.@test b === 3964
