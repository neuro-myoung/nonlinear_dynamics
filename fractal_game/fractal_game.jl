using CSV
using Plots
using StatsPlots
using Random
using DataFrames

function target_input(name) :: Matrix{Float64}
    target = CSV.read(name * ".csv", header=false , delim=',')
    return target
end

function target_generate(n, scale) :: Matrix{Float64}
    target = scale * rand(n,2)
    return target
end

function generate_points(initialPosition, target, iterations, ε) :: DataFrame
    targetIndex = rand(1:size(target)[1], iterations-1)
    positions = zeros(iterations,2) :: Matrix{Float64}
    positions[1,:] = initialPosition

    for i in 2:iterations
        nextTarget = target[targetIndex[i-1],:]
        positions[i,:] = positions[i-1,:] +  ε * (nextTarget - positions[i-1,:])
    end

    return positions

end

function play_game(initialPosition, target, iterations, ε)

    nPoints = size(target)[1]
    target = vcat(target, target[1,:]')

    display("Generated $nPoints random target points scaled by $scale with fraction $ε.")

    game = generate_points(initialPosition, target , iterations, ε)

    plotly()
    @df game scatter(:x1, :x2, marker = (:circle, 1), color=:black, size=(800,800), legend=false, title = "Fractal Game Base")
    scatter!(target[:,1], target[:,2], marker = (:circle, 5), color=:red, alpha=0.6)
    plot!(target[:,1], target[:,2], color=:red, alpha=0.6)

end
