--变量表
g_var = {}

--常用常量
g_var["快速位移状态"] = "被击退|冲刺|被抓"
g_var["治疗心法"] = "离经易道|云裳心经|补天诀|相知|灵素"
g_var["近战心法"] = "洗髓经|易筋经|傲血战意|铁牢律|太虚剑意|问水诀|山居剑意|焚影圣诀|明尊琉璃体|笑尘诀|铁骨衣|分山劲|北傲诀|凌海诀|隐龙诀|孤锋诀"
g_var["远程心法"] = "花间游|紫霞功|冰心诀|毒经|惊羽诀|天罗诡道|莫问|太玄经|无方|山海心诀"

--函数表
g_func = {}

--[[全局变量说明, 和字面意思可能有点差距
目标可控制, 为假时指的是目标不受任何负面效果影响, 或者这时候对目标使用负面效果技能有害无益
目标可攻击, 为假时指的是目标不吃伤害或者减伤非常高, 目标受负面效果影响，只是伤害部分被减免, 大部分门派控制技能伤害不高, 长CD高伤害的技能可以判断一下
--]]


g_func["初始化"] = function()
	g_var["目标减伤效果"] = g_func["目标减伤效果"]()
	g_var["目标闪避效果"] = tbuffstate("闪避效果")
	g_var["目标减命中效果"] = tbuffstate("减命中效果")

	g_var["目标可控制"] = g_func["目标可控制"]()
	g_var["目标可攻击"] = g_var["目标可控制"] and g_func["目标可攻击"]()
	g_var["目标没减伤"] = g_var["目标可攻击"] and g_func["目标没减伤"]()
	
	--单次免伤, 御和点了奇穴乘龙戏水
	g_var["目标单次免伤"] = 0
	local nLeftTime, nStackNum = tbuffstate("单次免伤")
	if nLeftTime > -0.25 then
		g_var["目标单次免伤"] = nStackNum
	end

	g_var["目标一刀"] = g_var["目标没减伤"] and g_var["目标单次免伤"] <= 0 and g_func["目标一刀"]()
	g_var["突进"] = g_var["目标可攻击"] and g_func["突进"]()

	_, g_var["附近敌人数量"] = enemy("距离<40")
end

--不打任何负面技能
g_func["目标可控制"] = function()
	--目标不是敌对
	if not rela("敌对") then return false end

	--目标无敌
	if tbuffstate("无敌时间") > -1 then
		bigtext("目标无敌", 0.5)
		return false
	end

	--苍云 盾立
	if tbufftime("盾立") > -1 or tlasttime("盾立") <= 2 then
		bigtext("目标盾立", 0.5)
		return false
	end

	--苍云 扬旌沙场
	if buffsrc("扬旌沙场") ~= tbuffsrc("扬旌沙场") then
		bigtext("目标不是扬旌沙场目标", 0.5)
		return false
	end

	--长歌 啸影
	if bufftime("啸影") > -1 then
		bigtext("被啸影", 0.5)
		return false
	end

	--指定名字的NPC不打
	if target("npc") and tname("圣蝎|风蜈|天蛛|灵蛇|玉蟾|碧蝶|苍棘缚地") then
		bigtext("不打指定npc", 0.5)
		return false
	end

	--目标减命中
	if g_var["目标减命中效果"] > 95 then
		bigtext("目标减命中过高: "..g_var["目标减命中效果"], 0.5)
		return false
	end

	return true
end

--计算目标减伤效果
g_func["目标减伤效果"] = function()
	local effect = 0
	local m = mounttype()
	if m == "外功" then
		effect = tbuffstate("减外伤效果")
	else
		effect = tbuffstate("减内伤效果")
	end

	if tschool("五毒") then
		effect = 100 - (100 - effect)  * (100 - tbuffstate("伤害转移效果")) / 100  --减伤之后再去掉转移部分，是剩下的实际伤害，貌似是这样
	end

	return effect
end

--不打伤害技能
g_func["目标可攻击"] = function()
	--衍天 巨门北落
	g_var["目标巨门北落"] = false
	if tbufftime("巨门北落") > -1 or tlasttime("巨门北落") <= 4 then
		g_var["目标巨门北落"] = true
		bigtext("目标巨门北落", 0.5)
		return false
	end

	--和尚反弹
	g_var["目标高反伤"] = false
	if tbuffstate("反伤效果") > 45 and tbuffstate("反伤效果") / 100 * tlifevalue() > lifevalue() - lifemax() * 0.1 then
		g_var["目标高反伤"] = true
		bigtext("目标高反伤", 0.5)
		return false
	end

	--免减伤
	local m = mounttype()
	
	if m == "内功" then
		if tbuffstate("免内伤时间") > -1 then
			bigtext("目标免内伤", 0.5)
			return false
		end
	elseif m == "外功" then
		if tbuffstate("免外伤时间") > -1 then
			bigtext("目标免外伤", 0.5)
			return false
		end
		if g_var["目标闪避效果"] > 95 then
			bigtext("目标闪避过高: ".. g_var["目标闪避效果"], 0.5)
			return false
		end
	elseif m == "天罗" then
		if tbuffstate("免内伤时间") > -1 then
			bigtext("目标免内伤", 0.5)
			return false
		end
		if g_var["目标闪避效果"] > 95 then
			bigtext("目标闪避过高: ".. g_var["目标闪避效果"], 0.5)
			return false
		end
	else
		bigtext("获取内功类型失败")
	end

	if g_var["目标减伤效果"] > 95 then
		bigtext("目标减伤过高: ".. g_var["目标减伤效果"], 0.5)
		return false
	end

	--[[9506 清绝影歌
	if tbuff("9506") then
		return false
	end
	--]]

	return true
end

g_func["目标没减伤"] = function()
	--减伤
	if g_var["目标减伤效果"] > 39 then
		return false
	end

	--减命中
	if tbuffstate("减命中效果") > 39 then
		return false
	end

	--外功和天罗判断闪避
	local m = mounttype()
	if m == "外功" or m == "天罗" then
		if g_var["目标闪避效果"] > 39 then
			return false
		end
	end

	--伤害转移
	if tbuff("玄水蛊|疾电叱羽") then
		return false
	end

	--千枝绽蕊 不好计算单独判断

	return true
end

--低血量没不死
g_func["目标一刀"] = function()
	--天策
	--if tbufftime("啸如虎") > -1 then return false end
	if tbuffstate("不死时间") > -1 then return false end

	--万花
	if tbufftime("笼花") > -1 then return false end

	--七秀 冥泽
	if tqixue("冥泽") and tnobuff("冥泽") then return false end

	--藏剑 片玉
	if tqixue("片玉") and tnobuff("碎玉") then return false end

	--五毒 蝉蜕
	if tqixue("蝉蜕") and tnobuff("严寒") then return false end


	--长歌 清绝影歌不死
	if tbuff("12875") then return false end

	--血量+伤害吸收盾 小于20%
	return tlife() + tdas() < 0.2
end

g_func["突进"] = function()
	--读条技能
	if tenemy("读条:风来吴山", "平面距离<10") ~= 0 then return false end
	if buffsn("逆乱") >= 4 and tenemy("读条:且待时休", "平面距离<15") ~= 0 then return false end
	

	--藏剑 风来吴山
	if tnpc("关系:敌对", "平面距离<10", "模板ID:57739") ~= 0 then return false end

	--纯阳 六合独尊
	if tnpc("关系:敌对", "平面距离<6", "模板ID:58295") ~= 0 then return false end

	--长歌 江逐月天
	if tnpc("关系:敌对", "平面距离<10", "模板ID:44764") ~= 0 then return false end

	--蓬莱 澹然若海
	if tnpc("关系:敌对", "平面距离<6", "模板ID:63709") ~= 0 then return false end

	--药宗 绿野蔓生
	if tbuff("绿野蔓生") then return false end
	
	--目标附近敌人大于5个，不突进
	local _, count = tenemy("平面距离<10")
	if count > 5 then return false end


	return true
end

g_func["采集"]= function()

	interact(doodad("名字:物资|止血草|河底的沙石|冰魂|浩气盟的物资|鱼篓|晶矿|马草|干柴|雪莲|铁血·犒赏", "距离<6", "距离最近"))

	if self().GetItemAmountInPackage(5, 4549) < 6 then
		interact(doodad("名字:曼陀罗", "距离<6", "距离最近"))
	end

	if self().GetItemAmountInPackage(5, 4550) < 6 then
		interact(doodad("名字:黄杜鹃", "距离<6", "距离最近"))
	end
end

g_func["处理刀宗缴械"] = function()
	if bufftime("洗兵雨") > 1 then
		local doodadID = doodad("模板ID:9810", "表现ID:49040")
		if doodadID ~= 0 then
			local x, y, z = xpos(doodadID)
			if x > 0 then
				local dist = pdis2(x, y)
				if dist > 2 then
					if acast("凌霄揽胜", -90, { nX = x, nY = y }) then
						bigtext("处理刀宗缴械", 1)
						exit()
					end
					if acast("瑶台枕鹤", 90, { nX = x, nY = y }) then
						bigtext("处理刀宗缴械", 1)
						exit()
					end
				end
				stopmove()
				moveto(x, y, z)
				exit()
			end
		end
	end
end
