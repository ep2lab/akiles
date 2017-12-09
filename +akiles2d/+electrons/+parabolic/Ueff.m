%{
Effective potential for the electron axial motion in the parabolic case.

INPUT
* h: effective plume radius at the axial position of the point(s)
* phiz: potential at the axis at those point(s)
* Jr, ptheta: momenta at those point(s)

OUTPUT
* phi: potential at the requested points
%}
function Ueff = Ueff(h,phiz,Jr,ptheta)
 
%% Compute Ueff
Ueff = - phiz + sqrt(2)*(Jr/pi+abs(ptheta))./h;