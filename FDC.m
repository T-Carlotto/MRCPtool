% *************************************************************************
%  MRC Separation Tool using Flow duration curve (FDC)
% *************************************************************************
% Authors: Tomas Carlotto and Pedro Luiz Borges Chaffe
% Developer: Tomas Carlotto
% Contact address: thomas.carl@hotmail.com
% *************************************************************************
% This code or any part of it may be used as long as the authors are cited.
% Under no circumstances will authors or copyright holders be liable for any claims,
% damages or other liability arising from the use any part of related code.
% *************************************************************************
% This code uses the following subfunction:
%         MRC_automatic.m  - Automated method of creating MRCs

function varargout = FDC(varargin)
% FDC MATLAB code for FDC.fig
%      FDC, by itself, creates a new FDC or raises the existing
%      singleton*.
%
%      H = FDC returns the handle to a new FDC or the handle to
%      the existing singleton*.
%
%      FDC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FDC.M with the given input arguments.
%
%      FDC('Property','Value',...) creates a new FDC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FDC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FDC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FDC

% Last Modified by GUIDE v2.5 20-Nov-2018 08:21:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FDC_OpeningFcn, ...
                   'gui_OutputFcn',  @FDC_OutputFcn, ...
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


% --- Executes just before FDC is made visible.
function FDC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FDC (see VARARGIN)

if isdir('data\data_base\matrix')~=0
load('data\data_base\matrix\numeric_filter_data.mat')

QsemNaN = NUM(isnan(NUM(:,1))==0,1);

Qsem0 = QsemNaN(QsemNaN~=0);
N = length(QsemNaN);
n0 = N-length(Qsem0);
p0 = n0/N;
sortQ = sort(QsemNaN,'Descend');
R = 1:1:N;
e1 = (1/N)*(R - (1/2));                               %Weibull
ep0 = e1/(1-p0);
e1(sortQ(:,1)==0) = e1(sortQ(:,1)==0)/(1-p0);
e1(sortQ(:,1)>0 & sortQ(:,1)<1) = e1(sortQ(:,1)>0 & sortQ(:,1)<1)/(1-p0);         %Probability of zero value

hold on
plot(e1,sortQ)
axis([0 1 min(QsemNaN(QsemNaN~=0,1)) max(QsemNaN)])
xlabel('Exceedance probability')
ylabel('Q(m^3s^{-1})')
set(gca,'YScale','log')
set(gca,'XScale','linear')
end

% Choose default command line output for FDC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FDC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FDC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes on button press in interval.
function interval_Callback(hObject, eventdata, handles)
% hObject    handle to interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global n_class;
edit_fig = get(handles.checkEditFig,'Value');
if isdir('data\data_base\matrix')~=0
load('data\data_base\matrix\numeric_filter_data.mat')

%*******************************************
if isdir('data\data_base\classes\')~=0        
   rmdir('data\data_base\classes','s');                    
   mkdir('data\data_base\classes\');  
else
   mkdir('data\data_base\classes\');
end 

% *******************************************
QsemNaN = NUM(isnan(NUM(:,1))==0,1);

Qsem0 = QsemNaN(QsemNaN(:,1)~=0);
N = length(QsemNaN);
sortQ = sort(QsemNaN,'Descend');
n0 = N-length(Qsem0);
p0 = n0/N;
R = 1:1:N;
e1 = (1/N)*(R - (1/2));                               %Weibull
ep0 = e1/(1-p0);
e1(sortQ(:,1)==0) = e1(sortQ(:,1)==0)/(1-p0);
e1(sortQ(:,1)>0 & sortQ(:,1)<1) = e1(sortQ(:,1)>0 & sortQ(:,1)<1)/(1-p0);

    cla('reset')
    if edit_fig == 1
    figure
    end
    hold on
    plot(e1,sortQ)
    axis([0 1 min(QsemNaN(QsemNaN~=0)) max(QsemNaN)])
    xlabel('Exceedance probability')
    ylabel('Q(m^3s^{-1})')
    set(gca,'YScale','log')
    set(gca,'XScale','linear')

% *******************************************

n_class = get(handles.n_class,'string');
n_class  = str2num(char(n_class));

MRC_class = zeros(n_class,2);

    if n_class>1
        class = zeros(n_class-1,2);
       for i = 1:n_class-1
        
           [class(i,1),class(i,2)] = ginput(1);                              
           pos = length(e1(e1<=class(i,1)));
           class(i,2) = sortQ(pos,1);                      
           plot([class(i,1) class(i,1)],[min(QsemNaN(QsemNaN~=0)) max(QsemNaN)],'r')                             
           
       end      
       sort_class = sortrows(class,1);      
       % ******************************************************
       if (n_class - 1) == 1           
             for ic = 1:2
                 if ic==1
                 class_12 = {['' 'Classe ', num2str(ic),':' ''];['X: ' num2str(e1(ic)) ' |--| ' num2str(sort_class(ic,1))];['Y: ' num2str(sortQ(ic)) ' |--| ' num2str(sort_class(1,2))]};
                
                 MRC_class(1,2) = sortQ(ic);
                 MRC_class(1,1) = sort_class(1,2);
                 
                 else
                 class_23 = {['' 'Classe ', num2str(ic),':' ''];['X: ' num2str(sort_class(1,1)) ' |--| ' num2str(1)];['Y: ' num2str(sort_class(1,2)) ' |--| ' num2str(min(sortQ(sortQ~=0)))]};
                 class_12 = [class_12;class_23];
                 
                 MRC_class(2,2) = sort_class(1,2);
                 MRC_class(2,1) = min(sortQ(sortQ~=0));
                 
                 end                 
             end           
             set(handles.listbox_limits,'string', class_12);
       else                       
             for ic = 1:n_class
                 if ic==1
                 class_12 = {['' 'Classe ', num2str(ic),':' ''];['X: ' num2str(e1(ic)) ' |--| ' num2str(sort_class(ic,1))];['Y: ' num2str(sortQ(ic)) ' |--| ' num2str(sort_class(ic,2))]};
                 
                 MRC_class(1,2) = sortQ(ic);
                 MRC_class(1,1) = sort_class(ic,2);  
                 
                 elseif ic <= n_class-1 
                 class_23 = {['' 'Classe ', num2str(ic),':' ''];['X: ' num2str(sort_class(ic-1,1)) ' |--| ' num2str(sort_class(ic,1))];['Y: ' num2str(sort_class(ic-1,2)) ' |--| ' num2str(sort_class(ic,2))]};
                 class_12 = [class_12;class_23];
                 
                 MRC_class(ic,2) = sort_class(ic-1,2);
                 MRC_class(ic,1) = sort_class(ic,2); 
                 
                 elseif ic == n_class
                 class_23 = {['' 'Classe ', num2str(ic),':' ''];['X: ' num2str(sort_class(ic-1,1)) ' |--| ' num2str(1)];['Y: ' num2str(sort_class(ic-1,2)) ' |--| ' num2str(min(sortQ(sortQ~=0)))]};
                 class_12 = [class_12;class_23];    
                 
                 MRC_class(ic,2) = sort_class(ic-1,2);
                 MRC_class(ic,1) = min(sortQ(sortQ~=0)); 
                 
                 end                 
             end                       
       % ******************************************************
       set(handles.listbox_limits,'string', class_12);             
       end       
    end    
    
    save('data\data_base\classes\MRC_class','MRC_class')    
end 

% --- Executes on selection change in listbox_limits.
function listbox_limits_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_limits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_limits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_limits


% --- Executes during object creation, after setting all properties.
function listbox_limits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_limits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in classific.
function classific_Callback(hObject, eventdata, handles)
% hObject    handle to classific (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('data\data_base\matrix\numeric_filter_data.mat')
load('data\data_base\classes\MRC_class.mat','MRC_class')

for ir = 1:size(MRC_class,1)    
    
    if isdir(['data\data_base\MRC_class_',num2str(ir),'\'])~=0        
             delete(['data\data_base\MRC_class_',num2str(ir),'\*.mat']);        
       else            
             mkdir(['data\data_base\MRC_class_',num2str(ir),'\']);        
    end
    
%    iter = length(dir(['data\data_base\Recess']))-2;
    iter = length(dir(['data\data_base\MRC_1']))-2; 
    is=0;
    for j = 1:iter
        load(['data\data_base\MRC_1\Recess_',num2str(j)],'coordenadas','coordenadas_b');
%      load(['data\data_base\Recess\Recess_',num2str(j)],'coordenadas','coordenadas_b');      
%      if (min(coordenadas(:,2))>=MRC_class(ir,1) && max(coordenadas(:,2))<=MRC_class(ir,2))
      if (min(coordenadas(:,2))>=MRC_class(ir,1) && min(coordenadas(:,2))<=MRC_class(ir,2))
          is=is+1;
          save(['data\data_base\MRC_class_',num2str(ir),'\Recess_',num2str(is)],'coordenadas','coordenadas_b')%,'coordenadas_b')          
      end
    end
end

n_class = get(handles.n_class,'string');
n_class  = str2num(char(n_class));

for ir = 1:n_class
    method = {'MRC_class'};
    ifi = 1;    
    MRC_automatic(method,ifi,ir);
end

close(FDC)


function n_class_Callback(hObject, eventdata, handles)
% hObject    handle to n_class (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_class as text
%        str2double(get(hObject,'String')) returns contents of n_class as a double



% --- Executes during object creation, after setting all properties.
function n_class_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_class (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clean_graph.
function clean_graph_Callback(hObject, eventdata, handles)
% hObject    handle to clean_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla('reset')


% --- Executes on button press in checkEditFig.
function checkEditFig_Callback(hObject, eventdata, handles)
% hObject    handle to checkEditFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkEditFig
