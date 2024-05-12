output("奇穴: [雾锁][吐故纳新][抱一][抱元][玄德][跬步][万物][无我][霜寒][心眼][重光][规焉]")

--载入库
load("Macro/Lib_PVP.lua")
load("Macro/Lib_Base.lua")

--变量表
local v = {}

--函数表
local f = {}

local counter = 0
local tx, ty, tz = 0

local pickCounter = 0
--主循环
function Main(g_player)
    --初始化
    g_func["初始化"]()
    --if target() then
    --    tx, ty, tz = xpos(tid())
    --end
    --
    --if notarget() and tx > 0 then
    --    if moveto(tx, ty, tz) then
    --        tx, ty, tz = 0
    --        pickCounter = 0
    --    else
    --        return
    --    end
    --end
    --
    --pickCounter = pickCounter + 1
    --if pickCounter < 60 then
    --    return
    --end
    --
    --if nofight() then
    --    f["花朝节"]()
    --end
    --
    --f["重置"]()
    --选目标
    if notarget() then
        g_base["切换目标"]()
    end


    --if dis(tid()) > 6 then
    --    moveto(xpos(tid()))
    --end
    --
    turn()

    if mana() < 0.05 then
        cast("打坐")
        return
    end

    if state("坐下") and mana() > 0.9 then
        jump()
    end
    --镇山河
    if fight() and life() < 0.5 and height() < 3 then
        if nobuff("镇山河") and gettimer("镇山河") > 1 then
            if cast("镇山河", true) then
                settimer("镇山河")
                stopmove()
            end
        end
    end

    --凭虚御风
    if fight() and life() < 0.75 then
        cast("凭虚御风")
    end

    --紫气东来
    if rela("敌对") and g_var["目标没减伤"] and dis() < 20 and qidian() <= 3 and qjcount() >= 5 and bufftime("气剑") > 10 then
        if nobuff("紫气东来") and gettimer("紫气东来") > 0.3 then
            if cast("紫气东来") then
                settimer("紫气东来")
            end
        end
    end

    --生太极
    if nobuff("破苍穹") then
        cast("破苍穹")
    end

    --坐忘无我
    if nobuff("坐忘无我") then
        cast("坐忘无我")
    end

    if g_var["目标可攻击"] then
        if qidian() >= 8 then
            cast("两仪化形")
        end
    end

    if qjcount() < 5 then
        cast("万世不竭")
    end

    if g_var["目标可攻击"] then
        cast("四象轮回")
        cast("太极无极")
    end

    --采集任务物品
    if nofight() then
        g_func["采集"](g_player)
    end
end

f["切换目标"] = function()
    v["20尺内敌人"] = enemy("距离<20", "视线可达", "没载具", "气血最少")
    if v["20尺内敌人"] ~= 0 then
        --没目标或不是敌对
        if not rela("敌对") then
            settar(v["20尺内敌人"])
            return
        end

        --当前目标挂了
        if tstate("重伤") then
            settar(v["20尺内敌人"])
            return
        end

        --距离太远
        if dis() > 20 then
            settar(v["20尺内敌人"])
            return
        end

        --视线不可达
        if tnovisible() then
            settar(v["20尺内敌人"])
            return
        end

        --比当前目标血量少
        if tlife() > 0.3 and xlife(v["20尺内敌人"]) < tlife() then
            settar(v["20尺内敌人"])
            return
        end
    end
end

local resetPos = {
    { 82466, 33577, 1109568 },
    { 83282, 34648, 1110976 },
    { 83760, 32929, 1110272 }
}
local index = 3

function OnFight(bFight)
    counter = 0;
    if index >= 3 then
        index = 1
    else
        index = index + 1
    end
end

f["重置"] = function()
    local pickId = doodad("可拾取", "距离<20")
    if pickId ~= 0 then
        if moveto(xpos(pickId)) then
            interact(pickId)

        end
    end
    if notarget() and nofight() then
        moveto(resetPos[index][1], resetPos[index][2], resetPos[index][3])
    end
end

f["花朝节"] = function()
    local doodadId = doodad("名字:玫瑰花丛|牛角花丛|苜蓿花丛|蔷薇花丛|牵牛花丛|绣球花丛", "距离<6", "距离最近")
    if counter == 10 then
        if doodadId ~= 0 then
            interact(doodadId)
        end
    end

    if counter > 30 then
        dialog("弄死它！")
    end

    counter = counter + 1

    if counter > 100 then
        counter = 0
		print("Reset")
    end

end
