#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    Com.file_lines(name)
end

function one(data)
    data
end

t0 = read_file("i25t0")
inp = read_file("i25")

println(one(t0))
#= Test.@test one(t0) === 0 =#

#= @time a = one(inp) =#
#= println(a) =#
#= Test.@test a === 0 =#

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t0)) =#
#= Test.@test two(t0) === 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b === 0 =#
