--������
g_var = {}

--���ó���
g_var["����λ��״̬"] = "������|���|��ץ"
g_var["�����ķ�"] = "�뾭�׵�|�����ľ�|�����|��֪|����"
g_var["��ս�ķ�"] = "ϴ�辭|�׽|��Ѫս��|������|̫�齣��|��ˮ��|ɽ�ӽ���|��Ӱʥ��|����������|Ц����|������|��ɽ��|������|�躣��|������|�·��"
g_var["Զ���ķ�"] = "������|��ϼ��|���ľ�|����|�����|���޹��|Ī��|̫����|�޷�|ɽ���ľ�"

--������
g_func = {}

--[[ȫ�ֱ���˵��, ��������˼�����е���
Ŀ��ɿ���, Ϊ��ʱָ����Ŀ�겻���κθ���Ч��Ӱ��, ������ʱ���Ŀ��ʹ�ø���Ч�������к�����
Ŀ��ɹ���, Ϊ��ʱָ����Ŀ�겻���˺����߼��˷ǳ���, Ŀ���ܸ���Ч��Ӱ�죬ֻ���˺����ֱ�����, �󲿷����ɿ��Ƽ����˺�����, ��CD���˺��ļ��ܿ����ж�һ��
--]]


g_func["��ʼ��"] = function()
	g_var["Ŀ�����Ч��"] = g_func["Ŀ�����Ч��"]()
	g_var["Ŀ������Ч��"] = tbuffstate("����Ч��")
	g_var["Ŀ�������Ч��"] = tbuffstate("������Ч��")

	g_var["Ŀ��ɿ���"] = g_func["Ŀ��ɿ���"]()
	g_var["Ŀ��ɹ���"] = g_var["Ŀ��ɿ���"] and g_func["Ŀ��ɹ���"]()
	g_var["Ŀ��û����"] = g_var["Ŀ��ɹ���"] and g_func["Ŀ��û����"]()
	
	--��������, ���͵�����Ѩ����Ϸˮ
	g_var["Ŀ�굥������"] = 0
	local nLeftTime, nStackNum = tbuffstate("��������")
	if nLeftTime > -0.25 then
		g_var["Ŀ�굥������"] = nStackNum
	end

	g_var["Ŀ��һ��"] = g_var["Ŀ��û����"] and g_var["Ŀ�굥������"] <= 0 and g_func["Ŀ��һ��"]()
	g_var["ͻ��"] = g_var["Ŀ��ɹ���"] and g_func["ͻ��"]()

	_, g_var["������������"] = enemy("����<40")
end

--�����κθ��漼��
g_func["Ŀ��ɿ���"] = function()
	--Ŀ�겻�ǵж�
	if not rela("�ж�") then return false end

	--Ŀ���޵�
	if tbuffstate("�޵�ʱ��") > -1 then
		bigtext("Ŀ���޵�", 0.5)
		return false
	end

	--���� ����
	if tbufftime("����") > -1 or tlasttime("����") <= 2 then
		bigtext("Ŀ�����", 0.5)
		return false
	end

	--���� ���ɳ��
	if buffsrc("���ɳ��") ~= tbuffsrc("���ɳ��") then
		bigtext("Ŀ�겻�����ɳ��Ŀ��", 0.5)
		return false
	end

	--���� ХӰ
	if bufftime("ХӰ") > -1 then
		bigtext("��ХӰ", 0.5)
		return false
	end

	--ָ�����ֵ�NPC����
	if target("npc") and tname("ʥЫ|����|����|����|���|�̵�|�Լ�����") then
		bigtext("����ָ��npc", 0.5)
		return false
	end

	--Ŀ�������
	if g_var["Ŀ�������Ч��"] > 95 then
		bigtext("Ŀ������й���: "..g_var["Ŀ�������Ч��"], 0.5)
		return false
	end

	return true
end

--����Ŀ�����Ч��
g_func["Ŀ�����Ч��"] = function()
	local effect = 0
	local m = mounttype()
	if m == "�⹦" then
		effect = tbuffstate("������Ч��")
	else
		effect = tbuffstate("������Ч��")
	end

	if tschool("�嶾") then
		effect = 100 - (100 - effect)  * (100 - tbuffstate("�˺�ת��Ч��")) / 100  --����֮����ȥ��ת�Ʋ��֣���ʣ�µ�ʵ���˺���ò��������
	end

	return effect
end

--�����˺�����
g_func["Ŀ��ɹ���"] = function()
	--���� ���ű���
	g_var["Ŀ����ű���"] = false
	if tbufftime("���ű���") > -1 or tlasttime("���ű���") <= 4 then
		g_var["Ŀ����ű���"] = true
		bigtext("Ŀ����ű���", 0.5)
		return false
	end

	--���з���
	g_var["Ŀ��߷���"] = false
	if tbuffstate("����Ч��") > 45 and tbuffstate("����Ч��") / 100 * tlifevalue() > lifevalue() - lifemax() * 0.1 then
		g_var["Ŀ��߷���"] = true
		bigtext("Ŀ��߷���", 0.5)
		return false
	end

	--�����
	local m = mounttype()
	
	if m == "�ڹ�" then
		if tbuffstate("������ʱ��") > -1 then
			bigtext("Ŀ��������", 0.5)
			return false
		end
	elseif m == "�⹦" then
		if tbuffstate("������ʱ��") > -1 then
			bigtext("Ŀ��������", 0.5)
			return false
		end
		if g_var["Ŀ������Ч��"] > 95 then
			bigtext("Ŀ�����ܹ���: ".. g_var["Ŀ������Ч��"], 0.5)
			return false
		end
	elseif m == "����" then
		if tbuffstate("������ʱ��") > -1 then
			bigtext("Ŀ��������", 0.5)
			return false
		end
		if g_var["Ŀ������Ч��"] > 95 then
			bigtext("Ŀ�����ܹ���: ".. g_var["Ŀ������Ч��"], 0.5)
			return false
		end
	else
		bigtext("��ȡ�ڹ�����ʧ��")
	end

	if g_var["Ŀ�����Ч��"] > 95 then
		bigtext("Ŀ����˹���: ".. g_var["Ŀ�����Ч��"], 0.5)
		return false
	end

	--[[9506 ���Ӱ��
	if tbuff("9506") then
		return false
	end
	--]]

	return true
end

g_func["Ŀ��û����"] = function()
	--����
	if g_var["Ŀ�����Ч��"] > 39 then
		return false
	end

	--������
	if tbuffstate("������Ч��") > 39 then
		return false
	end

	--�⹦�������ж�����
	local m = mounttype()
	if m == "�⹦" or m == "����" then
		if g_var["Ŀ������Ч��"] > 39 then
			return false
		end
	end

	--�˺�ת��
	if tbuff("��ˮ��|����߳��") then
		return false
	end

	--ǧ֦���� ���ü��㵥���ж�

	return true
end

--��Ѫ��û����
g_func["Ŀ��һ��"] = function()
	--���
	--if tbufftime("Х�绢") > -1 then return false end
	if tbuffstate("����ʱ��") > -1 then return false end

	--��
	if tbufftime("����") > -1 then return false end

	--���� ڤ��
	if tqixue("ڤ��") and tnobuff("ڤ��") then return false end

	--�ؽ� Ƭ��
	if tqixue("Ƭ��") and tnobuff("����") then return false end

	--�嶾 ����
	if tqixue("����") and tnobuff("�Ϻ�") then return false end


	--���� ���Ӱ�費��
	if tbuff("12875") then return false end

	--Ѫ��+�˺����ն� С��20%
	return tlife() + tdas() < 0.2
end

g_func["ͻ��"] = function()
	--��������
	if tenemy("����:������ɽ", "ƽ�����<10") ~= 0 then return false end
	if buffsn("����") >= 4 and tenemy("����:�Ҵ�ʱ��", "ƽ�����<15") ~= 0 then return false end
	

	--�ؽ� ������ɽ
	if tnpc("��ϵ:�ж�", "ƽ�����<10", "ģ��ID:57739") ~= 0 then return false end

	--���� ���϶���
	if tnpc("��ϵ:�ж�", "ƽ�����<6", "ģ��ID:58295") ~= 0 then return false end

	--���� ��������
	if tnpc("��ϵ:�ж�", "ƽ�����<10", "ģ��ID:44764") ~= 0 then return false end

	--���� �Ȼ����
	if tnpc("��ϵ:�ж�", "ƽ�����<6", "ģ��ID:63709") ~= 0 then return false end

	--ҩ�� ��Ұ����
	if tbuff("��Ұ����") then return false end
	
	--Ŀ�긽�����˴���5������ͻ��
	local _, count = tenemy("ƽ�����<10")
	if count > 5 then return false end


	return true
end

g_func["�ɼ�"]= function()

	interact(doodad("����:����|ֹѪ��|�ӵ׵�ɳʯ|����|�����˵�����|��¨|����|���|�ɲ�|ѩ��|��Ѫ������", "����<6", "�������"))

	if self().GetItemAmountInPackage(5, 4549) < 6 then
		interact(doodad("����:������", "����<6", "�������"))
	end

	if self().GetItemAmountInPackage(5, 4550) < 6 then
		interact(doodad("����:�ƶž�", "����<6", "�������"))
	end
end

g_func["�����ڽ�е"] = function()
	if bufftime("ϴ����") > 1 then
		local doodadID = doodad("ģ��ID:9810", "����ID:49040")
		if doodadID ~= 0 then
			local x, y, z = xpos(doodadID)
			if x > 0 then
				local dist = pdis2(x, y)
				if dist > 2 then
					if acast("������ʤ", -90, { nX = x, nY = y }) then
						bigtext("�����ڽ�е", 1)
						exit()
					end
					if acast("��̨���", 90, { nX = x, nY = y }) then
						bigtext("�����ڽ�е", 1)
						exit()
					end
				end
				stopmove()
				moveto(x, y, z)
				exit()
			end
		end
	end
end
