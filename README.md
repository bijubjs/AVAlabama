# Specialty Crop Agrivoltaics in the Southeastern USA: Profitability and the Role of Rural Energy for America Program

## Authors
Bijesh Mishra<sup>1*</sup>, Ruiqing Miao<sup>1*</sup>, Ngbede Musa<sup>1</sup>, Dennis Brothers<sup>1</sup>, Madhu Khanna<sup>2</sup>, Adam N. Rabinowitz<sup>1</sup>, Paul Mwebaze<sup>2</sup>, James McCall<sup>3</sup>

<sup>1</sup>Auburn University, Auburn, AL, 36849

<sup>2</sup>University of Illinois Urbana-Champaign, Urbana, IL, 61801

<sup>3</sup>National Renewable Energy Lab, Denver, CO, 80401

<sup>*</sup>Corresponding authors: bzm0094@auburn.edu; rzm0050@auburn.edu


## Abstract
Agrivoltaic profitability in the southeastern US needs to be better understood. This study examines the profitability of tomato and strawberry agrivoltaics in Alabama. We found that reducing the Rural Energy for America Program’s coverage of capital investment of agrivoltaics from 50\% to 25\% will make agrivoltaics unprofitable.

## Keywords
Benefit-cost analysis, Climate change, Photovoltaic, Solar energy, Strawberry, Tomato

## JEL Codes
C53, C63, Q48

### How to navigate through files in the repository?
Step 1: Run and render "Simulation R25.qmd". Rendering this file generates "Simulation-R25.pdf".
Step 2: Run and render "AV Profit R25.qmd". Rendering this files generates "AV-Profit-R25.pdf". This file will generate several results inside "Results" repository.

Step 3: Repeat steps 1 and 2 for .qmd files with R50 files in the same order as above. The outcomes are similar as above for the respective steps.

You can fild data used in the modeling inside "Data" repository and results and figures generated during simulation and alnalysis in "results" and "Plots" repositories. You can delete all files inside "Results" and "Plots" repositories before running, if you wish to. Running steps 1 to 3 automatically generate deleted results and figures.

## CAPEX ($/W)
![PV CAPEX ($/W)](https://github.com/bijubjs/Agrivoltaics-alabama/blob/main/Plots/CAPEX%20Solar%20Panels.png?raw=true)
Figure: AV Capital investment cost (CAPEX).


# Tomato Agrivoltaics
## TAV Profits 2,160 Scenarios
TAV profits in the four regions of Alabama under various solar energy system configurations. The vertical axis indicates electricity price, tomato price, tomato yield, and regions of Alabama. For example, "Northern 0.5 17" on the first row means the northern region of Alabama, 50% yield of 1,360 cartons of tomatoes, and $17 per carton of tomato. The horizontal axis has PVD, solar array types, and solar panel ground clearance height (ft.). For example, "0.10 Fixed 4.6" on the first column means 10% PVD, fixed-tilt solar panels mounted 4.6 ft. above the ground. Green and red colored blocks represent profits and losses from TAVs respectively. Profits and losses increase as blocks turn darker in color.

![TAV Profits R50](https://github.com/bijubjs/Agrivoltaics-alabama/blob/main/Plots/TAV%20Profits%20CTab%20R50.png?raw=true)
Figure: TAV profit after 50% of total PV CAPEX is compensated through a REAP within six months of the initial investment.
![TAV Profits R25](https://github.com/bijubjs/Agrivoltaics-alabama/blob/main/Plots/TAV%20Profits%20CTab%20R25.png?raw=true)
Figure: TAV profit after 25\% of total PV CAPEX is compensated through a REAP within six months of the initial investment.


# Strawberry Agrivoltaics
## SBAV Profits 2,160 Scenarios
SAV profits in the four regions of Alabama under various solar energy system configurations. The vertical axis has electricity prices, strawberry prices, strawberry yield, and regions of Alabama. For example, the label, "Northern 0.5 3" on the first row represents the northern region of Alabama, strawberry yield at 50% of 3,075 buckets, and $3 per bucket strawberry. The horizontal axis has PVD, solar panel array types, and solar panel ground clearance height (ft.). For example, the label "0.10 Fixed 4.6" on the first column represents 10% PVD, fixed-tilt solar panels mounted 4.6 ft. above the ground. Green and red colored blocks represent profits and losses from TAVs respectively. Profits and losses increase as blocks turn darker in color.

![SBAV Profits R50](https://github.com/bijubjs/Agrivoltaics-alabama/blob/main/Plots/SBAV%20Profits%20Ctab%20R50.png?raw=true)
Figure: SBAV profit after 50\% of the total PV CAPEX is compensated through a REAP within six months of the initial investment.
![SBAV Profits R25](https://github.com/bijubjs/Agrivoltaics-alabama/blob/main/Plots/SBAV%20Profits%20Ctab%20R25.png?raw=true)
Figure: SBAV profit after 25\% of the total PV CAPEX is compensated through a REAP within six months of the initial investment.