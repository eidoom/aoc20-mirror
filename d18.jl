#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    Com.file_lines(name)
end

function arithmetic(line)
    while length(line) > 1
        if line[2]
            new = line[1] + line[3]
        else
            new = line[1] * line[3]
        end
        line = vcat([new], line[4:end])
    end
    line[1]
end

function brackets(line)
    #= println(line) =#
    check = findfirst(isequal('('), line)
    if check == nothing
        finish = findfirst(isequal(')'), line[1:end])
        new = arithmetic(line[1:(finish - 1)])
        vcat([new], line[(finish + 1):end])
    else
        line = vcat(line[1:(check - 1)], brackets(line[(check + 1):end]))
        brackets(line)
    end
end

function one(data)
    tot = 0
    for datum in data
        #= println(datum) =#
        line = []
        for i in split(datum)
            #= println(i) =#
            if i == "+"
                push!(line, true)
            elseif i == "*"
                push!(line, false)
            elseif i[1] == '('
                br = findlast(isequal('('), i)
                for _ = 1:br
                    push!(line, '(')
                end
                push!(line, parse(Int, i[(br + 1):end]))
            elseif i[end] == ')'
                br = findfirst(isequal(')'), i)
                push!(line, parse(Int, i[1:(br - 1)]))
                for _ = br:length(i)
                    push!(line, ')')
                end
            else
                push!(line, parse(Int, i))
            end
        end
        #= println(line) =#
        start = findfirst(isequal('('), line)
        if start == nothing
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

println(one(t))
Test.@test one(t) == 26406

@time a = one(inp)
println(a)
#= Test.@test a == 0 =#

#= function two(data) =#
#=     data =#
#= end =#

#= println(two(t)) =#
#= Test.@test two(t) == 0 =#

#= @time b = two(inp) =#
#= println(b) =#
#= Test.@test b == 0 =#
