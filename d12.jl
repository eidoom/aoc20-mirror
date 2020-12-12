#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(line -> (line[1], parse(Int, line[2:end])), Com.file_lines(name))
end

conv = Dict('N' => [0, 1], 'E' => [1, 0], 'S' => [0, -1], 'W' => [-1, 0])

function first(navs)
    facing = 'E'
    ship = [0, 0]  # EN
    to_deg = Dict('N' => 0, 'E' => 90, 'S' => 180, 'W' => 270)
    to_dir = Dict(map(reverse, collect(to_deg)))
    for (act, val) in navs
        if act === 'F'
            ship += val * conv[facing]
        elseif act in ('N', 'E', 'S', 'W')
            ship += val * conv[act]
        else
            facing = to_dir[mod(to_deg[facing] + (act === 'R' ? 1 : -1) * val, 360)]
        end
    end
    sum(map(i -> abs(i), ship))
end

t = read_file("i12t0")
inp = read_file("i12")

println(first(t))
Test.@test first(t) == 25

@time a = first(inp)
println(a)
Test.@test a == 904

function second(navs)
    waypoint = [10, 1]  # EN
    ship = [0, 0]  # EN
    for (act, val) in navs
        if act === 'F'
            ship += val * waypoint
        elseif act in ('N', 'E', 'S', 'W')
            waypoint += val * conv[act]
        else
            x, y = waypoint
            if act === 'R'
                val *= -1
            end
            waypoint =
                [Int(x * cosd(val) - y * sind(val)), Int(x * sind(val) + y * cosd(val))]
        end
    end
    sum(map(i -> abs(i), ship))
end

println(second(t))
Test.@test second(t) == 286

@time b = second(inp)
println(b)
Test.@test b == 18747
