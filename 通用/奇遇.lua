


local counter = 1
--��ѭ��
function Main(g_player)
	nid = doodad("����:ɢ�����ҳ")
	if nid ~= 0 then
		output("����ɢ�����ҳ".. xdis(nid))
	end


	--moveto(xpos(tid()))
	if target() and dis() > 5 then
		moveToDis(5)
	end
end


-- �����ҵ�����Ϊ4�ĵ�ĺ���
function moveToDis(dist)
	print(dist)
	print(dis())
	if dis() < dist then
		return
	end

	local x1,y1,z1 = pos()
	local x2,y2,z2 = xpos(tid())

	-- �������� AB �ķ���
	local dx = x2 - x1
	local dy = y2 - y1

	-- ���� AB �ĳ���
	local len = dis()

	-- ������������
	local scale = dist / len

	output(dist..":"..len)
	-- ����� C ������
	local cx = x1 + (1 - scale) * dx
	local cy = y1 + (1 - scale) * dy

	moveto( cx, cy, z1)
end
