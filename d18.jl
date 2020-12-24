#!/usr/bin/env julia

import Test

include("./com.jl")

#= represent the different symbols ['+', '*', '(', ')'] as enums =#
@enum Sym plus times left right

const Letter = Union{Int,Sym}
const Letters = Vector{Letter}

#= turn strings into arrays of Int and Sym =#
function read_file(name::String)::Vector{Letters}
    lines = Letters[]
    for expr in Com.file_lines(name)
        line = Letter[]
        for i in split(expr)
            if i[1] === '+'
                push!(line, plus)
            elseif i[1] === '*'
                push!(line, times)
            elseif i[1] === '('
                br = findlast(c -> c === '(', i)
                for _ = 1:br
                    push!(line, left)
                end
                push!(line, parse(Int, i[(br + 1):end]))
            elseif i[end] === ')'
                br = findfirst(c -> c === ')', i)
                push!(line, parse(Int, i[1:(br - 1)]))
                for _ = br:length(i)
                    push!(line, right)
                end
            else
                push!(line, parse(Int, i))
            end
        end
        push!(lines, line)
    end
    lines
end

#= pure left-to-right operator precedence =#
#= it's faster to return an array here than an Int =#
function arithmetic(line::Letters)::Letters
    while length(line) > 1
        line = vcat([line[2] === plus ? line[1] + line[3] : line[1] * line[3]], line[4:end])
    end
    line
end

#= "recursive descent parser" for parentheses =#
function brackets(line::Letters, maths::Function)::Letters
    check = findfirst(i -> i === left, line)
    if check !== nothing
        brackets(vcat(line[1:(check - 1)], brackets(line[(check + 1):end], maths)), maths)
    else
        finish = findfirst(i -> i === right, line[1:end])
        if finish !== nothing
            vcat(maths(line[1:(finish - 1)]), line[(finish + 1):end])
        else
            maths(line)
        end
    end
end

#= sum of result of each expression =#
function evaluate(data::Vector{Letters}, maths::Function)::Int
    sum(line -> brackets(line, maths)[1], data)
end

t = read_file("i18t0")
@time inp = read_file("i18")

Test.@test evaluate(t, arithmetic) === 26457

@time a = evaluate(inp, arithmetic)
println(a)
Test.@test a === 280014646144

#= addition has higher operation precedence than multiplication =#
#= it would be faster to return an Int here, but then part 1 would be slowed down more than the gain in part 2 =#
function arithmetic2(line::Letters)::Letters
    while length(line) > 1
        i = findfirst(c -> c === plus, line)
        if i === nothing
            return [reduce(*, line[1:2:end])]
        end
        line = vcat(line[1:(i - 2)], [line[i - 1] + line[i + 1]], line[(i + 2):end])
    end
    line
end

Test.@test evaluate(t, arithmetic2) === 694173

@time b = evaluate(inp, arithmetic2)
println(b)
Test.@test b === 9966990988262
