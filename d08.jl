#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    a = map(line -> split(line), Com.file_lines(name))
    [[c, parse(Int, n)] for (c, n) in a]
end

function interpret(data)
    l = length(data)
    a = 0
    i = 1
    v = fill(0, l)
    while all(map(e -> e < 2, v))
        c, n = data[i]
        if c == "acc"
            a += n
            i += 1
        elseif c == "jmp"
            i += n
        elseif c == "nop"
            i += 1
        end
        if i > l
            return (true, a)
        end
        v[i] += 1
    end
    (false, a)
end

function first(data)
    interpret(data)[2]
end

t = read_file("i08t0")
inp = read_file("i08")

Test.@test first(t) == 5

@time a = first(inp)
println(a)
Test.@test a == 1331

function second(data)
    for k = 1:length(data)
        d = deepcopy(data)
        if d[k][1] == "nop"
            d[k][1] = "jmp"
        elseif d[k][1] == "jmp"
            d[k][1] = "nop"
        else
            continue
        end
        b, a = interpret(d)
        if b
            return a
        end
    end
end

Test.@test second(t) == 8

@time b = second(inp)
println(b)
Test.@test b == 1121
