using FFTW, PyPlot

fn = "/home/mg/Documents/signals/gqrx_20200719_185425_454350100_1200000_fc.raw"

num_bins = 128
freq = 454.3501e6
samprate = 1200000

samps = Array{ComplexF32}(undef, num_bins)

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

history_size = 10
history = zeros(Float32, num_bins, history_size)
history_i = 0

function mavg(avg, bins)
    for i in eachindex(bins)
        global history_i += 1
        global history[i, history_i] = bins[i]
        if history_i >= history_size; history_i = 0; end
        t = sum(history[i,:])/history_size
        global avg[i] = t
    end
    return avg
end

function plot_hists(bins)
    bins = fftshift(bins)
    PyPlot.plot(bins)
end


function add_to_hists(bins, hist_5)
    for i in eachindex(bins)
        if (bins[i] > .09)
            hist_5[i] += 1
        end
    end
end

function dofile(fn)
    open(fn) do f
        hist_5 = zeros(Int, num_bins)
        avg = zeros(Float32, num_bins)
        for i in 1:50000
            fillsamps(f,samps)
            bins = fft(samps)
            magbins = abs.(bins)
            avgmagbins = mavg(avg, magbins)
            add_to_hists(avgmagbins, hist_5)
            if i % 25000 == 0
                println(avgmagbins[1])
            end
        end
        plot_hists(hist_5)
    end
end

dofile(fn)
