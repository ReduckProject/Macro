local current_time = time()
local deadline_utc = time(2024, 5, 28, 0, 0, 0)
--if current_time >= deadline_utc then
--bigtext(
--    "测试时间结束",10,2)
--    return
--end
--[[ 奇穴: [刀魂][绝返][分野][血魄][锋鸣][割裂][业火麟光][恋战][援戈][惊涌][蔑视][阵云结晦]
秘籍:
盾刀  1会心 2伤害 1回怒(必须)
盾压  2会心 2伤害
劫刀  1会心 2伤害 1消耗
斩刀  1会心 3伤害
绝刀  1会心 1伤害 1调息减2秒(必须) 1减怒气(必须)
盾飞  2伤害 2持续(必须)
血怒  1回怒 3持续 (可以尝试 3回怒 1持续 提高绝刀伤害, 如果血怒不断的话, 自己看情况)

--循环
盾击 血怒 业火 盾击 盾击 盾飞 -> 斩刀 绝刀 绝刀 斩刀 绝刀 绝刀 血怒 斩刀 绝刀 绝刀 盾回
盾压 盾猛 盾刀 盾刀 盾飞 -> 阵云 斩刀 月照 绝刀 闪刀 雁门 绝刀 盾回
盾击 盾击 盾击 盾飞 -> 斩刀 绝刀 绝刀 血怒 斩刀 绝刀 绝刀 盾回
盾压 盾猛 盾刀 盾刀 盾飞 -> 阵云 斩刀 月照 绝刀 闪刀 雁门 绝刀 盾回
如果业火CD没对齐，3盾击前面会插入一个盾压
--]]

--关闭自动面向
setglobal("自动面向", false)

--宏选项
addopt("副本防开怪", false)

--变量表
local v = {}
v["记录信息"] = true
v["怒气"] = rage()
v["放血怒"] = false		--刀姿态是否放血怒重置CD标志
v["放阵云"] = false		--刀姿态是否放阵云标志

--函数表
local f = {}

--主循环
function Main()
	--按下自定义快捷键1挂扶摇, 注意是快捷键设定里面插件的快捷键1指定的按键，不是键盘上的1
	if keydown(1) then
		cast("扶摇直上")
	end

	--减伤
	if fight() and life() < 0.6 then
		cast("盾壁")
	end

	--初始化变量
	v["GCD16间隔"] = cdinterval(16)
	v["GCD804间隔"] = cdinterval(804)
	v["GCD"] = math.max(cdleft(16), cdleft(804))
	v["盾猛CD"] = cdleft(803)	--public 16 804
	v["盾击充能次数"] = cn("盾击")	--public 804 check 16, 盾刀和这个一样
	v["盾击充能时间"] = cntime("盾击", true)
	v["盾压CD"] = cdleft(802)	--public 16 804
	v["斩刀CD"] = cdleft(801)	--劫斩绝闪 阵云三段 public 16 804
	v["绝刀CD"] = cdleft(800)
	v["闪刀CD"] = cdleft(806)
	v["盾飞充能次数"] = cn("盾飞")
	v["盾飞充能时间"] = cntime("盾飞", true)
	v["血怒充能次数"] = cn("血怒")
	v["血怒充能时间"] = cntime("血怒", true)
	v["业火CD"] = cdleft(2607)		--public 16

	v["盾飞时间"] = bufftime("盾飞")
	v["血怒时间"] = bufftime("血怒·惊涌")	--27161
	--v["目标割裂时间"] = tbufftime("割裂", id())	--21308
	v["目标业火时间"] = tbufftime("业火焚城", id())	--25948
	v["麟光时间"] = bufftime("麟光玄甲")	--25941
	--26212 麟黯, 麟光重置过标记
	v["援戈层数"] = buffsn("援戈")		--27030 12秒, 释放盾击破招 27029(2秒)小于2层加1层 2层后删除 加6层27030
	v["援戈时间"] = bufftime("援戈")
	v["惊涌层数"] = buffsn("27482")		--有血怒没27484 打闪刀加2层27482, 劫斩绝闪删1层
	v["惊涌时间"] = bufftime("27482")
	v["没打过闪刀"] = nobuff("27484")	--27484 惊涌打过闪刀标记
	v["长驱层数"] = buffsn("长驱万里")		--27444, 最大45层
	v["长驱时间"] = bufftime("长驱万里")

	--目标不是敌人 直接结束
	if not rela("敌对") then return end

	--副本防开怪
	if getopt("副本防开怪") and dungeon() and nofight() then return end

	---------------------------------------------

	if pose("擎盾") then
		f["擎盾"]()
	end
	if pose("擎刀") then
		f["擎刀"]()
	end

	--没放技能记录信息
	if fight() and rela("敌对") and dis() < 4 and visible() and state("站立|走路|跑步|跳跃") and face() < 90 and cdleft(16) <= 0 and cdleft(804) <= 0 and gettimer("盾飞") > 0.5 and gettimer("盾回") > 0.5 then
		PrintInfo("---------- 没放技能")
	end
end

-------------------------------------------------------------------------------

f["擎盾"] = function()
	if gettimer("盾飞") < 0.5 then return end	--盾飞5帧之后才切姿态

	if v["长驱层数"] < 16 and f["盾击充能完成"]() then
		v["打3盾击"] = true
	end

	--打几轮之后业火CD赶不齐, 补个盾压
	if v["打3盾击"] and v["业火CD"] > v["GCD804间隔"] * 2 and v["业火CD"] <= v["GCD804间隔"] * 2 + v["GCD16间隔"] then
		CastX("盾压")
	end

	--盾击 援戈连击
	if buff("27029") then
		if nobuff("援戈") and v["盾击充能时间"] < 30.5 then
			f["盾击"]()
			return		--连击中只打盾击
		end
	end
		
	--盾击 进入连击
	if v["打3盾击"] then
		if v["斩刀CD"] <= v["GCD804间隔"] * 3 or (cdtime("血怒") <= 0 and cdtime("业火麟光") <= 0) then
			f["盾击"]()
		end
	end

	--盾飞
	v["放盾飞"] = false
	local nCD = v["GCD"] + 0.5	--怒气够了CD差一点，切刀等

	--业火, 50点 后面 斩刀 绝刀
	if v["目标业火时间"] > 0 then	
		if v["怒气"] >= 50 and v["斩刀CD"] <= nCD and v["绝刀CD"] <= nCD + v["GCD16间隔"] then
			v["放盾飞"] = true
		end
	
	--援戈, 25点 后面 斩刀 绝刀
	elseif v["援戈层数"] >= 6 then
		if v["怒气"] >= 25 and v["斩刀CD"] <= nCD and v["绝刀CD"] <= nCD + v["GCD16间隔"] then
			v["放盾飞"] = true
		end

	--阵云, 40点 后面 阵云 斩刀 月照 绝刀
	elseif v["长驱层数"] >= 16 then
		if v["怒气"] >= 30 and v["斩刀CD"] <= nCD + v["GCD16间隔"] and v["绝刀CD"] <= nCD + v["GCD16间隔"] * 3 then
			v["放盾飞"] = true
		end
	
	--其他非正常情况, 25点 后面 斩刀 绝刀
	else
		if v["怒气"] >= 25 and v["斩刀CD"] <= nCD and v["绝刀CD"] <= nCD + v["GCD16间隔"] then
			v["放盾飞"] = true
		end
	end

	if v["放盾飞"] and gettimer("盾击") >= 0.5 then
		if nobuff("27029") or buff("援戈") then
			if CastX("盾飞") then
				exit()
			end
		end
	end

	--差5点补盾刀
	if v["长驱层数"] >= 16 and v["怒气"] >= 35 then
		CastX("盾刀")
	end
	if v["目标业火时间"] > 0 and v["怒气"] >= 45 then
		CastX("盾刀")
	end

	--盾压
	CastX("盾压")

	--盾猛
	if not v["打3盾击"] or dis() > 10 then
		CastX("盾猛")
	end

	--盾刀
	CastX("盾刀")
end

f["擎刀"] = function()
	if gettimer("盾回") < 0.3 then return end

	--等刀魂
	if nobuff("8627") then return end
	
	--血怒, 8452 狂绝后清绝刀CD, 8474 橙武buff 4帧 * 25跳 不耗怒气 每跳清盾压绝刀CD 先不处理
	if v["斩刀CD"] > 1 and v["绝刀CD"] > 1 and cdleft(16) < 1 and v["盾飞时间"] > v["GCD16间隔"] * 2 + cdleft(16) + 1 and nobuff("狂绝|8452") then
		if v["放血怒"] then
			CastX("血怒")
		end
	end

	--阵云结晦
	if v["放阵云"] and v["盾飞时间"] > 11 then
		if rela("敌对") and dis() < 6 and face() < 90 then		--6*6 矩形, 用矩形判断模型大的怪有问题
			CastX("阵云结晦")
		end
		return	--斩刀比阵云距离远, 先卡住
	end



	--月照连营
	if buff("22976") then
		if dis() < 8 and face() < 90 then
			CastX("月照连营")
		end
	end
	--斩刀
	if v["怒气"] >= 25 and v["绝刀CD"] <= v["GCD16间隔"] + 0.1 and nobuff("狂绝|8453") then
		CastX("斩刀")
	end

       --雁门迢递
	if buff("22977") then
		if dis() < 15 then		--雁门20尺 闪刀15尺, 限制下距离防止因为距离原因先打雁门
			CastX("雁门迢递")
		end
	end

	--绝刀 第一刀
	if buff("狂绝") then
		CastX("绝刀")
	end

	--绝刀 第二刀
	if buff("狂绝|8453") then
		CastX("绝刀")
	end
	
	--盾回
	if v["怒气"] < 20 and v["GCD"] < 0.25 and gettimer("血怒") > 0.5 and gettimer("释放血怒") > 1 then
		CastX("盾回")
	end
end

f["盾击"] = function()
	if CastX("盾击") then
		if cdtime("业火麟光") <= 0 then
			CastX("血怒")
		end
		CastX("业火麟光")
	end
end

f["盾击充能完成"] = function()
	if cntime("盾击", true) < 10 + cdinterval(804) * 2 + math.max(cdleft(16), cdleft(804)) then		--盾击充能时间能连放3次
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--记录信息
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "怒气:"..v["怒气"]
	t[#t+1] = "距离:"..format("%.1f", dis())

	--盾
	t[#t+1] = "盾击CD:"..v["盾击充能次数"]..", "..v["盾击充能时间"]
	t[#t+1] = "业火CD:"..v["业火CD"]
	t[#t+1] = "盾压CD:"..v["盾压CD"]
	t[#t+1] = "盾猛CD:"..v["盾猛CD"]
	t[#t+1] = "业火:"..v["目标业火时间"]
	t[#t+1] = "援戈:"..v["援戈层数"]..", "..v["援戈时间"]

	--刀
	t[#t+1] = "斩刀CD:"..v["斩刀CD"]
	t[#t+1] = "绝刀CD:"..v["绝刀CD"]
	t[#t+1] = "闪刀CD:"..v["闪刀CD"]
	t[#t+1] = "麟光:"..v["麟光时间"]
	t[#t+1] = "惊涌:"..v["惊涌层数"]..", "..v["惊涌时间"]
	t[#t+1] = "长驱:"..v["长驱层数"]..", "..v["长驱时间"]
	
	t[#t+1] = "血怒:"..v["血怒时间"]
	t[#t+1] = "血怒CD:"..v["血怒充能次数"]..", "..v["血怒充能时间"]
	t[#t+1] = "盾飞:"..v["盾飞时间"]
	t[#t+1] = "盾飞CD:"..v["盾飞充能次数"]..", "..v["盾飞充能时间"]
	
	--t[#t+1] = "狂绝:"..bufftime("狂绝")		--8451
	print(table.concat(t, ", "))
end

--使用技能并记录信息
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["记录信息"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--技能释放回调表
local tFunc = {}

tFunc[13044] = function()	--盾刀
	v["怒气"] = v["怒气"] + 5
end

tFunc[13059] = function()	--盾刀二段
	v["怒气"] = v["怒气"] + 5
end

tFunc[13060] = function()	--盾刀三段
	v["怒气"] = v["怒气"] + 10
end

tFunc[13046] = function()	--盾猛
	v["怒气"] = v["怒气"] + 15
end

tFunc[13047] = function()	--盾击
	v["怒气"] = v["怒气"] + 10
	v["打3盾击"] = false	--打过1次取消3盾击标志
end

tFunc[13045] = function()	--盾压
	v["怒气"] = v["怒气"] + 15
end

tFunc[13040] = function()	--血怒
	v["放血怒"] = false		--放过取消标志
	settimer("释放血怒")
end

tFunc[30769] = function()	--阵云
	v["放阵云"] = false		--放过取消标志
end

--释放技能
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		local func = tFunc[SkillID]
		if func then
			func()
		end
	end
end

local tBuff = {
[8627] = "刀魂",	--监控buff 8393 间隔4帧
--[25939] = "业火自身标记",	--源ID是目标
--[8451] = "狂绝",
--[8452] = "重置绝刀CD",
--[8453] = "绝刀走CD",
}

--buff更新
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		local szName = tBuff[BuffID]
		if szName then
			if StackNum  > 0 then
				if BuffID == 27029 then
					deltimer("盾击")
				end

				if BuffID ~= 8627 or nobuff("8627") then
					print("OnBuff->添加buff: ".. szName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount..", 结束帧: "..EndFrame..", 剩余时间: "..(EndFrame-FrameCount)/16)
				end
			else
				print("OnBuff->移除buff: ".. szName..", ID: "..BuffID..", 等级: "..BuffLevel..", 层数: "..StackNum..", 源ID: "..SkillSrcID..", 开始帧: "..StartFrame..", 当前帧: "..FrameCount)
			end
		end

		if BuffID == 8391 then	--盾飞
			if StackNum  > 0 then
				--进入刀姿态
				if v["援戈层数"] >= 6 then	--有援戈，血怒重置CD
					v["放血怒"] = true
				else
					v["放血怒"] = false
				end

				if v["长驱层数"] >= 16 then	--设置阵云标志
					v["放阵云"] = true
				end

				print("------------------------------ 刀姿态", frame())		--分隔线
			else
				--取消绝刀走CD
				if cbuff("8453") then
					print("---------- 取消绝刀走CD")
				end
				print("------------------------------ 盾姿态", frame())		--分隔线
			end
		end
	end
end

--状态更新
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	v["怒气"] = nCurrentRage
end

--记录战斗状态改变
function OnFight(bFight)
	if bFight then
		print("--------------------进入战斗")
	else
		print("--------------------离开战斗")
	end
end
