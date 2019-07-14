function sine()
  SAMPLE_RATE = 1e6;

  NUM_SECONDS = 2;
  NUM_SAMPLES = NUM_SECONDS * SAMPLE_RATE;

  SIGNAL_FREQ_RAD = 250e3 * 2 * pi;

 % Generate a vector "t" which represents time, in units of samples.
 % This starts at t=0, and creates NUM_SAMPLES samples in steps of 1/SAMPLE_RATE
  t = [ 0 : (1/SAMPLE_RATE) : (NUM_SECONDS - 1/SAMPLE_RATE) ];

    % Create a sinusoid (signal = e^(jωt) ) with a magnitude of 0.90
    signal = 0.90 * exp(1j * SIGNAL_FREQ_RAD * t);

    % Plot the FFT of our signal as a quick sanity check.
    % The NUM_SAMPLES denominator is just to normalize this for display purposes.
    f = linspace(-0.5 * SAMPLE_RATE, 0.5 * SAMPLE_RATE, length(signal));
    plot(f, 20*log10(abs(fftshift(fft(signal)))/NUM_SAMPLES));
    xlabel('Frequency (Hz)');
    ylabel('Power (dB)');
    title('250 kHz tone');

    % SAMP_RATE=1e5;st=sinetone(50e3,SAMP_RATE,1e5/SAMP_RATE,10);
endfunction
