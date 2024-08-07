--[[ 奇穴: [素矰][棘矢][襄尺][长右][鹿蜀][桑柘][于狩][卢令][托月][佩弦][贯侯][朝仪万汇]
秘籍:
劲风	2会心 2伤害
饮羽	2调息 1重置 1非侠
引风	3调息 1回血

开打前把蓝打坐回满, 不然起手弛律不会放, 引风的释放时机有点问题导致有的大循环少1次棘矢引爆, 怕循环卡的太死实战中少打引风蓝不够
--]]

load("Macro/Lib_PVP.lua")
load("Macro/Lib_Skill.lua")

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)
addopt("自动选人", false)
addopt("自动打怪", false)
addopt("自动扶摇", false)
addopt("一刀", false)

--变量表
local v = {}
v["输出信息"] = true
v["没石次数"] = 0

--函数表
local f = {}

local timerSet = {}

--主循环
function Main()

    g_func["小轻功"]()

    if getopt("自动选人") then
        if g_func["周期执行"]("自动选人", 16) or notarget() then
            g_func["切换目标"](25)
        end
    end

    if getopt("一刀") then
        if g_func["周期执行"]("一刀", 8) or notarget() then
            g_func["一刀"]()
        end
    end

    if getopt("自动打怪") then
        if g_func["自动打怪"]() or notarget() then
            g_func["自动打怪"]()
        end
        turn()
    end

    f["花间处理"]()

    --if tbuff("斩无常|盾立|镇山河|南风吐月|巨门|冥泽") then
    if tbuff("斩无常|盾立|镇山河|南风吐月|巨门") then
        return
    end
    --应天授命
    if fight() then
        if life() < 0.2 then
            CastX("澄神醒梦")
        end

        if life() < 0.25 then
            CastX("应天授命")
        end
    end

    if target() and (not rela("敌对") or tlife() == 0) then
        return
    end

    if nofight() and target() then
        CastX("风矢")
    end

    if casting("饮羽簇") and castleft() < 0.13 then
        settimer("饮羽簇读条结束")
    end

    if gettimer("饮羽簇读条结束") < 0.3 then
        return
    end

    if castleft() > 0 then
        return
    end

    --初始化变量
    v["弓箭"] = rage()
    v["幻灵印"] = beast()

    v["饮羽CD"] = scdtime("饮羽簇")
    v["白羽CD"] = scdtime("白羽流星")
    v["金乌充能次数"] = cn("金乌见坠")
    v["金乌充能时间"] = cntime("金乌见坠", true)
    v["引风CD"] = scdtime("引风唤灵")
    v["弛律CD"] = scdtime("弛律召野")
    v["朝仪CD"] = scdtime("朝仪万汇")
    v["游雾乘云CD"] = cdtime("游雾乘云CD")

    v["承契层数"] = buffsn("承契")
    v["承契时间"] = bufftime("承契")
    v["贯穿层数"] = tbuffsn("贯穿", id())
    v["贯穿时间"] = tbufftime("贯穿", id())
    v["标鹄层数"] = tbuffsn("标鹄")
    v["标鹄时间"] = tbufftime("标鹄", id())
    v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10

    --寒更晓箭
    if v["弓箭"] < 8 and nobuff("合神") then
        if nofight() then
            --没进战把箭装满
            CastX("寒更晓箭")
        end

        if v["弓箭"] < 1 then
            --没箭了装箭, 自动装箭会比GCD晚1帧, 自己装, 抢不过也没影响, 抢过了还能快1帧
            CastX("寒更晓箭")
        end
    end
    if v["弓箭"] >= 5 then
        v["最后一支箭状态"] = arrow(0)
        if v["最后一支箭状态"] ~= 3 and v["最后一支箭状态"] ~= 4 then
            --if v["幻灵印"] ~= 1 then
            --最后一支箭没金乌
            CastX("空弦惊雁")
            --end
        end
    end

    --金乌见坠
    if v["弓箭"] >= 8 then
        --满箭才用
        if rela("敌对") and dis() < 30 then
            v["最后一支箭状态"] = arrow(0)
            if v["最后一支箭状态"] ~= 2 and v["最后一支箭状态"] ~= 4 then
                --最后一支箭没金乌
                if v["幻灵印"] ~= 1 or v["金乌充能次数"] >= 2 then
                    CastX("金乌见坠")
                end

                if not qixue("拖月") then
                    CastX("金乌见坠")
                end
            end

            if v["金乌充能次数"] >= 3 and bufftime("佩弦") < 0 and v["饮羽CD"] < 1 then
                --充能满了没瞬发
                CastX("金乌见坠")
            end
        end
    end

    if target() and fight() then
        if qixue("丛云隐月") then
            if v["幻灵印"] == 0 and (v["引风CD"] > 13 or v["弛律CD"] > 13) then
                if scdtime("丛云隐月") < 0.1 then
                    output("v0")
                end
                CastX("丛云隐月")
            end

            if v["幻灵印"] == 1 and v["引风CD"] > 16 and v["弛律CD"] > 16 then
                if scdtime("丛云隐月") < 0.1 then
                    output("v1")
                end
                CastX("丛云隐月")
            end
        end
    end

    if qixue("星烨") and fight() then
        if v["幻灵印"] == 0 then
            --if not nextbeast("野猪") and not beast("野猪") then
            --    --只召鹰
            --    setbeast({ "野猪", "虎", "熊", "鹰", "狼", "大象" })
            --end

            if scdtime("引风唤灵") < 5 then
                CastX("弛律召野")
            end
        end

        if v["幻灵印"] == 1 then
            --if not nextbeast("虎") and  not beast("虎") then
            --    --只召鹰
            --    setbeast({ "虎", "野猪", "鹰", "熊", "狼", "大象" })
            --end

            if v["幻灵印"] == 1 and scdtime("引风唤灵") > 2 then
                CastX("弛律召野")
            end
        end

        if v["幻灵印"] >= 2 and dis() > 0 and dis() < 30 then
            if (scdtime("弛律召野") < 43 and scdtime("弛律召野") > 0) or bufftime("澄神") < 3 then
                if v["游雾乘云CD"] < 0.3 then
                    if qixue("丛云隐月") then
                        CastX("丛云隐月")
                    end
                end
                CastX("游雾乘云")
            end
        end
    end

    if buff("游雾乘云") then
        if v["弓箭"] >= 2 then
            CastX("弛风鸣角")
        end
        CastX("劲风簇")
        return
    end

    if nofight() or notarget() and tlife() <= 0 or tbuff("斩无常") then
        return
    end

    if qixue("朱厌") or qixue("祝灵") and fight() then
        if qixue("兴游") and v["幻灵印"] >= 3 then
            if v["弓箭"] < 8 then
                CastX("寒更晓箭")
            end
            CastX("汇灵合契")
        end
        if v["幻灵印"] >= 4 then
            if v["弓箭"] < 8 then
                CastX("寒更晓箭")
            end
            CastX("汇灵合契")
        end

        if buff("合神") then
            if v["弓箭"] < 8 then
                CastX("白羽流星")
                --cast(35974)
            end
            if dis() < 10 then
                if scdtime("聚长川") == 0 and dis() < 10 then
                    if CastX("聚长川") then

                    end
                end
                if scdtime("汇山岚") == 0 and dis() < 6 then
                    if CastX("汇山岚") then

                    end
                end
            end

            --if CastX(35688) then
            if CastX("归平野") then

            end
            return
        end

        if not qixue("兴游") then
            if v["幻灵印"] == 1 then
                CastX("弛律召野")
                --CastX(35696)
            end
        else
            if v["幻灵印"] == 0 then
                CastX("弛律召野")
            end
        end
    end

    --引风唤灵, 和目标的角色距离大于20尺是在自己附近放
    if fight() and rela("敌对") and dis3() < 20 then
        CastX("引风唤灵")
    end

    if v["弓箭"] >= 3 then

        if buff("26861") then
            CastX("弛风鸣角")
        end

        --没石饮羽
        if buff("26862") then
            CastX("没石饮羽")
        end
    end

    if buff("佩弦") then
        if tlife() < 0.4 then
            CastX("饮羽簇")
        end

        if v["弓箭"] == 8 then
            CastX("劲风簇")
        end
    end
    if v["弓箭"] == 4 or v["弓箭"] == 8 then
        CastX("饮羽簇")
    end
    CastX("劲风簇")

    if getopt("自动扶摇") then
        CastX("扶摇直上")
    end
end


-------------------------------------------------------------------------------

--输出信息
function PrintInfo(s)
    local t = {}
    if s then
        t[#t + 1] = s
    end
    t[#t + 1] = "弓箭:" .. v["弓箭"]
    t[#t + 1] = "内力:" .. mana()
    --t[#t+1] = "幻灵印:"..v["幻灵印"]

    t[#t + 1] = "承契:" .. v["承契层数"] .. ", " .. v["承契时间"]
    t[#t + 1] = "贯穿:" .. v["贯穿层数"] .. ", " .. v["贯穿时间"]
    t[#t + 1] = "标鹄:" .. v["标鹄层数"] .. ", " .. v["标鹄时间"]

    t[#t + 1] = "饮羽CD:" .. v["饮羽CD"]
    t[#t + 1] = "白羽CD:" .. v["白羽CD"]
    t[#t + 1] = "引风CD:" .. v["引风CD"]
    --t[#t+1] = "弛律CD:"..v["弛律CD"]
    t[#t + 1] = "朝仪CD:" .. v["朝仪CD"]
    t[#t + 1] = "金乌CD:" .. v["金乌充能次数"] .. ", " .. v["金乌充能时间"]

    print(table.concat(t, ", "))
end

--使用技能并输出信息
function CastX(szSkill, bSelf)
    local skill = g_skill_action_bar[szSkill]
    if skill ~= nil then
        local _cdleft
        if skill[3] then
            _cdleft = scdtime(szSkill)
        else
            _cdleft = cdtime(szSkill)
        end
        if _cdleft > 0 then
            print(_cdleft)
            return
        end
        print(szSkill)
        actionclick(skill[1], skill[2])
    end

    --output(szSkill)

    if cast(szSkill, bSelf) then
        return true
    end
    return false
end

-------------------------------------------------------------------------------

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
    if CasterID == id() then
        if SkillID == 35665 then
            --没石饮羽
            v["没石次数"] = 0
            settimer("释放没石饮羽")
        end

        if SkillID == 35987 then
            --没石每跳子技能
            v["没石次数"] = v["没石次数"] + 1
        end

        if SkillID == 36165 then
            print("----------棘矢引爆")
        end

        if SkillID == 35695 then
            --引风唤灵
            settimer("释放引风唤灵")
        end

        if SkillID == 35669 then
            --寒更晓箭
            settimer("释放寒更晓箭")
            print("----------------------------------------寒更晓箭换箭")
        end

        if SkillID == 35661 then
            --饮羽簇
            deltimer("饮羽簇读条结束")
        end
    end


    -- 处理定时器
    local keysToDelete = {}
    -- 遍历表并记录值小于10的键
    for key, value in pairs(tableSet) do
        if gettimer(key) > value then
            table.insert(keysToDelete, key)
        end
    end
    -- 删除记录的键
    for _, key in ipairs(keysToDelete) do
        tableSet[key] = nil
    end
end

--战斗状态改变, 日志记录一下用于分析数据
function OnFight(bFight)
    if bFight then
        print("--------------------进入战斗")
    else
        print("--------------------离开战斗")
    end
end

function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
    --if TargetID == id() then
    --    if SkillName == "刀啸风吟·渊冰" then
    --        CastX("蹑云逐月")
    --        CastX("扶摇直上")
    --        CastX("风尽浮生")
    --        CastX("后撤")
    --    end
    --end
end

f["花间处理"] = function()
    if buff("芙蓉并蒂") then
        CastX("澄神醒梦")
    end
end

function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
    if jjc() then
        if SkillName == "楚河汉界" and xrela("敌对", CasterID) then
            CastX("扶摇直上")
            bigtext("霸刀准备隔墙 注意扶摇减伤")
        end

        if TargetID == id() then
            if SkillName == "刀啸风吟·渊冰" then
                CastX("澄神醒梦")
            end
        end
    end
end
