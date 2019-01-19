--thanks to QBER for helping me out

local pingfont = draw.CreateFont("Verdana", 35, 700)
local normal = draw.CreateFont("Arial")
local aa_rage = gui.Reference('RAGE', "MAIN", "Anti-Aim Main")
local box_2 = gui.Groupbox(aa_rage, "Manual-AA", 0, 660, 213, 450) --660
local active_check = gui.Checkbox(box_2, "Activate", "Activate", false)
local box = gui.Groupbox(box_2, "Manual-AA-Options", -15, 30, 210, 200)
local aakeybox = gui.Keybox(box, 'Aakey', "AA-Key", 0)
local back_key_nox = gui.Keybox(box, "Aakeyback", " AA-Back-Key", 0)
local autokeybox = gui.Keybox(box, 'autokey', "Autodir-Key", 0)
local change_real = gui.Slider(box, "real_slider", "Change Real", 90, 0, 180)
local auto_real = gui.Slider(box, "real_auto", "Auto Offset Real", 0, 0, 180)
local box_1 = gui.Groupbox(box_2, "Arrow-Options", -15, 240, 210, 250) --960
local active_arrow_check = gui.Checkbox(box_1, "Indicator_Arrows", "Indicator Arrows", false)
local arrow_slider = gui.Slider(box_1, "arrow_slider", "Arrow Thickness", 2, 0, 10)
local arrow_slider_size_x = gui.Slider(box_1, "arrow_slider_size", "Arrow Size X", 25, 0, 25)
local arrow_slider_size_y = gui.Slider(box_1, "arrow_slider_size", "Arrow Size Y", 17, 0, 17)
local aarow_slider_crosshair = gui.Slider(box_1, "arrow_slider_crosshair", "Distans from Crosshair", 200, 0, 400)
local time2 = 0
local time4 = 0
local a = 0
local auto_save = 1
local Standing = false
local Moving = false
local InAir = false



local function inair()

    local Alive = false
    if entities.GetLocalPlayer() ~= nil then
        Alive = entities.GetLocalPlayer():IsAlive();
    end


    if entities.GetLocalPlayer() ~= nil and Alive then



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

        if fFlags == 256 or fFlags == 262 then
            InAir = true
            time2 = globals.RealTime()
		
        else
            InAir = false
        end
    end
end






local function rage()

    local aa_angle_stand_real = gui.GetValue("rbot_antiaim_stand_real_add")
    local aa_angle_move_real = gui.GetValue("rbot_antiaim_move_real_add")
    local aa_mode_stand = gui.GetValue("rbot_antiaim_stand_real")
    local aa_mode_move = gui.GetValue("rbot_antiaim_move_real")
    local aa_key = aakeybox:GetValue()
    local is_down = false
    local down = false
    local checkrage = gui.GetValue("rbot_active")
    local rageaa = gui.GetValue("rbot_antiaim_enable")
    local auto = gui.GetValue("rbot_antiaim_autodir")
    local change_value = change_real:GetValue()
    local auto_real_offset = auto_real:GetValue()
    local auto_key = autokeybox:GetValue()
    local bacl_key = back_key_nox:GetValue()
    local active = active_check:GetValue()
    local Alive = false
    if entities.GetLocalPlayer() ~= nil then
        Alive = entities.GetLocalPlayer():IsAlive();
		
    end
	
	
		if auto ~= 0 then 
auto_save =gui.GetValue("rbot_antiaim_autodir")
end	


    if auto == 0 then
        aa_angle_stand_real_save = gui.GetValue("rbot_antiaim_stand_real_add")
        aa_angle_move_real_save = gui.GetValue("rbot_antiaim_move_real_add")
    end



    if aa_key ~= 0 then
        is_down = input.IsButtonPressed(aa_key)
        is_pressed = input.IsButtonDown(aa_key)
    end

    if auto_key ~= 0 then
        down = input.IsButtonPressed(auto_key)
    end

    if bacl_key ~= 0 then
        is_down_back = input.IsButtonPressed(bacl_key)
    end


    if active then
	inair()
	


        if (checkrage and rageaa) and entities.GetLocalPlayer() ~= nil and Alive then



            if auto == 0 then


                if aa_angle_stand_real < -35 and aa_angle_stand_real ~= 90 then
                    aa_angle_stand_real_new = change_value
                    a = 1
                elseif aa_angle_stand_real > 35 and aa_angle_stand_real ~= -90 then
                    aa_angle_stand_real_new = -change_value
                    a = 2         
                elseif aa_angle_stand_real > -35 and aa_angle_stand_real < 35 and a == 1 then
                    aa_angle_stand_real_new = -change_value
                elseif aa_angle_stand_real > -35 and aa_angle_stand_real < 35 and a == 2 then
                    aa_angle_stand_real_new = change_value
                elseif aa_angle_stand_real > -35 and aa_angle_stand_real < 35 and a == 0 then
                    aa_angle_stand_real_new = change_value
                end



                if is_down then
                    gui.SetValue("rbot_antiaim_move_real_add", aa_angle_stand_real_new)
                    gui.SetValue("rbot_antiaim_stand_real_add", aa_angle_stand_real_new)
                end

                if is_down_back then
                    gui.SetValue("rbot_antiaim_stand_real_add", 0)
                end


                if InAir then

                    aa_angle_move_real_new = 0
                    gui.SetValue("rbot_antiaim_move_real_add", aa_angle_move_real_new)

                elseif time2 + 0.05 < globals.RealTime() then

                    if change_value ~= 0 then
                        gui.SetValue("rbot_antiaim_move_real_add", aa_angle_stand_real)
                    end

                   
                end

            else
                    gui.SetValue("rbot_antiaim_stand_real_add", auto_real_offset)
                end

           
            if down and auto ~= 0 then
                gui.SetValue("rbot_antiaim_autodir", false)
                gui.SetValue("rbot_antiaim_move_real_add", aa_angle_move_real_save)
                gui.SetValue("rbot_antiaim_stand_real_add", aa_angle_stand_real_save)
            elseif down and auto == 0 then
                gui.SetValue("rbot_antiaim_autodir", auto_save)
            end
        end
    end
end

local function arrow()
    local aa_angle_stand_real = gui.GetValue("rbot_antiaim_stand_real_add")
    local aa_angle_move_real = gui.GetValue("rbot_antiaim_move_real_add")
    local screenx, screeny = draw.GetScreenSize()
    local posleftx, poslefty, posrightx, posrighty = (screenx / 2) - 200, screeny / 2, (screenx / 2) + 200, screeny / 2
    local arrow_size_x = arrow_slider_size_x:GetValue()
    local arrow_size_y = arrow_slider_size_y:GetValue()
    local arrow_crosshair = aarow_slider_crosshair:GetValue()
    local active_arrows = active_arrow_check:GetValue()
    local checkrage = gui.GetValue("rbot_active")
    local rageaa = gui.GetValue("rbot_antiaim_enable")
    local auto = gui.GetValue("rbot_antiaim_autodir")
    local active = active_check:GetValue()
    local arrow_size = arrow_slider:GetValue()

    local Alive = false
    if entities.GetLocalPlayer() ~= nil then
        Alive = entities.GetLocalPlayer():IsAlive();
    end
    if active then


        if (checkrage and rageaa) and entities.GetLocalPlayer() ~= nil and Alive then

            if auto == 0 then
                if Standing then
                    if aa_angle_stand_real > -145 and aa_angle_stand_real < 35 and aa_mode_stand ~= 2 then

                        l, e, f, t = 126, 183, 50, 255
                    else
                        l, e, f, t = 0, 0, 0, 180
                    end

                    if aa_angle_stand_real > 35 and aa_angle_stand_real < 145 and aa_mode_stand ~= 2 then

                        r, i, g, h = 126, 183, 50, 255
                    else
                        r, i, g, h = 0, 0, 0, 180
                    end

                    if aa_angle_stand_real < 35 and aa_angle_stand_real > -35 then
                        r, i, g, h = 0, 0, 0, 180
                        l, e, f, t = 0, 0, 0, 180
                        r1, b1, gh, a1 = 126, 183, 50, 255
                    else
                        r1, b1, gh, a1 = 0, 0, 0, 180
                    end
                end

                if Moving or InAir then
                    if aa_angle_move_real > -145 and aa_angle_move_real < -35 and aa_mode_move ~= 2 then

                        l, e, f, t = 126, 183, 50, 255
                    else
                        l, e, f, t = 0, 0, 0, 180
                    end

                    if aa_angle_move_real > 35 and aa_angle_move_real < 145 and aa_mode_move ~= 2 then

                        r, i, g, h = 126, 183, 50, 255
                    else
                        r, i, g, h = 0, 0, 0, 180
                    end

                    if aa_angle_move_real < 35 and aa_angle_move_real > -35 then
                        r, i, g, h = 0, 0, 0, 180
                        l, e, f, t = 0, 0, 0, 180
                        r1, b1, gh, a1 = 126, 183, 50, 255
                    else
                        r1, b1, gh, a1 = 0, 0, 0, 180
                    end
                end


            else
                h = 0
                t = 0
                a1 = 0
            end
        else
            h = 0
            t = 0
            a1 = 0
        end

        if active_arrows then

            draw.Color(r, i, g, h)
            draw.SetFont(pingfont)
            for i = 0, arrow_size do
                draw.Line(screenx / 2 + arrow_crosshair, screeny / 2 - i, screenx / 2 + arrow_crosshair - arrow_size_x, screeny / 2 - arrow_size_y - i);
                draw.Line(screenx / 2 + arrow_crosshair, screeny / 2 + i, screenx / 2 + arrow_crosshair - arrow_size_x, screeny / 2 + arrow_size_y + i);
            end

            draw.Color(l, e, f, t)
            draw.SetFont(pingfont)
            for i = 0, arrow_size do
                draw.Line(screenx / 2 - arrow_crosshair, screeny / 2 - i, screenx / 2 - arrow_crosshair + arrow_size_x, screeny / 2 - arrow_size_y - i);
                draw.Line(screenx / 2 - arrow_crosshair, screeny / 2 + i, screenx / 2 - arrow_crosshair + arrow_size_x, screeny / 2 + arrow_size_y + i);
            end

            draw.Color(r1, b1, gh, a1)
            draw.SetFont(pingfont)
            for i = 0, arrow_size do
                draw.Line(screenx / 2 - i, screeny / 2 + arrow_crosshair, screenx / 2 - arrow_size_y - i, screeny / 2 + arrow_crosshair - arrow_size_x);
                draw.Line(screenx / 2 + i, screeny / 2 + arrow_crosshair, screenx / 2 + arrow_size_y + i, screeny / 2 + arrow_crosshair - arrow_size_x);
            end
            draw.SetFont(normal)
        end
    end
end
local SCRIPT_FILE_NAME = "manualaa.lua";
local SCRIPT_FILE_ADDR = "https://raw.githubusercontent.com/DatIsKlar/aimware-lua/master/manualaa.lua";
local VERSION_FILE_ADDR = "https://raw.githubusercontent.com/DatIsKlar/aimware-lua/master/maversion.txt";
local VERSION_NUMBER = 2;


local update_available = false;
local version_check_done = false;
local update_downloaded = false;

local update_font = draw.CreateFont("Arial", 15, 15)
function manual_draw_event()



    if (update_available and not update_downloaded) then
        if (gui.GetValue("lua_allow_cfg") == false) then
            draw.SetFont(update_font)
            draw.Color(255, 0, 0, 255);
            draw.Text(0, 0, "[AA] An update is available");
        else
            local new_version_content = http.Get(SCRIPT_FILE_ADDR);
            local old_script = file.Open(SCRIPT_FILE_NAME, "w");
            old_script:Write(new_version_content);
            old_script:Close();
            update_available = false;
            update_downloaded = true;
        end
    end

    if (update_downloaded) then
        draw.SetFont(update_font)
        draw.Color(255, 0, 0, 255);
        draw.Text(0, 0, "[AA] An update has automatically been downloaded, reload the script");
        return;
    end

    if (not version_check_done) then
        if (gui.GetValue("lua_allow_http") == false) then
            draw.SetFont(update_font)
            draw.Color(255, 0, 0, 255);
            draw.Text(0, 0, "[Manual-AA] Please enable Lua HTTP Connections in your settings tab to use this script");
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

callbacks.Register("Draw", "manual_draw_event", manual_draw_event);




callbacks.Register("Draw", "rage", rage);
callbacks.Register("Draw", "arrow", arrow);
