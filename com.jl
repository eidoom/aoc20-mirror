module Com
export file_lines
export file_slurp
export file_paras

function file_lines(name::String)::Vector{String}
    buf::Vector{String} = open(name, "r") do file
        readlines(file)
    end
    filter(line::String -> line != "", buf)
end

function file_slurp(name::String)::SubString
    buf::String = open(name, "r") do file
        read(file, String)
    end
    strip(buf)
end

function file_paras(name::String)::Vector{String}
    split(file_slurp(name), "\n\n")
end

end
