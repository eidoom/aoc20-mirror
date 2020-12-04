#!/usr/bin/env julia

import Test

function read_file(name)
    f = open(name, "r")
    a = read(f, String)
    close(f)
    strip(a)
end

function parse(data)
    pp = Dict{SubString{String},SubString{String}}[]
    for b in split(data,"\n\n")
        b = strip(b)
        b = replace(b,"\n"=>" ")
        b = split(b," ")
        b = [split(a,":") for a in b]
        b = Dict(b)
        push!(pp,b)
    end
    pp
end

function valid(data)
    n = 0
    for pp in data
        if all(map(x -> haskey(pp, x), ["byr","iyr","eyr","hgt","hcl","ecl","pid"]))
            n += 1
        end
    end
    n
end

t = read_file("i04t0")
dt = parse(t)
inp = read_file("i04")
d = parse(inp)

Test.@test valid(dt) == 2

@time println(valid(d))

function strict(data)
    n = 0
    for pp in data
        if all(map(x -> haskey(pp, x), ["byr","iyr","eyr","hgt","hcl","ecl","pid"]))
            if all([1920 <= Base.parse(UInt, pp["byr"]) <= 2002,
                    2010 <= Base.parse(UInt, pp["iyr"]) <= 2020,
                    2020 <= Base.parse(UInt, pp["eyr"]) <= 2030,
                    length(pp["hgt"]) >= 4,
                    (pp["hgt"][end-1:end] == "cm" && 150 <= Base.parse(UInt, pp["hgt"][1:end-2]) <= 193) || (pp["hgt"][end-1:end] == "in" && 59 <= Base.parse(UInt, pp["hgt"][1:end-2]) <= 76),
                    length(pp["hcl"]) == 7 && pp["hcl"][1] == '#' && occursin(r"[a-f\d]{6}", pp["hcl"][2:7]),
                    pp["ecl"] in ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"],
                    length(pp["pid"]) == 9,
                   ])
                n += 1
            end
        end
    end
    n
end

Test.@test strict(dt) == 2

t2 = read_file("i04t2")
dt2 = parse(t2)
Test.@test strict(dt2) == 4

t1 = read_file("i04t1")
dt1 = parse(t1)
Test.@test strict(dt1) == 0

@time println(strict(d))
