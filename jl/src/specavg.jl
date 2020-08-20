
mutable struct MA
    avgmagbins::Array{Float32}
    accum::Array{Float32}
    history::Array{Float32, 2}
    history_i::Int32
end

function newMA(num_bins, history_size)
    return MA(zeros(Float32, num_bins),
              zeros(Float32, num_bins),
              zeros(Float32, num_bins, history_size),
              1)
end

function add!(ma::MA, magbins)
    now = ma.history_i
    for i in eachindex(magbins)
        ma.accum[i] -= ma.history[i, now]
        ma.history[i, now] = magbins[i]
        ma.accum[i] += magbins[i]
    end
    ma.history_i += 1
    history_size = size(ma.history)[2]
    if ma.history_i > history_size; ma.history_i = 1; end
end

function get(ma::MA)
    history_size = size(ma.history)[2]
    ma.avgmagbins .= ma.accum./history_size
    return ma.avgmagbins
end

function dofile(ma, infn, outfn)
    num_bins = length(ma.avgmagbins)
    magbins = Array{Float32}(undef, num_bins)
    open(infn) do inf
        open(outfn, "w") do outf
            for i in 1:6000000
                try
                    read!(inf, magbins)
                catch
                    @printf("Input ended after reading %i frames\n", i)
                    break
                end
                add!(ma, magbins)
                write(outf, get(ma))
                if i % 25000 == 0
                    println(get(ma)[18])
                end
            end
        end
    end
end

