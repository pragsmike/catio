using FFTW, PyPlot, DSP

fn = "/home/mg/Documents/signals/gqrx_20200719_185425_454350100_1200000_fc.raw"

const num_bins = 512
const freq = 454.3501e6
const samprate = 1200000


function fillsamps!(f, dest)
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

const history_size = 10

function mavg!(avg, bins, history, history_i)
    for i in eachindex(bins)
        history_i += 1
        history[i, history_i] = bins[i]
        if history_i >= history_size; history_i = 0; end
        avg[i] = sum(history[i,:])/history_size
    end
    return history_i
end

function plot_hists(bins)
    bins = fftshift(bins)
    PyPlot.plot(bins)
end


function add_to_hists(bins, hist_5, hist_10)
    for i in eachindex(bins)
        if (bins[i] > .10)
            hist_10[i] +=1
        end
        if (bins[i] > .07)
            hist_5[i] += 1
        end
    end
end

function dofile(fn)
    open(fn) do f
        hist_5 = zeros(Int, num_bins)
        hist_10 = zeros(Int, num_bins)
        avgmagbins = zeros(Float32, num_bins)
        samps = Array{ComplexF32}(undef, num_bins)
        window = DSP.Windows.hanning(num_bins, padding=0, zerophase=false)
        history = zeros(Float32, num_bins, history_size)
        history_i = 0
        for i in 1:6000000
            if !fillsamps!(f,samps); break; end
            samps = window .*samps
            bins = fft(samps)
            magbins = abs.(bins)
            history_i = mavg!(avgmagbins, magbins, history, history_i)
            add_to_hists(avgmagbins, hist_5, hist_10)
            if i % 25000 == 0
                println(avgmagbins[18])
            end
        end
        write("/tmp/hist_5", hist_5)
        write("/tmp/hist_10", hist_10)
        plot_hists(hist_5)
        plot_hists(hist_10)
    end
end

dofile(fn)
