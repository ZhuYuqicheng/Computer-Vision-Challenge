function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 20-Jun-2021 17:48:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

coordinates = [
 -3.4653, -62.2159;... %Brazilian Rainforest:3.4653°S, 62.2159°W
 61.2197, -146.8953;...%Columbia Glacier:61.2197°N, 146.8953°W
 25.2048, 55.2708;...  %Dubai:25.2048°N, 55.2708°E
 29.3117, 47.4818;...  %Kuwait:29.3117°N, 47.4818°E
 48.1351, 11.5820      %Theresienwiese, München:48.1351°N, 11.5820°E 
 ];                       
lats = coordinates(:, 1);
lons = coordinates(:, 2);

name_list = [{sprintf('Brazilian\n Rainforest')},...
             {sprintf('Columbia\n Glacier')},...
             {sprintf('\n Dubai')},...
             {sprintf('Kuwait\n')},...
             {sprintf('Münchner\n Theresienwiese')}];

geoscatter(lats, lons, ...
           'o', 'LineWidth', 1.5);
text(lats, lons, name_list,...
    'HorizontalAlignment','center',...
    'FontSize', 12);
geolimits([-15 70],[-180 90]);
geobasemap('topographic');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over brazilian_rainforest.
function brazilian_rainforest_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to brazilian_rainforest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over columbia_glacier.
function columbia_glacier_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to columbia_glacier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over munich_wiesn.
function munich_wiesn_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to munich_wiesn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over kuwait.
function kuwait_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to kuwait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over dubai.
function dubai_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dubai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function panel_show(hObject, eventdata, handles)
set(handles.mode_panel, 'Visible', 'On');
set(handles.panel_return, 'Visible', 'On');
set(handles.panel_text1, 'Visible', 'On');
set(handles.diff_highlights, 'Visible', 'On');
set(handles.time_lapse, 'Visible', 'On');

% --- Executes on button press in brazilian_rainforest.
function brazilian_rainforest_Callback(hObject, eventdata, handles)
% hObject    handle to brazilian_rainforest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
panel_show(hObject, eventdata, handles);

% --- Executes on button press in columbia_glacier.
function columbia_glacier_Callback(hObject, eventdata, handles)
% hObject    handle to columbia_glacier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
panel_show(hObject, eventdata, handles);

% --- Executes on button press in munich_wiesn.
function munich_wiesn_Callback(hObject, eventdata, handles)
% hObject    handle to munich_wiesn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
panel_show(hObject, eventdata, handles);

% --- Executes on button press in kuwait.
function kuwait_Callback(hObject, eventdata, handles)
% hObject    handle to kuwait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
panel_show(hObject, eventdata, handles);

% --- Executes on button press in dubai.
function dubai_Callback(hObject, eventdata, handles)
% hObject    handle to dubai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
panel_show(hObject, eventdata, handles);

% --- Executes on button press in panel_return.
function panel_return_Callback(hObject, eventdata, handles)
% hObject    handle to panel_return (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.mode_panel, 'Visible', 'Off');
set(handles.panel_return, 'Visible', 'Off');
set(handles.panel_text1, 'Visible', 'Off');
set(handles.diff_highlights, 'Visible', 'Off');
set(handles.time_lapse, 'Visible', 'Off');


% --- Executes during object creation, after setting all properties.
function panel_text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to panel_text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in diff_highlights.
function diff_highlights_Callback(hObject, eventdata, handles)
% hObject    handle to diff_highlights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in time_lapse.
function time_lapse_Callback(hObject, eventdata, handles)
% hObject    handle to time_lapse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
