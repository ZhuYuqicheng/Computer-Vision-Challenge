function GetDatasetList(app)
    % get the dir information
    app.dataset_path = uigetdir();
    dir_info = dir(app.dataset_path);
    dir_info = dir_info(~ismember({dir_info.name},{'.','..','.DS_Store'}));
    % get path list
    dir_list = fullfile({dir_info.folder}, {dir_info.name})';
    % get name list
    data_names = {dir_info.name}';
    app.dataset_names = cellfun(@getDatasetName,data_names,'UniformOutput',false);
    
    % update the tree menu
    if ~isempty(app.Tree.Children)
        app.Tree.Children.delete
    end
    default_tree = uitreenode(app.Tree,'Text','Default Dataset');
    user_tree = uitreenode(app.Tree,'Text','User Dataset');
    for index = 1:length(data_names)
        if ismember(data_names{index}, app.default_dataset_names) 
            uitreenode(default_tree,'Text',app.dataset_names{index}, ...
                'NodeData', dir_list{index});
        else
            uitreenode(user_tree,'Text',app.dataset_names{index}, ...
                'NodeData', dir_list{index});
        end
    end
    % expand the tree list
    expand(app.Tree);
end

%% function area
function dirname = getDatasetName(path)
    [~,dirname,~] = fileparts(path);
end