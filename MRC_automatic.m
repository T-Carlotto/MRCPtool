% *************************************************************************
%  Automated method of creating MRCs
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
%        method: vector of strings containing the names of the methods in use (when they are simulated MRCs)
%        ifi: index identifier of the method to be used (position of the vector method)
%        ir:  MRC Index.
% OUTPUTS: 
%        Pont_min_Recess: array of n rows by 3 columns 
%                        column 1: Coordinate x of the point of least value
%                        column 2: Coordinate y of the point of least value
%                        column 3: Event number
%        sort_min_Recess: array of n rows by 3 columns 
%                        column 1: are the x-coordinates of the minimum value point;
%                        column 2: are the y-coordinates of the minimum value point;
%                        column 3: are the numbers corresponding to the events to which the minimum value belongs


function [MatAdj,coord_recess,Pont_min_Recess,sort_min_Recess] = MRC_automatic(method,ifi,ir)

    
%% Assembly of the vector with the minimum values of each recession; 
iter = length(dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir)]))-2;
Pont_min_Recess = [];
soma_dim_recess = 0;
for j = 1:iter
    load(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\Recess_',num2str(j)],'coordenadas','coordenadas_b'); 
    soma_dim_recess = soma_dim_recess + length(coordenadas); 
     for j1 = 1: length(coordenadas)
         if coordenadas(j1,2) == min(coordenadas(:,2))
            Pont_min_Recess(j,1) = coordenadas(j1,1);  % Coordinate x of the point of least value 
            Pont_min_Recess(j,2) = coordenadas(j1,2);  % Coordinate y of the point of least value
            Pont_min_Recess(j,3) = j;                  % Event number
         end
     end
    
end
as = size(Pont_min_Recess,1);

if as>0
sort_min_Recess = zeros(as,3);    % Memory Allocation

%sort_min_Recess(:,2) = sort(Pont_min_Recess(:,2));     % Increasing ordering by the minimum values of each recession

sort_min_Recess = sortrows(Pont_min_Recess,2);   % Increasing ordering by the minimum values of each recession

sort_min_Recess(sort_min_Recess(:,3)==0,:) =  [];

% sort_min_Recess result is an array of n rows by 3 columns 
% column 1 are the x-coordinates;
% column 2 are the y-coordinates;
% column 3 are the numbers corresponding to the events to which the minimum value belongs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% =========================================================================
% Determination of the beginning and end of each recession.

dim1 = 0;
dcont = 1;

for i = 1:as   
    n = sort_min_Recess(i,3);
   % n2 = sort_min_Recess(i+1,3);
    load(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\Recess_',num2str(n)],'coordenadas','coordenadas_b');
    dim1 = dim1+length(coordenadas);   
    coord1 = coordenadas; 
    coord1_b = coordenadas_b;
    
    ordem_curv(dcont:dim1,1) = dcont:1:dim1;
    ordem_curv(dcont:dim1,2) = coord1(:,2); 
    ordem_curv(dcont:dim1,3) = n; 
    
    ordem_curv_b(dcont:dim1,1) = dcont:1:dim1;
    ordem_curv_b(dcont:dim1,2) = coord1_b(:,2); 
    ordem_curv_b(dcont:dim1,3) = n; 
    
    dim1 = length(ordem_curv);        
    dcont = length(ordem_curv)+1;      
    pos(i,1) = dim1;   
    %    
end

pos1 = zeros(length(pos)+1,1);
pos1(1,1) = 1;
pos1(2:end,1) = pos;
posicao = zeros(length(pos1)-1,2);
posicao(:,1) = pos1(1:end-1,1);
posicao(:,2) = pos1(2:end,1);
ordem_curv11 = ordem_curv;
quant =size(posicao,1)-1;

mud = quant;
if size(posicao,1) > 2
mnum = quant-1;
else
mnum = 1; 
mud = 2;
end

for j = 1:mnum
mud=mud-1;
   for i = mud:quant   %
       
    dist_temp = sqrt((((ordem_curv11(posicao(i,1):posicao(i,2),1)) - max(ordem_curv11(posicao(i+1,1)+1:posicao(i+1,2),1))).^2)+((ordem_curv11(posicao(i,1):posicao(i,2),2)) - min(ordem_curv11(posicao(i+1,1)+1:posicao(i+1,2),2))).^2);   
  
    process = 1; 
    dist_min=0;
    b=1;
    cont = 0;   
    
       while process>=0 
        a=b;
          cont=cont+1;   
          b = sqrt((((ordem_curv11(posicao(i,1):posicao(i,2),1)) - max(ordem_curv11(posicao(i+1,1)+1:posicao(i+1,2),1))).^2)+((ordem_curv11(posicao(i,1):posicao(i,2),2)) - min(ordem_curv11(posicao(i+1,1)+1:posicao(i+1,2),2))).^2);    
            dist_min(cont) = min(b);               
           % ordem_curv11(1+posicao(i,1):posicao(i,2),1) = ordem_curv11(1+posicao(i,1):posicao(i,2),1) + 1;          
             ordem_curv11(posicao(1,1):posicao(i,2),1) = ordem_curv11(posicao(1,1):posicao(i,2),1) + 1;

          if cont>1           
             cres = a-b;   
             process = max(cres(cres>0));             
          end           
       end                
       dist_min1 = min(dist_min);         
       
      while min(sqrt((((ordem_curv(posicao(i,1):posicao(i,2),1)) - max(ordem_curv(posicao(i+1,1)+1:posicao(i+1,2),1))).^2)+((ordem_curv(posicao(i,1):posicao(i,2),2)) - min(ordem_curv(posicao(i+1,1)+1:posicao(i+1,2),2))).^2)) > dist_min1            
           
          if j ~= quant-1  
              
                 %ordem_curv(1+posicao(i,1):posicao(i,2),1) = ordem_curv(1+posicao(i,1):posicao(i,2),1)+1;   
                 ordem_curv(posicao(1,1):posicao(i,2),1) = ordem_curv(posicao(1,1):posicao(i,2),1)+1;        
                
                 %ordem_curv_b(1+posicao(i,1):posicao(i,2),1) = ordem_curv(1+posicao(i,1):posicao(i,2),1)+1;  
                 ordem_curv_b(posicao(1,1):posicao(i,2),1) = ordem_curv(posicao(1,1):posicao(i,2),1)+1;
          else            
                ordem_curv(1:posicao(i,2),1) = ordem_curv(1:posicao(i,2),1)+1;   
                        
                ordem_curv_b(1:posicao(i,2),1) = ordem_curv(1:posicao(i,2),1)+1;             
          end         
      end        
   end
   
% MRC Assembly View  
%  %gplot(MatAdj,ordem_curv);
%   plot(ordem_curv(:,1),ordem_curv(:,2),'k.');
%   set(gca,'YScale','log')   
%   pause(0.0000001)  
 
end

ordem_curv(:,1) = ordem_curv(:,1)-min(ordem_curv(:,1));

 
    %% ==========================================================================
    %         Saving recessions for each event (positioned in the MRC)
    %% ==========================================================================
    for sep = 1:as
        
       dim_rec = length(ordem_curv(ordem_curv(:,3)==sep));
       
       coordenadas = zeros(dim_rec,2);
       coordenadas_b = zeros(dim_rec,2);       
       
       coordenadas(:,1) = ordem_curv(ordem_curv(:,3)==sep,1); 
       coordenadas(:,2) = ordem_curv(ordem_curv(:,3)==sep,2);
         
       coordenadas_b(:,1) = ordem_curv_b(ordem_curv(:,3)==sep,1); 
       coordenadas_b(:,2) = ordem_curv_b(ordem_curv(:,3)==sep,2);
          
       save(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\Recess_',num2str(sep)],'coordenadas','coordenadas_b')
                     
    end
%end
end
