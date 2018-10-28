function [Diff] = DiffCost(INPUT, var)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Theta0 = INPUT(1);
ThetaTwist = INPUT(2);
ChordGrad = INPUT(3);

[Diff, Vhalf, Power2, BetzPower AEPV, f, AEP] = WTVelocityRange([Theta0 ThetaTwist ChordGrad], var.A, var.k, var.omega, var.MeanChord, var.TipRadius, var.RootRadius, var.B, var.MinV0, var.MaxV0);

end

