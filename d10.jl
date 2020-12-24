#!/usr/bin/env julia

import Test

include("./com.jl")
include("./nacci.jl")

function read_file(name)::Vector{Int}
    sort(parse.(Int, Com.file_lines(name)))
end

function jolts(data::Vector{Int})::Int
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

Test.@test jolts(t0) === 35
Test.@test jolts(t1) === 220

@time a = jolts(inp)
println(a)
Test.@test a === 2312

function arrangements(data::Vector{Int})::Int
    cache::Vector{Int} = [1, 2, 4]
    pushfirst!(data, 0)
    count::Int = 0
    total::Int = 1
    for i::Int = 2:length(data)
        if data[i] - data[i - 1] === 1
            count += 1
        else
            if count > 1
                total *= Nacci.n_nacci(3, count, cache)
            end
            count = 0
        end
    end
    if count > 1
        total *= Nacci.n_nacci(3, count, cache)
    end
    total
end

Test.@test arrangements(t0) === 8
Test.@test arrangements(t1) === 19208

@time b = arrangements(inp)
println(b)
Test.@test b === 12089663946752
