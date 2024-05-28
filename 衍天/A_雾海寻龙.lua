--奇穴: [水盈][望旗][顺祝][列宿游][重山][神遁][亘天][连断][休囚][征凶][灵器][增卜]

--载入库
load("Macro/Lib_PVP.lua")

--变量表
local v = {}

--函数表
local f = {}

local counter = 0

--主循环
function Main(g_player)
    if npc("名字:天罡武卫", "角色距离<4") ~= 0 then
		g_func["敌对释放"]("巨门北落")
        if cdtime("踏星行") == 0 then
			g_func["敌对释放"]("鸿蒙天禁")
			g_func["敌对释放"]("踏星行")
			g_func["敌对释放"]("返闭惊魂")
        end
    end

    if target() and tid() ~= id() and xrela("敌对", tid()) then
		if dengcount() < 1 then
			return
		end
        if tbuffstate("可拉") then
            g_func["敌对释放"]("斗转星移")
        --else
        --    settar(id())
        end
    end

    if cdtime("斗转星移") > 33 then
        settar(id())
    end

    if cdtime("斗转星移") > 33 then
        if cdtime("踏星行") == 0 then
            g_func["敌对释放"]("踏星行")
            settar(id())
        end
    end

    --counter = counter + 1
    --if counter ~= 5 then
    --	return
    --end
    --output("sss")
    --初始化


    if cdtime("斗转星移") == 0 then
        nid = player("可选中", "视线可达", "自己可视", "可视自己", "关系:敌对", "距离<24")

        if nid ~= 0 then
            if xbuffstate("可拉", nid) then
                settar(nid)
            end

        end
    end

    counter = 0
end

