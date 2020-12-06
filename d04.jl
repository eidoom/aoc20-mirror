#!/usr/bin/env julia

import Test

function read_file(name)
    a = open(name, "r") do f
        read(f, String)
    end
    strip(a)
end

function parse(data)
    map(a -> Dict(map(b -> split(b, ":"), split(a))), split(data, "\n\n"))
end

function valid(data)
    count(
        pp ->
            all(map(x -> haskey(pp, x), ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])),
        data,
    )
end

t = read_file("i04t0")
dt = parse(t)
inp = read_file("i04")
d = parse(inp)

Test.@test valid(dt) == 2

@time a = valid(d)
println(a)
Test.@test a == 226

function strict(data)
    count(
        pp ->
            all(map(
                x -> haskey(pp, x),
                ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"],
            )) && all([
                1920 <= Base.parse(UInt, pp["byr"]) <= 2002,
                2010 <= Base.parse(UInt, pp["iyr"]) <= 2020,
                2020 <= Base.parse(UInt, pp["eyr"]) <= 2030,
                length(pp["hgt"]) >= 4,
                (
                    pp["hgt"][(end - 1):end] == "cm" &&
                    150 <= Base.parse(UInt, pp["hgt"][1:(end - 2)]) <= 193
                ) || (
                    pp["hgt"][(end - 1):end] == "in" &&
                    59 <= Base.parse(UInt, pp["hgt"][1:(end - 2)]) <= 76
                ),
                length(pp["hcl"]) == 7 &&
                    pp["hcl"][1] == '#' &&
                    occursin(r"[a-f\d]{6}", pp["hcl"][2:7]),
                pp["ecl"] in ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"],
                length(pp["pid"]) == 9,
            ]),
        data,
    )
end

Test.@test strict(dt) == 2

t2 = read_file("i04t2")
dt2 = parse(t2)
Test.@test strict(dt2) == 4

t1 = read_file("i04t1")
dt1 = parse(t1)
Test.@test strict(dt1) == 0

@time b = strict(d)
println(b)
Test.@test b == 160
