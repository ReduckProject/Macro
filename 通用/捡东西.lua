---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Gin.
--- DateTime: 2024/2/5 1:19
---

function Main()
    --interact(doodad("����:����|ֹѪ��|�ӵ׵�ɳʯ|����|�����˵�����|��¨|����|����|�ɲ�|ѩ��|��Ѫ������", "����<6", "�������"))


    local nid = doodad("��ʰȡ","�������")

    clickButton("Topmost/MB_DropItemSure/Wnd_All/Btn_Option1/")
    if nid ~= 0 then
        moveto(xpos(nid))
        interact(nid)
    end
end
