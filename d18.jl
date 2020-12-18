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
        if line[2] === plus
            new = line[1] + line[3]
        else
            new = line[1] * line[3]
        end
        line = vcat([new], line[4:end])
    end
    line[1]
end

function brackets(line)
    check = findfirst(i -> i === left, line)
    if check === nothing
        finish = findfirst(i -> i === right, line[1:end])
        new = arithmetic(line[1:(finish - 1)])
        vcat([new], line[(finish + 1):end])
    else
        line = vcat(line[1:(check - 1)], brackets(line[(check + 1):end]))
        brackets(line)
    end
end

function one(data)
    tot = 0
    for line in data
        start = findfirst(i -> i === left, line)
        if start === nothing
            tot += arithmetic(line)
        else
            new = brackets(line[(start + 1):end])
            tot += arithmetic(vcat(line[1:(start - 1)], new))
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
        else
            new = line[i - 1] + line[i + 1]
        end
        line = vcat(line[1:(i - 2)], [new], line[(i + 2):end])
    end
    line[1]
end

function brackets2(line)
    check = findfirst(i -> i === left, line)
    if check === nothing
        finish = findfirst(i -> i === right, line[1:end])
        new = arithmetic2(line[1:(finish - 1)])
        vcat([new], line[(finish + 1):end])
    else
        line = vcat(line[1:(check - 1)], brackets2(line[(check + 1):end]))
        brackets2(line)
    end
end

function two(data)
    tot = 0
    for line in data
        start = findfirst(i -> i === left, line)
        if start === nothing
            tot += arithmetic2(line)
        else
            new = brackets2(line[(start + 1):end])
            tot += arithmetic2(vcat(line[1:(start - 1)], new))
        end
    end
    tot
end

Test.@test two(t) === 694173

@time b = two(inp)
println(b)
Test.@test b === 9966990988262
