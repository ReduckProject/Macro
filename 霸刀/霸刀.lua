output("���̫��")
--������
local v = {}

--������
local f = {}

--��ѭ��
function Main(g_player)
	local nid = f["�л�Ŀ��"]()
	if nid ~= 0 and nid ~= nil and notarget() then
		settar(nid)
	end

	if notarget() then
		return
	end
	turn()
	cast("��������")
end

f["�л�Ŀ��"] = function()
	v["20���ڵ���"] = npc("����<6", "���߿ɴ�", "��ϵ:�ж�")
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
