local function ZuoSplitStr2Array(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + 1
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end
local MyAccount=GetUserAccount() 

if ToolsAccount==nil then return end
local ToolsAccounts =  ZuoSplitStr2Array(ToolsAccount,",")

local ret = false
for k,v in pairs(ToolsAccounts) do
	if MyAccount == v then
		ret =true
	end
end

if not ret then
	ReInitUI(1)
end 

