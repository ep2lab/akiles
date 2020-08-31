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
data.guess = load(fullfile('fixtures/example_guessfile.mat')); % path to file where initial guesses for h,phiz,?? are stored. If empty, default preprocessor values will be used. 

%% Solver
data.solver.phibracket = [-10,0.1]; % allowed range to search for phi at each point
data.solver.errorfcn = 'phiinfty'; % type of additional error to consider: 'netcurrent, 'phiinfty'
    data.solver.netcurrent = 0; % net electric current density in the plume to solve for, , when errorfcn above is 'netcurrent'
    data.solver.phiinfty = -4; % value of phi at infinity to solve for, when errorfcn above is 'phiinfty'