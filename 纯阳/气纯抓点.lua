output("��Ѩ: [����][�¹�����][��һ][��Ԫ][����][�Ͳ�][����][����][˪��][����][�ع�][����]")

--�����
load("Macro/Lib_PVP.lua")
load("Macro/Lib_Base.lua")

--������
local v = {}

--������
local f = {}

local mount_hps = {}
mount_hps["�����ľ�"]=true
mount_hps["�����"]=true
mount_hps["�뾭�׵�"]=true
mount_hps["��֪"]=true
mount_hps["����"]=true
--"�����ľ�|�����|�뾭�׵�|��֪|����"

local mount_neigong = {}
--"��ϼ��|̫�齣��|Ī��|������|���ľ�|̫����|�޷�"
mount_neigong["��ϼ��"]= true
mount_neigong["̫�齣��"]=true
mount_neigong["Ī��"]=true
mount_neigong["������"]=true
mount_neigong["���ľ�"]=true
mount_neigong["̫����"]=true
mount_neigong["�޷�"]=true

--��ѭ��
function Main(g_player)
	if tbuffstate("������") and scdtime("���Զ���") == 0 then
		CastX("�巽�о�")
	end

	if buff("����") and scdtime("���Զ���") == 0  then
		if nobuff("��������") then
			CastX("��������")
		end

		if qidian() > 9 then
			CastX("���Զ���")
		end
	end

	if buff("��������") then
		CastX("�����ֻ�")
	end
end


function CastX(szSkill, bSelf)
	g_func["�ж��ͷ�"](szSkill, bSelf)
end
