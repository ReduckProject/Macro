---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Gin.
--- DateTime: 2024/2/5 1:19
---

function Main()
    --interact(doodad("����:����|ֹѪ��|�ӵ׵�ɳʯ|����|�����˵�����|��¨|����|����|�ɲ�|ѩ��|��Ѫ������", "����<6", "�������"))


    if self().GetItemAmountInPackage(5, 7925) < 20 then
        if self().GetItemAmountInPackage(5, 7923) < 20 then
            interact(doodad("����:����", "����<6", "�������"))
        end

        if self().GetItemAmountInPackage(5, 7924) < 20 then
            interact(doodad("����:ʯ�ҷ�", "����<6", "�������"))
        end

        use(5, 7923)
    end

    if self().GetItemAmountInPackage(5, 7920) < 20 then
        interact(doodad("����:��ѿ������", "����<6", "�������"))
    end

    if self().GetItemAmountInPackage(5, 7922) < 10 then
        interact(doodad("����:��ù�ķ���", "����<6", "�������"))
    end

    --if self().GetItemAmountInPackage(5, 7921) < 20 then
    --    interact(doodad("����:���õ�����", "����<6", "�������"))
    --end
end
