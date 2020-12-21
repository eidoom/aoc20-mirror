#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name::String)::Vector{Tuple{Vector{SubString},Vector{SubString}}}
    res::Vector{Tuple{Vector{SubString},Vector{SubString}}} = []
    for line in Com.file_lines(name)
        ing, aln = split(line[1:(end - 1)], " (contains ")
        push!(res, (split(ing), split(aln, ", ")))
    end
    res
end

function one(recipes::Vector{Tuple{Vector{SubString},Vector{SubString}}})::Int
    alns::Set{SubString} = Set()
    ings::Set{SubString} = Set()
    for (r_ings, r_alns) in recipes
        for ing in r_ings
            push!(ings, ing)
        end
        for aln in r_alns
            push!(alns, aln)
        end
    end
    #= dan = [] =#
    cnts::Set{SubString} = Set()
    for aln in alns
        cnt = deepcopy(ings)
        for (r_ings, r_alns) in recipes
            if aln in r_alns
                cnt = intersect(cnt, r_ings)
            end
        end
        #= push!(dan, (aln, cnt)) =#
        for c in cnt
            push!(cnts, c)
        end
    end
    #= println(dan) =#
    saf::Set{SubString} = setdiff(ings, cnts)
    ctr::Int = 0
    for (r_ings, _) in recipes
        for ing in r_ings
            if ing in saf
                ctr += 1
            end
        end
    end
    ctr
end

t = read_file("i21t0")
@time inp = read_file("i21")

#= @time println(one(t)) =#
Test.@test one(t) == 5

@time a = one(inp)
println(a)
Test.@test a == 2374

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t)) =#
#= Test.@test two(t) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
