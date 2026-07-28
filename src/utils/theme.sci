function theme = get_theme()
    theme = struct();
    theme.bg_main = [0.118, 0.118, 0.180];       // #1E1E2E - Deep slate
    theme.bg_panel = [0.165, 0.169, 0.239];      // #2A2B3D - Lighter panel
    theme.text_primary = [1.000, 1.000, 1.000];  // #FFFFFF - Pure white
    theme.text_secondary = [0.651, 0.675, 0.804]; // #A6ACCD - Muted blue-gray
    theme.accent = [0.000, 0.824, 0.827];        // #00D2D3 - Vibrant cyan
    theme.danger = [1.000, 0.322, 0.322];        // #FF5252 - Red
    theme.font_body = "Arial";
    theme.font_size_h1 = 20;
    theme.font_size_h2 = 16;
    theme.font_size_body = 12;
endfunction