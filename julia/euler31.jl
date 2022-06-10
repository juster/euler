# 1: p
# 2: pp   2p
# 3: ppp  2p+p
# 4: pppp 2p+2p 2p+pp

const coins = [1,2,5,10,20,50,100,200]

# (incorrect)
function rem31(n)
    # coins = [5,10]
    pays = 1
    for i in 2:n
        pays += sum((i .% coins) .== 0)
    end
    pays
end

function dp31(n)
    function dp(pocket)
        # println("DBG ", pocket)
        idx = (pocket.+1)
        if getindex(seen, idx...); return end
        setindex!(seen, 1, idx...)
        p = pocket[1]
        for i in 2:length(pocket)
            c = coins[i]
            if p >= c
                next = copy(pocket)
                next[1] = p - c
                next[i] += 1
                dp(next)
            end
        end
    end

    # extra element for zero
    dims = [1 + n ÷ c for c in coins]
    seen = BitArray(undef, Tuple(dims))
    start = [1; fill(0, length(coins)-1)]
    dp(start)
    sum(seen)
end
