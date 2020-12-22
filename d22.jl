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

gg = 1

function two(decks, g = gg)
    println("=== Game ", g, " ===\n")
    deck1, deck2 = deepcopy(decks)
    i = 1
    prev = []
    winner = undef
    while all(deck -> length(deck) !== 0, [deck1, deck2])
        println("Round ", i, " (Game ", g, ")")
        println("Player 1's deck: ", deck1)
        println("Player 2's deck: ", deck2)
        if (deck1, deck2) in prev
            return (1, deck1)
        else
            push!(prev, (deck1, deck2))
            card1 = popfirst!(deck1)
            card2 = popfirst!(deck2)
            println("Player 1's plays: ", card1)
            println("Player 2's plays: ", card2)
            if length(deck1) >= card1 && length(deck2) >= card2
                println("Playing a sub-game to determine the winner...\n")
                global gg += 1
                winner = two((deck1[1:card1], deck2[1:card2]), gg)[1]
                println(
                    "The winner of game ",
                    gg,
                    " is player ",
                    winner,
                    "!\n\n...anyway, back to game ",
                    g,
                    ".",
                )
            else
                if card1 > card2
                    winner = 1
                else
                    winner = 2
                end
            end
        end
        println("Player ", winner, " wins round ", i, " of game ", g, "!\n")
        if winner === 1
            deck1 = vcat(deck1, [card1, card2])
        else
            deck2 = vcat(deck2, [card2, card1])
        end
        i += 1
    end
    (winner, winner === 1 ? deck1 : deck2)
end

function game(decks)
    winner, winning_deck = two(decks)
    println("== Post-game results ==\nPlayer ", winner, "'s deck: ", winning_deck)
    sum(map(card -> reduce(*, card), enumerate(reverse(winning_deck))))
end

#= t1 = read_file("i22t1") =#

game(t0)
Test.@test game(t0) === 291

#= @time b = game(inp) =#
#= println(b) =#
#= Test.@test b === 0 =#
