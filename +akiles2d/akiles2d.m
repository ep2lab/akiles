%{
This is the main akiles2d function, intended to be run by the user. It
essentially chains together the preprocessor, the iteration procedure, 
and then any postprocessing functions, and takes care of logging and saving to
disk.  

INPUT
* simrcfile: path to user simrc file to overwrite defaults
* userdata: data structure used to (partially) overwrite the data
  structure of the default smrc and the user simrc 

OUTPUT
* data: complete data structure with all the parameters of the problem
* solution: structure with the solution of the simulation 
%}
function [data,solution] = akiles2d(simrcfile,userdata)

%% Code version (must update manually when codebase changes)
VERSION = '20200901';

%% Run data preprocessor to prepare data structure
if ~exist('simrcfile','var')
    simrcfile = [];
end
if ~exist('userdata','var')
    userdata = [];
end
data  = akiles2d.preprocessor.preprocessor(simrcfile,userdata);

%% Create dir and save data
[~,~,~] = mkdir(data.akiles2d.simdir); % [~,~,~] avoids warnings if dir exists 
save(data.akiles2d.datafile,'data');

%% Startup messages
logger.title(['AKILES2D version ',VERSION],10,data.logger);
logger.log(['Simulation directory: ',data.akiles2d.simdir],'INF',5,data.logger);
logger.log(['Structure data saved to ',data.akiles2d.datafile,' successfully.'],'INF',5,data.logger);

%% Initial guess error and save iteration 0
solution = data.guess; % take guess as initial solution
solution.npoints = numel(solution.h);

%% Solver iteration loop
for iiter = 0:data.akiles2d.maxiter
    %% Compute error and Jacobian matrix
    solution.errorfcn = akiles2d.solver.errorfcn(data,solution);
    normerror = norm(solution.errorfcn);

    %% Save current solution to file and log message
    solutionfile = fullfile(data.akiles2d.simdir,[num2str(iiter),'.mat']);
    save(solutionfile,'-struct','solution');
    logger.log(['Iteration ',num2str(iiter),' saved to disk.'],'INF',5,data.logger);
    logger.log(['Error norm: ',num2str(normerror)],'INF',4,data.logger); 
    logger.log('Detailed error vector:','INF',1,data.logger);
    logger.write(num2str(solution.errorfcn),1,data.logger);

    %% Check convergence
    if norm(solution.errorfcn) < data.akiles2d.tolerance
        logger.log(['Convergence reached successfully at iteration ',num2str(iiter),'.'],'INF',5,data.logger);
         solutionfile = fullfile(data.akiles2d.simdir,'final.mat');
         save(solutionfile,'-struct','solution');
         logger.log(['Final iteration saved to ',solutionfile],'INF',5,data.logger);
        break;
    end
    
    %% Compute next solution
    solution = akiles2d.solver.solver(data,solution);
end

%% Warn if maximum number of iterations was reached after the loop
if iiter == data.akiles2d.maxiter
    logger.log('Maximum number of iterations was reached!','WRN',8,data.logger);
end

%% Run postprocessor functions and save
postfunctions = data.postprocessor.postfunctions;
for ifn = 1:length(postfunctions)
    logger.log(['Running postprocessor function: ',postfunctions{ifn}],'INF',5,data.logger);        
    solution = akiles2d.postprocessor.(postfunctions{ifn})(data,solution);
end
solutionfile = fullfile(data.akiles2d.simdir,'post.mat');
save(solutionfile,'-struct','solution');    
logger.log(['Solution saved to ',solutionfile],'INF',5,data.logger);

%% Farewell
logger.title('AKILES2D execution finished.',10,data.logger);










