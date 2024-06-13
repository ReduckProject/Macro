load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")
load("Macro/Lib_PVX.lua")
load("Macro/Lib_Tools.lua")


--addopt("马嵬驿自动跑商", false)
local timer = 0
local timer2 = 0
local f = {}
local goodsExchangeCount = 0

local timer3 = 0
function Main()
    local map = map();
    --打开千里
    clickButton("Topmost/MB_PlayerMessageBoxCommon/Wnd_All/Btn_Option1/")
    --进入地图
    timer2 = timer2 + 1
    if timer2 > 32 then
        clickButton("Normal/SwitchServerDLC/Wnd_Total/PageSet_Total/Page_QLFZ/WndContainer_LKS/Btn_EnterMap/")
        timer2 = 0
    end
    -- 确认进入烂柯山
    clickButton("Topmost/MB_msg_enter_map/Wnd_All/Btn_Option1/")
    -- 确认重置神行
    clickButton("Topmost1/TrafficSure/Wnd_EasyTraffic/Wnd_TrafficSkill/Btn_SureGO2/")
    if map ~= "马嵬驿" and map ~= "龙门荒漠" then
        if nobuff("据点贸易") then
            --神行过图确认
            clickButton("Topmost2/MB_SkillTraffic/Wnd_All/Btn_Option1/")
            timer = timer + 1
            if timer > 200 then
                if map ~= "跨服·烂柯山" and goodsExchangeCount == 0 then
                    --actionclick(2, 16)
                end
                timer = 0
            end
        end
    else
        if nobuff("据点贸易") and goodsExchangeCount == 0 then
            clickButton("Topmost1/WorldMap/Btn_Close/")
        end
    end
    --点赞
    clickButton("Normal1/FriendPraise1/")
    if map == "跨服·烂柯山" then
        timer3 = timer3 + 1
        --离开烂柯山确定
        --clickButton("Topmost/MB_LeavePVP/Wnd_All/Btn_Option1/")
        if timer3 > 100 then
            if autoMove(g_map["恶人烂柯山捡草"], false) then
                if buff("骑御") then
                    cast(54)
                end
            end
        end
    end

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

    if map == "马嵬驿" then
        if nobuff("据点贸易") then
            autoMove(g_map["马嵬驿神行点到商点"], false)
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


