local abs_frame_time = globals.AbsoluteFrameTime;
local math_floor = math.floor;
local callbacks_register = callbacks.Register;
local draw_text = draw.Text;
local ping = 0
local frame_rate = 0.0; -- flt
local skeet_font = draw.CreateFont("Verdana", 25, 700)
local aimware_font = draw.CreateFont("Arial", 21, 380)
local rifk7_font = draw.CreateFont("Fixedsys", 26, 300)
local normal = draw.CreateFont("Arial")
local fpsa = 255
local fakea = 0
local aamode = "false"
local aaalpha = 0
local vis_main = gui.Reference('VISUALS', "MISC", "Assistance")
local box = gui.Groupbox(vis_main, "Indicator", 0, 350, 213, 700)
local Fpsincheck = gui.Checkbox(box, "Fpsin", "FPS-Indicator", false);
local Fpsvalue = gui.Checkbox(box, "Fps_value", "FPS-Value", false);
local Fps_t = gui.Combobox(box, "Fps_t", "FPS Warning", "Off", "If below cmdrate", "If below Value");
local fps_slider = gui.Slider(box, "Fps_slider", "FPS Warning Value", 80, 10, 144)
local fps_res = gui.Checkbox(box, "Fps_res", "FPS Restrict", false);
local fps_slider_res = gui.Slider(box, "rest_slider", "FPS Restrict Value", 144, 10, 400)
local Pingincheck = gui.Checkbox(box, "Pingin", "Ping-Indicator", false);
local ping_val = gui.Checkbox(box, "Pingval", "Ping-Value", false);
local ping_slider = gui.Slider(box, "Ping_slider", "Ping Warning", 40, 10, 200)
local Flagcheck = gui.Checkbox(box, "Falg", "FLAG-Mode", false);
local Flagvalue = gui.Checkbox(box, "Falg_value", "FLAG-Value", false)
local Overridecheck = gui.Checkbox(box, "Override_key", "Override-Inidcator", false)
local speedcheck = gui.Checkbox(box, "Speed", "Speed-Indicator", false)
local aa_mode = gui.Checkbox(box, "aa", "Desync-Indicator", false)
local active_x = gui.Checkbox(box, "active_x", "Custom-X", false)
local wight_slider = gui.Slider(box, "wight_slider", "X Pos", 30, 10, 1700)
local active_y = gui.Checkbox(box, "active_y", "Custom-Y", false)
local high_slider = gui.Slider(box, "high_slider", "Y-Pos", 45, 30, 1010)
local active_gap = gui.Checkbox(box, "active_gap", "Custom-Gap", false)
local dis_slider = gui.Slider(box, "dis_slider", "Gap", 25, 0, 100)
local shadowcheck = gui.Checkbox(box, "Ocheck_shadow", "Text-Shadow", false)
local theme_combo = gui.Combobox(box, 'Theme', " Font-Theme", "Skeet", "Aimware", "rifk7")
local Standing = false
local Moving = false
local VERSION_NUMBER = 8;


local function get_abs_fps()

    frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * abs_frame_time();
    return math_floor((1.0 / frame_rate) + 0.5);
end



local function moving()
    if entities.GetLocalPlayer() ~= nil then
        Alive = entities.GetLocalPlayer():IsAlive();
    end



    if entities.GetLocalPlayer() ~= nil then

        local LocalPlayerEntity = entities.GetLocalPlayer();
        local fFlags = LocalPlayerEntity:GetProp("m_fFlags");

        local VelocityX = LocalPlayerEntity:GetPropFloat("localdata", "m_vecVelocity[0]");
        local VelocityY = LocalPlayerEntity:GetPropFloat("localdata", "m_vecVelocity[1]");

        local Velocity = math.sqrt(VelocityX ^ 2 + VelocityY ^ 2);


        if Velocity == 0 and (fFlags == 257 or fFlags == 263 or fFlags == 261) then
            Standing = true
        else
            Standing = false
        end

        if Velocity > 0 and (fFlags == 257 or fFlags == 263 or fFlags == 261) then
            Moving = true
        else
            Moving = false
        end
        return Velocity
    end
end



local function drawing_stuff()
    local Pingin = Pingincheck:GetValue()
    local Fpsin = Fpsincheck:GetValue()
    local overrideactive = Overridecheck:GetValue()
    local fakelatency_enable = gui.GetValue("msc_fakelatency_enable")
    local fakelatency_value = gui.GetValue("msc_fakelatency_amount")
    local fakelatency = 0
    local checkrage = gui.GetValue("rbot_active")
    local pos = 1015
    local pos2 = 1015
    local pos3 = 1015
    local main_active = gui.GetValue("esp_active")
    local ping_value = ping_slider:GetValue()
    local fakelagmode = ""
    local fakelag_enable = gui.GetValue("msc_fakelag_enable")
    local fakelag_mode = gui.GetValue("msc_fakelag_mode")
    local Flagin = Flagcheck:GetValue()
    local fakelag_value = gui.GetValue("msc_fakelag_value")
    local fakelag_value_ind = Flagvalue:GetValue()
    local fill1 = ""
    local flag_standing = gui.GetValue("msc_fakelag_standing")
    local override_key = gui.GetValue("rbot_resolver_override")
    local flag_moving = gui.GetValue("msc_fakelag_style")
    local Alive = false
    local speed_active = speedcheck:GetValue()
    local resolver = gui.GetValue("rbot_resolver")
    if entities.GetLocalPlayer() ~= nil then
        Alive = entities.GetLocalPlayer():IsAlive();
    end
    local Fpsin = Fpsincheck:GetValue()
    local main_active = gui.GetValue("esp_active")
    local fps_value = fps_slider:GetValue()
    local Fps_value_ind = Fpsvalue:GetValue()
    local mode = Fps_t:GetValue()
    local fps_rest = fps_res:GetValue()
    local fps_rest_val = fps_slider_res:GetValue()
	local ping_value1 = ping_val:GetValue()
    local aain = aa_mode:GetValue()
    if main_active then

        if fps_rest then
            client.Command("fps_max " .. fps_rest_val, true)
        end

        if mode == 0 then
            r1, g1, b1 = 126, 183, 50
        end


        if mode == 2 then
		print(get_abs_fps())
		print(fps_value)
            if get_abs_fps() < fps_value then
				r1, g1, b1 = 255, 0, 0
            else 
             r1, g1, b1 = 126, 183, 50
            end
        end

        if mode == 1 then
            tick = tonumber(client.GetConVar("sv_mincmdrate"))
		
		if get_abs_fps() < tick then
                r1, g1, b1 = 255, 0, 0
            else
                r1, g1, b1 = 126, 183, 50
            end
        end
        if Fpsin and Fps_value_ind then
            Fps_value_show = get_abs_fps()
        else
            Fps_value_show = ""
        end

        if Fpsin and main_active then
            --draw.Color(r1, g1, b1, fpsa)
            --draw.SetFont(pingfont)
            TextAdd("FPS " .. Fps_value_show, r1, g1, b1, fpsa);
            --draw.Text(20, 1015, "FPS")
            --draw.SetFont(normal)
        end

        if Alive then
            moving()


            if Pingin then


                fakea = 255
                p, i, n = 126, 183, 50

                if entities.GetPlayerResources() ~= nil then
                    ping = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())
                else
                    ping = 0
                end

                if (fakelatency_enable) then
                    fakelatency = math.ceil(fakelatency_value * 1000)
                    fakea = 255
                    if ping > (fakelatency * 0.75) then
                        p, i, n = 126, 183, 50

                    elseif ping < (fakelatency * 0.75) and ping > (fakelatency * 0.5) then
                        fakea = 255
                        p, i, n = 255, 165, 0
                    elseif ping < (fakelatency * 0.5) and ping > (fakelatency * 0.25) then
                        p, i, n = 255, 69, 0
                    elseif ping < (fakelatency * 0.25) then
                        p, i, n = 255, 0, 0
                    end

                    if fakelatency > 200 then
                        TextAdd("Reduce Fakelatency", 255, 0, 0, 255)
                    end
                end

                fill = ""
                local spike = ""
                if fakelatency_enable then
                    if ping < 199 then
                        spike = "Spike"
                        fill = " "
                    end
                end
                if ping > 199 then
                    spike = "Warning"
                    fill = " "
                    p, i, n = 255, 0, 0
                end


                if fakelatency_enable ~= true then
                    if ping > ping_value then
                        p, i, n = 255, 0, 0
                    elseif ping < ping_value * 0.85 and ping > ping_value * 0.75 then
                        p, i, n = 255, 165, 0
                    elseif ping < ping_value * 0.75 then
                        p, i, n = 126, 183, 50
                    end
                end

				if ping_value1 then
                ping = ping 				
				
				else 
				ping = ""				
				end


                --draw.Color(p, i, n, fakea)
                --draw.SetFont(pingfont)
                TextAdd("PING " .. spike .. fill .. ping, p, i, n, fakea); 
                --draw.Text(20, pos2, "PING " .. ping)
                --draw.SetFont(normal)
            end



            if (Flagin or fakelag_value_ind) then


                if (fakelag_enable) then

                    if flag_standing and Standing then
                        f, l, g = 126, 183, 50
                    elseif flag_standing == false and Standing then
                        f, l, g = 255, 0, 0
                    end
                    if flag_moving == 1 and Moving then
                        f, l, g = 255, 0, 0
                    elseif flag_moving ~= 1 and Moving then
                        f, l, g = 126, 183, 50
                    end

                    if flag_moving == 0 then
                        if flag_standing == false and Standing then
                            f, l, g = 255, 0, 0
                        else
                            f, l, g = 126, 183, 50
                        end
                    end

                    if flag_moving == 1 then
                        if Standing or Moving then
                            f, l, g = 255, 0, 0
                        else
                            f, l, g = 126, 183, 50
                        end
                    end

                    if flag_moving == 2 then
                        if flag_standing == false and Standing then
                            f, l, g = 255, 0, 0
                        else
                            f, l, g = 126, 183, 50
                        end
                    end

                else
                    f, l, g = 255, 0, 0
                end

                if Flagin then

                    if (fakelag_mode == 0) then
                        fakelagmode = "Factor"

                    elseif (fakelag_mode == 1) then
                        fakelagmode = "Switch"

                    elseif (fakelag_mode == 2) then
                        fakelagmode = "Adaptive"

                    elseif (fakelag_mode == 3) then
                        fakelagmode = "Random"

                    elseif (fakelag_mode == 4) then
                        fakelagmode = "Peek"
                    elseif (fakelag_mode == 5) then
                        fakelagmode = "Rapid-Peek"
                    end

                else
                    fakelagmode = ""
                end

                fill1 = ""
                if fakelag_value_ind and Flagin == false then
                    fakelag_val = fakelag_value
                    fill1 = ""
                elseif fakelag_value_ind and Flagin then
                    fakelag_val = fakelag_value
                    fill1 = " "
                else
                    fakelag_val = fill1
                end


                --draw.SetFont(pingfont)
                --draw.Color(f, l, g, 255)
                TextAdd("Flag " .. fakelagmode .. fill1 .. fakelag_val, f, l, g, 255)
                -- draw.SetFont(normal)
            end

            if aain then
                local mode_de = { "Off", "Still", "Balance", "Stretch", "Jitter" }
                local stand_de = gui.GetValue("rbot_antiaim_stand_desync")
                local move_de = gui.GetValue("rbot_antiaim_move_desync")
                de = "Desync "

                if Standing and stand_de > 0 then
                    mode_d = mode_de[stand_de + 1]
                    r2, g2, b2, a2 = 245, 198, 10, 255
                elseif Moving and move_de > 0 then
                    mode_d = mode_de[move_de + 1]
                    r2, g2, b2, a2 = 245, 198, 10, 255
                elseif Standing and stand_de == 0 then
                    r2, g2, b2, a2 = 255, 0, 0, 255
                    mode_d = "Off"
                elseif Moving and move_de == 0 then
                    r2, g2, b2, a2 = 255, 0, 0, 255
                    mode_d = "Off"
                end
                TextAdd(de .. mode_d, r2, g2, b2, a2)
            end


            if overrideactive and override_key ~= 0 and Alive then

                if input.IsButtonDown(override_key) then

                    if resolver then

                        TextAdd("Override ", 126, 183, 50, 255)
                    else
                        TextAdd("Override ", 255, 0, 0, 255)
                    end
                end
            end

            if speed_active and Alive then
                TextAdd("Velocity " .. math.floor(moving() + 0.5), 255, 255, 0, 255)
            end
        end
    end
    TextDrawing();
end


--local top_text = 1015;
local text_tabl = { {} };


function TextAdd(text, r, g, b, a)
    text_tabl[#text_tabl + 1] = { text, r, g, b, a };
end

function TextDrawing()

    sw, sh = draw.GetScreenSize();
    local a_gap = active_gap:GetValue()
    local a_x = active_x:GetValue()
    local a_y = active_y:GetValue()
    local posh = 45
    local posw = 30
    local gap = 25
    local font = theme_combo:GetValue()

    local shadow = shadowcheck:GetValue()
    if a_y then
        posh = (high_slider:GetValue())
    end
    if a_x then
        posw = (wight_slider:GetValue())
    end
    if a_gap then
        gap = dis_slider:GetValue()
    end




    top_text = sh - (gap * #text_tabl) - posh;
    for i = 1, #text_tabl do

        if font == 0 then
            draw.SetFont(skeet_font);
        elseif font == 1 then
            draw.SetFont(aimware_font)
        elseif font == 2 then
            draw.SetFont(rifk7_font)
        end

        draw.Color(text_tabl[i][2], text_tabl[i][3], text_tabl[i][4], text_tabl[i][5])
        draw.Text(posw, top_text + gap * i, text_tabl[i][1]);
        if shadow then
            draw.TextShadow(posw, top_text + gap * i, text_tabl[i][1])
        end
        draw.SetFont(normal);
    end;
    text_tabl = {}
end

callbacks.Register("Draw", "drawing_stuff", drawing_stuff);


local SCRIPT_FILE_NAME = GetScriptName();
local SCRIPT_FILE_ADDR = "https://raw.githubusercontent.com/DatIsKlar/aimware-lua/master/indicator.lua";
local VERSION_FILE_ADDR = "https://raw.githubusercontent.com/DatIsKlar/aimware-lua/master/indversion.txt";
local update_link = "raw.githubusercontent.com/DatIsKlar/update_log-aw/master/update_log_ind";


local update_available = false;
local version_check_done = false;
local update_downloaded = false;

local update_font = draw.CreateFont("Arial", 15, 15)
function indicator_draw_event()



    if (update_available and not update_downloaded) then
        if (gui.GetValue("lua_allow_cfg") == false) then
            draw.SetFont(update_font)
            draw.Color(255, 0, 0, 255);
            draw.Text(0, 0, "[Indicator] An update is available");
        else
            local new_version_content = http.Get(SCRIPT_FILE_ADDR);
            local old_script = file.Open(SCRIPT_FILE_NAME, "w");
			print("Open CS console for update log");
			client.Command("Update_Log");
			client.Command(update_link);
            old_script:Write(new_version_content);
            old_script:Close();
            update_available = false;
            update_downloaded = true;
        end
    end

    if (update_downloaded) then
        draw.SetFont(update_font)
        draw.Color(255, 0, 0, 255);
        draw.Text(0, 0, "[Indicator] An update has automatically been downloaded, reload the script");
		draw.Text(0,20,"[Indicator] Check Console for update log");
        return;
    end

    if (not version_check_done) then
        if (gui.GetValue("lua_allow_http") == false) then
            draw.SetFont(update_font)
            draw.Color(255, 0, 0, 255);
            draw.Text(0, 0, "[Indicator] Please enable Lua HTTP Connections in your settings tab to use this script");
            return;
        end

        version_check_done = true;
        local version = tonumber(http.Get(VERSION_FILE_ADDR));
        if (version ~= VERSION_NUMBER) then
            update_available = true;
        end
        draw.SetFont(normal)
    end
end

print("credit for auto-update goes to ShadyRetard")

callbacks.Register("Draw", "indicator_draw_event", indicator_draw_event);
