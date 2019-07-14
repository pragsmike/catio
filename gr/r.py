import struct
import scipy as np

with open("energy", 'rb') as f:
    num = np.fromfile(f, dtype=float, count=-1, sep='')
#    (num,) = struct.unpack('f', f.read(4))
    print (num[0])
