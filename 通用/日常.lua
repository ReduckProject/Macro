load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")
load("Macro/Lib_PVX.lua")

local f = {}
local goodsExchangeCount = 0
function Main()
    local map = map();

    if map == "跨服·烂柯山" or map == "帮会领地" or map == "南屏山" or map == "昆仑" or map == "南屏山" then
        g_base["采集"]()
    end

    if map == "帮会领地" then
        g_base["杀猪"]()
    end

    if map == "马嵬驿" or map == "龙门荒漠" or map == "巴陵县" or map == "洛道" then
        if goodsExchangeCount < 3 then
            clickButton("Topmost/MB_on_switch_map_sure/Wnd_All/Btn_Option1/")
            clickButton("Normal/OldQuestAcceptPanel/Btn_Sure/")
            local nid = npc("名字:据点总管", "角色距离<8")
            if nid ~= 0 then
                interact(nid)
                dialog("据点贸易！恶人谷")
            end

            --if buff("骑御") then
            --    cast(54)
            --end

            if buff("据点贸易") and nobuff("骑御") then
                cast(53)
                return
            end

            g_map_move["移动"]()
        end
    end

    if map == "枫叶泊·乐苑" or map == "帮会领地" or map == "广陵邑" then
        g_pvx["钓鱼"]()
    end
end



function OnMessage(szMsg, szType)
    --output(szMsg)
    if szMsg.find(szMsg,"你已完成了") and szMsg.find(szMsg,"据点贸易") then
        goodsExchangeCount = goodsExchangeCount + 1
    end
end


