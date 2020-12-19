#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    raw, mesgs = map(each -> split(each, '\n'), split(Com.file_slurp(name), "\n\n"))
    rules = Vector(undef, length(raw))
    for r in raw
        m = match(r"^(\d+): (.*)$", r)
        ii = parse(Int, m.captures[1]) + 1
        r = m.captures[2]
        if r[1] == '"'
            rules[ii] = r[2]
        else
            r = map(i -> map(j -> parse(Int, j) + 1, split(i, " ")), split(r, " | "))
            rules[ii] = r
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
        if length(rule) == 1
            builder(rules, rule[1])
        elseif length(rule) == 2
            a1 = builder(rules, rule[1])
            a2 = builder(rules, rule[2])
            as = []
            for i in a1, j in a2
                push!(as, i * j)
            end
            as
        else
            a1 = builder(rules, rule[1])
            a2 = builder(rules, rule[2])
            a3 = builder(rules, rule[3])
            as = []
            for i in a1, j in a2, k in a3
                push!(as, i * j * k)
            end
            as
        end
    else
        as = []
        for set in rule
            if length(set) == 1
                push!(as, builder(rules, set[1]))
            else
                a1 = builder(rules, set[1])
                a2 = builder(rules, set[2])
                for i in a1, j in a2
                    push!(as, i * j)
                end
            end
        end
        as
    end

end

function one(data)
    rules, mesgs = data
    mesgs = Set(mesgs)
    rules = builder(rules, 1)
    length(intersect(mesgs, rules))
end

t1 = read_file("i19t1")
inp = read_file("i19")

println(one(t1))
Test.@test one(t1) == 2

@time a = one(inp)
println(a)
Test.@test a == 224

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t)) =#
#= Test.@test two(t) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
