load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")
load("Macro/Lib_PVX.lua")

local f = {}
function Main()
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

    if map == "��Ҷ������Է" or map == "������" or map == "������" then
        g_pvx["����"]()
    end
end


