module Nacci

export fib
export trib
#= export trib_ks =#
#= export trib_alt =#
export trib4

#= These are unity indexed (blame Julia not me) =#
#= set the cache to change the start of the sequence =#
#= share the cache between multiple calls for maximum performance =#

#= ================================================================ =#
#= Fibonacci sequence =#
#= https://oeis.org/A000045 =#
#= https://en.wikipedia.org/wiki/Fibonacci_number =#

#= memoized recursive - slower than iterative =#
#= function fib(n::Int, memo = Dict{Int,Int}(1 => 0, 2 => 1))::Int =#
#=     #1= 0, 1, 1, 2, 3, 5, ... =1# =#
#=     if n < 3 =#
#=         return memo[n] =#
#=     end =#
#=     for m in (n - 1, n - 2) =#
#=         if !haskey(memo, m) =#
#=             memo[m] = fib(m, memo) =#
#=         end =#
#=     end =#
#=     memo[n - 1] + memo[n - 2] =#
#= end =#

#= tabulated iterative - fastest =#
function fib(n::Int, table::Vector{Int} = [0, 1])::Int
    #= 0, 1, 1, 2, 3, 5, ... =#
    m = length(table)
    if m < n
        resize!(table, n)
    end
    for i = (m + 1):n
        table[i] = sum(j -> table[i - j], 1:2)
    end
    table[n]
end

#= ================================================================ =#
#= Tribonacci sequence =#
#= https://oeis.org/A000073 =#
#= https://en.wikipedia.org/wiki/Generalizations_of_Fibonacci_numbers#Tribonacci_numbers =#

#= memoized recursive - slower than iterative =#
#= function trib(n::Int, memo::Dict{Int,Int} = Dict(1 => 0, 2 => 0, 3 => 1))::Int =#
#=     #1= 0, 0, 1, 1, 2, 4, ... =1# =#
#=     if n < 4 =#
#=         memo[n] =#
#=     else =#
#=         for m = (n - 3):(n - 1) =#
#=             if !haskey(memo, m) =#
#=                 memo[m] = trib(m, memo) =#
#=             end =#
#=         end =#
#=         memo[n - 1] + memo[n - 2] + memo[n - 3] =#
#=     end =#
#= end =#

#= tabulated iterative - fastest =#
function trib(n::Int, table::Vector{Int} = [0, 0, 1])::Int
    #= 0, 0, 1, 1, 2, 4, ... =#
    m = length(table)
    if m < n
        resize!(table, n)
    end
    for i = (m + 1):n
        table[i] = sum(j -> table[i - j], 1:3)
    end
    table[n]
end

#= ---------------------------------------------------------------- =#
#= analytical expression =#
#= From https://en.wikipedia.org/wiki/Generalizations_of_Fibonacci_numbers#Tribonacci_numbers =#
#= which is compact version of: https://vixra.org/pdf/1410.0054v6.pdf Formula 2 =#
#= In Julia, holds for 1 <= n <= 58. Works after in Mathematica, why breaks in Julia? Types? =#
#= Slower than the memoised recursive method =#

#= function trib_ks() =#
#=     sr = sqrt(33) =#
#=     tt = 3 * sr =#
#=     ap = cbrt(19 + tt) =#
#=     am = cbrt(19 - tt) =#
#=     b = cbrt(586 + 102 * sr) =#
#=     k = 3 * b / (b * (b - 2) + 4) =#
#=     base = (ap + am + 1) / 3 =#
#=     (k, base) =#
#= end =#

#= function trib_alt(n, k, base) =#
#=     round(UInt, k * base^(n - 2), RoundNearestTiesUp) =#
#= end =#

#= function trib_alt(n) =#
#=     trib_alt(n, trib_ks()...) =#
#= end =#

#= ---------------------------------------------------------------- =#

#= ================================================================ =#

function n_nacci(N::Int, n::Int, table::Vector{Int})::Int
    m = length(table)
    if m < n
        resize!(table, n)
    end
    for i = (m + 1):n
        table[i] = sum(j -> table[i - j], 1:N)
    end
    table[n]
end

end
