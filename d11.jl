#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(line -> collect(line), Com.file_lines(name))
end

function first(data)
    new = deepcopy(data)
    h = length(new)
    w = length(new[1])
    c = 1
    new_c = 0
    while new_c != c
        data = deepcopy(new)
        c = new_c
        for i = 1:h
            for j = 1:w
                if data[i][j] === 'L'
                    if i != 1
                        if j != 1
                            if data[i - 1][j - 1] === '#'
                                continue
                            end
                        end
                        if data[i - 1][j] === '#'
                            continue
                        end
                        if j != w
                            if data[i - 1][j + 1] === '#'
                                continue
                            end
                        end
                    end
                    if j != 1
                        if data[i][j - 1] === '#'
                            continue
                        end
                    end
                    if j != w
                        if data[i][j + 1] === '#'
                            continue
                        end
                    end
                    if i != h
                        if j != 1
                            if data[i + 1][j - 1] === '#'
                                continue
                            end
                        end
                        if data[i + 1][j] === '#'
                            continue
                        end
                        if j != w
                            if data[i + 1][j + 1] === '#'
                                continue
                            end
                        end
                    end
                    new[i][j] = '#'
                end
                if data[i][j] === '#'
                    count = 0
                    if i != 1
                        if j != 1
                            if data[i - 1][j - 1] === '#'
                                count += 1
                            end
                        end
                        if data[i - 1][j] === '#'
                            count += 1
                        end
                        if j != w
                            if data[i - 1][j + 1] === '#'
                                count += 1
                            end
                        end
                    end
                    if j != 1
                        if data[i][j - 1] === '#'
                            count += 1
                        end
                    end
                    if j != w
                        if data[i][j + 1] === '#'
                            count += 1
                        end
                    end
                    if i != h
                        if j != 1
                            if data[i + 1][j - 1] === '#'
                                count += 1
                            end
                        end
                        if data[i + 1][j] === '#'
                            count += 1
                        end
                        if j != w
                            if data[i + 1][j + 1] === '#'
                                count += 1
                            end
                        end
                    end
                    if count >= 4
                        new[i][j] = 'L'
                    end
                end
            end
        end
        new_c = count(p -> p === '#', Iterators.flatten(new))
    end
    c
end

t = read_file("i11t0")
inp = read_file("i11")

Test.@test first(t) === 37

@time a = first(inp)
println(a)
Test.@test a === 2126

function ray(data, i, j, di, dj, w, h)
    while true
        i += di
        j += dj
        if !(1 <= i <= h && 1 <= j <= w) || data[i][j] === 'L'
            return false
        elseif data[i][j] === '#'
            return true
        end
    end
end

#= function show(data) =#
#=     for l in data =#
#=         println(join(l)) =#
#=     end =#
#=     println() =#
#= end =#

function second(d)
    new = deepcopy(d)
    h = length(new)
    w = length(new[1])
    c = 1
    new_c = 0
    dirs = ((-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1))
    while new_c != c
        data = deepcopy(new)
        c = new_c
        for i = 1:h
            for j = 1:w
                if data[i][j] === 'L'
                    if !any(dir -> ray(data, i, j, dir..., w, h), dirs)
                        new[i][j] = '#'
                    end
                elseif data[i][j] === '#'
                    if count(dir -> ray(data, i, j, dir..., w, h), dirs) >= 5
                        new[i][j] = 'L'
                    end
                end
            end
        end
        new_c = count(p -> p === '#', Iterators.flatten(new))
    end
    c
end

Test.@test second(t) === 26

@time b = second(inp)
println(b)
Test.@test b === 1914
