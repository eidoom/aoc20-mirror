#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    parse.(Int, Com.file_lines(name))
end

function weakness1(data, preamble)
    i = 1
    while i + preamble <= length(data)
        sums = []
        for ii = i:(i + preamble - 1)
            for jj = (ii + 1):(i + preamble - 1)
                push!(sums, data[ii] + data[jj])
            end
        end
        if !(data[i + preamble] in sums)
            return data[i + preamble]
        end
        i += 1
    end
end

t = read_file("i09t0")
inp = read_file("i09")

ant = weakness1(t, 5)
Test.@test ant == 127

@time a = weakness1(inp, 25)
println(a)
Test.@test a == 57195069

function weakness2(data, ans)
    len = length(data)
    for l = 1:len
        for i = 1:(len - l)
            if ans == sum(data[i:(i + l)])
                return minimum(data[i:(i + l)]) + maximum(data[i:(i + l)])
            end
        end
    end
end

Test.@test weakness2(t, ant) == 62

@time b = weakness2(inp, a)
println(b)
Test.@test b == 7409241
