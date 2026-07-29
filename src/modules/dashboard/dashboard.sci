function render_dashboard(win, theme)
    ui_create_text(win, [312, 600, 400, 40], "VISUAL LAB PRO", theme.font_size_h1 + 8, theme.accent, theme.bg_main);
    ui_create_text(win, [212, 560, 600, 20], "Interactive Engineering & STEM Virtual Laboratory", theme.font_size_body, theme.text_secondary, theme.bg_main);
    
    ui_create_button(win, [237, 400, 250, 60], "PHYSICS LAB", "navigate_to(""physics"");", theme);
    ui_create_button(win, [237, 300, 250, 60], "CIRCUIT LAB", "disp(""Routing to Circuits..."");", theme);
    
    ui_create_button(win, [537, 400, 250, 60], "DATA ANALYTICS", "disp(""Routing to Analytics..."");", theme);
    ui_create_button(win, [537, 300, 250, 60], "FINANCE LAB", "disp(""Routing to Finance..."");", theme);

    ui_create_text(win, [312, 50, 400, 20], "FOSSEE Scilab GUIVerse Hackathon", 10, theme.text_secondary, theme.bg_main);
endfunction