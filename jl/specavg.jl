using FFTW, PyPlot, DSP

infn = "/home/mg/Documents/signals/fft_frames"
outfn = "/tmp/fft_frames_avg"

const num_bins = 2048

const history_size = 100

function mavg!(avg, bins, history, history_i)
    for i in eachindex(bins)
        history[i, history_i] = bins[i]
        avg[i] = sum(history[i,:])/history_size
    end
    history_i += 1
    if history_i >= history_size; history_i = 1; end
    return history_i
end

function dofile(infn, outfn)
    magbins = Array{Float32}(undef, num_bins)
    avgmagbins = zeros(Float32, num_bins)
    history = zeros(Float32, num_bins, history_size)
    history_i = 1
    open(infn) do inf
        open(outfn, "w") do outf
            for i in 1:6000000
                try
                    read!(inf, magbins)
                catch
                    @printf("Input ended after reading %i frames\n", i)
                    break
                end
                history_i = mavg!(avgmagbins, magbins, history, history_i)
                write(outf, avgmagbins)
                if i % 25000 == 0
                    println(avgmagbins[18])
                end
            end
        end
    end
end

@time dofile(infn, outfn)
