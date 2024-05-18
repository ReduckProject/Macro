load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")
load("Macro/Lib_PVX.lua")

local f = {}
function Main()
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

    if map == "枫叶泊·乐苑" or map == "帮会领地" or map == "广陵邑" then
        g_pvx["钓鱼"]()
    end
end


