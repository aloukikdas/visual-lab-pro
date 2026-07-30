clear; clc; 
if ~isempty(winsid()) then close(winsid()); end

global VLP_CONTEXT;
VLP_CONTEXT = struct();

exec("src/utils/theme.sci", -1);
exec("src/shared/ui_components.sci", -1);
exec("src/modules/dashboard/dashboard.sci", -1);
exec("src/modules/physics/physics_lab.sci", -1);
exec("src/modules/analytics/analytics_lab.sci", -1);
exec("src/modules/circuit/circuit_lab.sci", -1);
exec("src/modules/finance/finance_lab.sci", -1);
exec("src/core/router.sci", -1);

VLP_CONTEXT.theme = get_theme();
VLP_CONTEXT.window = figure("figure_name", "Visual Lab Pro", ...
    "position", [100, 100, 1024, 768], ...
    "backgroundcolor", VLP_CONTEXT.theme.bg_main, ...
    "menubar", "none", ...
    "toolbar", "none");
datatipManagerMode(VLP_CONTEXT.window, "on");

a = gca();
a.visible = "off";
navigate_to("dashboard");