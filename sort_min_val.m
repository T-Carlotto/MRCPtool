% *************************************************************************
%  It organizes the recession curves in ascending order by the minimum values
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
%        sort_min_Recess: array of n rows by 4 columns 
%                        column 1: are the x-coordinates of the minimum value point;
%                        column 2: are the y-coordinates of the minimum value point;
%                        column 3: are the numbers corresponding to the events to which the minimum value belongs
%                        column 4 are the y-coordinates of the minimum value point(Raw data)
function [sort_min_Recess] = sort_min_val(method,ifi,ir)


% iter is the number of recession files contained in the MRC directory
iter = length(dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir)]))-2;
%% Montagem do vetor com os mínimos valores de cada recessão; 
mut = 0;
soma_dim_recess = 0;
Pont_min_Recess = [];
for j = 1:iter
    load(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\Recess_',num2str(j)],'coordenadas','coordenadas_b'); 
   % soma_dim_recess = soma_dim_recess + length(coordenadas); 
     for j1 = 1: length(coordenadas)
         if coordenadas(j1,2) == min(coordenadas(:,2))
            Pont_min_Recess(j,1) = coordenadas(j1,1);  % Coordinate x of the minimum value point 
            Pont_min_Recess(j,2) = coordenadas(j1,2);  % Coordinate y of the minimum value point
            Pont_min_Recess(j,3) = j;                  % Event number
            Pont_min_Recess(j,4) = coordenadas_b(j1,2);% Coordinate y of the minimum value point(Raw data)   
          end
     end
end

as = size(Pont_min_Recess,1);

if as>0
sort_min_Recess = zeros(as,4);    
% Increasing ordering by the minimum values of each recession
sort_min_Recess = sortrows(Pont_min_Recess,2);

mud = 0;
for j = 1:iter
    load(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\Recess_',num2str(sort_min_Recess(j,3))],'coordenadas','coordenadas_b'); 
     for j1 = 1: length(coordenadas)
         if j<iter
             if coordenadas(j1,2) >= sort_min_Recess(j,2) && coordenadas(j1,2) <= sort_min_Recess(j+1,2)
                 mud = mud+1;
                 Pont_min_Recess(mud,1) = coordenadas(j1,1);  % Coordinate x of the minimum value point 
                 Pont_min_Recess(mud,2) = coordenadas(j1,2);  % Coordinate y of the minimum value point
                 Pont_min_Recess(mud,3) = j;                  % Event number
                 Pont_min_Recess(mud,4) = coordenadas_b(j1,2);% Coordinate y of the minimum value point(Raw data) 
             end
         else
             if coordenadas(j1,2) >= sort_min_Recess(j,2) 
                 mud = mud+1;
                 Pont_min_Recess(mud,1) = coordenadas(j1,1);  
                 Pont_min_Recess(mud,2) = coordenadas(j1,2);  
                 Pont_min_Recess(mud,3) = j;                  
                 Pont_min_Recess(mud,4) = coordenadas_b(j1,2);
             end
         end
     end
end
end
sort_min_Recess = Pont_min_Recess;%sortrows(Pont_min_Recess,2);

% sort_min_Recess result is an array of n rows by 4 columns 
% column 1 are the x-coordinates of the minimum value point;
% column 2 are the y-coordinates of the minimum value point;
% column 3 are the numbers corresponding to the events to which the minimum value belongs
% column 4 are the y-coordinates of the minimum value point(Raw data)