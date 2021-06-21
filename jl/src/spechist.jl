# Computes histogram-per-bin of given FFT frame.
#
using Printf

struct Hists
    fft_bins::Int32
    hist_bins::Int32
    max_mag::Float32
    histas
end

function newHists(fft_bins, hist_bins, max_mag)
    Hists(fft_bins, hist_bins, max_mag,
          zeros(Int, fft_bins, hist_bins))
end

function add_to_hists(bins, hists)
    for i in eachindex(bins)
        bin = ceil(Int, hists.hist_bins * (bins[i] / hists.max_mag))
        bin = ceil(clamp(bin, 1, hists.hist_bins))
        hists.histas[i, bin] += 1
    end
end

function dofile(hists::Hists, infn, outfn)
    magbins = Array{Float32}(undef, hists.fft_bins)
    open(infn) do inf
        for i in 1:3000000
            try
                read!(inf, magbins)
            catch
                @printf("Input ended after reading %i frames\n", i)
                break
            end

            add_to_hists(magbins, hists)
        end
        open(outfn, "w") do outf
            write(outf, hists.histas)
        end
    end
end

