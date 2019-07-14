#!/usr/bin/env python

from gnuradio import filter
import scipy
import matplotlib.pyplot as plt

M = 4
lpf = filter.firdes.low_pass_2(1, 1, 0.05, 0.05, 60)
ch = filter.pfb.channelizer_ccf(M, lpf, 1)

t = ch.pfb.taps()
tpc = len(t[0])

print "Prototype Taps: ", len(lpf)
print "Taps / Channel: ", tpc
print scipy.pi/M

x  = scipy.arange(0, M*tpc, 1)
x0 = scipy.arange(0, M*tpc, M)
x1 = scipy.arange(1, M*tpc, M)
x2 = scipy.arange(2, M*tpc, M)
x3 = scipy.arange(3, M*tpc, M)

pad = M - len(lpf)%M
lpf = list(lpf) + pad*[0,]

fig = plt.figure(1, figsize=(16,6), facecolor='w')
sp1 = fig.add_subplot(1,2,1)
sp1.plot(x, lpf, 'k-o', linewidth=1, markersize=10)
sp1.grid()
sp1.set_xlim([0, max(x)])
sp1.set_ylim([-0.02, 0.11])
sp1.set_xlabel("Tap Number", fontsize=18, fontweight="bold")

sp2 = fig.add_subplot(1,2,2)
sp2.plot(x, lpf, 'k-', linewidth=1)
sp2.plot(x0, t[0], 'o', markersize=10, label="Channel 0")
sp2.plot(x1, t[1], 's', markersize=10, label="Channel 1")
sp2.plot(x2, t[2], '^', markersize=10, label="Channel 2")
sp2.plot(x3, t[3], '>', markersize=10, label="Channel 3")
sp2.legend()
sp2.grid()
sp2.set_xlim([0, max(x3)])
sp2.set_ylim([-0.02, 0.11])
sp2.set_xlabel("Tap Number", fontsize=18, fontweight="bold")

plt.tight_layout()
fig.savefig("filter_phase.png", dpi=300, format="png")
plt.show()


