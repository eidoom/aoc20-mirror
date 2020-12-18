#!/usr/bin/env julia

import Test

include("./nacci.jl")

#= Fibonacci 0,1,... =#
#= https://oeis.org/A000045 =#
Test.@test Nacci.n_nacci(2, 41, [0, 1]) === 102334155
#= Test.@test Nacci.fib(41) === 102334155 =#

#= Tribonacci 0,0,1,... =#
#= https://oeis.org/A000073 =#
Test.@test Nacci.n_nacci(3, 38, vcat(fill(0, 2), [1])) === 1132436852
#= Test.@test Nacci.trib(38) === 1132436852 =#
#= Test.@test Nacci.trib_alt(38) == 1132436852 =#

#= Tetranacci 0,0,0,1,... =#
#= https://oeis.org/A000078 =#
Test.@test Nacci.n_nacci(4, 38, vcat(fill(0, 3), [1])) === 2775641472

#= Pentanacci 0,0,0,0,1,... =#
#= https://oeis.org/A001591 =#
Test.@test Nacci.n_nacci(5, 38, vcat(fill(0, 4), [1])) === 2621810068

#= Hexanacci 0,0,0,0,0,1,... =#
#= https://oeis.org/A001592 =#
Test.@test Nacci.n_nacci(6, 39, vcat(fill(0, 5), [1])) === 3414621024

#= a = 58 =#
#= @time println(Nacci.trib(a)) =#
#= @time println(Nacci.trib_alt(a)) =#

#= b = 10 =#
#= s = 10 =#
#= e = 50 =#

#= function rec() =#
#=     cache = Dict() =#
#=     for i = b:s:e =#
#=         println(Nacci.trib(i, cache)) =#
#=     end =#
#= end =#

#= function frm() =#
#=     cache = Nacci.trib_ks() =#
#=     for i = b:s:e =#
#=         println(Nacci.trib_alt(i, cache...)) =#
#=     end =#
#= end =#

#= @time rec() =#
#= @time frm() =#

#= c = 80 =#
#= @time println(Nacci.fib(c)) =#
#= @time println(Nacci.trib(c)) =#

#= Tribonacci 0,1,0,... =#
#= https://oeis.org/A001590 =#
Test.@test Nacci.n_nacci(3, 38, [0, 1, 0]) === 950439251

#= Tribonacci 1,1,1,... =#
#= https://oeis.org/A000213 =#
Test.@test Nacci.n_nacci(3, 37, fill(1, 3)) === 1467182629

#= Tetranacci 1,1,1,1,... =#
#= https://oeis.org/A000288 =#
Test.@test Nacci.n_nacci(4, 35, fill(1, 4)) === 1253477764

#= Pentanacci 1,1,1,1,1,... =#
#= https://oeis.org/A000322 =#
Test.@test Nacci.n_nacci(5, 35, fill(1, 5)) === 1428864769

#= Hexanacci 1,1,1,1,1,1,... =#
#= https://oeis.org/A000383 =#
Test.@test Nacci.n_nacci(6, 37, fill(1, 6)) === 4411648301
