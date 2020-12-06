#!/usr/bin/env julia

import Test

include("./com.jl")

function parse_file(name)
    map(a -> Dict(map(b -> split(b, ":"), split(a))), split(Com.file_slurp(name), "\n\n"))
end

function valid(data)
    count(
        pp ->
            all(map(x -> haskey(pp, x), ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])),
        data,
    )
end

dt = parse_file("i04t0")
d = parse_file("i04")

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
                1920 <= parse(UInt, pp["byr"]) <= 2002,
                2010 <= parse(UInt, pp["iyr"]) <= 2020,
                2020 <= parse(UInt, pp["eyr"]) <= 2030,
                length(pp["hgt"]) >= 4,
                (
                    pp["hgt"][(end - 1):end] == "cm" &&
                    150 <= parse(UInt, pp["hgt"][1:(end - 2)]) <= 193
                ) || (
                    pp["hgt"][(end - 1):end] == "in" &&
                    59 <= parse(UInt, pp["hgt"][1:(end - 2)]) <= 76
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

dt2 = parse_file("i04t2")
Test.@test strict(dt2) == 4

dt1 = parse_file("i04t1")
Test.@test strict(dt1) == 0

@time b = strict(d)
println(b)
Test.@test b == 160
