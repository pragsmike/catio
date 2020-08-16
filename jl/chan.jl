using FFTW, PyPlot, DSP, DataStructures, StatsBase

infn = "data/hists"
const fft_bins = 2048
const hist_bins = 128

function cumulate(hist)
    acc = hist[1]
    for i in 2:length(hist)
        acc += hist[i]
        hist[i] = acc
    end
end

struct Channel
    bot
    top
end

const binhzw = 1200000/2048
const bin1 = 453749800

function width(c)
    (c.top-c.bot)*binhzw
end
function center(c)
    binhzw*(c.top+c.bot)/2 + bin1
end

Base.show(io::IO, x::Channel) = print(io, string("[" , x.bot , " " , x.top , "] ", width(x), " ", round(center(x)/1e6, digits=3)))

channels = nil()

cbot = -1

function chanbot(bot)
    global cbot = bot
end
function chantop(top)
    c = Channel(cbot,top)
    global channels = cons(c, channels)
end

hists = Array{Int}(undef, fft_bins, hist_bins)

function dofile(infn)
    open(infn) do inf
        read!(inf, hists)
    end
    for i in 1:fft_bins
        let v = view(hists,i,:)
            cumulate(v)
        end
    end

    th = transpose(hists)
    h = th[60,:]
    #PyPlot.plot(h)

    base = h[1]
    state = false
    for i in 2:length(h)
        d = base - h[i]
        t = 5000
        if d > t
            if state == false
                state = true
                chanbot(i)
            end
        else
            if state == true
                state = false
                chantop(i)
            end
        end
    end
    for i in channels
        println(i)
    end

    widths = [ width(c) for c in channels]

#    PyPlot.hist(widths)

end


dofile(infn)
