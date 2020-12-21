#!/usr/bin/env julia

import Test

include("./com.jl")

@enum Edge top right bottom left flip_top flip_right flip_bottom flip_left

struct Tile
    num::Int
    image::BitArray{2}
end

function side_left(tile::Tile)::BitArray{1}
    tile.image[:, 1]
end

function side_right(tile::Tile)::BitArray{1}
    tile.image[:, end]
end

function side_top(tile::Tile)::BitArray{1}
    tile.image[1, :]
end

function side_bottom(tile::Tile)::BitArray{1}
    tile.image[end, :]
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
            #= println(tile1.num) =#
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
    if abs(Int(edge1) - Int(edge2)) === 0
        if edge2 in (left, right)
            image = hflip(image)
        else
            image = vflip(image)
        end
    elseif Int(edge1) - Int(edge2) === -1
        image = rot_cw(image)
    elseif Int(edge1) - Int(edge2) === 1
        image = rot_acw(image)
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

# Nessie
#              1111111111
#    01234567890123456789
#                      #
#    #    ##    ##    ###
#     #  #  #  #  #  #

upper = 18
middle = (0, 5, 6, 11, 12, 17, 18, 19)
lower = (1, 4, 7, 10, 13, 16)
weight = 15

function find_nessie(final::BitArray{2})::Int
    found = false
    count = 0
    for _ = 1:2  # flips
        for _ = 1:4  # rotations
            for a = 2:(size(final, 1) - 1)  # image row
                for i = 1:(size(final, 2) - middle[end] + 1)  # subset of row
                    if all(z -> final[a, i + z], middle) &&
                       final[a - 1, i + upper] &&
                       all(z -> final[a + 1, i + z], lower)
                        count += 1
                        found = true
                    end
                end
            end
            if found
                return count
            end
            final = rot_cw(final)
        end
        final = hflip(final)
    end
end

function proper(data::Vector{Tile})::Int
    len = Int(sqrt(length(data)))
    image = Array{BitArray{2},2}(undef, len, len)
    #= for i = 1:length(data) =#
    #=     image[i] = BitArray(fill(false, 8, 8)) =#
    #= end =#
    done = []
    c1 = undef
    p1 = (1, 1)
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
        if count === 2 && edges[1][1] in (right, bottom) && edges[2][1] in (right, bottom)
            image[p1...] = deborder(tile1.image)
            c1 = tile1
            push!(done, tile1)
            #= println(tile1.num) =#
            break
        end
    end
    stack = [(p1, c1)]
    i = 0
    while length(stack) !== 0
        pos, cur = pop!(stack)
        for tile in data
            if !(tile in done)
                for edge1 in instances(Edge)[1:4]
                    for edge2 in instances(Edge)
                        if side(cur, edge1) == side(tile, edge2)
                            if edge1 === right
                                npos = pos .+ (0, 1)
                            elseif edge1 === left
                                npos = pos .+ (0, -1)
                            elseif edge1 === top
                                npos = pos .+ (-1, 0)
                            elseif edge1 === bottom
                                npos = pos .+ (1, 0)
                            end
                            #= if any(e -> e === 0 || e > len, npos) =#
                            #=     continue =#
                            #= end =#
                            new = align(edge1, edge2, tile.image)
                            #= println(pos, " ", edge1, "; ", npos, " ", edge2) =#
                            image[npos...] = deborder(new)
                            push!(done, tile)
                            push!(stack, (npos, Tile(tile.num, new)))
                            i += 1
                            break
                        end
                    end
                end
            end
        end
    end
    #= println(image) =#
    final = hvcat(Tuple(fill(len, len)), permutedims(image, (2, 1))...)
    show_image(final)
    sightings = find_nessie(final)

    count(final) - sightings * weight
end

t = read_file("i20t0")
@time inp = read_file("i20")

#= Test.@test one(t) === 20899048083289 =#

@time a = one(inp)
println(a)
Test.@test a === 23386616781851

#= Test.@test proper(t) === 273 =#

@time b = proper(inp)
println(b)
#= Test.@test b == 0 =#
