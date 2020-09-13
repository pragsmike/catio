using Catio

infn = "/home/mg/Documents/signals/SDRuno_20200912_190336Z_2681kHz.cf32"
fn1 = "/tmp/fft_frames"
fn2 = "/tmp/fft_frames_avg_100"

samp_rate = 6000000
num_bins = 2048

spectro = newSpectro(num_bins)
@time dofile(spectro, infn, fn1)

history_size = 100
ma = newMA(num_bins, history_size)

@time dofile(ma, fn1, fn2)
