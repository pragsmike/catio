using FFTW, DSP, Printf


struct Spectro <: Block
    num_bins::Int
    window::Array{Float32}
    samps::Array{ComplexF32}
    magbins::Array{Float32}
end

function newSpectro(num_bins)
    return Spectro(
        num_bins,
        DSP.Windows.hanning(num_bins, padding=0, zerophase=false),
        Array{ComplexF32}(undef, num_bins),
        Array{Float32}(undef, num_bins)
    )
end

function tick(spectro::Spectro)
    spectro.samps .= spectro.window .*spectro.samps
    fft!(spectro.samps)
    bins = fftshift(spectro.samps)
    spectro.magbins .= abs2.(bins)
end

function getInputBuffer(spectro::Spectro)
    return spectro.samps
end
function getOutputBuffer(spectro::Spectro)
    return spectro.magbins
end
function progressString(spectro::Spectro)
    return string(spectro.magbins[18])
end

