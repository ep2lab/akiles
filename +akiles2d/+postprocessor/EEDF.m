%{
Postprocesses a converged simulation to compute the EEPF at each point.
The EEDF is defined as the function that, if integrated in E from 0 to
infinity, returns the density ne. 

INPUT
* data: structure with simulation data
* solution: converged solution structure

OUTPUT
* solution: updated structure with the new fields electrons.Ek and
  electrons.EEDF.
%}
function solution = EEDF(data,solution)

%% Unpack
nintegrationpoints = data.electrons.nintegrationpoints(:);
alpha = data.electrons.alpha;

npoints = solution.npoints; 
h = solution.h(:); % force column
r = solution.r(:);
phi = solution.phi(:);
ne00p = solution.ne00p;

nEk = sum(nintegrationpoints);

%% Obtain Pperplims
pperplimbwd = zeros(npoints,nEk); % allocate
pperplimfwd = pperplimbwd;    
Ek = pperplimbwd;
for ipoints = 1:npoints 
    E_transition = 1.5*(phi(ipoints)-phi(end));
    if isinf(phi(end)) || E_transition <= 0
        E_transition = 5;
    end        
    sep = E_transition/(nintegrationpoints(1)-1); % basic separation between linspaced points
    f = 1.05; % grow factor of this separation for the second segment
    Ek(ipoints,1:nintegrationpoints(1))     = linspace(0,E_transition,nintegrationpoints(1));
    Ek(ipoints,nintegrationpoints(1)+1:nEk) = E_transition + sep*(f.^[1:nintegrationpoints(2)]-1)/(f-1);
    % Compute Pperp limits        
    if ipoints == npoints % the point is h = infty, so keep zeros 
        continue;
    end
    pperpmin = r(ipoints)^2/(sqrt(2)*h(ipoints)^2);
    for iEk = 1:nEk 
        pperp = (Ek(ipoints,iEk) + phi - phi(ipoints)).*h.^2/sqrt(2);
        pperplimbwd(ipoints,iEk) = max(pperpmin,min(pperp(1:ipoints)));
        pperplimfwd(ipoints,iEk) = max(pperpmin,min(pperp(ipoints:npoints))); 
    end 
end   
 
%% EEPF
H = repmat(h,1,nEk);
PPERP = Ek.*H.^2/sqrt(2);
PPERPMIN = repmat(r.^2 ./ (sqrt(2).*h.^2),1,nEk);
PHI = repmat(phi,1,nEk);
G = @(pperp1,pperp2) 2*ne00p/sqrt(pi) .* exp(PHI) .* exp(-Ek) .* ...
     (sqrt(max(0,Ek-sqrt(2)./H.^2 .*pperp1)) - sqrt(max(0,Ek-sqrt(2)./H.^2 .*pperp2)));

solution.electrons.Ek = Ek;
solution.electrons.EEDF1 = 1*G(PPERPMIN,min(pperplimbwd,pperplimfwd));
solution.electrons.EEDF2 = 2*max(0,G(pperplimfwd,pperplimbwd));
solution.electrons.EEDF4 = (1+alpha)*max(0,G(max(pperplimbwd,pperplimfwd),PPERP));
solution.electrons.EEDF = solution.electrons.EEDF1 + solution.electrons.EEDF2 + solution.electrons.EEDF4;






















