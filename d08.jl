#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    [[c, parse(Int, n)] for (c, n) in split.(Com.file_lines(name))]
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

function run1(data)
    interpret(data)[2]
end

t = read_file("i08t0")
inp = read_file("i08")

Test.@test run1(t) === 5

@time a = run1(inp)
println(a)
Test.@test a === 1331

function run2(d)
    for k = 1:length(d)
        if d[k][1] in ("nop", "jmp")
            d[k][1] = d[k][1] == "nop" ? "jmp" : "nop"
            b, a = interpret(d)
            if b
                return a
            end
            d[k][1] = d[k][1] == "nop" ? "jmp" : "nop"
        end
    end
end

Test.@test run2(t) === 8

@time b = run2(inp)
println(b)
Test.@test b === 1121
