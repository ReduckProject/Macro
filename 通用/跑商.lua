
load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")

function Main()
    --print(g_map_move.moveToNpc, g_map_move.currentStep, g_map_move.coordinateLength, g_map_move.currentMap, g_map_move.currentGoods)


    local map = map();

    if map == "������ÿ�ɽ" or map == "������" then
        g_base["�ɼ�"]()
    end

    if map == "������" or map == "���Ż�Į" or map == "������" or map == "���" then
        g_map_move["�ƶ�"]()
    end


end