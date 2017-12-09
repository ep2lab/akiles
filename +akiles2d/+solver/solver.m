%{
Performs a point-by-point sweep of the solution points to correct ne00p 
and phi. Intended to be used inside a loop like in the akiles2d main 
script.

Standard for errorfcn is:
* The first (nh-1) components: quasineutrality error at all points except
  at infinity (last point).
* Last (n) component: error due to electric current.
 
INPUT:
* data: structure with simulation data (not used)
* solution: structure with current solution and errorfcn

OUTPUT:
* solution: updated solution structure
%}
function solution = solver(data,solution)

%% Unpack
phibracket = data.solver.phibracket;

%% New ne00p
solution.ne00p = solution.ne00p - solution.errorfcn(1)/(solution.errorfcn(1)-1)*solution.ne00p;
 
for i = length(solution.phi):-1:2
    solution.phi(i) = fzero(@(phii)adapted_errorfcn(data,solution,phii,i),phibracket); 
end

%% Compute new error
solution.errorfcn = akiles2d.solver.errorfcn(data,solution);        

end

%----------------------------------------------------------------------
%----------------------------------------------------------------------
%----------------------------------------------------------------------

function err = adapted_errorfcn(data,solution,phii,i) % auxiliary function used by fzero
    solution.phi(i) = phii;
    err = akiles2d.solver.errorfcn(data,solution,i);
end