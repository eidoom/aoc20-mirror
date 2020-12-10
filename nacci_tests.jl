#!/usr/bin/env julia

import Test

include("./nacci.jl")

#= https://oeis.org/A000045 =#
Test.@test Nacci.fib(41) == 102334155

#= https://oeis.org/A000073 =#
Test.@test Nacci.trib(38) == 1132436852
