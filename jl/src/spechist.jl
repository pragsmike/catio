# Computes histogram-per-bin of given FFT frame.
#
using FFTW, PyPlot, DSP, Printf

infn = "/home/mg/Documents/signals/fft_frames_avg_100"
outfn = "/tmp/hists"

const fft_bins = 2048
const hist_bins = 128
const max_mag = 0.5

function plot_hist(bins)
    #PyPlot.plot(bins)
end


function add_to_hists(bins, hists)
    for i in eachindex(bins)
        bin = ceil(Int, hist_bins * (bins[i] / max_mag))
        bin = ceil(clamp(bin, 1, hist_bins))
        hists[i, bin] += 1
    end
end

function dofile(infn, outfn)
    magbins = Array{Float32}(undef, fft_bins)
    hists = zeros(Int, fft_bins, hist_bins)
    open(infn) do inf
        for i in 1:3000000
            try
                read!(inf, magbins)
            catch
                @printf("Input ended after reading %i frames\n", i)
                break
            end

            add_to_hists(magbins, hists)

            if i % 50000 == 0
                plot_hist(hists[18,:])
            end
        end
        open(outfn, "w") do outf
            write(outf, hists)
        end
    end
    plot_hist(hists[20,:])
end

@time dofile(infn, outfn)
