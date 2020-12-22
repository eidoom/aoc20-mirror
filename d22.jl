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

function two(decks)
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

t1 = read_file("i22t1")

#= println(two(t1)) =#
#= Test.@test two(t1) === 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b === 0 =#
