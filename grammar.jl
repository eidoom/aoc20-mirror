#!/usr/bin/env julia

# Rules of the grammar
R = Dict(
    "NP" => [["Det", "Nom"]],  # noun phrase
    "Nom" => [["AP", "Nom"], ["book"], ["orange"], ["man"]],  # noun
    "AP" => [["Adv", "A"], ["heavy"], ["orange"], ["tall"]],  # adjective phrase
    "Det" => [["a"]],  # determiner
    "Adv" => [["very"], ["extremely"]],  # adjective modifier
    "A" => [["heavy"], ["orange"], ["tall"], ["muscular"]],  # adjective
)

function cykParse(w)
    n = length(w)

    T = [[Set([]) for j = 1:n] for i = 1:n]

    for j = 1:n

        for (lhs, rules) in R
            for rhs in rules

                # If a terminal is found
                if length(rhs) == 1 && rhs[1] == w[j]
                    push!(T[j][j], lhs)
                end
            end
        end

        for i = j:-1:1

            for k = i:j

                for (lhs, rules) in R
                    for rhs in rules

                        # If a terminal is found
                        if length(rhs) == 2 && rhs[1] in T[i][k] && rhs[2] in T[k + 1][j]
                            push!(T[i][j], lhs)
                        end
                    end
                end
            end
        end
    end

    # If word can be formed by rules of given grammar
    if length(T[1][n]) != 0
        println("True")
    else
        println("False")
    end
end

w = split("a very heavy orange book")
#= w = split("the quick brown fox jumps over the lazy dog") =#

cykParse(w)
