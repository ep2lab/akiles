%{
Computes the (evz,evr,evtheta) moment of the ion distribution function
at the requested points, which must be at the plume axis.  

This is a simple paraxial, cold ion model, where the axial ion velocity
uzi follows energy conservation and density decays as 1/(uz*h^2).  
All other ion moments are zero

INPUT
* data: structure with simulation data
* solution: current solution structure with fields h,phi
* evz,evr,evtheta: indices of the moment to compute
* ipoints: points at which the moment will be computed. Omit or give an
  empty array to compute at all points 

OUTPUT
* moment: total (evz,evr,evtheta) moment at the requested points
* moment1,moment2,moment4: moments for the free, reflected and
  doubly-trapped subpoppulations (there are only free in this case)
%}
function [moment,moment1,moment2,moment4] = moment(data,solution,evz,evr,evtheta,ipoints)

%% Unpack
chi = data.ions.chi; % dimensionless ion axial velocity at the origin
mu = data.ions.mu; % dimensionless ion mass

h = solution.h(:);
r = solution.r(:);
phi = solution.phi(:);

if ~exist('ipoints','var') || isempty(ipoints) % An empty ipoints means all points
    ipoints = 1:length(h);
end
ipoints = ipoints(:); % force column

%% Allocate
moment = ipoints.*0;
moment1 = moment;
moment2 = moment;
moment4 = moment;

%% Throw error if r ~= 0
if any(r(ipoints)~=0)
    error('Error: akiles2d.ions.parabolic.cold.moment cannot currently compute moments at points not on the plume axis')
end

%% Compute moment 
uz = sqrt(chi^2-(2/mu^2)*phi(ipoints)); % ion velocity
ni = chi./(uz.*h(ipoints).^2);

if evr == 0 && evtheta == 0 
    moment = ni.*uz.^evz; 
end
moment1 = moment; % all ions are free


