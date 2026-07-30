function render_analytics(win, theme)
    global VLP_CONTEXT;
    VLP_CONTEXT.analytics = struct(); 
    
    ui_create_text(win, [50, 700, 500, 30], "DATA ANALYTICS: CSV Visualization", theme.font_size_h1, theme.accent, theme.bg_main);
    ui_create_button(win, [850, 695, 120, 40], "BACK", "navigate_to(""dashboard"");", theme);
    
    ui_create_panel(win, [50, 100, 300, 550], theme.bg_panel);
    ui_create_text(win, [70, 610, 260, 20], "Data Controls", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    
    ui_create_button(win, [70, 550, 260, 40], "UPLOAD CSV DATA", "process_uploaded_csv()", theme);
    
    ui_create_text(win, [70, 500, 260, 15], "Maximum Value:", 10, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.analytics.lbl_max = ui_create_text(win, [70, 470, 260, 25], "--", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    
    ui_create_text(win, [70, 440, 260, 15], "Minimum Value:", 10, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.analytics.lbl_min = ui_create_text(win, [70, 410, 260, 25], "--", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    
    ui_create_text(win, [70, 380, 260, 15], "Average (Mean):", 10, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.analytics.lbl_mean = ui_create_text(win, [70, 350, 260, 25], "--", theme.font_size_h2, theme.accent, theme.bg_panel);

    ui_create_text(win, [70, 320, 260, 15], "Median:", 10, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.analytics.lbl_median = ui_create_text(win, [70, 290, 260, 25], "--", theme.font_size_h2, theme.text_primary, theme.bg_panel);

    ui_create_text(win, [70, 260, 260, 15], "Standard Deviation:", 10, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.analytics.lbl_stdev = ui_create_text(win, [70, 230, 260, 25], "--", theme.font_size_h2, theme.text_primary, theme.bg_panel);

    norm_axes_pos = get_normalized_pos([430, 100, 540, 550]);
    VLP_CONTEXT.analytics.ax = newaxes();
    VLP_CONTEXT.analytics.ax.axes_bounds = norm_axes_pos;
    
    a = VLP_CONTEXT.analytics.ax; 
    a.background = color(30, 30, 46);      
    a.foreground = color(166, 172, 205);   
    a.grid = [1, 1];                   
    a.font_color = color("white");
    a.title.text = "Awaiting Data Upload...";
    a.title.font_color = color("white");
    a.title.font_size = 4;
endfunction

function process_uploaded_csv()
    global VLP_CONTEXT;
    file_path = uigetfile("*.csv", "", "Select a 2-Column CSV Data File");
    if file_path == "" then
        return; 
    end
    
    try
        dataset = csvRead(file_path);
        if or(isnan(dataset)) then
            messagebox("Invalid data! Ensure the CSV contains only numbers (remove any text headers or words).", "Data Format Error", "error");
            return;
        end
        if size(dataset, 2) < 2 then
            messagebox("Invalid format! Please upload a CSV with at least 2 numeric columns (X and Y).", "Data Format Error", "error");
            return;
        end
    catch
        messagebox("Failed to read the file. Ensure it is a valid CSV.", "File Error", "error");
        return;
    end
    
    x_data = dataset(:, 1);
    y_data = dataset(:, 2);
    
    val_max = max(y_data);
    val_min = min(y_data);
    val_mean = mean(y_data);
    val_median = median(y_data);
    val_stdev = stdev(y_data);
    
    VLP_CONTEXT.analytics.lbl_max.string = msprintf("%.2f", val_max);
    VLP_CONTEXT.analytics.lbl_min.string = msprintf("%.2f", val_min);
    VLP_CONTEXT.analytics.lbl_mean.string = msprintf("%.2f", val_mean);
    VLP_CONTEXT.analytics.lbl_median.string = msprintf("%.2f", val_median);
    VLP_CONTEXT.analytics.lbl_stdev.string = msprintf("%.2f", val_stdev);
    
    sca(VLP_CONTEXT.analytics.ax); 
    drawlater();                 
    
    if ~isempty(VLP_CONTEXT.analytics.ax.children) then
        delete(VLP_CONTEXT.analytics.ax.children);
    end
    
    plot(x_data, y_data, "c-o");                  
    
    a = VLP_CONTEXT.analytics.ax; 
    a.data_bounds = [min(x_data)-1, 0; max(x_data)+1, val_max + (val_max*0.1)]; 
    
    [path, fname, extension] = fileparts(file_path);
    a.title.text = "Dataset Visualization: " + fname + extension;
    
    line_obj = a.children(1).children(1); 
    line_obj.thickness = 2;
    line_obj.mark_size = 4; 
    
    drawnow();                   
endfunction