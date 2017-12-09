%{
This function returns r for a given h, betar, Jr and ptheta. It is the
inverse function of getbetar

INPUT
* h: effective plume radius at the axial position of the point(s)
* betar: radial angle coordinate at those point(s)
* Jr, ptheta: momenta at those point(s)

OUTPUT
* r: radius of the point(s)
%}
function r = getr(h,betar,Jr,ptheta)

%% Compute r
r = sqrt((h.^2 ./sqrt(2)).* ...
    (Jr/pi+abs(ptheta)-cos(2*pi*betar).*sqrt(Jr/pi.*(Jr/pi+2*abs(ptheta)))));
