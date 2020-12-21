#!/usr/bin/env julia

import Test

include("./com.jl")

struct Recipe
    ings::Vector{AbstractString}
    alns::Vector{AbstractString}
end

function read_file(name::AbstractString)::Vector{Recipe}
    res::Vector{Recipe} = []
    for line in Com.file_lines(name)
        ing, aln = split(line[1:(end - 1)], " (contains ")
        push!(res, Recipe(split(ing), split(aln, ", ")))
    end
    res
end

function one(recipes::Vector{Recipe})::Tuple{Int,Set{AbstractString},Set{AbstractString}}
    alns::Set{AbstractString} = Set()
    ings::Set{AbstractString} = Set()
    for r in recipes
        for ing in r.ings
            push!(ings, ing)
        end
        for aln in r.alns
            push!(alns, aln)
        end
    end
    cnts::Set{AbstractString} = Set()
    for aln in alns
        cnt = deepcopy(ings)
        for r in recipes
            if aln in r.alns
                cnt = intersect(cnt, r.ings)
            end
        end
        for c in cnt
            push!(cnts, c)
        end
    end
    saf::Set{AbstractString} = setdiff(ings, cnts)
    (count(ing in saf for r in recipes for ing in r.ings), alns, cnts)
end

t = read_file("i21t0")
@time inp = read_file("i21")

tc, ta, td = one(t)
Test.@test tc == 5

@time a, ia, id = one(inp)
println(a)
Test.@test a == 2374

function two(
    recipes::Vector{Recipe},
    alns::Set{AbstractString},
    dan::Set{AbstractString},
)::String
    pairs::Vector{Tuple{Set{AbstractString},AbstractString}} = []
    for aln in alns
        cnt = deepcopy(dan)
        for r in recipes
            if aln in r.alns
                cnt = intersect(cnt, r.ings)
            end
        end
        push!(pairs, (cnt, aln))
    end
    sol::Vector{Tuple{AbstractString,AbstractString}} = []
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
