#!/usr/bin/env julia

import Test

include("./com.jl")

@enum Sym plus = 1 times = 2 left = 3 right = 4

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

function arithmetic(line)
    while length(line) > 1
        line = vcat([line[2] === plus ? line[1] + line[3] : line[1] * line[3]], line[4:end])
    end
    line
end

function brackets(line, maths)
    check = findfirst(i -> i === left, line)
    if check !== nothing
        line = vcat(line[1:(check - 1)], brackets(line[(check + 1):end], maths))
        brackets(line, maths)
    else
        finish = findfirst(i -> i === right, line[1:end])
        vcat(maths(line[1:(finish - 1)]), line[(finish + 1):end])
    end
end

function one(data)
    tot = 0
    for line in data
        start = findfirst(i -> i === left, line)
        if start === nothing
            tot += arithmetic(line)[1]
        else
            new = brackets(line[(start + 1):end], arithmetic)
            tot += arithmetic(vcat(line[1:(start - 1)], new))[1]
        end
    end
    tot
end

t = read_file("i18t0")
inp = read_file("i18")

Test.@test one(t) === 26457

@time a = one(inp)
println(a)
Test.@test a === 280014646144

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

function two(data)
    tot = 0
    for line in data
        start = findfirst(i -> i === left, line)
        if start === nothing
            tot += arithmetic2(line)[1]
        else
            new = brackets(line[(start + 1):end], arithmetic2)
            tot += arithmetic2(vcat(line[1:(start - 1)], new))[1]
        end
    end
    tot
end

Test.@test two(t) === 694173

@time b = two(inp)
println(b)
Test.@test b === 9966990988262
