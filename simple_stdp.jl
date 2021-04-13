# simple simulation of STDP in the simplest possible case just to see what the graph looks like

using Plots

function stdp_update(dt, coeff, decay)
    if dt == 0
        return 0
    elseif dt > 0
        return coeff * exp(-dt / decay)
    elseif dt < 0
        return -coeff * exp(dt / decay)
    else
        return -1e6
    end
end
post_t = 25 # half way through
xs = [i for i in -24:25]
stdps = stdp_update.(xs, 1, 5)
plot(xs, stdps,title="Classical STDP", xaxis="delta-t", yaxis="weight change")
savefig("Prototypical_STDP")
