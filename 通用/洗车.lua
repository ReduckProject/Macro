load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")

local s_init = {
    done = false,
    counter = 0,
    fightMap = false
}
function Main()
    --print(npc("模板ID:16113"))
    if s_init.counter % 100 == 0 then
        if not s_init.done then
            interact(1073741845)
            clickButton("Normal/ArenaQueue/Wnd_Arena/Wnd_Normal/Btn_TeamQueue")
        end
    end
    s_init.counter = s_init.counter + 1
    clickButton("Normal/ACC_JJCShowFinal/Wnd_JJC/Btn_Leave/")
end

function OnEnterMap(MapID, MapName)
    if MapName == "长安城" then
        s_init.counter = 0
        s_init.done = false
    end
end

function OnMessage(szMsg, szType)
    if szMsg.find(szMsg, "您已经加入") then
        s_init.done = true
    end
end