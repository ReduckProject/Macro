output("点大太极")
--变量表
local v = {}

--函数表
local f = {}

--主循环
function Main(g_player)
	local nid = f["切换目标"]()
	if nid ~= 0 and nid ~= nil and notarget() then
		settar(nid)
	end

	if notarget() then
		return
	end
	turn()
	cast("项王击鼎")
end

f["切换目标"] = function()
	v["20尺内敌人"] = npc("距离<6", "视线可达", "关系:敌对")
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
