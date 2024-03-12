output("奇穴: [雾锁][吐故纳新][抱一][抱元][玄德][跬步][万物][无我][霜寒][心眼][重光][规焉]")

--载入库
load("Macro/Lib_PVP.lua")
load("Macro/Lib_Base.lua")

--变量表
local v = {}

--函数表
local f = {}

--主循环
function Main(g_player)
	g_base["气纯抓点"]()
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
