output("��Ѩ: [����][�¹�����][��һ][��Ԫ][����][�Ͳ�][����][����][˪��][����][�ع�][����]")

--�����
load("Macro/Lib_PVP.lua")
load("Macro/Lib_Base.lua")

--������
local v = {}

--������
local f = {}

--��ѭ��
function Main(g_player)
	g_base["����ץ��"]()
end

f["�л�Ŀ��"] = function()
	v["20���ڵ���"] = enemy("����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����")
	if v["20���ڵ���"] ~= 0 then
		--ûĿ����ǵж�
		if not rela("�ж�") then
			settar(v["20���ڵ���"])
			return
		end
		
		--��ǰĿ�����
		if tstate("����") then
			settar(v["20���ڵ���"])
			return
		end
		
		--����̫Զ
		if dis() > 20 then
			settar(v["20���ڵ���"])
			return
		end
		
		--���߲��ɴ�
		if tnovisible() then
			settar(v["20���ڵ���"])
			return
		end
		
		--�ȵ�ǰĿ��Ѫ����
		if tlife() > 0.3 and xlife(v["20���ڵ���"]) < tlife() then
			settar(v["20���ڵ���"])
			return
		end
	end
end
