#!/usr/bin/env julia

import Test

include("./com.jl")

@enum Edge top right bottom left flip_top flip_right flip_bottom flip_left

struct Tile
    num::Int
    image::BitArray{2}
end

function side_left(tile::Tile)
    tile.image[1, :]
end

function side_right(tile::Tile)
    tile.image[end, :]
end

function side_top(tile::Tile)
    tile.image[:, 1]
end

function side_bottom(tile::Tile)
    tile.image[:, end]
end

function side(tile::Tile, edge::Edge)
    if edge == top
        side_top(tile)
    elseif edge == right
        side_right(tile)
    elseif edge == bottom
        side_bottom(tile)
    elseif edge == left
        side_left(tile)
    elseif edge == flip_top
        reverse(side_top(tile))
    elseif edge == flip_right
        reverse(side_right(tile))
    elseif edge == flip_bottom
        reverse(side_bottom(tile))
    elseif edge == flip_left
        reverse(side_left(tile))
    end
end

function read_file(name::String)::Vector{Tile}
    [
        Tile(
            parse(Int, num[6:end]),
            reshape(
                hcat(map(
                    line -> BitArray([el === '#' for el in line]),
                    split(tile, "\n"),
                )...),
                (10, 10),
            ),
        )
        for
        (num, tile) in map(para -> split(para, ":\n"), split(Com.file_slurp(name), "\n\n"))
    ]
end

function one(data)
    res = 1
    for tile1 in data
        count = 0
        for tile2 in data
            for edge1 in instances(Edge)
                for edge2 in instances(Edge)
                    if tile1 !== tile2
                        if side(tile1, edge1) == side(tile2, edge2)
                            count += 1
                        end
                    end
                end
            end
        end
        if count === 4
            res *= tile1.num
        end
    end
    res
end

t = read_file("i20t0")
@time inp = read_file("i20")

Test.@test one(t) == 20899048083289

@time a = one(inp)
println(a)
Test.@test a == 23386616781851

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t)) =#
#= Test.@test two(t) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
