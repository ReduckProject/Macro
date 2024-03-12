--[[ 奇穴: [弹指 或 竭泽][烟霞 或 生息][青律 或 月华 或 秋肃][清疏 或 厥阴指][微潮][积势][书离][渐催 或 池月][寒清 或 锋末][清神][遥归][落子无悔]
秘籍:
星楼  2调息 1消耗 1减伤
提针  2读条 1疗效 1回墨意
长针  1消耗 1距离 2疗效
商阳  1距离 3消耗

奇穴秘籍只是推荐，我也不太会玩，你是老手你自己看着点
如果需要打断点[厥阴指], 开启宏选项中的打断
没有特殊情况当前目标一直选中boss就行了
--]]

--宏选项
addopt("打断", false)

--变量表
local v = {
    id = nil,
    xid = nil
}
v["记录信息"] = true

--函数表
local f = {}
local mount_hps = {}
mount_hps["云裳心经"]=true
mount_hps["补天诀"]=true
mount_hps["离经易道"]=true
mount_hps["相知"]=true
mount_hps["灵素"]=true
--"云裳心经|补天诀|离经易道|相知|灵素"

local mount_neigong = {}
--"紫霞功|太虚剑意|莫问|花间游|冰心诀|太玄经|无方"
mount_neigong["紫霞功"]= true
mount_neigong["太虚剑意"]=true
mount_neigong["莫问"]=true
mount_neigong["花间游"]=true
mount_neigong["冰心诀"]=true
mount_neigong["太玄经"]=true
mount_neigong["无方"]=true

--主循环
function Main()
    if target("player") and v.id == nil then
        local tid = tid()
        if xrela("敌对", tid) then
            local mountname = xmountname(tid)
            if mount_hps[mountname] or mount_neigong[mountname] then
                v.id = tid
                print("关注："..v.id)
            end
        end
    end

	if v.id == nil then
		return
	end

    local dis = xdis(v.id)
    if dis > 0 and dis < 20 and xbuffstate("可打断", v.id) and cdtime("厥阴指") == 0 then
        v.xid = tid()
        settar(v.id)
        if tcastprog() > 0.3 or tcastpass() > 0.5 or tcastleft() < 0.3 then
            xcast("厥阴指", v.id)
        end
        settar(v.xid)
    end

    if dis > 60 or dis == 0 then
        v.id = nil
		print("dis="..dis.."重置")
    end
end

-------------------------------------------------------------------------------

f["获取治疗目标"] = function()
    local targetID = id()    --治疗目标先设置为自己, 不在队伍或者团队中时 party 返回 0
    local partyID = party("没状态:重伤", "不是自己", "距离<20", "视线可达", "没载具", "气血最少")    --获取血量最少队友
    if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then
        --有血量最少队友且比自己血量少
        targetID = partyID    --把他指定为治疗目标
    end
    return targetID
end

--记录信息
function PrintInfo(s)
    local t = {}
    if s then
        t[#t + 1] = s
    end
    t[#t + 1] = "墨意:" .. v["墨意"]
    t[#t + 1] = "治疗目标:" .. v["治疗目标"]
    t[#t + 1] = "治疗目标血量:" .. format("%0.2f", v["治疗目标血量"])
    print(table.concat(t, ", "))
end

--对治疗目标使用技能
function CastX(szSkill)
    if xcast(szSkill, v["治疗目标"]) then
        if v["记录信息"] then
            PrintInfo()
        end
        return true
    end
    return false
end
