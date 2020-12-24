#!/usr/bin/env julia

import Test

include("./com.jl")

#= abstract type Vertex end =#

#= struct Edge{V<:Vertex} =#
#=     child::V =#
#=     number::UInt =#
#= end =#

#= struct Node<:Vertex =#
#=     colour::String =#
#=     children::Array{Edge,1} =#
#= end =#

function build(name)
    data = Com.file_lines(name)
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
    len = length(cols)
    mat = zeros(Int, len, len)
    for es in edges
        foreach(a -> mat[keys[es[1]], keys[a[2]]] = parse(Int, a[1]), es[2])
    end

    #= rev = Dict(map(reverse, collect(keys))) =#

    (mat, keys["shiny gold"])
end

function search_up(mat, start)
    #= iterative DFS, traverse graph upwards =#
    visited = fill(false, size(mat, 1))
    stack = [start]
    tot = 0
    while length(stack) != 0
        cur = popat!(stack, length(stack))

        if !visited[cur]
            tot += 1
            visited[cur] = true
        end

        #= take column of matrix to find parents =#
        for (node, edge) in enumerate(mat[:, cur])
            if edge != 0 && !visited[node]
                push!(stack, node)
            end
        end
    end

    tot - 1
end

t0 = build("i07t0")
@time inp = build("i07")

Test.@test search_up(t0...) === 4

@time a = search_up(inp...)
println(a)
Test.@test a === 185

function search_down(mat, start)
    #= iterative DFS, traverse graph downwards =#
    stack = [(1, start)]
    tot = 0
    while length(stack) != 0
        pe, pn = popat!(stack, length(stack))
        tot += pe

        #= take row of matrix to find children =#
        for (node, edge) in enumerate(mat[pn, :])
            if edge != 0
                push!(stack, (pe * edge, node))
            end
        end
    end

    tot - 1
end

Test.@test search_down(t0...) === 32

t1 = build("i07t1")
Test.@test search_down(t1...) === 126

@time b = search_down(inp...)
println(b)
Test.@test b === 89084
