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

    if castleft() > 0 then
        return
    end

    f["�жԸ���㴦��"]()
    f["��Ѫ������"](0.6)
    f["���̴���"]()

    if dengcount() > 0 and target() and xrela("�ж�", tid()) then
        if tbuffstate("����") then
            g_func["�ж��ͷ�"]("��ת����")
        end
    end

    if cdtime("��ת����") > 33 then
        if cdtime("̤����") == 0 then
            settar(id())
            g_func["�ж��ͷ�"]("̤����")
        end
    end


    if notarget() or tdis() > 25 then
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


f["ѡ�ж�תĿ��"] =  function()
    if cdtime("��ת����") == 0 then
        nid = player("��ѡ��", "���߿ɴ�", "�Լ�����", "�����Լ�", "��ϵ:�ж�", "����<24")

        if nid ~= 0 then
            if xbuffstate("����", nid) then
                settar(nid)
            end

        end
    end
end

f["�жԸ���㴦��"] =  function()
    local nid = npc("����:�������|ѩħ����", "��ɫ����<6")
    if nid ~= 0 and xrela("�ж�",  nid) then
        if cdtime("�������"  == 0) then
            settar(id())
            cast("�������")
        end
        g_func["�ж��ͷ�"]("���ű���")
        g_func["�ж��ͷ�"]("���վ���")
        g_func["�ж��ͷ�"]("̤����")
    end
end

f["��Ѫ������"] = function(_life)
    if _life == nil then
        _life  =  0.6
    end

    g_func["�ж��ͷ�"]("���ű���")
    g_func["�ж��ͷ�"]("���վ���")
    if cdtime("�������"  == 0) then
        settar(id())
        cast("�������")
    end
    g_func["�ж��ͷ�"]("̤����")
end

f["���̴���"]= function()
    pid = player("��ϵ:�ж�", "�ڹ�:��Ӱʥ��", "�Լ�����<4")
    if pid ~=nil  then
        g_func["�ж��ͷ�"]("���ű���")
        if cdtime("�������"  == 0) then
            settar(id())
            cast("�������")
        end
        g_func["�ж��ͷ�"]("���վ���")
        g_func["�ж��ͷ�"]("̤����")
    end
end

f["���ڴ���"]  = function()

end