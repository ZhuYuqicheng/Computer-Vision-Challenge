function date_string = str2datestr(str)
    date_string = datestr(datetime(str,'InputFormat','yyyy_mm'), 'mmmm, yyyy');
end