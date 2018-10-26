function [MT, MN] = FunctionValidationTests(RunL1, RunL2, RunL3)
%This is a funtion to run the various functions relating to the wind
%turbine design with the variable values form the validation data to check
%that they function correctly.


%RUN THE LEVEL 1 INDUCED CALCULATIONS CODE IF DESIRED
if RunL1 = 1
    [a, adash, phi, Cn, Ct] = WTInducedCalcs(0, 0, 20, 3.14, 19.5, 0.0733, 1, 3, 20);
    %DISPLAY THE RESULTS OF THE ABOVE CALUCLATIONS
    T = table(a, adash, phi, Cn, Ct); %Generate a Table of the results from the induced calcualtions
    figure(1)
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames, 'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]); % Generate a Figure containing the table of results
else
end

%RUN THE LEVEL 2 SINGLE VELOCITY CODE IF DESIRED
if RunL2 = 1
    [MT, MN] = WTSingleVelocity(20, 0.209, -0.00698, 1, 0, 20 ,1, 3.1416, 3);
    %DISPLAY THE RESULTS OF THE ABOVE CALUCLATIONS
    %{
    T = table(a, adash, phi, Cn, Ct); %Generate a Table of the results from the induced calcualtions
    figure(1)
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames, 'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]); % Generate a Figure containing the table of results
    %}
else
end

%RUN THE LEVEL 3 RADIUS MOMENTUM CODE IF DESIRED
if RunL3 = 1
    [Diff] = WTVelocityRange([12*pi/180 -0.4*pi/180 0], 7, 1.8, 3.14, 1, 20, 1, 3, 5, 25);
    %DISPLAY THE RESULTS OF THE ABOVE CALUCLATIONS
    %{
T = table(a, adash, phi, Cn, Ct); %Generate a Table of the results from the induced calcualtions
    figure(1)
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames, 'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]); % Generate a Figure containing the table of results
%}
else
end