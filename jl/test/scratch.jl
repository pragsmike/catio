using Makie
using AbstractPlotting

sl = slider(1:5, raw = true, camera = campixel!, start = 1)

mutable struct Account
    balance::Float32
    interest::Float32
    deposit::Float32
end

accounts = [
    Account(410000, .06, 7000),
    Account(200000, .02, 0),
    Account(360000, .06, 0),
    Account(30000, .06, 36000)
]
total = Account(0,0,0)

now = Node(0)

function world(t)
    push!(map(a->a.balance, accounts), total.balance)
end

function init()
    for a in accounts
        total.balance += a.balance
    end
    now[] = 0
end
function evolve()
    total.balance = 0
    for a in accounts
        a.balance *= (1+a.interest)
        a.balance += a.deposit
        total.balance += a.balance
    end
    now[] += 1
end

b = barplot(lift(world, now))
xlims!(b, (1,7))
ylims!(b, (0,2e6))

scene = hbox(sl, b)
init()
display(scene)
