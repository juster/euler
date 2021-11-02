n:10;i:_1e6
a:!\i,b:|1_*/'1+!:'1+!n-1
j:a%'b,1

/ each row of matrix (y>=0) is every index other than y, then y
m:1!'>:'(n,n)#1,&n
o:@\(,!n),m[j] / offsets change after each picked digit
,/$o@'j,0

/ using a function
p:{(y#x),(y+1)_ x} / (p)ick off
(p\(,!n),j)@'j,0

/ this was too good to be true and so does not work
/ ur:|\'(n,n)#1,&n
/ k:+\(,!n),ur[j]
/ k@'j,0
