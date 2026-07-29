function render_physics(win, theme)
    ui_create_text(win, [50, 700, 400, 30], "PHYSICS LAB: Projectile Motion", theme.font_size_h1, theme.accent, theme.bg_main);
    
    ui_create_button(win, [850, 695, 120, 40], "BACK", "navigate_to(""dashboard"");", theme);
    
    ui_create_panel(win, [50, 100, 300, 550], theme.bg_panel);
    ui_create_text(win, [70, 610, 260, 20], "Simulation Parameters", theme.font_size_h2, theme.text_primary, theme.bg_panel);
    
    ui_create_panel(win, [400, 100, 570, 550], theme.bg_panel);
    ui_create_text(win, [400, 360, 570, 20], "[ Simulation Plot Will Render Here ]", theme.font_size_h2, theme.text_secondary, theme.bg_panel);
endfunction