using Makie
using AbstractPlotting

infn = "../data/hists"
const fft_bins = 2048
const hist_bins = 128

hists = Array{Int}(undef, fft_bins, hist_bins)

function readfile(infn)
    open(infn) do inf
        read!(inf, hists)
    end
end

readfile(infn)

s1 = slider(1:128, raw = true, camera = campixel!, start = 20)

x = range(1, stop = fft_bins)

y1 = lift(s1[end][:value]) do v
    hists[x,v]
end

scene = lines(x, y1, color = :blue)
scatter!(scene, x, y1, color = :red, markersize = 0.1)
s = hbox(s1, scene)
display(s)
