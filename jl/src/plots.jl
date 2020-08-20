using Printf, Plots, PyPlot

infn = "/home/mg/Documents/signals/hists"
#infn = "/tmp/hists"

const fft_bins = 2048
const hist_bins = 128

function cumulate(hist)
    acc = hist[1]
    for i in 2:length(hist)
        acc += hist[i]
        hist[i] = acc
    end
end
function rcumulate(hist)
    acc = hist[length(hist)]
    for i in length(hist)-1 : -1 : 1
        acc += hist[i]
        hist[i] = acc
    end
end

hists = Array{Int}(undef, fft_bins, hist_bins)
probs = Array{Float32}(undef, fft_bins, hist_bins)

function dofile(infn)
    open(infn) do inf
        read!(inf, hists)
    end
    for i in 1:fft_bins
        let v = view(hists,i,:)
            cumulate(v)
            total = sum(v)
            probs[i,:] = v / total
        end
    end
end

function getval(x,y)
    tx = Int(floor(clamp(x, 1, fft_bins)))
    ty = Int(floor(clamp(y, 1, hist_bins)))
    hists[tx, ty]
end

function plotsurf()
    x = range(1, fft_bins, step = 4)
    y = range(1, hist_bins, step = 1)
    z = getval
    surface(x, y, z, size = (2000,2000))
    #wireframe(x, y, z, c = :thermal)
end

function plotslice()
    th = transpose(hists)
    h = th[60,:]; PyPlot.plot(h)
end

dofile(infn)

#pyplot()
plotlyjs()
#display(plotsurf())
