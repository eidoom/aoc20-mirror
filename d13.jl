#!/usr/bin/env julia

import Test

include("./com.jl")

function read_line(line)
    [(i - 1, parse(Int, j)) for (i, j) in enumerate(split(line, ",")) if j != "x"]
end

function read_file(name)
    target, multiples = Com.file_lines(name)
    (parse(Int, target), read_line(multiples))
end

function read_test(name)
    read_line(Com.file_slurp(name))
end

function earliest(tar, mul)
    #= min(m -> div(tar, m[2]), mul) =#
    best = typemax(Int)
    ans = 0
    for (_, m) in mul
        quotient = div(tar, m)
        if quotient < best
            best = quotient
            ans = m
        end
    end
    (ans * (best + 1) - tar) * ans
end

t = read_file("i13t0")
inp = read_file("i13")

Test.@test earliest(t...) == 295

@time a = earliest(inp...)
println(a)
Test.@test a == 3269

# brute force (systematic search)
#= function offsets(pairs) =#
#=     pairs = sort(pairs, by = i -> i[2]) =#
#=     shortest = pairs[1][2] =#
#=     buses = [(id - offset, id) for (offset, id) in pairs[2:end]] =#
#=     t = 0 =#
#=     while true =#
#=         t += shortest =#
#=         if all(bus -> mod(t, bus[2]) == bus[1], buses) =#
#=             return t =#
#=         end =#
#=     end =#
#= end =#

# using proof
function offsets(pairs)
    pairs = [(mod(n - ab, n), n) for (ab, n) in pairs]
    tot = 0
    N = prod(map(pair -> pair[2], pairs))
    for (a, n) in pairs
        inv = div(N, n)
        tot += a * invmod(inv, n) * inv
    end
    mod(tot, N)
end

Test.@test offsets([(0, 3), (1, 4), (1, 5)]) == 39
Test.@test offsets(t[2]) == 1068781

t5 = read_test("i13t5")
Test.@test offsets(t5) == 3417
t1 = read_test("i13t1")
Test.@test offsets(t1) == 754018
t2 = read_test("i13t2")
Test.@test offsets(t2) == 779210
t3 = read_test("i13t3")
Test.@test offsets(t3) == 1261476
t4 = read_test("i13t4")
Test.@test offsets(t4) == 1202161486

@time b = offsets(inp[2])
println(b)
#= Test.@test b == 0 =#
