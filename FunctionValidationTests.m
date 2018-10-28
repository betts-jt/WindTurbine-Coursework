function [] = FunctionValidationTests(RunL1, RunL2, RunL3)
%This is a funtion to run the various functions relating to the wind
%turbine design with the variable values form the validation data to check
%that they function correctly.


%RUN THE LEVEL 1 INDUCED CALCULATIONS CODE IF DESIRED
if RunL1 == 1
    [a, adash, phi, Cn, Ct] = WTInducedCalcs(0, 0, 20, 3.14, 19.5, 0.0733, 1, 3);
    %DISPLAY THE RESULTS OF THE ABOVE CALUCLATIONS
    T = table(a, adash, phi, Cn, Ct); %Generate a Table of the results from the induced calcualtions
    figure(1)
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames, 'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]); % Generate a Figure containing the table of results
else
end

%RUN THE LEVEL 2 SINGLE VELOCITY CODE IF DESIRED
if RunL2 == 1
    V0 = 20;
    
    [Mt, Mn, Power,y, a_out, adash_out, phi, Cn, Ct] = WTSingleVelocity(V0, 0.209, -0.00698, 1, 0, 20 ,1, 3.1416, 3, 1.2566e+03, 1.225);
    %DISPLAY THE RESULTS OF THE ABOVE CALUCLATIONS
    disp(['The power generated at windspeed ', num2str(V0), ' was ', num2str(Power)]);
    y=y';
    a_out=a_out';
    adash_out=adash_out';
    phi=phi';
    Cn=Cn';
    Ct=Ct';
    T = table(y, a_out, adash_out, phi, Cn, Ct); %Generate a Table of the results from the single velocity calculations
    figure(2)
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames, 'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]); % Generate a Figure containing the table of results
    Mt=Mt';
    T = table(y, Mt); %Generate a Table of the results from the single velocity calculations
    figure(3)
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames, 'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]); % Generate a Figure containing the table of results
else
end

%RUN THE LEVEL 3 RADIUS MOMENTUM CODE IF DESIRED
if RunL3 == 1
    [~, Vhalf, Power2, BetzPower, AEPV, f, AEP] =  WTVelocityRange([12*pi/180 -0.4*pi/180 0], 7, 1.8, 3.14, 1, 20, 1, 3, 5, 25);
    % CODE TO OUTPUT RESULTS DELETE WHEN ADDED TO FUNCTION TEST
    disp(['The AEP of the blade is ', num2str(AEP)])
    Vhalf = Vhalf';
    AEPV = AEPV';
    f = f';
    Power2 = Power2';
    BetzPower = BetzPower';
    powerprob = Power2.*f*8760;
    powerprobIdeal = BetzPower.*f*8760;
    T = table(Vhalf, Power2, BetzPower, f, AEPV, powerprobIdeal);
    figure(3)
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames, 'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]); % Generate a Figure containing the table of results
else
end