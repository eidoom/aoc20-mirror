#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    Com.file_lines(name)
end

#= abstract type Vertex end =#

#= struct Edge{V<:Vertex} =#
#=     child::V =#
#=     number::UInt =#
#= end =#

#= struct Node<:Vertex =#
#=     colour::String =#
#=     children::Array{Edge,1} =#
#= end =#

function first(data)
    #= parse file into temporary array and find unique colours =#
    edges = []
    cols = Set()
    for d in data
        p = match(r"(\w+ \w+) bags contain ", d)
        i = 1 + length(p.match)
        pn = p.captures[1]
        c_regex = r"(\d+) (\w+ \w+) bags?[,.]"
        c = match(c_regex, d, i)
        children = []
        while c != nothing
            push!(children, c.captures)
            i = c.offset + length(c.match)
            c = match(c_regex, d, i)
        end
        push!(edges, [pn, children])
        push!(cols, pn)
        foreach(a -> push!(cols, a[2]), children)
    end

    #= encode the directed graph on a matrix (i, j) = i->j [just for fun] =#
    keys = Dict([[x, i] for (i, x) in enumerate(cols)])
    l = length(cols)
    m = zeros(Int, l, l)
    for es in edges
        foreach(a -> m[keys[es[1]], keys[a[2]]] = parse(Int, a[1]), es[2])
    end

    #= iterative DFS, traverse graph upwards =#
    visited = fill(false, l)
    stack = [keys["shiny gold"]]
    found = []
    while length(stack) != 0
        cur = popat!(stack, length(stack))

        if !visited[cur]
            push!(found, cur)
            visited[cur] = true
        end

        #= take column of matrix to find parents =#
        for (node, edge) in enumerate(m[:, cur])
            if edge != 0 && !visited[node]
                push!(stack, node)
            end
        end
    end

    #= rev = Dict(map(reverse, collect(keys))) =#
    #= println(map(x -> rev[x], found)) =#

    length(found) - 1
end

t = read_file("i07t0")
inp = read_file("i07")

Test.@test first(t) == 4

@time a = first(inp)
println(a)
Test.@test a == 185

function second(data)
    #= parse file into temporary array and find unique colours =#
    edges = []
    cols = Set()
    for d in data
        p = match(r"(\w+ \w+) bags contain ", d)
        i = 1 + length(p.match)
        pn = p.captures[1]
        c_regex = r"(\d+) (\w+ \w+) bags?[,.]"
        c = match(c_regex, d, i)
        children = []
        while c != nothing
            push!(children, c.captures)
            i = c.offset + length(c.match)
            c = match(c_regex, d, i)
        end
        push!(edges, [pn, children])
        push!(cols, pn)
        foreach(a -> push!(cols, a[2]), children)
    end

    #= encode the directed graph on a matrix (i, j) = i->j [just for fun] =#
    keys = Dict([[x, i] for (i, x) in enumerate(cols)])
    l = length(cols)
    m = zeros(Int, l, l)
    for es in edges
        foreach(a -> m[keys[es[1]], keys[a[2]]] = parse(Int, a[1]), es[2])
    end

    #= iterative DFS, traverse graph downwards =#
    stack = [[1, keys["shiny gold"]]]
    tot = 0
    while length(stack) != 0
        cur = popat!(stack, length(stack))
        tot += cur[1]

        #= take row of matrix to find children =#
        for (node, edge) in enumerate(m[cur[2], :])
            if edge != 0
                push!(stack, [cur[1] * edge, node])
            end
        end
    end

    tot - 1
end

Test.@test second(t) == 32

t1 = read_file("i07t1")
Test.@test second(t1) == 126

@time b = second(inp)
println(b)
Test.@test b == 89084
