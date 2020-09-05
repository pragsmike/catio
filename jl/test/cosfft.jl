using Colors,FFTW
using AbstractPlotting

N = 64

s1 = slider(1:N, raw = true, camera = campixel!, start = 4)

x = range(0, stop = 2pi*(N-1)/N, length = N)
ω₀ = s1[end][:value]

y = lift(ω₀ -> cos.(ω₀*x), ω₀)

fd = scatter(range(0,stop=N-1,length=N),
             lift(q -> abs.(fftshift(fft(q))), y))
td = scatter(x, lift(x->x, y))

scene = hbox(s1, fd, td)

display(scene)
