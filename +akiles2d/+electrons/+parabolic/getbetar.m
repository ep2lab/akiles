
%{
This function returns betar at a point (h,r), given Jr and ptheta.

INPUT
* h,r: position of the point(s)
* Jr, ptheta: momenta at those point(s)

OUTPUT
* betar: the value of the radial angle coordinate betar at those
  point(s)
%}
function betar = getbetar(h,r,Jr,ptheta)

%% Compute betar
betar = acos((Jr/pi+abs(ptheta) - sqrt(2)*r.^2 ./h.^2)./ ...
         sqrt(Jr/pi.*(Jr/pi+2*abs(ptheta))))/(2*pi);
betar(isnan(betar)) = 0; % For Jr = ptheta = r = 0
