# MRCPtool

*************************************************************************

Master Recession Curve Parameterization Tool (MRCPtool)
 
Abstract
Streamflow recession analysis is crucial for understanding how catchments release water in periods of drought and therefore is   important for water resources planning and management. Despite there being several theories on how to model recession curves, few studies compare the different approaches to that problem. In this work, we developed the Master Recession Curve Parameterization tool (MRCPtool), which brings together a set of automated methods for the analysis of recession periods based only on streamflow data. The methods include: (i) hydrograph separation using numerical filters; (ii) automatic extraction of recession periods; (iii) creation of the MRC with the matching strip method; (iv) creation of the MRC for different flow classes defined from the flow duration curve; (v) analysis of flow recession rates (-dQ/dt) as a function of flow (Q) and (vi) creation of the MRC from simulated recession curves with different analytical approaches, including linear and nonlinear models. The MRCPtool contains a graphical user interface developed in MATLAB software that facilitates the analysis of streamflow datasets.
 
     - The MRCPtool was developed in MATLAB for streamflow recession analysis.
     
     - MRCPtool brings together a set of automated resources for creating and analyzing Master Recession Curves.
     
     - MRCPtool considers different models and analytical expressions and provides comparison with graphical methods of MRCs.

*************************************************************************

Authors: Tomas Carlotto and Pedro Luiz Borges Chaffe

Developer: Tomas Carlotto

Contact address: thomas.carl@hotmail.com

*************************************************************************

This code or any part of it may be used as long as the authors are cited.
To cite MRCPtool use the article available at: 
https://www.sciencedirect.com/science/article/pii/S0098300419301025
Under no circumstances will authors or copyright holders be liable for any claims,
damages or other liability arising from the use any part of related code.

*************************************************************************
  This code uses the following subfunctions:
  
           MRC_automatic.m   - Automated method of creating MRCs
           
           ext_recess.m      - Automated way of identifying recession curves
           
           sort_min_val.m    - It organizes the recession curves in ascending 
                               order by the minimum values
                               
           FDC.m             - MRC Separation Tool using Flow duration curve
           
           filter_guide.m    - Numerical Filters for Hydrographs Separation
           
           createFit          - data fit functions

**************************************************************************

To use MRCPtool use the "guide" command (without quotes) at the MATLAB prompt and select MRC.fig (in the file directory).
The file ward.xlsx shows how data should be organized for analysis with MRCPtool and can be used to test or resources available tool

For more details about MRCPtool access the article available at:
https://www.sciencedirect.com/science/article/pii/S0098300419301025
