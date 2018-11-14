function [] = SingleRun(Theta0, ThetaTwist, ChordGrad,plotInitialGraphs,Theta0fix,ThetaTWfix,ChordGradfix)
% This function runs the velocity calculatiuons for a single blade to give
% details of how it performed and details relating to its possible AEP and
% the deflection of the blade when in  use
% Use this to run if x output from optimiser is already in the workspace
%   [] = SingleRun(deg2rad(x_Final_ForLoop(1)), deg2rad(x_Final_ForLoop(2)), x_Final_ForLoop(3),1,0,0,0)


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

if plotInitialGraphs == 1
    %RUN THE VELOCITY RANGE FUNCTION
    [Diff, AEP, AEPV, BAEP, BEPV, MaxDef_n, y, DeflectionDistance_n,V,Power,BPower,f] = WTVelocityRange([Theta0 ThetaTwist ChordGrad], variables.A, variables.k, variables.omega, variables.MeanChord, variables.TipRadius, variables.RootRadius, variables.B, variables.MinV0, variables.MaxV0);
    
    
    FinalBladeDif = MaxDef_n(find(AEPV>0,1,'last')); % Maximum blade deflection
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
        plot(-DeflectionDistance_n(i,:),y,-DeflectionDistance_n(i,:),-y)
    end
    plot([3 3],[-20 20])
    title('Blade Bending at Different Wind Speeds')
    ylabel('y, (m)')
    xlabel('deflection, (m)')
    
    %% PLOT BLADE BENDING DIAGRAM
    figure(3)
    for i=1:length(DeflectionDistance_n)
        hold on
        plot(-DeflectionDistance_n(i,:),y)
    end
    plot([3 3],[0 20])
    title('Blade Bending at Different Wind Speeds')
    ylabel('y, (m)')
    xlabel('deflection, (m)')
    %% PLOT V0 vs POWER
    figure(4)
    plot(V,Power,'r-',V(1:end-1),BPower,'b--')
    xlabel('Wind Velocity, (m/s)')
    ylabel('Power, (W)')
    title('Wind Velocity vs Power')
    legend('Actual Power Generated','Betz Ideal Power','Location','northwest')
    
    %% PLOT PROBABLITIY VS WIND SPEED
    figure(5)
    plot(V(1:end-1),f)
    xlabel('Wind Velocity, (m/s)')
    ylabel('Probility')
    title('Wind Velocity vs Probability')
end
%% Plot graphs to show global maxima has been reached
x_Final_ForLoop = [8.6057 -0.4383 0.0302];

res = 100;

if Theta0fix == 1
    Theta0 = [2:(20-2)/(res-1):20];
    ThetaTwist = x_Final_ForLoop(2);
    ChordGrad = x_Final_ForLoop(3);
    
    for aa = 1:res
        [Diff, AEP(aa), AEPV, BAEP(aa), BEPV, MaxDef_n, y, DeflectionDistance_n,V,Power,BPower,f] = WTVelocityRange([deg2rad(Theta0(aa)) deg2rad(ThetaTwist) ChordGrad], variables.A, variables.k, variables.omega, variables.MeanChord, variables.TipRadius, variables.RootRadius, variables.B, variables.MinV0, variables.MaxV0);
    end
    figure(6)
    hold on
    plot(Theta0, AEP, 'r')
    plot([x_Final_ForLoop(1) x_Final_ForLoop(1)],[0, max(AEP)], 'b')
    plot(x_Final_ForLoop(1), max(AEP), 'xb')
    xlabel('Theta0')
    ylabel('AEP')
    title('Difference in Theta0 against AEP')
end

if ThetaTWfix == 1
    Theta0 = x_Final_ForLoop(1);
    ThetaTwist = [-1.5:((0.5--1.5)/(res-1)):0.5];
    ChordGrad = x_Final_ForLoop(3);
    
    for bb = 1:res
        [Diff, AEP(bb), AEPV, BAEP(bb), BEPV, MaxDef_n, y, DeflectionDistance_n,V,Power,BPower,f] = WTVelocityRange([deg2rad(Theta0) deg2rad(ThetaTwist(bb)) ChordGrad], variables.A, variables.k, variables.omega, variables.MeanChord, variables.TipRadius, variables.RootRadius, variables.B, variables.MinV0, variables.MaxV0);
    end
    figure(7)
    hold on
    plot(ThetaTwist, AEP, 'r')
    plot([x_Final_ForLoop(2) x_Final_ForLoop(2)],[0, max(AEP)], 'b')
    plot(x_Final_ForLoop(2),max(AEP), 'xb')
    xlabel('Theta Twist')
    ylabel('AEP')
    title('Difference in Theta Twist against AEP')
end

if ChordGradfix == 1
    Theta0 = x_Final_ForLoop(1);
    ThetaTwist = x_Final_ForLoop(2);
    ChordGrad = [-0.1:(0.1--0.1)/(res-1):0.1];
    
    for cc = 1:res
        [Diff, AEP(cc), AEPV, BAEP(cc), BEPV, MaxDef_n, y, DeflectionDistance_n,V,Power,BPower,f] = WTVelocityRange([deg2rad(Theta0) deg2rad(ThetaTwist) ChordGrad(cc)], variables.A, variables.k, variables.omega, variables.MeanChord, variables.TipRadius, variables.RootRadius, variables.B, variables.MinV0, variables.MaxV0);
    end
    figure(8)
    hold on
    plot(ChordGrad, AEP, 'r')
    plot([x_Final_ForLoop(3) x_Final_ForLoop(3)],[0, max(AEP)], 'b')
    plot(x_Final_ForLoop(3),max(AEP), 'xb')
    xlabel('Chord Gradient')
    ylabel('AEP')
    title('Difference in Chord Gradient against AEP')
end

end

