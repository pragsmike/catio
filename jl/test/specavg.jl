using Catio


@testset "moving average sanity checks" begin
    num_bins = 2048
    history_size = 100
    magbins = ones(Float32, num_bins)

    ma = newMA(num_bins, history_size)
    add!(ma, magbins)

    @test Catio.get(ma) ≈ fill(0.01, num_bins)
    @test ma.accum ≈ fill(1.0, num_bins)
    @test ma.history_i == 2

    add!(ma, magbins)

    @test Catio.get(ma) ≈ fill(0.02, num_bins)
    @test ma.accum ≈ fill(2.0, num_bins)
    @test ma.history_i == 3

    for i in 1:200
        add!(ma, magbins)
    end
    @test ma.history[1,:] ≈ fill(1.0, history_size)
    @test ma.accum ≈ fill(100.0, num_bins)
    @test ma.history_i == 3

    @test Catio.get(ma) ≈ fill(1.0, num_bins)

end

