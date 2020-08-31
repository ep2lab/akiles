%{
This is an example user simrc, which partially overwrittes the settings
of the default simrc file when running the preprocessor

INPUT AND OUTPUT
* data: structure (optional as input; can be initially empty).
  Parameters will be added to it by running this function. 
%} 
function data = example_simrc2(data)

%% General
data.akiles2d.simdir = tempname; % directory where simulation files will be saved

%% Initial guess
    npoints = 500; % number of points in the solution vector. First point must be origin. Last point must be infinity.
%Can load guess from file, e.g. data.guess = load(fullfile('simulations/some_guess_file.mat'))
data.guess.h = [linspace(1,500,npoints-1),Inf].'; % column; independent variable: plume characteristic radius at each test point. The first value must be 1; the final value must be infinity
data.guess.r = zeros(1,npoints).'; % column; corresponding values of the radius for each test point
data.guess.phi = linspace(0,-8,npoints).'; % column; potential at each test point. Must be 0 at origin
data.guess.ne00p = 0.51; % density of the (vz > 0) electrons at the origin
 
%% Solver
data.solver.phibracket = [-10,0.1]; % allowed range to search for phi at each point
data.solver.errorfcn = 'phiinfty'; % type of additional error to consider: 'netcurrent, 'phiinfty'
    data.solver.netcurrent = 0; % net electric current density in the plume to solve for, , when errorfcn above is 'netcurrent'
    data.solver.phiinfty = -6; % value of phi at infinity to solve for, when errorfcn above is 'phiinfty'