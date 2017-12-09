%{
This function returns the mechanical energy E, and the momenta Jr,
ptheta from velocity variables at points (h,r).

INPUT
* h: effective plume radius at the axial position of the point(s)
* r: radius of the point(s)
* phiz: potential at the axis at those point(s)
* vz,vr,vtheta: velocity components at those point(s)

OUTPUT
* E, Jr, ptheta: mechanical energy and momenta at those point(s)
%}
function [E,Jr,ptheta] = getmomenta(h,r,phiz,vz,vr,vtheta)

%% Compute energies and momenta
% Definition of |ptheta| 
ptheta = abs(r.*vtheta);

% Energy
E = (vz.^2+vr.^2+vtheta.^2)/2 - phiz + r.^2 ./h.^4;

% Jr
Jr = (sqrt(1/2)*(E+phiz-vz.^2/2).*h.^2 - abs(ptheta))*pi;
 
