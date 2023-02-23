% *************************************************************************
%                         Chapman's numeric filter
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
%
%  OUTPUTS:     
%      Qchapman: Baseflow;

function [Qchapman] = chapman(dados,a,hObject, eventdata, handles)

%% Selection of entries
%Precipt = dados(:,2);
Q = dados(:,1);
%% =======================================
%%               3-point moving average
%% 
med_on=0;
if med_on==1
n = 5; % number of 3-point moving average applications
Qtot = Q';
Qajust = (Qtot(1:length(Qtot)) + [Qtot(1) Qtot(1:length(Qtot)-1)] + [Qtot(2:length(Qtot)) Qtot(length(Qtot))])/3;
% ========================================
for i =1:n
Qtot = Qajust;
Qajust = (Qtot(1:length(Qtot)) + [Qtot(1) Qtot(1:length(Qtot)-1)] + [Qtot(2:length(Qtot)) Qtot(length(Qtot))])/3;
end
Q = Qajust';
%==========================================
end

DIM = length(Q);                                                                                                     %dt = intervalo de tempo entre a primeira e a última observação
                                                                                                   % de uma série;
%Memory Allocation
Qchapman = zeros(DIM,1);
%==========================

%%                                                                                  
Qchapman(1,1) = Q(1); 

for i = 2:DIM
        
    if isnan(Q(i))
        ChapQcalc(i,1) = nan;
    else 
        ChapQ1 = (a/(2-a))*Qchapman(i-1,1) + ((1-a)/(2-a))*Q(i);        
        if ChapQ1 > Q(i)
            Qchapman(i,1)= Q(i);
        else            
            Qchapman(i,1) = ChapQ1;%(a/(2-a))*Qchapman(i-1,1) + ((1-a)/(2-a))*Q(i);    
        end
    end
end


%title('Chapman's filter');
%legend('Streamflow', 'Baseflow')

%xticklabel_rotate ([1:1:length(Q)], 90, TXT(2:length(TXT),1));

% Streamflow
%figure(2)
%x = Q;
%ts1 = timeseries(x,1:length(Q));
%ts1.Name = 'Daily Count';
%ts1.TimeInfo.Units = 'minutes';
%ts1.TimeInfo.StartDate = '01-Jan-2011';     % Set start date.
%ts1.TimeInfo.Format = 'dd/mmm/yyyy';       % Set format for display on x-axis.
%ts1.Time = ts1.Time- ts1.Time(1);         % Express time relative to the start date.
%plot(ts1)


end