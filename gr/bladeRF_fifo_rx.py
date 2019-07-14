#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: bladeRF FIFO RX
# Author: Jon Szymaniak <jon.szymaniak@nuand.com>
# Description: RX bladeRF SC16 Q11 samples from a FIFO, convert them to GR Complex values, and write them to a GUI sink.
# Generated: Sat Jul 15 18:26:52 2017
##################################################

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print "Warning: failed to XInitThreads()"

from PyQt4 import Qt
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio import qtgui
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from gnuradio.qtgui import Range, RangeWidget
from optparse import OptionParser
import sip
import sys
from gnuradio import qtgui


class bladeRF_fifo_rx(gr.top_block, Qt.QWidget):

    def __init__(self, fifo='/tmp/rx_samples.bin', frequency=1e9, sample_rate=2000000):
        gr.top_block.__init__(self, "bladeRF FIFO RX")
        Qt.QWidget.__init__(self)
        self.setWindowTitle("bladeRF FIFO RX")
        qtgui.util.check_set_qss()
        try:
            self.setWindowIcon(Qt.QIcon.fromTheme('gnuradio-grc'))
        except:
            pass
        self.top_scroll_layout = Qt.QVBoxLayout()
        self.setLayout(self.top_scroll_layout)
        self.top_scroll = Qt.QScrollArea()
        self.top_scroll.setFrameStyle(Qt.QFrame.NoFrame)
        self.top_scroll_layout.addWidget(self.top_scroll)
        self.top_scroll.setWidgetResizable(True)
        self.top_widget = Qt.QWidget()
        self.top_scroll.setWidget(self.top_widget)
        self.top_layout = Qt.QVBoxLayout(self.top_widget)
        self.top_grid_layout = Qt.QGridLayout()
        self.top_layout.addLayout(self.top_grid_layout)

        self.settings = Qt.QSettings("GNU Radio", "bladeRF_fifo_rx")
        self.restoreGeometry(self.settings.value("geometry").toByteArray())

        ##################################################
        # Parameters
        ##################################################
        self.fifo = fifo
        self.frequency = frequency
        self.sample_rate = sample_rate

        ##################################################
        # Variables
        ##################################################
        self.sample_rate_range = sample_rate_range = sample_rate
        self.frequency_range = frequency_range = frequency

        ##################################################
        # Blocks
        ##################################################
        self._sample_rate_range_range = Range(160e3, 40e6, 1e6, sample_rate, 200)
        self._sample_rate_range_win = RangeWidget(self._sample_rate_range_range, self.set_sample_rate_range, 'Sample Rate', "counter", float)
        self.top_grid_layout.addWidget(self._sample_rate_range_win, 0, 0, 1, 1)
        self._frequency_range_range = Range(300e6, 3.8e9, 1e6, frequency, 200)
        self._frequency_range_win = RangeWidget(self._frequency_range_range, self.set_frequency_range, 'Frequency', "counter", float)
        self.top_grid_layout.addWidget(self._frequency_range_win, 0, 1, 1, 1)
        self.qtgui_sink_x_0 = qtgui.sink_c(
        	1024, #fftsize
        	firdes.WIN_BLACKMAN_hARRIS, #wintype
        	frequency_range, #fc
        	sample_rate_range, #bw
        	"", #name
        	True, #plotfreq
        	True, #plotwaterfall
        	True, #plottime
        	True, #plotconst
        )
        self.qtgui_sink_x_0.set_update_time(1.0/10)
        self._qtgui_sink_x_0_win = sip.wrapinstance(self.qtgui_sink_x_0.pyqwidget(), Qt.QWidget)
        self.top_grid_layout.addWidget(self._qtgui_sink_x_0_win, 1, 0, 1, 8)

        self.qtgui_sink_x_0.enable_rf_freq(False)



        self.blocks_throttle_0 = blocks.throttle(gr.sizeof_gr_complex*1, sample_rate,True)
        self.blocks_multiply_const_vxx_0 = blocks.multiply_const_vcc(((1.0 / 2048.0), ))
        self.blocks_interleaved_short_to_complex_0 = blocks.interleaved_short_to_complex(True, False)
        self.blocks_file_source_0_0 = blocks.file_source(gr.sizeof_short*2, '/home/mg/prefix/src/mg/sigs/rf-929611400.sc16q11', False)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_file_source_0_0, 0), (self.blocks_interleaved_short_to_complex_0, 0))
        self.connect((self.blocks_interleaved_short_to_complex_0, 0), (self.blocks_throttle_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0, 0), (self.qtgui_sink_x_0, 0))
        self.connect((self.blocks_throttle_0, 0), (self.blocks_multiply_const_vxx_0, 0))

    def closeEvent(self, event):
        self.settings = Qt.QSettings("GNU Radio", "bladeRF_fifo_rx")
        self.settings.setValue("geometry", self.saveGeometry())
        event.accept()

    def get_fifo(self):
        return self.fifo

    def set_fifo(self, fifo):
        self.fifo = fifo

    def get_frequency(self):
        return self.frequency

    def set_frequency(self, frequency):
        self.frequency = frequency
        self.set_frequency_range(self.frequency)

    def get_sample_rate(self):
        return self.sample_rate

    def set_sample_rate(self, sample_rate):
        self.sample_rate = sample_rate
        self.set_sample_rate_range(self.sample_rate)
        self.blocks_throttle_0.set_sample_rate(self.sample_rate)

    def get_sample_rate_range(self):
        return self.sample_rate_range

    def set_sample_rate_range(self, sample_rate_range):
        self.sample_rate_range = sample_rate_range
        self.qtgui_sink_x_0.set_frequency_range(self.frequency_range, self.sample_rate_range)

    def get_frequency_range(self):
        return self.frequency_range

    def set_frequency_range(self, frequency_range):
        self.frequency_range = frequency_range
        self.qtgui_sink_x_0.set_frequency_range(self.frequency_range, self.sample_rate_range)


def argument_parser():
    description = 'RX bladeRF SC16 Q11 samples from a FIFO, convert them to GR Complex values, and write them to a GUI sink.'
    parser = OptionParser(usage="%prog: [options]", option_class=eng_option, description=description)
    parser.add_option(
        "-f", "--fifo", dest="fifo", type="string", default='/tmp/rx_samples.bin',
        help="Set Full path to FIFO [default=%default]")
    parser.add_option(
        "", "--frequency", dest="frequency", type="eng_float", default=eng_notation.num_to_str(1e9),
        help="Set Frequency [default=%default]")
    parser.add_option(
        "-s", "--sample-rate", dest="sample_rate", type="eng_float", default=eng_notation.num_to_str(2000000),
        help="Set Sample Rate [default=%default]")
    return parser


def main(top_block_cls=bladeRF_fifo_rx, options=None):
    if options is None:
        options, _ = argument_parser().parse_args()

    from distutils.version import StrictVersion
    if StrictVersion(Qt.qVersion()) >= StrictVersion("4.5.0"):
        style = gr.prefs().get_string('qtgui', 'style', 'raster')
        Qt.QApplication.setGraphicsSystem(style)
    qapp = Qt.QApplication(sys.argv)

    tb = top_block_cls(fifo=options.fifo, frequency=options.frequency, sample_rate=options.sample_rate)
    tb.start()
    tb.show()

    def quitting():
        tb.stop()
        tb.wait()
    qapp.connect(qapp, Qt.SIGNAL("aboutToQuit()"), quitting)
    qapp.exec_()


if __name__ == '__main__':
    main()
