using FFTW, PyPlot

println(PROGRAM_FILE); for x in ARGS; println(x); end

fn = "/home/mg/Documents/signals/gqrx_20200719_185425_454350100_1200000_fc.raw"

function fillsamps(dest)
    open(fn) do f
        for n in eachindex(dest)
            r = read(f, Float32)
            i = read(f, Float32)
            dest[n] = s::Complex{Float32} = complex(r, i)
        end
    end
end

bins = 128

samps = zeros(ComplexF32,bins)

fillsamps(samps)
println(samps[2])

PyPlot.plot(20 .*log10.(abs.(fftshift(fft(samps)))))
