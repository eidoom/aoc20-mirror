#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(
    name::AbstractString,
)::Vector{Tuple{Vector{AbstractString},Vector{AbstractString}}}
    res::Vector{Tuple{Vector{AbstractString},Vector{AbstractString}}} = []
    for line in Com.file_lines(name)
        ing, aln = split(line[1:(end - 1)], " (contains ")
        push!(res, (split(ing), split(aln, ", ")))
    end
    res
end

function one(
    recipes::Vector{Tuple{Vector{AbstractString},Vector{AbstractString}}},
)::Tuple{Int,Set{AbstractString},Set{AbstractString}}
    alns::Set{AbstractString} = Set()
    ings::Set{AbstractString} = Set()
    for (r_ings, r_alns) in recipes
        for ing in r_ings
            push!(ings, ing)
        end
        for aln in r_alns
            push!(alns, aln)
        end
    end
    cnts::Set{AbstractString} = Set()
    for aln in alns
        cnt = deepcopy(ings)
        for (r_ings, r_alns) in recipes
            if aln in r_alns
                cnt = intersect(cnt, r_ings)
            end
        end
        for c in cnt
            push!(cnts, c)
        end
    end
    saf::Set{AbstractString} = setdiff(ings, cnts)
    ctr::Int = 0
    for (r_ings, _) in recipes
        for ing in r_ings
            if ing in saf
                ctr += 1
            end
        end
    end
    (ctr, alns, cnts)
end

t = read_file("i21t0")
@time inp = read_file("i21")

tc, ta, td = one(t)
Test.@test tc == 5

@time a, ia, id = one(inp)
println(a)
Test.@test a == 2374

function two(recipes, alns, dan)::String
    pairs = []
    for aln in alns
        cnt = deepcopy(dan)
        for (r_ings, r_alns) in recipes
            if aln in r_alns
                cnt = intersect(cnt, r_ings)
            end
        end
        push!(pairs, (cnt, aln))
    end
    sol = []
    while length(sol) != length(dan)
        for (ings, aln) in pairs
            if length(ings) == 1
                ing = first(ings)
                push!(sol, (ing, aln))
                for a in eachindex(pairs)
                    pairs[a] = (filter(i -> i != ing, pairs[a][1]), pairs[a][2])
                end
            end
        end
    end
    join(map(j -> j[1], sort(sol, by = i -> i[2])), ",")
end

Test.@test two(t, ta, td) == "mxmxvkd,sqjhc,fvjkl"

@time b = two(inp, ia, id)
println(b)
Test.@test b == "fbtqkzc,jbbsjh,cpttmnv,ccrbr,tdmqcl,vnjxjg,nlph,mzqjxq"
