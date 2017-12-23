%{
Returns the analytical ne00p and phiinfty assuming there are no
intermediate barriers, from the current-free and quasineutrality
condition at the upstream boundary condition

INPUT
* chi: dimensionless electron current in the plume

OUTPUT
* ne00p: the density of the right-going electrons at the upstream
  boundary condition
* phiinfty: asymptotic electric potential downstream
%}
function [ne00p,phiinfty] = ne00p_phiinfty_nobarriers(chi)
 
%% Quasineutrality equation
eq1 = @(phiinfty) 1+ erf(sqrt(-phiinfty))-sqrt((-2*phiinfty)/pi).*exp(phiinfty);

%% Current-free equation
eq2 = @(phiinfty) sqrt(2/pi).*(1-phiinfty).*exp(phiinfty)/chi;

%% Solve for phiinfty and compute ne00p
phiinfty = fzero(@(phiinfty) eq1(phiinfty)-eq2(phiinfty),-5);
ne00p = 1/eq2(phiinfty);
