#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(line -> (line[1], parse(Int, line[2:end])), Com.file_lines(name))
end

function first(navs)
    facing = 'E'
    EN = [0, 0]
    to_deg = Dict('N' => 0, 'E' => 90, 'S' => 180, 'W' => 270)
    to_dir = Dict(map(reverse, collect(to_deg)))
    conv = Dict('N' => [0, 1], 'E' => [1, 0], 'S' => [0, -1], 'W' => [-1, 0])
    for (act, val) in navs
        if act === 'F'
            EN += val * conv[facing]
        elseif act in ('N', 'E', 'S', 'W')
            EN += val * conv[act]
        elseif act === 'R'
            facing = to_dir[mod(to_deg[facing] + val, 360)]
        elseif act === 'L'
            facing = to_dir[mod(to_deg[facing] - val, 360)]
        end
    end
    abs(EN[1]) + abs(EN[2])
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
    to_deg = Dict('N' => 0, 'E' => 90, 'S' => 180, 'W' => 270)
    to_dir = Dict(map(reverse, collect(to_deg)))
    conv = Dict('N' => [0, 1], 'E' => [1, 0], 'S' => [0, -1], 'W' => [-1, 0])
    for (act, val) in navs
        if act === 'F'
            ship += val * waypoint
        elseif act in ('N', 'E', 'S', 'W')
            waypoint += val * conv[act]
        elseif act === 'R'
            println(act, " ", val)
            x, y = waypoint
            waypoint = [x * cosd(val) + y * sind(val), - x * sind(val) + y * cosd(val)]
        elseif act === 'L'
            x, y = waypoint
            waypoint = [x * cosd(val) - y * sind(val), x * sind(val) + y * cosd(val)]
        end
        println(ship, " ", waypoint)
    end
    abs(ship[1]) + abs(ship[2])
end

println(second(t))
Test.@test second(t) == 286

@time b = second(inp)
println(b)
Test.@test b == 18747
