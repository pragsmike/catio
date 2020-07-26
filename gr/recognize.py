#!/usr/bin/python3

'''
Recognize channels within a band by detecting signals within the band.

Input is a vector of FFT magnitudes.
Output is a list of spans [(min, max) ...]
of contiguous ranges of frequencies where nonzero magnitudes occur.
'''
"""
Embedded Python Blocks:

Each time this file is saved, GRC will instantiate the first class it finds
to get ports and parameters of your block. The arguments to __init__  will
be the parameters. All of them are required to have default values!
"""

import numpy as np
from gnuradio import gr
import array


class blk(gr.sync_block):  # other base classes are basic_block, decim_block, interp_block
    """Embedded Python Block example - a simple multiply const"""

    def __init__(self, vector_size=256):  # only default arguments here
        """arguments to this function show up as parameters in GRC"""
        gr.sync_block.__init__(
            self,
            name='Vector Decay',   # will show up in GRC
            in_sig=[(np.float32,vector_size)],
            out_sig=[(np.float32,vector_size)]
        )
        self.acc = np.zeros(vector_size, np.float32)
        self.counter = 0;
        # if an attribute with the same name as a parameter is found,
        # a callback is registered (properties work, too).
        self.vector_size = vector_size

    def work(self, input_items, output_items):
        isig = input_items[0]
        osig = output_items[0]
        size = len(isig)
        acc = self.acc

        self.counter += 1
#        if self.counter % 100000000:
#            for i in range(0,size):
#                acc[i] = isig[i]
        for i in range(0,len(isig)):
            osig[i] =  isig[i]
        #output_items[0][:] = input_items[0] * 5
        return size # len(output_items[0])
