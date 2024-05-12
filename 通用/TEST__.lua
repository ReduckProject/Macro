--[[ 奇穴: [扬戈][神勇][大漠][击水 or 龙驭][驰骋][牧云][风虎][战心][渊][夜征][龙血][虎贲]
秘籍:
穿云  1调息 1会心 2伤害
龙吟  1调息 3伤害
龙牙  1会心 3伤害
突    1消耗 1距离 2伤害
灭    1调息 1会心 2伤害
战八方 1目标个数 1范围 2伤害
断魂刺 2调息 2伤害

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdio.h>

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
	--if life() < 1 then
	--	print("zzzzzz")
	--	if cast("后撤") then
	--		print("--------------------------------")
	--	end
	--end

	--if buff("七星拱瑞") then
	--	acast("太阴指", 90, tid())
	--
	--	cast("太阴指")
	--end

	--if counter % 16 == 0 then
	--	--local nid = npc("名字:据点总管", "平面距离<200")
	--	local nid = npc("模板ID:36387", "平面距离<200")
	--	if nid ~= 0 then
	--		print(xdis(nid))
	--	end
	--end
	--
	--
	--counter = counter + 1
	--print(castpass())

	--print(self())

	local pickId =  doodad("可拾取", "距离<20")
	if pickId ~= 0 then
		if moveto(xpos(pickId)) then
			interact(pickId)
		end
	end
end

function OnChannel(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if id() == CasterID then
		print(CasterID..SkillName..SkillID)
	end
end


function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if id() == CasterID then
		print(CasterID..SkillName..SkillID)
	end
end

function OnPrepare(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, Frame, StartFrame, FrameCount)
	if id() == CasterID then
		print(CasterID..SkillName..SkillID)
	end
end