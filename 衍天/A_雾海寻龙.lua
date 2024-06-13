--奇穴: [水盈][望旗][顺祝][列宿游][重山][神遁][亘天][连断][休囚][征凶][灵器][增卜]

--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}

--函数表
local f = {}

local counter = 0
--主循环
function Main(g_player)

    --nid = player("名字:移猪·唯我独尊|见人就啵·唯我独尊")
    --nid = player("名字:见人就啵·唯我独尊")
    --nid = player("名字:韩子墨·乾坤一掷")
    --if nid ~=0 then
    --    settar(nid)
    --end
    if castleft() > 0 then
        return
    end

    f["敌对复活点处理"]()
    f["低血量处理"](0.6)
    f["明教处理"]()

    if dengcount() < 1 then
        return
    end

    if target() and xrela("敌对", tid()) then
        if tbuffstate("可拉") then
            g_func["敌对释放"]("斗转星移")
        end
    end

    if cdtime("斗转星移") > 33 then
        if cdtime("踏星行") == 0 then
            --settar(id())
            g_func["敌对释放"]("踏星行")
        end
    end

    if cdtime("斗转星移") < 4 and not state("重伤") then
        if notarget() or dis() > 25 then
            f["选中斗转目标"]()
        else
            counter = counter + 1
            if counter ~= 16 then
                counter = 0
                f["选中斗转目标"]()
                return
            end
        end
    end
end

f["选中斗转目标"] = function()
    if cdtime("斗转星移") == 0 then
        nid = player("可选中", "视线可达", "内功:笑尘诀|太玄经|焚影圣诀|紫霞功", "自己可视", "可视自己", "关系:敌对", "距离<34")
        if nid == 0 then
            nid = player("可选中", "视线可达", "自己可视", "可视自己", "关系:敌对", "距离<34")
        end
        if nid ~= 0 then
            if xbuffstate("可拉", nid) then
                settar(nid)
            end

        end
    end
end

f["敌对复活点处理"] = function()
    --local nid = npc("名字:天罡武卫", "角色距离<6")
    local nid = npc("名字:天罡武卫|雪魔武卫", "角色距离<6", "关系:敌对")
    if nid ~= 0 and xrela("敌对", nid) then
        if cdtime("鸿蒙天禁" == 0) then
            --settar(id())
            cast("鸿蒙天禁")
        end
        g_func["敌对释放"]("巨门北落")
        g_func["敌对释放"]("返闭惊魂")
        g_func["敌对释放"]("踏星行")
    end
end

f["低血量处理"] = function(_life)
    if _life == nil then
        _life = 0.6
    end
    pid = player("关系:敌对", "自己距离<18")

    if life() < _life and pid ~= 0 then
        g_func["敌对释放"]("巨门北落")
        g_func["敌对释放"]("返闭惊魂")
        if cdtime("鸿蒙天禁" == 0) then
            --settar(id())
            cast("鸿蒙天禁")
        end
        g_func["敌对释放"]("踏星行")
    end
end

f["明教处理"] = function()
    pid = player("关系:敌对", "内功:焚影圣诀", "自己距离<4")
    if pid ~= nil and xrela("敌对") then
        output("明教处理")
        g_func["敌对释放"]("巨门北落")
        if cdtime("鸿蒙天禁" == 0) then
            --settar(id())
            cast("鸿蒙天禁")
        end
        g_func["敌对释放"]("返闭惊魂")
        g_func["敌对释放"]("踏星行")
    end
end

f["封内处理"] = function()

end