function [a, adash, phi, Cn, Ct] = WTInducedCalcs(a, adash, V0, omega, y, theta, Chord, B)
%1: SINGLE ELEMENT: use an iterative solution to find the values of a,
%adash, phi, Cn and Ct at a particular radius.

addpath('Lib'); %Add Lib folder to path to enable functions within that folder to be used in this function

tol = 0.0001; % Setting the tollerence required between the input and output value of a, adash to finish the optimisation
loopCount = 0; % Setting up a counter to count the numebr of loops
Error = 10; % Setting up an initial error value to enable the loop to start

while Error > tol
    % CALCULATE THE RELEVENT ANGLES
    tanPhi = ((1-a)*V0)/((1+adash)*omega*y); % Calculate the flow angle
    phi = atan(tanPhi);% Flow angle. Degrees
    alpha = phi-theta; % Calculate the angle of attack. Degrees
    
    % CALCULATE LIFT AND DRAG COEFFICIENTS
    mew = 1.81e-5; % Dynamic viscosity of air at 15oC. kg/ms
    rho = 1.225; % Density of air at 15oC. kg/m3
    Vrel = ((V0*(1-a))^2+(omega*y*(1-adash)^2))^0.5; %Calculating the relative velociy of the airflow. m/s
    
    Re = (rho*Vrel*Chord)/mew; % Calculating the reynolds number.
    [Cl, Cd] = ForceCoefficient(alpha, Re); % Running function to calculate drag and lift coefficient
    
    %CONVERT TO NORMAL AND TANGENTIAL FORCES
    Cn = (Cl*cos(phi))+(Cd*sin(phi)); % Normal force coefficient
    Ct = (Cl*sin(phi))+(Cd*cos(phi)); % Tangential force coefficient
    
    %CALCULATE NEW VALUES OF a/adash
    sigma = (B*Chord)/(2*pi()*y); %Calculating the solidity of the turbine.
    
    aNew = 1/(((4*sin(phi)^2)/(sigma*Cn))+1); % Calcualting the new value of a
    adashNew = 1/(((4*sin(phi)*cos(phi))/(sigma*Ct))-1); % Calcualting the new value of adash
    
    Error = abs(aNew-a)+abs(adashNew-adash); % Calculating the difference between the input and output values of a, adash
    a = aNew;
    adash = adashNew;
end
end
