% *************************************************************************
%  Numerical Filters for Hydrographs Separation (filter_guide)
% *************************************************************************
% Authors: Tomas Carlotto and Pedro Luiz Borges Chaffe
% Developer: Tomas Carlotto
% Contact address: thomas.carl@hotmail.com
% *************************************************************************
% This code or any part of it may be used as long as the authors are cited.
% Under no circumstances will authors or copyright holders be liable for any claims,
% damages or other liability arising from the use any part of related code.
% *************************************************************************
% This code uses the following subfunctions:
%          chapman.m       - Chapman's numeric filter
%          Eckhardt.m      - Eckhardt's numeric filter
%          LyneHollickM.m  - Lyne-Hollick's numeric filter

function varargout = filter_guide(varargin)
% FILTER_GUIDE MATLAB code for filter_guide.fig
%      FILTER_GUIDE, by itself, creates a new FILTER_GUIDE or raises the existing
%      singleton*.
%
%      H = FILTER_GUIDE returns the handle to a new FILTER_GUIDE or the handle to
%      the existing singleton*.
%
%      FILTER_GUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTER_GUIDE.M with the given input arguments.
%
%      FILTER_GUIDE('Property','Value',...) creates a new FILTER_GUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filter_guide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filter_guide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filter_guide

% Last Modified by GUIDE v2.5 21-Aug-2020 08:32:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filter_guide_OpeningFcn, ...
                   'gui_OutputFcn',  @filter_guide_OutputFcn, ...
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


% --- Executes just before filter_guide is made visible.
function filter_guide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filter_guide (see VARARGIN)

% Choose default command line output for filter_guide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes filter_guide wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = filter_guide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in next_extract.
function next_extract_Callback(hObject, eventdata, handles)
% hObject    handle to next_extract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.select_filter,'Value');
if val == 1
    load('data\data_base\matrix\input','NUM','TXT','RAW');
    save('data\data_base\matrix\numeric_filter_data','NUM','TXT','RAW')
end
close

% --- Executes on selection change in select_filter.
function select_filter_Callback(hObject, eventdata, handles)
% hObject    handle to select_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_filter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_filter
val = get(handles.select_filter,'Value');
if val == 1    
   set(handles.param_BFImax_filter,'Enable','off') 
   set(handles.param_a_filter,'Enable','off') 
   set(handles.apply_filter,'Enable','off')
   set(handles.view_filter,'Enable','off')    
   set(handles.save_button,'Enable','off')
   set(handles.next_extract,'Enable','on')
elseif val==2
    set(handles.param_BFImax_filter,'Enable','off') 
    set(handles.param_a_filter,'Enable','on') 
    set(handles.apply_filter,'Enable','on')
    set(handles.view_filter,'Enable','off')  
    set(handles.save_button,'Enable','off')
    set(handles.next_extract,'Enable','off')
    
elseif val==3
    set(handles.param_BFImax_filter,'Enable','on') 
    set(handles.param_a_filter,'Enable','on') 
    set(handles.apply_filter,'Enable','on')
    set(handles.view_filter,'Enable','off')   
    set(handles.save_button,'Enable','off')
    set(handles.next_extract,'Enable','off')
else
    set(handles.param_BFImax_filter,'Enable','off') 
    set(handles.param_a_filter,'Enable','on') 
    set(handles.apply_filter,'Enable','on')
    set(handles.view_filter,'Enable','off')   
    set(handles.save_button,'Enable','off')
    set(handles.next_extract,'Enable','off')
end



% --- Executes during object creation, after setting all properties.
function select_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param_a_filter_Callback(hObject, eventdata, handles)
% hObject    handle to param_a_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param_a_filter as text
%        str2double(get(hObject,'String')) returns contents of param_a_filter as a double


% --- Executes during object creation, after setting all properties.
function param_a_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_a_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function param_BFImax_filter_Callback(hObject, eventdata, handles)
% hObject    handle to param_BFImax_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of param_BFImax_filter as text
%        str2double(get(hObject,'String')) returns contents of param_BFImax_filter as a double


% --- Executes during object creation, after setting all properties.
function param_BFImax_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to param_BFImax_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in view_filter.
function view_filter_Callback(hObject, eventdata, handles)
% hObject    handle to view_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
name = get(handles.select_filter,'String');
val = get(handles.select_filter,'Value');

hold on
load('data\data_base\matrix\input','NUM','TXT','RAW')
plot(NUM(:,1))
axis([0 length(NUM(:,1)) min(NUM(:,1)) max(NUM(:,1))])
load('data\data_base\matrix\numeric_filter_data','NUM','TXT','RAW')
bar(NUM(:,1),'k')
ylabel('Q(m^3/s)')
xlabel('Time')
legend('Total flow','Baseflow')


% --- Executes on button press in apply_filter.
function apply_filter_Callback(hObject, eventdata, handles)
% hObject    handle to apply_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   set(handles.view_filter,'Enable','off');
   set(handles.save_button,'Enable','off');
   pause(0.000001);
   val = get(handles.select_filter,'Value');
   BFImax = get(handles.param_BFImax_filter, 'String');
   BFImax = str2num(char(BFImax));   
   param_a = get(handles.param_a_filter, 'String');
   param_a = str2num(char(param_a));
   
load('data\data_base\matrix\input','NUM','TXT','RAW');
  
if val == 2         
   if (isempty(param_a)) 
       h = msgbox('Enter the parameter a', 'Warning:','warn');
   else       
       disp('Lyne - Hollick')
       %*******************************************************************
       [LHCalMat] = LyneHollickM(NUM,param_a,hObject, eventdata, handles);       
       %*******************************************************************
       NUM(:,1) =  LHCalMat';
       save('data\data_base\matrix\numeric_filter_data','NUM','TXT','RAW')
       
       set(handles.view_filter,'Enable','on'); 
       set(handles.next_extract,'Enable','on');
       set(handles.save_button,'Enable','on');
       
   end
end


if val == 3       
   
   if (isempty(BFImax) || isempty(param_a)) 
       h = msgbox('Verify that the BFImax and a parameters have been', 'Warning:','warn');
   else       
       disp('Eckhardt')          
       %*******************************************************************
       [EckCalMat] = Eckhardt(NUM,param_a,BFImax,hObject, eventdata, handles);
       %*******************************************************************
       NUM(:,1) =  EckCalMat';
       save('data\data_base\matrix\numeric_filter_data','NUM','TXT','RAW')
       
       set(handles.view_filter,'Enable','on'); 
       set(handles.next_extract,'Enable','on');
       set(handles.save_button,'Enable','on');
   end   

end

if val == 4
   if (isempty(param_a)) 
       h = msgbox('Enter the parameter a', 'Warning:','warn');
   else              
       disp('Chapman')
       %*******************************************************************
       [Qchapman] = chapman(NUM,param_a,hObject, eventdata, handles);
       %*******************************************************************
       NUM(:,1) =  Qchapman';
       save('data\data_base\matrix\numeric_filter_data','NUM','TXT','RAW')
       
       set(handles.view_filter,'Enable','on'); 
       set(handles.next_extract,'Enable','on');
       set(handles.save_button,'Enable','on');
   end
end


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


rg_data = questdlg(['Would you like to save the hydrograph separation data?'], ...
    'Save file', ...
    'Save file','Exit','Exit');
switch rg_data
    case 'Save file'
        
        load('data\data_base\matrix\input','NUM','TXT','RAW')
        runoff = NUM(:,1);
        
        load('data\data_base\matrix\numeric_filter_data','NUM','TXT','RAW')
        baseflow = NUM(:,1);
        
        
        [namefile,path] = uiputfile({'.xlsx',  'Excel (*.xlsx)';'.txt', 'text file(*.txt)'});
        if path ~=0
            T = table(runoff,baseflow);
            
            T.Properties.VariableNames = {'Runoff' 'Baseflow'};
            writetable(T,[path,namefile])
        end
        
        
    case 'Exit'
end
