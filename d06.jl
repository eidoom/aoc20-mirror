#!/usr/bin/env julia

import Test

include("./com.jl")

function yes(data)
    sum(map(group -> length(Set(Iterators.flatten(group))), data))
end

t = Com.file_sents("i06t0")
inp = Com.file_sents("i06")

Test.@test yes(t) == 11

@time a = yes(inp)
println(a)
Test.@test a == 6297

function two(data)
    sum(map(group -> length(intersect(map(i -> Set(i), group)...)), data))
end

Test.@test two(t) == 6

@time b = two(inp)
println(b)
Test.@test b == 3158

Test.@test two(read_file("i06t1")) == 3512
