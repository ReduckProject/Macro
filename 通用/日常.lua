load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")
load("Macro/Lib_PVX.lua")

local f = {}
local goodsExchangeCount = 0
function Main()
    local map = map();

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


