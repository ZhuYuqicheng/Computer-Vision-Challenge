classdef GUI_run < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ClimateChangeAppUIFigure  matlab.ui.Figure
        Tree                      matlab.ui.container.Tree
        TabGroup                  matlab.ui.container.TabGroup
        CurtainTab                matlab.ui.container.Tab
        BeforeandAfterLabel       matlab.ui.control.Label
        TextArea                  matlab.ui.control.TextArea
        leftTextAreaLabel         matlab.ui.control.Label
        leftTextArea              matlab.ui.control.TextArea
        rightTextAreaLabel        matlab.ui.control.Label
        rightTextArea             matlab.ui.control.TextArea
        TimeLapseTab              matlab.ui.container.Tab
        DifferenceHighlightTab    matlab.ui.container.Tab
        Year1DropDownLabel        matlab.ui.control.Label
        Year1DropDown             matlab.ui.control.DropDown
        Year2DropDownLabel        matlab.ui.control.Label
        Year2DropDown             matlab.ui.control.DropDown
        heatmapmodeSwitchLabel    matlab.ui.control.Label
        heatmapmodeSwitch         matlab.ui.control.RockerSwitch
        DensityControlpanelPanel  matlab.ui.container.Panel
        modeSwitchLabel           matlab.ui.control.Label
        modeSwitch                matlab.ui.control.Switch
        ThresholdKnob             matlab.ui.control.Knob
        partialSwitchLabel        matlab.ui.control.Label
        partialSwitch             matlab.ui.control.Switch
        ThresholdSpinnerLabel     matlab.ui.control.Label
        ThresholdSpinner          matlab.ui.control.Spinner
        increaseLamp              matlab.ui.control.Lamp
        decreaseLamp              matlab.ui.control.Lamp
        Lamp                      matlab.ui.control.Lamp
        UIAxes                    matlab.ui.control.UIAxes
        DiscriptionLabel          matlab.ui.control.Label
        DatasetNameTextAreaLabel  matlab.ui.control.Label
        DatasetNameTextArea       matlab.ui.control.TextArea
        PictureNumberLabel        matlab.ui.control.Label
        PictureNumberEditField    matlab.ui.control.NumericEditField
        SelectDirectoryButton     matlab.ui.control.Button
        Image                     matlab.ui.control.Image
    end

    
    properties (Access = public)
        dataset_path                                 % path of dataset
        result_path = 'Results';                     % path of generated pictures
        curtain_html_dir = 'Results/curtain';        % curtain html dir for saving processed pictures
        curtain_func_dir = 'functions/curtain';      % original curtain function dir
        timelapse_html_dir = 'Results/time_lapse';   % time lapse html directory
        timelapse_func_dir = 'functions/time_lapse'; % time lapse function directory
        cover_path = 'cover.png';
        
        % default dataset names
        default_dataset_names = {'Brazilian Rainforest', ...
            'Columbia Glacier', 'Dubai', 'Kuwait', 'Wiesn'};
        
        dataset_names                                % the name list of the select dataset
        
        selected_paths                               % path of the selected dataset
        select_data_name                             % the name of the selected dataset
        current_image_paths                          % paths of original images of the selected dataset
        current_image_names                          % names(dates) of original images of the selected dataset
        
        HTML_time                                    % html component for time lapse
        HTML_curtain                                 % html component for curtain
        
        timelapse_reverse = false;                   % control the sort of time lapse
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            addpath(genpath('functions'))
            % turn off warning
            warning('off','all')
            % keep GUI on the top
            set(app.ClimateChangeAppUIFigure,'WindowStyle','modal')
            % lock the interaction with difference highlight
            app.UIAxes.Interactions = [];
            % create result folder
            if ~exist(app.result_path, 'dir')
                mkdir(app.result_path)
            end
        end

        % Button pushed function: SelectDirectoryButton
        function SelectDirectoryButtonPushed(app, event)
            % select dataset directory with ui dialog
            GetDatasetList(app)
            % remove the cover
            app.Image.Visible = false;
        end

        % Selection changed function: Tree
        function TreeSelectionChanged(app, event)
            selectedNodes = app.Tree.SelectedNodes;
            if ~isempty(selectedNodes.NodeData)
                % save the selected dataset path
                app.selected_paths = selectedNodes.NodeData;
                % get the dataset name
                [~,dirname,~] = fileparts(selectedNodes.NodeData);
                app.select_data_name = dirname;
                % picture processing
                ProcessImageData_final(app)
                
                % difference highlight initialization
                DifferenceInitilization(app)
                % curtain initialization
                CurtainInitialization(app)
                % time lapse initialization
                TimelapseInitialization(app)
                
                % description 
                app.DatasetNameTextArea.Value = app.select_data_name;
                app.PictureNumberEditField.Value = length(app.current_image_names);
                
            else
                
            end
        end

        % Value changed function: Year1DropDown
        function Year1DropDownValueChanged(app, event)
            % update item 2
            value = app.Year1DropDown.Value;
            app.Year2DropDown.Items = setdiff(app.current_image_names, value);
            % visualization
            DifferenceHighlight(app)
        end

        % Value changed function: Year2DropDown
        function Year2DropDownValueChanged(app, event)
            % update item 1
            value = app.Year2DropDown.Value;
            app.Year1DropDown.Items = setdiff(app.current_image_names, value);
            % visualization
            DifferenceHighlight(app)
        end

        % Value changed function: partialSwitch
        function partialSwitchValueChanged(app, event)
            value = app.partialSwitch.Value;
            % enable mode switcher
            app.modeSwitch.Enable = value;
            % enable lamps
            if value == "On"
                app.increaseLamp.Enable = true;
                app.decreaseLamp.Enable = true;
                app.increaseLamp.Color = [1,1,0];
            elseif value == "Off"
                app.increaseLamp.Enable = false;
                app.decreaseLamp.Enable = false;
                app.increaseLamp.Color = [.94,.94,.94];
                app.decreaseLamp.Color = [.94,.94,.94];
            end
            % visualization
            DifferenceHighlight(app)
        end

        % Value changed function: modeSwitch
        function modeSwitchValueChanged(app, event)
            value = app.modeSwitch.Value;
            % change lamps
            if value == "increase"
                app.increaseLamp.Color = [1,1,0];
                app.decreaseLamp.Color = [.94,.94,.94];
            elseif value == "decrease"
                app.increaseLamp.Color = [.94,.94,.94];
                app.decreaseLamp.Color = [1,0,0];
            end
            % visualization
            DifferenceHighlight(app)
        end

        % Value changed function: heatmapmodeSwitch
        function heatmapmodeSwitchValueChanged(app, event)
            value = app.heatmapmodeSwitch.Value;
            % control lamp
            if value == "Off"
                app.Lamp.Color = [.94,.94,.94];
            elseif value == "On"
                app.Lamp.Color = [0,1,0];
            end
            % visualization
            DifferenceHighlight(app)
        end

        % Value changed function: ThresholdKnob
        function ThresholdKnobValueChanged(app, event)
            value = app.ThresholdKnob.Value;
            app.ThresholdSpinner.Value = value;
            % visualization
            DifferenceHighlight(app)
        end

        % Value changed function: ThresholdSpinner
        function ThresholdSpinnerValueChanged(app, event)
            value = app.ThresholdSpinner.Value;
            app.ThresholdKnob.Value = value;
            % visualization
            DifferenceHighlight(app)
        end

        % Close request function: ClimateChangeAppUIFigure
        function ClimateChangeAppUIFigureCloseRequest(app, event)
            % clean the Result files after closing the App 
            if exist(app.result_path, 'dir')
                rmdir(app.result_path, 's')
            end
            delete(app)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ClimateChangeAppUIFigure and hide until all components are created
            app.ClimateChangeAppUIFigure = uifigure('Visible', 'off');
            app.ClimateChangeAppUIFigure.Color = [1 1 1];
            app.ClimateChangeAppUIFigure.Position = [100 100 963 551];
            app.ClimateChangeAppUIFigure.Name = 'Climate Change App';
            app.ClimateChangeAppUIFigure.Resize = 'off';
            app.ClimateChangeAppUIFigure.CloseRequestFcn = createCallbackFcn(app, @ClimateChangeAppUIFigureCloseRequest, true);
            app.ClimateChangeAppUIFigure.WindowStyle = 'modal';

            % Create Tree
            app.Tree = uitree(app.ClimateChangeAppUIFigure);
            app.Tree.SelectionChangedFcn = createCallbackFcn(app, @TreeSelectionChanged, true);
            app.Tree.Position = [1 194 156 335];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.ClimateChangeAppUIFigure);
            app.TabGroup.Position = [155 1 810 551];

            % Create CurtainTab
            app.CurtainTab = uitab(app.TabGroup);
            app.CurtainTab.Title = 'Curtain';

            % Create BeforeandAfterLabel
            app.BeforeandAfterLabel = uilabel(app.CurtainTab);
            app.BeforeandAfterLabel.Position = [5 64 93 22];
            app.BeforeandAfterLabel.Text = 'Before and After';

            % Create TextArea
            app.TextArea = uitextarea(app.CurtainTab);
            app.TextArea.Editable = 'off';
            app.TextArea.WordWrap = 'off';
            app.TextArea.FontSize = 15;
            app.TextArea.FontWeight = 'bold';
            app.TextArea.Position = [5 38 260 27];

            % Create leftTextAreaLabel
            app.leftTextAreaLabel = uilabel(app.CurtainTab);
            app.leftTextAreaLabel.HorizontalAlignment = 'right';
            app.leftTextAreaLabel.FontColor = [0.502 0.502 0.502];
            app.leftTextAreaLabel.Position = [-3 11 25 22];
            app.leftTextAreaLabel.Text = 'left';

            % Create leftTextArea
            app.leftTextArea = uitextarea(app.CurtainTab);
            app.leftTextArea.Editable = 'off';
            app.leftTextArea.Position = [29 11 98 20];

            % Create rightTextAreaLabel
            app.rightTextAreaLabel = uilabel(app.CurtainTab);
            app.rightTextAreaLabel.HorizontalAlignment = 'right';
            app.rightTextAreaLabel.FontColor = [0.502 0.502 0.502];
            app.rightTextAreaLabel.Position = [130 10 29 22];
            app.rightTextAreaLabel.Text = 'right';

            % Create rightTextArea
            app.rightTextArea = uitextarea(app.CurtainTab);
            app.rightTextArea.Editable = 'off';
            app.rightTextArea.Position = [166 10 98 20];

            % Create TimeLapseTab
            app.TimeLapseTab = uitab(app.TabGroup);
            app.TimeLapseTab.Title = 'Time Lapse';
            app.TimeLapseTab.BackgroundColor = [1 1 1];

            % Create DifferenceHighlightTab
            app.DifferenceHighlightTab = uitab(app.TabGroup);
            app.DifferenceHighlightTab.Title = 'Difference Highlight';
            app.DifferenceHighlightTab.BackgroundColor = [1 1 1];

            % Create Year1DropDownLabel
            app.Year1DropDownLabel = uilabel(app.DifferenceHighlightTab);
            app.Year1DropDownLabel.HorizontalAlignment = 'right';
            app.Year1DropDownLabel.Position = [31 90 39 22];
            app.Year1DropDownLabel.Text = 'Year 1';

            % Create Year1DropDown
            app.Year1DropDown = uidropdown(app.DifferenceHighlightTab);
            app.Year1DropDown.ValueChangedFcn = createCallbackFcn(app, @Year1DropDownValueChanged, true);
            app.Year1DropDown.Position = [85 90 100 22];

            % Create Year2DropDownLabel
            app.Year2DropDownLabel = uilabel(app.DifferenceHighlightTab);
            app.Year2DropDownLabel.HorizontalAlignment = 'right';
            app.Year2DropDownLabel.Position = [197 90 39 22];
            app.Year2DropDownLabel.Text = 'Year 2';

            % Create Year2DropDown
            app.Year2DropDown = uidropdown(app.DifferenceHighlightTab);
            app.Year2DropDown.ValueChangedFcn = createCallbackFcn(app, @Year2DropDownValueChanged, true);
            app.Year2DropDown.Position = [251 90 100 22];

            % Create heatmapmodeSwitchLabel
            app.heatmapmodeSwitchLabel = uilabel(app.DifferenceHighlightTab);
            app.heatmapmodeSwitchLabel.HorizontalAlignment = 'center';
            app.heatmapmodeSwitchLabel.Position = [48 14 87 22];
            app.heatmapmodeSwitchLabel.Text = 'heatmap mode';

            % Create heatmapmodeSwitch
            app.heatmapmodeSwitch = uiswitch(app.DifferenceHighlightTab, 'rocker');
            app.heatmapmodeSwitch.Orientation = 'horizontal';
            app.heatmapmodeSwitch.ValueChangedFcn = createCallbackFcn(app, @heatmapmodeSwitchValueChanged, true);
            app.heatmapmodeSwitch.Position = [69 45 45 20];

            % Create DensityControlpanelPanel
            app.DensityControlpanelPanel = uipanel(app.DifferenceHighlightTab);
            app.DensityControlpanelPanel.Title = 'Density Control panel';
            app.DensityControlpanelPanel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.DensityControlpanelPanel.Position = [383 14 400 108];

            % Create modeSwitchLabel
            app.modeSwitchLabel = uilabel(app.DensityControlpanelPanel);
            app.modeSwitchLabel.HorizontalAlignment = 'center';
            app.modeSwitchLabel.Enable = 'off';
            app.modeSwitchLabel.Position = [180 24 36 22];
            app.modeSwitchLabel.Text = 'mode';

            % Create modeSwitch
            app.modeSwitch = uiswitch(app.DensityControlpanelPanel, 'slider');
            app.modeSwitch.Items = {'increase', 'decrease'};
            app.modeSwitch.ValueChangedFcn = createCallbackFcn(app, @modeSwitchValueChanged, true);
            app.modeSwitch.Enable = 'off';
            app.modeSwitch.Position = [175 43 45 20];
            app.modeSwitch.Value = 'increase';

            % Create ThresholdKnob
            app.ThresholdKnob = uiknob(app.DensityControlpanelPanel, 'continuous');
            app.ThresholdKnob.Limits = [0 400];
            app.ThresholdKnob.ValueChangedFcn = createCallbackFcn(app, @ThresholdKnobValueChanged, true);
            app.ThresholdKnob.Position = [317 37 35 35];
            app.ThresholdKnob.Value = 60;

            % Create partialSwitchLabel
            app.partialSwitchLabel = uilabel(app.DensityControlpanelPanel);
            app.partialSwitchLabel.HorizontalAlignment = 'center';
            app.partialSwitchLabel.Position = [44 19 39 22];
            app.partialSwitchLabel.Text = 'partial';

            % Create partialSwitch
            app.partialSwitch = uiswitch(app.DensityControlpanelPanel, 'slider');
            app.partialSwitch.ValueChangedFcn = createCallbackFcn(app, @partialSwitchValueChanged, true);
            app.partialSwitch.Position = [40 43 45 20];

            % Create ThresholdSpinnerLabel
            app.ThresholdSpinnerLabel = uilabel(app.DensityControlpanelPanel);
            app.ThresholdSpinnerLabel.HorizontalAlignment = 'right';
            app.ThresholdSpinnerLabel.Position = [272 3 59 22];
            app.ThresholdSpinnerLabel.Text = 'Threshold';

            % Create ThresholdSpinner
            app.ThresholdSpinner = uispinner(app.DensityControlpanelPanel);
            app.ThresholdSpinner.Limits = [0 400];
            app.ThresholdSpinner.ValueChangedFcn = createCallbackFcn(app, @ThresholdSpinnerValueChanged, true);
            app.ThresholdSpinner.Position = [338 5 61 17];
            app.ThresholdSpinner.Value = 60;

            % Create increaseLamp
            app.increaseLamp = uilamp(app.DensityControlpanelPanel);
            app.increaseLamp.Enable = 'off';
            app.increaseLamp.Position = [139 28 14 14];
            app.increaseLamp.Color = [0.9412 0.9412 0.9412];

            % Create decreaseLamp
            app.decreaseLamp = uilamp(app.DensityControlpanelPanel);
            app.decreaseLamp.Enable = 'off';
            app.decreaseLamp.Position = [246 28 14 14];
            app.decreaseLamp.Color = [0.9412 0.9412 0.9412];

            % Create Lamp
            app.Lamp = uilamp(app.DifferenceHighlightTab);
            app.Lamp.Position = [162 45 20 20];
            app.Lamp.Color = [0.9412 0.9412 0.9412];

            % Create UIAxes
            app.UIAxes = uiaxes(app.DifferenceHighlightTab);
            app.UIAxes.Toolbar.Visible = 'off';
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.Position = [28 135 755 391];

            % Create DiscriptionLabel
            app.DiscriptionLabel = uilabel(app.ClimateChangeAppUIFigure);
            app.DiscriptionLabel.FontSize = 14;
            app.DiscriptionLabel.FontWeight = 'bold';
            app.DiscriptionLabel.Position = [12 164 83 22];
            app.DiscriptionLabel.Text = 'Discription:';

            % Create DatasetNameTextAreaLabel
            app.DatasetNameTextAreaLabel = uilabel(app.ClimateChangeAppUIFigure);
            app.DatasetNameTextAreaLabel.HorizontalAlignment = 'right';
            app.DatasetNameTextAreaLabel.Position = [8 135 89 22];
            app.DatasetNameTextAreaLabel.Text = 'Dataset Name: ';

            % Create DatasetNameTextArea
            app.DatasetNameTextArea = uitextarea(app.ClimateChangeAppUIFigure);
            app.DatasetNameTextArea.Editable = 'off';
            app.DatasetNameTextArea.Position = [13 109 123 22];

            % Create PictureNumberLabel
            app.PictureNumberLabel = uilabel(app.ClimateChangeAppUIFigure);
            app.PictureNumberLabel.HorizontalAlignment = 'right';
            app.PictureNumberLabel.Position = [10 76 92 22];
            app.PictureNumberLabel.Text = 'Picture Number:';

            % Create PictureNumberEditField
            app.PictureNumberEditField = uieditfield(app.ClimateChangeAppUIFigure, 'numeric');
            app.PictureNumberEditField.Editable = 'off';
            app.PictureNumberEditField.Position = [115 76 25 22];

            % Create SelectDirectoryButton
            app.SelectDirectoryButton = uibutton(app.ClimateChangeAppUIFigure, 'push');
            app.SelectDirectoryButton.ButtonPushedFcn = createCallbackFcn(app, @SelectDirectoryButtonPushed, true);
            app.SelectDirectoryButton.BackgroundColor = [0.8 0.8 0.8];
            app.SelectDirectoryButton.FontWeight = 'bold';
            app.SelectDirectoryButton.Position = [1 529 154 22];
            app.SelectDirectoryButton.Text = 'Select Directory';

            % Create Image
            app.Image = uiimage(app.ClimateChangeAppUIFigure);
            app.Image.Position = [1 1 963 525];
            app.Image.ImageSource = 'cover.png';

            % Show the figure after all components are created
            app.ClimateChangeAppUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GUI_run

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.ClimateChangeAppUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ClimateChangeAppUIFigure)
        end
    end
end