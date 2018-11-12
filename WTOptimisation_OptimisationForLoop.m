function [x_Final, Diff_final] = WTOptimisation_OptimisationForLoop()
%This function runs the optimiser a number of different times using a foor
%loop to start it from a different point each time in an attempt to
%mimimise the chance of falling into a local minima


addpath('Lib'); %Add Lib folder to path to enable functions within that folder to be used in this function

opts = optimset('fminsearch');
opts.Display = 'iter'; %What to display in command window
opts.TolX = 0.0001; %Tolerance on the variation in the parameters
opts.TolFun = 0.01; %Tolerance on the error
opts.MaxIter = 100; %Max number of iterations

Theta0 = [2:((20-2)/9):20];
ThetaTW = [-2:(-0.1--2)/9:-0.1];
Chordgrad = [-0.1:(0.1--0.1)/9:0.1];

for i = 1:10
[x(i,:), diff(i), exitflag] = fminsearchbnd(@DiffCost, [deg2rad(Theta0(i)) deg2rad(ThetaTW(i)) Chordgrad(i)], [deg2rad(2) deg2rad(-2) -0.1], [deg2rad(20) deg2rad(-0.1) 0.1], opts);
end

[Diff_final,Diff_pos]=min(diff);
x_Final = x(Diff_pos,:);
x_Final=[rad2deg(x_Final(1)) rad2deg(x_Final(2)) x_Final(3)];


end