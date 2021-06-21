module Catio
using FFTW, DSP, Printf

export newMA, dofile,add!,get,newSpectro,newHists,
    newHPlot,plotsurf,plotslice

include("Blocks.jl")
include("specavg.jl")
include("spec.jl")
include("spechist.jl")
include("plots.jl")

end
