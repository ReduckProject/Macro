--[[ 奇穴: [弹指 或 竭泽][烟霞 或 生息][青律 或 月华 或 秋肃][清疏 或 厥阴指][微潮][积势][书离][渐催 或 池月][寒清 或 锋末][清神][遥归][落子无悔]
秘籍:
星楼  2调息 1消耗 1减伤
提针  2读条 1疗效 1回墨意
长针  1消耗 1距离 2疗效
商阳  1距离 3消耗

奇穴秘籍只是推荐，我也不太会玩，你是老手你自己看着点
如果需要打断点[厥阴指], 开启宏选项中的打断
没有特殊情况当前目标一直选中boss就行了
--]]

load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")
load("Macro/Lib_PVP.lua")
--宏选项
addopt("打断", false)

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

local x, y, z = pos()

v["被芙蓉目标"] = 0
addopt("目标锁定", false)
addopt("攻防送", false)
--主循环
function Main()
    --if life() < 0.1 then
    --	clickButton("Topmost/RevivePanel/WndContainer_BtnList/Btn_Cancel/")
    --end
    --local nid = npc("名字:大龙")
    --if nid ~= 0 then
    --	turn()
    --	if xdis(nid) > 4 then
    --		moveto(xpos(nid))
    --	end
    --
    --	if notarget() then
    --		settar(nid)
    --	end
    --end

    --按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
    if keydown(1) then
        cast("扶摇直上")
    end

    local x1, y1, z1 = g_func["小轻功"]()

    if buff("展缓") then
        bigtext("展缓 不要动")
    end
    if nofight and nobuff("清心静气") then
        cast("清心静气")
    end

    if getopt("攻防送") then
        nid = player("可选中", "视线可达", "关系:敌对", "距离<60", "角度<10")
        if nid ~= 0 then
            x, y, z = xpos(nid)
            moveto(x, y, z)
            return
        end
    end

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

    if bufftime("兰摧玉折") > 9 and bufftime("钟林毓秀") > 9 then
        if buff("芙蓉并蒂") then
            if CastX("太阴指") then
                return
            end
        end

        if nobuff("金屋") and bufftime("芙蓉并蒂") < 4.8 then
            CastX("星楼月影")
        end
    end

    g_base["浮香丘箱子"]("星楼月影")

    --if buff("雷霆争女")
    if bufftime("八卦洞玄") > 2 and bufftime("八卦洞玄") < 4.6 then
        if nobuff("金屋") and scdtime("太阴指") == 0 then
            CastX("太阴指")
        else
            cast("后撤")
        end
    end

    if tbufftime("倒地") > 3 and tlife() < 0.8 then
        cast("春泥护花")
    end

    if buff("断魂刺") then
        local srcid = buffsrc("断魂刺")
        local cid = tid()
        settar(srcid)
        if scdtime("归园") < 2 then
            if srcid ~= 0 and (tbufftime("驰骋", srcid) > 0 or tbuff("合神")) and xdis(srcid) < 8 then
                xcast("归园", srcid)
            end
        else
            CastX("太阴指")
        end

        settar(cid)
    end

    if buff("倒地") then
        local srcid = buffsrc("倒地")
        local cid = tid()
        settar(srcid)

        if srcid ~= 0 and (tbufftime("驰骋", srcid) > 0 or tbuff("合神")) and xdis(srcid) < 8 then
            xcast("归园", srcid)
        end
        --settar(cid)
    end

    if buff("飞倾列缺") then
        if not cast("星楼月影") and nobuff("星楼月影") then
            if not cast("水月无间") and nobuff("水月无间") then
                cast("春泥护花", true)
            end
        end
    end

    --减伤
    if fight() and life() < 0.44 then
        if nobuff("大针") then
            cast("星楼月影")
        else
            if life() < 0.35 then
                cast("星楼月影")
            end
        end
    end

    if target() and scdtime("厥阴指") == 0 then
        --打断
        if getopt("打断") and tbuffstate("可打断") then
            CastX("厥阴指")
        end

        --local rank =  player("没状态:重伤", "关系:敌对", "读条:七星拱瑞|生太极|万世不竭|回雪飘摇|提针|长针|醉舞九天|迷仙引梦|冰蚕牵丝|天斗旋|兵主逆|鸿蒙天禁|杀星在尾|平沙落雁|青霄飞羽|变宫|变徵|笑傲光阴|云生结海|杯水留影|江逐月天|白芷含芳|青川濯莲|川乌射罔|且待时休|钟林毓秀|钟林毓秀|幻光步", "距离<20", "视线可达", "没载具", "气血最少")
        --if rank ~= 0 and rank == tid() then
        --	if xcastprog(rank ) > 0.3 or xcastpass(rank) > 0.5 or xcastleft(rank) < 0.3 then
        --		CastX("厥阴指")
        --	end
        --end

        if tcasting("七星拱瑞|生太极|吞日月|行天道|四象轮回|万世不竭|六合独尊|回雪飘摇|提针|长针|利针|醉舞九天|迷仙引梦|冰蚕牵丝|天斗旋|兵主逆|列宿游|鸿蒙天禁|杀星在尾|平沙落雁|杯水留影|青霄飞羽|变宫|宫|徵|变徵|笑傲光阴|云生结海|杯水留影|宫|江逐月天|白芷含芳|青川濯莲|川乌射罔|苍棘缚地|商陆缀寒|钩吻断肠|且待时休|兰摧玉折|钟林毓秀|阳明指|幻光步|任驰骋") then

            if tcasting("回雪飘摇|醉舞九天") then
                if tcastprog() > 0.2 or tcastpass() > 0.3 or tcastleft() < 0.3 then
                    stopcasting()
                    CastX("厥阴指")
                end
            end
            if tcastprog() > 0.4 or tcastpass() > 0.5 or tcastleft() < 0.3 then
                stopcasting()
                CastX("厥阴指")
            end
        end
    end

    if buff("怖畏暗刑|抢珠式|八卦洞玄") then
        if nobuff("金屋") then
            CastX("太阴指")
        end

        if bufftime("怖畏暗刑") > 2.5 then
            cast("后撤")
        end

        cast("扶摇直上")
    end

    --初始化变量
    v["墨意"] = rage()
    v["治疗量"] = charinfo("治疗量")    --如果想精确治疗，治疗量 * 技能系数 = 技能实际加血量
    v["治疗目标"] = f["获取治疗目标"]()
    v["治疗目标血量"] = xlife(v["治疗目标"])
    v["治疗目标是T"] = xmount("洗髓经|铁牢律|明尊琉璃体|铁骨衣", v["治疗目标"])

    if v["被芙蓉目标"] ~= 0 and v["被芙蓉目标"] ~= id() then
        settar(v["治疗目标"])
        v["治疗目标"] = v["被芙蓉目标"]
    end

    if tbufftime("兰摧玉折") > 9 and tbufftime("钟林毓秀") > 9 then
        if tbuff("芙蓉并蒂") then
            v["治疗目标"] = tid()
            if tnobuff("春泥护花|大针|镇山河|守如山|啸如虎|玄水蛊|天地低昂") then
                if tnobuff("大针") then
                    if scdtime("春泥护花") > 0 then
                        CastX("大针")
                    else
                        CastX("春泥护花")
                    end
                end
            end

        end
    else
        v["被芙蓉目标"] = 0
    end

    if tid() ~= v["治疗目标"] and id() ~= v["治疗目标"] then
        if (not rela("敌对")) and v["治疗目标血量"] < 0.8 then
            settar(v["治疗目标"])
        end
    end

    ---------------------------------------------
    if fight() then
        if v["治疗目标血量"] < 0.6 then
            CastX("春泥护花")
        end

        --听风
        if v["治疗目标血量"] < 0.35 then
            CastX("听风吹雪")
        end
    end

    if v["治疗目标血量"] < 0.8 then
        if buff("412|722|932|3458|6266") then
            --有瞬发
            CastX("长针")
        end
    end

    --长针
    if v["治疗目标血量"] < 0.45 then
        --水月
        if fight() and v["墨意"] < 20 then
            cast("水月无间")
        end

        if buff("412|722|932|3458|6266") then
            --有瞬发
            CastX("长针")
        end
    end

    if v["治疗目标血量"] < 0.35 then
        --加血
        CastX("大针")
    end
    --彼针

    --提针
    if v["治疗目标血量"] < 0.9 then
        --加血
        CastX("提针")
    end

    if v["墨意"] < 30 then
        --刷墨意
        CastX("提针")
    end

    --握针
    if rela("敌对") and ttid() ~= 0 and xrela("自己|友好|队友", ttid()) then
        --目标的目标 boss的目标大概率就是下一个要奶的人
        if xbufftime("握针", ttid(), id()) < 3 then
            xcast("握针", ttid())
        end
    end

    --碧水
    if fight() and mana() < 0.45 then
        cast("碧水滔天", true)
    end

    --秋肃
    if fight() and target("boss") and face() < 80 and qixue("秋肃") and tbufftime("秋肃") < 3 then
        cast("商阳指")
    end

    -- 握针
    xcast("握针", party("没状态:重伤", "距离<20", "视线可达", "我的buff时间:握针<3"))

    --脱战救人
    if casting("锋针") and castleft() < 0.13 then
        settimer("锋针读条结束")
    end

    if nofight() and not jjc() and gettimer("锋针读条结束") > 0.5 then
        xcast("锋针", party("有状态:重伤", "距离<20", "视线可达"))
    end

    if fight() then
        cast("扶摇直上")
    end
end

-------------------------------------------------------------------------------

f["获取治疗目标"] = function()
    if getopt("目标锁定") then
        if target() and tlife() < life() then
            return tid();
        else
            return id()
        end
    end

    local targetID = id()   --治疗目标先设置为自己, 不在队伍或者团队中时 party 返回 0
    local partyID = party("没状态:重伤", "不是自己", "距离<24", "视线可达", "没载具", "气血最少")    --获取血量最少队友

    if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then
        --有血量最少队友且比自己血量少
        targetID = partyID    --把他指定为治疗目标
    else
        if life() > 0.95 then
            if xrela("友好", tid()) and tid() > 0 and tlife() < 0.95 then
                targetID = tid()
            else
                --targetID = player("没状态:重伤", "同阵营", "不是自己", "距离<24", "视线可达", "没载具", "气血最少")
            end
        end

    end

    return targetID
end

--记录信息
function PrintInfo(s)
    local t = {}
    if s then
        t[#t + 1] = s
    end
    t[#t + 1] = "墨意:" .. v["墨意"]
    t[#t + 1] = "治疗目标:" .. v["治疗目标"]
    t[#t + 1] = "治疗目标血量:" .. format("%0.2f", v["治疗目标血量"])
    print(table.concat(t, ", "))
end

--对治疗目标使用技能
function CastX(szSkill)
    local success = g_func["敌对释放"](szSkill)
    if success then
        return success
    end
    if xcast(szSkill, v["治疗目标"]) then
        if v["记录信息"] then
            PrintInfo()
        end
        return true
    end
    return false
end

--
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
    if jjc() then
        if SkillName == "芙蓉并蒂" and xrela("敌对", CasterID) then
            v["被芙蓉目标"] = TargetID
        end

        if SkillName == "破重围" and xrela("敌对", CasterID) then

        end
    end


end