#!/usr/bin/env julia

import Test

include("./com.jl")

const Rule = NTuple{2,NTuple{2,Int}}
const Rules = Dict{String,Rule}
const Ticket = Vector{Int}
const Tickets = Vector{Ticket}
const Fields = Vector{String}

function read_rules(data::Vector{String})::Rules
    rules = Rules()
    for d in data
        m = match(r"^([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)$", d)
        if m !== nothing
            rules[m.captures[1]] =
                map(j -> parse.(Int, map(k -> m.captures[j + k], (0, 1))), (2, 4))
        end
    end
    rules
end

function read_tickets(data::Vector{String})::Tickets
    map(line -> parse.(Int, split(line, ",")), data[2:end])
end

function read_file(name::String)::Tuple{Rules,Ticket,Tickets}
    rules, yours, nearby = Com.file_sents(name)
    read_rules(rules), first(read_tickets(yours)), read_tickets(nearby)
end

function check_ticket(rule::Rule, n::Int)::Bool
    any((low <= n <= high) for (low, high) in rule)
end

function check_valid(rules::Rules, n::Int)::Bool
    any(rule -> check_ticket(rule, n), values(rules))
end

#= check each number of each ticket for validity by any field =#
function one(data::Tuple{Rules,Ticket,Tickets})::Int
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
@time inp = read_file("i16")

Test.@test one(t0) === 71

@time a = one(inp)
println(a)
Test.@test a === 27911

#= go through "columns of the ticket matrix" to see which fields they satisfy =#
function possibilities(rules::Rules, tickets::Tickets)::Vector{Fields}
    pos = []
    for col in axes(tickets[1], 1)
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
function ordering(pos::Vector{Fields})::Fields
    order = Fields(undef, length(pos))
    i = 1
    while any(p -> length(p) !== 0, pos)
        if length(pos[i]) === 1
            cur = pop!(pos[i])
            order[i] = cur
            for p in pos
                filter!(j -> j !== cur, p)
            end
        end
        i = mod(i + 1, axes(pos, 1))
    end
    order
end

#= look at tickets which contain only numbers that are valid by any field, then find the correct ordering of fields, then give product of departure fields =#
function two(data::Tuple{Rules,Ticket,Tickets})::Iterators.Zip{Tuple{Fields,Vector{Int}}}
    rules, yours, nearby = data
    valid = filter(ticket -> all(n -> check_valid(rules, n), ticket), nearby)
    pos = possibilities(rules, valid)
    unique = ordering(pos)
    zip(unique, yours)
end

function departures(data::Tuple{Rules,Ticket,Tickets})::Int
    sorted = two(data)
    res = 1
    for (field, num) in sorted
        if contains(field, "departure ")
            res *= num
        end
    end
    res
end

t1 = read_file("i16t1")
Test.@test collect(two(t1)) == [("row", 11), ("class", 12), ("seat", 13)]

@time b = departures(inp)
println(b)
Test.@test b === 737176602479
