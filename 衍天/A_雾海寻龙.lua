--��Ѩ: [ˮӯ][����][˳ף][������][��ɽ][���][ب��][����][����][����][����][����]

--�����
load("Macro/Lib_PVP.lua")

--������
local v = {}

--������
local f = {}

local counter = 0

f["�ǲ��"] = 537125194
--��ѭ��
function Main(g_player)

    if castleft() > 0 then
        return
    end

    if life() < 0.6 then
        g_func["�ж��ͷ�"]("���ű���")
        g_func["�ж��ͷ�"]("���վ���")
        g_func["�ж��ͷ�"]("�������")
        g_func["�ж��ͷ�"]("̤����")
    end

    local nid = npc("����:�������|ѩħ����", "��ɫ����<4")
    if nid ~= 0 and xrela("�ж�",  nid) then
		g_func["�ж��ͷ�"]("���ű���")
        if cdtime("̤����") == 0 then
            settar(id())
			g_func["�ж��ͷ�"]("�������")
			g_func["�ж��ͷ�"]("̤����")
			g_func["�ж��ͷ�"]("���վ���")
        end
    end

    if target() and tid() ~= id() and xrela("�ж�", tid()) then
		if dengcount() < 1 then
			return
		end
        if tbuffstate("����") then
            g_func["�ж��ͷ�"]("��ת����")
        --else
        --    settar(id())
        end
    end

    if cdtime("��ת����") > 33 then
        settar(id())
    end

    if cdtime("��ת����") > 33 then
        if cdtime("̤����") == 0 then
            g_func["�ж��ͷ�"]("̤����")
            settar(id())
        end
    end

    --counter = counter + 1
    --if counter ~= 5 then
    --	return
    --end
    --output("sss")
    --��ʼ��


    if cdtime("��ת����") == 0 then
        nid = player("��ѡ��", "���߿ɴ�", "�Լ�����", "�����Լ�", "��ϵ:�ж�", "����<24")

        if nid ~= 0 then
            if xbuffstate("����", nid) then
                settar(nid)
            end

        end
    end

    counter = 0
end

