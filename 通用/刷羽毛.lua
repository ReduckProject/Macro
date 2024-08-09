output("点大太极")
--变量表
local v = {}

--函数表
local f = {}


v["太虚剑意"] = function()
	cast("生太极", true)
	cast("坐忘无我")
	cast("万剑归宗")
	if qidian() > 8 then
		cast("无我无剑")
	end
	cast("三环套月")
end

v["紫霞功"] = function()
	cast("生太极", true)
	cast("坐忘无我")
	cast("六合独尊", true)
end

v["花间游"] = function()
	cast("春泥护花")
	cast("星楼月影")
	cast("商阳指")
	cast("碧水滔天")
end

v["冰心诀"] = function()
	cast("天地低昂")
	cast("剑破虚空")
	cast("玳弦急曲")

end

v["山海心决"] = function()
	if rage() < 1 then

	end
	cast("引风唤灵")
	cast("玳弦急曲")
end

v["北傲决"] = function()
	cast("项王击鼎")
end

v["问水诀"] = function()
	cast("九溪弥烟")
	cast("云栖松")
end

v["太玄经"] = function()
	cast("三星临")
	cast("兵主逆")
	cast("天斗旋")
end


v["毒经"] = function()
	cast("百足", true)
	cast("蛇影")
	cast("蟾啸")
	cast("玉蟾引", true)
end


v["焚影圣诀"] = function()
	cast("银月斩")
	cast("幽月轮")
end


v["莫问"] = function()
	cast("疏影横斜")
	cast("商")
	cast("角")
end


v["分山劲"] = function()
	cast("血怒")
	cast("盾舞")
end
--主循环
function Main(g_player)
	local nid = f["切换目标"]()
	if nid ~= 0 and nid ~= nil and (notarget() or dis() > 15) then
		settar(nid)
	end

	if notarget() then
		return
	end
	turn()
	v[xmountname(id())]()
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
