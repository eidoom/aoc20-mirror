#!/usr/bin/env julia

import Test

include("./com.jl")

function read_rules(data)
    rules = []
    for d in data
        m = match(r"^\w+: (\d+)-(\d+) or (\d+)-(\d+)$", d)
        if m !== nothing
            this = map(
                j -> map(i -> parse(Int, i), map(k -> m.captures[j + k], (0, 1))),
                (1, 3),
            )
            push!(rules, this)
        end
    end
    rules
end

function read_tickets(data)
    map(line -> map(n -> parse(Int, n), split(line, ",")), data[2:end])
end

function read_file(name)
    rules, yours, nearby = map(sec -> split(sec, '\n'), split(Com.file_slurp(name), "\n\n"))
    read_rules(rules), read_tickets(nearby)
end

function check_valid(rules, n)
    any(rule -> any((low <= n <= high) for (low, high) in rule), rules)

end

function one(data)
    rules, nearby = data
    invalid = 0
    for ticket in nearby
        for n in ticket
            if !check_valid(rules, n)
                invalid += n
            end
        end
    end
    invalid
end

t0 = read_file("i16t0")
t1 = read_file("i16t1")
inp = read_file("i16")

Test.@test one(t0) == 71

@time a = one(inp)
println(a)
Test.@test a == 27911

function two(data)
    data
end

println(two(t0))
#= Test.@test two(t0) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
