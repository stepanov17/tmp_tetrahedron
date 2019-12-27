clear;
clc;

rand("seed", 1234512345);

// check if an origin is within a tetrahedron
// http://steve.hollasch.net/cgindex/geometry/ptintet.html
function [res] = originInside(pt1, pt2, pt3, pt4)

    x = 0.; y = 0.; z = 0.; // origin

    x1 = pt1(1);
    y1 = pt1(2);
    z1 = pt1(3);

    x2 = pt2(1);
    y2 = pt2(2);
    z2 = pt2(3);

    x3 = pt3(1);
    y3 = pt3(2);
    z3 = pt3(3);

    x4 = pt4(1);
    y4 = pt4(2);
    z4 = pt4(3);

    d0 = det([x1 y1 z1 1; x2 y2 z2 1; x3 y3 z3 1; x4 y4 z4 1]);
    d1 = det([x  y  z  1; x2 y2 z2 1; x3 y3 z3 1; x4 y4 z4 1]);
    d2 = det([x1 y1 z1 1; x  y  z  1; x3 y3 z3 1; x4 y4 z4 1]);
    d3 = det([x1 y1 z1 1; x2 y2 z2 1; x  y  z  1; x4 y4 z4 1]);
    d4 = det([x1 y1 z1 1; x2 y2 z2 1; x3 y3 z3 1; x  y  z  1]);

    s0 = sign(d0);
    s1 = sign(d1);
    s2 = sign(d2);
    s3 = sign(d3);
    s4 = sign(d4);

    eps = 1.e-5;

    chk1 = (abs(s0 - s1) < eps);
    chk2 = (abs(s1 - s2) < eps);
    chk3 = (abs(s2 - s3) < eps);
    chk4 = (abs(s3 - s4) < eps);

    res = chk1 & chk2 & chk3 & chk4;

endfunction

// uniform distribution on a unit sphere [Muller 1959, Marsaglia 1972] - ??
// http://mathworld.wolfram.com/SpherePointPicking.html
function [res] = unifOnSphere()

    res = rand(1, 3, "normal");
    res = res / norm(res);

endfunction

////////////////////////////////////////////////////////////////////////////////
// Monte Carlo trials

N = 1.e6; // N of trials

M = 0.;

for i = 1 : N

    pt1 = unifOnSphere();
    pt2 = unifOnSphere();
    pt3 = unifOnSphere();
    pt4 = unifOnSphere();
    if originInside(pt1, pt2, pt3, pt4) then
        M = M + 1;
        P = M / i;
    end
    if (modulo(i, 1000) == 0) then
        printf("\t%d trials, P ~ %.3f\n", i, P);
    end
end
