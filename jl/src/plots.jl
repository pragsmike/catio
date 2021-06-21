using Printf, Plots, PyPlot

struct HPlot
    fft_bins::Int32
    hist_bins::Int32
    hists::Array{Int}
    probs::Array{Float32}
end

function newHPlot(fft_bins, hist_bins)
    HPlot(fft_bins, hist_bins,
          Array{Int}(undef, fft_bins, hist_bins),
          Array{Float32}(undef, fft_bins, hist_bins))
end

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


function dofile(hplot::HPlot, infn)
    open(infn) do inf
        read!(inf, hplot.hists)
    end
    for i in 1:hplot.fft_bins
        let v = view(hplot.hists,i,:)
            cumulate(v)
            total = sum(v)
            hplot.probs[i,:] = v / total
        end
    end
end

function getval(hplot,x,y)
    tx = Int(floor(clamp(x, 1, hplot.fft_bins)))
    ty = Int(floor(clamp(y, 1, hplot.hist_bins)))
    return hplot.hists[tx, ty]
end

function plotsurf(hplot)
    x = range(1, hplot.fft_bins, step = 4)
    y = range(1, hplot.hist_bins, step = 1)
    z = (x,y) -> getval(hplot,x,y)
    surface(x, y, z, size = (2000,2000))
    #wireframe(x, y, z, c = :thermal)
end

function plotslice(hplot, i)
    th = transpose(hplot.hists)
    h = th[i,:]; PyPlot.plot(h)
end

#pyplot()
plotlyjs()
