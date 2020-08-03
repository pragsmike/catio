using Printf, Plots

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
    probs[tx, ty]
end
function doplot()
    pyplot()
    x = range(1, fft_bins, step = 4)
    y = range(1, hist_bins, step = 1)
    z = getval
    #surface(x, y, z)
    wireframe(x, y, z, c = :thermal)
end

dofile(infn)

th = transpose(hists)
h = th[127,:]
PyPlot.plot(h)

#display(doplot())
