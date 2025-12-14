%test add corner
load lippedc_test

e1=14;
e2=15;
r=0.5;
nArc=8;
[node, elem] = add_corner(node, elem, e1, e2, r, nArc)

save lippedc2_test