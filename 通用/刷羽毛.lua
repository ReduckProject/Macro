output("���̫��")
--������
local v = {}

--������
local f = {}


v["̫�齣��"] = function()
	cast("��̫��", true)
	cast("��������")
	cast("�򽣹���")
	if qidian() > 8 then
		cast("�����޽�")
	end
	cast("��������")
end

v["��ϼ��"] = function()
	cast("��̫��", true)
	cast("��������")
	cast("���϶���", true)
end

v["������"] = function()
	cast("���໤��")
	cast("��¥��Ӱ")
	cast("����ָ")
	cast("��ˮ����")
end

v["���ľ�"] = function()
	cast("��صͰ�")
	cast("�������")
	cast("���Ҽ���")

end

v["ɽ���ľ�"] = function()
	if rage() < 1 then

	end
	cast("���绽��")
	cast("���Ҽ���")
end

v["������"] = function()
	cast("��������")
end

v["��ˮ��"] = function()
	cast("��Ϫ����")
	cast("������")
end

v["̫����"] = function()
	cast("������")
	cast("������")
	cast("�춷��")
end


v["����"] = function()
	cast("����", true)
	cast("��Ӱ")
	cast("�Х")
	cast("�����", true)
end


v["��Ӱʥ��"] = function()
	cast("����ն")
	cast("������")
end


v["Ī��"] = function()
	cast("��Ӱ��б")
	cast("��")
	cast("��")
end


v["��ɽ��"] = function()
	cast("Ѫŭ")
	cast("����")
end
--��ѭ��
function Main(g_player)
	local nid = f["�л�Ŀ��"]()
	if nid ~= 0 and nid ~= nil and (notarget() or dis() > 15) then
		settar(nid)
	end

	if notarget() then
		return
	end
	turn()
	v[xmountname(id())]()
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
