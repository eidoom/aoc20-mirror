#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name::String)::Array{Char,2}
    permutedims(hcat(collect.(Com.file_lines(name))...))
end

function seats1(data::Array{Char,2})::Int
    new = copy(data)
    h, w = size(new)
    c = 1
    new_c = 0
    while new_c != c
        data = copy(new)
        c = new_c
        for i in axes(new, 1)
            for j in axes(new, 2)
                if data[i, j] === 'L'
                    if i != 1
                        if j != 1
                            if data[i - 1, j - 1] === '#'
                                continue
                            end
                        end
                        if data[i - 1, j] === '#'
                            continue
                        end
                        if j != w
                            if data[i - 1, j + 1] === '#'
                                continue
                            end
                        end
                    end
                    if j != 1
                        if data[i, j - 1] === '#'
                            continue
                        end
                    end
                    if j != w
                        if data[i, j + 1] === '#'
                            continue
                        end
                    end
                    if i != h
                        if j != 1
                            if data[i + 1, j - 1] === '#'
                                continue
                            end
                        end
                        if data[i + 1, j] === '#'
                            continue
                        end
                        if j != w
                            if data[i + 1, j + 1] === '#'
                                continue
                            end
                        end
                    end
                    new[i, j] = '#'
                end
                if data[i, j] === '#'
                    count = 0
                    if i != 1
                        if j != 1
                            if data[i - 1, j - 1] === '#'
                                count += 1
                            end
                        end
                        if data[i - 1, j] === '#'
                            count += 1
                        end
                        if j != w
                            if data[i - 1, j + 1] === '#'
                                count += 1
                            end
                        end
                    end
                    if j != 1
                        if data[i, j - 1] === '#'
                            count += 1
                        end
                    end
                    if j != w
                        if data[i, j + 1] === '#'
                            count += 1
                        end
                    end
                    if i != h
                        if j != 1
                            if data[i + 1, j - 1] === '#'
                                count += 1
                            end
                        end
                        if data[i + 1, j] === '#'
                            count += 1
                        end
                        if j != w
                            if data[i + 1, j + 1] === '#'
                                count += 1
                            end
                        end
                    end
                    if count >= 4
                        new[i, j] = 'L'
                    end
                end
            end
        end
        new_c = count(p -> p === '#', new)
    end
    c
end

t = read_file("i11t0")
#= display(t) =#
@time inp = read_file("i11")

Test.@test seats1(t) === 37

@time a = seats1(inp)
println(a)
Test.@test a === 2126

function ray(data::Array{Char,2}, i::Int, j::Int, di::Int, dj::Int, h::Int, w::Int)::Bool
    while true
        i += di
        j += dj
        if !(1 <= i <= h && 1 <= j <= w) || data[i, j] === 'L'
            return false
        elseif data[i, j] === '#'
            return true
        end
    end
end

function seats2(d::Array{Char,2})::Int
    new = copy(d)
    h, w = size(new)
    c = 1
    new_c = 0
    dirs = ((-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1))
    while new_c != c
        data = copy(new)
        c = new_c
        for i in axes(new, 1)
            for j in axes(new, 2)
                if data[i, j] === 'L'
                    if !any(dir -> ray(data, i, j, dir..., h, w), dirs)
                        new[i, j] = '#'
                    end
                elseif data[i, j] === '#'
                    if count(dir -> ray(data, i, j, dir..., h, w), dirs) >= 5
                        new[i, j] = 'L'
                    end
                end
            end
        end
        new_c = count(p -> p === '#', new)
    end
    c
end

Test.@test seats2(t) === 26

@time b = seats2(inp)
println(b)
Test.@test b === 1914
