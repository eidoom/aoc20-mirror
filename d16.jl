#!/usr/bin/env julia

import Test

include("./com.jl")

function read_rules(data)
    rules = Dict()
    for d in data
        m = match(r"^([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)$", d)
        if m !== nothing
            rules[m.captures[1]] = map(
                j -> map(i -> parse(Int, i), map(k -> m.captures[j + k], (0, 1))),
                (2, 4),
            )
        end
    end
    rules
end

function read_tickets(data)
    map(line -> map(n -> parse(Int, n), split(line, ",")), data[2:end])
end

function read_file(name)
    rules, yours, nearby = map(sec -> split(sec, '\n'), Com.file_paras(name))
    read_rules(rules), first(read_tickets(yours)), read_tickets(nearby)
end

function check_ticket(rules, n)
    any((low <= n <= high) for (low, high) in rules)
end

function check_valid(rules, n)
    any(rule -> check_ticket(rule, n), values(rules))
end

#= check each number of each ticket for validity by any field =#
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
inp = read_file("i16")

Test.@test one(t0) == 71

@time a = one(inp)
println(a)
Test.@test a == 27911

#= go through "columns of the ticket matrix" to see which fields they satisfy =#
function possibilities(rules, tickets)
    pos = []
    for col = 1:length(tickets[1])
        this = []
        for (name, ranges) in rules
            if all(ticket -> check_ticket(ranges, ticket[col]), tickets)
                push!(this, name)
            end
        end
        push!(pos, this)
    end
    pos
end

#= find the correct choice of field for each column by iteratively setting columns with only one choice and removing that choice from its positions (so then there's another with only one choice, and so on) =#
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

#= look at tickets which contain only numbers that are valid by any field, then find the correct ordering of fields, then give product of departure fields =#
function two(data)
    rules, yours, nearby = data
    valid = filter(ticket -> all(n -> check_valid(rules, n), ticket), nearby)
    pos = possibilities(rules, valid)
    unique = ordering(pos)
    res = 1
    for (field, num) in zip(unique, yours)
        if contains(field, "departure ")
            res *= num
        end
    end
    res
end

#= t1 = read_file("i16t1") =#
#= @time two(t1) =#

@time b = two(inp)
println(b)
Test.@test b == 737176602479
