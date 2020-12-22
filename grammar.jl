#!/usr/bin/env julia

# Rules of the grammar
the_rules = Dict(
    "NP" => [["Det", "Nom"]],  # noun phrase
    "Nom" => [["AP", "Nom"], ["book"], ["orange"], ["man"]],  # noun
    "AP" => [["Adv", "A"], ["heavy"], ["orange"], ["tall"]],  # adjective phrase
    "Det" => [["a"]],  # determiner
    "Adv" => [["very"], ["extremely"]],  # adjective modifier
    "A" => [["heavy"], ["orange"], ["tall"], ["muscular"]],  # adjective
)

function cyk_parse(rules, words)
    n = length(words)

    table = fill(Set(), (n, n))

    for j = 1:n
        for (lhs, rhss) in rules
            for rhs in rhss

                # If a terminal is found
                if length(rhs) === 1 && rhs[1] == words[j]
                    push!(table[j, j], lhs)
                end
            end
        end

        for i = j:-1:1
            for k = i:j
                if k < n
                    #= println(i, " ", j, " ", k) =#
                    for (lhs, rhss) in rules
                        for rhs in rhss

                            # If a terminal is found
                            if length(rhs) === 2 &&
                               rhs[1] in table[i, k] &&
                               rhs[2] in table[k + 1, j]
                                push!(table[i, j], lhs)
                            end
                        end
                    end
                end
            end
        end
    end

    # If word can be formed by rules of given grammar
    if length(table[1, n]) !== 0
        println("true")
    else
        println("false")
    end
end

the_words = split("a very heavy orange book")
#= the_words = split("the quick brown fox jumps over the lazy dog") =#

cyk_parse(the_rules, the_words)
