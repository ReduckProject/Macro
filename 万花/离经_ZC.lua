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

load("Macro/Lib_Coordinates.lua")
load("Macro/Lib_Base.lua")
load("Macro/Lib_PVP.lua")
--��ѡ��
addopt("���", false)

--������
local v = {}
v["��¼��Ϣ"] = true

--������
local f = {}

local x, y, z = pos()

v["��ܽ��Ŀ��"] = 0
addopt("Ŀ������", false)
addopt("������", false)
--��ѭ��
function Main()
    --if life() < 0.1 then
    --	clickButton("Topmost/RevivePanel/WndContainer_BtnList/Btn_Cancel/")
    --end
    --local nid = npc("����:����")
    --if nid ~= 0 then
    --	turn()
    --	if xdis(nid) > 4 then
    --		moveto(xpos(nid))
    --	end
    --
    --	if notarget() then
    --		settar(nid)
    --	end
    --end

    --�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
    if keydown(1) then
        cast("��ҡֱ��")
    end

    local x1, y1, z1 = g_func["С�Ṧ"]()

    if buff("չ��") then
        bigtext("չ�� ��Ҫ��")
    end
    if nofight and nobuff("���ľ���") then
        cast("���ľ���")
    end

    if getopt("������") then
        nid = player("��ѡ��", "���߿ɴ�", "��ϵ:�ж�", "����<60", "�Ƕ�<10")
        if nid ~= 0 then
            x, y, z = xpos(nid)
            moveto(x, y, z)
            return
        end
    end

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

    if bufftime("��������") > 9 and bufftime("����ع��") > 9 then
        if buff("ܽ�ز���") then
            if CastX("̫��ָ") then
                return
            end
        end

        if nobuff("����") and bufftime("ܽ�ز���") < 4.8 then
            CastX("��¥��Ӱ")
        end
    end

    g_base["����������"]("��¥��Ӱ")

    --if buff("������Ů")
    if bufftime("���Զ���") > 2 and bufftime("���Զ���") < 4.6 then
        if nobuff("����") and scdtime("̫��ָ") == 0 then
            CastX("̫��ָ")
        else
            cast("��")
        end
    end

    if tbufftime("����") > 3 and tlife() < 0.8 then
        cast("���໤��")
    end

    if buff("�ϻ��") then
        local srcid = buffsrc("�ϻ��")
        local cid = tid()
        settar(srcid)
        if scdtime("��԰") < 2 then
            if srcid ~= 0 and (tbufftime("�۳�", srcid) > 0 or tbuff("����")) and xdis(srcid) < 8 then
                xcast("��԰", srcid)
            end
        else
            CastX("̫��ָ")
        end

        settar(cid)
    end

    if buff("����") then
        local srcid = buffsrc("����")
        local cid = tid()
        settar(srcid)

        if srcid ~= 0 and (tbufftime("�۳�", srcid) > 0 or tbuff("����")) and xdis(srcid) < 8 then
            xcast("��԰", srcid)
        end
        --settar(cid)
    end

    if buff("������ȱ") then
        if not cast("��¥��Ӱ") and nobuff("��¥��Ӱ") then
            if not cast("ˮ���޼�") and nobuff("ˮ���޼�") then
                cast("���໤��", true)
            end
        end
    end

    --����
    if fight() and life() < 0.44 then
        if nobuff("����") then
            cast("��¥��Ӱ")
        else
            if life() < 0.35 then
                cast("��¥��Ӱ")
            end
        end
    end

    if target() and scdtime("����ָ") == 0 then
        --���
        if getopt("���") and tbuffstate("�ɴ��") then
            CastX("����ָ")
        end

        --local rank =  player("û״̬:����", "��ϵ:�ж�", "����:���ǹ���|��̫��|��������|��ѩƮҡ|����|����|�������|��������|����ǣ˿|�춷��|������|�������|ɱ����β|ƽɳ����|��������|�乬|����|Ц������|�����ả|��ˮ��Ӱ|��������|���ƺ���|�ന���|��������|�Ҵ�ʱ��|����ع��|����ع��|�ùⲽ", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����")
        --if rank ~= 0 and rank == tid() then
        --	if xcastprog(rank ) > 0.3 or xcastpass(rank) > 0.5 or xcastleft(rank) < 0.3 then
        --		CastX("����ָ")
        --	end
        --end

        if tcasting("���ǹ���|��̫��|������|�����|�����ֻ�|��������|���϶���|��ѩƮҡ|����|����|����|�������|��������|����ǣ˿|�춷��|������|������|�������|ɱ����β|ƽɳ����|��ˮ��Ӱ|��������|�乬|��|��|����|Ц������|�����ả|��ˮ��Ӱ|��|��������|���ƺ���|�ന���|��������|�Լ�����|��½׺��|���Ƕϳ�|�Ҵ�ʱ��|��������|����ع��|����ָ|�ùⲽ|�γ۳�") then

            if tcasting("��ѩƮҡ|�������") then
                if tcastprog() > 0.2 or tcastpass() > 0.3 or tcastleft() < 0.3 then
                    stopcasting()
                    CastX("����ָ")
                end
            end
            if tcastprog() > 0.4 or tcastpass() > 0.5 or tcastleft() < 0.3 then
                stopcasting()
                CastX("����ָ")
            end
        end
    end

    if buff("��η����|����ʽ|���Զ���") then
        if nobuff("����") then
            CastX("̫��ָ")
        end

        if bufftime("��η����") > 2.5 then
            cast("��")
        end

        cast("��ҡֱ��")
    end

    --��ʼ������
    v["ī��"] = rage()
    v["������"] = charinfo("������")    --����뾫ȷ���ƣ������� * ����ϵ�� = ����ʵ�ʼ�Ѫ��
    v["����Ŀ��"] = f["��ȡ����Ŀ��"]()
    v["����Ŀ��Ѫ��"] = xlife(v["����Ŀ��"])
    v["����Ŀ����T"] = xmount("ϴ�辭|������|����������|������", v["����Ŀ��"])

    if v["��ܽ��Ŀ��"] ~= 0 and v["��ܽ��Ŀ��"] ~= id() then
        settar(v["����Ŀ��"])
        v["����Ŀ��"] = v["��ܽ��Ŀ��"]
    end

    if tbufftime("��������") > 9 and tbufftime("����ع��") > 9 then
        if tbuff("ܽ�ز���") then
            v["����Ŀ��"] = tid()
            if tnobuff("���໤��|����|��ɽ��|����ɽ|Х�绢|��ˮ��|��صͰ�") then
                if tnobuff("����") then
                    if scdtime("���໤��") > 0 then
                        CastX("����")
                    else
                        CastX("���໤��")
                    end
                end
            end

        end
    else
        v["��ܽ��Ŀ��"] = 0
    end

    if tid() ~= v["����Ŀ��"] and id() ~= v["����Ŀ��"] then
        if (not rela("�ж�")) and v["����Ŀ��Ѫ��"] < 0.8 then
            settar(v["����Ŀ��"])
        end
    end

    ---------------------------------------------
    if fight() then
        if v["����Ŀ��Ѫ��"] < 0.6 then
            CastX("���໤��")
        end

        --����
        if v["����Ŀ��Ѫ��"] < 0.35 then
            CastX("���紵ѩ")
        end
    end

    if v["����Ŀ��Ѫ��"] < 0.8 then
        if buff("412|722|932|3458|6266") then
            --��˲��
            CastX("����")
        end
    end

    --����
    if v["����Ŀ��Ѫ��"] < 0.45 then
        --ˮ��
        if fight() and v["ī��"] < 20 then
            cast("ˮ���޼�")
        end

        if buff("412|722|932|3458|6266") then
            --��˲��
            CastX("����")
        end
    end

    if v["����Ŀ��Ѫ��"] < 0.35 then
        --��Ѫ
        CastX("����")
    end
    --����

    --����
    if v["����Ŀ��Ѫ��"] < 0.9 then
        --��Ѫ
        CastX("����")
    end

    if v["ī��"] < 30 then
        --ˢī��
        CastX("����")
    end

    --����
    if rela("�ж�") and ttid() ~= 0 and xrela("�Լ�|�Ѻ�|����", ttid()) then
        --Ŀ���Ŀ�� boss��Ŀ�����ʾ�����һ��Ҫ�̵���
        if xbufftime("����", ttid(), id()) < 3 then
            xcast("����", ttid())
        end
    end

    --��ˮ
    if fight() and mana() < 0.45 then
        cast("��ˮ����", true)
    end

    --����
    if fight() and target("boss") and face() < 80 and qixue("����") and tbufftime("����") < 3 then
        cast("����ָ")
    end

    -- ����
    xcast("����", party("û״̬:����", "����<20", "���߿ɴ�", "�ҵ�buffʱ��:����<3"))

    --��ս����
    if casting("����") and castleft() < 0.13 then
        settimer("�����������")
    end

    if nofight() and not jjc() and gettimer("�����������") > 0.5 then
        xcast("����", party("��״̬:����", "����<20", "���߿ɴ�"))
    end

    if fight() then
        cast("��ҡֱ��")
    end
end

-------------------------------------------------------------------------------

f["��ȡ����Ŀ��"] = function()
    if getopt("Ŀ������") then
        if target() and tlife() < life() then
            return tid();
        else
            return id()
        end
    end

    local targetID = id()   --����Ŀ��������Ϊ�Լ�, ���ڶ�������Ŷ���ʱ party ���� 0
    local partyID = party("û״̬:����", "�����Լ�", "����<24", "���߿ɴ�", "û�ؾ�", "��Ѫ����")    --��ȡѪ�����ٶ���

    if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then
        --��Ѫ�����ٶ����ұ��Լ�Ѫ����
        targetID = partyID    --����ָ��Ϊ����Ŀ��
    else
        if life() > 0.95 then
            if xrela("�Ѻ�", tid()) and tid() > 0 and tlife() < 0.95 then
                targetID = tid()
            else
                --targetID = player("û״̬:����", "ͬ��Ӫ", "�����Լ�", "����<24", "���߿ɴ�", "û�ؾ�", "��Ѫ����")
            end
        end

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
    local success = g_func["�ж��ͷ�"](szSkill)
    if success then
        return success
    end
    if xcast(szSkill, v["����Ŀ��"]) then
        if v["��¼��Ϣ"] then
            PrintInfo()
        end
        return true
    end
    return false
end

--
function OnCast(CasterID, SkillName, SkillID, SkillLevel, TargetType, TargetID, PosY, PosZ, StartFrame, FrameCount)
    if jjc() then
        if SkillName == "ܽ�ز���" and xrela("�ж�", CasterID) then
            v["��ܽ��Ŀ��"] = TargetID
        end

        if SkillName == "����Χ" and xrela("�ж�", CasterID) then

        end
    end


end