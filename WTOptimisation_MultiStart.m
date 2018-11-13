function [x_Final] = WTOptimisation_MultiStart()
% This function runs the turbine blade optimiser using a multistart loop
% and the fmincon optimiser function in an attempt to avoide falling into
% local minima

addpath('Lib'); %Add Lib folder to path to enable functions within that folder to be used in this function
%4: OPTIMISATION - use fminsearchbnd to optimise theta0, thetatw, and cgrad for
%maximum AEP.
    % Initial, Lb & Ub are both arrays of 3 numbers with Initial being the
    % initial guesses for Theta0, ThetaTwist and ChordGrad. Lb are the
    % lower bounds for the optimisation and Ub is the upper bounds.
    % An example input would be WTOptimisation([0.209 -0.00698 0],[0 -0.01 -0.5],[0.4 0 0.5])
rng default % For reproducibility
opts = optimoptions(@fmincon,'Algorithm','sqp', 'Display', 'iter');
problem = createOptimProblem('fmincon','objective',...
    @DiffCost,'x0',[deg2rad(2.5) deg2rad(-1) 0],'lb',[deg2rad(2) deg2rad(-2) -0.1],'ub',[deg2rad(20) deg2rad(-0.1) 0.1],'options',opts);
ms = MultiStart;

[x,~] = run(ms,problem,100);
x_Final=[rad2deg(x(1)) rad2deg(x(2)) x(3)];
end