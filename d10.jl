#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(x -> parse(Int, x), Com.file_lines(name))
end

function first(data)
    data = sort(data)
    one = data[1] == 1 ? 1 : 0
    three = 1 + (data[1] == 3 ? 1 : 0)
    for i = 2:length(data)
        j=data[i]-data[i-1]
        if j == 1
            one += 1
        elseif j == 3
            three += 1
        end
    end
    one * three
end

t0 = read_file("i10t0")
t1 = read_file("i10t1")
inp = read_file("i10")

Test.@test first(t0) == 35   
Test.@test first(t1) == 220

@time a = first(inp)
println(a)
#= Test.@test a == 0 =#

#= function second(data) =#
#=     data =#
#= end =#

#= println(second(t)) =#
#= Test.@test second(t) == 0 =#

#= @time b = second(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
