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

--宏选项
addopt("打断", false)

--变量表
local v = {}
v["记录信息"] = true

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶摇直上")
	end
	if bufftime("八卦洞玄") > 2 then
		if  scdtime("太阴指") == 0 then
			cast("太阴指")
		end
	end
	if buff("断魂刺") then
		local srcid = buffsrc("断魂刺")
		local cid = tid()
		settar(srcid)

		if srcid ~= 0 and tbufftime("驰骋", srcid) > 0 and xdis(srcid) < 8 then
			xcast("归园", srcid)
		end
		settar(cid)
	end
	if buff("倒地") then
		local srcid = buffsrc("倒地")
		local cid = tid()
		settar(srcid)

		if srcid ~= 0 and tbufftime("驰骋", srcid) > 0 and xdis(srcid) < 8 then
			xcast("归园", srcid)
		end
		settar(cid)
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

		local rank =  player("没状态:重伤", "关系:敌对", "读条:七星拱瑞|生太极|万世不竭|回雪飘摇|提针|长针|醉舞|冰蚕牵丝|天斗旋|平沙落雁|青霄飞羽|笑傲光阴|云生结海|杯水留影|江逐月天|鸿蒙天禁|白芷含芳|青川濯莲|川乌射罔|且待时休|钟林毓秀|钟林毓秀|幻光步", "距离<20", "视线可达", "没载具", "气血最少")
		if rank ~= 0 then
			xcast("厥阴指", rank)
		end
	end


	--初始化变量
	v["墨意"] = rage()
	v["治疗量"] = charinfo("治疗量")    --如果想精确治疗，治疗量 * 技能系数 = 技能实际加血量
	v["治疗目标"] = f["获取治疗目标"]()
	v["治疗目标血量"] = xlife(v["治疗目标"])
	v["治疗目标是T"] = xmount("洗髓经|铁牢律|明尊琉璃体|铁骨衣", v["治疗目标"])

	---------------------------------------------
	if fight() and v["治疗目标血量"] < 0.4 then
		CastX("春泥护花")
	end
	--听风
	if fight() and v["治疗目标血量"] < 0.4 and life() > 0.6 then
		CastX("听风吹雪")
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
	if nofight() and gettimer("锋针读条结束") > 0.5 then
		xcast("锋针", party("有状态:重伤", "距离<20", "视线可达"))
	end
end

-------------------------------------------------------------------------------

f["获取治疗目标"] = function()
	local targetID = id()    --治疗目标先设置为自己, 不在队伍或者团队中时 party 返回 0
	local partyID = party("没状态:重伤", "不是自己", "距离<20", "视线可达", "没载具", "气血最少")    --获取血量最少队友

	if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then
		--有血量最少队友且比自己血量少
		targetID = partyID    --把他指定为治疗目标
	else
		if life() > 0.95 then
			if tid() > 0 and tlife() < 0.95 then
				targetID = tid()
			else
				targetID = player("没状态:重伤", "同阵营", "不是自己", "距离<20", "视线可达", "没载具", "气血最少")
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
	if xcast(szSkill, v["治疗目标"]) then
		if v["记录信息"] then
			PrintInfo()
		end
		return true
	end
	return false
end
