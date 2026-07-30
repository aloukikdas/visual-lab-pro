function render_physics(win, theme)
    global VLP_CONTEXT;
    VLP_CONTEXT.physics = struct();
    ui_create_text(win, [50, 700, 400, 30], "PHYSICS LAB: Projectile Motion", theme.font_size_h1, theme.accent, theme.bg_main);
    ui_create_button(win, [850, 695, 120, 40], "BACK", "navigate_to(""dashboard"");", theme);
    ui_create_panel(win, [50, 100, 300, 550], theme.bg_panel);
    ui_create_text(win, [70, 610, 260, 20], "Simulation Parameters", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    ui_create_text(win, [70, 540, 260, 20], "Launch Angle (Degrees):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.physics.lbl_angle = ui_create_text(win, [70, 500, 260, 30], "45 °", theme.font_size_h1, theme.accent, theme.bg_panel);
    VLP_CONTEXT.physics.sld_angle = ui_create_slider(win, [70, 470, 260, 20], 0, 90, 45, "preview_physics_path()", theme);
    ui_create_text(win, [70, 400, 260, 20], "Initial Velocity (m/s):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.physics.lbl_vel = ui_create_text(win, [70, 360, 260, 30], "60 m/s", theme.font_size_h1, theme.accent, theme.bg_panel);
    VLP_CONTEXT.physics.sld_vel = ui_create_slider(win, [70, 330, 260, 20], 1, 100, 60, "preview_physics_path()", theme);
    ui_create_button(win, [70, 240, 260, 45], "LAUNCH PROJECTILE", "run_physics_animation()", theme);
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
    
    plot([0], [0], "m"); 
    VLP_CONTEXT.physics.line_ghost = a.children(1).children(1);
    VLP_CONTEXT.physics.line_ghost.line_style = 3;
    VLP_CONTEXT.physics.line_ghost.thickness = 2;
    
    plot([0], [0], "c"); 
    VLP_CONTEXT.physics.line_solid = a.children(1).children(1);
    VLP_CONTEXT.physics.line_solid.line_style = 1;
    VLP_CONTEXT.physics.line_solid.thickness = 3;
    
    plot([0], [0], "yo"); 
    VLP_CONTEXT.physics.ball_marker = a.children(1).children(1);
    VLP_CONTEXT.physics.ball_marker.mark_size = 10;
    VLP_CONTEXT.physics.ball_marker.mark_background = color(255, 215, 0);

    VLP_CONTEXT.physics.is_animating = %f;
    preview_physics_path();
endfunction

function preview_physics_path()
    global VLP_CONTEXT;
    if VLP_CONTEXT.physics.is_animating then
        return;
    end
    angle_deg = VLP_CONTEXT.physics.sld_angle.value;
    v0 = VLP_CONTEXT.physics.sld_vel.value;
    VLP_CONTEXT.physics.lbl_angle.string = string(round(angle_deg)) + " °";
    VLP_CONTEXT.physics.lbl_vel.string = string(round(v0)) + " m/s";
    g = 9.81;
    angle_rad = angle_deg * %pi / 180;
    t_total = (2 * v0 * sin(angle_rad)) / g;
    t = linspace(0, t_total, 80);
    x = v0 * cos(angle_rad) * t;
    y = v0 * sin(angle_rad) * t - 0.5 * g * (t.^2);
    VLP_CONTEXT.physics.current_x = x;
    VLP_CONTEXT.physics.current_y = y;
    drawlater();                 
    VLP_CONTEXT.physics.line_ghost.data = [x', y'];
    VLP_CONTEXT.physics.line_solid.data = [0, 0];
    VLP_CONTEXT.physics.ball_marker.data = [0, 0];
    drawnow();                   
endfunction

function run_physics_animation()
    global VLP_CONTEXT;
    if VLP_CONTEXT.physics.is_animating then
        return;
    end
    VLP_CONTEXT.physics.is_animating = %t;
    x = VLP_CONTEXT.physics.current_x;
    y = VLP_CONTEXT.physics.current_y;
    num_steps = size(x, "*");
    for k = 1:num_steps
        drawlater();
        VLP_CONTEXT.physics.line_solid.data = [x(1:k)', y(1:k)'];
        VLP_CONTEXT.physics.ball_marker.data = [x(k), y(k)];
        drawnow();
        sleep(15); 
    end
    VLP_CONTEXT.physics.is_animating = %f;
endfunction