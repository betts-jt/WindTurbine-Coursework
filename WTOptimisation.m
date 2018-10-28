function [] = WTOptimisation(Initial, Lb, Ub)
%4: OPTIMISATION - use fminsearchbnd to optimise theta0, thetatw, and cgrad for
%maximum AEP.
    % Initial, Lb & Ub are both arrays of 3 numbers with Initial being the
    % initial guesses for Theta0, ThetaTwist and ChordGrad. Lb are the
    % lower bounds for the optimisation and Ub is the upper bounds.
    % An example input would be WTOptimisation([0.209 -0.00698 0],[0 -0.01 -0.5],[0.4 0 0.5])
    
% GENERATE A STRUCTURE OF VARIABLES
var.A = 7; % Weibull Coefficient 
var.k = 1.8; % Weibull Coefficient 
var.omega = 3.1416; % Tip Speed
var.MeanChord = 1; % Mean Chrod Radius
var.TipRadius = 20; % Blade Tip radius
var.RootRadius = 1; % Blade Root Radius
var.B = 3; % Numebr of Blades
var.MinV0 = 5; % Minimum wids speed for turbine to run (cut in speed)
var.MaxV0 = 25 % Maximum speed of wind before turbine shuts down

Theta0In = Initial(1);
ThetaTwistIn = Initial(2);
ChordGradIn = Initial(3);

Theta0Lb = Lb(1);
ThetaTwistLb = Lb(2);
ChordGradLb = Lb(3);

Theta0Lb = Ub(1);
ThetaTwistLb = Ub(2);
ChordGradLb = Ub(3);

opts = optimset('fminsearch');
opts.Display = 'iter'; %What to display in command window
opts.TolX = 0.0001; %Tolerance on the variation in the parameters
opts.TolFun = 0.001; %Tolerance on the error
opts.MaxIter = 100; %Max number of iterations

[x] = fminsearchbnd(@DiffCost, [Initial], [Lb], [Ub], opts, var);


end