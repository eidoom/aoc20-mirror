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

t = read_file("i22t0")
inp = read_file("i22")

println(one(t))
Test.@test one(t) === 306

@time a = one(inp)
println(a)
Test.@test a === 32472

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t)) =#
#= Test.@test two(t) === 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b === 0 =#
