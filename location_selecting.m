function varargout = location_selecting(varargin)
% LOCATION_SELECTING MATLAB code for location_selecting.fig
%      LOCATION_SELECTING, by itself, creates a new LOCATION_SELECTING or raises the existing
%      singleton*.
%
%      H = LOCATION_SELECTING returns the handle to a new LOCATION_SELECTING or the handle to
%      the existing singleton*.
%
%      LOCATION_SELECTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOCATION_SELECTING.M with the given input arguments.
%
%      LOCATION_SELECTING('Property','Value',...) creates a new LOCATION_SELECTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before location_selecting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to location_selecting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help location_selecting

% Last Modified by GUIDE v2.5 18-Jun-2021 20:17:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @location_selecting_OpeningFcn, ...
                   'gui_OutputFcn',  @location_selecting_OutputFcn, ...
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


% --- Executes just before location_selecting is made visible.
function location_selecting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to location_selecting (see VARARGIN)

% Choose default command line output for location_selecting
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
geolimits([-20 70],[-180 80])
geobasemap topographic

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes location_selecting wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = location_selecting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
