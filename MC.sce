clear;
clc;

rand("seed", 1234512345);

// check if an origin is within a tetrahedron
// http://steve.hollasch.net/cgindex/geometry/ptintet.html
function [res] = originInside(pt1, pt2, pt3, pt4)

    x = 0.; y = 0.; z = 0.; // origin

    x1 = pt1(1);  y1 = pt1(2);  z1 = pt1(3);
    x2 = pt2(1);  y2 = pt2(2);  z2 = pt2(3);
    x3 = pt3(1);  y3 = pt3(2);  z3 = pt3(3);
    x4 = pt4(1);  y4 = pt4(2);  z4 = pt4(3);

    eps = 1.e-5;
    res = %F;

    s0 = sign(det([x1 y1 z1 1; x2 y2 z2 1; x3 y3 z3 1; x4 y4 z4 1]));
    s1 = sign(det([x  y  z  1; x2 y2 z2 1; x3 y3 z3 1; x4 y4 z4 1]));
    if (abs(s0 - s1) > eps) then
        return;
    end

    s2 = sign(det([x1 y1 z1 1; x  y  z  1; x3 y3 z3 1; x4 y4 z4 1]));
    if (abs(s1 - s2) > eps) then
        return;
    end

    s3 = sign(det([x1 y1 z1 1; x2 y2 z2 1; x  y  z  1; x4 y4 z4 1]));
    if (abs(s2 - s3) > eps) then
        return;
    end

    s4 = sign(det([x1 y1 z1 1; x2 y2 z2 1; x3 y3 z3 1; x  y  z  1]));
    if (abs(s3 - s4) > eps) then
        return;
    end

    res = %T;

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

M = 0.; P = 0.;

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

// ~ 1/8
P
