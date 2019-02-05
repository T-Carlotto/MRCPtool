# MRCPtool

% *************************************************************************

%  Master Recession Curve Parameterization Tool (MRCPtool)

% *************************************************************************

% Authors: Tomas Carlotto and Pedro Luiz Borges Chaffe
% Developer: Tomas Carlotto
% Contact address: thomas.carl@hotmail.com

% *************************************************************************

% This code or any part of it may be used as long as the authors are cited.
% Under no circumstances will authors or copyright holders be liable for any claims,
% damages or other liability arising from the use any part of related code.

% *************************************************************************

%  This code uses the following subfunctions:
%           MRC_automatic.m   - Automated method of creating MRCs
%           ext_recess.m      - Automated way of identifying recession curves
%           sort_min_val.m    - It organizes the recession curves in ascending 
%                               order by the minimum values
%           FDC.m             - MRC Separation Tool using Flow duration curve
%           filter_guide.m    - Numerical Filters for Hydrographs Separation
%           creatFit          - data fit functions

% **************************************************************************

To use MRCPtool use the "guide" command (without quotes) at the MATLAB prompt and select MRC.fig (in the file directory).
The file ward.xlsx shows how data should be organized for analysis with MRCPtool and can be used to test or resources available tool
