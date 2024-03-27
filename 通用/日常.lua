load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")

local f = {}
function Main()
    --print(g_map_move.moveToNpc, g_map_move.currentStep, g_map_move.coordinateLength, g_map_move.currentMap, g_map_move.currentGoods)

    if nofight() then
        local map = map();

        if map == "跨服·烂柯山" or map == "帮会领地" or map == "南屏山" or map == "昆仑" or map == "南屏山" then
            g_base["采集"]()
        end

        if map == "帮会领地" then
            g_base["杀猪"]()
        end

        if map == "马嵬驿" or map == "龙门荒漠" or map == "巴陵县" or map == "洛道" then
            g_map_move["移动"]()
        end
    end

    f["功夫熊猫"]()
end

local counter = 0
f["功夫熊猫"] = function()
    if map() ~= "和平谷" then
        return
    end

    local boss_npc = npc("名字:包子铺老板")
    if boss_npc ~= 0 then
        if counter == 10 then
            if not interact() then
                counter = 0
                return
            end
        end

        if counter == 20 then
            if not dialog("可以") then
                counter = 0
                return
            end
        end

        if counter == 30 then
            if not dialog("功夫熊猫  ★★★★") then
                counter = 0
                return
            end
        end

        counter = counter + 1

        if counter > 200 then
            counter = 0
        end
    end

    local nid = npc("模板ID:126758", "距离<30", "角度<30", "距离最近")
    if nid > 0 then
        cast(37436)
        moveto(xpos(nid))
    end
end

