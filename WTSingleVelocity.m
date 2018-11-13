function [Mttot, Mntot, MaxDef_n, Power, N, a_out, adash_out, phi, Cn, Ct,DeflectionDistance_n] = WTSingleVelocity(V0, Theta0, ThetaTwist, MeanChord, ChordGrad, TipRadius, RootRadius, omega, B, BladeArea, rho)
%% WHOLE ROTOR - loop WTInducedCalcs to find the values for all radii,
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
    [a_out(i), adash_out(i), phi(i), Cn(i), Ct(i), Vrel(i)] = WTInducedCalcs(a, adash, V0, omega, y(i), ThetaR(i), Chord(i), B, TipRadius); % Run the induceed calculations at a specific poinot on the blade
    EIPoint(i) = 40e9*((Chord(i)*(0.2*Chord(i))^3)/12); % Calculate the approximate value of blade stiffness for each Chord section
end

Mt = (0.5*rho.*Vrel.^2.*Chord.*Ct)*deltay.*y; % Calcualte the moment due to torque at all points of the blade
Mn = (0.5*rho.*Vrel.^2.*Chord.*Cn)*deltay.*y; % Calcualte the moment due to root bending at all points of the blade


%% BLADE BENDING CALCULATIONS

%RUN THE INDUCED VELOCITY CALCULATION FOR ALL NODES
y_nodes(1:N) = [RootRadius:deltay:TipRadius]; % Generate N points at the nodes of the blade

for j=1:N
    ThetaR_nodes(j) = Theta0+(y_nodes(j)-1)*ThetaTwist; % Calcualte the value of twist at the particular point on the blades span
    Chord_nodes(j) = MeanChord + ((y_nodes(j)-((TipRadius-RootRadius)/2))*ChordGrad); % Calcualte the value of chord legnth at the particular point on the blades span
    [~, ~,~, Cn_nodes(j), Ct_nodes(j), Vrel_nodes(j)] = WTInducedCalcs(a, adash, V0, omega, y_nodes(j), ThetaR_nodes(j), Chord_nodes(j), B, TipRadius); % Run the induceed calculations at a specific poinot on the blade
    EIPoint2_nodes(j) = 40e9*(((0.2*Chord_nodes(j))*Chord_nodes(j)^3)/12); % Calculate the approximate value of blade stiffness for each Chord section about 1st principal axis
    EIPoint_nodes(j) = 40e9*((Chord_nodes(j)*(0.2*Chord_nodes(j))^3)/12); % Calculate the approximate value of blade stiffness for each Chord section about 2nd principal axis
end

Mt_nodes = (0.5*rho.*Vrel_nodes.^2.*Chord_nodes.*Ct_nodes)*deltay.*y_nodes; % Calcualte the moment due to torque at all points of the blade at nodes
Mn_nodes = (0.5*rho.*Vrel_nodes.^2.*Chord_nodes.*Cn_nodes)*deltay.*y_nodes; % Calcualte the moment due to root bending at all points of the blade at nodes

LocalForce_nodes_n = Mn_nodes./(y_nodes*deltay); % Calcualting the normal force on the blade at each point
LocalForce_nodes_t = Mt_nodes./(y_nodes*deltay); % Calcualting the tangental force on the blade at each point

T_t = zeros(1,N);
T_n = zeros(1,N);
M_t = zeros(1,N);
M_n = zeros(1,N);

count = N;
for i = 2:N
    T_t(count-1) = T_t(count) + 0.5*(LocalForce_nodes_t(count-1) + LocalForce_nodes_t(count))*deltay;
    T_n(count-1) = T_n(count) + 0.5*(LocalForce_nodes_n(count-1) + LocalForce_nodes_n(count))*deltay;
    M_t(count-1) = M_t(count) - T_n(count)*deltay - ((1/6)*LocalForce_nodes_n(count-1) + (1/3)*LocalForce_nodes_n(count))*deltay^2;
    M_n(count-1) = M_n(count) + T_t(count)*deltay + ((1/6)*LocalForce_nodes_t(count-1) + (1/3)*LocalForce_nodes_t(count))*deltay^2;
    count = count - 1; % Reduce loop counter by 1
end


M1 = M_t.*cos(ThetaR_nodes) - M_n.*sin(ThetaR_nodes); % Calculating bending moment in 1st principal axes
M2 = M_t.*sin(ThetaR_nodes) + M_n.*cos(ThetaR_nodes); % Calculating bending moment in 1nd principal axes
k1 = M1./EIPoint_nodes; % Calculating curvature about 1st principal axes
k2 = M2./EIPoint2_nodes; % Calculating curvature about moment in 1st principal axes

kn = -k1.*sin(ThetaR_nodes) + k2.*cos(ThetaR_nodes); % Converting curvature to normal axis of blade
kt = k1.*cos(ThetaR_nodes)+k2.*sin(ThetaR_nodes);% Converting curvature to tangential axis of blade


% CALCUALTING OVERALL DEFLECTIUON ANGLES AND DISTANCES
DeflectionAngle_t = zeros(1,N); % Generating array for t deflection angles
DeflectionAngle_n = zeros(1,N); % Generating array for n deflection angles
DeflectionDistance_t = zeros(1,N); % Generating array for t deflection distances
DeflectionDistance_n = zeros(1,N); % Generating array for n deflection distances

for i = 1:N-1
    % Calcualting y deflection angle
    DeflectionAngle_t(i+1) = DeflectionAngle_t(i) + 0.5*(kt(i+1)+kt(i))*deltay;
    % Calcualting z deflection angle
    DeflectionAngle_n(i+1) = DeflectionAngle_n(i) + 0.5*(kn(i+1)+kn(i))*deltay;
    % Calcualting y deflection distance
    DeflectionDistance_t(i+1) = DeflectionDistance_t(i) + DeflectionAngle_n(i)*deltay + ((1/6)*kn(i+1)+(1/3)*kn(i))*deltay^2;
    % Calcualting z deflection distance
    DeflectionDistance_n(i+1) = DeflectionDistance_n(i) + DeflectionAngle_t(i)*deltay + ((1/6)*kt(i+1)+(1/3)*kt(i))*deltay^2;
end

% MAXIMUM DEFLECTION
MaxDef_t = DeflectionDistance_t(end); % Calculate the maximum tangential deflection
MaxDef_n = DeflectionDistance_n(end); % Calculate the maximum normal bending
MaxDef_n = -MaxDef_n; % Invert normal deflection to make backwards bending positive

% TOTAL MOMENT CALCULATIONS
Mttot = sum(Mt); % Caluclate the total bending moment due to torque ofthe blade 
Mntot = sum(Mn); % Calcualte the total root bending moment of the blade

% TOTAL POWER CALCULATIONS
Power = Mttot*B*omega; %Calcualte the power generated due to the torque

end
