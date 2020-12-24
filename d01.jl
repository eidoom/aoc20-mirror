#!/usr/bin/env julia

import Test

include("./com.jl")

function get_data(name::String)::Vector{UInt}
    parse.(UInt, Com.file_lines(name))
end

function find(target::UInt, nums::Vector{UInt})::UInt
    for i in nums
        for j in nums
            if i + j === target
                return i * j
            end
        end
    end
end

t = get_data("i01t0")
inp = get_data("i01")

Test.@test find(UInt(2020), t) === UInt(514579)

@time a = find(UInt(2020), inp)
println(a)
Test.@test a === UInt(73371)

function find2(target::UInt, nums::Vector{UInt})::UInt
    for i in nums
        for j in nums
            for k in nums
                if i + j + k === target
                    return i * j * k
                end
            end
        end
    end
end

Test.@test find2(UInt(2020), t) === UInt(241861950)

@time b = find2(UInt(2020), inp)
println(b)
Test.@test b === UInt(127642310)
