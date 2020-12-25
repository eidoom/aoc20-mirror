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

function find_loop_size(public_key, subject_no)
    loop_size = 0
    value = 1
    while value !== public_key
        value *= subject_no
        value %= 20201227
        loop_size += 1
    end
    loop_size
end

Test.@test find_loop_size(5764801, 7) === 8
Test.@test find_loop_size(17807724, 7) === 11

function find_encryption_key(public_keys)
    card_public_key, door_public_key = public_keys
    card_loop_size = find_loop_size(card_public_key, 7)
    transform(door_public_key, card_loop_size)
end

function find_encryption_key_alt(public_keys)
    card_public_key, door_public_key = public_keys
    door_loop_size = find_loop_size(door_public_key, 7)
    transform(card_public_key, door_loop_size)
end

t0 = read_file("i25t0")
inp = read_file("i25")

Test.@test find_encryption_key(t0) === 14897079
Test.@test find_encryption_key_alt(t0) === 14897079

@time a = find_encryption_key(inp)
println(a)
Test.@test a === 10548634
