function [Diff Vhalf, Power2, AEP, f] = WTVelocityRange(Parameters, A, k, omega, MeanChord, TipRadius, RootRadius, B, MinV0, MaxV0)
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
[Mt, Mn,Power(i), Diff(i), y, a_out, adash_out, phi, Cn, Ct] = WTSingleVelocity(V(i), Theta0, ThetaTwist, MeanChord, ChordGrad, TipRadius, RootRadius, omega, B, BladeArea, rho);
end

for i=1:length(V)-1;
    f(i) = exp(-(V(i)/A)^k)-exp(-(V(i+1)/A)^k);
    AEP(i) = sum(0.5*(Power(i))+Power(i+1))*f(i)*8760;
end

parfor i=1:length(Vhalf); % Run a parallal processing for loop
[Mt, Mn,Power2(i), Diff(i), y, a_out, adash_out, phi, Cn, Ct] = WTSingleVelocity(Vhalf(i), Theta0, ThetaTwist, MeanChord, ChordGrad, TipRadius, RootRadius, omega, B, BladeArea, rho);
BetzPower = (16/27)*(0.5*rho*vhalf^A);
end

Vhalf = Vhalf';
AEP = AEP';
f = f';
Power2 = Power2';
T = table(Vhalf, Power2, AEP, f)

end

