


local counter = 1
--Ö÷Ñ­»·
function Main(g_player)
	counter = counter + 1
	if counter % 16 ~= 0 then return end
	clickButton("Normal/DdzPanel/Wnd_Operations/Wnd_Prepare/Btn_Ready/")
	clickButton("Normal/DdzPanel/Wnd_Operations/Wnd_Playing/Wnd_Affordable/Btn_Buchu/")
	--clickButton("Normal/DdzPanel/Wnd_Operations/Wnd_Demand_Dizhu/Btn_Demand_No/")
	--clickButton("Normal1/DdzSettlementPanel/Btn_Close/")
end
