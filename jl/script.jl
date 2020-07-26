using FFTW, PyPlot

fn = "/home/mg/Documents/signals/gqrx_20200719_185425_454350100_1200000_fc.raw"

num_bins = 128
freq = 454.3501e6
samprate = 1200000

samps = Array{ComplexF32}(undef, num_bins)
avg = zeros(ComplexF32, num_bins)

function fillsamps(f, dest)
    for n in eachindex(dest)
        if eof(f)
            return false
        end
        r = read(f, Float32)
        i = read(f, Float32)
        dest[n] = s::Complex{Float32} = complex(r, i)
    end
    return true
end

function thresh(bins, th)
    for i in eachindex(bins)
        if (bins[i] > th)
            bins[i] = 1
        else
            bins[i] = 0
        end
    end
end

history_size = 100
history = zeros(ComplexF32, num_bins, history_size)
history_i = 0

function mavg(bins)
    for i in eachindex(bins)
        global history_i += 1
        history[i, history_i] = bins[i]
        if history_i >= history_size; history_i = 0; end
        t = sum(history[i,:])/history_size
        avg[i] = t
    end
end

function dofile(fn)
    open(fn) do f
        for i in 1:50000
            fillsamps(f,samps)
            bins = fft(samps)
            mavg(bins)
            if i % 25000 == 0
                tavg = fftshift(avg)
                db = 20 .*log10.(abs.(tavg))
                thresh(db, -30)
                PyPlot.plot(db)
            end
        end
    end
end

dofile(fn)
