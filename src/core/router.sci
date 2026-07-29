function navigate_to(screen_name)
    global VLP_CONTEXT;
    current_ui = VLP_CONTEXT.window.children;
    if ~isempty(current_ui) then
        delete(current_ui);
    end
    a = gca();
    a.visible = "off";
    select screen_name
        case "dashboard" then
            render_dashboard(VLP_CONTEXT.window, VLP_CONTEXT.theme);
        case "physics" then
            render_physics(VLP_CONTEXT.window, VLP_CONTEXT.theme);
        else
            disp("404 Error: Module not found -> " + screen_name);
    end
endfunction