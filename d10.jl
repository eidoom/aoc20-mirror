#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    sort(map(x -> parse(Int, x), Com.file_lines(name)))
end

function first(data)
    one = data[1] == 1 ? 1 : 0
    three = 1 + (data[1] == 3 ? 1 : 0)
    for i = 2:length(data)
        j = data[i] - data[i - 1]
        if j == 1
            one += 1
        elseif j == 3
            three += 1
        end
    end
    one * three
end

t0 = read_file("i10t0")
t1 = read_file("i10t1")
inp = read_file("i10")

Test.@test first(t0) == 35
Test.@test first(t1) == 220

@time a = first(inp)
println(a)
Test.@test a == 2312

#= function fib(n, cache = Dict()) =#
#=     if n <= 1 =#
#=         n =#
#=     else =#
#=         for m in (n - 1, n - 2) =#
#=             if !haskey(cache, m) =#
#=                 cache[m] = fib(m, cache) =#
#=             end =#
#=         end =#
#=         cache[n - 1] + cache[n - 2] =#
#=     end =#
#= end =#

function trib(n, cache = Dict())
    if n == 1
        1
    elseif n == 2
        2
    elseif n == 3
        4
    else
        for m = (n - 3):(n - 1)
            if !haskey(cache, m)
                cache[m] = trib(m, cache)
            end
        end
        cache[n - 1] + cache[n - 2] + cache[n - 3]
    end
end

function second(data)
    pushfirst!(data, 0)
    count = 0
    total = 1
    for i = 2:length(data)
        j = data[i] - data[i - 1]
        if j == 1
            count += 1
        else
            if count > 1
                total *= trib(count)
            end
            count = 0
        end
    end
    if count > 1
        total *= trib(count)
    end
    total
end

Test.@test second(t0) == 8
Test.@test second(t1) == 19208

@time b = second(inp)
println(b)
Test.@test b == 12089663946752
