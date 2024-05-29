load("Macro/Lib_Skill.lua")
--������
g_var = {}
g_mount_skill = {}

--���ó���
g_var["����λ��״̬"] = "������|���|��ץ"
g_var["�����ķ�"] = "�뾭�׵�|�����ľ�|�����|��֪|����"
g_var["��ս�ķ�"] = "ϴ�辭|�׽|��Ѫս��|������|̫�齣��|��ˮ��|ɽ�ӽ���|��Ӱʥ��|����������|Ц����|������|��ɽ��|������|�躣��|������|�·��"
g_var["Զ���ķ�"] = "������|��ϼ��|���ľ�|����|�����|���޹��|Ī��|̫����|�޷�|ɽ���ľ�"

--������
g_func = {}

--[[ȫ�ֱ���˵��, ��������˼�����е���
Ŀ��ɿ���, Ϊ��ʱָ����Ŀ�겻���κθ���Ч��Ӱ��, ������ʱ���Ŀ��ʹ�ø���Ч�������к�����
Ŀ��ɹ���, Ϊ��ʱָ����Ŀ�겻���˺����߼��˷ǳ���, Ŀ���ܸ���Ч��Ӱ�죬ֻ���˺����ֱ�����, �󲿷����ɿ��Ƽ����˺�����, ��CD���˺��ļ��ܿ����ж�һ��
--]]


g_func["��ʼ��"] = function()
    g_var["Ŀ�����Ч��"] = g_func["Ŀ�����Ч��"]()
    g_var["Ŀ������Ч��"] = tbuffstate("����Ч��")
    g_var["Ŀ�������Ч��"] = tbuffstate("������Ч��")

    g_var["Ŀ��ɿ���"] = g_func["Ŀ��ɿ���"]()
    g_var["Ŀ��ɹ���"] = g_var["Ŀ��ɿ���"] and g_func["Ŀ��ɹ���"]()
    g_var["Ŀ��û����"] = g_var["Ŀ��ɹ���"] and g_func["Ŀ��û����"]()

    --��������, ���͵�����Ѩ����Ϸˮ
    g_var["Ŀ�굥������"] = 0
    local nLeftTime, nStackNum = tbuffstate("��������")
    if nLeftTime > -0.25 then
        g_var["Ŀ�굥������"] = nStackNum
    end

    g_var["Ŀ��һ��"] = g_var["Ŀ��û����"] and g_var["Ŀ�굥������"] <= 0 and g_func["Ŀ��һ��"]()
    g_var["ͻ��"] = g_var["Ŀ��ɹ���"] and g_func["ͻ��"]()

    _, g_var["������������"] = enemy("����<40")
end

--�����κθ��漼��
g_func["Ŀ��ɿ���"] = function()
    --Ŀ�겻�ǵж�
    if not rela("�ж�") then
        return false
    end

    --Ŀ���޵�
    if tbuffstate("�޵�ʱ��") > -1 then
        bigtext("Ŀ���޵�", 0.5)
        return false
    end

    --���� ����
    if tbufftime("����") > -1 or tlasttime("����") <= 2 then
        bigtext("Ŀ�����", 0.5)
        return false
    end

    --���� ���ɳ��
    if buffsrc("���ɳ��") ~= tbuffsrc("���ɳ��") then
        bigtext("Ŀ�겻�����ɳ��Ŀ��", 0.5)
        return false
    end

    --���� ХӰ
    if bufftime("ХӰ") > -1 then
        bigtext("��ХӰ", 0.5)
        return false
    end

    --ָ�����ֵ�NPC����
    if target("npc") and tname("ʥЫ|����|����|����|���|�̵�|�Լ�����") then
        bigtext("����ָ��npc", 0.5)
        return false
    end

    --Ŀ�������
    if g_var["Ŀ�������Ч��"] > 95 then
        bigtext("Ŀ������й���: " .. g_var["Ŀ�������Ч��"], 0.5)
        return false
    end

    return true
end

--����Ŀ�����Ч��
g_func["Ŀ�����Ч��"] = function()
    local effect = 0
    local m = mounttype()
    if m == "�⹦" then
        effect = tbuffstate("������Ч��")
    else
        effect = tbuffstate("������Ч��")
    end

    if tschool("�嶾") then
        effect = 100 - (100 - effect) * (100 - tbuffstate("�˺�ת��Ч��")) / 100  --����֮����ȥ��ת�Ʋ��֣���ʣ�µ�ʵ���˺���ò��������
    end

    return effect
end

--�����˺�����
g_func["Ŀ��ɹ���"] = function()
    --���� ���ű���
    g_var["Ŀ����ű���"] = false
    if tbufftime("���ű���") > -1 or tlasttime("���ű���") <= 4 then
        g_var["Ŀ����ű���"] = true
        bigtext("Ŀ����ű���", 0.5)
        return false
    end

    --���з���
    g_var["Ŀ��߷���"] = false
    if tbuffstate("����Ч��") > 45 and tbuffstate("����Ч��") / 100 * tlifevalue() > lifevalue() - lifemax() * 0.1 then
        g_var["Ŀ��߷���"] = true
        bigtext("Ŀ��߷���", 0.5)
        return false
    end

    --�����
    local m = mounttype()

    if m == "�ڹ�" then
        if tbuffstate("������ʱ��") > -1 then
            bigtext("Ŀ��������", 0.5)
            return false
        end
    elseif m == "�⹦" then
        if tbuffstate("������ʱ��") > -1 then
            bigtext("Ŀ��������", 0.5)
            return false
        end
        if g_var["Ŀ������Ч��"] > 95 then
            bigtext("Ŀ�����ܹ���: " .. g_var["Ŀ������Ч��"], 0.5)
            return false
        end
    elseif m == "����" then
        if tbuffstate("������ʱ��") > -1 then
            bigtext("Ŀ��������", 0.5)
            return false
        end
        if g_var["Ŀ������Ч��"] > 95 then
            bigtext("Ŀ�����ܹ���: " .. g_var["Ŀ������Ч��"], 0.5)
            return false
        end
    else
        bigtext("��ȡ�ڹ�����ʧ��")
    end

    if g_var["Ŀ�����Ч��"] > 95 then
        bigtext("Ŀ����˹���: " .. g_var["Ŀ�����Ч��"], 0.5)
        return false
    end

    --[[9506 ���Ӱ��
    if tbuff("9506") then
        return false
    end
    --]]

    return true
end

g_func["Ŀ��û����"] = function()
    --����
    if g_var["Ŀ�����Ч��"] > 39 then
        return false
    end

    --������
    if tbuffstate("������Ч��") > 39 then
        return false
    end

    --�⹦�������ж�����
    local m = mounttype()
    if m == "�⹦" or m == "����" then
        if g_var["Ŀ������Ч��"] > 39 then
            return false
        end
    end

    --�˺�ת��
    if tbuff("��ˮ��|����߳��") then
        return false
    end

    --ǧ֦���� ���ü��㵥���ж�

    return true
end

--��Ѫ��û����
g_func["Ŀ��һ��"] = function()
    --���
    --if tbufftime("Х�绢") > -1 then return false end
    if tbuffstate("����ʱ��") > -1 then
        return false
    end

    --��
    if tbufftime("����") > -1 then
        return false
    end

    ----���� ڤ��
    --if tqixue("ڤ��") and tnobuff("ڤ��") then
    --    return false
    --end
    --
    ----�ؽ� Ƭ��
    --if tqixue("Ƭ��") and tnobuff("����") then
    --    return false
    --end

    --�嶾 ����
    --if tqixue("����") and tnobuff("�Ϻ�") then
    --    return false
    --end


    --���� ���Ӱ�費��
    if tbuff("12875") then
        return false
    end

    --Ѫ��+�˺����ն� С��20%
    return tlife() + tdas() < 0.2
end

g_func["ͻ��"] = function()
    --��������
    if tenemy("����:������ɽ", "ƽ�����<10") ~= 0 then
        return false
    end
    if buffsn("����") >= 4 and tenemy("����:�Ҵ�ʱ��", "ƽ�����<15") ~= 0 then
        return false
    end


    --�ؽ� ������ɽ
    if tnpc("��ϵ:�ж�", "ƽ�����<10", "ģ��ID:57739") ~= 0 then
        return false
    end

    --���� ���϶���
    if tnpc("��ϵ:�ж�", "ƽ�����<6", "ģ��ID:58295") ~= 0 then
        return false
    end

    --���� ��������
    if tnpc("��ϵ:�ж�", "ƽ�����<10", "ģ��ID:44764") ~= 0 then
        return false
    end

    --���� �Ȼ����
    if tnpc("��ϵ:�ж�", "ƽ�����<6", "ģ��ID:63709") ~= 0 then
        return false
    end

    --ҩ�� ��Ұ����
    if tbuff("��Ұ����") then
        return false
    end

    --Ŀ�긽�����˴���5������ͻ��
    local _, count = tenemy("ƽ�����<10")
    if count > 5 then
        return false
    end

    return true
end

g_func["�ɼ�"] = function()

    interact(doodad("����:����|ֹѪ��|�ӵ׵�ɳʯ|����|�����˵�����|��¨|����|���|�ɲ�|ѩ��|��Ѫ������", "����<6", "�������"))

    if self().GetItemAmountInPackage(5, 4549) < 6 then
        interact(doodad("����:������", "����<6", "�������"))
    end

    if self().GetItemAmountInPackage(5, 4550) < 6 then
        interact(doodad("����:�ƶž�", "����<6", "�������"))
    end
end

g_func["�����ڽ�е"] = function()
    if bufftime("ϴ����") > 1 then
        local doodadID = doodad("ģ��ID:9810", "����ID:49040")
        if doodadID ~= 0 then
            local x, y, z = xpos(doodadID)
            if x > 0 then
                local dist = pdis2(x, y)
                if dist > 2 then
                    if acast("������ʤ", -90, { nX = x, nY = y }) then
                        bigtext("�����ڽ�е", 1)
                        exit()
                    end
                    if acast("��̨���", 90, { nX = x, nY = y }) then
                        bigtext("�����ڽ�е", 1)
                        exit()
                    end
                end
                stopmove()
                moveto(x, y, z)
                exit()
            end
        end
    end
end

g_func["�л�Ŀ��"] = function(dis2)
    if dis2 == nil then
        dis2 = 20
    end


    local n_id = g_func["N���ڵ���"](dis2)
    if n_id ~= 0 then
        --ûĿ����ǵж�
        if not rela("�ж�") then
            settar(n_id)
            return
        end

        --if tbuff("����ɽ|ն�޳�|Х�绢|��ɽ��") then
        --    return
        --end

        --��ǰĿ�����
        if tstate("����") then
            settar(n_id)
            return
        end

        --����̫Զ
        if dis() > 25 then
            settar(n_id)
            return
        end

        --���߲��ɴ�
        if tnovisible() then
            settar(n_id)
            return
        end

        --�ȵ�ǰĿ��Ѫ����
        if tlife() > 0.7 and xlife(n_id) < tlife() then
            settar(n_id)
            return
        end
    end
end

g_func["һ��"] = function(dis2)
    if dis2 == nil then
        dis2 = 20
    end


    local n_id = g_func["N���ڵ���"](dis2)
    if n_id ~= 0 then
        if xbufftime("Х�绢") > 2 then
            return
        end

        if xbufftime("����ɽ") > 2 and xlife(n_id) > 0.3 then
            return
        end

        if xbufftime("���") > 1  then
            return
        end

        if xbufftime("Ӧ������") > 2 and xlife() > 0.2  then
            return
        end

        --ûĿ����ǵж�
        if not rela("�ж�") then
            settar(n_id)
            return
        end

        --��ǰĿ�����
        if tstate("����") then
            settar(n_id)
            return
        end

        --����̫Զ
        if dis() > 25 then
            settar(n_id)
            return
        end

        --���߲��ɴ�
        if tnovisible() then
            settar(n_id)
            return
        end

        --�ȵ�ǰĿ��Ѫ����
        if tlife() > 0.7 and xlife(n_id) < 0.4 then
            settar(n_id)
            return
        end
    end
end


g_func["N���ڵ���"] = function(dis2, notid)
    if notid ~= nil and notid ~= 0 then
         return enemy("����<" .. dis2, "���߿ɴ�", "û�ؾ�", "��Ѫ����", "ID������:".. notid)
    end

    return enemy("����<" .. dis2, "���߿ɴ�", "û�ؾ�", "��Ѫ����")
end

g_func["N���ڵ����м���"] = function(dis2)
    if notid ~= nil and notid ~= 0 then
        return enemy("����<" .. dis2, "���߿ɴ�", "û�ؾ�", "��Ѫ����", "buff״̬:����Ч��>40")
    end

    return enemy("����<" .. dis2, "���߿ɴ�", "û�ؾ�", "��Ѫ����")
end

g_func["N���ڵ�����buff"] = function(dis2)
    if notid ~= nil and notid ~= 0 then
        return enemy("����<" .. dis2, "���߿ɴ�", "û�ؾ�", "��Ѫ����", "��ѡ��")
    end

    return enemy("����<" .. dis2, "���߿ɴ�", "û�ؾ�", "��Ѫ����")
end

g_counter = {

}
g_counter["��������"]=0
g_counter["��ҡֱ��"]=0
g_counter["��ҡֱ��"]=0
g_counter["������ʤ"]=0
g_counter["ӭ�����"]=0
g_counter["��̨���"]=0

g_counter["̫��ָ"]=0

g_counter["��Ч֡��"] = 8

g_func_period = {}
g_func["����ִ��"] = function(name, period)
    if g_func_period[name] == nil then
        g_func_period[name] = 0
    end

    if g_func_period[name] >= period then
        g_func_period[name] = 0
        return true
    end

    g_func_period[name] = g_func_period[name] + 1
    return false
end

g_qinggong = {
}

g_func["С�Ṧ"] = function()
    g_func["�Ṧ����"]("��ҡֱ��", "ACTIONBAR2_BUTTON12")
    g_func["�Ṧ����"]("��������", "ACTIONBAR2_BUTTON13")
    g_func["�Ṧ����"]("ӭ�����", "ACTIONBAR1_BUTTON13")
    g_func["�Ṧ����"]("������ʤ", "ACTIONBAR1_BUTTON12")
    g_func["�Ṧ����"]("��̨���", "ACTIONBAR1_BUTTON14")
    g_func["�Ṧ����"]("̫��ָ", "ACTIONBAR1_BUTTON7")
    --g_func["�Ṧ����"]("������", "ACTIONBAR2_BUTTON2")
end

g_func["�Ṧ����"] = function(skillName, actionBar)
    if keydown(actionBar) then
        g_counter[skillName] = g_counter["��Ч֡��"]
    end
    if g_counter[skillName] > 0 then
        g_func["�ͷż���"](skillName)
        g_counter[skillName] = g_counter[skillName] - 1
    end
end

g_skill_action_bar = {}
--���鼼��
g_skill_action_bar["�����"] = { 1, 1, false }
g_skill_action_bar["�����"] = { 1, 2, false }
g_skill_action_bar["��������"] = { 1, 4, false }
g_skill_action_bar["�ڷ�����"] = { 1, 3, false }
g_skill_action_bar["ûʯ����"] = { 1, 3, false }
g_skill_action_bar["��ʸ�꼯"] = { 1, 3, false }
g_skill_action_bar["�ؼ���"] = {1, 4}
g_skill_action_bar["��ʸ"] = { 1, 5 }
g_skill_action_bar["������Ұ"] = { 1, 6 }

g_skill_action_bar["��������"] = { 1, 9 }

g_skill_action_bar["Ӧ������"] = {1, 8}
g_skill_action_bar["���Ҿ���"] = { 2, 1, true }
g_skill_action_bar["���ڼ�׹"] = { 2, 2, true }
g_skill_action_bar["�������"] = { 2, 6 }
g_skill_action_bar["���绽��"] = { 2, 7 }
g_skill_action_bar["��������"] = {2, 8}


g_skill_action_bar["��ƽҰ"] = { 1, 1 }
g_skill_action_bar["�۳���"] = { 1, 2 }
g_skill_action_bar["��ɽ�"] = { 1, 3 }

-- �򻨼���
g_skill_action_bar["̫��ָ"] = { 1, 7 }
g_skill_action_bar["����ָ"] = { 2, 7, true }

g_skill_action_bar["������"] = {1, 1}
g_skill_action_bar["����ն"] = {1, 2}
g_skill_action_bar["������"] = {1, 3}
g_skill_action_bar["����ն"] = {1, 4}
g_skill_action_bar["������"] = {1, 6}
g_skill_action_bar["�ùⲽ"] = {1, 7}
g_skill_action_bar["��������"] = {1, 8}
g_skill_action_bar["������Ӱ"] = {1, 9}
g_skill_action_bar["���»�"] = {1, 10}

g_skill_action_bar["��������"] = {2, 1}
g_skill_action_bar["������"] = {2, 2}
g_skill_action_bar["̰ħ��"] = {2, 4}
g_skill_action_bar["������"] = {2, 6}
g_skill_action_bar["��η����"] = {2, 7}
g_skill_action_bar["������ħ��"] = {2, 8}
g_skill_action_bar["��ҹ�ϳ�"] = {2, 9}
g_skill_action_bar["������ɢ"] = {2, 10}

g_skill_action_bar["��ת����"] = {1, 7}
g_skill_action_bar["̤����"] = {2, 2}
g_skill_action_bar["���ű���"] = {2, 4}
g_skill_action_bar["�������"] = {1, 4}

g_func["�Զ����"] = function(tdis)
    if tdis == nil then
        tdis = 20
    end
    if notarget() or dis() > tdis then
        local npc_id = npc("����:������ʯ��|������ʯ���|�嵤|��ެ�ٷ�|����ɽ����|����ɽ����ͷĿ", "�Լ�����<"..tdis, "��ѡ��", "�Լ�����")
        if npc_id ~= 0 then
            settar(npc_id)
        end
    end
end

g_func["�ͷż���"] = function(szSkill, bSelf)
    local skill = g_skill_action_bar[szSkill]

    if skill ~= nil then
        local _cdleft
        if skill[3] then
            _cdleft = scdtime(szSkill)
        else
            _cdleft = cdtime(szSkill)
        end
        if _cdleft > 0 then
            return
        end
        actionclick(skill[1], skill[2])
        return true
    end

    if cast(szSkill, bSelf) then
        return true
    end
    return false
end

g_func["�ж��ͷ�"] = function(szSkill, bSelf)
    -- �Եж�����ͷ�
    --if target() and xrela("�ж�") and target("player")  then
        local skill = g_skill_action_bar[szSkill]
        if skill ~= nil then
            local _cdleft
            if skill[3] then
                _cdleft = scdtime(szSkill)
            else
                _cdleft = cdtime(szSkill)
            end
            if _cdleft > 0 then
                return true
            end
            actionclick(skill[1], skill[2])
            return true
        else
            return false
        end
    --else
    --    cast(szSkill, bSelf)
    --end
end

g_func["ܽ�ز��ٴ���"] = function()
    if buff("ܽ�ز���") then
        g_func["�ж��ͷ�"]()
    end
end

g_func["�жԸ���㴦��"] = function(fun)
    if fun ~= nil then
        local nid = npc("����:�������|ѩħ����", "��ɫ����<6")
        if nid ~= 0 and xrela("�ж�",  nid) then
            fun()
        end
    end
end
