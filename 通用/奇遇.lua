


local counter = 1
--主循环
function Main(g_player)
	nid = doodad("名字:散落的书页")
	if nid ~= 0 then
		output("发现散落的书页".. xdis(nid))
	end


	--moveto(xpos(tid()))
	if target() and dis() > 5 then
		moveToDis(5)
	end
end


-- 定义找到距离为4的点的函数
function moveToDis(dist)
	print(dist)
	print(dis())
	if dis() < dist then
		return
	end

	local x1,y1,z1 = pos()
	local x2,y2,z2 = xpos(tid())

	-- 计算向量 AB 的分量
	local dx = x2 - x1
	local dy = y2 - y1

	-- 计算 AB 的长度
	local len = dis()

	-- 计算缩放因子
	local scale = dist / len

	output(dist..":"..len)
	-- 计算点 C 的坐标
	local cx = x1 + (1 - scale) * dx
	local cy = y1 + (1 - scale) * dy

	moveto( cx, cy, z1)
end
