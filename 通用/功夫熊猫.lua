--[[ ��Ѩ: [���][����][��Į][��ˮ or ��Ԧ][�۳�][����][�绢][ս��][Ԩ][ҹ��][��Ѫ][����]
�ؼ�:
����  1��Ϣ 1���� 2�˺�
����  1��Ϣ 3�˺�
����  1���� 3�˺�
ͻ    1���� 1���� 2�˺�
��    1��Ϣ 1���� 2�˺�
ս�˷� 1Ŀ����� 1��Χ 2�˺�
�ϻ�� 2��Ϣ 2�˺�

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
	if counter == 10 then
		if not interact(npc("����:�������ϰ�")) then
			counter = 0
			return
		end
	end

	if counter == 20 then
		if not dialog("����") then
			counter = 0
			return
		end
	end

	if counter == 30 then
		if not dialog("������è  �����") then
			counter = 0
			return
		end
	end

	counter = counter + 1

	if counter > 1100 then
		counter = 0
	end

	local nid = npc("ģ��ID:126758", "����<30", "�Ƕ�<30", "�������")
	if nid > 0 then
		moveto(xpos(nid))
	end

	cast(37436)

end
