module Com
export file_lines
export file_slurp

function file_lines(name::String)::Array{String,1}
    a::Array{String,1} = open(name, "r") do f
        readlines(f)
    end
    filter(l::String -> l != "", a)
end

function file_slurp(name::String)::SubString
    a = open(name, "r") do f
        read(f, String)
    end
    strip(a)
end

end
