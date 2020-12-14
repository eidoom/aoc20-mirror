#!/usr/bin/env julia

import Test

include("./com.jl")

function read_file(name)
    init = []
    for line in Com.file_lines(name)
        op, val = split(line, " = ")
        p = match(r"mem\[(\d+)\]", op)
        if p === nothing
            push!(init, (op, val))
        else
            push!(init, map(i -> parse(Int32, i), (p.captures[1], val)))
        end
    end
    init
end

function emulator1(prog)
    mask = ""
    mem = fill(0, 1 << 16)
    for (op, val) in prog
        if op == "mask"
            mask = val
        else
            bin = "0000" * bitstring(val)
            res = 0
            for i = 1:36
                if mask[i] == '1'
                    res += 1 << (36 - i)
                elseif mask[i] == '0'
                    continue
                elseif bin[i] == '1'
                    res += 1 << (36 - i)
                end
            end
            mem[op] = res
        end
    end
    sum(mem)
end

t = read_file("i14t0")
inp = read_file("i14")

Test.@test emulator1(t) == 165

@time a = emulator1(inp)
println(a)
Test.@test a == 6559449933360

function all(res, arr, ii = 1)
    res = deepcopy(res)
    for i = ii:36
        if res[i] == 'X'
            res[i] = '0'
            all(res, arr, i + 1)
            res[i] = '1'
            all(res, arr, i + 1)
            return
        end
    end
    push!(arr, res)
end

function bin2dec(bin)
    dec = 0
    for i = 1:36
        if bin[i] == '1'
            dec += 1 << (36 - i)
        end
    end
    dec
end

function dec2bin(dec)
    bin = BitArray(undef, 36)
    for i = 1:36
        bin[i], dec = divrem(dec, 1 << (36 - i))
    end
    map(i -> i ? '1' : '0', bin)
end

function emulator2(prog)
    mask = ""
    mem = Dict()
    for (op, val) in prog
        if op == "mask"
            mask = val
        else
            add = dec2bin(op)
            res = [(m == '1' || m == 'X') ? m : a for (a, m) in zip(add, mask)]
            arr = []
            all(res, arr)
            for r in arr
                mem[bin2dec(r)] = val
            end
        end
    end
    sum(values(mem))
end

t1 = read_file("i14t1")
println(emulator2(t1))
Test.@test emulator2(t1) == 208

@time b = emulator2(inp)
println(b)
Test.@test b == 3369767240513
