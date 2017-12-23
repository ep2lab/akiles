%{
Computes the (evz,evr,evtheta) moment of the electron distribution
function at the requested points. 

Trivial cases are forced to be zero. Intermediate variables are stored
as persistent variables to speed up subsequent calls with the same
solution and ipoints. 

INPUT
* data: structure with simulation data
* solution: current solution structure with fields h,phi,ne00p,npoints
* evz,evr,evtheta: indices of the moment to compute
* ipoints: points at which the moment will be computed. Omit or give an
  empty array to compute at all points 

OUTPUT
* moment: total (evz,evr,evtheta) moment at the requested points
* moment1,moment2,moment4: moments for the free, reflected and
  doubly-trapped subpoppulations
%}
function [moment,moment1,moment2,moment4] = moment(data,solution,evz,evr,evtheta,ipoints)

%% Unpack
nintegrationpoints = data.electrons.nintegrationpoints(:);
alpha = data.electrons.alpha;

npoints = solution.npoints; 
h = solution.h(:); % force column
r = solution.r(:);
phi = solution.phi(:);
ne00p = solution.ne00p;

if ~exist('ipoints','var') || isempty(ipoints)
    ipoints = 1:length(solution.h);
end
ipoints = ipoints(:); % force column

nipoints = length(ipoints);
nE_ = sum(nintegrationpoints);

%% Allocate and zero
moment1 = ipoints.*0;
moment2 = moment1;
moment4 = moment1;
moment = moment1;

%% Trivial cases
if mod(evr,2) == 1 || mod(evtheta,2) == 1 
    return;
end

%% Obtain integration points and weights; find limits of Pperp' (see Eq. A13)
% save for future calls with same solution and ipoints
persistent previous_solution previous_ipoints Pperp_limbwd Pperp_limfwd E_
if isempty(previous_solution) || ~isequal(previous_solution,solution) || ~isequal(previous_ipoints,ipoints)   
    Pperp_limbwd = zeros(nipoints,nE_); % allocate
    Pperp_limfwd = Pperp_limbwd;    
    E_ = Pperp_limbwd;
    % prepare E' integration nodes
    for iipoints = 1:nipoints 
        i = ipoints(iipoints); 
        E_transition = 1.5*(phi(i)-phi(end));
        if isinf(phi(end)) || E_transition <= 0
            E_transition = 5;
        end        
        sep = E_transition/(nintegrationpoints(1)-1); % basic separation between linspaced points
        f = 1.05; % grow factor of this separation for the second segment
        E_(iipoints,1:nintegrationpoints(1)) = linspace(0,E_transition,nintegrationpoints(1));
        E_(iipoints,nintegrationpoints(1)+1:nE_) = E_transition + sep*(f.^[1:nintegrationpoints(2)]-1)/(f-1);
        % Compute Pperp' limits        
        if i == npoints % the point is h = infty 
            continue;
        end
        for iE_ = 1:nE_ 
            Pperp_ = (E_(iipoints,iE_) + phi - phi(i))./(h(i)^2 ./h.^2 - 1) - (r(i)^2/h(i)^4);
            Pperp_limbwd(iipoints,iE_) = max(0,min(Pperp_(1:i)));
            Pperp_limfwd(iipoints,iE_) = max(0,max(Pperp_(i+1:npoints))); 
        end
        if i == 1 % the point is h = 1
            Pperp_limbwd(iipoints,1) = Inf;
        end        
    end  
    % Store values in persistent variables for future comparisons
    previous_solution = solution;
    previous_ipoints = ipoints;
end

%% Prepare Integrals
Hijk = @(Pperp_a,Pperp_b) ... % first integral in Pperp'
        max(0,gamma((2+evr+evtheta)/2)*(gammainc(Pperp_b,(2+evr+evtheta)/2) - gammainc(Pperp_a,(2+evr+evtheta)/2)));
dGijk = @(E_a,E_b,Gijka,Gijkb) ... % second integral in E', assuming Gijk varies linearly in each subinterval
       (gamma((1+evz)/2)*(Gijkb.*E_a-Gijka.*E_b).*(gammainc(E_b,(1+evz)/2) - gammainc(E_a,(1+evz)/2)) + ...
        gamma((3+evz)/2)*(Gijka-Gijkb).*(gammainc(E_b,(3+evz)/2) - gammainc(E_a,(3+evz)/2))) ./ (E_a-E_b);

%% Integrate moment (see Eq. A10)
factor = ne00p*2^((evz+evr+evtheta)/2)* ...
         gamma((1+evr)/2)*gamma((1+evtheta)/2)/gamma(1+(evr+evtheta)/2)/pi^(3/2)* ...
         exp(phi(ipoints)-r(ipoints)./h(ipoints).^4);

Hijk1 = Hijk(Pperp_limfwd,Pperp_limbwd);
dGijk1 = dGijk(E_(:,1:nE_-1),E_(:,2:nE_),Hijk1(:,1:nE_-1),Hijk1(:,2:nE_));
moment1 = factor.*(sum(dGijk1,2) + Hijk1(:,nE_).*gamma((1+evz)/2).*gammainc(E_(:,nE_),(1+evz)/2,'upper')); % adds tail to infinity, assuming Gijk1 == Gijk1(end) from the last E' value onward
 
if mod(evz,2) ~= 1    
    Hijk2 = Hijk(0,min(Pperp_limbwd,Pperp_limfwd));
    dGijk2 = dGijk(E_(:,1:nE_-1),E_(:,2:nE_),Hijk2(:,1:nE_-1),Hijk2(:,2:nE_));
    moment2 = 2*factor.*sum(dGijk2,2);    
    Hijk4 = Hijk(Pperp_limbwd,Pperp_limfwd);
    dGijk4 = dGijk(E_(:,1:nE_-1),E_(:,2:nE_),Hijk4(:,1:nE_-1),Hijk4(:,2:nE_));
    moment4 = 2*alpha*factor.*sum(dGijk4,2);
else
    moment2 = moment1.*0;
    moment4 = moment1.*0;
end
moment = moment1 + moment2 + moment4; 
