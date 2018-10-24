function [aNew, adashNew, phi, Cn, Ct] = WTInducedCalcs(a, adash, V0, omega, y, theta, Chord, B, dispInducedResults)
%1: SINGLE ELEMENT: use an iterative solution to find the values of a,
%adash, phi, Cn and Ct at a particular radius.

addpath('Lib'); %Add Lib folder to path to enable functions within that folder to be used in this function

tol = 0.0001; % Setting the tollerence required between the input and output value of a, adash to finish the optimisation
loopCount = 0; % Setting up a counter to count the numebr of loops
Error = 10; % Setting up an initial error value to enable the loop to start
k = 0.1; % Relaxation factor used in loop up avoid an unstable loop situation
loopCountMax = 100; %Define the maximum numebr of loops permetted whilst solving for both a and adash to stop infinate looping
aNew = 0; % Setting the value a aNew to zero for the first loop
adashNew = 0; % Setting the value a adashNew to zero for the first loop

sigma = (B*Chord)/(2*pi()*y); %Calculating the solidity of the turbine.

while Error > tol
    
    a = k*(aNew-a)+a; % adding a relaxation factor to the value of a to help avoid an unstable loop
    adash = k*(adashNew-adash)+adash; % adding a relaxation factor to the value of adash to help avoid an unstable loop
    
    % CALCULATE THE RELEVENT ANGLES
    tanPhi = ((1-a)*V0)/((1+adash)*omega*y); % Calculate the flow angle
    phi = atan(tanPhi);% Flow angle. Degrees
    alpha = phi-theta; % Calculate the angle of attack. Degrees
    
    % CALCULATE LIFT AND DRAG COEFFICIENTS
    mew = 1.81e-5; % Dynamic viscosity of air at 15oC. kg/ms
    rho = 1.225; % Density of air at 15oC. kg/m3
    Vrel = ((V0*(1-a))^2 + (omega*y*(1+adash))^2)^0.5; %Calculating the relative velociy of the airflow. m/s
    
    Re = (rho*Vrel*Chord)/mew; % Calculating the reynolds number.
    [Cl, Cd] = ForceCoefficient(alpha, Re); % Running function to calculate drag and lift coefficient
    
    %CONVERT TO NORMAL AND TANGENTIAL FORCES
    Cn = (Cl*cos(phi))+(Cd*sin(phi)); % Normal force coefficient
    Ct = (Cl*sin(phi))-(Cd*cos(phi)); % Tangential force coefficient
    
    %CALCULATE NEW VALUES OF a/adash    
    aNew = 1/(((4*sin(phi)^2)/(sigma*Cn))+1); % Calcualting the new value of a
    adashNew = 1/(((4*(sin(phi)*cos(phi))/(sigma*Ct))-1)); % Calcualting the new value of adash
    
    
    if loopCount < loopCountMax %If loop count is less than the desired maximum
        Error = abs(aNew-a)+abs(adashNew-adash); % Calculating the difference between the input and output values of a, adash
    elseif loopCount > loopCountMax % If loop count is above the desired maximum
        Error = abs(aNew-a); % Calculating the difference between the input and output values of a, adash
    elseif loopCount == 5*loopCountMax
        error('It has not been possible to calculate a value of a. Please change the input parameters and try again'); % Stop trying to find a or adash is 5 times the maximum desired loops has been reached to stop the code running infinetly
    end
    
    loopCount = loopCount+1; % Increase the loop counter by 1
end

%DISPLAY THE RESULTS OF THE AVOBE CALUCLATIONS
if dispInducedResults == 1 % Show the results if the requested
    T = table(a, adash, phi, Cn, Ct); %Generate a Table of the results from the induced calcualtions
    figure
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames, 'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]); % Generate a Figure containing the table of results
elseif dispInducedResults == 0  % Do not show the results if the requested
    return
else
    error('Enter either 1 to show results of the Induced calculations or 0 to hide the results when calling the main function') % show an error is neither a 0 or 1 were entered in the dispInducedResults variable
end

end
