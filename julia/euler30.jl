module euler30

function max_digits(p)
    n = 1
    while 10^n - 1 < n * 9^p
        n += 1
    end
    n - 1
end

function brute(p)
    n = max_digits(p)
    println("Max possible digits: ", n)
    max = evalpoly(10, fill(9, n))
    s = []
    y = (0:9) .^ p # precompute exponents
    # TODO: calc the lower bound too?
    for i in 2:max
        x = sum(y[1 .+ digits(i)])
        if i == x
            println(x)
            push!(s, x)
        end
    end
    println("="^n)
    println(sum(s))
end

end
