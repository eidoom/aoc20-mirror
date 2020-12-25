#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    parse.(Int, Com.file_lines(name))
end

function transform(subject_no, loop_size)
    value = 1
    for _ = 1:loop_size
        value *= subject_no
        value %= 20201227
    end
    value
end

Test.@test transform(7, 8) === 5764801
Test.@test transform(7, 11) === 17807724

function determine(public_key, subject_no)
    loop_size = 1
    while transform(subject_no, loop_size) !== public_key
        loop_size += 1
    end
    loop_size
end

Test.@test determine(5764801, 7) === 8
Test.@test determine(17807724, 7) === 11

function one(data)
    card_public_key, door_public_key = data
    card_loop_size = determine(card_public_key, 7)
    transform(door_public_key, card_loop_size)
end

function one_alt(data)
    card_public_key, door_public_key = data
    door_loop_size = determine(door_public_key, 7)
    transform(card_public_key, door_loop_size)
end

t0 = read_file("i25t0")
inp = read_file("i25")

Test.@test one(t0) === 14897079
Test.@test one_alt(t0) === 14897079

println("Finding encryption key...")
@time a = one_alt(inp)
println(a)
#= Test.@test a === 0 =#

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t0)) =#
#= Test.@test two(t0) === 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b === 0 =#
