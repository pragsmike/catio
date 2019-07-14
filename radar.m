addpath('/home/mg/prefix/src/gnuradio/gr-utils/octave');
pkg load signal

c=read_complex_binary('/home/mg/prefix/src/mg/sigs/name-f5.210000e+09-s2.500000e+05-t20170716211742.cfile');
SAMPLE_RATE = 2e5

d=c(1:100000);
plot(1:length(d),d);

f = fftshift(fft(c));
plot(1:length(f),f);

function showt(c,start,n)
   d = c(start:start+n);
   plot(1:length(d),d);
endfunction