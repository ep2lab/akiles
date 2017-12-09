%{
Takes a simulation data structure and current solution, and computes the
quasineutrality error at the axis and the electric current error (at the
origin).

The electric current error is multiplied by the number of points to keep a
comparable weight with respect to the quasineutrality error.

INPUT
* data: structure with simulation data
* solution: structure with current solution
* ierr: indices of the error vector wanted. Omit or empty for all indices

OUTPUT
* errorfcn: first (n-1) components: quasineutrality error at all points except
  at infinity (last point). Last (n) component: error due to electric current.  
%}
function errorfcn = errorfcn(data,solution,ierr)

%% Unpack
npoints = solution.npoints;

%% Indices
if ~exist('ierr','var')
    ierr = 1:npoints;
end

%% Quasineutrality error
ne = akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,0,0,0,ierr); 
ni  = akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,0,0,0,ierr);
errorfcn = 1-ne./ni;  

%% Electric current error
infinity = (ierr==npoints);
if any(infinity)
    jze = akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,1,0,0,1);
    jzi = akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,1,0,0,1);
    errorfcn(infinity) = jzi-jze-data.akiles2d.netcurrent; % (weighted) current-free error at origin
end 