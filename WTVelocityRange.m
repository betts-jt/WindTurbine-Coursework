function [Diff, Vhalf, Power2, BetzPower, AEPV, f, AEP] = WTVelocityRange(Parameters, A, k, omega, MeanChord, TipRadius, RootRadius, B, MinV0, MaxV0)

%3: ANNUAL ENERGY - loop WTSingleVelocity to find the moments across the
%entire velocity range. Combine this with the frequency information to get
%the AEP.

% SET INITIAL VARIABLES FOR CALCULATION
rho = 1.225;
Interval = 1; %Setting the spacing between the min and max V0 to analyse
Theta0 = Parameters(1);
ThetaTwist = Parameters(2);
ChordGrad = Parameters(3);
BladeArea = pi()*TipRadius^2; % Calcualte the swept area of the blades

V=[MinV0:Interval:MaxV0];
Vhalf = [MinV0+Interval/2:Interval:MaxV0-Interval/2];

parfor i=1:length(V); % Run a parallal processing for loop
    [Mt, Mn,Power(i), y, a_out, adash_out, phi, Cn, Ct] = WTSingleVelocity(V(i), Theta0, ThetaTwist, MeanChord, ChordGrad, TipRadius, RootRadius, omega, B, BladeArea, rho);

end

for i=1:length(V)-1;
    f(i) = exp(-(V(i)/A)^k)-exp(-(V(i+1)/A)^k); % Calcualte the prabobability distribution for wind speeds
    Power2(i) = (0.5*(Power(i)+Power(i+1))); % Calculate the power at heach value of Vhalf using the trapezium rule
    AEPV(i) = 0.5*(Power(i)+Power(i+1))*f(i)*8760;  % Calcualte the anual energy  production using the trapezium rule
    BetzPower(i) = (16/27)*(0.5*rho*Vhalf(i)^3*BladeArea); % Calcualte the ideal power generated at each windspeed using the Betz limit
end

AEP = sum(AEPV);
BAEP = sum(BetzPower);
Diff =BAEP-AEP;

end

