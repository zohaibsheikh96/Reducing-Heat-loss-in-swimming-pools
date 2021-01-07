# Reducing Heat losses in swimming pools

## Background and motivation

Open swimming pools get naturally heated by absorbing solar energy directly from the sun. Majority of the solar radiation striking the swimming pool surface is absorbed by the water and converted into heat [1]. However, due to their vast surface area, heat losses to the surroundings are relatively high, and swimming pools maintain their average temperature relatively close to the average surrounding air temperature. As a result, during cooler months when the temperature outside is too low, heaters are used to heat the pool water to bring it to one’s desired temperature, which results in a substantial amount of electricity consumption.
The simplest suggested solution to this high heat loss issue to increase water temperature is an introduction of a transparent plastic cover that will allow solar radiation to pass through [2]. Plastic also meets the requirements of being a vapor barrier. Accordingly, the objective of this project is to design and analyze a transparent swimming pool cover that will address the aforementioned issues and should significantly reduce pool heating costs.
Heat loss from a swimming pool mainly occur through evaporation (ignored in this report), convection, radiation, and some negligible conduction to the ground. In order to retain the water at a higher temperature than that of the surrounding air, the amount of heat to be supplied to the water must be equal to the heat loss at this temperature. The water temperature will increase by keeping the heat input unchanged and reducing this heat loss [1]. With the introduction of a transparent cover, there will also be an introduction of heat loss due to reflection of the interfaces between the sun and the water. A pool cover will also decrease the solar gain contribution to some extent.
This project aims to analyse ad compare the heat losses from an open swimming pool with and without the incorporation of a transparent cover and see how much money can be saved through utilising a cover. Quite a few assumptions are introduced in the calculations, therefore the final calculated values may not be ideal or extremely accurate, however, it will still provide an insight to the suggested solution.
This project has used the weather dataset for Montreal from the months of March-May, and took advantage of MATLAB to calculate the hourly and total forced and natural convection heat transfer coefficients, corresponding resistances, reflection losses, and the Q values for convection, radiation and combined values for both with and without the presence of a sheet, all of which are presented and discussed in the following pages.

## Proposed Design

We are assuming that the swimming pool being analysed has the following specifications:
• Depth: 2m
• Surface Area: 5m X 5 m = 25 m2
• Water Temperature: 27 degrees Celsius = 300 K
• Floaters: Polyform 6" x 15" Red Buoys on the corner and middle edges
• 3-centimeter air gap between PVC sheets
//
In this project, we are trying to achieve minimal spending on raw materials which would have a greater impact towards our goal. That is why we decided to have square shaped pool, which makes it easier to manufacture the insulating sheet as well as making the calculations easier.
Since the dimension are 5mx5mx2m therefore the total volume is 50 m3. Relatively this is a smaller swimming pool but having a compact volume enables us to achieve better heat gain with less amount of heat supplied.
The density of the PVC sheet is 1600 kg/m^3. Therefore, it will sink when placed on the surface of the pool (density of water = 1000 kg/m3). So, floaters on the sides of the PVC sheet are attached in order for the sheet to stay on top of the water surface. The sheet is designed such that the first layer is of PVC, then
air and lastly PVC again. Hence, it would require 2x20mm thick PVC sheets covering 2x25m2=50m2 and 8 buoys holding the sheets afloat from 4 corners and 4 middles.
We are also assuming the desired water temperature to be 27 degrees Celsius (300 K), since most people prefer slightly warmer temperature water. According to swim university [3], the most common water temperature for residential pools for leisure is 26-28 degrees Celsius, and hence, we have decided to go with 27 degrees Celsius.

## Critical Analysis

i. Selected material properties and environmental data relevant to the problem.
We will be choosing a clear PVC sheet as our material. The material is transparent and requires minimal investment.
Where Density, ρ = 1600 kg/m3, Thermal conductivity, k = 0.16 Kwmk [4]
ii. Identification of relevant heat transfer mechanisms
In this project all three modes (taught in Mech 346) of heat transfer are active. Therefore, in the following paragraph we will discuss their roles below.
Conduction:
Conduction is mode of heat transfer in which heat moves through the material also if through the subsequent material if there is any. In our case heat can either move from the PVC sheet to the water body or from the water body to the sheet.

Convection:
In convection heat is transported through the movement of fluids. It flow direction is from hot to cold environment. For our project we will deal with convection in the medium of air. The wind and temperature difference between the sheet as well as the outside atmosphere will cause convection effects. This will either result in heat loss or gain by the water body.

Radiation:
Unlike previous heat transfer methods, radiation does not require a method to transfer heat. It is the transmission of energy through waves. This method would be the main source of heat gain in the water body. Although it should be kept in mind that not all the radiation energy emitted by the sun would absorb because of reflection of the PVC sheet as well as water.

iii. Main assumptions:
• Evaporation losses ignored
• Negligible solar absorption in the transparent material, but not negligible thermal radiation emitted and absorbed by the transparent material.
• The heat transfer through the floaters is negligible
• Radiation energy losses with the addition of sheet are ignored
• Montreal-est dataset used for the 3 months were March-May.
• Kinematic viscosity of air, v, assumed as an average constant of 1.47x10-5 m2/s [5] at 15 degrees Celsius temperature (considered average temperature during March-May) for easier manipulation of our code.
• Prandtl number of air, Pr, assumed as an average constant of 0.7323 [5] at 15 degrees Celsius temperature (considered average temperature during March-May) for easier manipulation of our code.
• Thermal Conductivity of air, k, 0.02476 W/m-K [5] assumed as an average constant of 0.7323 at 15 degrees Celsius temperature (considered average temperature during March-May) for easier manipulation of our code.
• Critical Reynold’s number =5x105

## iv. Equations
Without the sheet

Natural Convection Loss:
In order to find the find the convection loss we had to develop an algorithm which would extract the necessary weather data such as wind speed and temperature of our selected area. This information was utilized to find the natural convection factors and forced convection factors. In the passage below we will do a sample calculation in order to illustrate the MATLAB code.
For natural convection, Tfilm=Tw+Tsky2 Gr = g×(1Tfilm×(Tw−Tsky)×lc3(υ)2) Ralc = Gr ×𝑃𝑟𝑎𝑖𝑟
Note: we assume the value of υ to be constant. It is calculated at 15 degrees Celsius.
After we compute the Ra value, a condition was enforced in order to utilize the correct formula for finding the Nusselt number according to the value.
if 1E4 < Ralc(i) && Ralc(i) <1E7
Nulc(i) = 0.54 * Ralc(i)^0.25.
elseif 1E7 < Ralc(i) && Ralc(i) <1E11
Nulc(i) = 0.15 * Ralc(i)^ (1/3);
End

Moving on we then find the H coefficient and the power lost due to natural convection hnconv = Nulc×kairlc Qnconv = hnconv×A×(Tw−Tsky)
Forced Convection Loss:
In this part we begin by calculating the Reynolds number with help of wind speed data

𝑅𝑒=𝑈∞𝑙𝑐υ
Next according to the value of Reynolds number we apply the formula to find the Nusselt number which eventually leads us to get h, just like how we calculated in natural convection.
Re(i) = wind(i)*lc/vair;% Re #
if Re(i) > 5E5 % check for Laminar or Turbulent flow
Nu_lf(i) = 0.664*Recr^0.5*Prair^(1/3)+0.037*Re(i).^0.8*Prair^(1/3)*(1-(Recr/Re(i)).^0.8);% Nu # for turbulent flow
else
Nu_lf(i) = 0.664*Re(i).^0.5*Prair^(1/3);% Nu# for laminar flow
hfconv = Nulf×kairlc Qfconv = hfconv×A×(Tw−Tsky)
