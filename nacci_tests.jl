#!/usr/bin/env julia

import Test

include("./nacci.jl")

#= https://oeis.org/A000045 =#
Test.@test Nacci.fib(41) === 102334155
Test.@test Nacci.n_nacci(2, 41, [0,1]) === 102334155

#= https://oeis.org/A000073 =#
Test.@test Nacci.trib(38) === 1132436852
Test.@test Nacci.n_nacci(3, 38, [0,0,1]) === 1132436852
#= Test.@test Nacci.trib_alt(38) == 1132436852 =#

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

#= https://oeis.org/A000288 =#
Test.@test Nacci.n_nacci(4, 35, [1,1,1,1]) === 1253477764

#= https://oeis.org/A000322 =#
Test.@test Nacci.n_nacci(5, 35, [1,1,1,1,1]) === 1428864769

#= https://oeis.org/A000383 =#
Test.@test Nacci.n_nacci(6, 37, [1,1,1,1,1,1]) === 4411648301
