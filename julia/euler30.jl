module euler30

function brute(p)
    max = 1
    # bot = p*log10(9)+1
    # while max - log10(max) < bot max += 1 end
    while 10^(max-1) < max*9^p
        max += 1
    end
    println("Max possible digits: ", max-1)
    n = 2:10^max-1
    s = [sum(d^p for d=digits(i)) for i=n]
    s = n[n .== s]
    println.(s)
    println("="^max)
    println(sum(s))
end

end
