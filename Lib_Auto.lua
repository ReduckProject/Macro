g_auto_play = {}
g_auto_play_f = {}
g_auto_play_v = {}

g_auto_play["紫霞功"] = function()
    if fight() and life() < 0.5 and nobuff("坐忘无我") then
        cast("坐忘无我")
    end

    if casting("六合独尊") and castleft() < 0.13 then
        settimer("六合读条结束")
    end
    if casting("破苍穹") and castleft() < 0.13 then
        settimer("破苍穹读条结束")
    end

    if casting("四象轮回") and castleft() < 0.13 then
        settimer("等待气点同步")
    end
    if gettimer("等待气点同步") < 0.3 then
        return
    end

    --初始化变量
    g_auto_play_v["气点"] = qidian()
    local tSpeedXY, tSpeedZ = speed(tid())
    g_auto_play_v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0        --目标没移动
    g_auto_play_v["破苍穹距离"], g_auto_play_v["破苍穹时间"] = qc("气场破苍穹", id(), id())        --自己附近自己的气场, 距离是自己到气场边缘的距离，在圈外是正数，在圈内是负数
    g_auto_play_v["目标位置自己的六合"] = tnpc("关系:自己", "模板ID:58295", "平面距离<5")
    g_auto_play_v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 5    --目标当前血量大于自己最大血量5倍


    --镇山河
    if qixue("破势") then
        cast("镇山河", true)
    end

    --紫气
    if g_auto_play_v["目标静止"] and g_auto_play_v["目标血量较多"] and dis() < 20 then
        if g_auto_play_v["破苍穹距离"] < -3 and g_auto_play_v["破苍穹时间"] > 10 then
            if g_auto_play_v["目标位置自己的六合"] ~= 0 and gettimer("释放六合") < 2 then
                if cast("紫气东来") then
                    cast("凭虚御风")
                    settimer("紫气东来")
                end
            end
        end
    end

    --三才
    if qixue("厚亡") and g_auto_play_v["目标静止"] and dis() < 5 and face() < 60 and g_auto_play_f["没紫气"]() and scdtime("紫气东来") > 5 and cdleft(16) >= 0.5 then
        if cast("三才化生") then
            settimer("三才化生")
        end
    end

    --万世一段
    if rela("敌对") and dis() < 25 and qjcount() < 5 then
        cast(18640)
    end

    --破苍穹
    if rela("敌对") and dis() < 25 and g_auto_play_v["破苍穹距离"] > -1 then
        --没有破苍穹或者快出圈了
        cast("破苍穹", true)
    end

    --万世二段
    if buff("12504|12783") then
        if bufftime("气剑") < 3.75 then
            cast(18654)
        end

        --[[六合紫气前放二段?
        if scdtime("六合独尊") < cdinterval(16) and scdtime("紫气东来") < cdinterval(16) * 2 then
            cast(18654)
        end
        --]]

        --[[气点不够两仪，万世一段CD小于一个GCD，打二段，实战测试是否有提升
        if gettimer("释放飞剑") < 1 and scdtime(18640) < cdinterval(16) and g_auto_play_v["气点"] < 7 then
            cast(18654)
        end
        --]]
    end

    --六合
    if gettimer("六合读条结束") > 0.25 and g_auto_play_v["目标静止"] then
        if scdtime("紫气东来") < cdinterval(16) then
            if g_auto_play_v["破苍穹距离"] < -3 and g_auto_play_v["破苍穹时间"] > 12 then
                cast("六合独尊")
            end
        end

        if scdtime("紫气东来") > 10 then
            cast("六合独尊")
        end
    end

    --两仪
    if g_auto_play_v["气点"] >= 7 then
        cast("两仪化形")
    end

    --补破苍穹
    if rela("敌对") and dis() < 25 and scdtime("六合独尊") < cdinterval(16) and scdtime("紫气东来") < cdinterval(16) * 2 and g_auto_play_v["破苍穹时间"] < 12 then
        cast("破苍穹", true)
    end

    --化三清
    if fight() and mana() < 0.4 and state("站立") then
        cast("化三清", true)
    end

    --四象
    if gettimer("六合读条结束") > 0.5 then
        if g_auto_play_f["有紫气"]() then
            if g_auto_play_v["气点"] < 5 then
                cast("四象轮回")
            end
        else
            cast("四象轮回")
        end
    end

    if nofight() and nobuff("坐忘无我") then
        cast("坐忘无我")
    end
end

g_auto_play_f["没紫气"] = function()
    if buff("紫气东来") or gettimer("紫气东来") < 0.5 or gettimer("三才化生") < 0.5 then
        return false
    end
    return true
end

g_auto_play_f["有紫气"] = function()
    if buff("紫气东来") or gettimer("紫气东来") < 0.5 or gettimer("三才化生") < 0.5 then
        return true
    end
    return false
end

g_auto_play["太虚剑意"] = function()

    --按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
    if keydown(1) then
        cast("扶摇直上")
    end

    --减伤
    if fight() and life() < 0.5 and buffstate("减伤效果") < 40 then
        if gettimer("坐忘无我") > 0.3 and nobuff("坐忘无我") then
            cast("转乾坤")
        end
        if gettimer("转乾坤") > 0.3 then
            cast("坐忘无我")
        end
    end

    --初始化变量
    g_auto_play_v["气点"] = qidian()

    local tSpeedXY, tSpeedZ = speed(tid())
    g_auto_play_v["目标静止"] = rela("敌对") and tSpeedXY <= 0 and tSpeedZ <= 0
    g_auto_play_v["GCD间隔"] = cdinterval(16)
    g_auto_play_v["碎星辰CD"] = scdtime("碎星辰")
    g_auto_play_v["吞日月CD"] = scdtime("吞日月")
    g_auto_play_v["三环CD"] = scdtime("三环套月")
    g_auto_play_v["万剑CD"] = scdtime("万剑归宗")
    g_auto_play_v["八荒CD"] = scdtime("八荒归元")
    g_auto_play_v["人剑CD"] = scdtime("人剑合一")
    g_auto_play_v["紫气充能次数"] = cn("紫气东来")
    g_auto_play_v["紫气充能时间"] = cntime("紫气东来", true)

    g_auto_play_v["紫气时间"] = bufftime("紫气东来")
    g_auto_play_v["目标叠刃层数"] = tbuffsn("叠刃", id())
    g_auto_play_v["目标叠刃时间"] = tbufftime("叠刃", id())
    g_auto_play_v["碎星辰buff时间"] = bufftime("碎星辰")    --会心5% 会效10% 无视防御60% 4秒
    g_auto_play_v["风逝时间"] = bufftime("风逝")        --14931 无我伤害提高30% 5秒
    g_auto_play_v["裂云时间"] = bufftime("裂云")        --17933 15%会效
    g_auto_play_v["玄门层数"] = buffsn("玄门")            --每层提高 破防20% 会心3%
    g_auto_play_v["玄门时间"] = bufftime("玄门")

    g_auto_play_v["碎星辰"] = npc("关系:自己", "名字:气场碎星辰", "距离<13")
    g_auto_play_v["吞日月"] = npc("关系:自己", "名字:气场吞日月", "距离<13")
    g_auto_play_v["化三清"] = npc("关系:自己", "名字:气场化三清", "距离<15")
    _, g_auto_play_v["气场数量"] = npc("关系:自己", "名字:气场生太极|气场碎星辰|气场吞日月", "距离<13")

    --没进战，挂坐忘
    if nofight() and nobuff("坐忘无我") then
        CastX("坐忘无我")
    end

    --没进战 目标位置3碎星辰
    g_auto_play_v["碎星辰时间"], g_auto_play_v["碎星辰数量"] = qctime(id(), 10, 4980)    --自己10尺内碎星辰, 最短时间, 数量
    if nofight() and rela("敌对") then
        if g_auto_play_v["碎星辰数量"] < 3 or g_auto_play_v["碎星辰时间"] < 12 then
            CastX("碎星辰")
        end
    end

    --副本防开怪
    if getopt("副本防开怪") and dungeon() and nofight() then
        return
    end

    --人剑 起手打玄门
    if rela("敌对") and dis() < 8 and g_auto_play_v["气场数量"] >= 3 and g_auto_play_v["玄门层数"] < 3 then
        if g_auto_play_v["化三清"] == 0 and g_auto_play_v["碎星辰CD"] <= g_auto_play_v["GCD间隔"] then
            CastX("人剑合一")
        end
    end

    --碎星辰
    g_auto_play_v["碎星辰气场距离"], g_auto_play_v["碎星辰气场时间"] = qc("气场碎星辰", id(), id())
    if rela("敌对") and g_auto_play_v["碎星辰气场距离"] > 0 then
        --没有碎星辰或在外面
        CastX("碎星辰")
    end

    --橙武
    if buff("1915") and tbuffsn("23170", id()) < 3 then
        CastX("八荒归元")
    end

    --无我
    if g_auto_play_v["风逝时间"] >= 0 and g_auto_play_v["气点"] > 9 then
        CastX("无我无剑")
    end

    --三环
    if g_auto_play_v["目标叠刃时间"] < 0 or g_auto_play_v["目标叠刃时间"] > 12 then
        --紫气
        if nobuff("紫气东来") and rela("敌对") and dis() < 6 and face() < 90 and g_auto_play_v["目标静止"] then
            if g_auto_play_v["八荒CD"] <= g_auto_play_v["GCD间隔"] * 2 and g_auto_play_v["碎星辰气场距离"] < -1 and g_auto_play_v["碎星辰气场时间"] > 10 and g_auto_play_v["人剑CD"] > 10 then
                if cdtime("三环套月") <= 0 then
                    if CastX("紫气东来") then
                        CastX("凭虚御风")
                    end
                end
            end
        end

        CastX("三环套月")
    end

    --人剑
    if rela("敌对") and dis() < 6 and g_auto_play_v["碎星辰"] ~= 0 and g_auto_play_v["吞日月"] ~= 0 and g_auto_play_v["化三清"] == 0 then
        if g_auto_play_v["碎星辰CD"] <= g_auto_play_v["GCD间隔"] then
            CastX("人剑合一")
        end
    end

    --无我
    if g_auto_play_v["风逝时间"] >= 0 and g_auto_play_v["气点"] >= 6 then
        CastX("无我无剑")
    end

    --八荒
    CastX("八荒归元")

    --吞日月
    if rela("敌对") and g_auto_play_v["吞日月"] == 0 and g_auto_play_v["紫气时间"] < 0 then
        CastX("吞日月")
    end

    --化三清
    g_auto_play_v["移动键被按下"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
    if fight() and mana() < 0.45 and g_auto_play_v["目标静止"] and dis() < 6 and not g_auto_play_v["移动键被按下"] then
        CastX("化三清", true)
    end

    --万剑
    if rela("敌对") and dis() < 8 then
        if g_auto_play_v["三环CD"] > 0.5 and g_auto_play_v["八荒CD"] > 0.5 and g_auto_play_v["人剑CD"] > 0.5 then
            CastX("万剑归宗")
        end
    end

    --没放技能记录信息
    if fight() and rela("敌对") and dis() < 4 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and state("站立|走路|跑步|跳跃") then
        if gettimer("碎星辰") > 0.3 and gettimer("吞日月") > 0.3 then
            PrintInfo("-- 没放技能")
        end
    end
end

--使用技能并记录信息
function CastX(szSkill, bSelf)
    if cast(szSkill, bSelf) then
        settimer(szSkill)
        if g_auto_play_v["记录信息"] then
            PrintInfo()
        end
        return true
    end
    return false
end

g_auto_play_v["战意"] = rage()

--主循环
g_auto_play["傲血战意"] = function()
    -- 按下自定义快捷键1交扶摇
    if keydown(1) and scdtime("扶摇直上") <= 0 then
        if cast("扶摇直上") then
            settimer("扶摇直上")
        end
        if buff("骑御") then
            cbuff("骑御")
        end
    end

    --减伤
    if fight() then
        cast("啸如虎")

        if life() < 0.55 then
            cast("守如山")
        end
    end

    --目标不是敌对, 结束
    if not rela("敌对") then
        return
    end
    if gettimer("冲刺") < 0.3 then
        return
    end

    if getopt("副本防开怪") and dungeon() and nofight() then
        return
    end

    --等待任驰骋释放
    if casting("任驰骋") and castleft() < 0.13 then
        settimer("任驰骋读条结束")
    end
    if gettimer("任驰骋读条结束") < 0.3 then
        return
    end


    --初始化变量
    --g_auto_play_v["目标流血时间"] = tbufftime("流血", id())
    --g_auto_play_v["龙驭层数"] = buffsn("龙驭")
    --g_auto_play_v["驰骋"] = bufftime("驰骋")
    --g_auto_play_v["牧云"] = bufftime("牧云")
    --g_auto_play_v["渊"] = bufftime("2778")
    --g_auto_play_v["在马上"] = buff("骑御")
    --g_auto_play_v["有队伍"] = g_player.IsInParty()

    --下马
    if buff("骑御") and nobuff("驰骋") and cn("任驰骋") > 0 and qixue("龙驭") then
        --if cdleft(16) >= 1 and g_auto_play_v["战意"] < 5 and scdtime("撼如雷") < 1.5 then
        if scdtime("撼如雷") < 1 then
            cbuff("骑御")
            settimer("冲刺")
            exit()
        end
    end

    if buff("骑御") and (cn("任驰骋") > 0 or (nobuff("牧云") and scdtime("突") <= 0) or scdtime("渊") <= 1.5) and not qixue("龙驭") then
        cbuff("骑御")
        settimer("冲刺")
        exit()
    end

    --渊
    g_auto_play_v["目标附近队友"] = tparty("没状态:重伤", "不是自己", "自己距离>6", "自己距离<20", "距离<25", "不是内功:洗髓经|铁牢律|明尊琉璃体|铁骨衣", "视线可达", "距离最近")
    if g_auto_play_v["目标附近队友"] ~= 0 and nobuff("骑御") and qixue("渊") and scdtime("渊") <= 0 then
        if xcast("渊", g_auto_play_v["目标附近队友"]) then
            settimer("冲刺")
            exit()
        end
        return
    end

    --突
    --if cdleft(16) > 0.5 or nobuff("牧云") then
    if cast("突") then
        settimer("冲刺")
        exit()
    end

    --撼如雷
    if rela("敌对") and dis() < 8 and cdleft(16) < 0.5 then
        if qixue("龙驭") then
            if bufftime("驰骋") > 9 then
                cast("撼如雷", true)
            end
        elseif bufftime("渊") > 6 then
            cast("撼如雷", true)
        elseif bufftime("驰骋") > 9 then
            cast("撼如雷", true)
        end
    end

    --断魂刺
    if g_auto_play_v["战意"] <= 2 or dis() > 8 then
        if cast("断魂刺") then
            settimer("冲刺")
            exit()
        end
    end

    ---------------------------------------------

    if getopt("乘龙箭打断") and tbuffstate("可打断") then
        cast("乘龙箭")
    end

    --任驰骋
    if qixue("龙驭") then
        if buff("牧云") then
            cast("任驰骋")
        end
    end

    if not qixue("龙驭") and nobuff("驰骋") then
        if buff("牧云") then
            cast("任驰骋")
        end
    end

    --保流血
    if tbufftime("流血", id()) < cdinterval(16) * 2 then
        if g_auto_play_v["战意"] <= 2 then
            cast("灭")
        end
        cast("龙吟")
        cast("灭")
    end

    --龙牙
    if g_auto_play_v["战意"] >= 5 then
        cast("龙牙")
    end

    --战八方
    _, g_auto_play_v["6尺内敌人数量"] = npc("关系:敌对", "距离<6", "可选中")
    if g_auto_play_v["6尺内敌人数量"] >= 3 then
        cast("战八方")
    end

    --灭
    if g_auto_play_v["战意"] <= 2 then
        cast("灭")
    end

    --龙吟
    if g_auto_play_v["战意"] <= 3 then
        cast("龙吟")
    end

    --穿云
    cast("穿云")
end

g_auto_play_v["记录信息"] = true

--主循环
g_auto_play["离经易道"] = function()
    --按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
    if keydown(1) then
        cast("扶摇直上")
    end

    if nofight and nobuff("清心静气") then
        cast("清心静气")
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

    g_base["浮香丘箱子"]("星楼月影")

    --if buff("雷霆争女")
    if bufftime("八卦洞玄") > 2 then
        if scdtime("太阴指") == 0 then
            cast("太阴指")
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
            cast("太阴指")
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
    if fight() and life() < 0.5 then
        cast("星楼月影")
    end

    if scdtime("厥阴指") == 0 then
        --打断
        if getopt("打断") and tbuffstate("可打断") then
            cast("厥阴指")
        end

        local rank = player("没状态:重伤", "关系:敌对", "读条:七星拱瑞|生太极|万世不竭|回雪飘摇|提针|长针|醉舞九天|迷仙引梦|冰蚕牵丝|天斗旋|兵主逆|鸿蒙天禁|杀星在尾|平沙落雁|青霄飞羽|变宫|变徵|笑傲光阴|云生结海|杯水留影|江逐月天|白芷含芳|青川濯莲|川乌射罔|且待时休|钟林毓秀|钟林毓秀|幻光步", "距离<20", "视线可达", "没载具", "气血最少")
        if rank ~= 0 then
            if xcastprog(rank) > 0.3 or xcastpass(rank) > 0.5 or xcastleft(rank) < 0.3 then
                xcast("厥阴指", v.id)
            end
            xcast("厥阴指", rank)
        end
    end


    --初始化变量
    g_auto_play_v["墨意"] = rage()
    g_auto_play_v["治疗量"] = charinfo("治疗量")    --如果想精确治疗，治疗量 * 技能系数 = 技能实际加血量
    g_auto_play_v["治疗目标"] = g_auto_play_f["获取治疗目标"]()
    g_auto_play_v["治疗目标血量"] = xlife(g_auto_play_v["治疗目标"])
    g_auto_play_v["治疗目标是T"] = xmount("洗髓经|铁牢律|明尊琉璃体|铁骨衣", g_auto_play_v["治疗目标"])

    ---------------------------------------------
    if fight() and g_auto_play_v["治疗目标血量"] < 0.6 then
        CastX("春泥护花")
    end
    --听风
    if fight() and g_auto_play_v["治疗目标血量"] < 0.35 and life() > 0.35 then
        CastX("听风吹雪")
    end

    if g_auto_play_v["治疗目标血量"] < 0.8 then
        if buff("412|722|932|3458|6266") then
            --有瞬发
            CastX("长针")
        end
    end

    --长针
    if g_auto_play_v["治疗目标血量"] < 0.45 then
        --水月
        if fight() and g_auto_play_v["墨意"] < 20 then
            cast("水月无间")
        end

        if buff("412|722|932|3458|6266") then
            --有瞬发
            CastX("长针")
        end
    end

    if g_auto_play_v["治疗目标血量"] < 0.3 then
        --加血
        CastX("大针")
    end
    --彼针

    --提针
    if g_auto_play_v["治疗目标血量"] < 0.9 then
        --加血
        CastX("提针")
    end

    if g_auto_play_v["墨意"] < 30 then
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
    if nofight() and gettimer("锋针读条结束") > 0.5 then
        xcast("锋针", party("有状态:重伤", "距离<20", "视线可达"))
    end
end

-------------------------------------------------------------------------------

g_auto_play_f["获取治疗目标"] = function()
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

g_auto_play_v["输出信息"] = true
g_auto_play_v["没石次数"] = 0

--函数表
local f = {}

local counter = {
    killed = 16,
    max = 16;

    increment = function(self)
        self.killed = self.killed + 1
    end,

    start = function(self)
        self.killed = 0
    end,

    stop = function(self)
        self.killed = self.max
    end,

    running = function(self)
        self.killed = self.killed + 1
        return self.killed <= self.max
    end
}

--主循环
g_auto_play["山海心诀"] = function()
    --cast("风失")
    cast(35894)
    if casting("饮羽簇") and castleft() < 0.13 then
        settimer("饮羽簇读条结束")
    end
    if gettimer("饮羽簇读条结束") < 0.3 then
        return
    end

    --应天授命
    if fight() and life() < 0.20 then
        cast("应天授命")
    end

    --初始化变量
    g_auto_play_v["弓箭"] = rage()
    g_auto_play_v["幻灵印"] = beast()

    g_auto_play_v["饮羽CD"] = scdtime("饮羽簇")
    g_auto_play_v["白羽CD"] = scdtime("白羽流星")
    g_auto_play_v["金乌充能次数"] = cn("金乌见坠")
    g_auto_play_v["金乌充能时间"] = cntime("金乌见坠", true)
    g_auto_play_v["引风CD"] = scdtime("引风唤灵")
    g_auto_play_v["弛律CD"] = scdtime("弛律召野")
    g_auto_play_v["朝仪CD"] = scdtime("朝仪万汇")

    g_auto_play_v["承契层数"] = buffsn("承契")
    g_auto_play_v["承契时间"] = bufftime("承契")
    g_auto_play_v["贯穿层数"] = tbuffsn("贯穿", id())
    g_auto_play_v["贯穿时间"] = tbufftime("贯穿", id())
    g_auto_play_v["标鹄层数"] = tbuffsn("标鹄")
    g_auto_play_v["标鹄时间"] = tbufftime("标鹄", id())
    g_auto_play_v["目标血量较多"] = rela("敌对") and tlifevalue() > lifemax() * 10

    --寒更晓箭
    if g_auto_play_v["弓箭"] < 8 then
        if nofight() then
            --没进战把箭装满
            CastX("寒更晓箭")
        end

        if g_auto_play_v["弓箭"] < 1 then
            --没箭了装箭, 自动装箭会比GCD晚1帧, 自己装, 抢不过也没影响, 抢过了还能快1帧
            CastX("寒更晓箭")
        end
    end

    if g_auto_play_v["弓箭"] >= 5 then
        g_auto_play_v["最后一支箭状态"] = arrow(0)
        if g_auto_play_v["最后一支箭状态"] ~= 3 and g_auto_play_v["最后一支箭状态"] ~= 4 then
            if g_auto_play_v["幻灵印"] ~= 1 then
                --最后一支箭没金乌
                CastX("空弦惊雁")
            end
        end
    end

    --金乌见坠
    if g_auto_play_v["弓箭"] >= 8 then
        --满箭才用
        if rela("敌对") and dis() < 30 then
            g_auto_play_v["最后一支箭状态"] = arrow(0)
            if g_auto_play_v["最后一支箭状态"] ~= 2 and g_auto_play_v["最后一支箭状态"] ~= 4 then
                --最后一支箭没金乌
                if g_auto_play_v["幻灵印"] ~= 1 or g_auto_play_v["金乌充能次数"] >= 2 then
                    CastX("金乌见坠")
                end

                if not qixue("拖月") then
                    CastX("金乌见坠")
                end
            end

            if g_auto_play_v["金乌充能次数"] >= 3 and bufftime("佩弦") < 0 and g_auto_play_v["饮羽CD"] < 1 then
                --充能满了没瞬发
                CastX("金乌见坠")
            end
        end
    end

    if nofight() or notarget() and tlife() <= 0 or tbuff("斩无常") then
        return
    end

    if qixue("朱厌") or qixue("祝灵") and fight() then
        if qixue("兴游") and g_auto_play_v["幻灵印"] >= 3 then
            if g_auto_play_v["弓箭"] < 8 then
                CastX("寒更晓箭")
            end
            CastX("汇灵合契")
        end
        if g_auto_play_v["幻灵印"] >= 4 then
            if g_auto_play_v["弓箭"] < 8 then
                CastX("寒更晓箭")
            end
            CastX("汇灵合契")
        end

        if buff("合神") then
            if g_auto_play_v["弓箭"] < 8 then
                --cast("白羽流星")
                cast(35974)
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

            if CastX(35688) then

            end
            return
        end

        if not qixue("兴游") then
            if g_auto_play_v["幻灵印"] == 1 then
                --cast("弛律召野")
                CastX(35696)
            end
        else
            if g_auto_play_v["幻灵印"] == 0 then
                CastX(35696)
            end
        end
    end

    --引风唤灵, 和目标的角色距离大于20尺是在自己附近放
    if fight() and rela("敌对") and dis3() < 20 then
        CastX("引风唤灵")
    end

    if qixue("星烨") and fight() then
        if g_auto_play_v["幻灵印"] == 0 then
            if not nextbeast("野猪") and not beast("野猪") then
                --只召鹰
                setbeast({ "野猪", "虎", "熊", "鹰", "狼", "大象" })
            end

            if scdtime("引风唤灵") < 5 then
                CastX("弛律召野")
            end
        end

        if g_auto_play_v["幻灵印"] == 1 then
            if not nextbeast("虎") and not beast("虎") then
                --只召鹰
                setbeast({ "虎", "野猪", "鹰", "熊", "狼", "大象" })
            end

            if g_auto_play_v["幻灵印"] == 1 and scdtime("引风唤灵") > 2 then
                CastX("弛律召野")
            end
        end

        if g_auto_play_v["幻灵印"] >= 2 and dis() > 0 and dis() < 30 and bufftime("澄神") < 3 then
            CastX("游雾乘云")
        end
    end

    if buff("游雾乘云") then
        CastX("弛风鸣角")
        CastX("劲风簇")
        return
    end

    if g_auto_play_v["弓箭"] >= 3 then

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

        if g_auto_play_v["弓箭"] == 8 then
            CastX("劲风簇")
        end
    end
    if g_auto_play_v["弓箭"] == 4 or g_auto_play_v["弓箭"] == 8 then
        CastX("饮羽簇")
    end
    CastX("劲风簇")

end


function PrintInfo(s)

end