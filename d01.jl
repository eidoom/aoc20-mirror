#!/usr/bin/env julia

import Test

function read(name)
    f = open(name, "r")
    d = [parse(UInt, b) for b in readlines(f)]
    close(f)
    d
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

@time println(find(2020, inp))

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

@time println(find2(2020, inp))
