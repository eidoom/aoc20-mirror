#!/usr/bin/env julia

import Test

include("./com.jl")

#= An element of the grammar: a rule (Int) or a "word in the sentence"/"letter in the symbol" (Char) =#
const Element = Union{Int,Char}

#= rules are indexed by their position in the array =#
function read_file(
    name::String,
)::Tuple{Vector{Vector{Vector{Element}}},Vector{SubString}}
    raw, mesgs = Com.file_sents(name)
    rules = Vector(undef, length(raw))
    for r in raw
        m = match(r"^(\d+): (.*)$", r)
        ii = parse(Int, m.captures[1]) + 1
        if ii > length(rules)
            resize!(rules, ii)
        end
        r = m.captures[2]
        if r[1] === '"'
            rules[ii] = [[r[2]]]
        else
            r = map(i -> map(j -> parse(Int, j) + 1, split(i, " ")), split(r, " | "))
            rules[ii] = r
        end
    end
    rules, mesgs
end

#= recursively generate all strings which are allowed by rules =#
function builder(
    rules::Vector{Vector{Vector{Element}}},
    i::Int = 1,
)::Union{Char,Vector{Union{Char,String}}}
    rule = rules[i]

    if isa(rule[1][1], Char)
        rule[1][1]
    else
        as = Union{Char,String}[]
        for set in rule
            if length(set) === 1
                if length(rule) === 1
                    return builder(rules, set[1][1])
                else
                    for i in builder(rules, set[1])
                        push!(as, i)
                    end
                end
            elseif length(set) === 2
                a1 = builder(rules, set[1])
                a2 = builder(rules, set[2])
                for i in a1, j in a2
                    push!(as, i * j)
                end
            elseif length(set) === 3
                a1 = builder(rules, set[1])
                a2 = builder(rules, set[2])
                a3 = builder(rules, set[3])
                for i in a1, j in a2, k in a3
                    push!(as, i * j * k)
                end
            elseif length(set) === 4
                a1 = builder(rules, set[1])
                a2 = builder(rules, set[2])
                a3 = builder(rules, set[3])
                a4 = builder(rules, set[4])
                for i in a1, j in a2, k in a3, l in a4
                    push!(as, i * j * k * l)
                end
            elseif length(set) === 5
                a1 = builder(rules, set[1])
                a2 = builder(rules, set[2])
                a3 = builder(rules, set[3])
                a4 = builder(rules, set[4])
                a5 = builder(rules, set[5])
                for i in a1, j in a2, k in a3, l in a4, m in a5
                    push!(as, i * j * k * l * m)
                end
            elseif length(set) === 6
                a1 = builder(rules, set[1])
                a2 = builder(rules, set[2])
                a3 = builder(rules, set[3])
                a4 = builder(rules, set[4])
                a5 = builder(rules, set[5])
                a6 = builder(rules, set[6])
                for i in a1, j in a2, k in a3, l in a4, m in a5, n in a6
                    push!(as, i * j * k * l * m * n)
                end
            else
                println("Need more!")
            end
        end
        as
    end

end

#= count how many messages match the first rule by seeing if they're in the list of all possible messages =#
function one(rules::Vector{Vector{Vector{Element}}}, mesgs::Vector{SubString})::Int
    mesgs = Set(mesgs)
    allowed = builder(rules)
    length(intersect(mesgs, allowed))
end

t0 = read_file("i19t0")
t1 = read_file("i19t1")
@time r1, m1 = read_file("i19")

Test.@test one(t0...) === 2
Test.@test one(t1...) === 2

@time a = one(r1, m1)
println(a)
Test.@test a === 224

#= generating all possible strings is too slow =#
#= function additions(in1) =#
#=     in2 = deepcopy(in1) =#
#=     in2[9] = [[43], [43, 43]] =#
#=     #1= in2[9] = [[43], [43, 43], [43, 43, 43], [43, 43, 43, 43], [43, 43, 43, 43, 43]] =1# =#
#=     in2[12] = [[43, 32], [43, 43, 32, 32]] =#
#=     #1= in2[12] = [[43, 32], [43, 43, 32, 32], [43, 43, 43, 32, 32, 32], [43, 43, 43, 43, 32, 32, 32, 32]] =1# =#
#=     in2 =#
#= end =#

function cyk_parse(rules::Vector{Vector{Vector{Element}}}, symbol::SubString)::Bool
    n = length(symbol)

    table::BitArray{3} = BitArray{3}(fill(false, (n, n, length(rules))))

    for i = 1:n
        for a in axes(rules, 1)
            if isassigned(rules, a)
                for rhs in rules[a]
                    if length(rhs) === 1 && rhs[1] === symbol[i]
                        table[i, 1, a] = true
                    end
                end
            end
        end
    end

    for j = 2:n
        for i = 1:(n - j + 1)
            for k = 1:(j - 1)
                for a in axes(rules, 1)
                    if isassigned(rules, a)
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
    end

    table[1, n, 1]
end

t2r, t2m = read_file("i19t2")
Test.@test one(t2r, t2m) === 3

function two(rules::Vector{Vector{Vector{Element}}}, mesgs::Vector{SubString})::Int
    count(mesg -> cyk_parse(rules, mesg), mesgs)
end

#= put t1 in CNF (remove triple rule) =#
t1[1][1] = [[5, 7]]
resize!(t1[1], 7)
t1[1][7] = [[2, 6]]

Test.@test two(t0...) === 2
Test.@test two(t1...) === 2

#= put input in CNF by hand =#
t2_cnf = read_file("i19t2cnf")
Test.@test two(t2_cnf...) === 3
#= put in a few levels of recursion by hand =#
t2_cnf2 = read_file("i19t2cnf2")
Test.@test two(t2_cnf2...) === 12

r1_cnf = deepcopy(r1)
#= manually insert a few levels of recursion respecting CNF (ie. well, this is UGLY) =#
resize!(r1_cnf, 146)
r1_cnf[1] = [[43, 12], [9, 12], [136, 12], [137, 12], [138, 12], [145, 12]]
r1_cnf[9] = [[43, 9], [43, 43]]
r1_cnf[135] = [[9, 43]]
r1_cnf[136] = [[9, 9]]
r1_cnf[137] = [[136, 43]]
r1_cnf[138] = [[136, 9]]
r1_cnf[12] = [[43, 32], [43, 146], [43, 139], [43, 140]]
r1_cnf[139] = [[43, 142]]
r1_cnf[140] = [[141, 32]]
r1_cnf[141] = [[43, 32]]
r1_cnf[142] = [[43, 143]]
r1_cnf[143] = [[32, 144]]
r1_cnf[144] = [[32, 32]]
r1_cnf[145] = [[9, 138]]
r1_cnf[146] = [[12, 32]]
#= remove unit rules =#
r1_cnf[39] = [['a'], ['b']]

@time b = two(r1_cnf, m1)
println(b)
Test.@test b === 436
