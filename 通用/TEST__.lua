--[[ ��Ѩ: [���][����][��Į][��ˮ or ��Ԧ][�۳�][����][�绢][ս��][Ԩ][ҹ��][��Ѫ][����]
�ؼ�:
����  1��Ϣ 1���� 2�˺�
����  1��Ϣ 3�˺�
����  1���� 3�˺�
ͻ    1���� 1���� 2�˺�
��    1��Ϣ 1���� 2�˺�
ս�˷� 1Ŀ����� 1��Χ 2�˺�
�ϻ�� 2��Ϣ 2�˺�

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdio.h>

�������[��Ԧ], ����֮����Ԧ����3��Ͷ�����, ��3��վ׮��
--]]
load("Macro/Lib_PVP.lua")
load("Macro/Lib_Base.lua")
--������
local v = {}
local f = {}

local counter = 1
--��ѭ��
function Main(g_player)
	--if life() < 1 then
	--	print("zzzzzz")
	--	if cast("��") then
	--		print("--------------------------------")
	--	end
	--end

	--if buff("���ǹ���") then
	--	acast("̫��ָ", 90, tid())
	--
	--	cast("̫��ָ")
	--end

	--if counter % 16 == 0 then
	--	--local nid = npc("����:�ݵ��ܹ�", "ƽ�����<200")
	--	local nid = npc("ģ��ID:36387", "ƽ�����<200")
	--	if nid ~= 0 then
	--		print(xdis(nid))
	--	end
	--end
	--
	--
	--counter = counter + 1
	--print(castpass())

	--print(self())

	local pickId =  doodad("��ʰȡ", "����<20")
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