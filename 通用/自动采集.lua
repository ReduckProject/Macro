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
--load("Macro/Lib_PVP.lua")
--load("Macro/Lib_Base.lua")
--������
local v = {}
local f = {}

local id = 0
--��ѭ��
function Main(g_player)
	local time = gettimer("�ɼ�")
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
			--settimer("�ɼ�")
		end
		return
	end

	id = doodad("����:ֹѪ��|�ӵ׵�ɳʯ|�����˵�����|��¨|����|���|ǧ����|Ǧп��|���|�ɲ�|ѩ��|��ҩ|��ζ��|�����|ɺ��", "����<40", "�������")
end

