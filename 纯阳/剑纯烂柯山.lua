--[[ ��Ѩ: [�Ĺ�][����][������][����][����][����][����][����][�ʳ�][����][�鼫][����]
�ؼ�:
������	3���� 1��ɢ(�������)
����	1��Ϣ 1���� 2�˺�
����	1���� 2�˺� 1Ч��
�˻�	1��Ϣ 2�˺� 1Ч��
�˽�	1��Ϣ 1dot 1�������� 1�˺����60%
����	2��Ϣ 1��Ѫ�� 1����
ƾ��	2��Ϣ

���Ҳ����滹��װ��̫�û�������������, �˺�����ĵ�
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["��¼��Ϣ"] = true

--��ѭ��
function Main()
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	cast("������")
	--����
	if fight() and life() < 0.5 and buffstate("����Ч��") < 40 then
		if gettimer("��������") > 0.3 and nobuff("��������") then
			cast("תǬ��")
		end
		if gettimer("תǬ��") > 0.3 then
			cast("��������")
		end
	end

	--��ʼ������
	v["����"] = qidian()

	local tSpeedXY, tSpeedZ = speed(tid())
	v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0
	v["GCD���"] = cdinterval(16)
	v["���ǳ�CD"] = scdtime("���ǳ�")
	v["������CD"] = scdtime("������")
	v["����CD"] = scdtime("��������")
	v["��CD"] = scdtime("�򽣹���")
	v["�˻�CD"] = scdtime("�˻Ĺ�Ԫ")
	v["�˽�CD"] = scdtime("�˽���һ")
	v["�������ܴ���"] = cn("��������")
	v["��������ʱ��"] = cntime("��������", true)

	v["����ʱ��"] = bufftime("��������")
	v["Ŀ����в���"] = tbuffsn("����", id())
	v["Ŀ�����ʱ��"] = tbufftime("����", id())
	v["���ǳ�buffʱ��"] = bufftime("���ǳ�")	--����5% ��Ч10% ���ӷ���60% 4��
	v["����ʱ��"] = bufftime("����")		--14931 �����˺����30% 5��
	v["����ʱ��"] = bufftime("����")		--17933 15%��Ч
	v["���Ų���"] = buffsn("����")			--ÿ����� �Ʒ�20% ����3%
	v["����ʱ��"] = bufftime("����")

	v["���ǳ�"] = npc("��ϵ:�Լ�", "����:�������ǳ�", "����<16")
	v["������"] = npc("��ϵ:�Լ�", "����:����������", "����<16")
	v["������"] = npc("��ϵ:�Լ�", "����:����������", "����<15")
	v["��̫��"] = npc("��ϵ:�Լ�", "����:������̫��", "����<18")
	_, v["��������"] = npc("��ϵ:�Լ�", "����:������̫��|�������ǳ�|����������", "����<13")

	--û��ս��������
	if nofight() and nobuff("��������") then
		CastX("��������")
	end

	if nofight() then
		return
	end

	if v["��̫��"] == 0 then
		print("��̫��")
		if scdtime(358) == 0 then
			--��̫��
			CastX(358)

			if notarget() then
				CastX(358, true)
			end
		elseif scdtime(15187) == 0 then
			--�����
			CastX(15187)
		else
			--ƾ������
			CastX(355)
		end
	end

	if life() < 0.6 then
		CastX("��������")
	end

	if life() < 0.3 then
		CastX("תǬ��")
	end

	if life() < 0.6 then
		CastX("ƾ������")
	end

	if (scdtime(358) < 2.5 or scdtime(15187) < 2) and v["���ǳ�"] ~= 0 and v["������"] ~= 0 then
		CastX("�˽���һ")
	end


	if notarget() then
		return
	end

	--����
	if v["����"] > 9 then
		CastX("�����޽�")
	end

	if dis() < 6 and tstate("����") then
		CastX("�򽣹���")
	end

	if  v["������"] == 0 then
		CastX("������")
	end

	if  v["���ǳ�"] == 0 then
		CastX("���ǳ�")
	end


	if dis() > 6 and tlife() < 0.6 then
		CastX("�˻Ĺ�Ԫ")
	end

	if v["����"] < 7 then
		CastX("��������")
	end

end

-------------------------------------------------------------------------------

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "����:"..v["����"]

	t[#t+1] = "����:"..v["���Ų���"]..", "..v["����ʱ��"]
	t[#t+1] = "���ǳ�:"..v["���ǳ�buffʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "Ŀ�����:"..v["Ŀ����в���"]..", "..v["Ŀ�����ʱ��"]
	t[#t+1] = "����:"..v["����ʱ��"]
	t[#t+1] = "���н����ǳ�:"..bufftime("14983")

	t[#t+1] = "���ǳ�CD:"..v["���ǳ�CD"]
	t[#t+1] = "������CD:"..v["������CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "��CD:"..v["��CD"]
	t[#t+1] = "�˻�CD:"..v["�˻�CD"]
	t[#t+1] = "�˽�CD:"..v["�˽�CD"]
	t[#t+1] = "����CD:"..v["�������ܴ���"]..", "..v["��������ʱ��"]

	print(table.concat(t, ", "))
end

--ʹ�ü��ܲ���¼��Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["��¼��Ϣ"] then PrintInfo() end
		return true
	end
	return false
end

-------------------------------------------------------------------------------

local tWWSkills = {
	[383] = "����1����",
	[386] = "����2����",
	[387] = "����3����",
	[388] = "����4����",
	[389] = "����5����",
	[390] = "����6����",
	[391] = "����7����",
	[392] = "����8����",
	[393] = "����9����",
	[394] = "����10����",
}

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		--if SkillID == 21816 then
		--	print("---------- ���н�")
		--end

		--��¼����ʵ���ͷ�����
		local s = tWWSkills[SkillID]
		if s then
			print("---------- "..s)
		end
	end
end

--��¼ս��״̬�ı�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
