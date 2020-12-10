module Nacci
export fib
export trib

function fib(n, cache = Dict())
    if n <= 1
        n
    else
        for m in (n - 1, n - 2)
            if !haskey(cache, m)
                cache[m] = fib(m, cache)
            end
        end
        cache[n - 1] + cache[n - 2]
    end
end

function trib(n, cache = Dict())
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

#= function trib(n, cache = Dict()) =#
#=     if n < 3 =#
#=         0 =#
#=     elseif n == 3 =#
#=         1 =#
#=     else =#
#=         for m = (n - 3):(n - 1) =#
#=             if !haskey(cache, m) =#
#=                 cache[m] = trib(m, cache) =#
#=             end =#
#=         end =#
#=         cache[n - 1] + cache[n - 2] + cache[n - 3] =#
#=     end =#
#= end =#

end
