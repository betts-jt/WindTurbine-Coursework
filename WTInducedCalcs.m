function [a, adash, phi, Cn, Ct] = WTInducedCalcs(a, adash, V0, omega, y, theta, Chord, B)
%1: SINGLE ELEMENT: use an iterative solution to find the values of a,
%adash, phi, Cn and Ct at a particular radius.

% CALCULATE THE RELEVENT ANGLES
tanPhi = ((1-a)*V0)/((1+adash)*omega*y); % Calculate the flow angle
phi = atand(tanPhi);% Flow angle. Degrees
alpha = phi-theta; % Calculate the angle of attack. Degrees

% CALCULATE LIFT AND DRAG COEFFICIENTS
mew = 1.81e-5; % Dynamic viscosity of air at 15oC. kg/ms
rho = 1.225; % Density of air at 15oC. kg/m3

Re = (rho*V0*Chord)/mew; % Calculating the reynolds number.
[Cl, Cd] = ForceCoefficient(alpha, Re); % Running function to calculate drag and lift coefficient 

%CONVERT TO NORMAL AND TANGENTIAL FORCES
Cn = (Cl*cos(phi))+(Cd*sin(phi)); % Normal force coefficient
Ct = (Cl*sin(phi))+(Cd*cos(phi)); % Tangential force coefficient

%CALCULATE NEW VALUES OF a/adash
aNew = 1/((4sin(phi)^2)/)
adashNew = ;



end

