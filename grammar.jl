#!/usr/bin/env julia

function cyk_parse(rules, symbols)
    n = length(symbols)

    table = fill(Set(), (n, n))

    for j = 1:n
        for (lhs, rhss) in rules
            for rhs in rhss

                # If a terminal is found
                if length(rhs) === 1 && rhs[1] === symbols[j]
                    push!(table[j, j], lhs)
                end
            end
        end

        for i = j:-1:1
            for k = i:j
                if k < n
                    println(i, " ", j, " ", k)
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
    length(table[1, n]) !== 0
end

function example()
    the_rules = Dict(0 => [[1, 2]], 1 => [['a']], 2 => [[1, 3], [3, 1]], 3 => [['b']])

    the_words = ["aab", "aba", "ab", "ba", "abb","bba"]
    for word in the_words
        println(word, " ", cyk_parse(the_rules, word))
    end
end

@time example()
