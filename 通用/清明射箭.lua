local exist = {}
function Main()
    if nobuff("��������") then
        exist = {}
        return
    end

    if casting("���ֹ���") then
        return
    end

    local nid = npc("����:��֦������|��֦������", "����<55", "�������")
    if nid ~= 0 and not exist[nid] then
        settar(nid)
        if xcast(19126, nid) then
            exist[nid] = true
        end
    end

    nid = npc("����:������", "����<10", "�������")

    if nid ~= 0 and not exist[nid] then
        settar(nid)
        if xcast(19103, nid) then
            exist[nid] = true
            return
        end
    end
end


