#!/usr/bin/env julia

import Test

include("./com.jl")

#= represent the different symbols ['+', '*', '(', ')'] as enums =#
@enum Sym plus times left right

#= turn strings into arrays of Int and Sym =#
function read_file(name::String)::Vector{Vector{Union{Sym,Int}}}
    lines::Vector{Vector{Union{Sym,Int}}} = []
    for expr::String in Com.file_lines(name)
        line::Vector{Union{Sym,Int}} = []
        for i::SubString in split(expr)
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
function arithmetic(line::Vector{Union{Sym,Int}})::Vector{Union{Int,Sym}}
    while length(line) > 1
        line::Vector{Union{Sym,Int}} =
            vcat([line[2] === plus ? line[1] + line[3] : line[1] * line[3]], line[4:end])
    end
    line
end

#= "recursive descent parser" for parentheses =#
function brackets(line::Vector{Union{Sym,Int}}, maths)::Vector{Union{Sym,Int}}
    check = findfirst(i::Union{Sym,Int} -> i === left, line)
    if check !== nothing
        brackets(vcat(line[1:(check - 1)], brackets(line[(check + 1):end], maths)), maths)
    else
        finish::Union{Nothing,Int} =
            findfirst(i::Union{Sym,Int} -> i === right, line[1:end])
        if finish !== nothing
            vcat(maths(line[1:(finish - 1)]), line[(finish + 1):end])
        else
            maths(line)
        end
    end
end

#= sum of result of each expression =#
function evaluate(data::Vector{Vector{Union{Sym,Int}}}, maths)::Int
    sum(line::Vector{Union{Sym,Int}} -> brackets(line, maths)[1], data)
end

t = read_file("i18t0")
@time inp = read_file("i18")

Test.@test evaluate(t, arithmetic) === 26457

@time a = evaluate(inp, arithmetic)
println(a)
Test.@test a === 280014646144

#= addition has higher operation precedence than multiplication =#
function arithmetic2(line::Vector{Union{Sym,Int}})::Vector{Union{Int,Sym}}
    while length(line) > 1
        i::Union{Nothing,Int} = findfirst(c::Union{Sym,Int} -> c === plus, line)
        if i === nothing
            return [reduce(*, line[1:2:end])]
        end
        line::Vector{Union{Sym,Int}} =
            vcat(line[1:(i - 2)], [line[i - 1] + line[i + 1]], line[(i + 2):end])
    end
    line
end

Test.@test evaluate(t, arithmetic2) === 694173

@time b = evaluate(inp, arithmetic2)
println(b)
Test.@test b === 9966990988262
