using Plots
using Distributions

function bernoulli_spikes(N, p)
    outs = zeros(N)
    for i in 1:N
        r = rand()
        if r <= p
            outs[i] = 1
        end
    end
    return outs
end

function LIF_neuron(input, weight, thresh, neg_boundary, pos_decay, neg_decay)
    U = 0
    Us = zeros(length(input))
    output_spikes = zeros(length(input))
    for i in 1:length(input)
        if U < 0
            U += -(U / neg_decay) + (weight * input[i]) # not sure this works
        end
        if U >= 0
            U += -(U / pos_decay) + weight * input[i]
            if U >= thresh
                U = neg_boundary
                output_spikes[i] = 1
                input[i+1:end] = bernoulli_spikes(length(input) - i,0.4) * 0.3
            end
        end

        Us[i] = U
    end
    return Us, output_spikes
end

weight = 1
thresh = 3.5
neg_boundary = -2
pos_decay = 4
neg_decay = 8

input_spikes = zeros(50)
input_spikes[1:20] = bernoulli_spikes(20,0.4) * 0.3#rand(Normal(1, 0.2), 20)
input_spikes[21:30] = ones(10) * 1
input_spikes[31:50] = bernoulli_spikes(20,0.4) * 0.3
plot(input_spikes)
Us, output_spikes = LIF_neuron(input_spikes, weight,thresh,neg_boundary,pos_decay,neg_decay)
plot(Us)
plot(Us .- 3)
plot(output_spikes)

# okay, let's get a proper graph for this
output_idx = findmax(output_spikes)[2]
xs = [(i+1) for i in -output_idx:49-output_idx]

plot(xs, Us, xaxis="dt", yaxis="weight change",title="Membrane potential weight change",label="dw for given dt")
savefig("membrane_potential")
