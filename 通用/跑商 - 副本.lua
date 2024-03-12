local coordinates = {
    { 49252, 5638, 1058880 },
    { 49252, 5638, 1058880 },
    { 49360, 5908, 1058624 },
    { 49540, 6358, 1058240 },
    { 49720, 6807, 1058048 },
    { 49882, 7212, 1058048 },
    { 50062, 7662, 1058048 },
    { 50224, 8067, 1057920 },
    { 50404, 8516, 1057408 },
    { 50582, 8952, 1056448 },
    { 50743, 9355, 1056128 },
    { 50830, 9833, 1056128 },
    { 50859, 10311, 1055808 },
    { 50824, 10742, 1055936 },
    { 50784, 11221, 1056448 },
    { 50748, 11653, 1057088 },
    { 50708, 12129, 1057984 },
    { 50672, 12560, 1058176 },
    { 50632, 13040, 1057792 },
    { 50592, 13520, 1057408 },
    { 50556, 13949, 1056832 },
    { 50516, 14427, 1056448 },
    { 50480, 14859, 1056256 },
    { 50440, 15337, 1055936 },
    { 50400, 15817, 1055680 },
    { 50364, 16249, 1055488 },
    { 50324, 16729, 1055232 },
    { 50288, 17161, 1054976 },
    { 50248, 17639, 1055040 },
    { 50208, 18119, 1055232 },
    { 50172, 18551, 1055296 },
    { 50132, 19031, 1055360 },
    { 50092, 19511, 1055872 },
    { 50056, 19943, 1056320 },
    { 50016, 20423, 1056512 },
    { 49980, 20855, 1056704 },
    { 49940, 21335, 1056960 },
    { 49904, 21767, 1057216 },
    { 49864, 22246, 1057728 },
    { 49824, 22723, 1058368 },
    { 49788, 23154, 1058624 },
    { 49748, 23634, 1058880 },
    { 49712, 24066, 1059072 },
    { 49672, 24546, 1059328 },
    { 49632, 25026, 1059456 },
    { 49562, 25458, 1059712 },
    { 49462, 25937, 1060096 },
    { 49362, 26416, 1060288 },
    { 49272, 26848, 1060352 },
    { 49172, 27328, 1060480 },
    { 49082, 27756, 1060352 },
    { 48982, 28230, 1059520 },
    { 48892, 28639, 1058368 },
    { 48792, 29099, 1057088 },
    { 48692, 29567, 1056064 },
    { 48602, 29996, 1055680 },
    { 48502, 30476, 1055552 },
    { 48412, 30908, 1055552 },
    { 48312, 31388, 1055552 },
    { 48212, 31867, 1055616 },
    { 48128, 32299, 1055616 },
    { 48045, 32779, 1055680 },
    { 47965, 33259, 1055680 },
    { 47893, 33691, 1055680 },
    { 47823, 34121, 1055680 },
    { 47743, 34601, 1055680 },
    { 47663, 35081, 1055680 },
    { 47591, 35513, 1055680 },
    { 47511, 35993, 1055680 },
    { 47530, 36456, 1055680 },
    { 47682, 36768, 1055680 },
    { 47829, 37077, 1055680 },
    { 48143, 37154, 1055680 },
    { 48143, 37154, 1055680 }
}

_state = {
    length = #coordinates,
    index = 1,
    dif = 10,
	add = true
}


function Main(g_player)
    --clickButton("Normal/TopMenu/WndContainer_List/Wnd_OperationActivty/Btn_OperationActivty/")
    --	--clickButton("Topmost/MB_on_switch_map_sure/Wnd_All/Btn_Option1/")
    --	--if not ok then
    --	--	clickButton("Lowest/ActionBar2/")
    --	--	file=io.open("/test.txt","a")
    --	--	io.output(file)-- 设置默认输出文件
    --	--	io.write("last row!")
    --	--	io.close()
    --	--	ok=true
    --	--end
    --
    --	--clickButton("Topmost/MB_on_switch_map_sure/Wnd_All/Btn_Option1/")
    --if count % 10 == 0 then
    --	print(pos())
    --end
    --count = count + 1

    --moveto(29879, 41587, 1240832)
	print(_state.length, _state.index)
	moveto(coordinates[_state.index][1], coordinates[_state.index][2], coordinates[_state.index][3])

	--if Next() then
    --    if _state.index < _state.length then
    --        _state.index = _state.index + 1
    --    end
    --end

	Actions()
end

function OnMessage(szMsg, szType)
    print(szMsg .. "---" .. szType)
end

function Next()
    local x, y, z = pos()
    local _x, _y, _z = coordinates[_state.index][1], coordinates[_state.index][2], coordinates[_state.index][3]
    if (math.abs(x - _x) < 100 and math.abs(y - _y) < 100 and math.abs(z - _z) < 100) then
		print(coordinates[_state.index][1], coordinates[_state.index][2], coordinates[_state.index][3])
        return true
    else
		print(math.abs(x - _x), math.abs(y - _y) , math.abs(z - _z))
        return false
    end
end


function Actions()
	if map("龙门荒漠") then

	end
	--if Next() then
	--	if _state.index < _state.length then
	--		_state.index = _state.index + 1
	--	end
	--end

	if _state.index == _state.length then
		_state.add = false
	end

	if Next() then
		if _state.add then
			if _state.index < _state.length then

				_state.index = _state.index + 1
			end
		else
			if _state.index > 1 then
				_state.index = _state.index - 1
			end
		end
	end
end

