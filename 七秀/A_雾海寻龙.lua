--[[ ��Ѩ: [��¶][ʢ��][����][����][����][ɢ��ϼ][����][���][����][��΢�ɻ�][��ü][������ת]
�ؼ�:
�������  2��Ч 2����
��Ԫ����  1��Ч 3����
��ѩƮҡ  3��Ч 1����
��ĸ����  2���� 2��Ч
��صͰ�  2��Ϣ 1���� 1����
��������  3��Ϣ 1����
�Ĺ���    3��Ϣ 1����

���߱��˲���������, ��Ѩ�ؼ��Լ����������
--]]

--������
local v = {}
v["��¼��Ϣ"] = true

--������
local f = {}

load("Macro/Lib_Base.lua")
load("Macro/Lib_PVP.lua")
--��ѭ��
function Main()
	--�����Զ����ݼ�1�ҷ�ҡ, ע���ǿ�ݼ��趨�������Ŀ�ݼ�1ָ���İ��������Ǽ����ϵ�1
	if keydown(1) then
		fcast("��ҡֱ��")
	end

	g_base["����������"]("ȵ̤֦")

	if nofight() and nobuff("����") then
		cast("������")
	end

	g_func["С�Ṧ"]()


	--����
	if fight() then
		if life() < 0.6 then
			fcast("��صͰ�", true)
		end

		if bufftime("��������") > 9 and bufftime("����ع��") > 9 then
			if buff("ܽ�ز���") then
				if fcast("��Ū��") then
					return
				end

				if fcast("ȵ̤֦") then
					return
				end
			end

			if nobuff("��صͰ�") then
				fcast("��صͰ�", true)
			end
		end
	end

	--������
	if nobuff("����") then
		cast("�����ķ�", true)
	end

	--��ʼ������
	v["������"] = charinfo("������")	--����뾫ȷ���ƣ������� * ����ϵ�� = ����ʵ�ʼ�Ѫ��
	v["����Ŀ��"] = f["��ȡ����Ŀ��"]()
	v["����Ŀ��Ѫ��"] = xlife(v["����Ŀ��"])
	v["����Ŀ����T"] = xmount("ϴ�辭|������|����������|������", v["����Ŀ��"])
	v["����Ѫ��"] = 0.5			--���Ը��ݵ�ǰ�汾���Լ�װ���ʵ�����
	v["��ĸѪ��"] = 0.6
	if v["����Ŀ����T"] then	--��T�Ļ���Ѫ�߶���һ��
		v["����Ѫ��"] = 0.6
		v["��ĸѪ��"] = 0.7
	end

	if v["����Ŀ��"] == 0 then
		return
	end

	if tid() ~= v["����Ŀ��"] and id() ~= v["����Ŀ��"] then
		if (not rela("�ж�")) and v["����Ŀ��Ѫ��"] < 0.8 then
			settar(v["����Ŀ��"])
		end
	end

	if buff("С������") then
		cast("��صͰ�")
		if life() > 0.5 then
			return
		end
	end

	if buff("չ��") then
		bigtext("չ�� ��Ҫ��")
	end

	if target() and tid() == v["����Ŀ��"] then
		if tbuff("С������") then
			if tlife() > 0.5 then
				return
			end
		end
	end
	--------------------------------------------- ��Ѫ

	--��ѩ��1�������
	if casting("��ѩƮҡ") and castprog() < 0.34 then return end

	if qixue("����") and v["����Ŀ��Ѫ��"] > 0.5 and life() < 0.75 then
		cast("��صͰ�")
	end

	if xbufftime("��Ѫ") < 9 and xbuffsn("��Ѫ", v["����Ŀ��"]) > 2  then
		cast("���ٻ��")
	end
	--����
	if fight() and v["����Ŀ��Ѫ��"] < v["����Ѫ��"] then
		xcast("����Ͱ�", v["����Ŀ��"], true)
		xcast("��΢�ɻ�", v["����Ŀ��"], true)
	end

	--��ĸ
	if v["����Ŀ��Ѫ��"] < v["��ĸѪ��"] then
		xcast("��ĸ����", v["����Ŀ��"], true)
	end

	--����Ŀ���ǵ�ǰ���ڶ�����ѩ��Ŀ��
	if casting("��ѩƮҡ") and v["����Ŀ��"] == casttarget() then
		return
	end

	--��Ԫ ���
	--if v["����Ŀ��Ѫ��"] < 0.95 then
	if fight() then
		if xbufftime("��Ԫ����", v["����Ŀ��"], id()) < -1 then
			xcast("��Ԫ����", v["����Ŀ��"], true)
		end
		if xbufftime("����", v["����Ŀ��"], id()) < -1 then
			xcast("�������", v["����Ŀ��"], true)
		end
		xcast("��Ԫ����", v["����Ŀ��"], true)
	end
	
	--��ѩ
	if v["����Ŀ��Ѫ��"] < 0.8 then
		xcast("��ѩƮҡ", v["����Ŀ��"], true)
	end

	if v["����Ŀ��Ѫ��"] < 0.4 then
		cast("���ٻ��")
		cast("�ؾ�����")
	end

	if v["����Ŀ��Ѫ��"] < 0.3 then
		cast("��筴�")
	end

	--��ս����
	--if casting("��������") and castleft() < 0.13 then
	--	settimer("�����������")
	--end
	if nofight() and gettimer("�����������") > 0.5 then
		xcast("��������", party("��״̬:����", "����<20", "���߿ɴ�"))
	end

	--��T��hot
	--xcast("��Ԫ����", party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�ҵ�buffʱ��:��Ԫ����<-1"))
	--xcast("�������", party("û״̬:����", "����<20", "�ڹ�:ϴ�辭|������|����������|������", "���߿ɴ�", "�ҵ�buffʱ��:����<-1"))

	--û�¸ɾ͸�������hot
	xcast("�������", party("û״̬:����", "����<20", "���߿ɴ�", "�ҵ�buffʱ��:����<-1"))

	if fight() then
		cast("��ҡֱ��")
	end
end

-------------------------------------------------------------------------------

f["��ȡ����Ŀ��"] = function()
	local targetID = id()	--����Ŀ��������Ϊ�Լ�, ���ڶ�������Ŷ���ʱ party ���� 0
	local partyID = party("û״̬:����", "�����Լ�", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����")	--��ȡѪ�����ٶ���
	if partyID ~= 0 and partyID ~= targetID and xlife(partyID) < life() then	--��Ѫ�����ٶ����ұ��Լ�Ѫ����
		targetID = partyID	--����ָ��Ϊ����Ŀ��
	end

	if xbufftime("С������", v["����Ŀ��Ѫ��"]) > 0 and xlife(targetID) > 0.6 then
		targetID = party("û״̬:����", "�����Լ�", "����<20", "���߿ɴ�", "û�ؾ�", "��Ѫ����", "ID������:"..targetID)
	end

	if targetID == 0 then
		targetID = id()
	end

	return targetID
end
