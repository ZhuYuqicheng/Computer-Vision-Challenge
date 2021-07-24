%% image processing function
function ProcessImageData_final(app)
    % get result path
    result_path = fullfile(app.result_path, app.select_data_name);
    
    filePattern = fullfile(app.selected_paths, '*.jpg');
    imagefiles = dir(filePattern);
    app.current_image_paths = fullfile({imagefiles.folder}, {imagefiles.name})';
    image_names = {imagefiles.name}';
    app.current_image_names = cellfun(@(x) x(1:end-4),image_names,'UniformOutput',false);
    
    % creat result path
    if ~exist(result_path, 'dir')
        mkdir(result_path)
        % image processing
        ImageProcessing(app, result_path)
    end
end

%% function area
function ImageProcessing(app, result_dir)
    wait_str = "Initializing " + app.select_data_name + "...";
    progress = uiprogressdlg(app.ClimateChangeAppUIFigure,...
        'Title','Initialization',...
        'Message',wait_str);

    % calculate total iterations
    total_iter = 2*length(app.current_image_paths)-1 + ...
        ((length(app.current_image_paths)-2)^2+length(app.current_image_paths)-2)/2;
    count = 0;
    % load data
    img_ori = cell(length(app.current_image_paths), 1);
    for i=1:length(app.current_image_paths)
        img_ori{i}=imread(app.current_image_paths{i});
        % waitbar
        count = count + 1;
        progress.Value = count/total_iter;
        progress.Message = wait_str+"calculating left time";
    end
    app.timelapse_reverse = false;
    % decide how to deal with the dataset
    if ~ismember(app.select_data_name,  app.default_dataset_names)
        % Preprocessing
        image = preprocessing(img_ori);
        % Registration
        time_count = 0;
        total_loop = (length(image)-1)*length(image)/2;
        T = zeros(1, total_loop);
        for i = 1:length(image)-1
            for j = i+1:length(image)
                tic
                time_count = time_count + 1;
                imgA = image{j};
                imgB = image{i};
                file_name = app.current_image_names{i}+"_"+app.current_image_names{j};
                Registration(imgA, imgB, fullfile(result_dir, file_name))
                T(time_count) = toc;
                % waitbar
                count = count + 1;
                progress.Value = count/total_iter;
                progress.Message = wait_str+...
                    leftTimestring((sum(T)/time_count)*(total_loop-time_count));
            end
        end
        close(progress)
    elseif bwconncomp(edge(rgb2gray(img_ori{1}),'Roberts',.7)).NumObjects ~= 0 % much bright picxles
        image = img_ori;
        % Registration
        time_count = 0;
        total_loop = (length(image)-1)*length(image)/2;
        T = zeros(1, total_loop);
        for i = 1:length(image)-1
            for j = i+1:length(image)
                tic
                time_count = time_count + 1;
                imgA = image{j};
                imgB = image{i};
                file_name = app.current_image_names{i}+"_"+app.current_image_names{j};
                Registration_nopre(imgA, imgB, fullfile(result_dir, file_name))
                T(time_count) = toc;
                % waitbar
                count = count + 1;
                progress.Value = count/total_iter;
                progress.Message = wait_str+...
                    leftTimestring((sum(T)/time_count)*(total_loop-time_count));
            end
        end
        close(progress)
    elseif bwconncomp(edge(rgb2gray(img_ori{1}),'Sobel',.49)).NumObjects == 0 % too few features
        app.timelapse_reverse = true;
        % preprocessing
        image = preprocessing(img_ori);
        % Registration
        time_count = 0;
        total_loop = (length(image)-1)*length(image)/2;
        T = zeros(1, total_loop);
        for i = 1:length(image)-1
            for j = i+1:length(image)
                tic
                time_count = time_count + 1;
                imgA = image{i};
                imgB = image{j};
                file_name = app.current_image_names{i}+"_"+app.current_image_names{j};
                Registration_rf(imgA, imgB, fullfile(result_dir, file_name))
                T(time_count) = toc;
                % waitbar
                count = count + 1;
                progress.Value = count/total_iter;
                progress.Message = wait_str+...
                    leftTimestring((sum(T)/time_count)*(total_loop-time_count));
            end
        end
        close(progress)
    else
        % Preprocessing
        image = preprocessing(img_ori);
        % Registration
        time_count = 0;
        total_loop = (length(image)-1)*length(image)/2;
        T = zeros(1, total_loop);
        for i = 1:length(image)-1
            for j = i+1:length(image)
                tic
                time_count = time_count + 1;
                imgA = image{j};
                imgB = image{i};
                file_name = app.current_image_names{i}+"_"+app.current_image_names{j};
                Registration(imgA, imgB, fullfile(result_dir, file_name))
                T(time_count) = toc;
                % waitbar
                count = count + 1;
                progress.Value = count/total_iter;
                progress.Message = wait_str+...
                    leftTimestring((sum(T)/time_count)*(total_loop-time_count));
            end
        end
        close(progress)
    end
    
end







