function [Diff] = WTVelocityRange(Parameters, A, k, omega, MeanChord, TipRadius, RootRadius, B, MinV0, MaxV0)
%3: ANNUAL ENERGY - loop WTSingleVelocity to find the moments across the
%entire velocity range. Combine this with the frequency information to get
%the AEP.

% DELETE BEFORE FINISHEING
MinV0 = 5;
MaxV0 = 25;
A = 7;
k = 1.8;
omega = 3.146;
TipRadius = 20;
RootRadius = 1;
MeanChord = 1;
B = 3;

% SET INITIAL VARIABLES FOR CALCULATION
Interval = 1; %Setting the spacing between the min and max V0 to analyse
Theta0 = 0.209;
ThetaTwist = -0.00698;
ChordGrad = 0;

V=[MinV0:Interval:MaxV0];
Vhalf = [MinV0+Interval/2:Interval:MaxV0-Interval/2];

parfor i=1:length(V)-1; % Run a parallal processing for loop
f(i) = exp(-(V(i)/A)^k)-exp(-(V(i+1)/A)^k);
[Mt, Mn,Power(i), Diff(i), y, a_out, adash_out, phi, Cn, Ct] = WTSingleVelocity(V(i), Theta0, ThetaTwist, MeanChord, ChordGrad, TipRadius, RootRadius, omega, B);
end

for i=1:length(V)-1;
AEP(i) = sum(0.5*(Power(i))+Power(i+1))*f(i)*8760;
end


end

