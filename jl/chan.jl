using FFTW, PyPlot, DSP

fn = "data/2048/hist_6"

function fillspec!(f, bins)
    for n in eachindex(bins)
        if eof(f)
            return false
        end
        bins[n] = read(f, Int)
    end
    return true
end

function plot_hists(bins)
    PyPlot.plot(bins)
end

const fc = 50
const a = 1/(2*pi*fc + 1)

function hpf(x)
    let y = zeros(Float32, length(x))
        y[1] = 0
        for i in 2:length(x)
            y[i] = a * (y[i-1] + x[i] - x[i - 1])
        end
        return y
    end
end

const fcl = 1000
const al = 2*pi*fcl / (1 + 2*pi*fcl)

function lpf(x)
    let y = zeros(Float32, length(x))
        y[1] = al * x[1]
        for i in 2:length(x)
            y[i] = al * x[i] + (1-al) * y[i-1]
        end
        return y
    end
end

function thresh!(bins, th)
    for i in eachindex(bins)
        if (bins[i] > th)
            bins[i] = 1
        elseif (bins[i] < -th)
            bins[i] = -1
        else
            bins[i] = 0
        end
    end
end

let bins = zeros(Int, 2048), filtbins = zeros(Float32, 2048)
    open(fn) do f
        fillspec!(f, bins)
    end
    filtbins = hpf(bins)
    filtbins = fftshift(filtbins)
    filtbins = lpf(filtbins)
    thresh!(filtbins, 50)
    plot_hists(filtbins)
end

