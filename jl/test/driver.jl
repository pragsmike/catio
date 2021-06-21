using Catio

infn = "/home/mg/Documents/signals/SDRuno_20200912_190336Z_2681kHz.cf32"
fn1 = "/tmp/fft_frames"
fn2 = "/tmp/fft_frames_avg_100"
fn3 = "/tmp/hists"

samp_rate = 6000000
fft_bins = 2048

spectro = newSpectro(fft_bins)
@time dofile(spectro, infn, fn1)

history_size = 100
ma = newMA(fft_bins, history_size)

#@time dofile(ma, fn1, fn2)

hist_bins = 128
max_mag = 2.0
hists = newHists(fft_bins, hist_bins, max_mag)

#@time dofile(hists, fn2, fn3)


hplot = newHPlot(fft_bins, hist_bins)
#@time dofile(hplot, fn3)
