clc;
clear all;
X= readtable('Montreal-est.xls'); %data to be extracted from excel
solar = transpose(((X{:,13}))); %irradiance in KJ/m^2
Tempsky = transpose(((X{:,12})+273.15)); %sky temp in K
wind = transpose(((X{:,9})*0.1)); %windspeed in m/s
%constants
A = 25; %area of pool
P =20; %perimeter of pool
n=2208; %number of datasets
g=9.81; %m/s^2
Tw=27+273.15; %K, water tempertaure
vair=1.47*1E-5; %m^2/s, assume number for vair at 15 degrees celcius
Prair=0.7323; % no unit, Avg Pr assumed at 15 degrees celcius at 1 atm
lc = (A/P); %m, critical length of pool
kair=0.02476; %Wm/K, at 15 degrees celcius Air
Recr=5E5; %critical Reynolds number
alpha = 0.815; %fraction of solar energy absorbed by water
%For combined HT
Rcombinedconv=zeros(1,n); %Stores combined Forced and Natural Convection R values
Qcombinedconv=zeros(1,n); %Stores combined Forced and Natural Convection Q values
Qcombined=zeros(1,n); %Stores combined Qradiation and Qconvection
R= zeros(1,n); %Stores Resistance values
Qsconv= zeros(1,n); %stores Qconvection with sheet
%For natural convection loop arrays
hnconv=zeros(1,n); %stores natural convection hconv values
Gr=zeros(1,n); %stores Gr values
Ralc=zeros(1,n); %stores Ralc
Tfilm=zeros(1,n); %stores Tfilm
Nulc=zeros(1,n); %stores Nusselt number
Rnconv=zeros(1,n); %stores natural convection R values
Qnconv=zeros(1,n); %stores natural convection values
Qref=zeros(1,n); %stores Qreflection loss
Qtotwsheet= zeros(1,n); %stores total Q loss with sheet included
%Forced convection loop arrays
Re=zeros(1,n); %stores Reynolds number
hfconv=zeros(1,n); %stores h for forced convection
Rfconv=zeros(1,n);%stores R, resistance for forced convection
Nu_lf=zeros(1,n); %Nusselt number for forced convection
Qfconv=zeros(1,n); %stores Q for forced convection
%Radiation loss array+variables
Qrad=zeros(1,n); %stores Qradiation
sigma=5.67E-8; %Boltzman constant
e=0.9; %emissivity
%%Natural Convection at top surface of the cover
for i=1:n
Tfilm(i)=(Tw+Tempsky(i))/2; %Tfilm calculation
Gr(i) = g.*(1./(Tfilm(i))).*(Tw-Tempsky(i))*lc.^3./(vair).^2; %Gr formula
Ralc(i) = Gr(i) * Prair;
if 1E4 < Ralc(i) && Ralc(i) <1E7
Nulc(i) = 0.54 * Ralc(i)^0.25;
elseif 1E7 < Ralc(i) && Ralc(i) <1E11
Nulc(i) = 0.15 * Ralc(i)^(1/3);
end
hnconv(i) = Nulc(i)*kair/lc;
Rnconv(i) = 1/hnconv(i)/A;
Qnconv(i) = hnconv(i)*A*(Tw-Tempsky(i));
end
%%%Forced Convection at top surface of the
for i=1:n
if wind(i)==0 %checks is windspeed is zero
hfconv(i)=0;
Rfconv(i)=0;
Rcombinedconv(i)=Rnconv(i);
else
Re(i) = wind(i)*lc/vair;% Re #
if Re(i) > 5E5 % check for Laminar or Turbulent flow
Nu_lf(i) = 0.664*Recr^0.5*Prair^(1/3)+0.037*Re(i).^0.8*Prair^(1/3)*(1-(Recr/Re(i)).^0.8);% Nu # for turbulent flow
else
Nu_lf(i) = 0.664*Re(i).^0.5*Prair^(1/3);% Nu # for laminar flow
hfconv(i) = Nu_lf(i)*kair/lc;
Rfconv(i) = 1/(hfconv(i)*A); %forced Conv R
Rcombinedconv(i) = 1/((1/Rnconv(i))+(1/Rfconv(i))); %Combine Forced and Natural Convection at cover top
end
end
Qfconv(i)= hfconv(i)*A*(Tw-Tempsky(i));
Qcombinedconv(i)=Qfconv(i)+Qnconv(i);
end
%%%Radiation Loss
for i=1:n
Qrad(i)=A*sigma*e*4/2*(Tw+Tempsky(i)).^3*(Tw-Tempsky(i));
Qcombined(i)=Qrad(i)+Qcombinedconv(i);
end
%%%Q convecction with sheet
for i = 1:n
R(i)= (0.04/160 +0.03/kair +1/(hnconv(i)+hfconv(i)));
Qsconv(i) = (25*(R(i).^-1)*(Tw-Tempsky(i)));
end
%%% reflection loss with sheet
for i = 1:n
Qref(i) = (0.185*25*solar(i))/3.600;
Qtotwsheet(i)= Qref(i)+Qsconv(i);
end
d =nansum(Qtotwsheet(1,:)) %total Q loss with sheet
t = nansum(Qcombined(1,:)) %total Q loss without sheet
Power_Saving = (t - d)/1000 %total Q saved in KW
money_saved = ((0.0608)*Power_Saving) %total $$$ saved