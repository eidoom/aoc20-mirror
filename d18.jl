#!/usr/bin/env julia

import Test

include("./com.jl")

#= represent the different symbols ['+', '*', '(', ')'] as enums =#
@enum Sym plus times left right

#= turn strings into arrays of Int and Sym =#
function read_file(name)
    data = Com.file_lines(name)
    lines = []
    for datum in data
        line = []
        for i in split(datum)
            if i == "+"
                push!(line, plus)
            elseif i == "*"
                push!(line, times)
            elseif i[1] === '('
                br = findlast(i -> i === '(', i)
                for _ = 1:br
                    push!(line, left)
                end
                push!(line, parse(Int, i[(br + 1):end]))
            elseif i[end] === ')'
                br = findfirst(i -> i === ')', i)
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
function arithmetic(line)
    while length(line) > 1
        line = vcat([line[2] === plus ? line[1] + line[3] : line[1] * line[3]], line[4:end])
    end
    line
end

#= "recursive descent parser" for parentheses =#
function brackets(line, maths)
    check = findfirst(i -> i === left, line)
    if check !== nothing
        line = vcat(line[1:(check - 1)], brackets(line[(check + 1):end], maths))
        brackets(line, maths)
    else
        finish = findfirst(i -> i === right, line[1:end])
        if finish !== nothing
            vcat(maths(line[1:(finish - 1)]), line[(finish + 1):end])
        else
            vcat(maths(line))
        end
    end
end

#= sum of result of each expression =#
function evaluate(data, maths)
    sum(line -> brackets(line, maths)[1], data)
end

t = read_file("i18t0")
inp = read_file("i18")

Test.@test evaluate(t, arithmetic) === 26457

@time a = evaluate(inp, arithmetic)
println(a)
Test.@test a === 280014646144

#= addition has higher operation precedence than multiplication =#
function arithmetic2(line)
    while length(line) > 1
        i = findfirst(c -> c === plus, line)
        if i === nothing
            return reduce(*, line[1:2:end])
        end
        line = vcat(line[1:(i - 2)], [line[i - 1] + line[i + 1]], line[(i + 2):end])
    end
    line
end

Test.@test evaluate(t, arithmetic2) === 694173

@time b = evaluate(inp, arithmetic2)
println(b)
Test.@test b === 9966990988262
