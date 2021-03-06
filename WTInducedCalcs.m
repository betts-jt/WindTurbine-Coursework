function [aNew, adashNew, phi, Cn, Ct, Vrel] = WTInducedCalcs(a, adash, V0, omega, y, theta, Chord, B, TipRadius)
%1: SINGLE ELEMENT: use an iterative solution to find the values of a,
%adash, phi, Cn and Ct at a particular radius.


tol = 0.0001; % Setting the tollerence required between the input and output value of a, adash to finish the optimisation
loopCount = 0; % Setting up a counter to count the numebr of loops
Error = 10; % Setting up an initial error value to enable the loop to start
loopCountMax = 500; %Define the maximum numebr of loops permetted whilst solving for both a and adash to stop infinate looping
aNew = 0; % Setting the value a aNew to zero for the first loop
adashNew = 0; % Setting the value a adashNew to zero for the first loop
relaxationLoop = 50; % Loop count at which the relaxation factor is implemented

sigma = (B*Chord)/(2*pi()*y); %Calculating the solidity of the turbine.

while Error > tol
    
    % CALCULATE THE RELEVENT ANGLES
    tanPhi = ((1-a)*V0)/((1+adash)*omega*y); % Calculate the flow angle
    phi = atan(tanPhi);% Flow angle. Degrees
    alpha = phi-theta; % Calculate the angle of attack. Degrees
    
    % CALCUALTE TIP LOSSES
    f=(B*(TipRadius-y))/(2*y*sin(phi));
    F=(2/pi)*acos(exp(-f));
    
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
    aNew = 1/(((4*F*((sin(phi))^2))/(sigma*Cn))+1); % Calcualting the new value of a
    adashNew = 1/(((4*F*(sin(phi)*cos(phi)))/(sigma*Ct))-1); % Calcualting the new value of adash
    
    
    if loopCount < loopCountMax %If loop count is less than the desired maximum
        
        if(loopCount<relaxationLoop)
            k=1; % For low loopcounts set relaxation factor to one and dont use
        else
            k=0.1; % For higher loopcounts set relaxation factor to 0.1 and start to implement to improve stability.
        end
        
        Error = abs(aNew-a)+abs(adashNew-adash); % Calculating the difference between the input and output values of a, adash
        a = k*(aNew-a)+a; % adding a relaxation factor to the value of a to help avoid an unstable loop
        
        if a>1 % Check if the value of a is larger than one
            a=1; % Set the value ot 1 to avoid complex F value
        end
        
        adash = k*(adashNew-adash)+adash; % adding a relaxation factor to the value of adash to help avoid an unstable loop
        
        if adash<0 % Check if the value of adash is less
            %disp(num2str(adash))
            adash=0; % Set the value to 0 to avoide NaN answers
        end
        
    elseif loopCount > loopCountMax && loopCount < 2*loopCountMax % If loop count is above the desired maximum
        if(loopCount<loopCountMax+relaxationLoop)
            
            k=1; % For low loopcounts set relaxation factor to one and dont use
        else
            k=0.1; % For higher loopcounts set relaxation factor to 0.1 and start to implement to improve stability.
        end
        
        Error = abs(aNew-a); % Calculating the difference between the input and output values of a, adash
        a = k*(aNew-a)+a; % adding a relaxation factor to the value of a to help avoid an unstable loop
        
        if a>1 % Check if the value of a is larger than one
            a=1; % Set the value ot 1 to avoid complex F value
        end
        
        adash = 0; %set adash to 0 if the maximum number of desired loopes has been exceeded
    elseif loopCount > 2*loopCountMax
        break
    end
    
    loopCount = loopCount+1; % Increase the loop counter by 1
end

end
