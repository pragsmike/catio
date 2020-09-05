using Makie, AbstractPlotting,Random,Distributions,StatsBase

noise_μ = 0.0
noise_σ = 1.0
noise_a = 0.5

noise_dist = Normal(noise_μ, noise_σ)



numsamps = 1000000
bins = 100
W = 8
s = W*numsamps/bins/noise_a

xrange = range(-W/2,W/2,length=bins)
y = noise_a * rand(noise_dist, numsamps)
h = fit(Histogram, y,  xrange, closed=:left)
scene = plot(h)
lines!(scene, xrange, s*(1/(noise_σ*sqrt(2pi)))*map(x->exp(-0.5*(x/(noise_a*noise_σ))^2),xrange), color=:red)
display(scene)
