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
--load("Macro/Lib_PVP.lua")
--load("Macro/Lib_Base.lua")
--变量表
local v = {}
local f = {}

local id = 0
--主循环
function Main(g_player)
	local time = gettimer("采集")
	if time < 6 then
		interact(id)
		return
	end

	local x,y,z = xpos(id);
	if(x > 0) then
		moveto(x, y , z)
		interact(id)
		local d =  xdis(id)
		if d >= 0 and d < 4 then
			--settimer("采集")
		end
		return
	end

	id = doodad("名字:止血草|河底的沙石|浩气盟的物资|鱼篓|晶矿|虫草|千里香|铅锌矿|马草|干柴|雪莲|芍药|五味子|皇竹草|珊瑚", "距离<40", "距离最近")
end

