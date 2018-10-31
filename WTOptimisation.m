function [x] = WTOptimisation()

addpath('Lib'); %Add Lib folder to path to enable functions within that folder to be used in this function
%4: OPTIMISATION - use fminsearchbnd to optimise theta0, thetatw, and cgrad for
%maximum AEP.
    % Initial, Lb & Ub are both arrays of 3 numbers with Initial being the
    % initial guesses for Theta0, ThetaTwist and ChordGrad. Lb are the
    % lower bounds for the optimisation and Ub is the upper bounds.
    % An example input would be WTOptimisation([0.209 -0.00698 0],[0 -0.01 -0.5],[0.4 0 0.5])

opts = optimset('fminsearch');
opts.Display = 'iter'; %What to display in command window
opts.TolX = 0.0001; %Tolerance on the variation in the parameters
opts.TolFun = 0.001; %Tolerance on the error
opts.MaxIter = 500; %Max number of iterations

[x, diff, exitflag] = fminsearchbnd(@DiffCost, [deg2rad(2.5) deg2rad(-1) 0], [deg2rad(2) deg2rad(-2) -0.1], [deg2rad(20) deg2rad(-0.1) 0.1], opts);

end