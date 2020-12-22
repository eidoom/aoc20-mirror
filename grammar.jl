#!/usr/bin/env julia

#= https://en.wikipedia.org/wiki/CYK_algorithm#As_pseudocode =#
function cyk_parse(rules, symbol)
    n = length(symbol)

    table = BitArray(fill(false, (n, n, length(rules))))

    for i = 1:n
        for a in axes(rules, 1)
            for rhs in rules[a]
                if length(rhs) === 1 && rhs[1] === symbol[i]
                    table[i, 1, a] = true
                end
            end
        end
    end

    for j = 2:n
        for i = 1:(n - j + 1)
            for k = 1:(j - 1)
                for a in axes(rules, 1)
                    for rhs in rules[a]
                        if length(rhs) === 2 &&
                           table[i, k, rhs[1]] &&
                           table[i + k, j - k, rhs[2]]
                            table[i, j, a] = true
                        end
                    end
                end
            end
        end
    end

    table[1, n, 1]
end

function example()
    the_rules = [[[2, 3]], [['a']], [[2, 4], [4, 2]], [['b']]]

    the_words = [
        "aab",
        "aba",
        "ab",
        "ba",
        "abb",
        "bba",
        "bab",
        "baa",
        "a",
        "b",
        "aa",
        "bb",
        "aaa",
        "bbb",
    ]
    for word in the_words
        println(word, " ", cyk_parse(the_rules, word))
    end
end

@time example()
