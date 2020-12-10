#!/usr/bin/env julia

import Test

include("./com.jl")
include("./nacci.jl")

function read_file(name)::Array{Int,1}
    sort(map(x -> parse(Int, x), Com.file_lines(name)))
end

function first(data::Array{Int,1})::Int
    one::Int = data[1] === 1 ? 1 : 0
    three::Int = 1 + (data[1] === 3 ? 1 : 0)
    for i::Int = 2:length(data)
        if data[i] - data[i - 1] === 1
            one += 1
        else
            three += 1
        end
    end
    one * three
end

t0 = read_file("i10t0")
t1 = read_file("i10t1")
inp = read_file("i10")

Test.@test first(t0) === 35
Test.@test first(t1) === 220

@time a = first(inp)
println(a)
Test.@test a === 2312

function second(data::Array{Int,1})::Int
    cache = Dict{Int,Int}(1 => 1, 2 => 2, 3 => 4)
    pushfirst!(data, 0)
    count::Int = 0
    total::Int = 1
    for i::Int = 2:length(data)
        if data[i] - data[i - 1] === 1
            count += 1
        else
            if count > 1
                total *= Nacci.trib4(count, cache)
            end
            count = 0
        end
    end
    if count > 1
        total *= Nacci.trib4(count, cache)
    end
    total
end

Test.@test second(t0) === 8
Test.@test second(t1) === 19208

@time b = second(inp)
println(b)
Test.@test b === 12089663946752
