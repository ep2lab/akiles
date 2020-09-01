%{
Compendium of all tests for the function/class in the name of this file.

NOTES:
* The functions to be tested must be in the Matlab path. You can run the
  tests by executing 'runtests'. 
* Your working directory must be the
  directory where this test file is contained.  
%}
function tests = test_akiles2d
    clc;
    tests = functiontests(localfunctions);     
end

%----------------------------------------------------------------------
%----------------------------------------------------------------------
%----------------------------------------------------------------------
 
function test_preprocessor_and_default_simrc(~)
    % Call simrc without arguments
    data = akiles2d.simrc; 
    % Call simrc with arguments
    data.test = 'just a test string'; % adding extra, unused fields raises no error
    data = akiles2d.simrc(data);
    % Call preprocessor without arguments
    data = akiles2d.preprocessor.preprocessor;
    % Call preprocessor with a user simrc file
    data = akiles2d.preprocessor.preprocessor(fullfile('fixtures/example_simrc.m'));
    % Call preprocessor with a data structute
    data = akiles2d.preprocessor.preprocessor('fixtures/example_simrc.m',struct('testfield',12345)); % adding extra, unused fields raises no error
end

%----------------------------------------------------------------------

function test_electrons_parabolic_get(~) % all get methods
    % fixture
    h = [3,3.5];
    r = [0.52,0.55];
    phiz = [-0.4,-0.5];
    E = [2,2.1];
    Jr = [1.2,1.1];
    ptheta = [0.1,0.11];
    % getbetar and getr
    [betar] = akiles2d.electrons.parabolic.getbetar(h,r,Jr,ptheta);    
    [rnew] = akiles2d.electrons.parabolic.getr(h,betar,Jr,ptheta);    
    assert(all(abs(r-rnew)<1e-14));
    
    % getmomenta and getvelocities
    [absvz,absvr,absvtheta] = akiles2d.electrons.parabolic.getvelocities(h,r,phiz,E,Jr,ptheta);
    [Enew,Jrnew,pthetanew] = akiles2d.electrons.parabolic.getmomenta(h,r,phiz,absvz,absvr,absvtheta);
    assert(all(abs(E-Enew)<1e-14));
    assert(all(abs(Jr-Jrnew)<1e-14));
    assert(all(abs(ptheta-pthetanew)<1e-14));
end

%----------------------------------------------------------------------

function test_electrons_parabolic_semimaxwellian_moment(~)
    data = akiles2d.preprocessor.preprocessor(fullfile('fixtures/example_simrc.m'));
    solution = data.guess;
    
    ipoints = 3;
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,0,0,0,ipoints);    
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,1,0,0,ipoints); 
    
    ipoints = [1,3];
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,0,0,0,ipoints);    
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,1,0,0,ipoints);    

    ipoints = [];
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,0,0,0,ipoints);    
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,1,0,0,ipoints);    
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,2,0,0,ipoints);   
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,0,2,0,ipoints);   
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,3,0,0,ipoints);   
    [moment,moment1,moment2,moment4] = akiles2d.electrons.parabolic.semimaxwellian.moment(data,solution,1,2,0,ipoints);  
end

%----------------------------------------------------------------------

function test_ions_parabolic_cold_moment(~)
    data = akiles2d.preprocessor.preprocessor(fullfile('fixtures/example_simrc.m'));
    solution = data.guess;
    
    ipoints = 3;
    [moment,moment1,moment2,moment4] = akiles2d.ions.parabolic.cold.moment(data,solution,0,0,0,ipoints);
    [moment,moment1,moment2,moment4] = akiles2d.ions.parabolic.cold.moment(data,solution,1,0,0,ipoints);
    
    ipoints = [1,3,4];
    [moment,moment1,moment2,moment4] = akiles2d.ions.parabolic.cold.moment(data,solution,0,0,0,ipoints);
    [moment,moment1,moment2,moment4] = akiles2d.ions.parabolic.cold.moment(data,solution,1,0,0,ipoints);
    
    ipoints = [];
    [moment,moment1,moment2,moment4] = akiles2d.ions.parabolic.cold.moment(data,solution,0,0,0,ipoints);    
    [moment,moment1,moment2,moment4] = akiles2d.ions.parabolic.cold.moment(data,solution,1,0,0,ipoints);
    [moment,moment1,moment2,moment4] = akiles2d.ions.parabolic.cold.moment(data,solution,2,0,0,ipoints); %#ok<*ASGLU>
end
 
%----------------------------------------------------------------------

function test_errorfcn_and_solver(~)
    data = akiles2d.preprocessor.preprocessor(fullfile('fixtures/example_simrc.m'));
    solution = data.guess; 
    solution.errorfcn = akiles2d.solver.errorfcn(data,solution); 
    solution = akiles2d.solver.solver(data,solution);
end

%----------------------------------------------------------------------

function test_postprocessor_moments(~)
    data = akiles2d.preprocessor.preprocessor(fullfile('fixtures/example_simrc.m'));
    solution = data.guess;  
    solution = akiles2d.postprocessor.moments(data,solution); %#ok<*NASGU>
end

%----------------------------------------------------------------------

function test_akiles(~)
    [data,solution] = akiles2d.akiles2d(fullfile('fixtures/example_simrc.m')); 
end

%----------------------------------------------------------------------

function test_akiles_phiinfty(~)
    [data,solution] = akiles2d.akiles2d(fullfile('fixtures/example_simrc2.m')); 
end