using Catio: newMA, dofile

infn = "/home/mg/Documents/signals/fft_frames"
outfn = "/tmp/fft_frames_avg"

const num_bins = 2048
const history_size = 100

ma = newMA(num_bins, history_size)

@time dofile(ma, infn, outfn)

