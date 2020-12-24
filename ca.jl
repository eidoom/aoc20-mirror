#!/usr/bin/env julia

function life(state, neighbourhood, iterations, born, survive)
    #= 
    Runs a cellular automaton and returns number of alive states at end
    state: initial state
    neighbourhood: adjacent cells as lattice vectors
    iterations: number of iterations to run
    born, survive: rules of CA in r"B\d+/S\d+" form
    =#
    for _ = 1:iterations
        prev = deepcopy(state)
        state = Set{Tuple}()
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
