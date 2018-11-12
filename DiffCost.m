function [Diff] = DiffCost(INPUT)
% This is a cost function to use in an optimisation loop. It takes in the
% upper/ lower bounds and start point and returns the value of diff, the
% difference between the AEP and the betz AEP value
%   Detailed explanation goes here
    
% GENERATE A STRUCTURE OF VARIABLES
variables.A = 7; % Weibull Coefficient 
variables.k = 1.8; % Weibull Coefficient 
variables.omega = 3.1416; % Tip Speed
variables.MeanChord = 1; % Mean Chrod Radius
variables.TipRadius = 20; % Blade Tip radius
variables.RootRadius = 1; % Blade Root Radius
variables.B = 3; % Numebr of Blades
variables.MinV0 = 5; % Minimum wids speed for turbine to run (cut in speed)
variables.MaxV0 = 25; % Maximum speed of wind before turbine shuts down

Theta0 = INPUT(1);
ThetaTwist = INPUT(2);
ChordGrad = INPUT(3);


[Diff, Vhalf, Power2, BetzPower, AEPV, f, AEP] = WTVelocityRange([Theta0 ThetaTwist ChordGrad], variables.A, variables.k, variables.omega, variables.MeanChord, variables.TipRadius, variables.RootRadius, variables.B, variables.MinV0, variables.MaxV0);

end

