#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    map(
        player -> parse.(Int, split(player, '\n')[2:end]),
        split(Com.file_slurp(name), "\n\n"),
    )
end

#= seems to run pretty much the same =#
#= function one(decks) =#
#=     deck1, deck2 = reverse.(deepcopy(decks)) =#
#=     while all(deck -> length(deck) !== 0, [deck1, deck2]) =#
#=         card1 = pop!(deck1) =#
#=         card2 = pop!(deck2) =#
#=         if card1 > card2 =#
#=             deck1 = vcat([card2, card1], deck1) =#
#=         else =#
#=             deck2 = vcat([card1, card2], deck2) =#
#=         end =#
#=     end =#
#=     sum(map( =#
#=         card -> reduce(*, card), =#
#=         enumerate(length(deck1) === 0 ? deck2 : deck1), =#
#=     )) =#
#= end =#

function one(decks)
    deck1, deck2 = deepcopy(decks)
    while all(deck -> length(deck) !== 0, [deck1, deck2])
        card1 = popfirst!(deck1)
        card2 = popfirst!(deck2)
        if card1 > card2
            deck1 = vcat(deck1, [card1, card2])
        else
            deck2 = vcat(deck2, [card2, card1])
        end
    end
    sum(map(
        card -> reduce(*, card),
        enumerate(reverse(length(deck1) === 0 ? deck2 : deck1)),
    ))
end

t0 = read_file("i22t0")
inp = read_file("i22")

Test.@test one(t0) === 306

@time a = one(inp)
println(a)
Test.@test a === 32472

function rc(decks)
    deck1, deck2 = deepcopy(decks)
    prev = []
    i = 1
    card1 = undef
    card2 = undef
    while true
        println("Round ", i)
        if (deck1, deck2) in prev
            return 1
        end
        push!(prev, (deck1, deck2))
        println("Player 1's deck: ", deck1)
        println("Player 2's deck: ", deck2)
        card1 = popfirst!(deck1)
        card2 = popfirst!(deck2)
        println("Player 1's plays: ", card1)
        println("Player 2's plays: ", card2)
        if !(length(deck1) >= card1 && length(deck2) >= card2)
            break
        end
        deck1 = deck1[1:card1]
        deck2 = deck2[1:card2]
        i += 1
    end
    if card1 > card2
        1
    else
        2
    end
end

function two(decks)
    deck1, deck2 = deepcopy(decks)
    i = 1
    while all(deck -> length(deck) !== 0, [deck1, deck2])
        println("Round ", i, " (Game 1)")
        println("Player 1's deck: ", deck1)
        println("Player 2's deck: ", deck2)
        card1 = popfirst!(deck1)
        card2 = popfirst!(deck2)
        println("Player 1's plays: ", card1)
        println("Player 2's plays: ", card2)
        if length(deck1) >= card1 && length(deck2) >= card2
            println("Playing a sub-game to determine the winner...\n")
            winner = rc((deck1[1:card1], deck2[1:card2]))
        else
            if card1 > card2
                winner = 1
            else
                winner = 2
            end
        end
        if winner === 1
            deck1 = vcat(deck1, [card1, card2])
        else
            deck2 = vcat(deck2, [card2, card1])
        end
        println("Player ",winner," wins round ",i," of game 1!\n")
        i += 1
        if i == 18
            break
        end
    end
    sum(map(
        card -> reduce(*, card),
        enumerate(reverse(length(deck1) === 0 ? deck2 : deck1)),
    ))
end

t1 = read_file("i22t1")

println(two(t0))
#= Test.@test two(t1) === 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b === 0 =#
