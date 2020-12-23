#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    parse.(Int, collect(Com.file_slurp(name)))
end

function one(circle, moves)
    n = length(circle)
    i = 1
    m = 1
    for _ = 1:moves
        @debug "-- move $(m) --"
        m += 1
        @debug "i: $(i)"
        @debug "cups: $(circle)"
        cur = circle[i]
        if i > n - 3
            circle = circshift(circle, 3)
            i -= (n - 3)
        end
        lifted = circle[(i + 1):(i + 3)]
        remain = vcat(circle[1:i], circle[(i + 4):end])
        @debug "pick up: $(lifted)"
        dest = nothing
        while dest === nothing
            cur = mod(cur - 1, 1:n)
            dest = findfirst(x -> x === (cur), remain)
        end
        @debug "I: $(dest)"
        if dest < i
            i += 3
        end
        @debug "destination: $(remain[dest])\n"
        circle = vcat(remain[1:dest], lifted, remain[(dest + 1):end])
        i = mod(i + 1, 1:9)
    end
    @debug "-- final --"
    @debug "cups: $(circle)"

    one = findfirst(x -> x === 1, circle)
    join(circshift(circle, n - one)[1:(end - 1)])
end

t0 = read_file("i23t0")
inp = read_file("i23")

Test.@test one(t0, 10) === "92658374"
Test.@test one(t0, 100) === "67384529"

@time a = one(inp, 100)
println(a)
Test.@test a === "45286397"

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t0)) =#
#= Test.@test two(t0) === 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b === 0 =#
