#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    raw, mesgs = map(each -> split(each, '\n'), split(Com.file_slurp(name), "\n\n"))
    rules = []
    for r in raw
        m = match(r"^(\d+): (.*)$", r)
        r = m.captures[2]
        if r[1] == '"'
            push!(rules, r[2])
        else
            r = map(i -> map(j -> parse(Int, j) + 1, split(i, " ")), split(r, " | "))
            push!(rules, r)
        end
    end
    rules, mesgs
end

function builder(rules, i)
    rule = rules[i]

    if isa(rule, Char)
        rule
    elseif length(rule) == 1
        rule = rule[1]
        if length(rule) == 2
            broadcast(*, builder(rules, rule[1]), builder(rules, rule[2]))
        else
            broadcast(
                *,
                builder(rules, rule[1]),
                builder(rules, rule[2]),
                builder(rules, rule[3]),
            )
        end
    else
        as = []
        for set in rule
            p1, p2 = set
            a1 = builder(rules, p1)
            a2 = builder(rules, p2)
            for i in a1
                for j in a2
                    push!(as, i*j)
                end
            end
        end
        println("as ", as)
        as
    end

end

function one(data)
    rules, mesgs = data
    #= println(rules) =#
    mesgs = Set(mesgs)
    #= println(mesgs) =#
    rules = Set(builder(rules, 1))
    println("rules ", rules)
    length(intersect(mesgs, rules))
    #= as = [] =#
    #= is = [1] =#
    #= #1= while true =1# =#
    #= i = pop!(is) =#
    #= a = "" =#
    #= rule = rules[i] =#

    #= if isa(rule, Char) =#
    #=     a *= rule =#
    #= else =#
    #=     for set in rule =#
    #=         for pos in set =#
    #=             push!(is, pos) =#
    #=         end =#
    #=     end =#
    #= end =#
    #= #1= end =1# =#
end

#= t0 = read_file("i19t0") =#
t1 = read_file("i19t1")
#= t2 = read_file("i19t2") =#
inp = read_file("i19")

#= println(one(t0)) =#
@time println(one(t1))
#= @time println(one(t2)) =#
#= Test.@test one(t) == 0 =#

#= @time a = one(inp) =#
#= println(a) =#
#= Test.@test a == 0 =#

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t)) =#
#= Test.@test two(t) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
