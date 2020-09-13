using FFTW, DSP, Printf

struct Spectro
    window::Array{Float32}
end

function newSpectro(num_bins)
    return Spectro(DSP.Windows.hanning(num_bins, padding=0, zerophase=false))
end

function dofile(spectro::Spectro, infn, outfn)
    window = spectro.window
    num_bins = length(window)
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
                magbins .= abs2.(bins)
                write(fbins, magbins)
                if i % 25000 == 0
                    println(magbins[18])
                end
            end
        end
    end
end

