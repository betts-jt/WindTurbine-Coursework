function [Diff, AEP, AEPV, BAEP, BEPV, FinalBladeDif, y, DeflectionDistance_n,V,Power,BPower,f] = WTVelocityRange(Parameters, A, k, omega, MeanChord, TipRadius, RootRadius, B, MinV0, MaxV0)

%3: ANNUAL ENERGY - loop WTSingleVelocity to find the moments across the
%entire velocity range. Combine this with the frequency information to get
%the AEP.

% SET INITIAL VARIABLES FOR CALCULATION
rho = 1.225;
Interval = 1; %Setting the spacing between the min and max V0 to analyse
Theta0 = Parameters(1);
ThetaTwist = Parameters(2);
ChordGrad = Parameters(3);
BladeArea = pi()*(TipRadius^2-RootRadius); % Calcualte the swept area of the blades

V=[MinV0:Interval:MaxV0];
Vhalf = [MinV0+Interval/2:Interval:MaxV0-Interval/2];

parfor i=1:length(V) % Run a parallal processing for loop
    [~, Mntot(i),MaxDef_n(i),Power(i), N(i), a_out, adash_out, phi, Cn, Ct,DeflectionDistance_n(i,:)] = WTSingleVelocity(V(i), Theta0, ThetaTwist, MeanChord, ChordGrad, TipRadius, RootRadius, omega, B, BladeArea, rho);
    
    if Mntot(i) >0.5e6 % Check if the root ebnding is greater than the maximum ammount allowed in the coursework sheet
        Power(i) = 0; % Set local power to 0
    end
    if abs(MaxDef_n(i))>3 % Check is bending is greater than 3. 3 is the point the blade hits the tower
        Power(i) = 0; % Set local power to 0
    end
end

for i=1:length(V)-1
    f(i) = exp(-(V(i)/A)^k)-exp(-(V(i+1)/A)^k); % Calcualte the prabobability distribution for wind speeds
    Power2(i) = (0.5*(Power(i)+Power(i+1))); % Calculate the power at each value of Vhalf using the trapezium rule
    AEPV(i) = Power2(i)*f(i)*8760;  % Calcualte the anual energy  production using the trapezium rule
    BEPV(i) = (16/27)*(0.5*rho*Vhalf(i)^3*BladeArea)*f(i)*8760; % Calcualte the ideal AEP generated at each windspeed using the Betz limit
    BPower(i) = (16/27)*(0.5*rho*Vhalf(i)^3*BladeArea); % Calcualte the ideal power generated at each windspeed using the Betz limit
end

AEP = sum(AEPV);

for i=1:length(MaxDef_n)
    if MaxDef_n(i) < 3
        MaxDefBeforeLimit_n(i) = MaxDef_n(i);
    end
end

FinalBladeDif = max(MaxDefBeforeLimit_n); % Maximum blade deflection


BAEP = sum(BEPV);
Diff =BAEP-AEP;

% CALCULATE THE VALUES OF Y FOR FUNCTION OUTPUT
span = TipRadius-RootRadius; %Total Legnth of Blade
deltay = span/(N(1)-1); %Change in span between sections
y(1:N) = [RootRadius:deltay:TipRadius]; % Generate N points along the blade as values of span

end

