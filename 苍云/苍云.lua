local current_time = time()
local deadline_utc = time(2024, 5, 28, 0, 0, 0)
--if current_time >= deadline_utc then
--bigtext(
--    "����ʱ�����",10,2)
--    return
--end
--[[ ��Ѩ: [����][����][��Ұ][Ѫ��][����][����][ҵ�����][��ս][Ԯ��][��ӿ][����][���ƽ��]
�ؼ�:
�ܵ�  1���� 2�˺� 1��ŭ(����)
��ѹ  2���� 2�˺�
�ٵ�  1���� 2�˺� 1����
ն��  1���� 3�˺�
����  1���� 1�˺� 1��Ϣ��2��(����) 1��ŭ��(����)
�ܷ�  2�˺� 2����(����)
Ѫŭ  1��ŭ 3���� (���Գ��� 3��ŭ 1���� ��߾����˺�, ���Ѫŭ���ϵĻ�, �Լ������)

--ѭ��
�ܻ� Ѫŭ ҵ�� �ܻ� �ܻ� �ܷ� -> ն�� ���� ���� ն�� ���� ���� Ѫŭ ն�� ���� ���� �ܻ�
��ѹ ���� �ܵ� �ܵ� �ܷ� -> ���� ն�� ���� ���� ���� ���� ���� �ܻ�
�ܻ� �ܻ� �ܻ� �ܷ� -> ն�� ���� ���� Ѫŭ ն�� ���� ���� �ܻ�
��ѹ ���� �ܵ� �ܵ� �ܷ� -> ���� ն�� ���� ���� ���� ���� ���� �ܻ�
���ҵ��CDû���룬3�ܻ�ǰ������һ����ѹ
--]]

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["��¼��Ϣ"] = true
v["ŭ��"] = rage()
v["��Ѫŭ"] = false		--����̬�Ƿ��Ѫŭ����CD��־
v["������"] = false		--����̬�Ƿ�����Ʊ�־

--������
local f = {}

--��ѭ��
function Main()
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	--����
	if fight() and life() < 0.6 then
		cast("�ܱ�")
	end

	--��ʼ������
	v["GCD16���"] = cdinterval(16)
	v["GCD804���"] = cdinterval(804)
	v["GCD"] = math.max(cdleft(16), cdleft(804))
	v["����CD"] = cdleft(803)	--public 16 804
	v["�ܻ����ܴ���"] = cn("�ܻ�")	--public 804 check 16, �ܵ������һ��
	v["�ܻ�����ʱ��"] = cntime("�ܻ�", true)
	v["��ѹCD"] = cdleft(802)	--public 16 804
	v["ն��CD"] = cdleft(801)	--��ն���� �������� public 16 804
	v["����CD"] = cdleft(800)
	v["����CD"] = cdleft(806)
	v["�ܷɳ��ܴ���"] = cn("�ܷ�")
	v["�ܷɳ���ʱ��"] = cntime("�ܷ�", true)
	v["Ѫŭ���ܴ���"] = cn("Ѫŭ")
	v["Ѫŭ����ʱ��"] = cntime("Ѫŭ", true)
	v["ҵ��CD"] = cdleft(2607)		--public 16

	v["�ܷ�ʱ��"] = bufftime("�ܷ�")
	v["Ѫŭʱ��"] = bufftime("Ѫŭ����ӿ")	--27161
	--v["Ŀ�����ʱ��"] = tbufftime("����", id())	--21308
	v["Ŀ��ҵ��ʱ��"] = tbufftime("ҵ��ٳ�", id())	--25948
	v["���ʱ��"] = bufftime("�������")	--25941
	--26212 ����, ������ù����
	v["Ԯ�����"] = buffsn("Ԯ��")		--27030 12��, �ͷŶܻ����� 27029(2��)С��2���1�� 2���ɾ�� ��6��27030
	v["Ԯ��ʱ��"] = bufftime("Ԯ��")
	v["��ӿ����"] = buffsn("27482")		--��Ѫŭû27484 ��������2��27482, ��ն����ɾ1��
	v["��ӿʱ��"] = bufftime("27482")
	v["û�������"] = nobuff("27484")	--27484 ��ӿ����������
	v["��������"] = buffsn("��������")		--27444, ���45��
	v["����ʱ��"] = bufftime("��������")

	--Ŀ�겻�ǵ��� ֱ�ӽ���
	if not rela("�ж�") then return end

	--����������
	if getopt("����������") and dungeon() and nofight() then return end

	---------------------------------------------

	if pose("���") then
		f["���"]()
	end
	if pose("�浶") then
		f["�浶"]()
	end

	--û�ż��ܼ�¼��Ϣ
	if fight() and rela("�ж�") and dis() < 4 and visible() and state("վ��|��·|�ܲ�|��Ծ") and face() < 90 and cdleft(16) <= 0 and cdleft(804) <= 0 and gettimer("�ܷ�") > 0.5 and gettimer("�ܻ�") > 0.5 then
		PrintInfo("---------- û�ż���")
	end
end

-------------------------------------------------------------------------------

f["���"] = function()
	if gettimer("�ܷ�") < 0.5 then return end	--�ܷ�5֮֡�������̬

	if v["��������"] < 16 and f["�ܻ��������"]() then
		v["��3�ܻ�"] = true
	end

	--����֮��ҵ��CD�ϲ���, ������ѹ
	if v["��3�ܻ�"] and v["ҵ��CD"] > v["GCD804���"] * 2 and v["ҵ��CD"] <= v["GCD804���"] * 2 + v["GCD16���"] then
		CastX("��ѹ")
	end

	--�ܻ� Ԯ������
	if buff("27029") then
		if nobuff("Ԯ��") and v["�ܻ�����ʱ��"] < 30.5 then
			f["�ܻ�"]()
			return		--������ֻ��ܻ�
		end
	end
		
	--�ܻ� ��������
	if v["��3�ܻ�"] then
		if v["ն��CD"] <= v["GCD804���"] * 3 or (cdtime("Ѫŭ") <= 0 and cdtime("ҵ�����") <= 0) then
			f["�ܻ�"]()
		end
	end

	--�ܷ�
	v["�Ŷܷ�"] = false
	local nCD = v["GCD"] + 0.5	--ŭ������CD��һ�㣬�е���

	--ҵ��, 50�� ���� ն�� ����
	if v["Ŀ��ҵ��ʱ��"] > 0 then	
		if v["ŭ��"] >= 50 and v["ն��CD"] <= nCD and v["����CD"] <= nCD + v["GCD16���"] then
			v["�Ŷܷ�"] = true
		end
	
	--Ԯ��, 25�� ���� ն�� ����
	elseif v["Ԯ�����"] >= 6 then
		if v["ŭ��"] >= 25 and v["ն��CD"] <= nCD and v["����CD"] <= nCD + v["GCD16���"] then
			v["�Ŷܷ�"] = true
		end

	--����, 40�� ���� ���� ն�� ���� ����
	elseif v["��������"] >= 16 then
		if v["ŭ��"] >= 30 and v["ն��CD"] <= nCD + v["GCD16���"] and v["����CD"] <= nCD + v["GCD16���"] * 3 then
			v["�Ŷܷ�"] = true
		end
	
	--�������������, 25�� ���� ն�� ����
	else
		if v["ŭ��"] >= 25 and v["ն��CD"] <= nCD and v["����CD"] <= nCD + v["GCD16���"] then
			v["�Ŷܷ�"] = true
		end
	end

	if v["�Ŷܷ�"] and gettimer("�ܻ�") >= 0.5 then
		if nobuff("27029") or buff("Ԯ��") then
			if CastX("�ܷ�") then
				exit()
			end
		end
	end

	--��5�㲹�ܵ�
	if v["��������"] >= 16 and v["ŭ��"] >= 35 then
		CastX("�ܵ�")
	end
	if v["Ŀ��ҵ��ʱ��"] > 0 and v["ŭ��"] >= 45 then
		CastX("�ܵ�")
	end

	--��ѹ
	CastX("��ѹ")

	--����
	if not v["��3�ܻ�"] or dis() > 10 then
		CastX("����")
	end

	--�ܵ�
	CastX("�ܵ�")
end

f["�浶"] = function()
	if gettimer("�ܻ�") < 0.3 then return end

	--�ȵ���
	if nobuff("8627") then return end
	
	--Ѫŭ, 8452 ����������CD, 8474 ����buff 4֡ * 25�� ����ŭ�� ÿ�����ѹ����CD �Ȳ�����
	if v["ն��CD"] > 1 and v["����CD"] > 1 and cdleft(16) < 1 and v["�ܷ�ʱ��"] > v["GCD16���"] * 2 + cdleft(16) + 1 and nobuff("���|8452") then
		if v["��Ѫŭ"] then
			CastX("Ѫŭ")
		end
	end

	--���ƽ��
	if v["������"] and v["�ܷ�ʱ��"] > 11 then
		if rela("�ж�") and dis() < 6 and face() < 90 then		--6*6 ����, �þ����ж�ģ�ʹ�Ĺ�������
			CastX("���ƽ��")
		end
		return	--ն�������ƾ���Զ, �ȿ�ס
	end



	--������Ӫ
	if buff("22976") then
		if dis() < 8 and face() < 90 then
			CastX("������Ӫ")
		end
	end
	--ն��
	if v["ŭ��"] >= 25 and v["����CD"] <= v["GCD16���"] + 0.1 and nobuff("���|8453") then
		CastX("ն��")
	end

       --��������
	if buff("22977") then
		if dis() < 15 then		--����20�� ����15��, �����¾����ֹ��Ϊ����ԭ���ȴ�����
			CastX("��������")
		end
	end

	--���� ��һ��
	if buff("���") then
		CastX("����")
	end

	--���� �ڶ���
	if buff("���|8453") then
		CastX("����")
	end
	
	--�ܻ�
	if v["ŭ��"] < 20 and v["GCD"] < 0.25 and gettimer("Ѫŭ") > 0.5 and gettimer("�ͷ�Ѫŭ") > 1 then
		CastX("�ܻ�")
	end
end

f["�ܻ�"] = function()
	if CastX("�ܻ�") then
		if cdtime("ҵ�����") <= 0 then
			CastX("Ѫŭ")
		end
		CastX("ҵ�����")
	end
end

f["�ܻ��������"] = function()
	if cntime("�ܻ�", true) < 10 + cdinterval(804) * 2 + math.max(cdleft(16), cdleft(804)) then		--�ܻ�����ʱ��������3��
		return true
	end
	return false
end

-------------------------------------------------------------------------------

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then t[#t+1] = s end
	t[#t+1] = "ŭ��:"..v["ŭ��"]
	t[#t+1] = "����:"..format("%.1f", dis())

	--��
	t[#t+1] = "�ܻ�CD:"..v["�ܻ����ܴ���"]..", "..v["�ܻ�����ʱ��"]
	t[#t+1] = "ҵ��CD:"..v["ҵ��CD"]
	t[#t+1] = "��ѹCD:"..v["��ѹCD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "ҵ��:"..v["Ŀ��ҵ��ʱ��"]
	t[#t+1] = "Ԯ��:"..v["Ԯ�����"]..", "..v["Ԯ��ʱ��"]

	--��
	t[#t+1] = "ն��CD:"..v["ն��CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "����CD:"..v["����CD"]
	t[#t+1] = "���:"..v["���ʱ��"]
	t[#t+1] = "��ӿ:"..v["��ӿ����"]..", "..v["��ӿʱ��"]
	t[#t+1] = "����:"..v["��������"]..", "..v["����ʱ��"]
	
	t[#t+1] = "Ѫŭ:"..v["Ѫŭʱ��"]
	t[#t+1] = "ѪŭCD:"..v["Ѫŭ���ܴ���"]..", "..v["Ѫŭ����ʱ��"]
	t[#t+1] = "�ܷ�:"..v["�ܷ�ʱ��"]
	t[#t+1] = "�ܷ�CD:"..v["�ܷɳ��ܴ���"]..", "..v["�ܷɳ���ʱ��"]
	
	--t[#t+1] = "���:"..bufftime("���")		--8451
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

--�����ͷŻص���
local tFunc = {}

tFunc[13044] = function()	--�ܵ�
	v["ŭ��"] = v["ŭ��"] + 5
end

tFunc[13059] = function()	--�ܵ�����
	v["ŭ��"] = v["ŭ��"] + 5
end

tFunc[13060] = function()	--�ܵ�����
	v["ŭ��"] = v["ŭ��"] + 10
end

tFunc[13046] = function()	--����
	v["ŭ��"] = v["ŭ��"] + 15
end

tFunc[13047] = function()	--�ܻ�
	v["ŭ��"] = v["ŭ��"] + 10
	v["��3�ܻ�"] = false	--���1��ȡ��3�ܻ���־
end

tFunc[13045] = function()	--��ѹ
	v["ŭ��"] = v["ŭ��"] + 15
end

tFunc[13040] = function()	--Ѫŭ
	v["��Ѫŭ"] = false		--�Ź�ȡ����־
	settimer("�ͷ�Ѫŭ")
end

tFunc[30769] = function()	--����
	v["������"] = false		--�Ź�ȡ����־
end

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
	if CasterID == id() then
		local func = tFunc[SkillID]
		if func then
			func()
		end
	end
end

local tBuff = {
[8627] = "����",	--���buff 8393 ���4֡
--[25939] = "ҵ��������",	--ԴID��Ŀ��
--[8451] = "���",
--[8452] = "���þ���CD",
--[8453] = "������CD",
}

--buff����
function OnBuff(CharacterID, BuffName, BuffID, BuffLevel, StackNum, SkillSrcID, StartFrame, EndFrame, FrameCount)
	if CharacterID == id() then
		local szName = tBuff[BuffID]
		if szName then
			if StackNum  > 0 then
				if BuffID == 27029 then
					deltimer("�ܻ�")
				end

				if BuffID ~= 8627 or nobuff("8627") then
					print("OnBuff->���buff: ".. szName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount..", ����֡: "..EndFrame..", ʣ��ʱ��: "..(EndFrame-FrameCount)/16)
				end
			else
				print("OnBuff->�Ƴ�buff: ".. szName..", ID: "..BuffID..", �ȼ�: "..BuffLevel..", ����: "..StackNum..", ԴID: "..SkillSrcID..", ��ʼ֡: "..StartFrame..", ��ǰ֡: "..FrameCount)
			end
		end

		if BuffID == 8391 then	--�ܷ�
			if StackNum  > 0 then
				--���뵶��̬
				if v["Ԯ�����"] >= 6 then	--��Ԯ�꣬Ѫŭ����CD
					v["��Ѫŭ"] = true
				else
					v["��Ѫŭ"] = false
				end

				if v["��������"] >= 16 then	--�������Ʊ�־
					v["������"] = true
				end

				print("------------------------------ ����̬", frame())		--�ָ���
			else
				--ȡ��������CD
				if cbuff("8453") then
					print("---------- ȡ��������CD")
				end
				print("------------------------------ ����̬", frame())		--�ָ���
			end
		end
	end
end

--״̬����
function OnStateUpdate(nCurrentLife, nCurrentMana, nCurrentRage, nCurrentEnergy, nCurrentSunEnergy, nCurrentMoonEnergy)
	v["ŭ��"] = nCurrentRage
end

--��¼ս��״̬�ı�
function OnFight(bFight)
	if bFight then
		print("--------------------����ս��")
	else
		print("--------------------�뿪ս��")
	end
end
