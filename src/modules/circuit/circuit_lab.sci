function render_circuit(win, theme)
    global VLP_CONTEXT;
    VLP_CONTEXT.circuit = struct(); 
    VLP_CONTEXT.circuit.is_playing = %f;
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
    ui_create_text(win, [70, 270, 260, 20], "Live Measurements", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    ui_create_text(win, [70, 230, 120, 20], "Current (I):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.circuit.lbl_cur = ui_create_text(win, [70, 200, 120, 30], "0.12 A", theme.font_size_h1, theme.danger, theme.bg_panel);
    ui_create_text(win, [210, 230, 120, 20], "Power (P):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.circuit.lbl_pow = ui_create_text(win, [210, 200, 120, 30], "1.44 W", theme.font_size_h1, theme.danger, theme.bg_panel);
    VLP_CONTEXT.circuit.btn_start = ui_create_button(win, [70, 110, 260, 45], "PULSE CIRCUIT (5 SECONDS)", "start_circuit_sim()", theme);
    
    norm_axes_top = get_normalized_pos([430, 380, 540, 270]);
    VLP_CONTEXT.circuit.ax = newaxes();
    VLP_CONTEXT.circuit.ax.axes_bounds = norm_axes_top;
    
    a = VLP_CONTEXT.circuit.ax; 
    a.background = color(30, 30, 46);      
    a.foreground = color(166, 172, 205);   
    a.grid = [1, 1];                   
    a.font_color = color("white");
    a.title.text = "V-I Characteristic Curve";
    a.title.font_color = color("white");
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
    
    norm_axes_bot = get_normalized_pos([430, 80, 540, 270]);
    VLP_CONTEXT.circuit.ax_sch = newaxes();
    VLP_CONTEXT.circuit.ax_sch.axes_bounds = norm_axes_bot;
    
    a2 = VLP_CONTEXT.circuit.ax_sch;
    a2.background = color(20, 20, 30); 
    a2.data_bounds = [0, 0; 10, 5]; 
    a2.title.text = "Live Circuit Schematic";
    a2.title.font_color = color("white");
    a2.axes_visible = ["off", "off", "off"]; 
    a2.box = "off"; 
    a2.x_ticks = tlist(["ticks", "locations", "labels"], [], []);
    a2.y_ticks = tlist(["ticks", "locations", "labels"], [], []);
    
    sca(a2); 
    
    plot([4.8, 1, 1, 4.2], [1, 1, 4, 4], "w"); 
    gce().children(1).thickness = 3;
    plot([5.8, 9, 9, 5.2], [4, 4, 1, 1], "w"); 
    gce().children(1).thickness = 3;
    
    plot([0.5, 1.5], [2.6, 2.6], "w"); gce().children(1).thickness = 2; 
    plot([0.7, 1.3], [2.4, 2.4], "w"); gce().children(1).thickness = 4; 
    plot([0.5, 0.5], [2.75, 2.95], "w"); gce().children(1).thickness = 2; 
    plot([0.4, 0.6], [2.85, 2.85], "w"); gce().children(1).thickness = 2;
    plot([0.4, 0.6], [2.15, 2.15], "w"); gce().children(1).thickness = 2; 
    
    rx = [4.2, 4.3, 4.5, 4.7, 4.9, 5.1, 5.3, 5.5, 5.7, 5.8];
    ry = [4.0, 4.3, 3.7, 4.3, 3.7, 4.3, 3.7, 4.3, 3.7, 4.0];
    plot(rx, ry, "c"); 
    gce().children(1).thickness = 3;
    
    plot([4.8, 5.2], [1, 1.5], "y"); 
    VLP_CONTEXT.circuit.switch_arm = gce().children(1);
    VLP_CONTEXT.circuit.switch_arm.data = [4.8, 1; 5.2, 1.5];
    VLP_CONTEXT.circuit.switch_arm.thickness = 3;
    
    plot([9], [2.5], "wo");
    VLP_CONTEXT.circuit.bulb = gce().children(1);
    VLP_CONTEXT.circuit.bulb.mark_size = 35; 
    
    plot([0], [0], "ro");
    VLP_CONTEXT.circuit.electrons = gce().children(1);
    VLP_CONTEXT.circuit.electrons.mark_size = 8;
    VLP_CONTEXT.circuit.electrons.mark_background = color(255, 50, 50);
    VLP_CONTEXT.circuit.electrons.visible = "off"; 
    
    xstring(2.0, 2.45, "Battery: 12 V");
    VLP_CONTEXT.circuit.txt_bat = gce();
    VLP_CONTEXT.circuit.txt_bat.font_foreground = color("white");
    
    xstring(4.2, 4.6, "Resistor: 100 Ohms");
    VLP_CONTEXT.circuit.txt_res = gce();
    VLP_CONTEXT.circuit.txt_res.font_foreground = color("white");
    
    xstring(8.2, 2.45, "Bulb");
    VLP_CONTEXT.circuit.txt_bulb = gce();
    VLP_CONTEXT.circuit.txt_bulb.font_foreground = color("white");
    
    xstring(4.6, 0.4, "Switch: OFF");
    VLP_CONTEXT.circuit.txt_switch = gce();
    VLP_CONTEXT.circuit.txt_switch.font_foreground = color("white");
    
    update_circuit_plot();
endfunction

function [x, y] = get_wire_coordinates(s_array)
    x = zeros(s_array); y = zeros(s_array);
    for i = 1:size(s_array, "*")
        s = modulo(s_array(i), 22); 
        if s <= 8 then
            x(i) = 1 + s;
            if x(i) >= 4.2 & x(i) <= 5.8 then
                y(i) = 4.0 + 0.3 * sin((2 * %pi / 0.4) * (x(i) - 4.2));
            else
                y(i) = 4; // Flat wire
            end
            
        elseif s <= 11 then
            x(i) = 9; y(i) = 4 - (s - 8);  
        elseif s <= 19 then
            x(i) = 9 - (s - 11); y(i) = 1; 
        else
            x(i) = 1; y(i) = 1 + (s - 19); 
        end
    end
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
    
    VLP_CONTEXT.circuit.txt_bat.text = "Battery: " + string(round(v_in)) + " V";
    VLP_CONTEXT.circuit.txt_res.text = "Resistor: " + string(round(r_load)) + " Ohms";
    
    if VLP_CONTEXT.circuit.is_playing then
        intensity = min(power / 50.0, 1.0); 
        r_val = int(50 + (205 * intensity));
        g_val = int(50 + (205 * intensity));
        VLP_CONTEXT.circuit.bulb.mark_background = color(r_val, g_val, 50); 
        VLP_CONTEXT.circuit.electrons.visible = "on";
    else
        VLP_CONTEXT.circuit.bulb.mark_background = color(40, 40, 40); 
        VLP_CONTEXT.circuit.electrons.visible = "off";
    end
    
    drawnow();                   
endfunction

function start_circuit_sim()
    global VLP_CONTEXT;
    if VLP_CONTEXT.circuit.is_playing then return; end
    VLP_CONTEXT.circuit.is_playing = %t;
    VLP_CONTEXT.circuit.txt_switch.text = "Switch: ON";
    VLP_CONTEXT.circuit.txt_switch.font_foreground = color(0, 255, 200); 
    VLP_CONTEXT.circuit.switch_arm.data = [4.8, 1; 5.2, 1]; // Close switch
    update_circuit_plot(); 
    
    particles_s = [0, 3.6, 7.3, 11, 14.6, 18.3]; 
    for frame = 1:150
        try
            check_alive = VLP_CONTEXT.circuit.ax_sch.type;
        catch
            VLP_CONTEXT.circuit.is_playing = %f;
            return; 
        end
        v_in = VLP_CONTEXT.circuit.sld_vol.value;
        r_load = VLP_CONTEXT.circuit.sld_res.value;
        live_current = v_in / r_load;
        speed = live_current * 0.4; 
        
        particles_s = particles_s + speed;
        [px, py] = get_wire_coordinates(particles_s);
        
        drawlater();
        VLP_CONTEXT.circuit.electrons.data = [px', py'];
        drawnow();
        
        sleep(30); 
    end
    try
        VLP_CONTEXT.circuit.is_playing = %f;
        VLP_CONTEXT.circuit.txt_switch.text = "Switch: OFF";
        VLP_CONTEXT.circuit.txt_switch.font_foreground = color("white");
        VLP_CONTEXT.circuit.switch_arm.data = [4.8, 1; 5.2, 1.5];
        update_circuit_plot();
    catch
    end
endfunction