module Com
export file_lines
export file_slurp

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

end
