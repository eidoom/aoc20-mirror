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
    res::Int = 1
    for tile1::Tile in data
        # don't flip first tile
        if count(
            tile1 !== tile2 && side(tile1, edge1) == side(tile2, edge2)
            for
            tile2::Tile in data,
            edge1::Edge in instances(Edge)[1:4], edge2::Edge in instances(Edge)
        ) === 2
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

function hvflip(image::BitArray{2})::BitArray{2}
    image[end:-1:1, end:-1:1]
end

function trans(image::BitArray{2})::BitArray{2}
    permutedims(image, (2, 1))
end

function rot_cw(image::BitArray{2})::BitArray{2}
    hflip(trans(image))
end

function rot_acw(image::BitArray{2})::BitArray{2}
    vflip(trans(image))
end

function align(edge1::Edge, edge2::Edge, image::BitArray{2})::BitArray{2}
    if edge1 === top
        if edge2 === top
            image |> vflip
        elseif edge2 === right
            image |> trans
        elseif edge2 === bottom
            image
        elseif edge2 === left
            image |> rot_acw
        elseif edge2 === flip_top
            image |> hvflip
        elseif edge2 === flip_right
            image |> rot_cw
        elseif edge2 === flip_bottom
            image |> hflip
        elseif edge2 === flip_left
            image |> hflip |> rot_acw
        end
    elseif edge1 === right
        if edge2 === top
            image |> trans
        elseif edge2 === right
            image |> hflip
        elseif edge2 === bottom
            image |> rot_cw
        elseif edge2 === left
            image
        elseif edge2 === flip_top
            image |> rot_acw
        elseif edge2 === flip_right
            image |> hvflip
        elseif edge2 === flip_bottom
            image |> rot_cw |> vflip
        elseif edge2 === flip_left
            image |> vflip
        end
    elseif edge1 === bottom
        if edge2 === top
            image
        elseif edge2 === right
            image |> rot_acw
        elseif edge2 === bottom
            image |> vflip
        elseif edge2 === left
            image |> trans
        elseif edge2 === flip_top
            image |> hflip
        elseif edge2 === flip_right
            image |> rot_acw |> hflip
        elseif edge2 === flip_bottom
            image |> hvflip
        elseif edge2 === flip_left
            image |> rot_cw
        end
    elseif edge1 === left
        if edge2 === top
            image |> rot_cw
        elseif edge2 === right
            image
        elseif edge2 === bottom
            image |> trans
        elseif edge2 === left
            image |> hflip
        elseif edge2 === flip_top
            image |> rot_cw |> vflip
        elseif edge2 === flip_right
            image |> vflip
        elseif edge2 === flip_bottom
            image |> rot_acw
        elseif edge2 === flip_left
            image |> hvflip
        end
    end
end

function show_image(image::BitArray{2})
    for i in axes(image, 1)
        for j in axes(image, 2)
            print(image[i, j] ? '#' : '.')
        end
        println()
    end
    println()
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
    found::Bool = false
    count::Int = 0
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
    done::Vector{Tile} = []
    c1 = undef
    p1::Tuple{Int,Int} = (1, 1)
    for tile1 in data
        count::Int = 0
        edges::Vector{Tuple{Edge,Edge}} = []
        for tile2 in data, edge1 in instances(Edge)[1:4], edge2 in instances(Edge)
            if tile1 !== tile2 && side(tile1, edge1) == side(tile2, edge2)
                count += 1
                push!(edges, (edge1, edge2))
            end
        end
        if count === 2 && all(i -> edges[i][1] in (right, bottom), 1:2)
            image[p1...] = deborder(tile1.image)
            c1 = tile1
            push!(done, tile1)
            #= println(tile1.num) =#
            break
        end
    end
    stack::Vector{Tuple{Tuple{Int,Int},Tile}} = [(p1, c1)]
    while length(stack) !== 0
        pos, cur = pop!(stack)
        for tile::Tile in data
            if !(tile in done)
                for edge1::Edge in instances(Edge)[1:4], edge2::Edge in instances(Edge)
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
                        new::BitArray{2} = align(edge1, edge2, tile.image)
                        #= println(pos, " ", edge1, "; ", npos, " ", edge2) =#
                        #= show_image(cur.image) =#
                        #= show_image(tile.image) =#
                        #= show_image(new) =#
                        #= return =#
                        image[npos...] = deborder(new)
                        push!(done, tile)
                        push!(stack, (npos, Tile(tile.num, new)))
                        break
                    end
                end
            end
        end
    end
    #= println(image) =#
    final::BitArray{2} = hvcat(Tuple(fill(len, len)), permutedims(image, (2, 1))...)
    #= show_image(final) =#
    sightings::Int = find_nessie(final)

    count(final) - sightings * weight
end

t = read_file("i20t0")
@time inp = read_file("i20")

#= ti1 = t[2].image =#
#= ti2 = t[1].image =#
#= show_image(ti1) =#
#= show_image(ti2) =#
#= show_image(align(left, right, ti2)) =#

Test.@test one(t) === 20899048083289

#= @time a = one(inp) =#
#= println(a) =#
#= Test.@test a === 23386616781851 =#

#= Test.@test proper(t) === 273 =#

@time b = proper(inp)
println(b)
#= Test.@test b == 0 =#
