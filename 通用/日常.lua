load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")

local f = {}
function Main()
    --print(g_map_move.moveToNpc, g_map_move.currentStep, g_map_move.coordinateLength, g_map_move.currentMap, g_map_move.currentGoods)

    if nofight() then
        local map = map();

        if map == "������ÿ�ɽ" or map == "������" or map == "����ɽ" or map == "����" or map == "����ɽ" then
            g_base["�ɼ�"]()
        end

        if map == "������" then
            g_base["ɱ��"]()
        end

        if map == "������" or map == "���Ż�Į" or map == "������" or map == "���" then
            g_map_move["�ƶ�"]()
        end
    end

    f["������è"]()
end

local counter = 0
f["������è"] = function()
    if map() ~= "��ƽ��" then
        return
    end

    local boss_npc = npc("����:�������ϰ�")
    if boss_npc ~= 0 then
        if counter == 10 then
            if not interact() then
                counter = 0
                return
            end
        end

        if counter == 20 then
            if not dialog("����") then
                counter = 0
                return
            end
        end

        if counter == 30 then
            if not dialog("������è  �����") then
                counter = 0
                return
            end
        end

        counter = counter + 1

        if counter > 200 then
            counter = 0
        end
    end

    local nid = npc("ģ��ID:126758", "����<30", "�Ƕ�<30", "�������")
    if nid > 0 then
        cast(37436)
        moveto(xpos(nid))
    end
end

