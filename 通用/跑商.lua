
load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")

function Main()
    --print(g_map_move.moveToNpc, g_map_move.currentStep, g_map_move.coordinateLength, g_map_move.currentMap, g_map_move.currentGoods)


    local map = map();

    if map == "跨服·烂柯山" or map == "帮会领地" then
        g_base["采集"]()
    end

    if map == "马嵬驿" or map == "龙门荒漠" or map == "巴陵县" or map == "洛道" then
        g_map_move["移动"]()
    end


end