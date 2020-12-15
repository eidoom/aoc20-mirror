#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    Com.file_lines(name)
end

function one(data)
    data
end

t = read_file("iNNt0")
inp = read_file("iNN")

println(one(t))
#= Test.@test one(t) == 0 =#

#= @time a = one(inp) =#
#= println(a) =#
#= Test.@test a == 0 =#

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t)) =#
#= Test.@test two(t) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
