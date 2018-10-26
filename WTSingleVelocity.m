function [MT, MN] = WTSingleVelocity(V0, Theta0, ThetaTwist, MeanChord, ChordGrad, TipRadius,RootRadius, omega, B)
%2: WHOLE ROTOR - loop WTInducedCalcs to find the values for all radii,
%then integrate these to get the normal and tangential moment at the blade
%root.

%INITIAL VARIABLES
a = 0; % Initial value of a dash used in Induced Calculatiuons
adash = 0; %Initial value of a dash used in Induced Calculatiuons
omega = 3.141593; % Initial tip velocity
V0 = 20; % Initial velocity of wind perpendicular to turbine
theta = 0.0733; % 
Chord = 1; % Chord legnth of turbing blade
B = 3; % Number of turbine blades

% SETTING UP VALUES FOR FULL RADIUS CALCULATIONS
N = 20; % The total numebr of sections acros the balde span to be analysed
span = TipRadius-RootRadius; %Total Legnth of Blade
y(1:N) = [RootRadius:span/(N-1):TipRadius]; % Generate N points along the blade as values of span

for i=1:N
    [a_out(i), adash_out(i), phi(i), Cn(i), Ct(i), Vrel(i)] = WTInducedCalcs(a, adash, V0, omega, y(i), theta, Chord, B)
end
end
