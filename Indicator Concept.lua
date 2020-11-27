local box
local wight_slider
local high_slider
local gap_slider
local theme_combo
local font_size
local font_thickness
local setup_done = false

local function set_up_gui(x, y)
    if (not setup_done) then
        vis_main = gui.Reference('VISUALS', "MISC", "Assistance");
        box = gui.Groupbox(vis_main, "Indicator")
        wight_slider = gui.Slider(box, "wight_slider_indicator", "X Pos", 30, 10, x);
        high_slider = gui.Slider(box, "high_slider_indicator", "Y-Pos", 45, 30, y);
        gap_slider = gui.Slider(box, "gap_slider", "Gap", 25, 0, 100);
        theme_combo = gui.Combobox(box, 'Fonts_Indicator', " Font", "Verdana", "Arial", "Fixedsys");
        font_size = gui.Slider(box, "font_slider_indicator", "Font Size", 25, 0, 60);
        font_thickness = gui.Slider(box, "font_slider_indicator", "Font Size", 700, 100, 1000);
        setup_done = true
    end
end

local fonts = { "Verdana", "Arial", "Fixedsys" }

local indicator_tabl = { {} };

add = {}

add.Indicator = function(text, r, g, b, a, status)
    if status then
        indicator_tabl[#indicator_tabl + 1] = { text, r, g, b, a };
    end
end

add.IndicatorForCheckbox = function(text, var, mode, status, r1, g1, b1, a1, r2, g2, b2, a2)
    local on
    if mode == 0 then
        on = true
        if gui.GetValue(var) then
            rf, gf, bf, af = r1, g1, b1, a1
        else
            rf, gf, bf, af = r2, g2, b2, a2
        end
    else
        if gui.GetValue(var) then
            on = true
            rf, gf, bf, af = r1, g1, b1, a1
        else
            on = false
        end
    end
    if status and on then
        indicator_tabl[#indicator_tabl + 1] = { text, rf, gf, bf, af };
    end
end

add.IndicatorForKeybox = function(text, var, mode, status, r1, g1, b1, a1, r2, g2, b2, a2)
    local on
    if entities.GetLocalPlayer() == nil or not entities.GetLocalPlayer():IsAlive() then
        return
    end
    if gui.GetValue(var) ~= 0 then
        if mode == 0 or mode == 3 then
            on = true
            if input.IsButtonDown(gui.GetValue(var)) then
                rf, gf, bf, af = r1, g1, b1, a1
            else
                rf, gf, bf, af = r2, g2, b2, a2
            end
        elseif mode == 1 then
            if input.IsButtonDown(gui.GetValue(var)) then
                rf, gf, bf, af = r1, g1, b1, a1
                on = true
            else
                on = false
            end
        elseif mode == 2 then
            on = true
            if input.IsButtonDown(gui.GetValue(var)) then
                rf, gf, bf, af = r1, g1, b1, a1
            else
                rf, gf, bf, af = r2, g2, b2, a2
            end
        elseif mode == 4 then
            on = false
        end
    elseif gui.GetValue(var) == 0 then
        if mode == 2 then
            rf, gf, bf, af = r2, g2, b2, a2
            on = true
        elseif mode == 3 then
            rf, gf, bf, af = r1, g1, b1, a1
            on = true
        elseif mode == 4 then
            rf, gf, bf, af = r1, g1, b1, a1
            on = true
        end
    end

    if on and status then
        indicator_tabl[#indicator_tabl + 1] = { text, rf, gf, bf, af };
    end
end

local function draw_Indicator()
    local sw, sh = draw.GetScreenSize();
    set_up_gui(sw, sh)
    if setup_done then
        top_text = sh - (gap_slider:GetValue() * #indicator_tabl) - high_slider:GetValue();
        draw.SetFont(draw.CreateFont(fonts[theme_combo:GetValue() + 1], math.floor(font_size:GetValue()), math.floor(font_thickness:GetValue())))
        for i = 1, #indicator_tabl do
            draw.Color(indicator_tabl[i][2], indicator_tabl[i][3], indicator_tabl[i][4], indicator_tabl[i][5]);
            draw.TextShadow(wight_slider:GetValue(), top_text + gap_slider:GetValue() * i, indicator_tabl[i][1]);
        end
        indicator_tabl = {};
    end
end

callbacks.Register("Draw", "draw_Indicator", draw_Indicator);
