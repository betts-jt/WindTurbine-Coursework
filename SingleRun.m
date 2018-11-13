function [MaxDef_n] = SingleRun(Theta0, ThetaTwist, ChordGrad)
% This function runs the velocity calculatiuons for a single blade to give
% details of how it performed and details relating to its possible AEP and
% the deflection of the blade when in  use
% Use this to run if x output from optimiser is already in the workspace
%   [MaxDef_n] = SingleRun(deg2rad(x_Final(1)), deg2rad(x_Final(2)), x_Final(3))


% GENERATE A STRUCTURE OF VARIABLES
variables.A = 7; % Weibull Coefficient
variables.k = 1.8; % Weibull Coefficient
variables.omega = 3.1416; % Tip Speed
variables.MeanChord = 1; % Mean Chrod Radius
variables.TipRadius = 20; % Blade Tip radius
variables.RootRadius = 1; % Blade Root Radius
variables.B = 3; % Numebr of Blades
variables.MinV0 = 5; % Minimum wids speed for turbine to run (cut in speed)
variables.MaxV0 = 25; % Maximum speed of wind before turbine shuts down

%RUN THE VELOCITY RANGE FUNCTION
[Diff, AEP, AEPV, BAEP, BEPV, FinalBladeDif, y, DeflectionDistance_n] = WTVelocityRange([Theta0 ThetaTwist ChordGrad], variables.A, variables.k, variables.omega, variables.MeanChord, variables.TipRadius, variables.RootRadius, variables.B, variables.MinV0, variables.MaxV0);

%% PLOT AEP vs BEPV GRAPH
figure(1)
plot(y,AEPV,'r-',y,BEPV,'b--')
title('Final Blade AEP vs Betz Ideal AEP')
ylabel('AEP, (W)')
xlabel('y, (m)')
legend('AEP', 'Betz Ideal AEP')

%% PLOT BLADE BENDING DIAGRAM
    figure(2)
for i=1:length(DeflectionDistance_n)
    hold on
    plot(-DeflectionDistance_n(i,:),y)
end
    plot([3 3],[0 20])
    title('Blade Bending at Different Wind Speeds')
    ylabel('y, (m)')
    xlabel('deflection, (m)')

%% PLOTTING GRAPHS TO SHOW THAT MAXIMUM HAS BEEN ACHIEVED
figure(3)

plot(,AEPV)




