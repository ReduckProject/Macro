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

local counter = 0
--��ѭ��
function Main(g_player)
	dialog("�ã�")
	if counter > 0 then
		counter = counter - 1
		return
	end
    local nid = npc("����:����")
    local x, y, z = xpos(nid)
    if nid ~= 0 then
        local x, y, z = xpos(nid)
        if x == 11969 then
			if moveto(xpos(nid)) then
				interact(nid)
				counter = 200
			end

        end
        --print(xpos(nid))
    end
end

