% *************************************************************************
%                         Eckhardt's numeric filter
% *************************************************************************
% Authors: Tomas Carlotto and Pedro Luiz Borges Chaffe
% Developer: Tomas Carlotto
% Contact address: thomas.carl@hotmail.com
% *************************************************************************
% This code or any part of it may be used as long as the authors are cited.
% Under no circumstances will authors or copyright holders be liable for any claims,
% damages or other liability arising from the use any part of related code.
% *************************************************************************
%  INPUTS:
%      data: Matrix of n rows 2 columns, where: column 1 are the flows and 
%            column 2 are the precipitations (optional, the current version does not use);
%      a: parameter (exp(-dt/K))
%      (hObject, eventdata, handles): connection functions for the interface;
%      BFImax: Maximum base flow index
%  OUTPUTS:     
%      EckCalMat: Baseflow;

function [EckCalMat] = Eckhardt(dados,a,BFImax,hObject, eventdata, handles)

%Selection of entries
%Precipt = dados(:,2);
Q = dados(:,1);
%============================================
%% =======================================
%%               3-point moving average
%% =======================================
med_on=0;
if med_on == 1
n = 5; % Number of 3-point moving average applications
Qtot = Q';
Qajust = (Qtot(1:length(Qtot)) + [Qtot(1) Qtot(1:length(Qtot)-1)] + [Qtot(2:length(Qtot)) Qtot(length(Qtot))])/3;
% ========================================
for i =1:n
Qtot = Qajust;
Qajust = (Qtot(1:length(Qtot)) + [Qtot(1) Qtot(1:length(Qtot)-1)] + [Qtot(2:length(Qtot)) Qtot(length(Qtot))])/3;
end
Q = Qajust';
end
%==========================================

DIM = length(Q); % 

%% Eckhardt

EckCalMat = zeros(DIM,1);

EckCalMat(1,1) = Q(1);
for ii=2:DIM    
        
    if isnan(Q(ii))
        EckCalMat(ii,1) = NaN;
    else
        EckCal1 = (((1-BFImax).*a.*EckCalMat(ii-1,1))+((1-a).*BFImax.*Q(ii))) ./ (1-(a.*BFImax));
        if EckCal1 <= Q(ii)
            EckCalMat(ii,1) = EckCal1;%(((1-BFImax).*a.*EckCalMat(ii-1,1))+((1-a).*BFImax.*Q(ii))) ./ (1-(a.*BFImax));
        else
            EckCalMat(ii,1) = Q(ii);
        end
    end    
end



end
