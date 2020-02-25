from gnuradio.filter import firdes
b = firdes.low_pass(1, 2048000, 70000, 20000, firdes.WIN_HAMMING)
from scipy import signal
w, h = signal.freqz(b)
import matplotlib.pyplot as plt 
import numpy as np
plt.plot(w, 20 * np.log10(abs(h)), 'b')
plt.ylabel('Amplitude [dB]', color='b')
plt.xlabel('Frequency [rad/sample]')
plt.show()
