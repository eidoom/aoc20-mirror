#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    Com.file_lines(name)
end

function first(data)
    data
end

t = read_file("iNNt0")
inp = read_file("iNN")

println(t)
println(read_file(t))
#= Test.@test first(t) == 0 =#

#= @time a = first(inp) =#
#= println(a) =#
#= Test.@test a == 0 =#

#= function second(data) =#
#=     data =#
#= end =#

#= Test.@test second(t) == 0 =#

#= @time b = second(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
