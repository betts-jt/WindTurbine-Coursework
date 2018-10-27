function [Diff] = WTVelocityRange(Parameters, A, k, omega, MeanChord, TipRadius, RootRadius, B, MinV0, MaxV0)
%3: ANNUAL ENERGY - loop WTSingleVelocity to find the moments across the
%entire velocity range. Combine this with the frequency information to get
%the AEP.

MinV0 = 5;
MaxV0 = 25;
A = 7;
k = 1.8;

% SET I:NITIAL VARIABLES FOR CALCULATION
Interval = 1; %Setting the spacing between the min and max V0 to analyse

V=[MinV0:Interval:MaxV0];

for i=1:length(V)-1
f(i) = exp(-(V(i)/A)^k)-exp(-(V(i+1)/A)^k);

end
