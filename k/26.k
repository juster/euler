p:300 / precision
r:2+!1000-1 / range
c:{[a] *(1)+&a~/:a@{(#a)#!x}'1+!(#a)%2} / count repetition length
dd:{:[(p=#z)|(x=0);z;_f[10*x!y;y;z,x]]}
d:({dd[10;x;!0]}'r)%r / denominators
m:{[t] &/n@n&0<n:c'{x _ t}'!#t}'d
2+&m=|/m
