function time_string = leftTimestring(sec)
    if sec < 60
        time_string = "about "+string(round(sec))+"s left";
    else
        time_string = "about "+string(fix(sec/60))+"m "+string(round(mod(sec, 60)))+"s left";
    end
end