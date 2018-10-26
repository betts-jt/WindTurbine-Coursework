function [] = Main(dispInducedResults)
%This is the main function used to run the wind turbine design/optimisation
%code.
%   dispInducedResults = 1 if the results form the induced calculation are
%   to be desplayed or 0 if they are to be hidden.


%INITIAL VARIABLES
% These are the inital input values for the variables required in the
% induced and single velocity calculations.

a = 0; % Proportion of the wind velocity absorbed across the rotor
adash = 0; % Proportion of rotation in the wake)
V0 = 20; % Wing speed perpendiculat to blade
omega = 3.14; % rotational speed of blades. rad/s
y = 19.5; % Distance on analysed anulus form  blade center. m
theta = 0.0733; % Blade twist angle. rad
Chord = 1; %Chord legnth of a blad. m
B = 3; % Number of blades

%RUN SINGLE ELEMENT INDUCED CALCULATION
[a, adash, phi, Cn, Ct] = WTInducedCalcs(a, adash, V0, omega, y, theta, Chord, B, dispInducedResults);

end