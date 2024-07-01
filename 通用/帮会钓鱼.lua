--买好鱼饵，背包留足够空间, 在帮会池塘边开始运行

local counter = 0
function Main(g_player)

	if nobuff("27477") and counter % 10 == 0 then
		cast(35959)
		cast(35963)
		cast(35964)
		cast(35965)
		cast(35966)
	end
	counter = counter + 1

	--if counter == 16 then
	--	clickButton("Normal/GetFishPanel/WndContainer_ListAndOperation/WndContainer_NormalFishOperation/Btn_PutInBag/")
	--end
end


function OnMessage(szMsg, szType)
	--output(szMsg)
	if szMsg.find(szMsg,"收杆") then
		cast(35959)
		counter = 1
	end
end