#!/usr/bin/env julia

Coord{N} = NTuple{N,Int}

function life(
    state::Set{Coord{N}},
    neighbourhood::Vector{Coord{N}},
    iterations::Int,
    born::NTuple{B, Int},
    survive::NTuple{S, Int},
)::Int where {N, B, S}
    #=
    Runs a cellular automaton and returns number of alive states at end
    state: initial state
    neighbourhood: adjacent cells as lattice vectors
    iterations: number of iterations to run
    born, survive: rules of CA in r"B\d+/S\d+" form
    =#
    for _ = 1:iterations
        prev = copy(state)
        state = Set{Coord{N}}()
        for alive in prev
            if count(dir -> alive .+ dir in prev, neighbourhood) in survive
                push!(state, alive)
            end
            for pos in map(dir -> alive .+ dir, neighbourhood)
                if !(pos in prev) && count(dir -> pos .+ dir in prev, neighbourhood) in born
                    push!(state, pos)
                end

            end
        end
    end
    length(state)
end
