using Plots
using Statistics

function single_exp_kernel(series, t_rise)
    int_1 = 0
    int_1s = zeros(length(series))
    for (i,el) in enumerate(series)
        int_1 += -(int_1 / t_rise) + el
        int_1s[i] = int_1
    end
    return int_1s
end
function double_exp_kernel(series, t_rise, t_decay)
    int_1 = 0
    int_2 = 0
    int_1s = []
    int_2s = []
    for el in series
        int_1 += -(int_1 / t_rise) + el
        int_2 += (int_1 - int_2) / t_decay
        push!(int_1s, int_1)
        push!(int_2s, int_2)
    end
    return int_2, int_1s, int_2s
end

function get_dw(dt, pre_decay, post_decay, weight)
    series_pre = zeros(50)
    series_post = zeros(50)
    series_pre[25 + dt] = 1
    series_post[25] = 1
    pre = single_exp_kernel(series_pre, pre_decay) * weight
    post = single_exp_kernel(series_post, post_decay)
    #plot(post .- pre)
    #plot!(post)
    #plot!(pre)
    dw = (post .- pre) .* pre
    return dw, pre, post
end

dws = []
pes = []
dts = [i for i in -49:49]
pre_decay = 2
post_decay = 5
scale_factor=0.5
for dt in dts
    dw, pre, post = get_dw(dt,pre_decay,post_decay,scale_factor)
    push!(dws, mean(dw))
    push!(pes,mean(post .- pre))
end
plot(dts,dws)
plot(pes)

xs = [i for i in -49:50]
dw, pre, post = get_dw(2,8,4,1)
plot(xs,post .- pre,title="Spike prediction error for +2dt (pre after post)",xaxis="delta-t", yaxis="Value",label="Prediction Error")
plot!(xs,pre, label="presynaptic potential")
savefig("postsynaptic_first_prediction_error")
plot((post .- pre) .* pre,title="Actual weight change (multiply with presynaptic potential)",xaxis="dt", yaxis="weight change")
savefig("postsynaptic_first_weight_change")

dw, pre, post = get_dw(-2,8,4,1)
plot(xs,post .- pre,title="Spike prediction error for +2dt (pre after post)",xaxis="delta-t", yaxis="Value",label="Prediction Error")
plot!(xs,pre, label="presynaptic potential")
savefig("presynaptic_first_prediction_error")
plot((post .- pre) .* pre,title="Actual weight change (multiply with presynaptic potential)",xaxis="dt", yaxis="weight change")
savefig("presynaptic_first_weight_change")
