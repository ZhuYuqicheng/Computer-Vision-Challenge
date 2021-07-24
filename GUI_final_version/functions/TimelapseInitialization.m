function TimelapseInitialization(app)
    % create function folder in result folder
    target_dir = fullfile(app.timelapse_html_dir, app.select_data_name);
    if ismember(app.select_data_name, app.default_dataset_names)
        function_name = string(length(app.current_image_names));
        current_function_path = fullfile(app.timelapse_func_dir, function_name);
    else
        current_function_path = fullfile(app.timelapse_func_dir, '8');
    end
    copyfile(current_function_path, target_dir)
    
    % copy images
    target_img_dir = fullfile(target_dir, 'img');
    processed_image_path = fullfile(app.result_path, app.select_data_name);
    image_names = app.current_image_names;
    if ~app.timelapse_reverse % first image as reference
        image_dir = fullfile(processed_image_path, image_names{1}+"_"+image_names{2});
        MoveAndChangeName(fullfile(image_dir, 'pic_1.png'), target_img_dir, '1.jpg')
        MoveAndChangeName(fullfile(image_dir, 'pic_2.png'), target_img_dir, '2.jpg')
        for index = 3:length(image_names)
            image_dir = fullfile(processed_image_path, image_names{1}+"_"+image_names{index});
            new_name = string(index)+".jpg";
            MoveAndChangeName(fullfile(image_dir, 'pic_2.png'), target_img_dir, new_name)
        end
        % dealing with user defined dataset
        if ~ismember(app.select_data_name, app.default_dataset_names) && length(image_names)<8
            for index = length(image_names)+1:8
                image_dir = fullfile(processed_image_path, image_names{1}+"_"+image_names{end});
                new_name = string(index)+".jpg";
                MoveAndChangeName(fullfile(image_dir, 'pic_2.png'), target_img_dir, new_name)
            end
        end
    else % last image as reference
        image_dir = fullfile(processed_image_path, image_names{1}+"_"+image_names{end});
        MoveAndChangeName(fullfile(image_dir, 'pic_2.png'), target_img_dir, '1.jpg')
        MoveAndChangeName(fullfile(image_dir, 'pic_1.png'), target_img_dir, string(length(image_names))+".jpg")
        for index = 2:length(image_names)-1
            image_dir = fullfile(processed_image_path, image_names{index}+"_"+image_names{end});
            new_name = string(index)+".jpg";
            MoveAndChangeName(fullfile(image_dir, 'pic_2.png'), target_img_dir, new_name)
        end
    end
    
    % time lapse visualization
    app.HTML_time = uihtml(app.TimeLapseTab);
    app.HTML_time.Position = [1 5 840 500];
    app.HTML_time.HTMLSource = fullfile(target_dir, '11.html');
end

%% function area
function MoveAndChangeName(image_path, targer_path, image_name)
    copyfile(image_path, targer_path)
    [~,file_name,ext] = fileparts(image_path);
    move_path = fullfile(targer_path, file_name+ext);
    to_path = fullfile(targer_path, image_name);
    movefile(move_path, to_path)
end