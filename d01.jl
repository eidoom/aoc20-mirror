#!/usr/bin/env julia

import Test

function read(name)
    open(name, "r") do f
        map(b -> parse(UInt, b), readlines(f))
    end
end

function find(target, nums)
    for i in nums
        for j in nums
            if i + j == target
                return i * j
            end
        end
    end
end

t = read("i01t0")
inp = read("i01")

Test.@test find(2020, t) == 514579

@time a = find(2020, inp)
println(a)
Test.@test a == 73371

function find2(target, nums)
    for i in nums
        for j in nums
            for k in nums
                if i + j + k == target
                    return i * j * k
                end
            end
        end
    end
end

Test.@test find2(2020, t) == 241861950

@time b = find2(2020, inp)
println(b)
Test.@test b == 127642310
