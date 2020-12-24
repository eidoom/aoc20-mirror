#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(
        line -> map(i -> line[i], findall(r"(e|se|sw|w|nw|ne)", line)),
        split(Com.file_slurp(name)),
    )
end

function seed(data)
    # white: not in set/dead (default), black: in set/alive
    hexmap::Set{Tuple{Int,Int}} = Set()
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

function one(hexmap)
    length(hexmap)
end

t0 = read_file("i24t0")
@time inp = read_file("i24")
init_t = seed(t0)
@time init = seed(inp)

Test.@test one(init_t) === 10

@time a = one(init)
println(a)
Test.@test a === 382

#= B2/S12 on hexagonal lattice =#
#= This is straight out of day 17 =#
function life(board, neighbours, days)
    for _ = 1:days
        prev = deepcopy(board)
        board = Set{Tuple}()
        for alive in prev
            if count(dir -> alive .+ dir in prev, neighbours) in (1, 2)
                push!(board, alive)
            end
            for pos in map(dir -> alive .+ dir, neighbours)
                if !(pos in prev) && count(dir -> pos .+ dir in prev, neighbours) === 2
                    push!(board, pos)
                end

            end
        end
    end
    length(board)
end

function two(hexmap)
    dirs = [(-1, 1), (1, -1), (-1, 0), (1, 0), (0, 1), (0, -1)]
    life(hexmap, dirs, 100)
end

Test.@test two(init_t) === 2208

@time b = two(init)
println(b)
Test.@test b === 3964
