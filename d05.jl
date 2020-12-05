#!/usr/bin/env julia

import Test

function read_file(name)
    f = open(name, "r")
    a = readlines(f)
    close(f)
    a
end

t = read_file("i05t0")

function seat1d(data)
    l = length(data)
    low = 0
    upp = (1 << l) - 1
    for c in data
        if c in ['F','L']
            upp -= div(upp - low, 2) + 1
        else
            low += div(upp - low, 2) + 1
        end
    end
    upp
end

function id(data)
    seat1d(data[1:7])*8+seat1d(data[8:10])
end

inp = read_file("i05")

Test.@test id(t[1]) == 357
Test.@test id(t[2]) == 567
Test.@test id(t[3]) == 119
Test.@test id(t[4]) == 820

ids = map(s -> id(s), inp)

@time println(maximum(ids))

function mine(data)
    l = sort(data)
    p = first(l)-1
    for n in l
        if n != p + 1
            return p + 1
        else
            p = n
        end
    end
end

@time println(mine(ids))
