%{
Postprocesses a converged simulation to compute several moments electrons
and ions, and standard quantities derived from them.

INPUT
* data: structure with simulation data
* solution: converged solution structure

OUTPUT
* solution: updated structure with the moment fields (electrons, ions)
%}
function solution = moments(data,solution)

%% Basic electron moments
[solution.electrons.M000,solution.electrons.M0001,solution.electrons.M0002,solution.electrons.M0004] = ...
    akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,0,0,0); 
[solution.electrons.M100,solution.electrons.M1001,solution.electrons.M1002,solution.electrons.M1004] = ...
    akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,1,0,0); 
[solution.electrons.M200,solution.electrons.M2001,solution.electrons.M2002,solution.electrons.M2004] = ...
    akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,2,0,0); 
[solution.electrons.M020,solution.electrons.M0201,solution.electrons.M0202,solution.electrons.M0204] = ...
    akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,0,2,0); 
[solution.electrons.M002,solution.electrons.M0021,solution.electrons.M0022,solution.electrons.M0024] = ...
    akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,0,0,2); 
[solution.electrons.M300,solution.electrons.M3001,solution.electrons.M3002,solution.electrons.M3004] = ...
    akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,3,0,0); 
[solution.electrons.M120,solution.electrons.M1201,solution.electrons.M1202,solution.electrons.M1204] = ...
    akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,1,2,0); 
[solution.electrons.M102,solution.electrons.M1021,solution.electrons.M1022,solution.electrons.M1024] = ...
    akiles2d.electrons.(data.potential.model).(data.electrons.model).moment(data,solution,1,0,2); 

%% Derived electron quantities
ll = {'','1','2','4'}; % Label for the whole population and each subpopulation

for il = 1:length(ll)
    l = ll{il};
    % Density
    solution.electrons.(['n',l]) = solution.electrons.(['M000',l]);  
    % Axial velocity
    solution.electrons.(['u',l]) = solution.electrons.(['M100',l])./solution.electrons.(['n',l]);  
    % Axial temperature
    solution.electrons.(['Tz',l]) = solution.electrons.(['M200',l])./solution.electrons.(['n',l]) - solution.electrons.(['u',l]).^2;  
    % Radial temperature
    solution.electrons.(['Tr',l]) = solution.electrons.(['M020',l])./solution.electrons.(['n',l]);
    % Azimuthal temperature
    solution.electrons.(['Ttheta',l]) = solution.electrons.(['M002',l])./solution.electrons.(['n',l]);
    % Axial flux of axial heat
    solution.electrons.(['qzz',l]) = 1/2*solution.electrons.(['M300',l]) - 3/2*solution.electrons.(['n',l]).*solution.electrons.(['u',l]).*solution.electrons.(['Tz',l]) - 1/2*solution.electrons.(['n',l]).*solution.electrons.(['u',l]).^3;
    % Axial flux of radial heat
    solution.electrons.(['qzr',l]) = 1/2*solution.electrons.(['M120',l]) - 1/2*solution.electrons.(['n',l]).*solution.electrons.(['u',l]).*solution.electrons.(['Tr',l]);
    % Axial flux of azimuthal heat
    solution.electrons.(['qztheta',l]) = 1/2*solution.electrons.(['M102',l]) - 1/2*solution.electrons.(['n',l]).*solution.electrons.(['u',l]).*solution.electrons.(['Ttheta',l]);
end
   
%% Basic ion moments
[solution.ions.M000,solution.ions.M0001,solution.ions.M0002,solution.ions.M0004] = ...
    akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,0,0,0); 
[solution.ions.M100,solution.ions.M1001,solution.ions.M1002,solution.ions.M1004] = ...
    akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,1,0,0); 
[solution.ions.M200,solution.ions.M2001,solution.ions.M2002,solution.ions.M2004] = ...
    akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,2,0,0); 
[solution.ions.M020,solution.ions.M0201,solution.ions.M0202,solution.ions.M0204] = ...
    akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,0,2,0); 
[solution.ions.M002,solution.ions.M0021,solution.ions.M0022,solution.ions.M0024] = ...
    akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,0,0,2); 
[solution.ions.M300,solution.ions.M3001,solution.ions.M3002,solution.ions.M3004] = ...
    akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,3,0,0); 
[solution.ions.M120,solution.ions.M1201,solution.ions.M1202,solution.ions.M1204] = ...
    akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,1,2,0); 
[solution.ions.M102,solution.ions.M1021,solution.ions.M1022,solution.ions.M1024] = ...
    akiles2d.ions.(data.potential.model).(data.ions.model).moment(data,solution,1,0,2); 

%% Derived ion quantities
ll = {'','1','2','4'}; % Label for the whole population and each subpopulation

for il = 1:length(ll)
    l = ll{il};
    % Density
    solution.ions.(['n',l]) = solution.ions.(['M000',l]);  
    % Axial velocity
    solution.ions.(['u',l]) = solution.ions.(['M100',l])./solution.ions.(['n',l]);  
    % Axial temperature
    solution.ions.(['Tz',l]) = solution.ions.(['M200',l])./solution.ions.(['n',l]) - solution.ions.(['u',l]).^2;  
    % Radial temperature
    solution.ions.(['Tr',l]) = solution.ions.(['M020',l])./solution.ions.(['n',l]);
    % Azimuthal temperature
    solution.ions.(['Ttheta',l]) = solution.ions.(['M002',l])./solution.ions.(['n',l]);
    % Axial flux of axial heat
    solution.ions.(['qzz',l]) = 1/2*solution.ions.(['M300',l]) - 3/2*solution.ions.(['n',l]).*solution.ions.(['u',l]).*solution.ions.(['Tz',l]) - 1/2*solution.ions.(['n',l]).*solution.ions.(['u',l]).^3;
    % Axial flux of radial heat
    solution.ions.(['qzr',l]) = 1/2*solution.ions.(['M120',l]) - 1/2*solution.ions.(['n',l]).*solution.ions.(['u',l]).*solution.ions.(['Tr',l]);
    % Axial flux of azimuthal heat
    solution.ions.(['qztheta',l]) = 1/2*solution.ions.(['M102',l]) - 1/2*solution.ions.(['n',l]).*solution.ions.(['u',l]).*solution.ions.(['Ttheta',l]);
end
   

