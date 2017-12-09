%{
This function returns |vz|, |vr|, |vtheta| at a point (h,r), given phiz,
E, Jr and ptheta. 

INPUT
* h: effective plume radius at the axial position of the point(s)
* r: radius of the point(s)
* phiz: potential at the axis at those point(s)
* E, Jr, ptheta: mechanical energy and momenta at those point(s)

OUTPUT
* absvz,absvr,absvtheta: absolute value of the velocities
%} 
function [absvz,absvr,absvtheta] = getvelocities(h,r,phiz,E,Jr,ptheta)

%% Compute velocities
% Axial velocity |vz|
temp = sqrt(2)*(Jr/pi+abs(ptheta))./h.^2;
absvz = sqrt((E+phiz-temp)*2);

% Azimuthal velocity |vtheta| (definition of ptheta)
absvtheta = abs(ptheta./r);
absvtheta(isnan(absvtheta)) = 0; % vtheta = 0 always at the axis

% Radial velocity |vr|
absvr = sqrt((temp - (r.^2)./h.^4)*2 - absvtheta.^2);
