output("奇穴: [雾锁][吐故纳新][抱一][抱元][玄德][跬步][万物][无我][霜寒][心眼][重光][规焉]")

--载入库
load("Macro/Lib_PVP.lua")
load("Macro/Lib_Base.lua")

--变量表
local v = {}

--函数表
local f = {}

local mount_hps = {}
mount_hps["云裳心经"]=true
mount_hps["补天诀"]=true
mount_hps["离经易道"]=true
mount_hps["相知"]=true
mount_hps["灵素"]=true
--"云裳心经|补天诀|离经易道|相知|灵素"

local mount_neigong = {}
--"紫霞功|太虚剑意|莫问|花间游|冰心诀|太玄经|无方"
mount_neigong["紫霞功"]= true
mount_neigong["太虚剑意"]=true
mount_neigong["莫问"]=true
mount_neigong["花间游"]=true
mount_neigong["冰心诀"]=true
mount_neigong["太玄经"]=true
mount_neigong["无方"]=true


--主循环
function Main(g_player)
	--if nofight() or notarget() then
	--	return
	--end
	g_base["气纯抓点"]()

	--v["生太极"] = npc("关系:自己", "名字:气场碎星辰", "距离<13")
	--v["破苍穹"] = npc("关系:自己", "名字:气场吞日月", "距离<13")
	--_, v["气场数量"] = npc("关系:自己", "名字:气场生太极|气场碎星辰|气场吞日月", "距离<13")
	--if nobuff("生太极") or v["气场数量"] < 3 then
	--	return
	--end
	--
	--local mountname = xmountname(tid)
	--
	--if mount_hps[mountname] then
	--	g_base["气纯抓点"]()
	--else
	--end
end