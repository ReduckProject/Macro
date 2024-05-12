--[[ 奇穴: [扬戈][神勇][大漠][击水 or 龙驭][驰骋][牧云][风虎][战心][渊][夜征][龙血][虎贲]
秘籍:
穿云  1调息 1会心 2伤害
龙吟  1调息 3伤害
龙牙  1会心 3伤害
突    1消耗 1距离 2伤害
灭    1调息 1会心 2伤害
战八方 1目标个数 1范围 2伤害
断魂刺 2调息 2伤害

如果点了[龙驭], 上马之后龙驭不到3层就动起来, 到3层站桩打
--]]
load("Macro/Lib_PVP.lua")
load("Macro/Lib_Base.lua")
--变量表
local v = {}
local f = {}

local counter = 1
--主循环
function Main(g_player)
	if counter == 10 then
		if not interact(npc("名字:包子铺老板")) then
			counter = 0
			return
		end
	end

	if counter == 20 then
		if not dialog("可以") then
			counter = 0
			return
		end
	end

	if counter == 30 then
		if not dialog("功夫熊猫  ★★★★") then
			counter = 0
			return
		end
	end

	counter = counter + 1

	if counter > 1100 then
		counter = 0
	end

	local nid = npc("模板ID:126758", "距离<30", "角度<30", "距离最近")
	if nid > 0 then
		moveto(xpos(nid))
	end

	cast(37436)

end
