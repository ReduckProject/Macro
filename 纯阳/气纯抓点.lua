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
	--if nofight() or notarget() then
	--	return
	--end
	g_base["����ץ��"]()

	--v["��̫��"] = npc("��ϵ:�Լ�", "����:�������ǳ�", "����<13")
	--v["�Ʋ��"] = npc("��ϵ:�Լ�", "����:����������", "����<13")
	--_, v["��������"] = npc("��ϵ:�Լ�", "����:������̫��|�������ǳ�|����������", "����<13")
	--if nobuff("��̫��") or v["��������"] < 3 then
	--	return
	--end
	--
	--local mountname = xmountname(tid)
	--
	--if mount_hps[mountname] then
	--	g_base["����ץ��"]()
	--else
	--end
end