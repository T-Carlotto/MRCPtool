% *************************************************************************
%  Data Fit Functions
% *************************************************************************
% Authors: Tomas Carlotto and Pedro Luiz Borges Chaffe
% Developer: Tomas Carlotto
% Contact address: thomas.carl@hotmail.com
% *************************************************************************
% This code or any part of it may be used as long as the authors are cited.
% Under no circumstances will authors or copyright holders be liable for any claims,
% damages or other liability arising from the use any part of related code.
% *************************************************************************

%  Create a fit.
%  INPUTs:
%  Data for fit:
%      x1: X TIME
%      y1: Y DATA
%      opt: vector with 4 lines and 1 column (e.g.[1;0;1;0], Exponential
%      model and Coutagne model actives)
%         value: 0 - inactivo
%                1 - active
%         Line 1 - Exponential model (Q0*exp(-b*x)) 
%         Line 2 - Boussinesq model (Q0*(1+b*x).^-2)
%         Line 3 - Coutagne model ((Q0^(1-b))-(1-b)*a*x).^(1/(1-b))
%         Line 4 - Wittenberg model (Q0*((1+((1-b)*Q0^(1-b)).*x)/(a*b)).^(1/(b-1)))

%  OUTPUTS:
%      fit1 : a fit object representing the fit - model 1
%      fit2 : a fit object representing the fit - model 2
%      fit3 : a fit object representing the fit - model 3
%      fit4 : a fit object representing the fit - model 4
%      gof1 : structure with goodness-of fit info - model 1
%      gof2 : structure with goodness-of fit info - model 2
%      gof3 : structure with goodness-of fit info - model 3
%      gof4 : structure with goodness-of fit info - model 4
%
function [fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(x1, y1, opt)

fit1=[];
fit2=[];
fit3=[];
fit4=[];
gof1=[];
gof2=[];
gof3=[];
gof4=[];

%[xData, yData] = prepareCurveData(x1,y1);
xData = x1;
yData = y1;
% Set up fittype and options.
% ft = fittype( 'exp1' );
%  opts = fitoptions(ft);
%  opts.Lower = [-inf -inf];
%  opts.StartPoint = [0 0];
%  opts.Upper = [inf inf];

% func 1 - Maillet (1905)
if opt(1) == 1
 opts1 = fitoptions('Method','NonlinearLeastSquares');
 opts1.Lower =      [-inf];% -inf];
 opts1.StartPoint = [0 ];%max(yData)];
 opts1.Upper =      [inf];% inf];  
    
  ft1 = fittype(@(a, x ) max(yData)*exp(-a*x), 'independent', {'x'}, ...
          'dependent', 'y','Options',opts1); 
%  ft1 = fittype(@(a,b, x ) b*exp(-a*x), 'independent', {'x'}, ...
%        'dependent', 'y','Options',opts1);
 % Fit model to data.
[fit1, gof1] = fit(xData, yData, ft1);

end
% func 2 - Boussinesq (1905)
if opt(2) == 1
    
 %Boussinesq parameters
 opts2 = fitoptions('Method','NonlinearLeastSquares');
  opts2.Lower = [-inf ];%-inf];
  opts2.StartPoint = [0 ];%max(yData)];
  opts2.Upper = [inf ];%inf];
 
  ft2 = fittype(@(a, x ) max(yData)*(1+a*x).^-2, 'independent', {'x'}, ...
             'dependent', 'y','Options',opts2);
% ft2 = fittype(@(a,b, x ) b*(1+a*x).^-2, 'independent', {'x'}, ...
%            'dependent', 'y','Options',opts2);
 % Fit model to data.
[fit2, gof2] = fit(xData, yData, ft2);

end
 %func 3 - Coutagne (1948)
if opt(3) ==1
 % Coutagne parameters
 opts3 = fitoptions('Method','NonlinearLeastSquares');
 opts3.Lower = [0 1 ];%0];
 opts3.StartPoint = [0 1.5];% max(yData)];
 opts3.Upper = [1000 1.999];   
 
  ft3 = fittype(@(a, b, x ) ((max(yData)^(1-b))-(1-b)*a*x).^(1/(1-b)), 'independent', {'x'}, ...
              'dependent', {'y'}, 'coefficients',{'a','b'},'Options',opts3);
    
%  ft3 = fittype(@(a, b,c, x ) ((c^(1-b))-(1-b)*a*x).^(1/(1-b)), 'independent', {'x'}, ...
%               'dependent', {'y'}, 'coefficients',{'a','b','c'},'Options',opts3);
 % Fit model to data.
 [fit3, gof3] = fit(xData, yData, ft3);

end

% func 4 - Wittenberg (1999)
if opt(4) == 1
%Wittenberg parameters   
opts4 = fitoptions('Method','NonlinearLeastSquares','MaxFunEvals',1000,'MaxIter',1000);    
opts4.Lower = [0.0001 0.0001];% 0];
opts4.StartPoint = [1 0.05];% max(yData)];
opts4.Upper = [10000 0.999];% 5000]; 

 ft4 = fittype(@(a,b,x) max(yData)*(1+(((1-b)*max(yData)^(1-b)).*x./(a*b))).^(1/(b-1)), 'independent', {'x'}, ...
           'dependent', 'y','Options',opts4);

% ft4 = fittype(@(a,b,c,x) c*(1+(((1-b)*c^(1-b)).*x./(a*b))).^(1/(b-1)), 'independent', {'x'}, ...
%           'dependent', 'y','Options',opts4); % Qt=Qo[1+(b-1)*a*t]^(b/(1-b))
% %                                              c*(1+(((1-b)*c^(1-b)).*x./(a*b))).^(1/(b-1))
% Fit model to data.                         
% dmx = length(xData);
% dataxy = zeros(dmx,2);
% desc_dataxy = zeros(dmx,2);
% dataxy(:,1) = xData;
% dataxy(:,2) = yData;
% 
% for i = 1:dmx
%  desc_dataxy(i,1) = xData(end+1-i);
%  desc_dataxy(i,2) = yData(end+1-i);
% end

% xData = desc_dataxy(:,1); 
% yData = desc_dataxy(:,2); 
[fit4, gof4] = fit(xData, yData, ft4);

end


%legend( h, 'y vs. x', 'Ajuste exponencial', 'Location', 'NorthEast' );
% Label axes
%xlabel( 'x' );
%ylabel( 'y' );
%grid on


