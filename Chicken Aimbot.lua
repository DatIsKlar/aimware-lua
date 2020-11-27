-- Very big pp from cheeseot for helping me out
local ref = gui.Reference( "Ragebot","Aimbot","Toggle")
local multi = gui.Multibox( ref, "Chicken Aimbot" )
local checkbox = gui.Checkbox( multi, "chicken.aimbot", "Chicken Aimbot", false )
checkbox:SetDescription("Enable On Shot")
local auto_shoot = gui.Checkbox( multi, "chicken.aimbot.autoshoot", "Chicken Autoshoot", false )
local silent = gui.Checkbox( multi, "chicken.aimbot.silent", "Silent Chicken Aim", false )
auto_shoot:SetDescription("When Active Whill auto Shoot Chickens")
local autostop = gui.Checkbox( multi, "chicken.aimbot.autostop", "Chicken Autostop", false )
autostop:SetDescription("Only works as full stop and is experimental")

local function no_recoil(viewangles_cmd, local_player) 
    local punchAngleVec = local_player:GetPropVector("localdata", "m_Local", "m_aimPunchAngle");
    local punchAngle = punchAngleVec*2.00000
    local new_angle = EulerAngles(0,0,viewangles_cmd.z)
    new_angle.x = viewangles_cmd.x  - punchAngle.x
    new_angle.y = viewangles_cmd.y  - punchAngle.y
    return new_angle
end

local function get_closed_enemy(players,local_player )
    local pos
    local min = math.huge
    local nearest
    for i, player in pairs(players) do
        if player:GetTeamNumber() ~= local_player:GetTeamNumber() then 
         local pos = player:GetAbsOrigin()
         if pos == nil then 
             return 
         end
            local lenght = (pos-local_player:GetAbsOrigin()):Length()
            if lenght < min then 
                local enemy_pos = player:GetHitboxPosition(1)
                local player_pos = local_player:GetAbsOrigin()
                player_pos.z = player_pos.z+local_player:GetPropVector("localdata", "m_vecViewOffset[0]").z
                local fraction_chicken = (engine.TraceLine( Vector3(player_pos.x,player_pos.y,player_pos.z), Vector3(enemy_pos.x,enemy_pos.y,enemy_pos.z), 0x1 )).fraction
                if fraction_chicken >= 0.9 then 
                min = lenght
                nearest = player
                end
            end
        end
     end
     return nearest
end

local Fl_ONGROUND = bit.lshift(1,0)
local FL_PARTIALGROUND = bit.lshift(1,17)
local on_jump = 0
local function is_active(local_player,chicken, weapon) 
    local status = false
    local m_flNextAttack = local_player:GetPropFloat("bcc_localdata", "m_flNextAttack")
    local fFlags = bit.tobit(local_player:GetProp( "m_fFlags" ))
    if bit.band(fFlags, FL_PARTIALGROUND) == FL_PARTIALGROUND or bit.band(fFlags,Fl_ONGROUND) ~= Fl_ONGROUND then 
        on_jump = globals.TickCount()
    end
    if on_jump +1 < globals.TickCount() then 
        if #chicken<1 or local_player:GetWeaponType() == 0 or not checkbox:GetValue() or m_flNextAttack >= globals.CurTime() or  m_flNextAttack >= globals.CurTime() or weapon:GetProp("m_iClip1") == 0 then 
            return false
        else 
            return true 
        end
    else
        return false 
    end
end

local function get_angle_shot(local_player, enemy)
    local closet = get_closed_enemy(enemy,local_player)
    if closet == nil then 
        return 
    end
    local player_pos = local_player:GetAbsOrigin()
    player_pos.z = player_pos.z+local_player:GetPropVector("localdata", "m_vecViewOffset[0]").z
    local enemy_pos = closet:GetHitboxPosition(1)
    local angle = (enemy_pos-player_pos):Angles()
    return angle
end

 local function auto_stop(local_player, cmd, m_flNextPrimaryAttack,time)
    if m_flNextPrimaryAttack+ time < globals.CurTime() then 
        local velocity = Vector3(local_player:GetPropFloat("localdata","m_vecVelocity[0]"), local_player:GetPropFloat("localdata","m_vecVelocity[1]"), local_player:GetPropFloat("localdata","m_vecVelocity[2]"))
        local direction = velocity:Angles()
        local speed = velocity:Length()
        direction.y = cmd.viewangles.y-direction.y
        local negate_direction = direction:Forward()*(-speed)
        cmd.forwardmove =  cmd.forwardmove*0.15+negate_direction.x
        cmd.sidemove = cmd.sidemove*0.15+negate_direction.y
    end
end

local time = 0
local IN_ATTACK = bit.lshift(1,0)
local IN_ATTACK_2 = bit.lshift(1,19)
callbacks.Register("CreateMove", function (cmd)   
    local local_player = entities.GetLocalPlayer()
    local chicken = entities.FindByClass("CChicken")
    local viewangles_cmd = cmd.viewangles 
    local weapon = local_player:GetPropEntity("m_hActiveWeapon")
    local m_flNextPrimaryAttack = weapon:GetProp("LocalActiveWeaponData", "m_flNextPrimaryAttack")

    if not is_active(local_player, chicken, weapon, m_flNextPrimaryAttack) then 
        return 
    end

    local angle = get_angle_shot(local_player,chicken)
    if angle == nil then 
        return 
    end
    local correctet_angle = no_recoil(angle, local_player)
    local autstop = autostop:GetValue()
    if bit.band(cmd.buttons, IN_ATTACK) == IN_ATTACK then -- on shot
        time = globals.CurTime()
        if autstop then 
            auto_stop(local_player, cmd,m_flNextPrimaryAttack,time)
        end
        cmd.viewangles = correctet_angle
        if not silent:GetValue() then 
            engine.SetViewAngles( angle ) 
        end
    end
    if auto_shoot:GetValue() then --autoshootw
        cmd.viewangles = correctet_angle
        if not silent:GetValue() then 
            engine.SetViewAngles( angle )
        end    
        if cmd.viewangles == correctet_angle then  
            if local_player:GetWeaponType() == 1 or local_player:GetWeaponType() == 5  then 
                if m_flNextPrimaryAttack+time +0.02 < globals.CurTime()  then 
                    if local_player:GetWeaponType() == 5  then 
                        if local_player:GetProp("m_bIsScoped") == 0 then 
                            cmd.buttons = bit.bor(IN_ATTACK_2, cmd.buttons)
                            time = globals.CurTime()
                        elseif local_player:GetProp("m_bIsScoped") == 1 then 
                            if autstop then 
                                auto_stop(local_player, cmd,m_flNextPrimaryAttack,time)
                            end
                            cmd.buttons = bit.bor(IN_ATTACK, cmd.buttons)  
                        end
                    else
                        if autstop then 
                            auto_stop(local_player, cmd,m_flNextPrimaryAttack,time)
                        end
                        cmd.buttons = bit.bor(IN_ATTACK, cmd.buttons)       
                        time = globals.CurTime()
                    end
                end
            else
                if autstop then 
                    auto_stop(local_player, cmd,m_flNextPrimaryAttack,time)
                end
                cmd.buttons = bit.bor(IN_ATTACK, cmd.buttons)
            end
        end
    end
end)
