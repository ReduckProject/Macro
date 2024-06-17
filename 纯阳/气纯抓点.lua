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
	if tbuffstate("可锁足") and scdtime("八卦洞玄") == 0 then
		CastX("五方行尽")
	end

	if buff("会神") and scdtime("八卦洞玄") == 0  then
		if nobuff("紫气东来") then
			CastX("紫气东来")
		end

		if qidian() > 9 then
			CastX("八卦洞玄")
		end
	end

	if buff("紫气东来") then
		CastX("四象轮回")
	end
end


function CastX(szSkill, bSelf)
	g_func["敌对释放"](szSkill, bSelf)
end
