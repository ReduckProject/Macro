--[[ ��Ѩ: [��ָ �� ����][��ϼ �� ��Ϣ][���� �� �»� �� ����][���� �� ����ָ][΢��][����][����][���� �� ����][���� �� ��ĩ][����][ң��][�����޻�]
�ؼ�:
��¥  2��Ϣ 1���� 1����
����  2���� 1��Ч 1��ī��
����  1���� 1���� 2��Ч
����  1���� 3����

��Ѩ�ؼ�ֻ���Ƽ�����Ҳ��̫���棬�����������Լ����ŵ�
�����Ҫ��ϵ�[����ָ], ������ѡ���еĴ��
û�����������ǰĿ��һֱѡ��boss������
--]]

--��ѡ��
addopt("���", false)

--������
local v = {
    id = nil,
    xid = nil
}
v["��¼��Ϣ"] = true

--������
local f = {}
local mount_hps = {}
mount_hps["�����ľ�"]=true
mount_hps["�����"]=true
mount_hps["�뾭�׵�"]=true
mount_hps["��֪"]=true
mount_hps["����"]=true
--"�����ľ�|�����|�뾭�׵�|��֪|����"

local mount_neigong = {}
--"��ϼ��|̫�齣��|Ī��|������|���ľ�|̫����|�޷�"
mount_neigong["��ϼ��"]= true
mount_neigong["̫�齣��"]=true
mount_neigong["Ī��"]=true
mount_neigong["������"]=true
mount_neigong["���ľ�"]=true
mount_neigong["̫����"]=true
mount_neigong["�޷�"]=true

--��ѭ��
function Main()
    if target("player") and v.id == nil then
        local tid = tid()
        if xrela("�ж�", tid) then
            local mountname = xmountname(tid)
            if mount_hps[mountname] or mount_neigong[mountname] then
                v.id = tid
                print("��ע��"..v.id)
            end
        end
    end

	if v.id == nil then
		return
	end

    local dis = xdis(v.id)
    if dis > 0 and dis < 20 and xbuffstate("�ɴ��", v.id) and cdtime("����ָ") == 0 then
        v.xid = tid()
        settar(v.id)
        if tcastprog() > 0.3 or tcastpass() > 0.5 or tcastleft() < 0.3 then
            xcast("����ָ", v.id)
        end
        settar(v.xid)
    end

    if dis > 60 or dis == 0 then
        v.id = nil
		print("dis="..dis.."����")
    end
end

-------------------------------------------------------------------------------

f["��ȡ����Ŀ��"] = function()
    local targetID = id()    --����Ŀ��������Ϊ�Լ�, ���ڶ�������Ŷ���ʱ party ���� 0
    local partyID = party("û״̬:����", "�����Լ�", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����")    --��ȡѪ�����ٶ���
    if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then
        --��Ѫ�����ٶ����ұ��Լ�Ѫ����
        targetID = partyID    --����ָ��Ϊ����Ŀ��
    end
    return targetID
end

--��¼��Ϣ
function PrintInfo(s)
    local t = {}
    if s then
        t[#t + 1] = s
    end
    t[#t + 1] = "ī��:" .. v["ī��"]
    t[#t + 1] = "����Ŀ��:" .. v["����Ŀ��"]
    t[#t + 1] = "����Ŀ��Ѫ��:" .. format("%0.2f", v["����Ŀ��Ѫ��"])
    print(table.concat(t, ", "))
end

--������Ŀ��ʹ�ü���
function CastX(szSkill)
    if xcast(szSkill, v["����Ŀ��"]) then
        if v["��¼��Ϣ"] then
            PrintInfo()
        end
        return true
    end
    return false
end
