local exist = {}
function Main()
    if nobuff("清明射柳") then
        exist = {}
        return
    end

    if casting("穿林贯天") then
        return
    end

    local nid = npc("名字:柳枝孔明灯|桃枝孔明灯", "距离<55", "距离最近")
    if nid ~= 0 and not exist[nid] then
        settar(nid)
        if xcast(19126, nid) then
            exist[nid] = true
        end
    end

    nid = npc("名字:孔明灯", "距离<10", "距离最近")

    if nid ~= 0 and not exist[nid] then
        settar(nid)
        if xcast(19103, nid) then
            exist[nid] = true
            return
        end
    end
end


