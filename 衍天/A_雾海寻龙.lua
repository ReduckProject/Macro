--��Ѩ: [ˮӯ][����][˳ף][������][��ɽ][���][ب��][����][����][����][����][����]

--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}

--������
local f = {}

local counter = 0
--��ѭ��
function Main(g_player)

    --nid = player("����:����Ψ�Ҷ���|���˾�࣡�Ψ�Ҷ���")
    --nid = player("����:���˾�࣡�Ψ�Ҷ���")
    --nid = player("����:����ī��Ǭ��һ��")
    --if nid ~=0 then
    --    settar(nid)
    --end
    if castleft() > 0 then
        return
    end

    f["�жԸ���㴦��"]()
    f["��Ѫ������"](0.6)
    f["���̴���"]()

    if dengcount() < 1 then
        return
    end

    if target() and xrela("�ж�", tid()) then
        if tbuffstate("����") then
            g_func["�ж��ͷ�"]("��ת����")
        end
    end

    if cdtime("��ת����") > 33 then
        if cdtime("̤����") == 0 then
            --settar(id())
            g_func["�ж��ͷ�"]("̤����")
        end
    end

    if cdtime("��ת����") < 4 and not state("����") then
        if notarget() or dis() > 25 then
            f["ѡ�ж�תĿ��"]()
        else
            counter = counter + 1
            if counter ~= 16 then
                counter = 0
                f["ѡ�ж�תĿ��"]()
                return
            end
        end
    end
end

f["ѡ�ж�תĿ��"] = function()
    if cdtime("��ת����") == 0 then
        nid = player("��ѡ��", "���߿ɴ�", "�ڹ�:Ц����|̫����|��Ӱʥ��|��ϼ��", "�Լ�����", "�����Լ�", "��ϵ:�ж�", "����<34")
        if nid == 0 then
            nid = player("��ѡ��", "���߿ɴ�", "�Լ�����", "�����Լ�", "��ϵ:�ж�", "����<34")
        end
        if nid ~= 0 then
            if xbuffstate("����", nid) then
                settar(nid)
            end

        end
    end
end

f["�жԸ���㴦��"] = function()
    --local nid = npc("����:�������", "��ɫ����<6")
    local nid = npc("����:�������|ѩħ����", "��ɫ����<6", "��ϵ:�ж�")
    if nid ~= 0 and xrela("�ж�", nid) then
        if cdtime("�������" == 0) then
            --settar(id())
            cast("�������")
        end
        g_func["�ж��ͷ�"]("���ű���")
        g_func["�ж��ͷ�"]("���վ���")
        g_func["�ж��ͷ�"]("̤����")
    end
end

f["��Ѫ������"] = function(_life)
    if _life == nil then
        _life = 0.6
    end
    pid = player("��ϵ:�ж�", "�Լ�����<18")

    if life() < _life and pid ~= 0 then
        g_func["�ж��ͷ�"]("���ű���")
        g_func["�ж��ͷ�"]("���վ���")
        if cdtime("�������" == 0) then
            --settar(id())
            cast("�������")
        end
        g_func["�ж��ͷ�"]("̤����")
    end
end

f["���̴���"] = function()
    pid = player("��ϵ:�ж�", "�ڹ�:��Ӱʥ��", "�Լ�����<4")
    if pid ~= nil and xrela("�ж�") then
        output("���̴���")
        g_func["�ж��ͷ�"]("���ű���")
        if cdtime("�������" == 0) then
            --settar(id())
            cast("�������")
        end
        g_func["�ж��ͷ�"]("���վ���")
        g_func["�ж��ͷ�"]("̤����")
    end
end

f["���ڴ���"] = function()

end