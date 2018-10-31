function [Mttot, Mntot, deltaX_total, Power, y, a_out, adash_out, phi, Cn, Ct] = WTSingleVelocity(V0, Theta0, ThetaTwist, MeanChord, ChordGrad, TipRadius, RootRadius, omega, B, BladeArea, rho)
%2: WHOLE ROTOR - loop WTInducedCalcs to find the values for all radii,
%then integrate these to get the normal and tangential moment at the blade
%root.

%INITIAL VARIABLES
a = 0; % Initial value of a dash used in Induced Calculatiuons
adash = 0; %Initial value of a dash used in Induced Calculatiuons

% SETTING UP VALUES FOR FULL RADIUS CALCULATIONS
N = 20; % The total numebr of sections acros the balde span to be analysed
span = TipRadius-RootRadius; %Total Legnth of Blade
deltay = span/(N-1); %Change in span between sections
y(1:N-1) = [RootRadius+deltay/2:deltay:TipRadius-deltay/2]; % Generate N points along the blade as values of span
MaxMn = 0.5e6; % Maximum value of root bendiung moment as defined in coursework sheet

%RUN THE INDUCED VELOCITY CALCULATION FOR ALL POINTS ON SPAN
for i=1:N-1
    ThetaR(i) = Theta0+y(i)*ThetaTwist; % Calcualte the value of twist at the particular point on the blades span
    Chord(i) = MeanChord + ((y(i)-((TipRadius-RootRadius)/2))*ChordGrad); % Calcualte the value of chord legnth at the particular point on the blades span
    [a_out(i), adash_out(i), phi(i), Cn(i), Ct(i), Vrel(i)] = WTInducedCalcs(a, adash, V0, omega, y(i), ThetaR(i), Chord(i), B); % Run the induceed calculations at a specific poinot on the blade
    EIPoint(i) = 40e9*((Chord(i)*(0.2*Chord(i))^3)/12); % Calculate the approximate value of blade stiffness for each Chord section
end

Mt = (0.5*rho.*Vrel.^2.*Chord.*Ct)*deltay.*y; % Calcualte the moment due to torque at all points of the blade
Mn = (0.5*rho.*Vrel.^2.*Chord.*Cn)*deltay.*y; % Calcualte the moment due to root bending at all points of the blade

Local_Force = Mn./y; % Calcualting the normal force on the blade at each point

%Total_Force = sum(Local_Force)

for i=1:N-1
    deltaX_local(i) = ((Local_Force(i)*y(i)^2)/(24*EIPoint(i)*span))*((2*span^2)+(2*span-y(i))^2); %Calculating the local deflection due to normal force at each point of the blade
end

deltaX_total = sum(deltaX_local); % Calcualting the total deflection of the tip of the blade

Mttot = sum(Mt); % Caluclate the total bending moment due to torque ofthe blade 
Mntot = sum(Mn); % Calcualte the total root bending moment of the blade

Power = Mttot*B*omega; %Calcualte the power generated due to the torque

end
