load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")
load("Macro/Lib_PVX.lua")
load("Macro/Lib_Tools.lua")


--addopt("�������Զ�����", false)
local timer = 0
local timer2 = 0
local f = {}
local goodsExchangeCount = 0

local timer3 = 0
function Main()
    local map = map();
    --��ǧ��
    clickButton("Topmost/MB_PlayerMessageBoxCommon/Wnd_All/Btn_Option1/")
    --�����ͼ
    timer2 = timer2 + 1
    if timer2 > 32 then
        clickButton("Normal/SwitchServerDLC/Wnd_Total/PageSet_Total/Page_QLFZ/WndContainer_LKS/Btn_EnterMap/")
        timer2 = 0
    end
    -- ȷ�Ͻ����ÿ�ɽ
    clickButton("Topmost/MB_msg_enter_map/Wnd_All/Btn_Option1/")
    -- ȷ����������
    clickButton("Topmost1/TrafficSure/Wnd_EasyTraffic/Wnd_TrafficSkill/Btn_SureGO2/")
    if map ~= "������" and map ~= "���Ż�Į" then
        if nobuff("�ݵ�ó��") then
            --���й�ͼȷ��
            clickButton("Topmost2/MB_SkillTraffic/Wnd_All/Btn_Option1/")
            timer = timer + 1
            if timer > 200 then
                if map ~= "������ÿ�ɽ" and goodsExchangeCount == 0 then
                    --actionclick(2, 16)
                end
                timer = 0
            end
        end
    else
        if nobuff("�ݵ�ó��") and goodsExchangeCount == 0 then
            clickButton("Topmost1/WorldMap/Btn_Close/")
        end
    end
    --����
    clickButton("Normal1/FriendPraise1/")
    if map == "������ÿ�ɽ" then
        timer3 = timer3 + 1
        --�뿪�ÿ�ɽȷ��
        --clickButton("Topmost/MB_LeavePVP/Wnd_All/Btn_Option1/")
        if timer3 > 100 then
            if autoMove(g_map["�����ÿ�ɽ���"], false) then
                if buff("����") then
                    cast(54)
                end
            end
        end
    end

    if map == "������ÿ�ɽ" or map == "������" or map == "����ɽ" or map == "����" or map == "����ɽ" then
        g_base["�ɼ�"]()
    end



    if map == "������" then
        g_base["ɱ��"]()
    end

    if map == "������" or map == "���Ż�Į" or map == "������" or map == "���" then
        if goodsExchangeCount < 3 then
            clickButton("Topmost/MB_on_switch_map_sure/Wnd_All/Btn_Option1/")
            clickButton("Normal/OldQuestAcceptPanel/Btn_Sure/")
            local nid = npc("����:�ݵ��ܹ�", "��ɫ����<8")
            if nid ~= 0 then
                interact(nid)
                dialog("�ݵ�ó�ף����˹�")
            end

            --if buff("����") then
            --    cast(54)
            --end

            if buff("�ݵ�ó��") and nobuff("����") then
                cast(53)
                return
            end

            g_map_move["�ƶ�"]()
        end
    end

    if map == "������" then
        if nobuff("�ݵ�ó��") then
            autoMove(g_map["���������е㵽�̵�"], false)
        end
    end

    if map == "��Ҷ������Է" or map == "������" or map == "������" then
        g_pvx["����"]()
    end
end



function OnMessage(szMsg, szType)
    --output(szMsg)
    if szMsg.find(szMsg,"���������") and szMsg.find(szMsg,"�ݵ�ó��") then
        goodsExchangeCount = goodsExchangeCount + 1
    end
end


