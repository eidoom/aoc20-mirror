#!/usr/bin/env julia

import Test

function read_file(name)
    a = open(name, "r") do f
        read(f, String)
    end
    map(i -> split(i, '\n'), split(strip(a), "\n\n"))
end

function yes(data)
    ayes = 0
    for group in data
        gyes = Set()
        for person in group
            for question in person
                push!(gyes, question)
            end
        end
        ayes += length(gyes)
    end
    ayes
end

t = read_file("i06t0")
inp = read_file("i06")

Test.@test yes(t) == 11

@time a = yes(inp)
println(a)
Test.@test a == 6297

function two(data)
    ayes = 0
    for group in data
        ayes += length(intersect(map(i -> Set(i), group)...))
    end
    ayes
end

Test.@test two(t) == 6

@time b = two(inp)
println(b)
Test.@test b == 3158
