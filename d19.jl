#!/usr/bin/env julia

import Test

include("./com.jl")

#= rules are indexed by their position in the array =#
function read_file(
    name::String,
)::Tuple{Vector{Union{Vector{Vector{Int}},Char}},Vector{SubString}}
    raw, mesgs = map(each -> split(each, '\n'), split(Com.file_slurp(name), "\n\n"))
    rules = Vector(undef, length(raw))
    for r in raw
        m = match(r"^(\d+): (.*)$", r)
        ii = parse(Int, m.captures[1]) + 1
        if ii > length(rules)
            resize!(rules, ii)
        end
        r = m.captures[2]
        if r[1] === '"'
            rules[ii] = r[2]
        else
            r = map(i -> map(j -> parse(Int, j) + 1, split(i, " ")), split(r, " | "))
            rules[ii] = r
        end
    end
    rules, mesgs
end

#= recursively generate all strings which are allowed by rules =#
function builder(rules, i::Int = 1)
    rule = rules[i]

    if isa(rule, Char)
        rule
    elseif length(rule) === 1 && length(rule[1]) === 1
        builder(rules, rule[1][1])
    else
        as = []
        for set in rule
            if length(set) === 1
                push!(as, builder(rules, set[1]))
            elseif length(set) === 2
                a1 = builder(rules, set[1])
                a2 = builder(rules, set[2])
                for i in a1, j in a2
                    push!(as, i * j)
                end
            elseif length(set) === 3
                a1 = builder(rules, set[1])
                a2 = builder(rules, set[2])
                a3 = builder(rules, set[3])
                for i in a1, j in a2, k in a3
                    push!(as, i * j * k)
                end
            end
        end
        as
    end

end

function one(rules, mesgs)
    mesgs = Set(mesgs)
    allowed = builder(rules)
    length(intersect(mesgs, allowed))
end

t1 = read_file("i19t1")
@time r1, m1 = read_file("i19")

Test.@test one(t1...) === 2

@time a = one(r1, m1)
println(a)
Test.@test a === 224

#= function fix(in1) =#
#=     in2 = deepcopy(in1) =#
#=     in2[9] = [[43], [43, 9]] =#
#=     in2[12] = [[43, 32], [43, 12, 32]] =#
#=     in2 =#
#= end =#

#= function additions(in1) =#
#=     in2 = deepcopy(in1) =#
#=     in2[9] = [[43], [43, 43]] =#
#=     in2[12] = [[43, 32], [43, 43, 32, 32]] =#
#=     in2 =#
#= end =#

t2r, t2m = read_file("i19t2")
Test.@test one(t2r, t2m) === 3

#= println(builder(t2r)) =#

#= t2rf = fix(t2r) =#
#= r2 = fix(r1) =#

#= function two(rules, mesgs) =#
#=     data =#
#= end =#

#= println(one(additions(t2r), t2m)) =#
#= Test.@test two(t) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
