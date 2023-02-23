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
%  This code uses the following subfunction:
%           MRC_automatic.m   - Automated method of creating MRCs
%           ext_recess.m      - Automated way of identifying recession curves
%           sort_min_val.m    - It organizes the recession curves in ascending 
%                               order by the minimum values
%           FDC.m             - MRC Separation Tool using Flow duration curve
%           filter_guide.m    - Numerical Filters for Hydrographs Separation
%           creatFit          - data fit functions
function varargout = MRC(varargin)
% MRC MATLAB code for MRC.fig
%      MRC, by itself, creates a new MRC or raises the existing
%      singleton*.
%
%      H = MRC returns the handle to a new MRC or the handle to
%      the existing singleton*.
%
%      MRC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MRC.M with the given input arguments.
%
%      MRC('Property','Value',...) creates a new MRC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MRC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MRC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MRC

% Last Modified by GUIDE v2.5 20-Aug-2020 17:59:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MRC_OpeningFcn, ...
                   'gui_OutputFcn',  @MRC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MRC is made visible.
function MRC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MRC (see VARARGIN)

% Choose default command line output for MRC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MRC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MRC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save_position.
function save_position_Callback(hObject, eventdata, handles)
% hObject    handle to save_position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
cla('reset')

val = get(handles.type_mrc,'Value');
global newVal_class
type_view_plot = get(handles.type_view_slider,'Value');
check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');
MRC = 1;

method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);

method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};

if val == 1 
    ir = 1;
    ifi = 1;
elseif val == 2 || val == 3
    ir = newVal_class;
    ifi = 1;
elseif val == 4
    ir = 1;
    ifi = method_fit_pos(newVal_class);
end

escala_x = get(handles.escala_x,'string');
escala_y = get(handles.escala_y,'string');
nome_eixo_x = get(handles.nome_eixo_x,'string');
nome_eixo_y = get(handles.nome_eixo_y,'string');
ajuste_eixo_x = get(handles.ajuste_eixo_x,'string');
ajuste_eixo_x  = str2num(char(ajuste_eixo_x ));
ajuste_eixo_y = get(handles.ajuste_eixo_y,'string');
ajuste_eixo_y  = str2num(char(ajuste_eixo_y ));

tamanho_passo = get(handles.t_passo,'string');
tamanho_passo = str2num(char(tamanho_passo));

newVal = tamanho_passo;%floor(get(hObject,'Value'));

d = dir(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir)]);
str = {d.name};    
S = get(handles.listbox1,'value');            
           if S>=3           
                for in = 1:length(dir(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir)]))                    
                    s =struct('name',d(S));
                    nome = s.name.name;                    
                if S==in
                    nome_save=nome;
                    load(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\',nome],'coordenadas','coordenadas_b')                   
                end                
                end
           end
            
 %% Alocação de memória
dim = length(coordenadas);
Mat = sparse(dim+1);
MatAdj = sparse(dim);
%% =================================

for i = 1:dim           
    Mat(i,i+1) = 1; 
end

MatAdj(1:dim,1:dim)=Mat(1:dim,1:dim);
coordenadas(:,1) = coordenadas(:,1)+ newVal;
coordenadas_b(:,1) = coordenadas_b(:,1)+ newVal;
line(ajuste_eixo_x*coordenadas(:,1),ajuste_eixo_y*coordenadas(:,2),'Color','r','LineWidth',3)
save(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\',nome_save],'coordenadas','coordenadas_b')

plot_curv_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

cla('line','reset')

check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');
MRC = 1;
method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);

global newVal_class
val = get(handles.type_mrc,'Value');
if val == 1 
    ir = 1;
    ifi = 1;
elseif val == 2 || val == 3
    ir = newVal_class;
    ifi = 1;
elseif val == 4
    ir = 1;
    ifi = method_fit_pos(newVal_class);
end

method = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};

ajuste_eixo_x = get(handles.ajuste_eixo_x,'string');
ajuste_eixo_x  = str2num(char(ajuste_eixo_x ));
ajuste_eixo_y = get(handles.ajuste_eixo_y,'string');
ajuste_eixo_y  = str2num(char(ajuste_eixo_y ));

d = dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir)]);
str = {d.name};    
S = get(handles.listbox1,'value');            
 if S>=3           
    for in = 1:length(dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir)]))                    
        s =struct('name',d(S));
        nome = s.name.name;                    
        if S==in
                    nome_save=nome;
                    load(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\',nome],'coordenadas','coordenadas_b')            
                    line(ajuste_eixo_x*coordenadas(:,1),ajuste_eixo_y*coordenadas(:,2),'Color','r','LineWidth',3)
        end                
    end          
           
    plot_curv_Callback(hObject, eventdata, handles)  
    filtroquest = questdlg('What do you want to do?', ...
	'MRC edition', ...
	'Delete recession','Moove recession','Exit');

    switch filtroquest    
        case 'Delete recession'        
            
            cont = 0;            
            s =struct('name',d(S));
            nome_del = s.name.name;            
            delete(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\',nome_del]); 
           
            d1 = dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir)]);                                   
            dimDir=length(dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir)]));
            
            mkdir('data\data_base\temp')
            
            for in = 3:dimDir               
                   cont = cont+1;                   
                   st =struct('name',d1(in));
                   nome_recess = st.name.name;                  
                   load(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\',nome_recess],'coordenadas','coordenadas_b')              
                   
                   save(['data\data_base\temp\Recess_',num2str(cont)],'coordenadas','coordenadas_b')                  
            end 
         
            delete(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\*.mat']);
            movefile('data\data_base\temp\*.mat',['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\'])          
            rmdir('data\data_base\temp')        
            
            set(handles.listbox1, 'value', 1);        
            files = dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\']);  
            set(handles.listbox1,'string',{files.name});   
            
            nv=length(dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir)]))-2;
            set(handles.text_quant_recess,'string',['N = ',num2str(nv)]);
            
            MRC_automatic(method,ifi,ir);
            
            cla('reset')
            plot_curv_Callback(hObject, eventdata, handles)
            
            [sort_min_Recess] = sort_min_val(method,ifi,ir);   

            data_fit = sortrows(sort_min_Recess,1);
 
            save('data\data_base\matrix\MRC_datafit','data_fit');
            
    
        case 'Moove recession'  
            set(handles.uipanel4,'Visible','on')            
    end

end


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Import_recess.
function Import_recess_Callback(hObject, eventdata, handles)
% hObject    handle to Import_recess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


import_quest = questdlg([' When you perform the import, the database'...
                         ' will be updated and the previous work'...
                         ' will be lost if it is not saved.'], ...
	                     ' Open', ...
	                     'Import data','Save work','Exit','Exit');
                     
ir = get(handles.ir,'string'); %MRC Class Definition
ir  = str2num(char(ir));

switch import_quest
    case 'Import data'           
        if isdir('data\data_base\MRC_',num2str(ir),'\')~=0        
             delete('data\data_base\MRC_',num2str(ir),'\*.mat');        
        else            
             mkdir('data\data_base\MRC_',num2str(ir),'\');        
        end  
        dim = length(dir('data\data_base\eventos_diff'))-2;
         for i = 1:dim
            
             load(['data\data_base\eventos_diff\evento_',num2str(i)],'curv_recessao','curv_recessao_b')
             coordenadas = zeros(length(curv_recessao),2);
             coordenadas(:,1) = [1:1:length(curv_recessao)]'; % coordinates of the x-axis 
             coordenadas(:,2) = curv_recessao(:,1); % coordinates of the y-axis
             coordenadas_b = zeros(length(curv_recessao_b),2);    
             coordenadas_b(:,1) = [1:1:length(curv_recessao_b)]'; % axis of x coordinates data without moving average
             coordenadas_b(:,2) = curv_recessao_b(:,1); % axis of y coordinates data without moving average  
    
             save(['data\data_base\MRC_',num2str(ir),'\Recess_',num2str(i)],'coordenadas','coordenadas_b')%,'coordenadas_b')
         end

             files = dir('data\data_base\MRC_',num2str(ir),'\');%fullfile(pwd,'Folder01','*.png'));
             set(handles.listbox1,'string',{files.name});
        
    case 'Save work'
            
                [caminho,dirnome] = uiputfile({'*.*',  'All Files (*.*)'});
               
                if caminho~=0
                mkdir([dirnome,caminho,'/']);
  
                tamanho = length(dir('data\data_base\MRC_',num2str(ir),'\'))-2;
              
                for i = 1 :tamanho
              
                load(['data\data_base\MRC_',num2str(ir),'\Recess_',num2str(i)],'coordenadas','coordenadas_b')
              
                save([dirnome,caminho,'\Recess_',num2str(i)],'coordenadas','coordenadas_b')
  
                end
                end
              
                     
    case 'Exit'
        
        
end

guidata(hObject, handles);


% --- Executes on button press in plot_curv.
function plot_curv_Callback(hObject, eventdata, handles)
% hObject    handle to plot_curv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');
MRC = 1;
method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);
method = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
global newVal_class
val = get(handles.type_mrc,'Value');
if val == 1 
    ir = 1;
    ifi = 1;
elseif val == 2 || val == 3
    method = {'MRC_class' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    ir = newVal_class;
    ifi = 1;
elseif val == 4
    ir = 1;
    ifi = method_fit_pos(newVal_class);
end

name_recess = get(handles.checkbox_n_recess, 'Value');

escala_x = get(handles.escala_x,'string');
escala_y = get(handles.escala_y,'string');
nome_eixo_x = get(handles.nome_eixo_x,'string');
nome_eixo_y = get(handles.nome_eixo_y,'string');
ajuste_eixo_x = get(handles.ajuste_eixo_x,'string');
ajuste_eixo_x  = str2num(char(ajuste_eixo_x ));
ajuste_eixo_y = get(handles.ajuste_eixo_y,'string');
ajuste_eixo_y  = str2num(char(ajuste_eixo_y ));
lim = length(dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir)]))-2; 

global h
hold on
maxXlim = zeros(1,lim);
maxYlim = zeros(1,lim);
minYlim = zeros(1,lim);

 for in = 1:lim          
     
   load(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\Recess_',num2str(in)],'coordenadas','coordenadas_b')        
   
   maxXlim(in) = max(ajuste_eixo_x*coordenadas(:,1));
   maxYlim(in) = max(ajuste_eixo_y*coordenadas(:,2));
   minYlim(in) = min(ajuste_eixo_y*coordenadas(:,2));
   
   if name_recess ==0       
       if ifi == 1
       h = plot(ajuste_eixo_x*coordenadas(:,1),ajuste_eixo_y*coordenadas(:,2),'Color',0.6*ones(1,3));
       legend('Original recessions')
       else
       h = plot(ajuste_eixo_x*coordenadas(:,1),ajuste_eixo_y*coordenadas(:,2),'Color',[0.2 0.6 1]);%'k');
       legend('Fit recessions')
       end
   else
       h = plot(ajuste_eixo_x*coordenadas(:,1),(ajuste_eixo_y*coordenadas(:,2)));       
   end
   maxXlim = max(maxXlim);
   maxYlim = max(maxYlim);
   minYlim = min(minYlim);   
   %pause
   axis([0 maxXlim minYlim maxYlim])
xlabel(nome_eixo_x)
ylabel(nome_eixo_y)
%text(ajuste_eixo_x*min(coordenadas(:,1)),log(ajuste_eixo_y*max(coordenadas(:,2))),num2str(in),'EdgeColor',[0 1 0])
if name_recess ==1
text(ajuste_eixo_x*min(coordenadas(:,1)),(ajuste_eixo_y*max(coordenadas(:,2))),num2str(in),'FontSize',7)
end
%%=======================================================
set(gca,'YScale',escala_y)
set(gca,'XScale',escala_x)

 end
 
                     
% --- Executes on button press in Limpar.
function Limpar_Callback(hObject, eventdata, handles)
% hObject    handle to Limpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla('reset')


% --- Executes on button press in mov_curv.
function mov_curv_Callback(hObject, eventdata, handles)
% hObject    handle to mov_curv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)%

%% Slider 1 ======================================
%numSteps = get(handles.passo,'string');
%numSteps = str2num(char(numSteps));

numSteps = 10000;

set(handles.slider1, 'Min', 1);
set(handles.slider1, 'Max', numSteps);
set(handles.slider1, 'Value', 1);
%set(handles.slider3, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1)]);

set(handles.slider1, 'SliderStep', [(1/(numSteps-1)) , (1/(numSteps-1))]);

% save the current/last slider value
handles.lastSliderVal = get(handles.slider1,'Value');
%===================================================
%===================================================
% Slider 2 =========================================

set(handles.slider2, 'Min', 1);
set(handles.slider2, 'Max', numSteps);
set(handles.slider2, 'Value',numSteps);

%set(handles.slider3, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1)]);

set(handles.slider2, 'SliderStep', [(1/(numSteps-1)) , (1/(numSteps-1))]);

% save the current/last slider value
handles.lastSliderVal = get(handles.slider2,'Value');

%%=====================================================
%======================================================

function passo_Callback(hObject, eventdata, handles)
% hObject    handle to passo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of passo as text
%        str2double(get(hObject,'String')) returns contents of passo as a double


% --- Executes during object creation, after setting all properties.
function passo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to passo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
cla('reset')

global newVal_class
val = get(handles.type_mrc,'Value');
type_view_plot = get(handles.type_view_slider,'Value');
check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');
MRC = 1;

method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);

method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};

if val == 1 
    ir = 1;
    ifi = 1;
elseif val == 2 || val == 3
    ir = newVal_class;
    ifi = 1;
elseif val == 4
    ir = 1;
    ifi = method_fit_pos(newVal_class);
end

escala_x = get(handles.escala_x,'string');
escala_y = get(handles.escala_y,'string');
nome_eixo_x = get(handles.nome_eixo_x,'string');
nome_eixo_y = get(handles.nome_eixo_y,'string');
ajuste_eixo_x = get(handles.ajuste_eixo_x,'string');
ajuste_eixo_x  = str2num(char(ajuste_eixo_x ));
ajuste_eixo_y = get(handles.ajuste_eixo_y,'string');
ajuste_eixo_y  = str2num(char(ajuste_eixo_y ));
tamanho_passo = get(handles.t_passo,'string');
tamanho_passo = str2num(char(tamanho_passo));

newVal2 = tamanho_passo;%floor(get(hObject,'Value'))


d = dir(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir)]);
str = {d.name};    
S = get(handles.listbox1,'value');            
           if S>=3           
                for in = 1:length(dir(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir)]))                    
                    s =struct('name',d(S));
                    nome = s.name.name;                    
                if S==in
                    nome_save=nome;
                    load(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\',nome],'coordenadas','coordenadas_b')            
                    
                end                
                end
           end
 
 %%
dim = length(coordenadas);
Mat = sparse(dim+1);
MatAdj = sparse(dim);
%% =================================

for i = 1:dim           
    Mat(i,i+1) = 1; 
end

MatAdj(1:dim,1:dim)=Mat(1:dim,1:dim);

coordenadas(:,1) = coordenadas(:,1)- newVal2;
coordenadas_b(:,1) = coordenadas_b(:,1)- newVal2;

line(ajuste_eixo_x*coordenadas(:,1),ajuste_eixo_y*coordenadas(:,2),'Color','r','LineWidth',3)

save(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\',nome_save],'coordenadas','coordenadas_b')

plot_curv_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function t_passo_Callback(hObject, eventdata, handles)
% hObject    handle to t_passo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_passo as text
%        str2double(get(hObject,'String')) returns contents of t_passo as a double


% --- Executes during object creation, after setting all properties.
function t_passo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_passo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function escala_y_Callback(hObject, eventdata, handles)
% hObject    handle to escala_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of escala_y as text
%        str2double(get(hObject,'String')) returns contents of escala_y as a double


% --- Executes during object creation, after setting all properties.
function escala_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to escala_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function escala_x_Callback(hObject, eventdata, handles)
% hObject    handle to escala_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of escala_x as text
%        str2double(get(hObject,'String')) returns contents of escala_x as a double


% --- Executes during object creation, after setting all properties.
function escala_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to escala_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nome_eixo_x_Callback(hObject, eventdata, handles)
% hObject    handle to nome_eixo_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nome_eixo_x as text
%        str2double(get(hObject,'String')) returns contents of nome_eixo_x as a double


% --- Executes during object creation, after setting all properties.
function nome_eixo_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nome_eixo_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nome_eixo_y_Callback(hObject, eventdata, handles)
% hObject    handle to nome_eixo_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nome_eixo_y as text
%        str2double(get(hObject,'String')) returns contents of nome_eixo_y as a double


% --- Executes during object creation, after setting all properties.
function nome_eixo_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nome_eixo_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ajuste_eixo_x_Callback(hObject, eventdata, handles)
% hObject    handle to ajuste_eixo_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ajuste_eixo_x as text
%        str2double(get(hObject,'String')) returns contents of ajuste_eixo_x as a double


% --- Executes during object creation, after setting all properties.
function ajuste_eixo_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ajuste_eixo_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ajuste_eixo_y_Callback(hObject, eventdata, handles)
% hObject    handle to ajuste_eixo_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ajuste_eixo_y as text
%        str2double(get(hObject,'String')) returns contents of ajuste_eixo_y as a double


% --- Executes during object creation, after setting all properties.
function ajuste_eixo_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ajuste_eixo_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function import_mrc_Callback(hObject, eventdata, handles)
% hObject    handle to import_mrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[dirnome] = uigetdir();
ir  = 1;
if isdir(['data\data_base\MRC_',num2str(ir),'\'])~=0
delete(['data\data_base\MRC_',num2str(ir),'\*.mat']);
else
mkdir(['data\data_base\MRC_',num2str(ir),'\'])
end

if isdir('data\data_base\matrix\')~=0
delete('data\data_base\matrix\*.mat');
elseif isdir ('data\data_base\matrix') == 0
mkdir ('data\data_base\matrix'); 
end

  if dirnome~=0
  tamanho = length(dir(dirnome))-2;           
  for i = 1 :tamanho           
  load([dirnome,'\Recess_',num2str(i)])            
  save(['data\data_base\MRC_',num2str(ir),'\Recess_',num2str(i)],'coordenadas','coordenadas_b')
  end
  files = dir([dirnome,'/']);%fullfile(pwd,'Folder01','*.png'));
  set(handles.listbox1,'string',{files.name});
  nv=length(dir(['data\data_base\MRC_',num2str(ir)]))-2;
  set(handles.text_quant_recess,'string',['N = ',num2str(nv)]);
  end


% --------------------------------------------------------------------
function export_mrc_Callback(hObject, eventdata, handles)
% hObject    handle to export_mrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global newVal_class
val = get(handles.type_mrc,'Value');
check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');
MRC = 1;
method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);
method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};

if val == 1 
    ir = 1;
    ifi = 1;
elseif val == 2 || val == 3
    method_name = {'MRC_class' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    ir = newVal_class;
    ifi = 1;
elseif val == 4
    ir = 1;
    ifi = method_fit_pos(newVal_class);
end

[caminho,dirnome] = uiputfile({'*.*',  'All Files (*.*)'});
if caminho~=0
    mkdir([dirnome,caminho,'/']);
    tamanho = length(dir(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\']))-2;
    for i = 1 :tamanho
        load(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\Recess_',num2str(i)],'coordenadas','coordenadas_b')
        save([dirnome,caminho,'\Recess_',num2str(i)],'coordenadas','coordenadas_b')
    end
    
end



% --------------------------------------------------------------------
function tools_Callback(hObject, eventdata, handles)
% hObject    handle to tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in gerar_linha_mestra.
function gerar_linha_mestra_Callback(hObject, eventdata, handles)
% hObject    handle to gerar_linha_mestra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gerar_linha_mestra


% --- Executes on button press in MRC_auto.
function MRC_auto_Callback(hObject, eventdata, handles)
% hObject    handle to MRC_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%str = get(hObject, 'String');
%val = get(hObject,'Value');

check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');

check_editFigure = get(handles.check_editFigures,'Value');

MRC = 1;
method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);

global newVal_class 
global h

val = get(handles.type_mrc,'Value');
if val == 1 
    ir = 1;
    ifi = 1;
elseif val == 2 
    ir = newVal_class;
    ifi = 1;
elseif val == 3
    ir = 1;
    ifi = 1;
elseif val == 4        
    ir = 1;
    %ifi = method_fit_pos(newVal_class);
end

method = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};

escala_x = get(handles.escala_x,'string');
escala_y = get(handles.escala_y,'string');
nome_eixo_x = get(handles.nome_eixo_x,'string');
nome_eixo_y = get(handles.nome_eixo_y,'string');
ajuste_eixo_x = get(handles.ajuste_eixo_x,'string');
ajuste_eixo_x  = str2num(char(ajuste_eixo_x ));
ajuste_eixo_y = get(handles.ajuste_eixo_y,'string');
ajuste_eixo_y  = str2num(char(ajuste_eixo_y ));

if val == 1    
%ir = 1;
cla('reset');
MRC_automatic(method,ifi,ir);

if check_editFigure ==1
    figure
end
plot_curv_Callback(hObject, eventdata, handles)


files = dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\']);                                   %fullfile(pwd,'Folder01','*.png'));
set(handles.listbox1,'string',{files.name});
    
check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');

[sort_min_Recess] = sort_min_val(method,ifi,ir);     

opt= [check_Maillet;check_Boussinesq;check_Coutagne;check_Wittenberg];

data_fit = sortrows(sort_min_Recess,1);
save('data\data_base\matrix\MRC_datafit','data_fit');

tdata = ajuste_eixo_x*data_fit(:,1)-min(ajuste_eixo_x*data_fit(:,1));%ajuste_eixo_x*[0:size(data_fit,1)-1]';
plot_tdata = ajuste_eixo_x*data_fit(:,1);
ydata = ajuste_eixo_y*data_fit(:,2);
Q0 = max(ydata);
%[fitresult,pontos_x,pontos_y]=ajuste_curva_MRC(ajuste_eixo_x*sort_min_Recess(:,1),ajuste_eixo_y*(sort_min_Recess(:,2)));
%[fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(ajuste_eixo_x*sort_min_Recess(:,1),ajuste_eixo_y*(sort_min_Recess(:,2)),opt);


[fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(tdata,ydata,opt);
%[fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(tdata,ydata,opt);

% [fitresult,pontos_x,pontos_y]=ajuste_curva_MRC(ajuste_eixo_x*sort_min_Recess(:,1),ajuste_eixo_y*(sort_min_Recess(:,2)));
% [fitresult, gof] = createFit(ajuste_eixo_x*sort_min_Recess(:,1),ajuste_eixo_y*(sort_min_Recess(:,2)));

% data_fit = sortrows(sort_min_Recess,1);
% tdata = ajuste_eixo_x*[0:size(data_fit,1)-1]';
% 
% plot_tdata = ajuste_eixo_x*data_fit(:,1);
% ydata = ajuste_eixo_y*data_fit(:,2);

% % Coutagne (1948) - RMSE
% fun = @(x)Coutagne_rmse(x,tdata,ydata);
% x0 = rand(2,1);
% bestx = fminsearch(fun,x0);
% 
% % %======================================
% A = bestx(1)
% lambda = bestx(2)
% yfit = (max(ydata).^(1-A)-(1-A)*lambda*tdata).^(1/(1-A));
% plot(plot_tdata,ydata,'k.');
% hold on
% plot(plot_tdata,yfit,'g','LineWidth',2);

% %======================================

%Wittenberg (1999) - RMSE
% fun2 = @(x)Wittenberg_rmse(x,tdata,ydata);
% x0 = rand(2,1);
% bestx = fminsearch(fun2,x0);
% %=====================
% d = bestx(1);
% c = bestx(2);
% yfit2 = max(ydata)*(1+((1-d)*max(ydata)^(1-d)).*tdata/(c*d)).^(1/(d-1));
% plot(plot_tdata,ydata,'k.');
% hold on
% plot(plot_tdata,yfit2,'b--');

Str = {};
iu =  0;
idx = ones(1,8);

mrc = plot(plot_tdata, ydata,'ro');   
%mrc = plot(tdata, ydata,'r.'); 
        set(mrc,'MarkerSize',6);      
                
if check_Maillet==1

% % % Plot fit with data Maillet
a = fit1.a;
y_m = Q0*exp(-a*tdata);        
h1 = plot(plot_tdata,y_m,'c');

%h1 = plot(fit1,'c');
set(h1,'LineWidth',2);
idx = max(idx):(max(idx)+7);
% List parameters
ci = confint(fit1); %confidence bounds
Str(idx(1)) = {'>Maillet Model'};
Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  a = ',num2str(fit1.a),' ( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']};  
%Str(idx(4)) = {['  b = ',num2str(fit1.b),' ( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']};
Str(idx(4)) = {'--> Goodness-of-fit statistics'};
Str(idx(5)) = {['  The sum of squares due to error (SSE): ',num2str(gof1.sse)]};
Str(idx(6)) = {['  R-square: ',num2str(gof1.rsquare)]};
Str(idx(7)) = {['  Adjusted R-square: ',num2str(gof1.adjrsquare)]};
Str(idx(8)) = {['  Root mean squared error (RMSE): ',num2str(gof1.rmse)]};

iu = 1;
% K = - 1/alfa(2);
% Str(4) = {['  K = ',num2str(K)]};
% a = exp(-ajuste_eixo_x/K);
% A = a/(2-a);
% B = (1-a)/(2-a);
% BFImax = B/(1-A); % Eckhardt(2005) Artigo-(How to construct recursive digital filters for baseflow separation)
% Str(5) = {['  BFImax = ',num2str(BFImax)]};

end

if check_Boussinesq == 1    
% % Plot fit with data Boussinesq

 a = fit2.a;
 y_bouss = Q0*(1+a*tdata).^-2;
 h2 = plot(plot_tdata,y_bouss,'b--');
 
% h2 = plot(fit2,'b--');
 set(h2,'LineWidth',1.3);
 idx = max(idx)+iu:(max(idx)+8);
% List parameters
ci2 = confint(fit2); %confidence bounds
Str(idx(1)) = {'>Boussinesq Model'};
Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  a = ',num2str(fit2.a),' ( ', num2str(ci2(1)),' |--| ', num2str(ci2(2)),' )']};  
%Str(idx(4)) = {['  b = ',num2str(fit2.b),' ( ', num2str(ci2(3)),' |--| ', num2str(ci2(4)),' )']};
Str(idx(4)) = {'--> Goodness-of-fit statistics'};
Str(idx(5)) = {['  The sum of squares due to error (SSE): ',num2str(gof2.sse)]};
Str(idx(6)) = {['  R-square: ',num2str(gof2.rsquare)]};
Str(idx(7)) = {['  Adjusted R-square: ',num2str(gof2.adjrsquare)]};
Str(idx(8)) = {['  Root mean squared error (RMSE): ',num2str(gof2.rmse)]};
iu=1;
end

if check_Coutagne == 1
% % Plot fit with data Coutagne

 Coutagne_par_a= fit3.a;
 Coutagne_par_b= fit3.b;
 y_cout =((Q0^(1-Coutagne_par_b))-(1-Coutagne_par_b)*Coutagne_par_a*tdata).^(1/(1-Coutagne_par_b));
 h3 = plot(plot_tdata,y_cout,'g');
 
%h3 = plot(fit3,'g');
 set(h3,'LineWidth',3);
 idx = max(idx)+iu:(max(idx)+9);
% List parameters
ci3 = confint(fit3); %confidence bounds
Str(idx(1)) = {'>Coutagne Model'};
Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  a = ',num2str(fit3.a),' ( ', num2str(ci3(1)),' |--| ', num2str(ci3(2)),' )']};  
Str(idx(4)) = {['  b = ',num2str(fit3.b),' ( ', num2str(ci3(3)),' |--| ', num2str(ci3(4)),' )']};
Str(idx(5)) = {'--> Goodness-of-fit statistics'};
Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof3.sse)]};
Str(idx(7)) = {['  R-square: ',num2str(gof3.rsquare)]};
Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof3.adjrsquare)]};
Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof3.rmse)]};
iu = 1;
end

if check_Wittenberg == 1
% %Plot fit with data Wittenberg

Witt_par_a=fit4.a;
Witt_par_b=fit4.b;             
Wittenberg_Q =  Q0*(1+((1-Witt_par_b)*Q0^(1-Witt_par_b)).*tdata./(Witt_par_a*Witt_par_b)).^(1/(Witt_par_b-1));
h4 = plot(plot_tdata,Wittenberg_Q,'m--');

% h4 = plot(fit4,'m--');
 set(h4,'LineWidth',1.3);  
 idx = max(idx)+iu:(max(idx)+9);
% List parameters
ci4 = confint(fit4); %confidence bounds
Str(idx(1)) = {'>Wittenberg Model'};
Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  a = ',num2str(fit4.a),' ( ', num2str(ci4(1)),' |--| ', num2str(ci4(2)),' )']};  
Str(idx(4)) = {['  b = ',num2str(fit4.b),' ( ', num2str(ci4(3)),' |--| ', num2str(ci4(4)),' )']};
Str(idx(5)) = {'--> Goodness-of-fit statistics'};
Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof4.sse)]};
Str(idx(7)) = {['  R-square: ',num2str(gof4.rsquare)]};
Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof4.adjrsquare)]};
Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof4.rmse)]};
end

set(handles.listbox1,'Enable','on')
set(handles.list_parameters,'string',Str);
%%=======================================================
xlabel(nome_eixo_x)
ylabel(nome_eixo_y) 
set(gca,'YScale',escala_y)
set(gca,'XScale',escala_x)

% Creation of graphics captions
MRC = 1;
fit_select = [MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg];
fit_def = [h mrc];
fit_name_str = {'Recession Curves'};
fit_name_str = [fit_name_str {'MRC Data'}];
if fit_select(2)==1
    fit_def = [fit_def h1];
    fit_name_str = [fit_name_str,{'Fit Maillet'}];
end
if fit_select(3)==1
    fit_def = [fit_def h2];
    fit_name_str = [fit_name_str,{'Fit Boussinesq'}];
end
if fit_select(4)==1
    fit_def = [fit_def h3];
    fit_name_str = [fit_name_str,{'Fit Coutagne'}];
end
if fit_select(5)==1
    fit_def = [fit_def h4];
    fit_name_str = [fit_name_str,{'Fit Wittenberg'}];
end
legend(fit_def,fit_name_str)             


elseif val == 2     
set(handles.popup_view,'Value',1)
FDC                            % Call of the MRC Classification GUI
global n_class;
nameClass = {num2str(zeros(1,n_class))};
for icl = 1:n_class
    nameClass(icl) = {['Class_',num2str(icl)]};
end
set(handles.popup_view,'String',nameClass)

elseif val == 3    
    
ir = 1;
dimDir=length(dir(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir)]))-2;
cla('reset')

if check_editFigure ==1
    figure
end

MRC_automatic(method,ifi,ir);
[sort_min_Recess] = sort_min_val(method,ifi,ir);     
data_fit = sortrows(sort_min_Recess,1);

hold on
vetQ = [];
vetdQ = [];
for it = 1:dimDir   
    load(['data\data_base\',char(cell(method(ifi))),'_',num2str(ir),'\Recess_',num2str(it),'.mat'],'coordenadas','coordenadas_b');
    pos =find(coordenadas(:,2));    
    Q =  coordenadas(pos,2);
    Qm = (Q(1:end-1)+Q(2:end))/2;
    dQ = diff(coordenadas(pos,2));
    vetQ = [vetQ;Qm(1:end)];
    vetdQ = [vetdQ;dQ];
end

% =============================================================
% Data Binning (Kirchner 2009) - Saúl Arciniega-Esparza (2017)
% =============================================================
    Qbin=sortrows([log10(-vetdQ) log10(vetQ)],-2); % Sort the data to get the bins
    pbin=ceil(size(Qbin,1)*0.01); %number of elements in each range of percentage values
    BIN=[];
    while size(Qbin,1)>0
        try
           BIN=[BIN; mean(Qbin(1:pbin,:))]; %Determination of intermediate BINs
           Qbin(1:pbin,:)=[]; % Exclude the data from which the BINs were obtained
        catch mensaje
            if size(Qbin,1)>1
                BIN=[BIN; mean(Qbin)]; %BINs of the last values
            end
           Qbin=[]; 
        end
    end
    BIN(end,:)=[];
    D=[(1:size(BIN,1))' -10.^(BIN(:,1)) 10.^(BIN(:,2))]; %matrix of bins
    REC=D; %save BINS   
%%

%load('data\data_base\matrix\MRC_datafit.mat');
mrc = data_fit(:,2);
diffmrc1 = diff(mrc);
mrcdata = mrc(diffmrc1~=0 & diffmrc1<0); % Eliminating zero derivatives and greater than 0;
diffmrcdata = diff(mrcdata);

% Linear regression
% Defining log10 (Q) and log (-dQ) values of the BINs
xbins = log10(REC(:,3));
ybins = log10(REC(:,2));

% Defining log10 (Q) and log (-dQ) values of the MRC
xmrc = log10((mrcdata(1:end-1)+mrcdata(2:end))/2);
ymrc = log10(-diffmrcdata);

% Defining log10 (Q) and log (-dQ) values of the set of all recessions
vetQ = log10(vetQ);
vetdQ = log10(-vetdQ);

hold on
plot(vetQ,vetdQ,'k.','Color',0.6*ones(1,3))

% Plot MRC data
mrc_p = plot(xmrc,ymrc,'ro');
set(mrc_p,'MarkerSize',6);

%Plot BINs data
bins_p = plot(xbins,ybins,'ksquare');
set(bins_p,'MarkerSize',6);
set(bins_p,'MarkerFaceColor',[0 0 0]);


opts3 = fitoptions('Method','NonlinearLeastSquares');
opts3.Lower = [-inf -inf ];
opts3.StartPoint = [0 0];
opts3.Upper = [inf inf];    
ft3 = fittype(@(b, a, x ) b*x + a, 'independent', {'x'}, ...
              'dependent', {'y'}, 'coefficients',{'b','a'},'Options',opts3);

% Fit model to data.
[fit_t, gof_t] = fit(vetQ, vetdQ, ft3);
f1 = plot(fit_t);
set(f1,'Color',0.8*ones(1,3))
set(f1,'LineWidth',3)

a = fit_t.a;
b = fit_t.b;

[fit_mrc, gof_mrc] = fit(xmrc, ymrc, ft3);
f2 = plot(fit_mrc,'r--');
set(f2,'LineWidth',1.3);

mrc_a = fit_mrc.a;
mrc_b = fit_mrc.b;

[fit_bins, gof_bins] = fit(xbins, ybins, ft3);
f3 = plot(fit_bins,'k--');
set(f3,'LineWidth',1);

bins_a = fit_bins.a;
bins_b = fit_bins.b;


xlabel('log(Q)'); ylabel('log(-dQ/dt)')
legend('Recessions (Original data)','MRC data','Data BINs','Fit Recessions (LR)','Fit MRC (LR)','Fit BINs (LR)')


Str = {};
idx = ones(1,9);

idx = max(idx):(max(idx)+8);
% List parameters
ci = confint(fit_t); %confidence bounds
Str(idx(1)) = {'> Linear Regression (all recessions)'};
Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  b = ',num2str(fit_t.b),' ( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']};  
Str(idx(4)) = {['  a = ',num2str(10^(fit_t.a)),' ( ', num2str(10^(ci(3))),' |--| ', num2str(10^(ci(4))),' )']};
Str(idx(5)) = {'--> Goodness-of-fit statistics'};
Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof_t.sse)]};
Str(idx(7)) = {['  R-square: ',num2str(gof_t.rsquare)]};
Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof_t.adjrsquare)]};
Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof_t.rmse)]};


idx = max(idx)+1:(max(idx)+9);
% List parameters
ci = confint(fit_mrc); %confidence bounds
Str(idx(1)) = {'> Linear Regression (MRC data)'};
Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  b = ',num2str(fit_mrc.b),' ( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']};  
Str(idx(4)) = {['  a = ',num2str(10^(fit_mrc.a)),' ( ', num2str(10^(ci(3))),' |--| ', num2str(10^(ci(4))),' )']};
Str(idx(5)) = {'--> Goodness-of-fit statistics'};
Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof_mrc.sse)]};
Str(idx(7)) = {['  R-square: ',num2str(gof_mrc.rsquare)]};
Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof_mrc.adjrsquare)]};
Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof_mrc.rmse)]};
set(handles.list_parameters,'string',Str); 

idx = max(idx)+1:(max(idx)+9);
% List parameters
ci = confint(fit_bins); %confidence bounds
Str(idx(1)) = {'> Linear Regression (BINs data)'};
Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  b = ',num2str(fit_bins.b),' ( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']};  
Str(idx(4)) = {['  a = ',num2str(10^(fit_bins.a)),' ( ', num2str(10^(ci(3))),' |--| ', num2str(10^(ci(4))),' )']};
Str(idx(5)) = {'--> Goodness-of-fit statistics'};
Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof_bins.sse)]};
Str(idx(7)) = {['  R-square: ',num2str(gof_bins.rsquare)]};
Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof_bins.adjrsquare)]};
Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof_bins.rmse)]};
set(handles.list_parameters,'string',Str); 

%legend('All recessions',mrc_p,'MRC data',h1,'Fit All recessions (LR)',h2,'Fit MRC (LR)')
% set(gca,'YScale','log')
% set(gca,'XScale','log') 

elseif val == 4
    

    set(handles.view_plot_text,'visible','off');
    set(handles.type_view_slider,'visible','off');
    set(handles.text_view,'visible','off');
    set(handles.popup_view,'visible','off');
        
 ir = 1;
 cla('reset');

% MRC_automatic(ir);
% plot_curv_Callback(hObject, eventdata, handles)
% files = dir(['data\data_base\MRC_',num2str(ir),'\']);                                 %fullfile(pwd,'Folder01','*.png'));
% set(handles.listbox1,'string',{files.name});
    
check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');
opt= [check_Maillet;check_Boussinesq;check_Coutagne;check_Wittenberg];

if sum(opt)>0
%ifi = method_fit_pos(newVal_class);
LenDir = length(dir(['data\data_base\MRC_',num2str(ir),'\']))-2;

if check_Maillet==1;
   if isdir(['data\data_base\Maillet_',num2str(ir),'\'])~=0
     delete(['data\data_base\Maillet_',num2str(ir),'\*.mat']);
   else
     mkdir(['data\data_base\Maillet_',num2str(ir),'\'])
   end 
end
if check_Boussinesq == 1
   if isdir(['data\data_base\Boussinesq_',num2str(ir),'\'])~=0
     delete(['data\data_base\Boussinesq_',num2str(ir),'\*.mat']);
   else
     mkdir(['data\data_base\Boussinesq_',num2str(ir),'\'])
   end 
end
if check_Coutagne == 1
   if isdir(['data\data_base\Coutagne_',num2str(ir),'\'])~=0
     delete(['data\data_base\Coutagne_',num2str(ir),'\*.mat']);
   else
     mkdir(['data\data_base\Coutagne_',num2str(ir),'\'])
   end  
end
if check_Wittenberg == 1
   if isdir(['data\data_base\Wittenberg_',num2str(ir),'\'])~=0
     delete(['data\data_base\Wittenberg_',num2str(ir),'\*.mat']);
   else
     mkdir(['data\data_base\Wittenberg_',num2str(ir),'\'])
   end
end

for isimu = 1:LenDir
   load(['data\data_base\MRC_',num2str(ir),'\Recess_',num2str(isimu)],'coordenadas','coordenadas_b')

   xrecess = ajuste_eixo_x*coordenadas(:,1)-min(ajuste_eixo_x*coordenadas(:,1));
   yrecess = ajuste_eixo_y*coordenadas(:,2);
   Q0 = max(ajuste_eixo_y*coordenadas(:,2));
   
   %plot(ajuste_eixo_x*coordenadas(:,1),ajuste_eixo_y*coordenadas(:,2))
   
   %[fitresult,pontos_x,pontos_y]=ajuste_curva_MRC(ajuste_eixo_x*sort_min_Recess(:,1),ajuste_eixo_y*(sort_min_Recess(:,2)));
   %[fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(ajuste_eixo_x*sort_min_Recess(:,1),ajuste_eixo_y*(sort_min_Recess(:,2)),opt);
   [fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(xrecess,yrecess,opt);


   % % Coutagne (1978) - RMSE
   % fun = @(x)Coutagne_rmse(x,tdata,ydata);
   % x0 = rand(2,1);
   % bestx = fminsearch(fun,x0);   
   % % %======================================
   % A = bestx(1)
   % lambda = bestx(2)
   % yfit = (max(ydata).^(1-A)-(1-A)*lambda*tdata).^(1/(1-A));
   % plot(plot_tdata,ydata,'k.');
   % hold on
   % plot(plot_tdata,yfit,'g','LineWidth',2);
   % %======================================
   %Wittenberg (1999) - RMSE
   % fun2 = @(x)Wittenberg_rmse(x,tdata,ydata);
   % x0 = rand(2,1);
   % bestx = fminsearch(fun2,x0);
   % %=====================
   % d = bestx(1);
   % c = bestx(2);
   % yfit2 = max(ydata)*(1+((1-d)*max(ydata)^(1-d)).*tdata/(c*d)).^(1/(d-1));
   % plot(plot_tdata,ydata,'k.');
   % hold on
   % plot(plot_tdata,yfit2,'b--');

   if check_Maillet==1           
   
   M_par_a = fit1.a;   
   %M_par_b = fit1.b;
     
   %M_Q = M_par_b.*exp(-M_par_a*xrecess);
   M_Q = Q0.*exp(-M_par_a*xrecess);
   coordenadas(:,1) = xrecess;
   coordenadas(:,2) = M_Q;   
   save(['data\data_base\Maillet_',num2str(ir),'\Recess_',num2str(isimu),'.mat'],'coordenadas','coordenadas_b')
   
   end
   
   if check_Boussinesq == 1    
   
   Bouss_par_a = fit2.a;   
   %Bouss_par_b = fit2.b;
   %Bouss_Q = Bouss_par_b*(1+Bouss_par_a*xrecess).^-2;
   Bouss_Q = Q0*(1+Bouss_par_a*xrecess).^-2;
   coordenadas(:,1) = xrecess;
   coordenadas(:,2) = Bouss_Q;
   save(['data\data_base\Boussinesq_',num2str(ir),'\Recess_',num2str(isimu),'.mat'],'coordenadas','coordenadas_b')
   
   end
   
   if check_Coutagne == 1        
   
   Coutagne_par_a = fit3.a;   
   Coutagne_par_b = fit3.b; 
   %Coutagne_par_c = fit3.c;
   %Coutagne_Q =((Coutagne_par_c^(1-Coutagne_par_b))-(1-Coutagne_par_b)*Coutagne_par_a*xrecess).^(1/(1-Coutagne_par_b));
   Coutagne_Q =((Q0^(1-Coutagne_par_b))-(1-Coutagne_par_b)*Coutagne_par_a*xrecess).^(1/(1-Coutagne_par_b));
   coordenadas(:,1) = xrecess;
   coordenadas(:,2) = Coutagne_Q;
   save(['data\data_base\Coutagne_',num2str(ir),'\Recess_',num2str(isimu),'.mat'],'coordenadas','coordenadas_b')    
   end
   
   if check_Wittenberg == 1  
     
   Witt_par_a = fit4.a;   
   Witt_par_b = fit4.b; 
   %Witt_par_c = fit4.c;
   %Wittenberg_Q =  Witt_par_c*(1+((1-Witt_par_b)*Witt_par_c^(1-Witt_par_b)).*xrecess./(Witt_par_a*Witt_par_b)).^(1/(Witt_par_b-1));
   Wittenberg_Q =  Q0*(1+((1-Witt_par_b)*Q0^(1-Witt_par_b)).*xrecess./(Witt_par_a*Witt_par_b)).^(1/(Witt_par_b-1));
   coordenadas(:,1) = xrecess;
   coordenadas(:,2) = Wittenberg_Q;
   save(['data\data_base\Wittenberg_',num2str(ir),'\Recess_',num2str(isimu),'.mat'],'coordenadas','coordenadas_b')    
   end
% set(handles.listbox1,'Enable','on')
% set(handles.list_parameters,'string',Str);
%%=======================================================
% xlabel(nome_eixo_x)
% ylabel(nome_eixo_y) 
% set(gca,'YScale',escala_y)
% set(gca,'XScale',escala_x) 
end
   % MRC com data originais
   ifi=1;
   MRC_automatic(method,ifi,ir); 
   
   % MRCs com data simulados
   if check_Maillet==1           
   ifi=2;
   MRC_automatic(method,ifi,ir);   
   end
   
   if check_Boussinesq == 1    
   ifi=3;
   MRC_automatic(method,ifi,ir); 
   end
   
   if check_Coutagne == 1        
   ifi=4;
   MRC_automatic(method,ifi,ir);   
   end
   
   if check_Wittenberg == 1 
   ifi=5;     
   MRC_automatic(method,ifi,ir);  
   end
  
    set(handles.view_plot_text,'visible','on');
    set(handles.type_view_slider,'visible','on');
    set(handles.text_view,'visible','on');
    set(handles.popup_view,'visible','on');
else
 msgbox(['Please check one or more available methods in "Select fit view"'],'Warning');   
end

end


% --- Executes on button press in ident_recess.
function ident_recess_Callback(hObject, eventdata, handles)
% hObject    handle to ident_recess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%=====================================================================
global newVal_class
newVal_class = 1;

if isdir('data\data_base\matrix')~=0
load('data\data_base\matrix\numeric_filter_data.mat')

nome_eixo_x = get(handles.nome_eixo_x,'string');
nome_eixo_y = get(handles.nome_eixo_y,'string');
ajuste_eixo_x = get(handles.ajuste_eixo_x,'string');
ajuste_eixo_x  = str2num(char(ajuste_eixo_x ));
ajuste_eixo_y = get(handles.ajuste_eixo_y,'string');
ajuste_eixo_y  = str2num(char(ajuste_eixo_y ));

D_min = get(handles.D_min,'string');
D_min  =str2num(char(D_min));

mov_average = get(handles.edit_mov_average,'string');
mov_average  =str2num(char(mov_average));
%MRC_class = [min(NUM(:,1)) max(NUM(:,1))];
%diff_sepEventos(NUM,T,MRC_class,D_min);
ext_recess(NUM,D_min,mov_average);

%cla('reset')
ir = 1;
nv=length(dir(['data\data_base\MRC_',num2str(ir)]))-2;
set(handles.text_quant_recess,'string',['N = ',num2str(nv)]);

load('data\data_base\matrix\input.mat','NUM')

load('data\data_base\matrix\serie_recess.mat');
dim_r = size(dataBrutos_recess,2);
figure
hold on
plot(NUM(:,1))
for it = 1:dim_r
    pos =find(dataBrutos_recess(:,it));
    plot(ajuste_eixo_x*coord_recess(pos,it),ajuste_eixo_y*dataBrutos_recess(pos,it),'k.');    
end
axis([0 length(NUM(:,1)) min(NUM(:,1)) max(NUM(:,1))])
xlabel(nome_eixo_x)
ylabel(nome_eixo_y)
%set(gca,'YScale',escala_y)
%set(gca,'XScale',escala_x)
legend('Total flow','Recession data')

else
    msgbox('Select the data file before requesting this action.')
end
%==================================================================
ir = 1;
files = dir(['data\data_base\MRC_',num2str(ir),'\']);
set(handles.listbox1,'string',{files.name});
set(handles.listbox1,'Enable','off')


function param_T_Callback(hObject, eventdata, handles)
% hObject    handle to param_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param_T as text
%        str2double(get(hObject,'String')) returns contents of param_T as a double


% --- Executes during object creation, after setting all properties.
function param_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_data.
function select_data_Callback(hObject, eventdata, handles)
% hObject    handle to select_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global newVal_class nameDataFile
newVal_class = 1;
[filename, pathname, filterindex] = uigetfile( ...
       {'*.xlsx','excel (*.xlsx)'; ...
        '*.xls','excel (*.xls)'}, ...
        'Pick a file', ...
        'MultiSelect', 'on');       

if filename ~= 0 
    
    sp = strsplit(filename,'.');
    nameDataFile = sp(1);
    
[NUM,TXT,RAW] = xlsread([pathname,filename]);


 f = figure('Name','Numerical Information','Position',[400 50 800 550]);
 t = uitable(f,'ColumnName', RAW(1,(2:size(RAW,2))),'RowName',RAW(2:size(RAW,1),1),'ColumnWidth',{100},'Position',[10 10 790 540]);
 set(t,'data',NUM)
 
% Create directories =====================
%mkdir ('data\data_base');
if isdir('data\data_base\matrix\')~=0
delete('data\data_base\matrix\*.mat');
elseif isdir ('data\data_base\matrix') == 0
mkdir ('data\data_base\matrix'); 
end
% ======================================
save('data\data_base\matrix\input','NUM','TXT','RAW','t')
save('data\data_base\matrix\numeric_filter_data','NUM','TXT','RAW')

else 

filtroquest = questdlg(['Data file was not imported. Do the procedure again? '], ...
	'Data file', ...
	'Open file','Exit','Exit');
switch filtroquest    
    case 'Open file'        
    select_data_Callback(hObject, eventdata, handles)
    case 'Exit'        
end
end
handles.output = hObject;   
%imshow(handles.images{index});
guidata(hObject, handles);

function ir_Callback(hObject, eventdata, handles)
% hObject    handle to ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ir as text
%        str2double(get(hObject,'String')) returns contents of ir as a double


% --- Executes during object creation, after setting all properties.
function ir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in type_mrc.
function type_mrc_Callback(hObject, eventdata, handles)
% hObject    handle to type_mrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns type_mrc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from type_mrc
val = get(handles.type_mrc,'Value');
if val==1
    set(handles.view_plot_text,'visible','off');
    set(handles.type_view_slider,'visible','off');
    set(handles.popup_view,'visible','off');
    set(handles.text_view,'visible','off');
    nv=length(dir(['data\data_base\MRC_',num2str(1)]))-2;
    set(handles.text_quant_recess,'string',['N = ',num2str(nv)]);
elseif val==2
    set(handles.view_plot_text,'visible','on');
    set(handles.type_view_slider,'visible','on');
    set(handles.popup_view,'visible','on');
    set(handles.text_view,'visible','on');        
  
    set(handles.popup_view,'Value',1)                     
    global n_class;
    nameClass = {num2str(zeros(1,n_class))};
    for icl = 1:n_class
        nameClass(icl) = {['Class_',num2str(icl)]};
    end
    set(handles.popup_view,'String',nameClass)
    
elseif val==3
    set(handles.view_plot_text,'visible','off');
    set(handles.type_view_slider,'visible','off');
    set(handles.popup_view,'visible','off');
    set(handles.text_view,'visible','off');
elseif val==4
    set(handles.view_plot_text,'visible','on');
    set(handles.type_view_slider,'visible','on');
    set(handles.popup_view,'visible','on');
    set(handles.text_view,'visible','on');
    
    check_Maillet = get(handles.check_maillet,'Value');
    check_Boussinesq = get(handles.check_Boussinesq,'Value');
    check_Coutagne = get(handles.check_coutagne,'Value');
    check_Wittenberg = get(handles.check_wittenberg,'Value');
    set(handles.list_parameters, 'value', 1);
    check_Maillet = get(handles.check_maillet,'Value');
    method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    check_Boussinesq = get(handles.check_Boussinesq,'Value');
    check_Coutagne = get(handles.check_coutagne,'Value');
    check_Wittenberg = get(handles.check_wittenberg,'Value');
    MRC = 1;
    method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);
    set(handles.popup_view,'String',method_name(method_fit_pos))
    if method_fit_pos == 1
        set(handles.popup_view,'String',{'MRC'})
        set(handles.popup_view,'Value',1)
    end 
    
    
end

%str = get(hObject, 'String');
%val = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function type_mrc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type_mrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D_min_Callback(hObject, eventdata, handles)
% hObject    handle to D_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of D_min as text
%        str2double(get(hObject,'String')) returns contents of D_min as a double


% --- Executes during object creation, after setting all properties.
function D_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to D_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in list_parameters.
function list_parameters_Callback(hObject, eventdata, handles)
% hObject    handle to list_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_parameters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_parameters


% --- Executes during object creation, after setting all properties.
function list_parameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_n_recess.
function checkbox_n_recess_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_n_recess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_n_recess


% --- Executes on button press in check_maillet.
function check_maillet_Callback(hObject, eventdata, handles)
% hObject    handle to check_maillet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.type_mrc,'Value');
if val == 4
    check_Maillet = get(handles.check_maillet,'Value');
    method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    check_Boussinesq = get(handles.check_Boussinesq,'Value');
    check_Coutagne = get(handles.check_coutagne,'Value');
    check_Wittenberg = get(handles.check_wittenberg,'Value');
    MRC = 1;
    method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);
    set(handles.popup_view,'String',method_name(method_fit_pos))
    if method_fit_pos == 1
        set(handles.popup_view,'String',{'MRC'})
        set(handles.popup_view,'Value',1)
    end
end


% Hint: get(hObject,'Value') returns toggle state of check_maillet


% --- Executes on button press in check_Boussinesq.
function check_Boussinesq_Callback(hObject, eventdata, handles)
% hObject    handle to check_Boussinesq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.type_mrc,'Value');
if val == 4
    method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    check_Boussinesq = get(handles.check_Boussinesq,'Value');
    check_Maillet = get(handles.check_maillet,'Value');
    check_Coutagne = get(handles.check_coutagne,'Value');
    check_Wittenberg = get(handles.check_wittenberg,'Value');
    MRC = 1;
    method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);
    set(handles.popup_view,'String',method_name(method_fit_pos))
    if method_fit_pos == 1
        set(handles.popup_view,'String',{'MRC'})
        set(handles.popup_view,'Value',1)
    end
end
% Hint: get(hObject,'Value') returns toggle state of check_Boussinesq


% --- Executes on button press in check_coutagne.
function check_coutagne_Callback(hObject, eventdata, handles)
% hObject    handle to check_coutagne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.type_mrc,'Value');
if val == 4
    check_Coutagne = get(handles.check_coutagne,'Value');
    method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    check_Maillet = get(handles.check_maillet,'Value');
    check_Boussinesq = get(handles.check_Boussinesq,'Value');
    check_Wittenberg = get(handles.check_wittenberg,'Value');
    MRC = 1;
    method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);
    set(handles.popup_view,'String',method_name(method_fit_pos));
    if method_fit_pos == 1
        set(handles.popup_view,'String',{'MRC'});
        set(handles.popup_view,'Value',1)
    end
end
% Hint: get(hObject,'Value') returns toggle state of check_coutagne


% --- Executes on button press in check_wittenberg.
function check_wittenberg_Callback(hObject, eventdata, handles)
% hObject    handle to check_wittenberg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.type_mrc,'Value');
if val == 4
    check_Wittenberg = get(handles.check_wittenberg,'Value');
    method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    check_Maillet = get(handles.check_maillet,'Value');
    check_Boussinesq = get(handles.check_Boussinesq,'Value');
    check_Coutagne = get(handles.check_coutagne,'Value');
    MRC = 1;
    method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);
    set(handles.popup_view,'String',method_name(method_fit_pos))
    if method_fit_pos == 1
        set(handles.popup_view,'String',{'MRC'})
        set(handles.popup_view,'Value',1)
    end
end
% Hint: get(hObject,'Value') returns toggle state of check_wittenberg


% --- Executes on button press in apply_separation.
function apply_separation_Callback(hObject, eventdata, handles)
% hObject    handle to apply_separation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Call for numerical filter separation flows
filter_guide;


% --- Executes on selection change in type_view_slider.
function type_view_slider_Callback(hObject, eventdata, handles)
% hObject    handle to type_view_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns type_view_slider contents as cell array
%        contents{get(hObject,'Value')} returns selected item from type_view_slider

val = get(handles.type_mrc,'Value');
if val == 2
set(handles.popup_view,'Value',1)                     
global n_class;
nameClass = {num2str(zeros(1,n_class))};
for icl = 1:n_class
    nameClass(icl) = {['Class_',num2str(icl)]};
end
set(handles.popup_view,'String',nameClass)
elseif val == 4 
    check_Maillet = get(handles.check_maillet,'Value');
    check_Boussinesq = get(handles.check_Boussinesq,'Value');
    check_Coutagne = get(handles.check_coutagne,'Value');
    check_Wittenberg = get(handles.check_wittenberg,'Value');
    set(handles.list_parameters, 'value', 1);
    check_Maillet = get(handles.check_maillet,'Value');
    method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    check_Boussinesq = get(handles.check_Boussinesq,'Value');
    check_Coutagne = get(handles.check_coutagne,'Value');
    check_Wittenberg = get(handles.check_wittenberg,'Value');
    MRC = 1;
    method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);
    set(handles.popup_view,'String',method_name(method_fit_pos))
    if method_fit_pos == 1
        set(handles.popup_view,'String',{'MRC'})
        set(handles.popup_view,'Value',1)
    end
end


% global n_class;
% numSteps = n_class;
% MRC = 1;
% numfit = sum([MRC check_Maillet check_Boussinesq check_Coutagne check_Wittenberg]); %METHOD
% 
% if val~=4
%   set(handles.slider3, 'Min', 1);
%   set(handles.slider3, 'Max', numSteps);
%   set(handles.slider3, 'Value', 1);
%   set(handles.slider3, 'SliderStep', [(1/(numSteps-1)) , (1/(numSteps-1))]);
% else
%   set(handles.slider3, 'Min', 1);
%   set(handles.slider3, 'Max', numfit);
%   set(handles.slider3, 'Value', 1);
%   set(handles.slider3, 'SliderStep', [(1/(numfit-1)) , (1/(numfit-1))]);      
% end


% Plot MRC 1=============================
% set(handles.text_MRC,'string','1');
% ir = 1;
% cla('reset');
% plot_curv_Callback(hObject, eventdata, handles)
% files = dir(['data\data_base\MRC_',num2str(ir),'\']);                                   %fullfile(pwd,'Folder01','*.png'));
% set(handles.listbox1,'string',{files.name});
%==============================

% save the current/last slider value
% handles.lastSliderVal = get(handles.slider3,'Value');


% --- Executes during object creation, after setting all properties.
function type_view_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type_view_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_editFigures.
function check_editFigures_Callback(hObject, eventdata, handles)
% hObject    handle to check_editFigures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_editFigures



function edit_mov_average_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mov_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mov_average as text
%        str2double(get(hObject,'String')) returns contents of edit_mov_average as a double


% --- Executes during object creation, after setting all properties.
function edit_mov_average_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mov_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_view.
function popup_view_Callback(hObject, eventdata, handles)
% hObject    handle to popup_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_view contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_view

global newVal_class
global h
newVal_class = get(handles.popup_view,'Value');
val = get(handles.type_mrc,'Value');
type_view_plot = get(handles.type_view_slider,'Value');
check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');
check_editFigure = get(handles.check_editFigures,'Value');
MRC = 1;
method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);

method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};

if val == 1 
    ir = 1;
    ifi = 1;
elseif val == 2
    method_name = {'MRC_class' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    ir = newVal_class;
    ifi = 1;
elseif val == 3
    ir = 1;
    ifi = 1;
elseif val == 4
    ir = 1;
    ifi = method_fit_pos(newVal_class);
end


files = dir(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\']);                                   %fullfile(pwd,'Folder01','*.png'));
set(handles.listbox1,'string',{files.name});
nv=length(dir(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir)]))-2;
set(handles.text_quant_recess,'string',['N = ',num2str(nv)]);

escala_x = get(handles.escala_x,'string');
escala_y = get(handles.escala_y,'string');
nome_eixo_x = get(handles.nome_eixo_x,'string');
nome_eixo_y = get(handles.nome_eixo_y,'string');
ajuste_eixo_x = get(handles.ajuste_eixo_x,'string');
ajuste_eixo_x  = str2num(char(ajuste_eixo_x ));
ajuste_eixo_y = get(handles.ajuste_eixo_y,'string');
ajuste_eixo_y  = str2num(char(ajuste_eixo_y ));
[sort_min_Recess] = sort_min_val(method_name,ifi,ir);  

 
if length(sort_min_Recess)>0
    
 data_fit = sortrows(sort_min_Recess,1); 
 tdata = ajuste_eixo_x*data_fit(:,1)-min(ajuste_eixo_x*data_fit(:,1));
 plot_tdata = ajuste_eixo_x*data_fit(:,1);
 ydata = ajuste_eixo_y*data_fit(:,2);
 Q0 = max(ydata);
 
 if type_view_plot == 1
    %if val ~= 4
        cla('reset');
        
        if check_editFigure == 1
            figure
        end         
        
        plot_curv_Callback(hObject, eventdata, handles)        
                
        if ifi == 1
        opt= [1;1;1;1];    
        else
        opt= [check_Maillet;check_Boussinesq;check_Coutagne;check_Wittenberg];
        end
        %[fitresult,pontos_x,pontos_y]=ajuste_curva_MRC(ajuste_eixo_x*sort_min_Recess(:,1),ajuste_eixo_y*(sort_min_Recess(:,2)));
        %[fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(ajuste_eixo_x*sort_min_Recess(:,1),ajuste_eixo_y*(sort_min_Recess(:,2)),opt);
        [fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(tdata,ydata,opt);


        % % Coutagne (1948) - RMSE
        % fun = @(x)Coutagne_rmse(x,tdata,ydata);
        % x0 = [0;0];
        % bestx = fminsearch(fun,x0);
        % % %======================================
        % A = bestx(1)
        % lambda = bestx(2)
        % yfit = (max(ydata).^(1-A)-(1-A)*lambda*tdata).^(1/(1-A));
        % plot(plot_tdata,ydata,'k.');
        % hold on
        % plot(plot_tdata,yfit,'y','LineWidth',2);
        % % 
        % % %======================================
        % % 
        % % %Wittenberg (1999) - RMSE
        % fun2 = @(x)Wittenberg_rmse(x,tdata,ydata);
        % x0 = rand(2,1);
        % bestx = fminsearch(fun2,x0);
        % % %=====================
        % b = bestx(1)
        % a = bestx(2)
        % yfit2 = max(ydata)*(1+((1-b)*max(ydata)^(1-b)).*tdata/(a*b)).^(1/(b-1));
        % plot(plot_tdata,ydata,'k.');
        % hold on
        % plot(plot_tdata,yfit2,'g--','LineWidth',2);
        % %===================================================
        Str = {};
        idx = ones(1,8);
        iu = 0;
        
        %if ifi==1
        mrc = plot(plot_tdata, ydata,'ro');   
        set(mrc,'MarkerSize',6);
        legend([h mrc],'Recession Curves (Original Data)','MRC Data')
        %end
        
        if (check_Maillet==1 && ifi==2) || ifi == 1
            % % % Plot fit with data Maillet 
%             if ifi~=1
%             mrc = plot(plot_tdata, ydata,'r^');   
%             set(mrc,'MarkerSize',6);            
%             end
            
            a = fit1.a;
            y_m = Q0*exp(-a*tdata);            
            %h1 = plot(fit1,'c'); 
            h1 = plot(plot_tdata,y_m,'c');
            
            set(h1,'LineWidth',2);
            legend([h mrc h1],'Recession Curves (Simulated)','MRC Data','Fit Maillet')
            
            idx = max(idx):(max(idx)+7);
            % List parameters
            ci = confint(fit1); %confidence bounds
            Str(idx(1)) = {'>Maillet Model'};
            Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
            Str(idx(3)) = {['  a = ',num2str(fit1.a),' ( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']};  
            %Str(idx(4)) = {['  b = ',num2str(fit1.b),' ( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']};
            Str(idx(4)) = {'--> Goodness-of-fit statistics'};
            Str(idx(5)) = {['  The sum of squares due to error (SSE): ',num2str(gof1.sse)]};
            Str(idx(6)) = {['  R-square: ',num2str(gof1.rsquare)]};
            Str(idx(7)) = {['  Adjusted R-square: ',num2str(gof1.adjrsquare)]};
            Str(idx(8)) = {['  Root mean squared error (RMSE): ',num2str(gof1.rmse)]};
            iu=1;
            % K = - 1/alfa(2);
            % Str(4) = {['  K = ',num2str(K)]};
            % a = exp(-ajuste_eixo_x/K);
            % A = a/(2-a);
            % B = (1-a)/(2-a);
            % BFImax = B/(1-A); % Eckhardt(2005) Artigo-(How to construct recursive digital filters for baseflow separation)
            % Str(5) = {['  BFImax = ',num2str(BFImax)]};

        end

        if (check_Boussinesq == 1 && ifi==3) || ifi == 1
            % % Plot fit with data Boussinesq            
             %cla('reset')
%            if ifi~=1
%              mrc = plot(plot_tdata, ydata,'rv');   
%              set(mrc,'MarkerSize',6);
%            end
             a = fit2.a;
             y_bouss = Q0*(1+a*tdata).^-2;
             h2 = plot(plot_tdata,y_bouss,'b--');
             %h2 = plot(fit2,'b--');             
             set(h2,'LineWidth',1.3);
             legend([h mrc h2],'Recession Curves (Simulated)','MRC Data','Fit Boussinesq')
             
             idx = max(idx)+iu:(max(idx)+8);
            % List parameters
            ci2 = confint(fit2); %confidence bounds
            Str(idx(1)) = {'>Boussinesq Model'};
            Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
            Str(idx(3)) = {['  a = ',num2str(fit2.a),' ( ', num2str(ci2(1)),' |--| ', num2str(ci2(2)),' )']};  
            %Str(idx(4)) = {['  b = ',num2str(fit2.b),' ( ', num2str(ci2(3)),' |--| ', num2str(ci2(4)),' )']};
            Str(idx(4)) = {'--> Goodness-of-fit statistics'};
            Str(idx(5)) = {['  The sum of squares due to error (SSE): ',num2str(gof2.sse)]};
            Str(idx(6)) = {['  R-square: ',num2str(gof2.rsquare)]};
            Str(idx(7)) = {['  Adjusted R-square: ',num2str(gof2.adjrsquare)]};
            Str(idx(8)) = {['  Root mean squared error (RMSE): ',num2str(gof2.rmse)]};
            iu=1;
            
        end

        if (check_Coutagne == 1 && ifi==4) || ifi ==1
            % % Plot fit with data Coutagne
%             if ifi~=1    
%              mrc = plot(plot_tdata, ydata,'r*');   
%              set(mrc,'MarkerSize',6);
%             end
            Coutagne_par_a= fit3.a;
            Coutagne_par_b= fit3.b;
            y_cout =((Q0^(1-Coutagne_par_b))-(1-Coutagne_par_b)*Coutagne_par_a*tdata).^(1/(1-Coutagne_par_b));
            h3 = plot(plot_tdata,y_cout,'g');
             %h3 = plot(fit3,'g');                            
             set(h3,'LineWidth',3);      
             legend([h mrc h3],'Recession Curves (Simulated)','MRC Data','Fit Coutagne') 
             
             idx = max(idx)+iu:(max(idx)+9);
            % List parameters
            ci3 = confint(fit3); %confidence bounds
            Str(idx(1)) = {'>Coutagne Model'};
            Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
            Str(idx(3)) = {['  a = ',num2str(fit3.a),' ( ', num2str(ci3(1)),' |--| ', num2str(ci3(2)),' )']};  
            Str(idx(4)) = {['  b = ',num2str(fit3.b),' ( ', num2str(ci3(3)),' |--| ', num2str(ci3(4)),' )']};
            Str(idx(5)) = {'--> Goodness-of-fit statistics'};
            Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof3.sse)]};
            Str(idx(7)) = {['  R-square: ',num2str(gof3.rsquare)]};
            Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof3.adjrsquare)]};
            Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof3.rmse)]};
            iu=1;
        end

        if (check_Wittenberg == 1 && ifi==5)|| ifi == 1
             % %Plot fit with data Wittenberg
             
%              if ifi~=1             
%              mrc = plot(plot_tdata, ydata,'rsquare');  
%              set(mrc,'MarkerSize',6);
%              end             
             
             Witt_par_a=fit4.a;
             Witt_par_b=fit4.b;             
             Wittenberg_Q =  Q0*(1+((1-Witt_par_b)*Q0^(1-Witt_par_b)).*tdata./(Witt_par_a*Witt_par_b)).^(1/(Witt_par_b-1));
             h4 = plot(plot_tdata,Wittenberg_Q,'m--');
             %h4 = plot(fit4,'m--');          
             set(h4,'LineWidth',1.3);
             legend([h mrc h4],'Recession Curves (Simulated)','MRC Data','Fit Wittenberg')  
             
             idx = max(idx)+iu:(max(idx)+9);
            % List parameters
            ci4 = confint(fit4); %confidence bounds
            Str(idx(1)) = {'>Wittenberg Model'};
            Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
            Str(idx(3)) = {['  a = ',num2str(fit4.a),' ( ', num2str(ci4(1)),' |--| ', num2str(ci4(2)),' )']};  
            Str(idx(4)) = {['  b = ',num2str(fit4.b),' ( ', num2str(ci4(3)),' |--| ', num2str(ci4(4)),' )']};
            Str(idx(5)) = {'--> Goodness-of-fit statistics'};
            Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof4.sse)]};
            Str(idx(7)) = {['  R-square: ',num2str(gof4.rsquare)]};
            Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof4.adjrsquare)]};
            Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof4.rmse)]};
        end
        
        set(handles.listbox1,'Enable','on')
        set(handles.list_parameters,'string',Str);
        
        xlabel(nome_eixo_x); ylabel(nome_eixo_y)
        set(gca,'YScale',escala_y)
        set(gca,'XScale',escala_x)
        
% Creation of graphics captions

if ifi == 1
legend([h,mrc,h1,h2,h3,h4],'Recession Curves (Original Data)','MRC Data','Fit Maillet','Fit Boussinesq','Fit Coutagne','Fit Wittenberg')
end

%     else
%         cla('reset');%         
%         plot_curv_Callback(hObject, eventdata, handles)        
%                         
%     end
elseif type_view_plot==2
     
     
set(handles.listbox1,'Enable','off')
dimDir=length(dir(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir)]))-2;
cla('reset')
        if check_editFigure == 1
            figure
        end
hold on

if strcmp(char(cell(method_name(ifi))),char(cell(method_name(1))))~=1
    orig_vetQ = [];
    orig_vetdQ = [];
    for it = 1:dimDir   
        load(['data\data_base\',char(cell(method_name(1))),'_',num2str(ir),'\Recess_',num2str(it),'.mat'],'coordenadas','coordenadas_b');
        pos =find(coordenadas(:,2));    
        orig_Q =  coordenadas(pos,2);
        orig_Qm = (orig_Q(1:end-1)+orig_Q(2:end))./2;
        orig_dQ = diff(coordenadas(pos,2));
        orig_vetQ = [orig_vetQ;orig_Qm(1:end)];
        orig_vetdQ = [orig_vetdQ;orig_dQ];
    end
    plot(log10(orig_vetQ),log10(-orig_vetdQ),'r.','Color',[0.6 0.6 0.6])
end


vetQ = [];
vetdQ = [];
for it = 1:dimDir   
    load(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\Recess_',num2str(it),'.mat'],'coordenadas','coordenadas_b');
    pos =find(coordenadas(:,2));    
    Q =  coordenadas(pos,2);
    Qm = (Q(1:end-1)+Q(2:end))./2;
    dQ = diff(coordenadas(pos,2));
    vetQ = [vetQ;Qm(1:end)];
    vetdQ =[vetdQ;dQ];
end

% =============================================================
% Data Binning (Kirchner 2009) - Saúl Arciniega-Esparza (2017)
% =============================================================
    Qbin=sortrows([log10(-vetdQ) log10(vetQ)],-2); % 
    pbin=ceil(size(Qbin,1)*0.01); %
    BIN=[];
    while size(Qbin,1)>0
        try
           BIN=[BIN; mean(Qbin(1:pbin,:))]; %
           Qbin(1:pbin,:)=[]; % 
        catch mensaje
            if size(Qbin,1)>1
                BIN=[BIN; mean(Qbin)]; %
            end
           Qbin=[]; 
        end
    end
    BIN(end,:)=[];
    D=[(1:size(BIN,1))' -10.^(BIN(:,1)) 10.^(BIN(:,2))]; %
    REC=D; %    
% ===============================================================

if strcmp(char(cell(method_name(ifi))),char(cell(method_name(1))))==1
plot(log10(vetQ),log10(-vetdQ),'k.','Color',[0.6 0.6 0.6])
else
plot(log10(vetQ),log10(-vetdQ),'y.','Color',[0.2 0.6 1])  
end

mrc = data_fit(:,2);
diffmrc1 = diff(mrc);
mrcdata = mrc(diffmrc1~=0 & diffmrc1<0); % Eliminating null derivatives greater than 0;
diffmrcdata = diff(mrcdata);

% Linear regression

xbins = log10(REC(:,3));
ybins = log10(REC(:,2));

% Linear regression

xmrc = log10((mrcdata(1:end-1)+mrcdata(2:end))./2);
ymrc = log10(-diffmrcdata);

vetQ = log10(vetQ);
vetdQ = log10(-vetdQ);

opts3 = fitoptions('Method','NonlinearLeastSquares');
opts3.Lower = [-inf -inf ];
opts3.StartPoint = [0 0];
opts3.Upper = [inf inf];    
ft3 = fittype(@(b, a, x ) b*x + a, 'independent', {'x'}, ...
              'dependent', {'y'}, 'coefficients',{'b','a'},'Options',opts3);
          
% Fit model to data.
[fit_t, gof_t] = fit(vetQ, vetdQ, ft3);
f1 = plot(fit_t);
if strcmp(char(cell(method_name(ifi))),char(cell(method_name(1))))==1
set(f1,'Color',0.8*ones(1,3))
else
set(f1,'Color',[0.2 0.6 1])
end
set(f1,'LineWidth',3)

a = fit_t.a;
b = fit_t.b;

 mrc_p = plot(xmrc,ymrc,'ro');
 set(mrc_p,'MarkerSize',6);
 
% if strcmp(char(cell(method_name(ifi))),'MRC')==1
% mrc_p = plot(log10(mrcdata(2:end)),log10(-diffmrcdata),'ro');
% set(mrc_p,'MarkerSize',6);
% elseif (check_Maillet == 1 && ifi==2)
% mrc_p = plot(log10(mrcdata(2:end)),log10(-diffmrcdata),'r^');
% set(mrc_p,'MarkerSize',6);    
% elseif (check_Boussinesq == 1 && ifi==3)
% mrc_p = plot(log10(mrcdata(2:end)),log10(-diffmrcdata),'rv');
% set(mrc_p,'MarkerSize',6);   
% elseif (check_Coutagne == 1 && ifi==4)
% mrc_p = plot(log10(mrcdata(2:end)),log10(-diffmrcdata),'r*');
% set(mrc_p,'MarkerSize',6);  
% elseif (check_Wittenberg == 1 && ifi==5)
% mrc_p = plot(log10(mrcdata(2:end)),log10(-diffmrcdata),'rsquare');
% set(mrc_p,'MarkerSize',6);
% end

[fit_mrc, gof_mrc] = fit(xmrc, ymrc, ft3);

% if strcmp(char(cell(method_name(ifi))),'MRC')==1
% f2 = plot(fit_mrc,'r--');
% set(f2,'LineWidth',1.3);
% elseif (check_Maillet == 1 && ifi==2)
% f2 = plot(fit_mrc,'c');
% set(f2,'LineWidth',1.3);    
% elseif (check_Boussinesq == 1 && ifi==3)
% f2 = plot(fit_mrc,'b--');
% set(f2,'LineWidth',1.3);    
% elseif (check_Coutagne == 1 && ifi==4)
% f2 = plot(fit_mrc,'g');
% set(f2,'LineWidth',3);    
% elseif (check_Wittenberg == 1 && ifi==5)
% f2 = plot(fit_mrc,'m--');
% set(f2,'LineWidth',1.3);
% end

 f2 = plot(fit_mrc,'r--');
 set(f2,'LineWidth',1.3);

 mrc_a = fit_mrc.a;
 mrc_b = fit_mrc.b;
  
 
 %Plot BINs data
bins_p = plot(xbins,ybins,'ksquare');
set(bins_p,'MarkerSize',6);
set(bins_p,'MarkerFaceColor',[0 0 0]);
 
[fit_bins, gof_bins] = fit(xbins, ybins, ft3);
f3 = plot(fit_bins,'k--');
set(f3,'LineWidth',1.3);

bins_a = fit_bins.a;
bins_b = fit_bins.b;

 
xlabel('log(Q)'); ylabel('log(-dQ/dt)')
if strcmp(char(cell(method_name(ifi))),char(cell(method_name(1))))~=1
legend('Original data','Recessions (Simulated)','Fit Recessions (Simulated)','MRC data','Fit MRC','Data BINs','Fit BINs (LR)') 
else
legend('Recessions (Original data)','Fit Recessions (LR)','MRC data','Fit MRC (LR)','Data BINs','Fit BINs (LR)')   
end
%set(gca,'YScale',escala_y)
%set(gca,'XScale',escala_x)

Str = {};
idx = ones(1,9);

idx = max(idx):(max(idx)+10);
% List parameters
ci = confint(fit_t); %confidence bounds
if strcmp(char(cell(method_name(ifi))),char(cell(method_name(1))))~=1
Str(idx(1)) = {['> Linear Regression (Recessions (Simulated-',char(cell(method_name(ifi))),'))']};    
else
Str(idx(1)) = {'> Linear Regression (all recessions)'};
end
Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  b = ',num2str(fit_t.b),' ( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']};  
Str(idx(4)) = {['  a = ',num2str(10^(fit_t.a)),' ( ', num2str(10^(ci(3))),' |--| ', num2str(10^(ci(4))),' )']};
Str(idx(5)) = {'--> Goodness-of-fit statistics'};
Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof_t.sse)]};
Str(idx(7)) = {['  R-square: ',num2str(gof_t.rsquare)]};
Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof_t.adjrsquare)]};
Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof_t.rmse)]};

idx = max(idx):(max(idx)+9);
% List parameters
ci = confint(fit_mrc); %confidence bounds

if strcmp(char(cell(method_name(ifi))),char(cell(method_name(1))))~=1
Str(idx(1)) = {['> Linear Regression (MRC (Simulated-',char(cell(method_name(ifi))),'))']};    
else
Str(idx(1)) = {'> Linear Regression (MRC data)'};
end
Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  b = ',num2str(fit_mrc.b),' ( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']};  
Str(idx(4)) = {['  a = ',num2str(10^fit_mrc.a),' ( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']};
Str(idx(5)) = {'--> Goodness-of-fit statistics'};
Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof_mrc.sse)]};
Str(idx(7)) = {['  R-square: ',num2str(gof_mrc.rsquare)]};
Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof_mrc.adjrsquare)]};
Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof_mrc.rmse)]};
   
idx = max(idx)+1:(max(idx)+9);
% List parameters
ci = confint(fit_bins); %confidence bounds

if strcmp(char(cell(method_name(ifi))),char(cell(method_name(1))))~=1
Str(idx(1)) = {['> Linear Regression (BINs (Simulated-',char(cell(method_name(ifi))),'))']};    
else
Str(idx(1)) = {'> Linear Regression (BINs data)'};
end

Str(idx(2)) = {'--> Coefficients (with 95% confidence bounds):'};
Str(idx(3)) = {['  b = ',num2str(fit_bins.b),' ( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']};  
Str(idx(4)) = {['  a = ',num2str(10^fit_bins.a),' ( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']};
Str(idx(5)) = {'--> Goodness-of-fit statistics'};
Str(idx(6)) = {['  The sum of squares due to error (SSE): ',num2str(gof_bins.sse)]};
Str(idx(7)) = {['  R-square: ',num2str(gof_bins.rsquare)]};
Str(idx(8)) = {['  Adjusted R-square: ',num2str(gof_bins.adjrsquare)]};
Str(idx(9)) = {['  Root mean squared error (RMSE): ',num2str(gof_bins.rmse)]};
set(handles.list_parameters,'string',Str);

end
 
else 
    cla('reset')
    msgbox(['No recession has entered Class ', num2str(ir),'. Decrease the minimum duration recessions'],'Warning'); 
end


% --- Executes during object creation, after setting all properties.
function popup_view_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();


% --- Executes on button press in pushbuttonReport.
function pushbuttonReport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global newVal_class n_class h nameDataFile
val = get(handles.type_mrc,'Value');

escala_x = get(handles.escala_x,'string');
escala_y = get(handles.escala_y,'string');
nome_eixo_x = get(handles.nome_eixo_x,'string');
nome_eixo_y = get(handles.nome_eixo_y,'string');
ajuste_eixo_x = get(handles.ajuste_eixo_x,'string');
ajuste_eixo_x  = str2num(char(ajuste_eixo_x ));
ajuste_eixo_y = get(handles.ajuste_eixo_y,'string');
ajuste_eixo_y  = str2num(char(ajuste_eixo_y ));

type_view_plot = get(handles.type_view_slider,'Value');
check_Maillet = get(handles.check_maillet,'Value');
check_Boussinesq = get(handles.check_Boussinesq,'Value');
check_Coutagne = get(handles.check_coutagne,'Value');
check_Wittenberg = get(handles.check_wittenberg,'Value');
check_editFigure = get(handles.check_editFigures,'Value');
MRC = 1;

method_fit_pos = find([MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg]);

if val == 1
    method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    ir = 1;
    ifi = 1;
    MRC_automatic(method_name,ifi,ir);
    
    [sort_min_Recess] = sort_min_val(method_name,ifi,ir);
    opt= [check_Maillet;check_Boussinesq;check_Coutagne;check_Wittenberg];
    data_fit = sortrows(sort_min_Recess,1);
    tdata = ajuste_eixo_x*data_fit(:,1)-min(ajuste_eixo_x*data_fit(:,1));
    plot_tdata = ajuste_eixo_x*data_fit(:,1);
    ydata = ajuste_eixo_y*data_fit(:,2);
    Q0 = max(ydata);
    [fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(tdata,ydata,opt);
    
    fig1 = figure; % New figure
    
    plot_curv_Callback(hObject, eventdata, handles)
    mrc = plot(plot_tdata, ydata,'ro');
    set(mrc,'MarkerSize',6);
    
    mkdir(['data\Results\',char(cell(nameDataFile)),'\MRC_All_Recessions\'])
    file_name = ['data\Results\',char(cell(nameDataFile)),'\MRC_All_Recessions\report_fit_MRC'];
    
    path_file = fopen([file_name,'.txt'],'w');
    
    if check_Maillet==1
        
        % % % Plot fit with data Maillet
        a = fit1.a;
        y_m = Q0*exp(-a*tdata);            
        h1 = plot(plot_tdata,y_m,'c');
        %h1 = plot(fit1,'c');
        set(h1,'LineWidth',2);
        
        name_method = 'Fit Maillet';
        ci = confint(fit1); %confidence bounds
        fprintf(path_file,'***************************************************************\r\n')
        fprintf(path_file,['                      ',name_method,'\r\n']);
        fprintf(path_file,'***************************************************************\r\n')
        fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
        fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit1.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
        %fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
        fprintf(path_file,'--> Goodness of fit statistics\r\n');
        fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof1.sse));
        fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof1.rsquare));
        fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof1.adjrsquare));
        fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof1.rmse));
        
    end
    
    if check_Boussinesq == 1
        % % Plot fit with data Boussinesq
        a = fit2.a;
        y_bouss = Q0*(1+a*tdata).^-2;
        h2 = plot(plot_tdata,y_bouss,'b--');
        %h2 = plot(fit2,'b--');
        set(h2,'LineWidth',1.3);
        
        name_method = 'Fit Boussinesq';
        ci = confint(fit2); %confidence bounds
        fprintf(path_file,'***************************************************************\r\n')
        fprintf(path_file,['                      ',name_method,'\r\n']);
        fprintf(path_file,'***************************************************************\r\n')
        fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
        fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit2.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
        %fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
        fprintf(path_file,'--> Goodness of fit statistics\r\n');
        fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof2.sse));
        fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof2.rsquare));
        fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof2.adjrsquare));
        fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof2.rmse));
        
    end
    
    if check_Coutagne == 1
        % % Plot fit with data Coutagne
        Coutagne_par_a= fit3.a;
        Coutagne_par_b= fit3.b;
        y_cout =((Q0^(1-Coutagne_par_b))-(1-Coutagne_par_b)*Coutagne_par_a*tdata).^(1/(1-Coutagne_par_b));
        h3 = plot(plot_tdata,y_cout,'g');
        %h3 = plot(fit3,'g');
        set(h3,'LineWidth',3);
        
        name_method = 'Fit Coutagne';
        ci = confint(fit3); %confidence bounds
        fprintf(path_file,'***************************************************************\r\n')
        fprintf(path_file,['                      ',name_method,'\r\n']);
        fprintf(path_file,'***************************************************************\r\n')
        fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
        fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit3.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
        fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit3.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
        fprintf(path_file,'--> Goodness of fit statistics\r\n');
        fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof3.sse));
        fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof3.rsquare));
        fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof3.adjrsquare));
        fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof3.rmse));
        
    end
    
    if check_Wittenberg == 1
        % %Plot fit with data Wittenberg
        Witt_par_a=fit4.a;
        Witt_par_b=fit4.b;             
        Wittenberg_Q =  Q0*(1+((1-Witt_par_b)*Q0^(1-Witt_par_b)).*tdata./(Witt_par_a*Witt_par_b)).^(1/(Witt_par_b-1));
        h4 = plot(plot_tdata,Wittenberg_Q,'m--');
        %h4 = plot(fit4,'m--');
        set(h4,'LineWidth',1.3);
        
        name_method = 'Fit Wittenberg';
        ci = confint(fit4); %confidence bounds
        fprintf(path_file,'***************************************************************\r\n')
        fprintf(path_file,['                      ',name_method,'\r\n']);
        fprintf(path_file,'***************************************************************\r\n')
        fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
        fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit4.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
        fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit4.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
        fprintf(path_file,'--> Goodness of fit statistics\r\n');
        fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof4.sse));
        fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof4.rsquare));
        fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof4.adjrsquare));
        fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof4.rmse));
    end
    fclose(path_file);
    
    %%=======================================================
    xlabel(nome_eixo_x)
    ylabel(nome_eixo_y)
    set(gca,'YScale',escala_y)
    set(gca,'XScale',escala_x)
    
    % Creation of graphics captions
    MRC = 1;
    fit_select = [MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg];
    fit_def = [h mrc];
    fit_name_str = {'Recession Curves'};
    fit_name_str = [fit_name_str {'MRC Data'}];
    if fit_select(2)==1
        fit_def = [fit_def h1];
        fit_name_str = [fit_name_str,{'Fit Maillet'}];
    end
    if fit_select(3)==1
        fit_def = [fit_def h2];
        fit_name_str = [fit_name_str,{'Fit Boussinesq'}];
    end
    if fit_select(4)==1
        fit_def = [fit_def h3];
        fit_name_str = [fit_name_str,{'Fit Coutagne'}];
    end
    if fit_select(5)==1
        fit_def = [fit_def h4];
        fit_name_str = [fit_name_str,{'Fit Wittenberg'}];
    end
    legend(fit_def,fit_name_str)
    
   
    saveas(fig1,['data\Results\',char(cell(nameDataFile)),'\MRC_All_Recessions\fit_MRC.fig'])
    saveas(fig1,['data\Results\',char(cell(nameDataFile)),'\MRC_All_Recessions\fit_MRC.png'])
    
    close(fig1)
    
    
elseif val == 2
    method_name = {'MRC_class' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    ifi=1;
    mkdir(['data\Results\',char(cell(nameDataFile)),'\MRC_Classified\'])
    for ir = 1: n_class
        
        newVal_class = ir;
        
        MRC_automatic(method_name,ifi,ir);
        [sort_min_Recess] = sort_min_val(method_name,ifi,ir);
        
        if length(sort_min_Recess)>0
            
            opt= [check_Maillet;check_Boussinesq;check_Coutagne;check_Wittenberg];
            data_fit = sortrows(sort_min_Recess,1);
            
            tdata = ajuste_eixo_x*data_fit(:,1)-min(ajuste_eixo_x*data_fit(:,1));
            plot_tdata = ajuste_eixo_x*data_fit(:,1);
            ydata = ajuste_eixo_y*data_fit(:,2);
            Q0 = max(ydata);
            [fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(tdata,ydata,opt);
            
            fig1 = figure; % New figure
            
            plot_curv_Callback(hObject, eventdata, handles)
            
            mrc = plot(plot_tdata, ydata,'ro');
            set(mrc,'MarkerSize',6);
            
            file_name = ['data\Results\',char(cell(nameDataFile)),'\MRC_Classified\report_fit_MRC_',num2str(ir)];
            path_file = fopen([file_name,'.txt'],'w');
            
            if check_Maillet==1
                
                % % % Plot fit with data Maillet
                a = fit1.a;
                y_m = Q0*exp(-a*tdata);            
                h1 = plot(plot_tdata,y_m,'c');
                %h1 = plot(fit1,'c');
                set(h1,'LineWidth',2);
                
                name_method = 'Fit Maillet';
                ci = confint(fit1); %confidence bounds
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',name_method,'\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
                fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit1.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
                %fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
                fprintf(path_file,'--> Goodness of fit statistics\r\n');
                fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof1.sse));
                fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof1.rsquare));
                fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof1.adjrsquare));
                fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof1.rmse));
                
            end
            
            if check_Boussinesq == 1
                % % Plot fit with data Boussinesq
                a = fit2.a;
                y_bouss = Q0*(1+a*tdata).^-2;
                h2 = plot(plot_tdata,y_bouss,'b--');
                %h2 = plot(fit2,'b--');
                set(h2,'LineWidth',1.3);
                
                name_method = 'Fit Boussinesq';
                ci = confint(fit2); %confidence bounds
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',name_method,'\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
                fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit2.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
                %fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
                fprintf(path_file,'--> Goodness of fit statistics\r\n');
                fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof2.sse));
                fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof2.rsquare));
                fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof2.adjrsquare));
                fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof2.rmse));
                
            end
            
            if check_Coutagne == 1
                % % Plot fit with data Coutagne
                Coutagne_par_a= fit3.a;
                Coutagne_par_b= fit3.b;
                y_cout =((Q0^(1-Coutagne_par_b))-(1-Coutagne_par_b)*Coutagne_par_a*tdata).^(1/(1-Coutagne_par_b));
                h3 = plot(plot_tdata,y_cout,'g');
                %h3 = plot(fit3,'g');
                set(h3,'LineWidth',3);
                
                name_method = 'Fit Coutagne';
                ci = confint(fit3); %confidence bounds
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',name_method,'\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
                fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit3.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
                fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit3.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
                fprintf(path_file,'--> Goodness of fit statistics\r\n');
                fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof3.sse));
                fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof3.rsquare));
                fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof3.adjrsquare));
                fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof3.rmse));
                
            end
            
            if check_Wittenberg == 1
                % %Plot fit with data Wittenberg
                Witt_par_a=fit4.a;
                Witt_par_b=fit4.b;             
                Wittenberg_Q =  Q0*(1+((1-Witt_par_b)*Q0^(1-Witt_par_b)).*tdata./(Witt_par_a*Witt_par_b)).^(1/(Witt_par_b-1));
                h4 = plot(plot_tdata,Wittenberg_Q,'m--');
                %h4 = plot(fit4,'m--');
                set(h4,'LineWidth',1.3);
                
                name_method = 'Fit Wittenberg';
                ci = confint(fit4); %confidence bounds
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',name_method,'\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
                fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit4.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
                fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit4.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
                fprintf(path_file,'--> Goodness of fit statistics\r\n');
                fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof4.sse));
                fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof4.rsquare));
                fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof4.adjrsquare));
                fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof4.rmse));
            end
            fclose(path_file);
            
            %%=======================================================
            xlabel(nome_eixo_x)
            ylabel(nome_eixo_y)
            set(gca,'YScale',escala_y)
            set(gca,'XScale',escala_x)
            
            % Creation of graphics captions
            MRC = 1;
            fit_select = [MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg];
            fit_def = [h mrc];
            fit_name_str = {'Recession Curves'};
            fit_name_str = [fit_name_str {'MRC Data'}];
            if fit_select(2)==1
                fit_def = [fit_def h1];
                fit_name_str = [fit_name_str,{'Fit Maillet'}];
            end
            if fit_select(3)==1
                fit_def = [fit_def h2];
                fit_name_str = [fit_name_str,{'Fit Boussinesq'}];
            end
            if fit_select(4)==1
                fit_def = [fit_def h3];
                fit_name_str = [fit_name_str,{'Fit Coutagne'}];
            end
            if fit_select(5)==1
                fit_def = [fit_def h4];
                fit_name_str = [fit_name_str,{'Fit Wittenberg'}];
            end
            legend(fit_def,fit_name_str)
            
            saveas(fig1,['data\Results\',char(cell(nameDataFile)),'\MRC_Classified\fit_MRC_',num2str(ir),'.fig'])
            saveas(fig1,['data\Results\',char(cell(nameDataFile)),'\MRC_Classified\fit_MRC_',num2str(ir),'.png'])
            close(fig1)
            %=====================================
            % log10(-dQdt) Vs log10(Q)
            %=====================================
            dimDir=length(dir(['data\data_base\',char(cell(method_name(1))),'_',num2str(ir)]))-2;
            
            fig2 = figure; % New Figure (log10(-dQdt) Vs log10(Q))
            hold on
            
%             if strcmp(char(cell(method_name(ifi))),'MRC')~=1
%                 orig_vetQ = [];
%                 orig_vetdQ = [];
%                 for it = 1:dimDir
%                     load(['data\data_base\',char(cell(method_name(1))),'_',num2str(ir),'\Recess_',num2str(it),'.mat'],'coordenadas','coordenadas_b');
%                     pos =find(coordenadas(:,2));
%                     orig_Q =  coordenadas(pos,2);
%                     orig_dQ = diff(coordenadas(pos,2));
%                     orig_vetQ = [orig_vetQ;orig_Q(2:end)];
%                     orig_vetdQ = [orig_vetdQ;orig_dQ];
%                 end
%                 plot(log10(orig_vetQ),log10(-orig_vetdQ),'r.','Color',[0.6 0.6 0.6])
%             end
            
            vetQ = [];
            vetdQ = [];
            for it = 1:dimDir
                load(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\Recess_',num2str(it),'.mat'],'coordenadas','coordenadas_b');
                pos =find(coordenadas(:,2));
                Q =  coordenadas(pos,2);
                Qm = (Q(1:end-1)+Q(2:end))./2;
                dQ = diff(coordenadas(pos,2));
                vetQ = [vetQ;Qm(1:end)];
                vetdQ = [vetdQ;dQ];
            end
            
            % =============================================================
            % Data Binning (Kirchner 2009) - Saúl Arciniega-Esparza (2017)
            % =============================================================
            Qbin=sortrows([log10(-vetdQ) log10(vetQ)],-2); % 
            pbin=ceil(size(Qbin,1)*0.01); %
            BIN=[];
            while size(Qbin,1)>0
                try
                    BIN=[BIN; mean(Qbin(1:pbin,:))]; %
                    Qbin(1:pbin,:)=[]; % 
                catch mensaje
                    if size(Qbin,1)>1
                        BIN=[BIN; mean(Qbin)]; %
                    end
                    Qbin=[];
                end
            end
            BIN(end,:)=[];
            D=[(1:size(BIN,1))' -10.^(BIN(:,1)) 10.^(BIN(:,2))]; %
            REC=D; %
            % =============================================================
            
%             if strcmp(char(cell(method_name(ifi))),'MRC')==1
                plot(log10(vetQ),log10(-vetdQ),'k.','Color',[0.6 0.6 0.6])
%             else
%                 plot(log10(vetQ),log10(-vetdQ),'k.')
%             end
            
            mrc = data_fit(:,2);
            diffmrc1 = diff(mrc);
            mrcdata = mrc(diffmrc1~=0 & diffmrc1<0); % Eliminating null derivatives greater than 0;
            diffmrcdata = diff(mrcdata);
            
            % Linear regression
            % Defining log10 (Q) and log (-dQ) values of the BINs
            xbins = log10(REC(:,3));
            ybins = log10(REC(:,2));
            % Linear regression
            % Defining log10 (Q) and log (-dQ) values of the MRC
            xmrc = log10((mrcdata(1:end-1)+mrcdata(2:end))./2);
            ymrc = log10(-diffmrcdata);            
            % Defining log10 (Q) and log (-dQ) values of the set of all recessions
            vetQ = log10(vetQ);
            vetdQ = log10(-vetdQ);
                        
            mrc_p = plot(xmrc,ymrc,'ro');
            set(mrc_p,'MarkerSize',6);
            
            %Plot BINs data
            bins_p = plot(xbins,ybins,'ksquare');
            set(bins_p,'MarkerSize',6);
            set(bins_p,'MarkerFaceColor',[0 0 0]);           

            
            opts3 = fitoptions('Method','NonlinearLeastSquares');
            opts3.Lower = [-inf -inf ];
            opts3.StartPoint = [0 0];
            opts3.Upper = [inf inf];
            ft3 = fittype(@(b, a, x ) b*x + a, 'independent', {'x'}, ...
                'dependent', {'y'}, 'coefficients',{'b','a'},'Options',opts3);
            
            % Fit model to data.
            [fit_t, gof_t] = fit(vetQ, vetdQ, ft3);
            f1 = plot(fit_t);
            set(f1,'Color',0.8*ones(1,3))
            set(f1,'LineWidth',3)
            a = fit_t.a;
            b = fit_t.b;
                       
            [fit_mrc, gof_mrc] = fit(xmrc, ymrc, ft3);
            f2 = plot(fit_mrc,'r--');
            set(f2,'LineWidth',1.4);
            mrc_a = fit_mrc.a;
            mrc_b = fit_mrc.b;
                      
            [fit_bins, gof_bins] = fit(xbins, ybins, ft3);
            f3 = plot(fit_bins,'k--');
            set(f3,'LineWidth',1.4);
            
            bins_a = fit_bins.a;
            bins_b = fit_bins.b;
                
            xlabel('log(Q)'); ylabel('log(-dQ/dt)')
%             if strcmp(char(cell(method_name(ifi))),'MRC')~=1
%                 legend('Original data','Recessions (Simulated)','MRC data','Fit Recessions (Simulated)','Fit MRC')
%             else
                legend('Recessions (Original data)','MRC data','Data BINs','Fit Recessions (LR)','Fit MRC (LR)','Fit BINs (LR)')
%             end

            %set(gca,'YScale',escala_y)
            %set(gca,'XScale',escala_x)
            saveas(fig2,['data\Results\',char(cell(nameDataFile)),'\MRC_Classified\fit_dQdt_Vs_Q_',num2str(ir),'.fig'])
            saveas(fig2,['data\Results\',char(cell(nameDataFile)),'\MRC_Classified\fit_dQdt_Vs_Q_',num2str(ir),'.png'])
            close(fig2)
            
            file_name = ['data\Results\',char(cell(nameDataFile)),'\MRC_Classified\report_dQdt_Vs_Q_',num2str(ir)];
            path_file = fopen([file_name,'.txt'],'w');
            
            % Report Parameters
            name_method = 'Linear Regression (Recessions)';
            ci = confint(fit_t); %confidence bounds
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,['                      ',name_method,'\r\n']);
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
            fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit_t.b), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
            fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(10^fit_t.a), ['( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']);
            fprintf(path_file,'--> Goodness of fit statistics\r\n');
            fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof_t.sse));
            fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof_t.rsquare));
            fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof_t.adjrsquare));
            fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof_t.rmse));
            
            
            name_method = 'Linear Regression (MRC)';
            ci = confint(fit_mrc); %confidence bounds
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,['                      ',name_method,'\r\n']);
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
            fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit_mrc.b), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
            fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(10^fit_mrc.a), ['( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']);
            fprintf(path_file,'--> Goodness of fit statistics\r\n');
            fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof_mrc.sse));
            fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof_mrc.rsquare));
            fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof_mrc.adjrsquare));
            fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof_mrc.rmse));
            
            
            name_method = 'Linear Regression (BINs)';
            ci = confint(fit_bins); %confidence bounds
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,['                      ',name_method,'\r\n']);
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
            fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit_bins.b), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
            fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(10^fit_bins.a), ['( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']);
            fprintf(path_file,'--> Goodness of fit statistics\r\n');
            fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof_bins.sse));
            fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof_bins.rsquare));
            fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof_bins.adjrsquare));
            fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof_bins.rmse));
                       
            fclose(path_file);
            % =============================
        else
            cla('reset')
            msgbox(['No recession has entered Class ', num2str(ir),'. Decrease the minimum duration recessions'],'Warning');
        end
    end
elseif val == 3    
            method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
            ir = 1;
            ifi = 1;
            MRC_automatic(method_name,ifi,ir);
            [sort_min_Recess] = sort_min_val(method_name,ifi,ir);        
            data_fit = sortrows(sort_min_Recess,1);
            %=====================================
            % log10(-dQdt) Vs log10(Q)
            %=====================================
            mkdir(['data\Results\',char(cell(nameDataFile)),'\dQdt_Vs_Q\'])
            dimDir=length(dir(['data\data_base\',char(cell(method_name(1))),'_',num2str(ir)]))-2;
            
            fig3 = figure; % New Figure (log10(-dQdt) Vs log10(Q))
            hold on
            
%             if strcmp(char(cell(method_name(ifi))),'MRC')~=1
%                 orig_vetQ = [];
%                 orig_vetdQ = [];
%                 for it = 1:dimDir
%                     load(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\Recess_',num2str(it),'.mat'],'coordenadas','coordenadas_b');
%                     pos =find(coordenadas(:,2));
%                     orig_Q =  coordenadas(pos,2);
%                     orig_dQ = diff(coordenadas(pos,2));
%                     orig_vetQ = [orig_vetQ;orig_Q(2:end)];
%                     orig_vetdQ = [orig_vetdQ;orig_dQ];
%                 end
%                 plot(log10(orig_vetQ),log10(-orig_vetdQ),'r.','Color',[0.6 0.6 0.6])
%             end
            
            vetQ = [];
            vetdQ = [];
            for it = 1:dimDir
                load(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\Recess_',num2str(it),'.mat'],'coordenadas','coordenadas_b');
                pos =find(coordenadas(:,2));
                Q =  coordenadas(pos,2);
                Qm = (Q(1:end-1)+Q(2:end))./2;
                dQ = diff(coordenadas(pos,2));
                vetQ = [vetQ;Qm(1:end)];
                vetdQ = [vetdQ;dQ];
            end
            
            % =============================================================
            % Data Binning (Kirchner 2009) 
            % =============================================================
            Qbin=sortrows([log10(-vetdQ) log10(vetQ)],-2); % 
            pbin=ceil(size(Qbin,1)*0.01); %
            BIN=[];
            while size(Qbin,1)>0
                try
                    BIN=[BIN; mean(Qbin(1:pbin,:))]; %
                    Qbin(1:pbin,:)=[]; %
                catch mensaje
                    if size(Qbin,1)>1
                        BIN=[BIN; mean(Qbin)]; %
                    end
                    Qbin=[];
                end
            end
            BIN(end,:)=[];
            D=[(1:size(BIN,1))' -10.^(BIN(:,1)) 10.^(BIN(:,2))]; %
            REC=D; %
            
%             if strcmp(char(cell(method_name(ifi))),'MRC')==1
                plot(log10(vetQ),log10(-vetdQ),'k.','Color',[0.6 0.6 0.6])
%             else
%                 plot(log10(vetQ),log10(-vetdQ),'k.')
%             end
            
            mrc = data_fit(:,2);
            diffmrc1 = diff(mrc);
            mrcdata = mrc(diffmrc1~=0 & diffmrc1<0); % Eliminating null derivatives greater than 0;
            diffmrcdata = diff(mrcdata);
            
            % Linear regression
            % Defining log10 (Q) and log (-dQ) values of the BINs 
            xbins = log10(REC(:,3));
            ybins = log10(REC(:,2));
            
            % Linear regression
            % Defining log10 (Q) and log (-dQ) values of the MRC
            xmrc = log10((mrcdata(1:end-1)+mrcdata(2:end))./2);
            ymrc = log10(-diffmrcdata);
            
            % Defining log10 (Q) and log (-dQ) values of the set of all recessions
            vetQ = log10(vetQ);
            vetdQ = log10(-vetdQ);            
            
            mrc_p = plot(xmrc,ymrc,'ro');
            set(mrc_p,'MarkerSize',6);
            
            %Plot BINs data
            bins_p = plot(xbins,ybins,'ksquare');
            set(bins_p,'MarkerSize',6);
            set(bins_p,'MarkerFaceColor',[0 0 0]);
           
            
            opts3 = fitoptions('Method','NonlinearLeastSquares');
            opts3.Lower = [-inf -inf ];
            opts3.StartPoint = [0 0];
            opts3.Upper = [inf inf];
            ft3 = fittype(@(b, a, x ) b*x + a, 'independent', {'x'}, ...
                'dependent', {'y'}, 'coefficients',{'b','a'},'Options',opts3);
            
            % Fit model to data.
            [fit_t, gof_t] = fit(vetQ, vetdQ, ft3);
            f1 = plot(fit_t);
            set(f1,'LineWidth',3)
            set(f1,'Color',[0.8 0.8 0.8])
            a = fit_t.a;
            b = fit_t.b;

            
            [fit_mrc, gof_mrc] = fit(xmrc, ymrc, ft3);
            f2 = plot(fit_mrc,'r--');
            set(f2,'LineWidth',1.4);
            mrc_a = fit_mrc.a;
            mrc_b = fit_mrc.b;
  
            
            [fit_bins, gof_bins] = fit(xbins, ybins, ft3);
            f3 = plot(fit_bins,'k--');
            set(f3,'LineWidth',1.4);
            
            bins_a = fit_bins.a;
            bins_b = fit_bins.b;


            
            xlabel('log(Q)'); ylabel('log(-dQ/dt)')
%             if strcmp(char(cell(method_name(ifi))),'MRC')~=1
%                 legend('Original data','Recessions (Simulated)','MRC data','Fit Recessions (Simulated)','Fit MRC')
%             else
                legend('Recessions (Original data)','MRC data','Data BINs','Fit Recessions (LR)','Fit MRC (LR)','Fit BINs (LR)')
%             end
            %set(gca,'YScale',escala_y)
            %set(gca,'XScale',escala_x)
            saveas(fig3,['data\Results\',char(cell(nameDataFile)),'\dQdt_Vs_Q\fit_dQdt_Vs_Q_',num2str(ir),'.fig'])
            saveas(fig3,['data\Results\',char(cell(nameDataFile)),'\dQdt_Vs_Q\fit_dQdt_Vs_Q_',num2str(ir),'.png'])
            close(fig3)
            
            file_name = ['data\Results\',char(cell(nameDataFile)),'\dQdt_Vs_Q\report_dQdt_Vs_Q_',num2str(ir)];
            path_file = fopen([file_name,'.txt'],'w');
            
            % Report Parameters
            name_method = 'Linear Regression (Recessions)';
            ci = confint(fit_t); %confidence bounds
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,['                      ',name_method,'\r\n']);
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
            fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit_t.b), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
            fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(10^fit_t.a), ['( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']);
            fprintf(path_file,'--> Goodness of fit statistics\r\n');
            fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof_t.sse));
            fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof_t.rsquare));
            fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof_t.adjrsquare));
            fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof_t.rmse));
            
            
            name_method = 'Linear Regression (MRC)';
            ci = confint(fit_mrc); %confidence bounds
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,['                      ',name_method,'\r\n']);
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
            fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit_mrc.b), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
            fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(10^fit_mrc.a), ['( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']);
            fprintf(path_file,'--> Goodness of fit statistics\r\n');
            fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof_mrc.sse));
            fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof_mrc.rsquare));
            fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof_mrc.adjrsquare));
            fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof_mrc.rmse));
        
            name_method = 'Linear Regression (BINs)';
            ci = confint(fit_bins); %confidence bounds
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,['                      ',name_method,'\r\n']);
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
            fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit_bins.b), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
            fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(10^fit_bins.a), ['( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']);
            fprintf(path_file,'--> Goodness of fit statistics\r\n');
            fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof_bins.sse));
            fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof_bins.rsquare));
            fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof_bins.adjrsquare));
            fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof_bins.rmse));
              
            fclose(path_file);
    
elseif val == 4
%%
    method_name = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    ir = 1;        
     mkdir(['data\Results\',char(cell(nameDataFile)),'\Simulated_recessions\'])
     name_save = {'MRC' 'Maillet' 'Boussinesq' 'Coutagne' 'Wittenberg'};
    for itr = 1:length(method_fit_pos)
        newVal_class = itr;    
        ifi = method_fit_pos(itr);
        if ifi > 1
        MRC_automatic(method_name,ifi,ir);
        [sort_min_Recess] = sort_min_val(method_name,ifi,ir);
        
            
            opt= [check_Maillet;check_Boussinesq;check_Coutagne;check_Wittenberg];
            data_fit = sortrows(sort_min_Recess,1);
            
            tdata = ajuste_eixo_x*data_fit(:,1)-min(ajuste_eixo_x*data_fit(:,1));
            plot_tdata = ajuste_eixo_x*data_fit(:,1);
            ydata = ajuste_eixo_y*data_fit(:,2);
            Q0 = max(ydata);
            
            [fit1,fit2,fit3,fit4,gof1,gof2,gof3,gof4] = createFit(tdata,ydata,opt);
           
            fig4 = figure; % New figure
            
            plot_curv_Callback(hObject, eventdata, handles)
            
            mrc = plot(plot_tdata, ydata,'ro');
            set(mrc,'MarkerSize',6);
            
            file_name = ['data\Results\',char(cell(nameDataFile)),'\Simulated_recessions\report_MRC_',char(cell(name_save(ifi)))];
            path_file = fopen([file_name,'.txt'],'w');
            
            if check_Maillet==1 && ifi ==2
                
                % % % Plot fit with data Maillet
                a = fit1.a;
                y_m = Q0*exp(-a*tdata);
                h1 = plot(plot_tdata,y_m,'c');
                %h1 = plot(fit1,'c');
                set(h1,'LineWidth',2);
                
                name_method = 'Fit Maillet';
                ci = confint(fit1); %confidence bounds
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',name_method,'\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
                fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit1.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
                %fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
                fprintf(path_file,'--> Goodness of fit statistics\r\n');
                fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof1.sse));
                fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof1.rsquare));
                fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof1.adjrsquare));
                fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof1.rmse));
                
            end
            
            if check_Boussinesq == 1 && ifi == 3
                % % Plot fit with data Boussinesq
                a = fit2.a;
                y_bouss = Q0*(1+a*tdata).^-2;
                h2 = plot(plot_tdata,y_bouss,'b--');
                %h2 = plot(fit2,'b');
                set(h2,'LineWidth',1.4);
                
                name_method = 'Fit Boussinesq';
                ci = confint(fit2); %confidence bounds
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',name_method,'\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
                fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit2.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
                %fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
                fprintf(path_file,'--> Goodness of fit statistics\r\n');
                fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof2.sse));
                fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof2.rsquare));
                fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof2.adjrsquare));
                fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof2.rmse));
                
            end
            
            if check_Coutagne == 1 && ifi ==4
                % % Plot fit with data Coutagne
                Coutagne_par_a= fit3.a;
                Coutagne_par_b= fit3.b;
                y_cout =((Q0^(1-Coutagne_par_b))-(1-Coutagne_par_b)*Coutagne_par_a*tdata).^(1/(1-Coutagne_par_b));
                h3 = plot(plot_tdata,y_cout,'g');
                %h3 = plot(fit3,'g');
                set(h3,'LineWidth',3);
                
                name_method = 'Fit Coutagne';
                ci = confint(fit3); %confidence bounds
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',name_method,'\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
                fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit3.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
                fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit3.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
                fprintf(path_file,'--> Goodness of fit statistics\r\n');
                fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof3.sse));
                fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof3.rsquare));
                fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof3.adjrsquare));
                fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof3.rmse));
                
            end
            
            if check_Wittenberg == 1 && ifi == 5
                % %Plot fit with data Wittenberg
                Witt_par_a=fit4.a;
                Witt_par_b=fit4.b;
                Wittenberg_Q =  Q0*(1+((1-Witt_par_b)*Q0^(1-Witt_par_b)).*tdata./(Witt_par_a*Witt_par_b)).^(1/(Witt_par_b-1));
                h4 = plot(plot_tdata,Wittenberg_Q,'m--');

                %h4 = plot(fit4,'m');
                set(h4,'LineWidth',1.4);
                
                name_method = 'Fit Wittenberg';
                ci = confint(fit4); %confidence bounds
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',name_method,'\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
                fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(fit4.a), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
                fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit4.b), ['( ', num2str(ci(3)),' |--| ', num2str(ci(4)),' )']);
                fprintf(path_file,'--> Goodness of fit statistics\r\n');
                fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof4.sse));
                fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof4.rsquare));
                fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof4.adjrsquare));
                fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof4.rmse));
            end
            fclose(path_file);
            
            %%=======================================================
            xlabel(nome_eixo_x)
            ylabel(nome_eixo_y)
            set(gca,'YScale',escala_y)
            set(gca,'XScale',escala_x)
            
            % Creation of graphics captions
            MRC = 1;
            fit_select = [MRC,check_Maillet,check_Boussinesq,check_Coutagne,check_Wittenberg];
            fit_def = [h mrc];
            fit_name_str = {'Recession Curves'};
            fit_name_str = [fit_name_str {'MRC Data'}];
            if fit_select(2)==1 && ifi == 2
                fit_def = [fit_def h1];
                fit_name_str = [fit_name_str,{'Fit Maillet'}];
            end
            if fit_select(3)==1 && ifi == 3
                fit_def = [fit_def h2];
                fit_name_str = [fit_name_str,{'Fit Boussinesq'}];
            end
            if fit_select(4)==1 && ifi == 4
                fit_def = [fit_def h3];
                fit_name_str = [fit_name_str,{'Fit Coutagne'}];
            end
            if fit_select(5)==1 && ifi == 5
                fit_def = [fit_def h4];
                fit_name_str = [fit_name_str,{'Fit Wittenberg'}];
            end
            legend(fit_def,fit_name_str)
            
            saveas(fig4,['data\Results\',char(cell(nameDataFile)),'\Simulated_recessions\fit_MRC_',char(cell(name_save(ifi))),'.fig'])
            saveas(fig4,['data\Results\',char(cell(nameDataFile)),'\Simulated_recessions\fit_MRC_',char(cell(name_save(ifi))),'.png'])
            close(fig4)
            
            %=====================================
            % log10(-dQdt) Vs log10(Q)
            %=====================================
            dimDir=length(dir(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir)]))-2;
            
            fig5 = figure; % New Figure (log10(-dQdt) Vs log10(Q))            
            hold on
            
            if strcmp(char(cell(method_name(ifi))),'MRC')~=1
                orig_vetQ = [];
                orig_vetdQ = [];
                for it = 1:dimDir
                    load(['data\data_base\',char(cell(method_name(1))),'_',num2str(ir),'\Recess_',num2str(it),'.mat'],'coordenadas','coordenadas_b');
                    pos =find(coordenadas(:,2));
                    orig_Q =  coordenadas(pos,2);
                    orig_Qm = (orig_Q(1:end-1)+orig_Q(2:end))./2;
                    orig_dQ = diff(coordenadas(pos,2));
                    orig_vetQ = [orig_vetQ;orig_Qm(1:end)];
                    orig_vetdQ = [orig_vetdQ;orig_dQ];
                end
                plot(log10(orig_vetQ),log10(-orig_vetdQ),'r.','Color',[0.6 0.6 0.6])
            end
            
            vetQ = [];
            vetdQ = [];
            for it = 1:dimDir
                load(['data\data_base\',char(cell(method_name(ifi))),'_',num2str(ir),'\Recess_',num2str(it),'.mat'],'coordenadas','coordenadas_b');
                pos =find(coordenadas(:,2));
                Q =  coordenadas(pos,2);
                Qm = (Q(1:end-1)+Q(2:end))./2;
                dQ = diff(coordenadas(pos,2));
                vetQ = [vetQ;Qm(1:end)];
                vetdQ = [vetdQ;dQ];
            end
            
            % =============================================================
            % Data Binning (Kirchner 2009)
            % =============================================================
            Qbin=sortrows([log10(-vetdQ) log10(vetQ)],-2); % Sort the data to get the bins
            pbin=ceil(size(Qbin,1)*0.01); %number of elements in each range of percentage values
            BIN=[];
            while size(Qbin,1)>0
                try
                    BIN=[BIN; mean(Qbin(1:pbin,:))]; %
                    Qbin(1:pbin,:)=[]; %
                catch mensaje
                    if size(Qbin,1)>1
                        BIN=[BIN; mean(Qbin)]; %
                    end
                    Qbin=[];
                end
            end
            BIN(end,:)=[];
            D=[(1:size(BIN,1))' -10.^(BIN(:,1)) 10.^(BIN(:,2))]; %
            REC=D; %
            % ===============================================================
            
            if strcmp(char(cell(method_name(ifi))),'MRC')==1
                plot(log10(vetQ),log10(-vetdQ),'k.','Color',[0.6 0.6 0.6])
            else
                plot(log10(vetQ),log10(-vetdQ),'k.','Color',[0.2 0.6 1])
            end
            
            mrc = data_fit(:,2);
            diffmrc1 = diff(mrc);
            mrcdata = mrc(diffmrc1~=0 & diffmrc1<0); % 
            diffmrcdata = diff(mrcdata);
           
            % Linear regression
            % Defining log10 (Q) and log (-dQ) values of the BINs
            xbins = log10(REC(:,3));
            ybins = log10(REC(:,2));
            
            % Linear regression
            % Defining log10 (Q) and log (-dQ) values of the MRC
            xmrc = log10((mrcdata(1:end-1)+mrcdata(2:end))./2);
            ymrc = log10(-diffmrcdata);
            
            % Defining log10 (Q) and log (-dQ) values of the set of all recessions
            vetQ = log10(vetQ);
            vetdQ = log10(-vetdQ);
            
            opts3 = fitoptions('Method','NonlinearLeastSquares');
            opts3.Lower = [-inf -inf ];
            opts3.StartPoint = [0 0];
            opts3.Upper = [inf inf];
            ft3 = fittype(@(b, a, x ) b*x + a, 'independent', {'x'}, ...
                'dependent', {'y'}, 'coefficients',{'b','a'},'Options',opts3);
            
            % Fit model to data.
            [fit_t, gof_t] = fit(vetQ, vetdQ, ft3);
            f1 = plot(fit_t);
            if strcmp(char(cell(method_name(ifi))),'MRC')==1
                set(f1,'Color',0.8*ones(1,3))
            else
                set(f1,'Color',[0.2 0.6 1])
            end
            set(f1,'LineWidth',3)
            a = fit_t.a;
            b = fit_t.b;
  
            
             mrc_p = plot(xmrc,ymrc,'ro');
            set(mrc_p,'MarkerSize',6);
            
            [fit_mrc, gof_mrc] = fit(xmrc, ymrc, ft3);
            f2 = plot(fit_mrc,'r--');
            set(f2,'LineWidth',1.3);
            mrc_a = fit_mrc.a;
            mrc_b = fit_mrc.b;
   
            
            %Plot BINs data
            bins_p = plot(xbins,ybins,'ksquare');
            set(bins_p,'MarkerSize',6);
            set(bins_p,'MarkerFaceColor',[0 0 0]);
            
            [fit_bins, gof_bins] = fit(xbins, ybins, ft3);
            f3 = plot(fit_bins,'k--');
            set(f3,'LineWidth',1.3);
            
            bins_a = fit_bins.a;
            bins_b = fit_bins.b;

            
            xlabel('log(Q)'); ylabel('log(-dQ/dt)')
            if strcmp(char(cell(method_name(ifi))),'MRC')~=1
                legend('Original data','Recessions (Simulated)','Fit Recessions (Simulated)','MRC data','Fit MRC','Data BINs','Fit BINs (LR)')
            else
                legend('Recessions (Original data)','Fit Recessions (LR)','MRC data','Fit MRC (LR)','Data BINs','Fit BINs (LR)')
            end
            %set(gca,'YScale',escala_y)
            %set(gca,'XScale',escala_x)
            saveas(fig5,['data\Results\',char(cell(nameDataFile)),'\Simulated_recessions\fit_dQdt_Vs_Q_',char(cell(name_save(ifi))),'.fig'])
            saveas(fig5,['data\Results\',char(cell(nameDataFile)),'\Simulated_recessions\fit_dQdt_Vs_Q_',char(cell(name_save(ifi))),'.png'])
            close(fig5)
            
            file_name = ['data\Results\',char(cell(nameDataFile)),'\Simulated_recessions\report_dQdt_Vs_Q_',char(cell(name_save(ifi)))];
            path_file = fopen([file_name,'.txt'],'w');
            
            % Report Parameters
                       
            if strcmp(char(cell(method_name(ifi))),'MRC')~=1
                name_method = {['Linear Regression (Recessions (Simulated-',char(cell(method_name(ifi))),'))']};
            else
                name_method = {'Linear Regression (all recessions)'};
            end            
            
            ci = confint(fit_t); %confidence bounds
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,['                      ',char(cell(name_method)),'\r\n']);
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
            fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit_t.b), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
            fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(10^fit_t.a), ['( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']);
            fprintf(path_file,'--> Goodness of fit statistics\r\n');
            fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof_t.sse));
            fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof_t.rsquare));
            fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof_t.adjrsquare));
            fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof_t.rmse));
                        
            if strcmp(char(cell(method_name(ifi))),'MRC')~=1
                name_method = {['Linear Regression (MRC (Simulated-',char(cell(method_name(ifi))),'))']};
            else
                name_method = {'Linear Regression (MRC data)'};
            end             
            ci = confint(fit_mrc); %confidence bounds
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,['                      ',char(cell(name_method)),'\r\n']);
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
            fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit_mrc.b), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
            fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(10^fit_mrc.a), ['( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']);
            fprintf(path_file,'--> Goodness of fit statistics\r\n');
            fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof_mrc.sse));
            fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof_mrc.rsquare));
            fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof_mrc.adjrsquare));
            fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof_mrc.rmse));
           
            
            if strcmp(char(cell(method_name(ifi))),'MRC')~=1
                name_method = {['Linear Regression (BINs (Simulated-',char(cell(method_name(ifi))),'))']};
            else
                name_method = {'Linear Regression (BINs data)'};
            end             
            ci = confint(fit_bins); %confidence bounds
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,['                      ',char(cell(name_method)),'\r\n']);
            fprintf(path_file,'***************************************************************\r\n')
            fprintf(path_file,'%6s %18s %30s\r\n','Parameters','Fit Value', 'Confidence Bounds (95%)');
            fprintf(path_file,'%5s %21s %33s\r\n','b',num2str(fit_bins.b), ['( ', num2str(ci(1)),' |--| ', num2str(ci(2)),' )']);
            fprintf(path_file,'%5s %21s %33s\r\n','a',num2str(10^fit_bins.a), ['( ', num2str(10^ci(3)),' |--| ', num2str(10^ci(4)),' )']);
            fprintf(path_file,'--> Goodness of fit statistics\r\n');
            fprintf(path_file,'%5s %10s\r\n','The sum of squares due to error (SSE): ',num2str(gof_bins.sse));
            fprintf(path_file,'%5s %39s\r\n','R-square: ',num2str(gof_bins.rsquare));
            fprintf(path_file,'%5s %30s\r\n','Adjusted R-square: ',num2str(gof_bins.adjrsquare));
            fprintf(path_file,'%5s %17s\r\n','Root mean squared error (RMSE): ',num2str(gof_bins.rmse));       

            fclose(path_file);
            % =============================
        end
    end
end


% --------------------------------------------------------------------
function import_recession_c_Callback(hObject, eventdata, handles)
% hObject    handle to import_recession_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile( ...
       {'*.xlsx','excel (*.xlsx)'; ...
        '*.xls','excel (*.xls)'}, ...
        'Pick a file', ...
        'MultiSelect', 'off');       

ir  = 1;
if isdir(['data\data_base\MRC_',num2str(ir),'\'])~=0
delete(['data\data_base\MRC_',num2str(ir),'\*.mat']);
else
mkdir(['data\data_base\MRC_',num2str(ir),'\'])
end

if isdir('data\data_base\matrix\')~=0
delete('data\data_base\matrix\*.mat');
elseif isdir ('data\data_base\matrix') == 0
mkdir ('data\data_base\matrix'); 
end

  if filename~=0
  
  [num_data,TXT,RAW] = xlsread([pathname,filename]);  
  leng_data = size(num_data,1);
  
  [p, n_r] = unique(num_data(:,1));   
  n_curves = length(n_r);
  n_r = [n_r;size(num_data,1)];
  d = 0;
%   i=0;
%   if n_curves>=2
      for i = 1:n_curves
          d = d+1;
          if i<n_curves
          coordenadas =[[0:(n_r(i+1)-n_r(i))-1]' num_data(n_r(i):n_r(i+1)-1,2)];
          coordenadas_b =[[0:(n_r(i+1)-n_r(i))-1]' num_data(n_r(i):n_r(i+1)-1,2)];          
          save(['data\data_base\MRC_',num2str(ir),'\Recess_',num2str(d)],'coordenadas','coordenadas_b')
          elseif i==n_curves
          coordenadas =[[0:(n_r(i+1)-n_r(i))]' num_data(n_r(i):n_r(i+1),2)];
          coordenadas_b =[[0:(n_r(i+1)-n_r(i))]' num_data(n_r(i):n_r(i+1),2)];          
          save(['data\data_base\MRC_',num2str(ir),'\Recess_',num2str(d)],'coordenadas','coordenadas_b')    
          end
      end
%   d = d+1;
%   coordenadas = [[0:(size(num_data,1)- n_r(i+1))]' num_data(n_r(end):end,2)];
%   coordenadas_b = [[0:(size(num_data,1)- n_r(i+1))]' num_data(n_r(end):end,2)];
%   else
%   d = d+1;
%   coordenadas = [[0:(size(num_data,1)- n_r(i+1))]' num_data(n_r(end):end,2)];
%   coordenadas_b = [[0:(size(num_data,1)- n_r(i+1))]' num_data(n_r(end):end,2)];       
%   end
  
  save(['data\data_base\MRC_',num2str(ir),'\Recess_',num2str(d)],'coordenadas','coordenadas_b')  
  files = dir(['data\data_base\MRC_',num2str(ir),'/']);%fullfile(pwd,'Folder01','*.png'));  
  set(handles.listbox1,'string',{files.name});
  nv=length(dir(['data\data_base\MRC_',num2str(ir)]))-2;
  set(handles.text_quant_recess,'string',['N = ',num2str(nv)]);
  end
