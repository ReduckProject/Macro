g_auto_play = {}
g_auto_play_f = {}
g_auto_play_v = {}

g_auto_play["��ϼ��"] = function()
    if fight() and life() < 0.5 and nobuff("��������") then
        cast("��������")
    end

    if casting("���϶���") and castleft() < 0.13 then
        settimer("���϶�������")
    end
    if casting("�Ʋ��") and castleft() < 0.13 then
        settimer("�Ʋ���������")
    end

    if casting("�����ֻ�") and castleft() < 0.13 then
        settimer("�ȴ�����ͬ��")
    end
    if gettimer("�ȴ�����ͬ��") < 0.3 then
        return
    end

    --��ʼ������
    g_auto_play_v["����"] = qidian()
    local tSpeedXY, tSpeedZ = speed(tid())
    g_auto_play_v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0        --Ŀ��û�ƶ�
    g_auto_play_v["�Ʋ�����"], g_auto_play_v["�Ʋ��ʱ��"] = qc("�����Ʋ��", id(), id())        --�Լ������Լ�������, �������Լ���������Ե�ľ��룬��Ȧ������������Ȧ���Ǹ���
    g_auto_play_v["Ŀ��λ���Լ�������"] = tnpc("��ϵ:�Լ�", "ģ��ID:58295", "ƽ�����<5")
    g_auto_play_v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 5    --Ŀ�굱ǰѪ�������Լ����Ѫ��5��


    --��ɽ��
    if qixue("����") then
        cast("��ɽ��", true)
    end

    --����
    if g_auto_play_v["Ŀ�꾲ֹ"] and g_auto_play_v["Ŀ��Ѫ���϶�"] and dis() < 20 then
        if g_auto_play_v["�Ʋ�����"] < -3 and g_auto_play_v["�Ʋ��ʱ��"] > 10 then
            if g_auto_play_v["Ŀ��λ���Լ�������"] ~= 0 and gettimer("�ͷ�����") < 2 then
                if cast("��������") then
                    cast("ƾ������")
                    settimer("��������")
                end
            end
        end
    end

    --����
    if qixue("����") and g_auto_play_v["Ŀ�꾲ֹ"] and dis() < 5 and face() < 60 and g_auto_play_f["û����"]() and scdtime("��������") > 5 and cdleft(16) >= 0.5 then
        if cast("���Ż���") then
            settimer("���Ż���")
        end
    end

    --����һ��
    if rela("�ж�") and dis() < 25 and qjcount() < 5 then
        cast(18640)
    end

    --�Ʋ��
    if rela("�ж�") and dis() < 25 and g_auto_play_v["�Ʋ�����"] > -1 then
        --û���Ʋ����߿��Ȧ��
        cast("�Ʋ��", true)
    end

    --��������
    if buff("12504|12783") then
        if bufftime("����") < 3.75 then
            cast(18654)
        end

        --[[��������ǰ�Ŷ���?
        if scdtime("���϶���") < cdinterval(16) and scdtime("��������") < cdinterval(16) * 2 then
            cast(18654)
        end
        --]]

        --[[���㲻�����ǣ�����һ��CDС��һ��GCD������Σ�ʵս�����Ƿ�������
        if gettimer("�ͷŷɽ�") < 1 and scdtime(18640) < cdinterval(16) and g_auto_play_v["����"] < 7 then
            cast(18654)
        end
        --]]
    end

    --����
    if gettimer("���϶�������") > 0.25 and g_auto_play_v["Ŀ�꾲ֹ"] then
        if scdtime("��������") < cdinterval(16) then
            if g_auto_play_v["�Ʋ�����"] < -3 and g_auto_play_v["�Ʋ��ʱ��"] > 12 then
                cast("���϶���")
            end
        end

        if scdtime("��������") > 10 then
            cast("���϶���")
        end
    end

    --����
    if g_auto_play_v["����"] >= 7 then
        cast("���ǻ���")
    end

    --���Ʋ��
    if rela("�ж�") and dis() < 25 and scdtime("���϶���") < cdinterval(16) and scdtime("��������") < cdinterval(16) * 2 and g_auto_play_v["�Ʋ��ʱ��"] < 12 then
        cast("�Ʋ��", true)
    end

    --������
    if fight() and mana() < 0.4 and state("վ��") then
        cast("������", true)
    end

    --����
    if gettimer("���϶�������") > 0.5 then
        if g_auto_play_f["������"]() then
            if g_auto_play_v["����"] < 5 then
                cast("�����ֻ�")
            end
        else
            cast("�����ֻ�")
        end
    end

    if nofight() and nobuff("��������") then
        cast("��������")
    end
end

g_auto_play_f["û����"] = function()
    if buff("��������") or gettimer("��������") < 0.5 or gettimer("���Ż���") < 0.5 then
        return false
    end
    return true
end

g_auto_play_f["������"] = function()
    if buff("��������") or gettimer("��������") < 0.5 or gettimer("���Ż���") < 0.5 then
        return true
    end
    return false
end

g_auto_play["̫�齣��"] = function()

    --�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
    if keydown(1) then
        cast("��ҡֱ��")
    end

    --����
    if fight() and life() < 0.5 and buffstate("����Ч��") < 40 then
        if gettimer("��������") > 0.3 and nobuff("��������") then
            cast("תǬ��")
        end
        if gettimer("תǬ��") > 0.3 then
            cast("��������")
        end
    end

    --��ʼ������
    g_auto_play_v["����"] = qidian()

    local tSpeedXY, tSpeedZ = speed(tid())
    g_auto_play_v["Ŀ�꾲ֹ"] = rela("�ж�") and tSpeedXY <= 0 and tSpeedZ <= 0
    g_auto_play_v["GCD���"] = cdinterval(16)
    g_auto_play_v["���ǳ�CD"] = scdtime("���ǳ�")
    g_auto_play_v["������CD"] = scdtime("������")
    g_auto_play_v["����CD"] = scdtime("��������")
    g_auto_play_v["��CD"] = scdtime("�򽣹���")
    g_auto_play_v["�˻�CD"] = scdtime("�˻Ĺ�Ԫ")
    g_auto_play_v["�˽�CD"] = scdtime("�˽���һ")
    g_auto_play_v["�������ܴ���"] = cn("��������")
    g_auto_play_v["��������ʱ��"] = cntime("��������", true)

    g_auto_play_v["����ʱ��"] = bufftime("��������")
    g_auto_play_v["Ŀ����в���"] = tbuffsn("����", id())
    g_auto_play_v["Ŀ�����ʱ��"] = tbufftime("����", id())
    g_auto_play_v["���ǳ�buffʱ��"] = bufftime("���ǳ�")    --����5% ��Ч10% ���ӷ���60% 4��
    g_auto_play_v["����ʱ��"] = bufftime("����")        --14931 �����˺����30% 5��
    g_auto_play_v["����ʱ��"] = bufftime("����")        --17933 15%��Ч
    g_auto_play_v["���Ų���"] = buffsn("����")            --ÿ����� �Ʒ�20% ����3%
    g_auto_play_v["����ʱ��"] = bufftime("����")

    g_auto_play_v["���ǳ�"] = npc("��ϵ:�Լ�", "����:�������ǳ�", "����<13")
    g_auto_play_v["������"] = npc("��ϵ:�Լ�", "����:����������", "����<13")
    g_auto_play_v["������"] = npc("��ϵ:�Լ�", "����:����������", "����<15")
    _, g_auto_play_v["��������"] = npc("��ϵ:�Լ�", "����:������̫��|�������ǳ�|����������", "����<13")

    --û��ս��������
    if nofight() and nobuff("��������") then
        CastX("��������")
    end

    --û��ս Ŀ��λ��3���ǳ�
    g_auto_play_v["���ǳ�ʱ��"], g_auto_play_v["���ǳ�����"] = qctime(id(), 10, 4980)    --�Լ�10�������ǳ�, ���ʱ��, ����
    if nofight() and rela("�ж�") then
        if g_auto_play_v["���ǳ�����"] < 3 or g_auto_play_v["���ǳ�ʱ��"] < 12 then
            CastX("���ǳ�")
        end
    end

    --����������
    if getopt("����������") and dungeon() and nofight() then
        return
    end

    --�˽� ���ִ�����
    if rela("�ж�") and dis() < 8 and g_auto_play_v["��������"] >= 3 and g_auto_play_v["���Ų���"] < 3 then
        if g_auto_play_v["������"] == 0 and g_auto_play_v["���ǳ�CD"] <= g_auto_play_v["GCD���"] then
            CastX("�˽���һ")
        end
    end

    --���ǳ�
    g_auto_play_v["���ǳ���������"], g_auto_play_v["���ǳ�����ʱ��"] = qc("�������ǳ�", id(), id())
    if rela("�ж�") and g_auto_play_v["���ǳ���������"] > 0 then
        --û�����ǳ���������
        CastX("���ǳ�")
    end

    --����
    if buff("1915") and tbuffsn("23170", id()) < 3 then
        CastX("�˻Ĺ�Ԫ")
    end

    --����
    if g_auto_play_v["����ʱ��"] >= 0 and g_auto_play_v["����"] > 9 then
        CastX("�����޽�")
    end

    --����
    if g_auto_play_v["Ŀ�����ʱ��"] < 0 or g_auto_play_v["Ŀ�����ʱ��"] > 12 then
        --����
        if nobuff("��������") and rela("�ж�") and dis() < 6 and face() < 90 and g_auto_play_v["Ŀ�꾲ֹ"] then
            if g_auto_play_v["�˻�CD"] <= g_auto_play_v["GCD���"] * 2 and g_auto_play_v["���ǳ���������"] < -1 and g_auto_play_v["���ǳ�����ʱ��"] > 10 and g_auto_play_v["�˽�CD"] > 10 then
                if cdtime("��������") <= 0 then
                    if CastX("��������") then
                        CastX("ƾ������")
                    end
                end
            end
        end

        CastX("��������")
    end

    --�˽�
    if rela("�ж�") and dis() < 6 and g_auto_play_v["���ǳ�"] ~= 0 and g_auto_play_v["������"] ~= 0 and g_auto_play_v["������"] == 0 then
        if g_auto_play_v["���ǳ�CD"] <= g_auto_play_v["GCD���"] then
            CastX("�˽���һ")
        end
    end

    --����
    if g_auto_play_v["����ʱ��"] >= 0 and g_auto_play_v["����"] >= 6 then
        CastX("�����޽�")
    end

    --�˻�
    CastX("�˻Ĺ�Ԫ")

    --������
    if rela("�ж�") and g_auto_play_v["������"] == 0 and g_auto_play_v["����ʱ��"] < 0 then
        CastX("������")
    end

    --������
    g_auto_play_v["�ƶ���������"] = keydown("MOVEFORWARD") or keydown("MOVEBACKWARD") or keydown("STRAFELEFT") or keydown("STRAFERIGHT") or keydown("JUMP")
    if fight() and mana() < 0.45 and g_auto_play_v["Ŀ�꾲ֹ"] and dis() < 6 and not g_auto_play_v["�ƶ���������"] then
        CastX("������", true)
    end

    --��
    if rela("�ж�") and dis() < 8 then
        if g_auto_play_v["����CD"] > 0.5 and g_auto_play_v["�˻�CD"] > 0.5 and g_auto_play_v["�˽�CD"] > 0.5 then
            CastX("�򽣹���")
        end
    end

    --û�ż��ܼ�¼��Ϣ
    if fight() and rela("�ж�") and dis() < 4 and face() < 90 and cdleft(16) <= 0 and castleft() <= 0 and state("վ��|��·|�ܲ�|��Ծ") then
        if gettimer("���ǳ�") > 0.3 and gettimer("������") > 0.3 then
            PrintInfo("-- û�ż���")
        end
    end
end

--ʹ�ü��ܲ���¼��Ϣ
function CastX(szSkill, bSelf)
    if cast(szSkill, bSelf) then
        settimer(szSkill)
        if g_auto_play_v["��¼��Ϣ"] then
            PrintInfo()
        end
        return true
    end
    return false
end

g_auto_play_v["ս��"] = rage()

--��ѭ��
g_auto_play["��Ѫս��"] = function()
    -- �����Զ����ݼ�1����ҡ
    if keydown(1) and scdtime("��ҡֱ��") <= 0 then
        if cast("��ҡֱ��") then
            settimer("��ҡֱ��")
        end
        if buff("����") then
            cbuff("����")
        end
    end

    --����
    if fight() then
        cast("Х�绢")

        if life() < 0.55 then
            cast("����ɽ")
        end
    end

    --Ŀ�겻�ǵж�, ����
    if not rela("�ж�") then
        return
    end
    if gettimer("���") < 0.3 then
        return
    end

    if getopt("����������") and dungeon() and nofight() then
        return
    end

    --�ȴ��γ۳��ͷ�
    if casting("�γ۳�") and castleft() < 0.13 then
        settimer("�γ۳Ҷ�������")
    end
    if gettimer("�γ۳Ҷ�������") < 0.3 then
        return
    end


    --��ʼ������
    --g_auto_play_v["Ŀ����Ѫʱ��"] = tbufftime("��Ѫ", id())
    --g_auto_play_v["��Ԧ����"] = buffsn("��Ԧ")
    --g_auto_play_v["�۳�"] = bufftime("�۳�")
    --g_auto_play_v["����"] = bufftime("����")
    --g_auto_play_v["Ԩ"] = bufftime("2778")
    --g_auto_play_v["������"] = buff("����")
    --g_auto_play_v["�ж���"] = g_player.IsInParty()

    --����
    if buff("����") and nobuff("�۳�") and cn("�γ۳�") > 0 and qixue("��Ԧ") then
        --if cdleft(16) >= 1 and g_auto_play_v["ս��"] < 5 and scdtime("������") < 1.5 then
        if scdtime("������") < 1 then
            cbuff("����")
            settimer("���")
            exit()
        end
    end

    if buff("����") and (cn("�γ۳�") > 0 or (nobuff("����") and scdtime("ͻ") <= 0) or scdtime("Ԩ") <= 1.5) and not qixue("��Ԧ") then
        cbuff("����")
        settimer("���")
        exit()
    end

    --Ԩ
    g_auto_play_v["Ŀ�긽������"] = tparty("û״̬:����", "�����Լ�", "�Լ�����>6", "�Լ�����<20", "����<25", "�����ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�������")
    if g_auto_play_v["Ŀ�긽������"] ~= 0 and nobuff("����") and qixue("Ԩ") and scdtime("Ԩ") <= 0 then
        if xcast("Ԩ", g_auto_play_v["Ŀ�긽������"]) then
            settimer("���")
            exit()
        end
        return
    end

    --ͻ
    --if cdleft(16) > 0.5 or nobuff("����") then
    if cast("ͻ") then
        settimer("���")
        exit()
    end

    --������
    if rela("�ж�") and dis() < 8 and cdleft(16) < 0.5 then
        if qixue("��Ԧ") then
            if bufftime("�۳�") > 9 then
                cast("������", true)
            end
        elseif bufftime("Ԩ") > 6 then
            cast("������", true)
        elseif bufftime("�۳�") > 9 then
            cast("������", true)
        end
    end

    --�ϻ��
    if g_auto_play_v["ս��"] <= 2 or dis() > 8 then
        if cast("�ϻ��") then
            settimer("���")
            exit()
        end
    end

    ---------------------------------------------

    if getopt("���������") and tbuffstate("�ɴ��") then
        cast("������")
    end

    --�γ۳�
    if qixue("��Ԧ") then
        if buff("����") then
            cast("�γ۳�")
        end
    end

    if not qixue("��Ԧ") and nobuff("�۳�") then
        if buff("����") then
            cast("�γ۳�")
        end
    end

    --����Ѫ
    if tbufftime("��Ѫ", id()) < cdinterval(16) * 2 then
        if g_auto_play_v["ս��"] <= 2 then
            cast("��")
        end
        cast("����")
        cast("��")
    end

    --����
    if g_auto_play_v["ս��"] >= 5 then
        cast("����")
    end

    --ս�˷�
    _, g_auto_play_v["6���ڵ�������"] = npc("��ϵ:�ж�", "����<6", "��ѡ��")
    if g_auto_play_v["6���ڵ�������"] >= 3 then
        cast("ս�˷�")
    end

    --��
    if g_auto_play_v["ս��"] <= 2 then
        cast("��")
    end

    --����
    if g_auto_play_v["ս��"] <= 3 then
        cast("����")
    end

    --����
    cast("����")
end

g_auto_play_v["��¼��Ϣ"] = true

--��ѭ��
g_auto_play["�뾭�׵�"] = function()
    --�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
    if keydown(1) then
        cast("��ҡֱ��")
    end

    if nofight and nobuff("���ľ���") then
        cast("���ľ���")
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

    g_base["����������"]("��¥��Ӱ")

    --if buff("������Ů")
    if bufftime("���Զ���") > 2 then
        if scdtime("̫��ָ") == 0 then
            cast("̫��ָ")
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
            cast("̫��ָ")
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
    if fight() and life() < 0.5 then
        cast("��¥��Ӱ")
    end

    if scdtime("����ָ") == 0 then
        --���
        if getopt("���") and tbuffstate("�ɴ��") then
            cast("����ָ")
        end

        local rank = player("û״̬:����", "��ϵ:�ж�", "����:���ǹ���|��̫��|��������|��ѩƮҡ|����|����|�������|��������|����ǣ˿|�춷��|������|�������|ɱ����β|ƽɳ����|��������|�乬|����|Ц������|�����ả|��ˮ��Ӱ|��������|���ƺ���|�ന���|��������|�Ҵ�ʱ��|����ع��|����ع��|�ùⲽ", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����")
        if rank ~= 0 then
            if xcastprog(rank) > 0.3 or xcastpass(rank) > 0.5 or xcastleft(rank) < 0.3 then
                xcast("����ָ", v.id)
            end
            xcast("����ָ", rank)
        end
    end


    --��ʼ������
    g_auto_play_v["ī��"] = rage()
    g_auto_play_v["������"] = charinfo("������")    --����뾫ȷ���ƣ������� * ����ϵ�� = ����ʵ�ʼ�Ѫ��
    g_auto_play_v["����Ŀ��"] = g_auto_play_f["��ȡ����Ŀ��"]()
    g_auto_play_v["����Ŀ��Ѫ��"] = xlife(g_auto_play_v["����Ŀ��"])
    g_auto_play_v["����Ŀ����T"] = xmount("ϴ�辭|������|����������|������", g_auto_play_v["����Ŀ��"])

    ---------------------------------------------
    if fight() and g_auto_play_v["����Ŀ��Ѫ��"] < 0.6 then
        CastX("���໤��")
    end
    --����
    if fight() and g_auto_play_v["����Ŀ��Ѫ��"] < 0.35 and life() > 0.35 then
        CastX("���紵ѩ")
    end

    if g_auto_play_v["����Ŀ��Ѫ��"] < 0.8 then
        if buff("412|722|932|3458|6266") then
            --��˲��
            CastX("����")
        end
    end

    --����
    if g_auto_play_v["����Ŀ��Ѫ��"] < 0.45 then
        --ˮ��
        if fight() and g_auto_play_v["ī��"] < 20 then
            cast("ˮ���޼�")
        end

        if buff("412|722|932|3458|6266") then
            --��˲��
            CastX("����")
        end
    end

    if g_auto_play_v["����Ŀ��Ѫ��"] < 0.3 then
        --��Ѫ
        CastX("����")
    end
    --����

    --����
    if g_auto_play_v["����Ŀ��Ѫ��"] < 0.9 then
        --��Ѫ
        CastX("����")
    end

    if g_auto_play_v["ī��"] < 30 then
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
    if nofight() and gettimer("�����������") > 0.5 then
        xcast("����", party("��״̬:����", "����<20", "���߿ɴ�"))
    end
end

-------------------------------------------------------------------------------

g_auto_play_f["��ȡ����Ŀ��"] = function()
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

g_auto_play_v["�����Ϣ"] = true
g_auto_play_v["ûʯ����"] = 0

--������
local f = {}

local counter = {
    killed = 16,
    max = 16;

    increment = function(self)
        self.killed = self.killed + 1
    end,

    start = function(self)
        self.killed = 0
    end,

    stop = function(self)
        self.killed = self.max
    end,

    running = function(self)
        self.killed = self.killed + 1
        return self.killed <= self.max
    end
}

--��ѭ��
g_auto_play["ɽ���ľ�"] = function()
    --cast("��ʧ")
    cast(35894)
    if casting("�����") and castleft() < 0.13 then
        settimer("����ض�������")
    end
    if gettimer("����ض�������") < 0.3 then
        return
    end

    --Ӧ������
    if fight() and life() < 0.20 then
        cast("Ӧ������")
    end

    --��ʼ������
    g_auto_play_v["����"] = rage()
    g_auto_play_v["����ӡ"] = beast()

    g_auto_play_v["����CD"] = scdtime("�����")
    g_auto_play_v["����CD"] = scdtime("��������")
    g_auto_play_v["���ڳ��ܴ���"] = cn("���ڼ�׹")
    g_auto_play_v["���ڳ���ʱ��"] = cntime("���ڼ�׹", true)
    g_auto_play_v["����CD"] = scdtime("���绽��")
    g_auto_play_v["����CD"] = scdtime("������Ұ")
    g_auto_play_v["����CD"] = scdtime("�������")

    g_auto_play_v["��������"] = buffsn("����")
    g_auto_play_v["����ʱ��"] = bufftime("����")
    g_auto_play_v["�ᴩ����"] = tbuffsn("�ᴩ", id())
    g_auto_play_v["�ᴩʱ��"] = tbufftime("�ᴩ", id())
    g_auto_play_v["��������"] = tbuffsn("����")
    g_auto_play_v["����ʱ��"] = tbufftime("����", id())
    g_auto_play_v["Ŀ��Ѫ���϶�"] = rela("�ж�") and tlifevalue() > lifemax() * 10

    --��������
    if g_auto_play_v["����"] < 8 then
        if nofight() then
            --û��ս�Ѽ�װ��
            CastX("��������")
        end

        if g_auto_play_v["����"] < 1 then
            --û����װ��, �Զ�װ�����GCD��1֡, �Լ�װ, ������ҲûӰ��, �����˻��ܿ�1֡
            CastX("��������")
        end
    end

    if g_auto_play_v["����"] >= 5 then
        g_auto_play_v["���һ֧��״̬"] = arrow(0)
        if g_auto_play_v["���һ֧��״̬"] ~= 3 and g_auto_play_v["���һ֧��״̬"] ~= 4 then
            if g_auto_play_v["����ӡ"] ~= 1 then
                --���һ֧��û����
                CastX("���Ҿ���")
            end
        end
    end

    --���ڼ�׹
    if g_auto_play_v["����"] >= 8 then
        --��������
        if rela("�ж�") and dis() < 30 then
            g_auto_play_v["���һ֧��״̬"] = arrow(0)
            if g_auto_play_v["���һ֧��״̬"] ~= 2 and g_auto_play_v["���һ֧��״̬"] ~= 4 then
                --���һ֧��û����
                if g_auto_play_v["����ӡ"] ~= 1 or g_auto_play_v["���ڳ��ܴ���"] >= 2 then
                    CastX("���ڼ�׹")
                end

                if not qixue("����") then
                    CastX("���ڼ�׹")
                end
            end

            if g_auto_play_v["���ڳ��ܴ���"] >= 3 and bufftime("����") < 0 and g_auto_play_v["����CD"] < 1 then
                --��������û˲��
                CastX("���ڼ�׹")
            end
        end
    end

    if nofight() or notarget() and tlife() <= 0 or tbuff("ն�޳�") then
        return
    end

    if qixue("����") or qixue("ף��") and fight() then
        if qixue("����") and g_auto_play_v["����ӡ"] >= 3 then
            if g_auto_play_v["����"] < 8 then
                CastX("��������")
            end
            CastX("�������")
        end
        if g_auto_play_v["����ӡ"] >= 4 then
            if g_auto_play_v["����"] < 8 then
                CastX("��������")
            end
            CastX("�������")
        end

        if buff("����") then
            if g_auto_play_v["����"] < 8 then
                --cast("��������")
                cast(35974)
            end
            if dis() < 10 then
                if scdtime("�۳���") == 0 and dis() < 10 then
                    if CastX("�۳���") then

                    end
                end
                if scdtime("��ɽ�") == 0 and dis() < 6 then
                    if CastX("��ɽ�") then

                    end
                end
            end

            if CastX(35688) then

            end
            return
        end

        if not qixue("����") then
            if g_auto_play_v["����ӡ"] == 1 then
                --cast("������Ұ")
                CastX(35696)
            end
        else
            if g_auto_play_v["����ӡ"] == 0 then
                CastX(35696)
            end
        end
    end

    --���绽��, ��Ŀ��Ľ�ɫ�������20�������Լ�������
    if fight() and rela("�ж�") and dis3() < 20 then
        CastX("���绽��")
    end

    if qixue("����") and fight() then
        if g_auto_play_v["����ӡ"] == 0 then
            if not nextbeast("Ұ��") and not beast("Ұ��") then
                --ֻ��ӥ
                setbeast({ "Ұ��", "��", "��", "ӥ", "��", "����" })
            end

            if scdtime("���绽��") < 5 then
                CastX("������Ұ")
            end
        end

        if g_auto_play_v["����ӡ"] == 1 then
            if not nextbeast("��") and not beast("��") then
                --ֻ��ӥ
                setbeast({ "��", "Ұ��", "ӥ", "��", "��", "����" })
            end

            if g_auto_play_v["����ӡ"] == 1 and scdtime("���绽��") > 2 then
                CastX("������Ұ")
            end
        end

        if g_auto_play_v["����ӡ"] >= 2 and dis() > 0 and dis() < 30 and bufftime("����") < 3 then
            CastX("�������")
        end
    end

    if buff("�������") then
        CastX("�ڷ�����")
        CastX("�����")
        return
    end

    if g_auto_play_v["����"] >= 3 then

        if buff("26861") then
            CastX("�ڷ�����")
        end

        --ûʯ����
        if buff("26862") then
            CastX("ûʯ����")
        end
    end

    if buff("����") then
        if tlife() < 0.4 then
            CastX("�����")
        end

        if g_auto_play_v["����"] == 8 then
            CastX("�����")
        end
    end
    if g_auto_play_v["����"] == 4 or g_auto_play_v["����"] == 8 then
        CastX("�����")
    end
    CastX("�����")

end


function PrintInfo(s)

end