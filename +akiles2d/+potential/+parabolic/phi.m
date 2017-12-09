%{
Computes phi in the parabolic potential case.

INPUT
* h: effective plume radius at the axial position of the point(s)
* r: radius of the point(s)
* phiz: potential at the axis at those point(s)

OUTPUT
* phi: potential at the requested points
%}
function phi = phi(h,r,phiz)
 
%% Compute phi
phi = - r.^2 ./ h.^4 + phiz;