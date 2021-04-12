a = 5
b = 6

using Plots

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

t_rise = 2
series = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
outs = single_exp_kernel(series, t_rise)
plot(outs)

series_pre = zeros(30)
series_post = zeros(30)
series_pre[10] = 1
series_post[20] = 1
pre = single_exp_kernel(series_pre, 10) * 0.3
post = single_exp_kernel(series_post, t_rise)
plot(post .- pre)
plot!(post)
plot!(pre)
plot((post .- pre) .* pre)
