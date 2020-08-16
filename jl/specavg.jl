using FFTW, PyPlot, DSP,Test,Printf

infn = "/home/mg/Documents/signals/fft_frames"
outfn = "/tmp/fft_frames_avg"

const num_bins = 2048

const history_size = 100

mutable struct MA
    avgmagbins::Array{Float32}
    history::Array{Float32, 2}
    history_i::Int32
end

function newMA(num_bins, history_size)
    return MA(zeros(Float32, num_bins),
              zeros(Float32, num_bins, history_size),
              1)
end

function add!(ma::MA, magbins)
    history_size = size(ma.history)[2]
    for i in eachindex(magbins)
        ma.history[i, ma.history_i] = magbins[i]
        ma.avgmagbins[i] = sum(ma.history[i,:])/history_size
    end
    ma.history_i += 1
    if ma.history_i > history_size; ma.history_i = 1; end
end



function dofile(infn, outfn)
    magbins = Array{Float32}(undef, num_bins)
    ma = newMA(num_bins, history_size)
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
                write(outf, ma.avgmagbins)
                if i % 25000 == 0
                    println(ma.avgmagbins[18])
                end
            end
        end
    end
end

@testset "moving average sanity checks" begin
    magbins = ones(Float32, num_bins)

    ma = newMA(num_bins, history_size)
    add!(ma, magbins)

    @test ma.avgmagbins ≈ fill(0.01, num_bins)

    add!(ma, magbins)

    @test ma.avgmagbins ≈ fill(0.02, num_bins)

    for i in 1:200
        add!(ma, magbins)
    end
    @test ma.history[1,:] ≈ fill(1.0, history_size)

    @test ma.avgmagbins ≈ fill(1.0, num_bins)

end

#@time dofile(infn, outfn)
