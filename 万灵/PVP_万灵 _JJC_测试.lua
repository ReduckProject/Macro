--[[ ��Ѩ: [�سD][��ʸ][���][����][¹��][ɣ��][����][¬��][����][����][���][�������]
�ؼ�:
����	2���� 2�˺�
����	2��Ϣ 1���� 1����
����	3��Ϣ 1��Ѫ

����ǰ������������, ��Ȼ���ֳ��ɲ����, ������ͷ�ʱ���е����⵼���еĴ�ѭ����1�μ�ʸ����, ��ѭ������̫��ʵս���ٴ�����������
--]]

load("Macro/Lib_PVP.lua")

--�ر��Զ�����
setglobal("�Զ�����", false)

--��ѡ��
addopt("����������", false)

--������
local v = {}
v["�����Ϣ"] = true
v["ûʯ����"] = 0

--������
local f = {}

local counter = {
    killed = 16,
    max = 16;

    increment = function(self)
        self.killed = self.killed + 1
    end,

    start = function(self)
        self.killed = 0
    end,

    stop = function(self)
        self.killed = self.max
    end,

    running = function(self)
        self.killed = self.killed + 1
        return self.killed <= self.max
    end
}

local count = 0;

--��ѭ��
function Main()
    --if life() < 0.1 then
    --    clickButton("Topmost/RevivePanel/WndContainer_BtnList/Btn_Cancel/")
    --end
    --local nid = npc("����:����")
    --if nid ~= 0 then
    --    turn()
    --    if xdis(nid) > 20 then
    --        moveto(xpos(nid))
    --    end
    --
    --    if notarget() then
    --        settar(nid)
    --    end
    --end

    --cast("��ʧ")
    cast(35894)
    if casting("�����") and castleft() < 0.13 then
        settimer("����ض�������")
    end
    if gettimer("����ض�������") < 0.3 then
        return
    end

    --Ӧ������
    if fight() and life() < 0.25 then
        cast("Ӧ������")
    end

    count = count + 1
    if count % 2 ~= 0 then
        --return
    end

    --��ʼ������
    v["����"] = rage()
    v["����ӡ"] = beast()

    v["����CD"] = scdtime("�����")
    v["����CD"] = scdtime("��������")
    v["���ڳ��ܴ���"] = cn("���ڼ�׹")
    v["���ڳ���ʱ��"] = cntime("���ڼ�׹", true)
    v["����CD"] = scdtime("���绽��")
    v["����CD"] = scdtime("������Ұ")
    v["����CD"] = scdtime("�������")

    v["��������"] = buffsn("����")
    v["����ʱ��"] = bufftime("����")
    v["�ᴩ����"] = tbuffsn("�ᴩ", id())
    v["�ᴩʱ��"] = tbufftime("�ᴩ", id())
    v["��������"] = tbuffsn("����")
    v["����ʱ��"] = tbufftime("����", id())
    v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10

    if tbuff("ȵ̤֦|ն�޳�|����|��ɽ��|�Ϸ��¹�") then
        return
    end
    --��������
    if v["����"] < 8 then
        if nofight() then
            --û��ս�Ѽ�װ��
            CastX("��������")
        end

        if v["����"] < 1 then
            --û����װ��, �Զ�װ�����GCD��1֡, �Լ�װ, ������ҲûӰ��, �����˻��ܿ�1֡
            CastX("��������")
        end
    end

    if v["����"] >= 5 then
        v["���һ֧��״̬"] = arrow(0)
        if v["���һ֧��״̬"] ~= 3 and v["���һ֧��״̬"] ~= 4 then
            --if v["����ӡ"] ~= 1 then
                --���һ֧��û����
                CastX("���Ҿ���")
            --end
        end
    end

    --���ڼ�׹
    if v["����"] >= 8 then
        --��������
        if rela("�ж�") and dis() < 30 then
            v["���һ֧��״̬"] = arrow(0)
            if v["���һ֧��״̬"] ~= 2 and v["���һ֧��״̬"] ~= 4 then
                --���һ֧��û����
                if v["����ӡ"] ~= 1 or v["���ڳ��ܴ���"] >= 2 then
                    CastX("���ڼ�׹")
                end

                if not qixue("����") then
                    CastX("���ڼ�׹")
                end
            end

            if v["���ڳ��ܴ���"] >= 3 and bufftime("����") < 0 and v["����CD"] < 1 then
                --��������û˲��
                CastX("���ڼ�׹")
            end
        end
    end

    if nofight() or notarget() and tlife() <= 0 or tbuff("ն�޳�") then
        return
    end

    if qixue("����") or qixue("ף��") and fight() then
        if qixue("����") and v["����ӡ"] >= 3 then
            if v["����"] < 8 then
                CastX("��������")
            end
            CastX("�������")
        end
        if v["����ӡ"] >= 4 then
            if v["����"] < 8 then
                CastX("��������")
            end
            CastX("�������")
        end

        if buff("����") then
            if v["����"] < 8 then
                --cast("��������")
                cast(35974)
            end
            if dis() < 10 then
                if scdtime("�۳���") == 0 and dis() < 10 then
                    if CastX("�۳���") then

                    end
                end
                if scdtime("��ɽ�") == 0 and dis() < 6 then
                    if CastX("��ɽ�") then

                    end
                end
            end

            if CastX(35688) then

            end
            return
        end

        if not qixue("����") then
            if v["����ӡ"] == 1 then
                --cast("������Ұ")
                CastX(35696)
            end
        else
            if v["����ӡ"] == 0 then
                CastX(35696)
            end
        end
    end

    --���绽��, ��Ŀ��Ľ�ɫ�������20�������Լ�������
    if fight() and rela("�ж�") and dis3() < 20 then
        CastX("���绽��")
    end

    if qixue("����") and fight() then
        if v["����ӡ"] == 0 then
            --if not nextbeast("Ұ��") and not beast("Ұ��") then
            --    --ֻ��ӥ
            --    setbeast({ "Ұ��", "��", "��", "ӥ", "��", "����" })
            --end

            if scdtime("���绽��") < 5 then
                CastX("������Ұ")
            end
        end

        if v["����ӡ"] == 1 then
            --if not nextbeast("��") and  not beast("��") then
            --    --ֻ��ӥ
            --    setbeast({ "��", "Ұ��", "ӥ", "��", "��", "����" })
            --end

            if v["����ӡ"] == 1 and scdtime("���绽��") > 2 then
                CastX("������Ұ")
            end
        end

        if v["����ӡ"] >= 2 and dis() > 0 and dis() < 30 then
            if (scdtime("������Ұ") < 43 and scdtime("������Ұ") > 0) or bufftime("����") < 3 then
                CastX("�������")
            end
        end
    end

    if buff("�������") then
        if v["����"] >= 2 then
            CastX("�ڷ�����")
        end
        CastX("�����")
        return
    end

    if v["����"] >= 3 then

        if buff("26861") then
            CastX("�ڷ�����")
        end

        --ûʯ����
        if buff("26862") then
            CastX("ûʯ����")
        end
    end

    if buff("����") then
        if tlife() < 0.4 then
            CastX("�����")
        end

        if v["����"] == 8 then
            CastX("�����")
        end
    end
    if v["����"] == 4 or v["����"] == 8 then
        CastX("�����")
    end
    CastX("�����")

end

-------------------------------------------------------------------------------

--�����Ϣ
function PrintInfo(s)
    local t = {}
    if s then
        t[#t + 1] = s
    end
    t[#t + 1] = "����:" .. v["����"]
    t[#t + 1] = "����:" .. mana()
    --t[#t+1] = "����ӡ:"..v["����ӡ"]

    t[#t + 1] = "����:" .. v["��������"] .. ", " .. v["����ʱ��"]
    t[#t + 1] = "�ᴩ:" .. v["�ᴩ����"] .. ", " .. v["�ᴩʱ��"]
    t[#t + 1] = "����:" .. v["��������"] .. ", " .. v["����ʱ��"]

    t[#t + 1] = "����CD:" .. v["����CD"]
    t[#t + 1] = "����CD:" .. v["����CD"]
    t[#t + 1] = "����CD:" .. v["����CD"]
    --t[#t+1] = "����CD:"..v["����CD"]
    t[#t + 1] = "����CD:" .. v["����CD"]
    t[#t + 1] = "����CD:" .. v["���ڳ��ܴ���"] .. ", " .. v["���ڳ���ʱ��"]

    print(table.concat(t, ", "))
end

--ʹ�ü��ܲ������Ϣ
function CastX(szSkill, bSelf)
    if cast(szSkill, bSelf) then
        settimer(szSkill)
        print(szSkill)
        if v["�����Ϣ"] then
            PrintInfo()
        end
        return true
    end
    return false
end

-------------------------------------------------------------------------------

--�ͷż���
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
    if CasterID == id() then
        if SkillID == 35665 then
            --ûʯ����
            v["ûʯ����"] = 0
            settimer("�ͷ�ûʯ����")
        end

        if SkillID == 35987 then
            --ûʯÿ���Ӽ���
            v["ûʯ����"] = v["ûʯ����"] + 1
        end

        if SkillID == 36165 then
            print("----------��ʸ����")
        end

        if SkillID == 35695 then
            --���绽��
            settimer("�ͷ����绽��")
        end

        if SkillID == 35669 then
            --��������
            settimer("�ͷź�������")
            print("----------------------------------------������������")
        end

        if SkillID == 35661 then
            --�����
            deltimer("����ض�������")
        end
    end
end

--ս��״̬�ı�, ��־��¼һ�����ڷ�������
function OnFight(bFight)
    if bFight then
        print("--------------------����ս��")
    else
        print("--------------------�뿪ս��")
    end
end
