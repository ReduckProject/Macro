
load("Macro/Lib_Tools.lua")
load("Macro/����/��Ȼ��.lua")
local var = {}
local count = 0

local xiake = 0


var["��һ"] = false
--var["��һ"] = true
--var["��һ��"] = 69
var["�϶�"] = false
--var["�϶���"] = 80
var["����"] = false
--��ѭ��
function Main(g_player)

    if map() == '����' then
		var["��һ"] = false
		var["��һ��"] = nil
		var["�϶�"] = false
		var["�϶���"] = nil
		var["����"] = false
		xiake = 0

		clickButton("Topmost/MB_PlayerMessageBoxCommon/Wnd_All/Btn_Option1/")
		clickButton("Topmost/NetworkVideo/Btn_Close/")
        local nid = npc("����:�����", "����<6")
        if nid ~= 0 then
            if count == 30 then
                interact(nid)
            end

            if count == 60 then
                dialog("����������ǰ���ؾ�")
            end

			if count == 90 then
				dialog("���ư�")
			end

			if count == 120 then
				dialog("25��Ӣ��������_��Ȼ��")
			end
        end

        count = count + 1

        if count > 200 then
            count = 0
        end
		return
    end

	if map() == "Ӣ������������Ȼ��" then
		xiake = xiake + 1

		if xiake == 50 then
			clickButton("Normal/NpcMorphBar/WndContainer_NpcSummonBar/Btn_CallAll/")
		end
		if xiake == 100 then
			clickButton("Normal/NpcMorphBar/WndContainer_NpcSummonBar/Btn_CallAll/")
		end
		if xiake == 150 then
			clickButton("Normal/NpcMorphBar/WndContainer_NpcSummonBar/Btn_CallAll/")
		end
	end

	local nid = npc("��ϵ:�ж�", "ģ��ID:58937", "��ɫ����<50")
	if nid == 0 then
		nid = npc("��ϵ:�ж�", "����:��ɽ����", "��ɫ����<50")
	end
	if nid == 0 then
		nid = npc("��ϵ:�ж�", "����:˾��", "��ɫ����<30")
	end

	if nid == 0 then
		nid = npc("��ϵ:�ж�", "����:����ϼ", "��ɫ����<30")
	end

	if nid == 0 then
		nid = npc("��ϵ:�ж�", "����:ʯ��", "��ɫ����<30")

		if nid ~= 0 then
			--nid = doodad("ģ��ID:656", "�������")
			if nid == 0 then
				--nid = doodad("����:��ʯ", "�������")
			end
			if nid ~= 0 then
				Main2()
				return
			end
		end
	end

	if nid ~= 0 then
		if notarget() or tid() ~= nid then
			settar(nid)
		end
		turn()
		if target() and dis() > 4 then
			moveToDis(4)
		end

		Main2()
		return
	end


	if fight() then
		local nid = npc("��ϵ:�ж�", "����:��������|��������|��ɽ����|��������|����Ѳ�߱�|����������", "����<10");

		if nid == 0 then
			nid = npc("��ϵ:�ж�", "����:˾��")
		end
		if nid ~= 0 and notarget() then
			settar(nid)
		end

		if target() and tid() ~= 0 and xrela("�ж�", tid()) then
			turn()
			Main2()
			return
		end
	end

	if not var["��һ"] then

		if var["��һ��"] == nil then
			var["��һ��"] = tie()
		end
		boss1_road()
		return
	end

	if  var["��һ"]  and not var["�϶�"] and tie() - var["��һ��"] == 2  then
		if var["�϶���"] == nil then
			var["�϶���"] = tie()
		end
		boss2_road()
		return
	end

	if  var["�϶�"]  and not var["����"] and  tie() - var["�϶���"] == 2 then
		if var["������"] == nil then
			var["������"] = tie()
		end
		boss3_road()
		return
	end

	local did = doodad("����:˾��ı���")
	if did == 0 then
		did = doodad("ģ��ID:1392")
	end
	if did ~= 0 then
		moveto(xpos(did))
		interact(did)
	end

end


function tie()
	return self().GetItemAmountInPackage(5, 25829)
end


function boss1_road()
	if autoMove(g_yanranfeng["���-��һ"], "���-��һ", false ) then
		var["��һ"] = true
	end
end
function boss2_road()
	if autoMove(g_yanranfeng["��һ-�϶�"], "��һ-�϶�", false ) then
		var["�϶�"] = true
	end
end
function boss3_road()
	if autoMove(g_yanranfeng["�϶�-����"], "�϶�-����", false ) then
		var["����"] = true
	end
end



-- �����ҵ�����Ϊ4�ĵ�ĺ���
function moveToDis(dist)
	if dis() < dist then
		return
	end

	local x1,y1,z1 = pos()
	local x2,y2,z2 = xpos(tid())

	-- �������� AB �ķ���
	local dx = x2 - x1
	local dy = y2 - y1

	-- ���� AB �ĳ���
	local len = dis()

	-- ������������
	local scale = dist / len
	-- ����� C ������
	local cx = x1 + (1 - scale) * dx
	local cy = y1 + (1 - scale) * dy

	moveto( cx, cy, z1)
end

function Main2()

	if mount("������") then
		Main4()
	else
		Main3()
	end
end
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
local f = {}
v["��¼��Ϣ"] = true

--��ѭ��
function Main3()
	--if life() < 0.1 then
	--    clickButton("Topmost/RevivePanel/WndContainer_BtnList/Btn_Cancel/")
	--end
	--local nid = npc("����:����")
	--if nid ~= 0 then
	--    turn()
	--    if xdis(nid) > 4 then
	--        moveto(xpos(nid))
	--    end
	--
	--    if notarget() then
	--        settar(nid)
	--    end
	--end
	--
	--if notarget() or tlife() < 0.1 then
	--    f["�л�Ŀ��"]()
	--end
	--turn()
	--if dis() > 4 then
	--    moveto(xpos(tid()))
	--end

	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		cast("��ҡֱ��")
	end

	if buff("����") then
		cast(54)
	end

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
	v["���ǳ�buffʱ��"] = bufftime("���ǳ�")    --����5% ��Ч10% ���ӷ���60% 4��
	v["����ʱ��"] = bufftime("����")        --14931 �����˺����30% 5��
	v["����ʱ��"] = bufftime("����")        --17933 15%��Ч
	v["���Ų���"] = buffsn("����")            --ÿ����� �Ʒ�20% ����3%
	v["����ʱ��"] = bufftime("����")

	v["���ǳ�"] = npc("��ϵ:�Լ�", "����:�������ǳ�", "����<13")
	v["������"] = npc("��ϵ:�Լ�", "����:����������", "����<13")
	v["������"] = npc("��ϵ:�Լ�", "����:����������", "����<15")
	_, v["��������"] = npc("��ϵ:�Լ�", "����:������̫��|�������ǳ�|����������", "����<13")

	--û��ս��������
	if nofight() and nobuff("��������") then
		CastX("��������")
	end

	--û��ս Ŀ��λ��3���ǳ�
	v["���ǳ�ʱ��"], v["���ǳ�����"] = qctime(id(), 10, 4980)    --�Լ�10�������ǳ�, ���ʱ��, ����
	if nofight() and rela("�ж�") then
		if v["���ǳ�����"] < 3 or v["���ǳ�ʱ��"] < 12 then
			CastX("���ǳ�", true)
		end
	end

	--����������
	if getopt("����������") and dungeon() and nofight() then
		return
	end

	--�˽� ���ִ�����
	if rela("�ж�") and dis() < 8 and v["��������"] >= 3 and v["���Ų���"] < 3 then
		if v["������"] == 0 and v["���ǳ�CD"] <= v["GCD���"] then
			CastX("�˽���һ")
		end
	end

	--���ǳ�
	v["���ǳ���������"], v["���ǳ�����ʱ��"] = qc("�������ǳ�", id(), id())
	if rela("�ж�") and v["���ǳ���������"] > 0 then
		--û�����ǳ���������
		CastX("���ǳ�", true)
	end

	--����
	if buff("1915") and tbuffsn("23170", id()) < 3 then
		CastX("�˻Ĺ�Ԫ")
	end

	--����
	if v["����ʱ��"] >= 0 and v["����"] > 9 then
		CastX("�����޽�")
	end

	--����
	if v["Ŀ�����ʱ��"] < 0 or v["Ŀ�����ʱ��"] > 12 then
		--����
		if nobuff("��������") and rela("�ж�") and dis() < 6 and face() < 90 and v["Ŀ�꾲ֹ"] then
			if v["�˻�CD"] <= v["GCD���"] * 2 and v["���ǳ���������"] < -1 and v["���ǳ�����ʱ��"] > 10 and v["�˽�CD"] > 10 then
				if cdtime("��������") <= 0 then
					if CastX("��������") then
						CastX("ƾ������")
					end
				end
			end
		end

		CastX("��������")
	end

	--�˽�
	if rela("�ж�") and dis() < 6 and v["���ǳ�"] ~= 0 and v["������"] ~= 0 and v["������"] == 0 then
		if v["���ǳ�CD"] <= v["GCD���"] then
			CastX("�˽���һ")
		end
	end

	--����
	if v["����ʱ��"] >= 0 and v["����"] >= 6 then
		CastX("�����޽�")
	end

	--�˻�
	CastX("�˻Ĺ�Ԫ")

	--������
	if rela("�ж�") and v["������"] == 0 and v["����ʱ��"] < 0 then
		CastX("������", true)
	end

	--������
	v["�ƶ���������"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
	if fight() and mana() < 0.45 and v["Ŀ�꾲ֹ"] and dis() < 6 and not v["�ƶ���������"] then
		CastX("������", true)
	end

	--��
	if rela("�ж�") and dis() < 8 then
		if v["����CD"] > 0.5 and v["�˻�CD"] > 0.5 and v["�˽�CD"] > 0.5 then
			CastX("�򽣹���")
		end
	end

	--û�ż��ܼ�¼��Ϣ
	if fight() and rela("�ж�") and dis() < 4 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and state("վ��|��·|�ܲ�|��Ծ") then
		if gettimer("���ǳ�") > 0.3 and gettimer("������") > 0.3 then
			PrintInfo("-- û�ż���")
		end
	end
end

function Main4()
	--g_func["С�Ṧ"]()
	if buff("����") then
		cast(54)
	end


	if life() < 0.5 then
		cast("���໤��")
	end

	if mana() < 0.4 then
		cast("��ˮ����")
	end

	if notarget() then
		return
	end

	if fight() then
		cast("ˮ���޼�")
		cast("�������")
	end


	cast("ī����Դ")

	if buff("�������") then
		cast("����ָ")
	end

	if tnobuff("��������") then
		cast("��������")
	end

	if tnobuff("����ع��") and gettimer("����ع��") > 2 then
		if cast("����ع��") then
			settimer("����ع��")
		end
	end


	if tnobuff("����ָ") then
		cast("����ָ")
	end

	if tbuff("����ָ") and tbuff("����ع��") and tbuff("��������") then
		cast("ܽ�ز���")
		cast("��ʯ���")
	end

	if tnobuff("��ѩʱ��") then
		cast("��ѩʱ��")
	end


	cast("����ָ")

end
-------------------------------------------------------------------------------

--��¼��Ϣ
function PrintInfo(s)
	local t = {}
	if s then
		t[#t + 1] = s
	end
	t[#t + 1] = "����:" .. v["����"]

	t[#t + 1] = "����:" .. v["���Ų���"] .. ", " .. v["����ʱ��"]
	t[#t + 1] = "���ǳ�:" .. v["���ǳ�buffʱ��"]
	t[#t + 1] = "����:" .. v["����ʱ��"]
	t[#t + 1] = "����:" .. v["����ʱ��"]
	t[#t + 1] = "Ŀ�����:" .. v["Ŀ����в���"] .. ", " .. v["Ŀ�����ʱ��"]
	t[#t + 1] = "����:" .. v["����ʱ��"]
	t[#t + 1] = "���н����ǳ�:" .. bufftime("14983")

	t[#t + 1] = "���ǳ�CD:" .. v["���ǳ�CD"]
	t[#t + 1] = "������CD:" .. v["������CD"]
	t[#t + 1] = "����CD:" .. v["����CD"]
	t[#t + 1] = "��CD:" .. v["��CD"]
	t[#t + 1] = "�˻�CD:" .. v["�˻�CD"]
	t[#t + 1] = "�˽�CD:" .. v["�˽�CD"]
	t[#t + 1] = "����CD:" .. v["�������ܴ���"] .. ", " .. v["��������ʱ��"]

	print(table.concat(t, ", "))
end

--ʹ�ü��ܲ���¼��Ϣ
function CastX(szSkill, bSelf)
	if cast(szSkill, bSelf) then
		settimer(szSkill)
		if v["��¼��Ϣ"] then
			PrintInfo()
		end
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
			print("---------- " .. s)
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

f["�л�Ŀ��"] = function()
	v["20���ڵ���"] = npc("����:������ʯ��|������ʯ���|�嵤|��ެ�ٷ�", "�Լ�����<20", "��ѡ��", "�Լ�����")
	if v["20���ڵ���"] ~= 0 then
		settar(v["20���ڵ���"])
	end
end
