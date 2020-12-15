#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name::String)::Array{Int,1}
    map(i::SubString -> parse(Int, i), split(Com.file_slurp(name), ","))
end

function game0(spoken::Array{Int,1}, nth::Int)::Int
    while length(spoken) < nth
        index::Union{Int,Nothing} =
            findlast(i::Int -> i === last(spoken), spoken[1:(end - 1)])
        push!(spoken, index === nothing ? 0 : length(spoken) - index)
    end
    last(spoken)
end

function game(spoken::Array{Int,1}, nth::Int)::Int
    record = Dict{Int,Array{Int,1}}()
    sizehint!(record, nth)
    for (i, s) in enumerate(spoken)
        record[s] = [i]
    end
    cur = last(spoken)
    for i = (length(spoken) + 1):nth
        cur = length(record[cur]) === 1 ? 0 : i - 1 - popfirst!(record[cur])
        if haskey(record, cur)
            push!(record[cur], i)
        else
            record[cur] = [i]
        end
    end
    cur
end

one = 2020
two = 30000000

t0 = read_file("i15t0")
t1 = read_file("i15t1")
t2 = read_file("i15t2")
t3 = read_file("i15t3")
t4 = read_file("i15t4")
t5 = read_file("i15t5")
t6 = read_file("i15t6")

inp = read_file("i15")

Test.@test game(t0, one) === 436
Test.@test game(t1, one) === 1
Test.@test game(t2, one) === 10
Test.@test game(t3, one) === 27
Test.@test game(t4, one) === 78
Test.@test game(t5, one) === 438
Test.@test game(t6, one) === 1836

@time a = game(inp, one)
println(a)
Test.@test a === 755

#= Test.@test game(t0, two) === 175594 =#
#= Test.@test game(t1, two) === 2578 =#
#= Test.@test game(t2, two) === 3544142 =#
#= Test.@test game(t3, two) === 261214 =#
#= Test.@test game(t4, two) === 6895259 =#
#= Test.@test game(t5, two) === 18 =#
#= Test.@test game(t6, two) === 362 =#

#= @time b = game(inp, two) =#
#= println(b) =#
#= Test.@test b === 11962 =#
