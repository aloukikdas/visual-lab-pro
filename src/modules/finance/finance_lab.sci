function render_finance(win, theme)
    global VLP_CONTEXT;
    VLP_CONTEXT.finance = struct(); 
    
    ui_create_text(win, [50, 700, 500, 30], "FINANCE LAB: Wealth Predictor", theme.font_size_h1, theme.accent, theme.bg_main);
    ui_create_button(win, [850, 695, 120, 40], "BACK", "navigate_to(""dashboard"");", theme);
    
    ui_create_panel(win, [50, 100, 300, 550], theme.bg_panel);
    ui_create_text(win, [70, 610, 260, 20], "Investment Plan", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    
    ui_create_text(win, [70, 540, 260, 20], "Monthly Investment:", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.finance.lbl_sip = ui_create_text(win, [70, 500, 260, 30], "₹ 10000", theme.font_size_h1, theme.accent, theme.bg_panel);
    VLP_CONTEXT.finance.sld_sip = ui_create_slider(win, [70, 470, 260, 20], 500, 50000, 10000, "update_finance_plot()", theme);

    ui_create_text(win, [70, 410, 260, 20], "Expected Return (Annual %):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.finance.lbl_rate = ui_create_text(win, [70, 370, 260, 30], "12 %", theme.font_size_h1, theme.accent, theme.bg_panel);
    VLP_CONTEXT.finance.sld_rate = ui_create_slider(win, [70, 340, 260, 20], 1, 30, 12, "update_finance_plot()", theme);

    ui_create_text(win, [70, 280, 260, 20], "Time Period (Years):", theme.font_size_body, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.finance.lbl_time = ui_create_text(win, [70, 240, 260, 30], "10 Years", theme.font_size_h1, theme.accent, theme.bg_panel);
    VLP_CONTEXT.finance.sld_time = ui_create_slider(win, [70, 210, 260, 20], 1, 30, 10, "update_finance_plot()", theme);
    ui_create_text(win, [70, 160, 120, 15], "Total Invested:", 10, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.finance.lbl_invested = ui_create_text(win, [70, 130, 120, 25], "₹ 12.00 L", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    ui_create_text(win, [210, 160, 120, 15], "Total Wealth:", 10, theme.text_secondary, theme.bg_panel);
    VLP_CONTEXT.finance.lbl_wealth = ui_create_text(win, [210, 130, 120, 25], "₹ 23.23 L", theme.font_size_h2, theme.accent, theme.bg_panel);
    norm_axes_pos = get_normalized_pos([430, 100, 540, 550]);
    VLP_CONTEXT.finance.ax = newaxes();
    VLP_CONTEXT.finance.ax.axes_bounds = norm_axes_pos;
    
    a = VLP_CONTEXT.finance.ax; 
    a.background = color(30, 30, 46);      
    a.foreground = color(166, 172, 205);   
    a.grid = [1, 1];                   
    a.font_color = color("white");
    a.title.text = "Exponential Wealth Growth";
    a.title.font_color = color("white");
    a.title.font_size = 4;
    a.x_label.text = "Time (Years)";
    a.x_label.font_color = color("white");
    a.y_label.text = "Value (₹ in Lakhs)";
    a.y_label.font_color = color("white");
    
    plot([0], [0], "w"); 
    plot([0], [0], "c"); 
    
    VLP_CONTEXT.finance.line_invested = a.children(2).children(1); 
    VLP_CONTEXT.finance.line_invested.thickness = 2;
    VLP_CONTEXT.finance.line_invested.line_style = 2; 
    
    VLP_CONTEXT.finance.line_wealth = a.children(1).children(1);  
    VLP_CONTEXT.finance.line_wealth.thickness = 3;
    
    update_finance_plot();
endfunction

function str = format_inr(val)
    if val >= 10000000 then
        str = msprintf("₹ %.2f Cr", val / 10000000);
    elseif val >= 100000 then
        str = msprintf("₹ %.2f L", val / 100000);
    else
        str = msprintf("₹ %d", round(val));
    end
endfunction

function update_finance_plot()
    global VLP_CONTEXT;
    
    P = VLP_CONTEXT.finance.sld_sip.value;
    annual_rate = VLP_CONTEXT.finance.sld_rate.value;
    years = VLP_CONTEXT.finance.sld_time.value;
    
    i = annual_rate / (12 * 100); 
    total_months = years * 12;
    
    months_arr = 1:total_months;
    years_arr = months_arr / 12; 
    
    invested_arr = P * months_arr;
    wealth_arr = P * (((1 + i).^months_arr - 1) / i) * (1 + i);
    
    total_invested = invested_arr(total_months);
    total_wealth = wealth_arr(total_months);
    VLP_CONTEXT.finance.lbl_sip.string = "₹ " + string(round(P));
    VLP_CONTEXT.finance.lbl_rate.string = string(round(annual_rate)) + " %";
    VLP_CONTEXT.finance.lbl_time.string = string(round(years)) + " Years";
    VLP_CONTEXT.finance.lbl_invested.string = format_inr(total_invested);
    VLP_CONTEXT.finance.lbl_wealth.string = format_inr(total_wealth);
    
    drawlater();
    VLP_CONTEXT.finance.line_invested.data = [years_arr', invested_arr' / 100000];
    VLP_CONTEXT.finance.line_wealth.data = [years_arr', wealth_arr' / 100000];
    a = VLP_CONTEXT.finance.ax;
    scaled_max_wealth = total_wealth / 100000;
    a.data_bounds = [0, 0; years, scaled_max_wealth + (scaled_max_wealth * 0.1)]; 
    
    drawnow();                   
endfunction