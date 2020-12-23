#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name::String)::Vector{Int}
    parse.(Int, collect(Com.file_slurp(name)))
end

function one(circle::Vector{Int}, moves::Int)::String
    n::Int = length(circle)
    i::Int = 1
    for m::Int = 1:moves
        @debug "-- move $(m) --"
        @debug "i: $(i)"
        @debug "cups: $(circle)"
        cur::Int = circle[i]
        if i > n - 3
            circle = circshift(circle, 3)
            i -= (n - 3)
        end
        lifted::Vector{Int} = circle[(i + 1):(i + 3)]
        remain::Vector{Int} = vcat(circle[1:i], circle[(i + 4):end])
        @debug "pick up: $(lifted)"
        dest::Union{Int,Nothing} = nothing
        while dest === nothing
            cur = mod(cur - 1, 1:n)
            dest = findfirst(x -> x === cur, remain)
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

    one::Int = findfirst(x -> x === 1, circle)
    join(circshift(circle, n - one)[1:(end - 1)])
end

t0 = read_file("i23t0")
@time inp = read_file("i23")

Test.@test one(t0, 10) === "92658374"
Test.@test one(t0, 100) === "67384529"

@time a = one(inp, 100)
println(a)
Test.@test a === "45286397"

#= function show_ll(linked) =#
#=     str = "" =#
#=     cur = 1 =#
#=     for i in axes(linked, 1) =#
#=         cur = linked[cur] =#
#=         str *= string(cur) =#
#=         str *= " " =#
#=     end =#
#=     str =#
#= end =#

function two(starter::Vector{Int})
    moves::Int = 10000000
    circle::Vector{Int} = vcat(starter, 10:1000000)
    linked = Vector{Int}(undef, length(circle))
    for i = 1:(length(circle) - 1)
        linked[circle[i]] = circle[i + 1]
    end
    linked[circle[end]] = circle[1]
    n::Int = length(circle)
    cur::Int = circle[end]
    for m = 1:moves
        #= println("-- move $(m) --") =#
        #= println("cups: $(show_ll(linked))")  # slowww =#
        cur = linked[cur]
        #= println("current: $(cur)") =#
        l1 = linked[cur]
        l2 = linked[l1]
        l3 = linked[l2]
        #= println("pick up: $(l1), $(l2), $(l3)") =#
        linked[cur] = linked[l3]
        dest = mod(cur - 1, 1:n)
        while dest in (l1, l2, l3)
            dest = mod(dest - 1, 1:n)
        end
        #= println("destination: $(dest)") =#
        linked[l3] = linked[dest]
        linked[dest] = l1
    end
    e1 = linked[1]
    e2 = linked[e1]
    e1 * e2
end

@time println(two(t0))
Test.@test two(t0) === 149245887792

@time b = two(inp)
println(b)
Test.@test b === 836763710
