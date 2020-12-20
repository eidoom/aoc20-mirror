#!/usr/bin/env julia

import Test

include("./com.jl")

@enum Edge top right bottom left flip_top flip_right flip_bottom flip_left

#= pairs = Dict(top => bottom, left => right, right => left, bottom => top) =#

struct Tile
    num::Int
    image::BitArray{2}
end

function side_left(tile::Tile)::BitArray{1}
    tile.image[1, :]
end

function side_right(tile::Tile)::BitArray{1}
    tile.image[end, :]
end

function side_top(tile::Tile)::BitArray{1}
    tile.image[:, 1]
end

function side_bottom(tile::Tile)::BitArray{1}
    tile.image[:, end]
end

function side(tile::Tile, edge::Edge)::BitArray{1}
    if edge === top
        side_top(tile)
    elseif edge === right
        side_right(tile)
    elseif edge === bottom
        side_bottom(tile)
    elseif edge === left
        side_left(tile)
    elseif edge === flip_top
        reverse(side_top(tile))
    elseif edge === flip_right
        reverse(side_right(tile))
    elseif edge === flip_bottom
        reverse(side_bottom(tile))
    elseif edge === flip_left
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

function one(data::Vector{Tile})::Int
    res = 1
    for tile1 in data
        count = 0
        for tile2 in data
            for edge1 in instances(Edge)[1:4]  # don't flip first tile
                for edge2 in instances(Edge)
                    if tile1 !== tile2
                        if side(tile1, edge1) == side(tile2, edge2)
                            count += 1
                        end
                    end
                end
            end
        end
        if count === 2
            res *= tile1.num
        end
    end
    res
end

function vflip(image::BitArray{2})::BitArray{2}
    image[end:-1:1, :]
end

function hflip(image::BitArray{2})::BitArray{2}
    image[:, end:-1:1]
end

function rot_cw(image::BitArray{2})::BitArray{2}
    hflip(permutedims(image, (2, 1)))
end

function rot_acw(image::BitArray{2})::BitArray{2}
    vflip(permutedims(image, (2, 1)))
end

function align(edge1::Edge, edge2::Edge, image::BitArray{2})::BitArray{2}
    if Int(edge2) > 3
        if edge2 in (flip_left, flip_right)
            image = vflip(image)
        elseif edge2 in (flip_top, flip_bottom)
            image = hflip(image)
        end
        edge2 = Edge(Int(edge2) - 4)
    end
    if abs(Int(edge1) - Int(edge2)) == 0
        if edge2 in (left, right)
            image = hflip(image)
        else
            image = vflip(image)
        end
    elseif Int(edge1) - Int(edge2) == -1
        image = rot_acw(image)
    elseif Int(edge1) - Int(edge2) == 1
        image = rot_cw(image)
    end
    image
end

function show_image(image::BitArray{2})
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            print(image[i, j] ? '#' : '.')
        end
        println()
    end
end

function deborder(image::BitArray{2})::BitArray{2}
    image[2:(end - 1), 2:(end - 1)]
end

function proper(data::Vector{Tile})
    len = Int(sqrt(length(data)))
    image = Array{BitArray{2},2}(undef, len, len)
    done = []
    cur = undef
    pos = (1, 1)
    for tile1 in data
        count = 0
        edges = []
        for tile2 in data
            for edge1 in instances(Edge)[1:4]
                for edge2 in instances(Edge)
                    if tile1 !== tile2
                        if side(tile1, edge1) == side(tile2, edge2)
                            count += 1
                            push!(edges, (edge1, edge2))
                        end
                    end
                end
            end
        end
        if count == 2 && edges[1][1] in (right, bottom) && edges[2][1] in (right, bottom)
            #= image[pos...] = deborder(tile1.image) =#
            image[pos...] = tile1.image
            cur = tile1
            push!(done, tile1)
            break
        end
    end
    stack = [(pos, cur)]
    while length(stack) != 0
        pos, cur = pop!(stack)
        for tile in data
            if !(tile in done)
                for edge1 in instances(Edge)[1:4]
                    for edge2 in instances(Edge)
                        if side(cur, edge1) == side(tile, edge2)
                            if edge1 == right
                                npos = pos .+ (0, 1)
                            elseif edge1 == left
                                npos = pos .+ (0, -1)
                            elseif edge1 == top
                                npos = pos .+ (-1, 0)
                            elseif edge1 == bottom
                                npos = pos .+ (1, 0)
                            end
                            if !isdefined(image, npos[2] * len + npos[1])
                                new = align(edge1, edge2, tile.image)
                                #= image[npos...] = deborder(new) =#
                                image[npos...] = new
                                push!(done, tile)
                                push!(stack, (npos, Tile(tile.num, new)))
                                #= if npos == (3, 3) =#
                                #=     println(pos, " ", edge1, " ", edge2) =#
                                #=     show_image(cur.image) =#
                                #=     println() =#
                                #=     show_image(tile.image) =#
                                #=     println() =#
                                #=     show_image(new) =#
                                #=     println() =#
                                #= end =#
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    final = hvcat((len, len, len), image...)
    #= show_image(final) =#
    show_image(rot_acw(final))
end

t = read_file("i20t0")
@time inp = read_file("i20")

Test.@test one(t) == 20899048083289
@time proper(t)

#= @time a = one(inp) =#
#= println(a) =#
#= Test.@test a == 23386616781851 =#

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t)) =#
#= Test.@test two(t) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
