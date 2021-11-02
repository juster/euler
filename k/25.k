c:{:[|/x>9;_f (x!10)+0,-1_ x%10;x]}
e25:{a:b:1,&1000;i:2; while[b[999]=0;a:b;b:c[a+b];i+:1]; i}
e25[`]

/ or without while
c:{:[|/x>9;_f (x!10)+0,-1_ x%10;x]}
n:1000;i:2; {0=*|x[1]} {i+:1;{c[x+y]}\|x}/ (2,n)#0=!n; i

/ old golf entry
xx: 1+til 100;
uc:{[x;y] tO:last[x]+y;aO:tO mod 10;bO:`int$(tO-aO) % 10;(-1_x),aO,bO}/[enlist 0;];
plus:{[x;y] mO:max count @/:(x;y) ;m:uc (x,(mO-count x)#0)
    + (y,(mO-count y)#0);?[0=last m ;-1_m;m]};
count {[x] a:-2#x; x,enlist plus[a 0; a 1]}/[{[x] 1000>count last x};(enlist 1;enlist 1)]
