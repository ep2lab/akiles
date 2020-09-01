%{
Creates default data structure containing the parameters of the problem.
Called by main before running user simrc file. You may take this file
as a reference list of defaults and as a template that you can copy to
create your own user simrc files. 

INPUT AND OUTPUT
* data: parameter structure (optional as input; can be initially empty). 
%} 
function data = simrc(data)

%% General
data.akiles2d.simdir = fullfile(pwd,'sims'); % directory where simulation files will be saved
data.akiles2d.maxiter = 200; % maximum number of iterations to try
data.akiles2d.tolerance = 1e-6; % norm of errorfcn must be this small to exit solver successfully 

%% Logger 
data.logger.filedebuglevel = 3; % file debug level. A higher number prints less messages
data.logger.screendebuglevel = 3; % screen debug level. A higher number prints less messages
data.logger.linelength = 80; % maximum line length in the logs

%% Potential
data.potential.model = 'parabolic'; % the electric field model 

%% Ions
data.ions.model = 'cold'; % the ion model to use
data.ions.chi = 0.02; % dimensionless ion axial velocity at the origin (also current)
data.ions.mu = Inf; % dimensionless ion mass. Set to Inf for hypersonic limit

%% Electrons 
data.electrons.model = 'semimaxwellian'; % the electron model to use
data.electrons.nintegrationpoints = [500,300]; % Number of points to use in E' integration. The first number is for E' less than the transition value (linspaced points). The second is for E' larger than that (logspaced points).
data.electrons.alpha = 1; % filling parameter for doubly-trapped regions
 
%% Initial guess
    npoints = 500; % number of points in the solution vector. First point must be origin. Last point must be infinity.
%Can load guess from file, e.g. data.guess = load(fullfile('simulations/some_guess_file.mat'))
data.guess.h = [linspace(1,5,npoints-1),Inf].'; % column; independent variable: plume characteristic radius at each test point. The first value must be 1; the final value must be infinity
data.guess.r = zeros(1,npoints).'; % column; corresponding values of the radius for each test point
data.guess.phi = linspace(0,-4,npoints).'; % column; potential at each test point. Must be 0 at origin
data.guess.ne00p = 0.51; % density of the (vz > 0) electrons at the origin
 
%% Solver
data.solver.phibracket = [-10,0.1]; % allowed range to search for phi at each point
data.solver.errorfcn = 'netcurrent'; % type of additional error to consider: 'netcurrent, 'phiinfty'
    data.solver.netcurrent = 0; % net electric current density in the plume to solve for, , when errorfcn above is 'netcurrent'
    data.solver.phiinfty = -4; % value of phi at infinity to solve for, when errorfcn above is 'phiinfty'

%% Postprocessor
data.postprocessor.postfunctions = {'moments','EEDF'}; % Cell array with the names of postprocessor functions to run after iteration process
