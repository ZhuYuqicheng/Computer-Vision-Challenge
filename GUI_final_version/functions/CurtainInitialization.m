function CurtainInitialization(app)
    dataset_html_dir = fullfile(app.curtain_html_dir, app.select_data_name);
    image_names = app.current_image_names;
    result_path = fullfile(app.result_path, app.select_data_name);
    % get the source for curtain
    curtain_image_path = fullfile(result_path, image_names{1}+"_"+image_names{end});
    if exist(dataset_html_dir, 'dir') ~= 7
        copyfile(app.curtain_func_dir, dataset_html_dir)
        pic1_path = fullfile(curtain_image_path, 'pic_1.png');
        pic2_path = fullfile(curtain_image_path, 'pic_2.png');
        copyfile(pic1_path,fullfile(dataset_html_dir, fullfile("img", "pic_1.jpg")))
        copyfile(pic2_path,fullfile(dataset_html_dir, fullfile("img", "pic_2.jpg")))
    end
    % place the html component
    app.HTML_curtain = uihtml(app.CurtainTab);
    app.HTML_curtain.Position = [1 90 808 436];
    app.HTML_curtain.HTMLSource = fullfile(dataset_html_dir, 'sliding_curtain.html');
    
    % select the printed name of dataset
    switch app.select_data_name
        case "Brazilian Rainforest"
            app.TextArea.Value = "Rainforest, Brazilian";
        case "Columbia Glacier"
            app.TextArea.Value = "Columbia Glacier, Alaska";
        case "Dubai"
            app.TextArea.Value = "Dubai, United Arab Emirates";
        case "Kuwait"
            app.TextArea.Value = "Kuwait, Middle East";
        case "Wiesn"
            app.TextArea.Value = "Wiesn, Munich";
        otherwise
            app.TextArea.Value = app.select_data_name;
    end
    % display the datase name
    app.leftTextArea.Value = str2datestr(image_names{end});
    app.rightTextArea.Value = str2datestr(image_names{1});
end