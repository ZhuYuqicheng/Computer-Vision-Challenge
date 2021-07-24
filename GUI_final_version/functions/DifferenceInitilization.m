function DifferenceInitilization(app)
    % year list initialization (difference)
    item1 = app.current_image_names;
    item2 = app.current_image_names(2:end);
    app.Year1DropDown.Items = item1;
    app.Year2DropDown.Items = item2;
    app.Year1DropDown.Value = item1{1};
    app.Year2DropDown.Value = item2{1};
    
    % visualization
    DifferenceHighlight(app)
end