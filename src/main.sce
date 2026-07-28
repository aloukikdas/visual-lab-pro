clear; clc; 
if ~isempty(winsid()) then close(winsid()); end
exec("src/utils/theme.sci", -1);
exec("src/shared/ui_components.sci", -1);
theme = get_theme();
mainWindow = figure("figure_name", "Visual Lab Pro - Architecture Test", ...
    "position", [100, 100, 1024, 768], ...
    "backgroundcolor", theme.bg_main, ...
    "menubar", "none", ...
    "toolbar", "none");
// 4. Test UI Framework
// Drawing a centered card: x=312, y=234, width=400, height=300
testPanel = ui_create_panel(mainWindow, [312, 234, 400, 300], theme.bg_panel);

// Drawing centered text inside the card area
testTitle = ui_create_text(mainWindow, [312, 450, 400, 30], "Architecture Approved", theme.font_size_h1, theme.text_primary, theme.bg_panel);
testSub = ui_create_text(mainWindow, [312, 410, 400, 20], "UI Framework is active.", theme.font_size_body, theme.text_secondary, theme.bg_panel);

// Drawing a button centered inside the card area
testBtn = ui_create_button(mainWindow, [412, 280, 200, 40], "PROCEED TO NAV", "", theme);