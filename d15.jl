#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(i -> parse(Int, i), split(Com.file_slurp(name), ","))
end

function game(spoken::Array{Int,1}, nth)
    while length(spoken) < nth
        prev = last(spoken)
        if prev in spoken[1:(end - 1)]
            push!(spoken, length(spoken) - findlast(i -> i == prev, spoken[1:(end - 1)]))
        else
            push!(spoken, 0)
        end
    end
    last(spoken)
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

Test.@test game(t0, one) == 436
Test.@test game(t1, one) == 1
Test.@test game(t2, one) == 10
Test.@test game(t3, one) == 27
Test.@test game(t4, one) == 78
Test.@test game(t5, one) == 438
Test.@test game(t6, one) == 1836

@time a = game(inp, one)
println(a)
Test.@test a == 755

#= println(game(t0, two)) =#

#= Test.@test game(t0, two) == 175594 =#
#= Test.@test game(t1, two) == 2578 =#
#= Test.@test game(t2, two) == 3544142 =#
#= Test.@test game(t3, two) == 261214 =#
#= Test.@test game(t4, two) == 6895259 =#
#= Test.@test game(t5, two) == 18 =#
#= Test.@test game(t6, two) == 362 =#

#= @time b = game(inp, two) =#
#= println(b) =#
#= Test.@test b == 0 =#
