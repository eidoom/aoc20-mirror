module Nacci

export fib
export trib
#= export trib_ks =#
#= export trib_alt =#
export trib4

#= These are unity indexed (blame Julia not me) =#

#= https://en.wikipedia.org/wiki/Fibonacci_number =#
function fib(n, cache = Dict())
    #= 0, 1, 1, 2, 3, 5, ... =#
    if n < 3
        n - 1
    else
        for m in (n - 1, n - 2)
            if !haskey(cache, m)
                cache[m] = fib(m, cache)
            end
        end
        cache[n - 1] + cache[n - 2]
    end
end

#= https://en.wikipedia.org/wiki/Generalizations_of_Fibonacci_numbers#Tribonacci_numbers =#
function trib(n, cache = Dict())
    #= 0, 0, 1, 1, 2, 4, ... =#
    if n < 3
        0
    elseif n == 3
        1
    else
        for m = (n - 3):(n - 1)
            if !haskey(cache, m)
                cache[m] = trib(m, cache)
            end
        end
        cache[n - 1] + cache[n - 2] + cache[n - 3]
    end
end

#= ---------------------------------------------------------------- =#
#= From https://en.wikipedia.org/wiki/Generalizations_of_Fibonacci_numbers#Tribonacci_numbers =#
#= which is compact version of: https://vixra.org/pdf/1410.0054v6.pdf Formula 2 =#
#= In Julia, holds for 1 <= n <= 58. Works after in Mathematica, why breaks in Julia? =#
#= Slower =#

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

function trib4(n, cache = Dict())
    #= 1, 2, 4, 7, 13, 24, ... =#
    if n == 1
        1
    elseif n == 2
        2
    elseif n == 3
        4
    else
        for m = (n - 3):(n - 1)
            if !haskey(cache, m)
                cache[m] = trib(m, cache)
            end
        end
        cache[n - 1] + cache[n - 2] + cache[n - 3]
    end
end

end
