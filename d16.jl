#!/usr/bin/env julia

import Test

include("./com.jl")

function read_rules(data)
    rules = Dict()
    for d in data
        m = match(r"^([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)$", d)
        if m !== nothing
            this = map(
                j -> map(i -> parse(Int, i), map(k -> m.captures[j + k], (0, 1))),
                (2, 4),
            )
            rules[m.captures[1]] = this
        end
    end
    rules
end

function read_tickets(data)
    map(line -> map(n -> parse(Int, n), split(line, ",")), data[2:end])
end

function read_file(name)
    rules, yours, nearby = map(sec -> split(sec, '\n'), split(Com.file_slurp(name), "\n\n"))
    read_rules(rules), first(read_tickets(yours)), read_tickets(nearby)
end

function check_valid(rules, n)
    any(rule -> any((low <= n <= high) for (low, high) in rule), values(rules))

end

function one(data)
    rules, _, nearby = data
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
#= t1 = read_file("i16t1") =#
inp = read_file("i16")

Test.@test one(t0) == 71

@time a = one(inp)
println(a)
Test.@test a == 27911

function possibilities(rules, tickets)
    pos = []
    for col = 1:length(tickets[1])
        this = []
        for (name, ranges) in rules
            if all(
                ticket -> any(low <= ticket[col] <= high for (low, high) in ranges),
                tickets,
            )
                push!(this, name)
            end
        end
        push!(pos, this)
    end
    pos
end

function ordering(pos)
    order = Array{String}(undef, length(pos))
    i = 1
    while any(p -> length(p) != 0, pos)
        if length(pos[i]) == 1
            cur = pop!(pos[i])
            order[i] = cur
            for p in pos
                filter!(i -> i != cur, p)
            end
        end
        i = mod(i + 1, 1:length(pos))
    end
    order
end

function two(data)
    rules, yours, nearby = data
    valid = filter(ticket -> all(n -> check_valid(rules, n), ticket), nearby)
    pos = possibilities(rules, valid)
    unique = ordering(pos)
    res = 1
    for (field, num) in zip(unique, yours)
        if contains(field, "departure")
            res *= num
        end
    end
    res
end

#= @time two(t1) =#

@time b = two(inp)
println(b)
Test.@test b == 737176602479
