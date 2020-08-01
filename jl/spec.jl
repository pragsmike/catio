using FFTW, PyPlot, DSP, Printf

infn = "/home/mg/Documents/signals/gqrx_20200719_185425_454350100_1200000_fc.raw"
outfn = "/tmp/fft_frames"

const num_bins = 2048

function dofile(infn, outfn)
    window = DSP.Windows.hanning(num_bins, padding=0, zerophase=false)
    samps = Array{ComplexF32}(undef, num_bins)
    magbins = Array{Float32}(undef, num_bins)
    open(infn) do f
        open(outfn, "w") do fbins
            for i in 1:6000000
                try
                    read!(f, samps)
                catch
                    @printf("Input ended after reading %i frames\n", i)
                    break
                end
                samps .= window .*samps
                fft!(samps)
                bins = fftshift(samps)
                magbins .= abs.(samps)
                write(fbins, magbins)
                if i % 25000 == 0
                    println(magbins[18])
                end
            end
        end
    end
end

@time dofile(infn, outfn)
