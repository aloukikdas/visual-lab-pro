function render_circuit(win, theme)
    global VLP_CONTEXT;
    VLP_CONTEXT.circuit = struct(); 
    
    ui_create_text(win, [50, 700, 500, 30], "CIRCUIT LAB: DC Analysis", theme.font_size_h1, theme.accent, theme.bg_main);
    ui_create_button(win, [850, 695, 120, 40], "BACK", "navigate_to(""dashboard"");", theme);
    
    ui_create_panel(win, [50, 100, 300, 550], theme.bg_panel);
    ui_create_text(win, [70, 610, 260, 20], "Power Supply & Load", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    
    ui_create_text(win, [70, 540, 260, 20], "Source Voltage (V):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.circuit.lbl_vol = ui_create_text(win, [70, 500, 260, 30], "12 V", theme.font_size_h1, theme.accent, theme.bg_panel);
    VLP_CONTEXT.circuit.sld_vol = ui_create_slider(win, [70, 470, 260, 20], 0, 24, 12, "update_circuit_plot()", theme);
    
    ui_create_text(win, [70, 410, 260, 20], "Load Resistance (Ohms):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.circuit.lbl_res = ui_create_text(win, [70, 370, 260, 30], "100 Ohms", theme.font_size_h1, theme.accent, theme.bg_panel);
    VLP_CONTEXT.circuit.sld_res = ui_create_slider(win, [70, 340, 260, 20], 10, 500, 100, "update_circuit_plot()", theme);
    
    ui_create_text(win, [70, 260, 260, 20], "Live Measurements", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    
    ui_create_text(win, [70, 220, 120, 20], "Current (I):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.circuit.lbl_cur = ui_create_text(win, [70, 190, 120, 30], "0.12 A", theme.font_size_h1, theme.danger, theme.bg_panel);
    
    ui_create_text(win, [210, 220, 120, 20], "Power (P):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.circuit.lbl_pow = ui_create_text(win, [210, 190, 120, 30], "1.44 W", theme.font_size_h1, theme.danger, theme.bg_panel);

    norm_axes_pos = get_normalized_pos([430, 100, 540, 550]);
    VLP_CONTEXT.circuit.ax = newaxes();
    VLP_CONTEXT.circuit.ax.axes_bounds = norm_axes_pos;
    
    a = VLP_CONTEXT.circuit.ax; 
    a.background = color(30, 30, 46);      
    a.foreground = color(166, 172, 205);   
    a.grid = [1, 1];                   
    a.font_color = color("white");
    a.title.text = "V-I Characteristic Curve";
    a.title.font_color = color("white");
    a.title.font_size = 4;
    a.x_label.text = "Voltage (V)";
    a.x_label.font_color = color("white");
    a.y_label.text = "Current (A)";
    a.y_label.font_color = color("white");
    
    a.data_bounds = [0, 0; 25, 2.5]; 
    
    plot([0, 24], [0, 0.24], "c");         
    plot([12], [0.12], "yd");              
    
    VLP_CONTEXT.circuit.line_slope = a.children(2).children(1); 
    VLP_CONTEXT.circuit.line_slope.thickness = 2;
    
    VLP_CONTEXT.circuit.marker_op = a.children(1).children(1);  
    VLP_CONTEXT.circuit.marker_op.mark_size = 15;
    VLP_CONTEXT.circuit.marker_op.mark_background = color(255, 255, 0); 
    
    update_circuit_plot();
endfunction

function update_circuit_plot()
    global VLP_CONTEXT;
    
    v_in = VLP_CONTEXT.circuit.sld_vol.value;
    r_load = VLP_CONTEXT.circuit.sld_res.value;
    
    current = v_in / r_load;
    power = v_in * current;
    
    VLP_CONTEXT.circuit.lbl_vol.string = string(round(v_in)) + " V";
    VLP_CONTEXT.circuit.lbl_res.string = string(round(r_load)) + " Ohms";
    VLP_CONTEXT.circuit.lbl_cur.string = msprintf("%.2f A", current);
    VLP_CONTEXT.circuit.lbl_pow.string = msprintf("%.2f W", power);
    
    drawlater();                 
    
    max_current = 24 / r_load;
    VLP_CONTEXT.circuit.line_slope.data = [0, 0; 24, max_current];
    VLP_CONTEXT.circuit.marker_op.data = [v_in, current];
    
    drawnow();                   
endfunction