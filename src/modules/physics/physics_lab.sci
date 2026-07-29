function render_physics(win, theme)
    global VLP_CONTEXT;
    VLP_CONTEXT.physics = struct(); 
    
    ui_create_text(win, [50, 700, 400, 30], "PHYSICS LAB: Projectile Motion", theme.font_size_h1, theme.accent, theme.bg_main);
    ui_create_button(win, [850, 695, 120, 40], "BACK", "navigate_to(""dashboard"");", theme);
    
    ui_create_panel(win, [50, 100, 300, 550], theme.bg_panel);
    ui_create_text(win, [70, 610, 260, 20], "Simulation Parameters", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    
    ui_create_text(win, [70, 540, 260, 20], "Launch Angle (Degrees):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.physics.lbl_angle = ui_create_text(win, [70, 500, 260, 30], "45 °", theme.font_size_h1, theme.accent, theme.bg_panel);
    VLP_CONTEXT.physics.sld_angle = ui_create_slider(win, [70, 470, 260, 20], 0, 90, 45, "update_physics_plot()", theme);
    
    ui_create_text(win, [70, 400, 260, 20], "Initial Velocity (m/s):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.physics.lbl_vel = ui_create_text(win, [70, 360, 260, 30], "60 m/s", theme.font_size_h1, theme.accent, theme.bg_panel);
    VLP_CONTEXT.physics.sld_vel = ui_create_slider(win, [70, 330, 260, 20], 1, 100, 60, "update_physics_plot()", theme);
    
    norm_axes_pos = get_normalized_pos([430, 100, 540, 550]);
    VLP_CONTEXT.physics.ax = newaxes();
    VLP_CONTEXT.physics.ax.axes_bounds = norm_axes_pos;

    a = VLP_CONTEXT.physics.ax; 
    a.background = color(30, 30, 46);      
    a.foreground = color(166, 172, 205);   
    a.data_bounds = [0, 0; 1000, 550]; 
    a.grid = [1, 1];                   
    a.font_color = color("white");
    a.title.text = "Projectile Trajectory";
    a.title.font_color = color("white");
    a.title.font_size = 4;
    a.x_label.text = "Distance (m)";
    a.x_label.font_color = color("white");
    a.y_label.text = "Height (m)";
    a.y_label.font_color = color("white");

    plot([0], [0], "c");                  
    line_obj = a.children(1).children(1); 
    line_obj.thickness = 3;

    VLP_CONTEXT.physics.trajectory_line = line_obj; 
    
    update_physics_plot();
endfunction

function update_physics_plot()
    global VLP_CONTEXT;
    
    angle_deg = VLP_CONTEXT.physics.sld_angle.value;
    v0 = VLP_CONTEXT.physics.sld_vel.value;
    
    VLP_CONTEXT.physics.lbl_angle.string = string(round(angle_deg)) + " °";
    VLP_CONTEXT.physics.lbl_vel.string = string(round(v0)) + " m/s";
    
    g = 9.81;
    angle_rad = angle_deg * %pi / 180;
    
    t_total = (2 * v0 * sin(angle_rad)) / g;
    t = linspace(0, t_total, 100);
    
    x = v0 * cos(angle_rad) * t;
    y = v0 * sin(angle_rad) * t - 0.5 * g * (t.^2);
    
    drawlater();                 
    VLP_CONTEXT.physics.trajectory_line.data = [x', y'];
    drawnow();                   
endfunction