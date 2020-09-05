using Makie, AbstractPlotting,Random,Distributions,StatsBase,SpecialFunctions

noise_μ = 0.0
noise_σ = 1.0
noise_a = .2

noise_dist = Normal(noise_μ, noise_σ)

#Random.seed!(0)

function gen()
    return rand(0:1)
end

function channel(v)
    return v + noise_a * rand(noise_dist)
end

function decide(v)
    if (v < 0.5)
        return 0
    else
        return 1
    end
end

bitcount = 0
errors = 0

function one()
    g = gen()
    r = channel(g)
    d = decide(r)

    if (d != g)
        global errors += 1
    end
    global bitcount += 1
end

function Erfc(x)
    0.5 * erfc(x/sqrt(2))
end

function main()
    global bitcount = 0
    global errors = 0
    for i in 1:1000000
        one()
    end

    chanErrProb = Erfc(0.5/(noise_σ*noise_a))

    μ = bitcount*chanErrProb
    σ = sqrt(μ*(1-chanErrProb))
    dev = (errors - μ)/σ
    xp = string(μ,  " ± ", σ)
    println("error prob ", chanErrProb)
    println("Expected errors ", xp)
    println("Bits ", bitcount, " Errors ", errors, " BER ", errors/bitcount)
    println("Deviance ", dev)
end

function g(μ,σ, x)
    (1/(noise_σ*sqrt(2pi)))*exp(-0.5*(x/noise_σ)^2)
end

numsamps = 1000000
bins = 1000
W = 3
s = 0.5*W*numsamps/(bins*noise_a)

xrange = range(-W/2,W/2,length=bins)
y = map(x -> channel(gen()), 1:numsamps)
#y = rand(noise_dist, numsamps)
h = fit(Histogram, y,  xrange, closed=:left)
scene = plot(h)

lines!(scene, xrange, s*(1/(noise_σ*sqrt(2pi)))*map(x->exp(-0.5*(x/(noise_a*noise_σ))^2),xrange), color=:red)
lines!(scene, xrange, s*(1/(noise_σ*sqrt(2pi)))*map(x->exp(-0.5*((x-1)/(noise_a*noise_σ))^2),xrange), color=:green)

display(scene)
main()
