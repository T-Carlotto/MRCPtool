% *************************************************************************
%  Automated way of identifying recession curves
% *************************************************************************
% Authors: Tomas Carlotto and Pedro Luiz Borges Chaffe
% Developer: Tomas Carlotto
% Contact address: thomas.carl@hotmail.com
% *************************************************************************
% This code or any part of it may be used as long as the authors are cited.
% Under no circumstances will authors or copyright holders be liable for any claims,
% damages or other liability arising from the use any part of related code.
% *************************************************************************
% INPUTS:
%          data: Matrix of n rows 2 columns, where: column 1 are the flows and 
%          column 2 are the precipitations (optional, the current version does not use);
%          D_min: minimum size of recessions (e.g. 10 days)
%          n: Number of applications of the 3-point moving average
%          
% OUTPUT   
%          recessao: matrix containing the recession curves.

%function [recessao] = ext_recess(data,T,D_min)
function [recessao] = ext_recess(data,D_min,n)

%% =======================================
load('data\data_base\matrix\input.mat');

recess = 0;            
data_b = NUM(:,1);    % Saves the ORIGINAL data;

data_b(data_b<0)=nan;

Qtot = data(:,1)';    % Total flow PROCESSED DATA 
%precipit = data(:,2); 


filtro_ruido_MM = 1; % Enables smoothing by 3rd order moving average 
filtro_ruido_SG = 0; % Enables smoothing by Savitzky-Golay

%% ========================================
%%               3-point moving average
%% ========================================
filtro_ruido_MM=1;
if filtro_ruido_MM == 1
%n = 5;                 
Qajust = (Qtot(1:length(Qtot)) + [Qtot(1) Qtot(1:length(Qtot)-1)] + [Qtot(2:length(Qtot)) Qtot(length(Qtot))])/3;

% ========================================
if n>1
for i =1:n-1
Qtot = Qajust;
Qajust = (Qtot(1:length(Qtot)) + [Qtot(1) Qtot(1:length(Qtot)-1)] + [Qtot(2:length(Qtot)) Qtot(length(Qtot))])/3;
end
end
Qtot = Qajust';

elseif filtro_ruido_SG == 1

Qtot = sgolayfilt(Qtot,3,21);
    
end
 
%% ========================================
t=1:1:length(Qtot);
n=1;
DQ(1,1) = (Qtot(n+1)-Qtot(1))/(t(n+1)-t(1));   
d=1; 
for i=n+2:length(Qtot)  
    d=d+1;
    DQ(d,1) = (Qtot(i)-Qtot(i-n))/(t(i)-t(i-n));
end
cont1=0;
evento_recess=0;
   
      for i = 1:length(DQ)              
             if DQ(i)>0  
                cont1 = 0;       
             elseif DQ(i)<0 && min(abs(DQ(i)))>0.0000000001
                cont1 = cont1+1;
             if cont1 == 1        
                evento_recess = evento_recess + 1;       
             end
             recess(cont1,evento_recess)= Qtot(i);  
             coord_desc(cont1,evento_recess) = i;
             dataBrutos_desc(cont1,evento_recess)= data_b(i,1);
             
             serie_recess(i,1) = i;
             serie_recess(i,2) = Qtot(i);
             serie_recess(i,3) = data_b(i,1);
             
             else                          
             cont1 =0;       
             end
      end  
      serie_recess(serie_recess(:,2)==0,2)=nan;
      serie_recess(serie_recess(:,3)==0,3)=nan;
 
   dimxDesc = size(recess,2);
   dimyDesc = size(recess,1);
   
   
   d=0;
   d1 = 0;
   d2 = 0;
   d3 = 0;
   d4 = 0;
   d5 = 0;
%===============================

%%
   if (dimxDesc>1 || dimyDesc>1)
      for i3 = 1:dimxDesc
       if length(recess(min(find(recess(:,i3))):max(find(recess(:,i3))),i3))>D_min % Duração mínima para cada recessões
         %if ((max(recess(min(find(recess(:,i3))):max(find(recess(:,i3))),i3)) - min(recess(min(find(recess(:,i3))):max(find(recess(:,i3))),i3)))/length(recess(min(find(recess(:,i3))):max(find(recess(:,i3))),i3)))<=T  % se a diferença entre o valor mínimo e o máximo for maior ou igual T;
           d4=d4+1;
           d5 = 0;
           
      %=========================================
            for i4 = 1:dimyDesc
               if recess(i4,i3)~=0
                  d5=d5+1;
                  recessao(d5,d4)=recess(i4,i3);
                  coord_recess(d5,d4) = coord_desc(i4,i3);
                  dataBrutos_recess(d5,d4) = dataBrutos_desc(i4,i3);
               end
            end
      %==========================================     
         %end 
       end
      end
      
      save('data\data_base\matrix\serie_recess','recessao','coord_recess','dataBrutos_recess');
   
%============================================
%% Adequacy of the dimensions of the recession vectors (raw and smoothed data)
%============================================
% ======================================
% ======================================
      if d4>1
        
         if isdir('data\data_base\Recess\')~=0        
             delete('data\data_base\Recess\*.mat');        
         else            
             mkdir('data\data_base\Recess\');        
         end
         
         if isdir('data\data_base\MRC_1\')~=0        
             delete('data\data_base\MRC_1\*.mat');        
         else            
             mkdir('data\data_base\MRC_1\');        
         end
    
         dm_len = recessao(1,recessao(1,:)~=0); % Creates a vector with the size equal to the number of recessions of class ir
      
         for is = 1:size(dm_len,2)   
               aloc = recessao(recessao(:,is)~=0,is);
               aloc_b = dataBrutos_recess(dataBrutos_recess(:,is)~=0,is);      
            if  length(aloc)>length(aloc_b)            
               curv_recessao_b = aloc_b;   
               curv_recessao = aloc(1:length(curv_recessao_b));      
            elseif  length(aloc)<length(aloc_b)      
               curv_recessao = aloc;            
               curv_recessao_b = aloc_b(1:length(curv_recessao));      
            else          
               curv_recessao = aloc;            
               curv_recessao_b = aloc_b;      
            end    
             
            %********************************************
            %        MRC data
            %********************************************
             coordenadas = zeros(length(curv_recessao),2);
             coordenadas(:,1) = [1:1:length(curv_recessao)]'; % coordinates of the x-axis
             coordenadas(:,2) = curv_recessao(:,1); % coordinates of the y-axis

             coordenadas_b = zeros(length(curv_recessao_b),2);    
             coordenadas_b(:,1) = [1:1:length(curv_recessao_b)]'; % coordinates of the x-axis
             coordenadas_b(:,2) = curv_recessao_b(:,1); % coordinates of the y-axis data without moving average  
    
             save(['data\data_base\Recess','\Recess_',num2str(is)],'coordenadas','coordenadas_b');     
             save(['data\data_base\MRC_1\Recess_',num2str(is)],'coordenadas','coordenadas_b');            
             
            %********************************************
  
         end
      end
      
   end

end 