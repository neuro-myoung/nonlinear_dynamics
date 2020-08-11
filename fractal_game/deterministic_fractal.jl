using CSV
using Plots
using StatsPlots
using Random
using DataFrames
using Distances

function target_generate(n, scale) :: Matrix{Float64}
    target = scale * rand(n,2)
    return target
end

target = target_generate(4,1)

function play_game(initialPosition::Array{Float64,1} , target::Array{Float64,2} , iterations::Int64, ε::Float64)

    n::Int64 = size(target)[1]
    points = fill([ 0.0, 0.0 ], sum(n .^ collect(0:1:iterations)))
    points[1] = initialPosition

    for i in 1:iterations
        start = sum(n .^ collect(0:1:i-1))+1
        stop = sum(n .^ collect(0:1:i))
        startprev = sum(n .^ collect(0:1:i-2))+1

        tempprev = points[startprev:start-1,:]
        temp = fill([ 0.0, 0.0 ], stop-start+1)

        counter::Int64=1
            for j in 1:size(target)[1]
                for z in tempprev
                    temp[counter] = z +  ε .* (target[j,:] - z)
                    counter += 1
                end
            end
        points[start:stop,:] = temp
    end

    df::DataFrame = DataFrame(hcat(points...)')
    target = vcat(target, target[1,:]')
    display(target[:,1])
    plotly()
    @df df scatter(:x1, :x2, marker = (:circle, 1), color=:black, size=(800,800), legend=false, title = "Fractal Game Two")
    scatter!(target[:,1], target[:,2], marker = (:circle, 5), color=:red, alpha=0.6)
    plot!(target[:,1], target[:,2], color=:red, alpha=0.6)
end

target = [ 0.2 0.5; 0.35 0.2; 0.65 0.2; 0.8 0.5; 0.65 0.8; 0.35 0.8]


play_game([0.5,0.5], target, 6, 0.8)
