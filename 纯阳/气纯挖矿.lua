output("��Ѩ: [����][�¹�����][��һ][��Ԫ][����][�Ͳ�][����][����][˪��][����][�ع�][����]")

--�����
load("Macro/Lib_PVP.lua")
load("Macro/Lib_Base.lua")

--������
local v = {}

--������
local f = {}

local counter = 0
local tx, ty, tz = 0

local pickCounter = 0
--��ѭ��
function Main(g_player)
    --��ʼ��
    g_func["��ʼ��"]()
    --if target() then
    --    tx, ty, tz = xpos(tid())
    --end
    --
    --if notarget() and tx > 0 then
    --    if moveto(tx, ty, tz) then
    --        tx, ty, tz = 0
    --        pickCounter = 0
    --    else
    --        return
    --    end
    --end
    --
    --pickCounter = pickCounter + 1
    --if pickCounter < 60 then
    --    return
    --end
    --
    --if nofight() then
    --    f["������"]()
    --end
    --
    --f["����"]()
    --ѡĿ��
    if notarget() then
        g_base["�л�Ŀ��"]()
    end


    --if dis(tid()) > 6 then
    --    moveto(xpos(tid()))
    --end
    --
    turn()

    if mana() < 0.05 then
        cast("����")
        return
    end

    if state("����") and mana() > 0.9 then
        jump()
    end
    --��ɽ��
    if fight() and life() < 0.5 and height() < 3 then
        if nobuff("��ɽ��") and gettimer("��ɽ��") > 1 then
            if cast("��ɽ��", true) then
                settimer("��ɽ��")
                stopmove()
            end
        end
    end

    --ƾ������
    if fight() and life() < 0.75 then
        cast("ƾ������")
    end

    --��������
    if rela("�ж�") and g_var["Ŀ��û����"] and dis() < 20 and qidian() <= 3 and qjcount() >= 5 and bufftime("����") > 10 then
        if nobuff("��������") and gettimer("��������") > 0.3 then
            if cast("��������") then
                settimer("��������")
            end
        end
    end

    --��̫��
    if nobuff("�Ʋ��") then
        cast("�Ʋ��")
    end

    --��������
    if nobuff("��������") then
        cast("��������")
    end

    if g_var["Ŀ��ɹ���"] then
        if qidian() >= 8 then
            cast("���ǻ���")
        end
    end

    if qjcount() < 5 then
        cast("��������")
    end

    if g_var["Ŀ��ɹ���"] then
        cast("�����ֻ�")
        cast("̫���޼�")
    end

    --�ɼ�������Ʒ
    if nofight() then
        g_func["�ɼ�"](g_player)
    end
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

local resetPos = {
    { 82466, 33577, 1109568 },
    { 83282, 34648, 1110976 },
    { 83760, 32929, 1110272 }
}
local index = 3

function OnFight(bFight)
    counter = 0;
    if index >= 3 then
        index = 1
    else
        index = index + 1
    end
end

f["����"] = function()
    local pickId = doodad("��ʰȡ", "����<20")
    if pickId ~= 0 then
        if moveto(xpos(pickId)) then
            interact(pickId)

        end
    end
    if notarget() and nofight() then
        moveto(resetPos[index][1], resetPos[index][2], resetPos[index][3])
    end
end

f["������"] = function()
    local doodadId = doodad("����:õ�廨��|ţ�ǻ���|��ޣ����|Ǿޱ����|ǣţ����|���򻨴�", "����<6", "�������")
    if counter == 10 then
        if doodadId ~= 0 then
            interact(doodadId)
        end
    end

    if counter > 30 then
        dialog("Ū������")
    end

    counter = counter + 1

    if counter > 100 then
        counter = 0
		print("Reset")
    end

end
