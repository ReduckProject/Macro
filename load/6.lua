--//初始化
if not ZMAC then return end

local ipairs, pairs,tonumber,tostring,type,string       = ipairs, pairs,tonumber,tostring,type,string
local pcall,loadstring                            = pcall,loadstring
local t_insert, t_sort, t_remove, t_concat       = table.insert, table.sort, table.remove, table.concat
local s_sub,s_find,s_format,s_match,s_gsub,s_len ,s_byte,s_char= string.sub,string.find,string.format,string.match,string.gsub,string.len,string.byte,string.char
local m_floor, m_min ,m_ceil,m_abs               = math.floor, math.min,math.ceil,math.abs

local GetPlayer            = GetPlayer
local GetNpc               = GetNpc
local IsPlayer             = IsPlayer
local UI_GetClientPlayerID = UI_GetClientPlayerID
local GetClientPlayer      = GetClientPlayer
local GetClientTeam        = GetClientTeam
local GetLogicFrameCount   = GetLogicFrameCount
local GetFormatText        = GetFormatText
local SetTarget            = SetTarget
local SelectTarget         = SelectTarget
local GetForceTitle        = GetForceTitle
local GetTargetHandle      = GetTargetHandle
local GetTarget            = GetTarget
local GetSkill             = GetSkill
local Table_GetMapName     = Table_GetMapName
local Table_GetSkill       = Table_GetSkill
local Table_GetSkillName   = Table_GetSkillName
local Skill_GetCongNengCDID= Skill_GetCongNengCDID
local GetCharacterDistance = GetCharacterDistance
local GetBuff              = GetBuff
local Table_GetBuffName    = Table_GetBuffName
local GetTime              = GetTime
local TimeToDate           = TimeToDate
local GetLocalTime         = GetLocalTime
local GetTickCount         = GetTickCount
local StringLowerW         = StringLowerW
local StringReplaceW       = StringReplaceW
local StringFindW          = StringFindW
local Output               = Output
local TurnTo               = TurnTo
local AutoMoveToTarget     = AutoMoveToTarget
local AutoMoveToPoint      = AutoMoveToPoint
local GetLogicDirection    = GetLogicDirection
local Camera_EnableControl = Camera_EnableControl
local Scene_GameWorldPositionToScenePosition = Scene_GameWorldPositionToScenePosition

local IsEnemy              = IsEnemy
local IsAlly               = IsAlly
local IsParty              = IsParty
local IsNeutrality         = IsNeutrality

local OnUseItem            = OnUseItem
local OnUseSkill           = OnUseSkill
local CastSkill            = CastSkill
local CastSkillXYZ         = CastSkillXYZ
local ActionBar_Cast       = ActionBar_Cast

local function _ZMAC_SplitStr2Array2(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = s_find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = s_sub(szFullString, nFindStartIndex, s_len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = s_sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + 1
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

local _ZMAC_Compare2=function (cType, RealNum, cNum)
	local Boolean = false
	local RealNum = tonumber(RealNum)
	local cNum = tonumber(cNum)
	if cType=='>' then Boolean = RealNum>cNum end
	if cType=='<' then Boolean = RealNum<cNum end
	if cType=='=' then Boolean = RealNum==cNum end
	return Boolean
end

rtime = function(pDate, cType)
	
	local pAAA = _ZMAC_SplitStr2Array2(pDate,'-')
	
	local pYear ,pMonth,pDay,pHour,pMin,pSec = tonumber(pAAA[1]),tonumber(pAAA[2]),tonumber(pAAA[3]),tonumber(pAAA[4]),tonumber(pAAA[5]),tonumber(pAAA[6])
	
	
	local timelib = TimeToDate(GetCurrentTime())
	local nYear,nMonth,nDay,nHour,nMin,nSec = timelib['year'],timelib['month'],timelib['day'],timelib['hour'],timelib['minute'],timelib['second']
	
	local pTime11 = pYear*365 + pMonth*30 + pDay + pHour/24 + (pMin/24)/60 + (pSec/24)/360
	local nTime11 = nYear*365 + nMonth*30 + nDay + nHour/24 + (nMin/24)/60 + (nSec/24)/360
	return _ZMAC_Compare2(cType, nTime11 , pTime11)
end



if rtime('2024-9-21-23-59-59','>') then
	
	return
end




local _ZMAC = {}

_ZMAC.Macro = {}    --宏表，用于系统宏管理器编辑时，自动保存明文至此表
ZMAC.Switch = {}    --技能开关

local aCommand = {}  --宏命令键值表，用于连接“/cast”指令与“Cast” function
local aCommandHelp = {}  --宏帮助文档
local bIsThisAccount = true   
local ConfigFlag = true  --config函数用的变量，判断条件是否符合
local bProtectChannel = false			--/config是否保护引导

WY={} --老宏遗留

local SCHOOL_NAME = {
	["侠士"] = 0,
	["天策"] = 1,
	["万花"] = 2,
	["纯阳"] = 3,
	["七秀"] = 4,
	["少林"] = 5,
	["藏剑"] = 6,
	["丐帮"] = 7,
	["明教"] = 8,
	["五毒"] = 9,
	["唐门"] = 10,
	["丐幫"] = 0,
	--...
}

local KUNG_FU_MOUNT = {
	["傲血战意"] = 10026,
	["铁牢律"] = 10062,
	["易筋经"] = 10003,
	["洗髓经"] = 10002,
	["问水诀"] = 10144,
	["山居剑意"] = 10145,
	["太虛剑意"] = 10015,
	["紫霞功"] = 10014,
	["冰心诀"] = 10081,
	["云裳心经"] = 10080,
	["离经易道"] = 10028,
	["花间游"] = 10021,
	["天罗诡道"] = 10225,
	["惊羽诀"] = 10224,
	["补天诀"] = 10176,
	["毒经"] = 10175,
	["焚影圣诀"] = 10242,
	["明尊琉璃体"] = 10243,
	["笑尘诀"] = 10268,
	["分山劲"] = 10390,
	["铁骨衣"] = 10389,
}

local TARGET_TYPE ={
	["玩家"] = TARGET.PLAYER,
	["普通"] = 1,
	["高手"] = 2,
	["头目"] = 3,
	["领袖"] = 4,
}

local MOVE_STATUS = {
	["dash"] = MOVE_STATE.ON_DASH,						--衝刺
	["death"] = MOVE_STATE.ON_DEATH,					--重傷
	["entrap"] = MOVE_STATE.ON_ENTRAP,					--定身
	["float"] = MOVE_STATE.ON_FLOAT,					--水中懸浮
	["freeze"] = MOVE_STATE.ON_FREEZE,					--定身
	["halt"] = MOVE_STATE.ON_HALT,						--眩暈
	["jump"] = MOVE_STATE.ON_JUMP,						--跳躍
	["back"] = MOVE_STATE.ON_KNOCKED_BACK,				--被擊退
	["down"] = MOVE_STATE.ON_KNOCKED_DOWN,				--被擊倒
	["off"] = MOVE_STATE.ON_KNOCKED_OFF,				--被擊飛
	["pull"] = MOVE_STATE.ON_PULL,						--被抓
	["repulsed"] = MOVE_STATE.ON_REPULSED,				--滑行
	["rise"] = MOVE_STATE.ON_RISE,						--爬起
	["run"] = MOVE_STATE.ON_RUN,						--跑步
	["sit"] = MOVE_STATE.ON_SIT,						--坐下
	["skid"] = MOVE_STATE.ON_SKID,						--滑行
	["stand"] = MOVE_STATE.ON_STAND,					--站立
	["swim"] = MOVE_STATE.ON_SWIM,						--游泳
	["swimjump"] = MOVE_STATE.ON_SWIM_JUMP,				--水中跳躍
	["walk"] = MOVE_STATE.ON_WALK,						--走路
	["move"] = 26,						--攻擊位移狀態
	["bmove"] = 27,						--被擊位移狀態
	["硬直"] = 28,						--硬直
}

local nMoveStateList = {       --缘起里没有MOVE_STATE常量，需要手动用or兼容
	['stand'] = MOVE_STATE.ON_STAND or 1,
	['walk'] = MOVE_STATE.ON_WALK or 2,
	['run'] = MOVE_STATE.ON_RUN or 3,
	['jump'] = MOVE_STATE.ON_JUMP or 4,
	['swimjump'] = MOVE_STATE.ON_SWIM_JUMP or 5,
	['swim'] = MOVE_STATE.ON_SWIM or 6,
	['float'] = MOVE_STATE.ON_FLOAT or 7,
	['sit'] = MOVE_STATE.ON_SIT or 8,
	['down'] = MOVE_STATE.ON_KNOCKED_DOWN or 9,
	['back'] = MOVE_STATE.ON_KNOCKED_BACK or 10,
	['off'] = MOVE_STATE.ON_KNOCKED_OFF or 11,
	['halt'] = MOVE_STATE.ON_HALT or 12,
	['freeze'] = MOVE_STATE.ON_FREEZE or 13,
	['entrap'] = MOVE_STATE.ON_ENTRAP or 14,
	['autofly'] = MOVE_STATE.ON_AUTO_FLY or 15,
	['death'] = MOVE_STATE.ON_DEATH or 16,
	['dash'] = MOVE_STATE.ON_DASH or 17,
	['pull'] = MOVE_STATE.ON_PULL or 18,
	['repulsed']=MOVE_STATE.ON_REPULSED or 19,  --击退
	['rise'] = MOVE_STATE.ON_RISE or 20,
	['skid'] = MOVE_STATE.ON_SKID or 21,
	['sprintbreak'] =MOVE_STATE.ON_SPRINT_BREAK or 22,
	["move"] = 26,						--攻擊位移狀態
	["bmove"] = 27,						--被擊位移狀態
	["recover"] = 28,						--硬直
	['invalid'] = MOVE_STATE.INVALID or 0,   --还有位移、僵直、收招、飞行、轻功、登顶、蓬莱浮空等未写
}

--保护引导的技能,用于记录自己最后释放技能的时间,在function Cast中加入条件，防止执行过快断读条
local SelfProtectSkill ={
	['酒中仙']=true,
	['盾舞']=true,
	['六合独尊']=true,
	['凝神聚气']=true,
	['快雪时晴']=true,
	['风来吴山']=true,
	['醉舞九天']=true,
	['千蝶吐瑞']=true,
	['玳弦急曲']=true,
	['回雪飘摇']=true,
	['左旋右转']=true,
	['月华倾泻']=true,
	['玲珑箜篌']=true,
	['笑醉狂']=true,
	['鬼斧神工']=true,
	['暴雨梨花针']=true,
	['连环弩']=true,
	['朝圣言']=true,
	['号令三军']=true,
	['醉斩白蛇']=true,
	--['万世不竭']=true,
	['徵']=true,
	['川乌射罔']=true,
	['斩无常']=true,
	['秒无狗']=true,
	
}

local btype = {}
btype[1] = '外攻'
btype[3] = '阳性'
btype[5] = '混元'
btype[7] = '阴性'
btype[11] = '毒性'
btype[13] = '蛊'
local detype = {}
detype[2] = '外攻'
detype[4] = '阳性'
detype[6] = '混元'
detype[8] = '阴性'
detype[10] = '点穴'
detype[12] = '毒性'
detype[14] = '蛊'

--透支技能时间字典，用于判定透支技能层数,cd与层数
_ZMAC.TouzhiSkillList = {
	[16602]={9,2},          --破釜沉舟
	[16629]={16,3},         --雷走风切
	[16608]={40,3},         --散流霞
	[16633]={20,3},         --踏宴扬旗
	[16479]={16,3},         --割据秦宫
	[16620]={40,2},         --封渊震煞
	[27556]={10,2},         --川乌射罔
	[312]  ={18,2},          --坐忘无我
	
	[28680]={35,3},         --鸣震九霄
	}


_ZMAC.Pup={
	['连弩'] = 16175,
	['重弩'] = 16176,
	['毒刹'] = 16177,
	['底座'] = 16174,
}
--宠物技能ID
local g_PetSkillNameToID = {['天蛛引']=2225,['圣蝎引']=2221,['风蜈引']=2224,['灵蛇引']=2223,['玉蟾引']=2222,['碧蝶引']=2965}
--免保护引导技能
local Dict_NoBrokenSKill={
	['中断读条']=true,
	['阳春白雪']=true,
	['测试']=true,
	['面对目标']=true,
	['宠物攻击']=true,['宠物跟随']=true,['宠物停留']=true,['主动型']=true,['防御型']=true,['被动型']=true,
	['煽弄']=true,['归巢']=true,['丝牵']=true,['蝎蜇']=true,['影滞']=true,['幻击']=true,['蟾躁']=true,
	['千机变攻击']=true,['千机变停止']=true,
	['连弩形态']=true,['重弩形态']=true,['毒刹形态']=true,['连弩']=true,['重弩']=true,['毒刹']=true,
	['返回登录']=true,
	['南风吐月']=true,['折叶笼花']=true,['镇山河']=true, --救命技能,无视保护
}

_ZMAC.FakeSkillList = {
	['返回登录']=true,
	['自动魂灯']=true,
	['自动魂灯2']=true,
	['全局治疗']=true,
	['全局打断']=true,
	['全局断奶']=true,
	['全局转火']=true,
	['全局群人']=true,
	['全局决斗']=true,
	
	['飞星·改']=true,
	['全局蚀奶']=true,
	['中断读条']=true,
	['打断自己']=true,
	['停止执行']=true,
	['停止移动']=true,
	['面对目标']=true,
	['背对目标']=true,
	['自动绕背']=true,
	['向前移动']=true,
	['向后移动']=true,
	['选择自己']=true,
	['破盾']=true,
	['破魔']=true,
	['轻功躲避']=true,
	['破壁']=true,
	['下马']=true,
	['跟随目标']=true,
	['小轻功']=true,
	['测试']=true,
	['跳']=true,
	['向上轻功']=true,
	['向前轻功']=true,
	['向后轻功']=true,
	['向前上轻功']=true,
	['向后上轻功']=true,
	['日月晦·隐']=true,
	['秒无狗']=true,
	['烟雨行前']=true,
	['烟雨行后']=true,
	['烟雨行左']=true,
	['烟雨行右']=true,
	
	['日月晦一段假']=true,
	['日月晦二段假']=true,
	['日月晦三段假']=true,
	
}

local BaseSkillList = {
			['六合棍'] =  11,
			['梅花枪法'] =  12,
			['三柴剑法'] =  13,
			['长拳']=14,  
			['连环双刀']= 15,
			['判官笔法'] = 16,
			['四季剑法']=1795,	
			['大荒笛法']=2183, 			
			['罡风镖法']=3121,
			['大漠刀法']=4326,
			['卷雪刀']=13039, 
			['五音六律']=14063,  
			['霜风刀法']=16010, 
			['飘遥伞击']=19712,
			['碎风刃']=22126, 
			['魂击']=25512, 
			['裁叶饮刃'] = 27451,
			['药宗未知待查']=000,   --待处理
			}
			
--秘籍列表
_ZMAC.tAllRecipeList={}         --获取全职业所有秘籍列表 szRecipeNmae = recipe_id
do
	for i=1,g_tTable.SkillRecipe:GetRowCount() do
		
		local tSkillRecipe = g_tTable.SkillRecipe:GetRow(i)
		if tSkillRecipe then
			local szName = tSkillRecipe.szName
			if szName and szName~='' and tSkillRecipe.dwSkillID~=0 then
				local szSkillName,szRecipe = szName:match('·(.+)》(.+)')
				if szSkillName and szRecipe then
					_ZMAC.tAllRecipeList[szSkillName..szRecipe] = {tSkillRecipe.dwID , tSkillRecipe.dwSkillID}
				end
			end
		end
	end
end

--//加解密
--_Base64
local _Base64 = {}
_Base64.__code = {
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
            'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
            'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/',
        };
_Base64.__decode = {}
for k,v in pairs(_Base64.__code) do
    _Base64.__decode[s_byte(v,1)] = k - 1 
end
function _Base64.encode(text)
    local len11 = s_len(text)
    local left = len11 % 3
    len11 = len11 - left
    local res = {}
    local index  = 1
    for i = 1, len11, 3 do
        local a = s_byte(text, i )
        local b = s_byte(text, i + 1)
        local c = s_byte(text, i + 2)
        -- num = a<<16 + b<<8 + c
        local num = a * 65536 + b * 256 + c 
        for j = 1, 4 do
            --tmp = num >> ((4 -j) * 6)
            local tmp = m_floor(num / (2 ^ ((4-j) * 6)))
            --curPos = tmp&0x3f
            local curPos = tmp % 64 + 1
            res[index] = _Base64.__code[curPos]
            index = index + 1
        end
    end

    if left == 1 then
        _Base64.__left1(res, index, text, len11)
    elseif left == 2 then
        _Base64.__left2(res, index, text, len11)        
    end
    return t_concat(res)
end
function _Base64.__left2(res, index, text, len11)
    local num1 = s_byte(text, len11 + 1)
    num1 = num1 * 1024 --lshift 10 
    local num2 = s_byte(text, len11 + 2)
    num2 = num2 * 4 --lshift 2 
    local num = num1 + num2
   
    local tmp1 = m_floor(num / 4096) --rShift 12
    local curPos = tmp1 % 64 + 1
    res[index] = _Base64.__code[curPos]
    local tmp2 = m_floor(num / 64)
    curPos = tmp2 % 64 + 1
    res[index + 1] = _Base64.__code[curPos]

    curPos = num % 64 + 1
    res[index + 2] = _Base64.__code[curPos]
    
    res[index + 3] = "=" 
end
function _Base64.__left1(res, index,text, len11)
    local num = s_byte(text, len11 + 1)
    num = num * 16 
    
    tmp = m_floor(num / 64)
    local curPos = tmp % 64 + 1
    res[index ] = _Base64.__code[curPos]
    
    curPos = num % 64 + 1
    res[index + 1] = _Base64.__code[curPos]
    
    res[index + 2] = "=" 
    res[index + 3] = "=" 
end
function _Base64.decode(text)
    local len11 = s_len(text)
    local left = 0 
    if s_sub(text, len11 - 1) == "==" then
        left = 2 
        len11 = len11 - 4
    elseif s_sub(text, len11) == "=" then
        left = 1
        len11 = len11 - 4
    end

    local res = {}
    local index = 1
    local decode = _Base64.__decode
    for i =1, len11, 4 do
        local a = decode[s_byte(text,i    )] 
        local b = decode[s_byte(text,i + 1)] 
        local c = decode[s_byte(text,i + 2)] 
        local d = decode[s_byte(text,i + 3)]

        --num = a<<18 + b<<12 + c<<6 + d
        local num = a * 262144 + b * 4096 + c * 64 + d
        
        local e = s_char(num % 256)
        num = m_floor(num / 256)
        local f = s_char(num % 256)
        num = m_floor(num / 256)
        res[index ] = s_char(num % 256)
        res[index + 1] = f
        res[index + 2] = e
        index = index + 3
    end

    if left == 1 then
        _Base64.__decodeLeft1(res, index, text, len11)
    elseif left == 2 then
        _Base64.__decodeLeft2(res, index, text, len11)
    end
    return t_concat(res)
end
function _Base64.__decodeLeft1(res, index, text, len11)
    local decode = _Base64.__decode
    local a = decode[s_byte(text, len11 + 1)] 
    local b = decode[s_byte(text, len11 + 2)] 
    local c = decode[s_byte(text, len11 + 3)] 
    local num = a * 4096 + b * 64 + c
    
    local num1 = m_floor(num / 1024) % 256
    local num2 = m_floor(num / 4) % 256
    res[index] = s_char(num1)
    res[index + 1] = s_char(num2)
end
function _Base64.__decodeLeft2(res, index, text, len11)
    local decode = _Base64.__decode
    local a = decode[s_byte(text, len11 + 1)] 
    local b = decode[s_byte(text, len11 + 2)]
    local num = a * 64 + b
    num = m_floor(num / 16)
    res[index] = s_char(num)
end
--_ZMAC_transMacro
local _ZMAC_transMacro={}
local OriginTXT = {   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'a', 'B', 'b', 'C', 'c', 'D', 'd', 'E', 'e', 'f', 'F', 'g', 'G', 'h', 'H', 'i', 'I', 'j', 'J', 'K', 'k', 'L', 'l', 'M', 'm', 'N', 'n', 'O', 'o', 'P', 'p', 'Q', 'q', 'R', 'r', 'S', 's', 'T', 't', 'U', 'u', 'v', 'V', 'W', 'w', 'X', 'x', 'Y', 'y', 'Z', 'z', '+','/','='}
local EncodeTXT =  { "x","p","W","9","4","Q","7","/","n","L","o","1","M","d","3","j","f","=","G","w","b","Z","X","8","s","P","S","A","k","g","E","i","F","B","a","C","t","z","U","c","V","v","r","Y","D","R","I","T","0","J","5","2","K","e","l","h","O","y","H","u","q","N","+","6","m"}
local Encode_ZMAC = { '9', 'x', 'p', 'W', '4', '7', '/', 'n', 'L', 'o', '1', 'M', 'd', '3', 'j', 'f', '=', 'G', 'w', 'b', 'Z', 'X', '8', 's', 'P', 'S', 'A', 'k', 'g', 'E', 'i', 'F', 'B', 'a', 'C', 't', 'z', 'U', 'c', 'V', 'v', 'r', 'Y', 'D', 'R', 'I', 'T', '0', 'J', '5', '2', 'K', 'e', 'h', 'O', 'y', 'l', 'H', 'Q', 'u', 'q', 'N', '+', '6', 'm' }
local _Dictbase2macro = {}
local _Dictmacro2base = {}
local _Dictmacro2base_ZMAC = {}
for k,v in pairs(OriginTXT) do
	_Dictbase2macro[v] = EncodeTXT[k]
end
for k,v in pairs(EncodeTXT) do
	_Dictmacro2base[v] = OriginTXT[k]
end
for k,v in pairs(Encode_ZMAC) do
	_Dictmacro2base_ZMAC[v] = OriginTXT[k]
end
_Dictmacro2base={
['=']='=',
['N']='0',
['O']='1',
['a']='2',
['b']='3',
['c']='4',
['t']='5',
['u']='6',
['w']='8',
['x']='9',
['H']='A',
['V']='a',
['I']='B',
['W']='b',
['J']='C',
['X']='c',
['K']='D',
['Y']='d',
['L']='E',
['Z']='e',
['o']='f',
['M']='F',
['p']='g',
['0']='G',
['q']='h',
['1']='H',
['r']='i',
['2']='I',
['s']='j',
['3']='J',
['4']='K',
['6']='k',
['5']='L',
['7']='l',
['d']='M',
['8']='m',
['e']='N',
['9']='n',
['f']='O',
['+']='o',
['g']='P',
['P']='p',
['h']='Q',
['Q']='q',
['i']='R',
['R']='r',
['j']='S',
['m']='s',
['k']='T',
['n']='t',
['l']='U',
['A']='u',
['B']='v',
['C']='V',
['D']='W',
['S']='w',
['E']='X',
['T']='x',
['F']='Y',
['U']='y',
['G']='Z',
['/']='z',
['v']='7',
['y']='+',
['z']='/',
['\n']='\n',
['\r']='\r'
}
_Dictbase2macro={
['=']='=',
['0']='N',
['1']='O',
['2']='a',
['3']='b',
['4']='c',
['5']='t',
['6']='u',
['8']='w',
['9']='x',
['A']='H',
['a']='V',
['B']='I',
['b']='W',
['C']='J',
['c']='X',
['D']='K',
['d']='Y',
['E']='L',
['e']='Z',
['f']='o',
['F']='M',
['g']='p',
['G']='0',
['h']='q',
['H']='1',
['i']='r',
['I']='2',
['j']='s',
['J']='3',
['K']='4',
['k']='6',
['L']='5',
['l']='7',
['M']='d',
['m']='8',
['N']='e',
['n']='9',
['O']='f',
['o']='+',
['P']='g',
['p']='P',
['Q']='h',
['q']='Q',
['R']='i',
['r']='R',
['S']='j',
['s']='m',
['T']='k',
['t']='n',
['U']='l',
['u']='A',
['v']='B',
['V']='C',
['W']='D',
['w']='S',
['X']='E',
['x']='T',
['Y']='F',
['y']='U',
['Z']='G',
['z']='/',
['7']='v',
['+']='y',
['/']='z'}
_ZMAC_transMacro.jiemi = function(str)
	local tmp = s_gsub(str, "['=''N''O''a''b''c''t''u''w''x''H''V''I''W''J''X''K''Y''L''Z''o''M''p''0''q''1''r''2''s''3''4''6''5''7''d''8''e''9''f''+''g''P''h''Q''i''R''j''m''k''n''l''A''B''C''D''S''E''T''F''U''G''/''v''y''z''\r''\n''\r']", _Dictmacro2base)
	tmp = _Base64.decode(tmp) 
	tmp = s_gsub(tmp ,'\r\n','\n')    
	return tmp
end
_ZMAC_transMacro.jiami = function(str)
	local tmp = _Base64.encode(str)
	return s_gsub(tmp ,"['=''0''1''2''3''4''5''6''7''8''9''a''b''c''d''e''f''g''h''i''j''k''l''m''n''o''p''q''r''s''t''u''v''w''x''y''z''A''B''C''D''E''F''G''H''I''J''K''L''M''N''O''P''Q''R''S''T''U''V''W''X''Y''Z''+''/']", _Dictbase2macro)
end




--//Debug
_ZMAC_PrintKaiguan = false
_ZMAC_PrintKaiguanRed = false
local EncodeSZ=function(sz,r,g,b)
	sz=string.gsub(tostring(sz),"\""," ")
	return "<text>text=\""..sz.."\" r="..(r or 0).." g="..(g or 255).." b="..(b or 255).." </text>"
end
local szPrintStart=EncodeSZ("> ",255,0,0)
local szPrintEnd=EncodeSZ("\n")
_ZMAC.Print = function(szType,szStr)
	if _ZMAC_PrintKaiguan ==true then
		OutputMessage(szType,szStr)
	end
end
_ZMAC.colorPrint=function(...)
	if _ZMAC_PrintKaiguan ~=true then
		return
	end
	
	local t={...}
	for i,v in pairs(t)do
		if type(v) == 'string' then
			t[i]=EncodeSZ(v,255,0,0)   
		else
			t[i]=EncodeSZ(unpack(v))
		end
	end
	OutputMessage("MSG_SYS",table.concat(t)..EncodeSZ("\n"),true)
end
_ZMAC.PrintRed=function(...)
	if _ZMAC_PrintKaiguan ~=true and _ZMAC_PrintKaiguanRed ~= true then
		return
	end
	
	local t={...}
	for i,v in pairs(t)do
		if type(v) == 'string' then
			t[i]=EncodeSZ(v,255,0,0)    --不写就默认红色
		else
			t[i]=EncodeSZ(unpack(v))
		end
	end
	OutputMessage("MSG_SYS",table.concat(t)..EncodeSZ("\n"),true)
end
_ZMAC.PrintBlue=function(...)
	if _ZMAC_PrintKaiguan ~=true then
		return
	end
	
	local t={...}
	for i,v in pairs(t)do
		if type(v) == 'string' then
			t[i]=EncodeSZ(v,0,0,255)    
		else
			t[i]=EncodeSZ(unpack(v))
		end
	end
	OutputMessage("MSG_SYS",table.concat(t)..EncodeSZ("\n"),true)
end
_ZMAC.PrintGreen=function(...)
	if _ZMAC_PrintKaiguan ~=true then
		return
	end
	
	local t={...}
	for i,v in pairs(t)do
		if type(v) == 'string' then
			t[i]=EncodeSZ(v,0,128,0)    
		else
			t[i]=EncodeSZ(unpack(v))
		end
	end
	OutputMessage("MSG_SYS",table.concat(t)..EncodeSZ("\n"),true)
end
_ZMAC.PrintGray=function(...)
	if _ZMAC_PrintKaiguan ~=true then
		return
	end
	
	local t={...}
	for i,v in pairs(t)do
		if type(v) == 'string' then
			t[i]=EncodeSZ(v,128,128,128)    
		else
			t[i]=EncodeSZ(unpack(v))
		end
	end
	OutputMessage("MSG_SYS",table.concat(t)..EncodeSZ("\n"),true)
end
_ZMAC.PrintOrange=function(...)
	if _ZMAC_PrintKaiguan ~=true then
		return
	end
	local t={...}
	for i,v in pairs(t)do
		if type(v) == 'string' then
			t[i]=EncodeSZ(v,255,165,0)    
		else
			t[i]=EncodeSZ(unpack(v))
		end
	end
	OutputMessage("MSG_SYS",table.concat(t)..EncodeSZ("\n"),true)
end
_ZMAC.Debug3=function (szMsg, szHead,szType)
	if _ZMAC_PrintKaiguan == true then
		szHead = szHead or '调试输出'
		szType = szType or 'MSG_SYS'
		local tTime = TimeToDate((GetLocalTime()))
		OutputMessage(szType, '['..s_format('%02d:%02d:%02d',tTime.hour, tTime.minute, tTime.second)..'  '..szHead .. '] ' .. szMsg .. '\n')
	end
end
-- 在聊天欄輸出一段黃字（只有當前用戶可見）
-- (void) WY.Sysmsg(string szMsg[, string szHead])
-- szMsg -- 要輸出的文字內容
-- szHead -- 輸出前綴，自動加上中括號，默認為：海鰻插件
WY.Sysmsg = function(szMsg, szHead, szType)
	szHead = szHead or "宏"
	szType = szType or "MSG_SYS"
	OutputMessage(szType, "[" .. szHead .. "] " .. szMsg .. "\n")
end
-- 在聊天欄輸出調試信息，和 WY.Sysmsg 類似，多了2個用于區分的符號標記
-- (void) WY.Debug(string szMsg[, string szHead])
-- (void) WY.Debug2(string szMsg[, string szHead])
-- (void) WY.Debug3(string szMsg[, string szHead])
WY.nDebug = 1
WY.bDebug = false
WY.Debug = function(szMsg, szHead, nLevel)
	nLevel = nLevel or 1
	if WY.bDebug and WY.nDebug >= nLevel then
		if nLevel == 3 then szMsg = "### " .. szMsg
		elseif nLevel == 2 then szMsg = "=== " .. szMsg
		else szMsg = "-- " .. szMsg end
		WY.Sysmsg(szMsg, szHead)
	end
end
WY.Debug2 = function(szMsg, szHead) WY.Debug(szMsg, szHead, 2) end
WY.Debug3 = function(szMsg, szHead) WY.Debug(szMsg, szHead, 3) end


--//Breathe
tBreatheCall={}
tSystemBreatheCall = {}
tDelayCall={}
BreatheCall('AutoBreathe',function ()
	local nFrame = GetLogicFrameCount()
	local hPlayer = GetClientPlayer()
	local SwiteBan = hPlayer and hPlayer.nMoveState ~= 16 
	local SafeAlertOpenSwiteBan = hPlayer
	if IsInLoading() or (not SwiteBan) or (not SafeAlertOpenSwiteBan) then
		return 
	end
	for k, v in pairs(tBreatheCall) do
		if not IsInLoading() and SwiteBan and SafeAlertOpenSwiteBan then
			if nFrame >= v.nNext then
				v.nNext = nFrame + v.nFrame
				local res, err = pcall(v.fnAction)
				if not res then
					_ZMAC.Debug3('BreatheCall#' .. k ..' ERROR: ' .. err)
				end
			end
		end
	end
	for k, v in pairs(tSystemBreatheCall) do
		if nFrame >= v.nNext then
			v.nNext = nFrame + v.nFrame
			local res, err = pcall(v.fnAction)
			if not res then
				_ZMAC.Debug3('tSystemBreatheCall#' .. k ..' ERROR: ' .. err)
			end
		end
	end	
	local nTime = GetTime()
	for k = #tDelayCall, 1, -1 do
		local v = tDelayCall[k]
		if v.nTime <= nTime then
			local res, err = pcall(v.fnAction)
			if not res then
				_ZMAC.Debug3('DelayCall#' .. k ..' ERROR: ' .. err)
			end
			t_remove(tDelayCall, k)
		end
	end
end)
function _ZMAC.DestroytAlltBreatheCall()
	for k, v in pairs(tBreatheCall) do
		_ZMAC.BreatheCall(k)
	end
end
function _ZMAC.BreatheCall(szKey, fnAction, nTime)
	nTime = nTime or 62.5 --默认延迟1秒16次
	local key = StringLowerW(szKey)
	if fnAction and type(fnAction) == 'function' then 	--如果有第二个参数，就注册
		local nFrame = 1
		if nTime and nTime > 0 then
			nFrame =  m_ceil(nTime / 62.5)
		end
		local data = tBreatheCall[key]
		if not data then
			tBreatheCall[key] = { fnAction = fnAction, nNext = GetLogicFrameCount() + 1, nFrame = nFrame }
			--_ZMAC.Debug3('Start # ' .. szKey .. ' # ' .. nFrame)
		end
	else --如果没有第二个参数，就直接注销呼吸
		local data = tBreatheCall[key]
		if data then
			tBreatheCall[key] = nil
			--_ZMAC.Debug3('Stop # ' .. szKey)
		end
	end
end
--//检测指定呼吸是否在执行
function _ZMAC.CheckBreatheCall(szKey)
	local data = tBreatheCall[StringLowerW(szKey)]
	if data then return true end
	return false
end
--//检测呼吸是否为空
function _ZMAC.CheckAllBreatheCall()
	_ZMAC.Debug3('tBreatheCall # ' .. tostring(#tBreatheCall))
	if #tBreatheCall > 0 then
		return true
	end
	return false
end
--//将指定呼吸延迟
_ZMAC.BreatheCallDelay = function(szKey, nTime)
	local t = tBreatheCall[StringLowerW(szKey)]
	if t then
		t.nFrame =  m_ceil(nTime / 62.5)
		t.nNext = GetLogicFrameCount() + t.nFrame
	end
end
--//将指定呼吸单次延时
_ZMAC.BreatheCallDelayOnce = function(szKey, nTime)
	local t = tBreatheCall[StringLowerW(szKey)]
	if t then
		t.nNext = GetLogicFrameCount() +  m_ceil(nTime / 62.5)
	end
end
--//功能同_ZMAC.BreatheCall，tSystemBreatheCall注册向tSystemBreatheCall{}
function _ZMAC.tSystemBreatheCall(szKey, fnAction, nTime)
	nTime = nTime or 62.5
	local key = StringLowerW(szKey)
	if fnAction and type(fnAction) == 'function' then
		local nFrame = 1
		if nTime and nTime > 0 then
			nFrame =  m_ceil(nTime / 62.5)
		end
		local data = tSystemBreatheCall[key]
		if not data then
			tSystemBreatheCall[key] = { fnAction = fnAction, nNext = GetLogicFrameCount() + 1, nFrame = nFrame }
			--_ZMAC.Debug3('tSystemBreatheCall # ' .. szKey .. ' # ' .. nFrame)
			_ZMAC.Debug3('SysStart # ' .. szKey .. ' # ' .. nFrame)
		end
	else
		local data = tSystemBreatheCall[key]
		if data then
			tSystemBreatheCall[key] = nil
			--_ZMAC.Debug3('UntSystemBreatheCall # ' .. szKey)
			_ZMAC.Debug3('SysStop # ' .. szKey)
		end
	end
end
function _ZMAC.CheckSysBreatheCall(szKey)
	szKey = szKey or 'YH_ChuLiAbnormal'
	local data = tSystemBreatheCall[StringLowerW(szKey)]
	if data then
		return true
	end
	return false
end
_ZMAC.tSystemBreatheCallDelay = function(szKey, nTime)
	local t = tSystemBreatheCall[StringLowerW(szKey)]
	if t then
		t.nFrame =  m_ceil(nTime / 62.5)
		t.nNext = GetLogicFrameCount() + t.nFrame
	end
end
_ZMAC.tSystemBreatheCallDelayOnce = function(szKey, nTime)
	local t = tSystemBreatheCall[StringLowerW(szKey)]
	if t then
		t.nNext = GetLogicFrameCount() +  m_ceil(nTime / 62.5)
	end
end
--延时执行func一次
function _ZMAC.DelayCall(nDelay, fnAction)
	if not nDelay then
		if #tDelayCall > 0 then
			if tDelayCall[#tDelayCall].fnAction == fnAction then
				return _ZMAC.Debug3('Ignore DelayCall ' .. tostring(fnAction))
			end
		end
		nDelay = 0
	end
	t_insert(tDelayCall, { nTime = nDelay + GetTime(), fnAction = fnAction })
end

--//EVENT
_ZMAC_EVENT = {}
_ZMAC_Sys_EVENT = {}
--//执行EVENT
function EventHandler(szEvent)
	-- local nTime = GetTime()
	for k, v in pairs(_ZMAC_EVENT[szEvent]) do
		local res, err = pcall(v, szEvent)
		if not res then
			_ZMAC.Debug3('EVENT#' .. szEvent .. '.' .. k ..' ERROR: ' .. err)
		end
	end
	-- 如果有性能问题请启用
	-- Log('EventHandler ' .. szEvent .. ' cost:' .. GetTime() - nTime ..'ms')
end
--//执行Sys_EVENT
function EvenSystHandler(szEvent)
	-- local nTime = GetTime()
	for k, v in pairs(_ZMAC_Sys_EVENT[szEvent]) do
		local res, err = pcall(v, szEvent)
		if not res then
			_ZMAC.Debug3('EVENT#' .. szEvent .. '.' .. k ..' ERROR: ' .. err)
		end
	end
	-- 如果有性能问题请启用
	-- Log('SysEventHandler ' .. szEvent .. ' cost:' .. GetTime() - nTime ..'ms')
end
--//注册事件，和系统的区别在于可以指定一个 KEY 防止多次加载
--//szEvent.szKey,后面加点标识字符串,防止重复/取消绑定,如 LOADING_END.xxx
--//fnAction(arg0~arg9),传入nil相当于取消该事件
--//特别注意：当 fnAction为nil并且szKey也为nil时会取消所有通过本函数注册的事件处理器
function ZMAC_RegisterEvent(szEvent, fnAction)
	local szKey = nil
	local nPos = StringFindW(szEvent, '.')
	if nPos then
		szKey = s_sub(szEvent, nPos + 1)
		szEvent = s_sub(szEvent, 1, nPos - 1)
	end
	if not _ZMAC_EVENT[szEvent] then
		_ZMAC_EVENT[szEvent] = {}
		RegisterEvent(szEvent, EventHandler)
	end
	local tEvent = _ZMAC_EVENT[szEvent]
	if fnAction then
		if not szKey then
			t_insert(tEvent, fnAction)
		else
			tEvent[szKey] = fnAction
		end
	else
		if not szKey then
			_ZMAC_EVENT[szEvent] = {}
		else
			tEvent[szKey] = nil
		end
		if next(tEvent) == nil then
			_ZMAC_EVENT[szEvent] = nil
			UnRegisterEvent(szEvent, EventHandler)
		end
	end
end
--//调用ZMAC_RegisterEvent，实现按表注册事件
function ZMACRegisterEvent(szEvent, fnAction)
	if type(szEvent) == 'table' then
		for _, v in ipairs(szEvent) do
			ZMAC_RegisterEvent(v, fnAction)
		end
	else
		ZMAC_RegisterEvent(szEvent, fnAction)
	end
end
--//注销事件函数
function ZMACUnRegisterEvent(szEvent)
	if type(szEvent) == 'table' then
		for _, v in ipairs(szEvent) do
			ZMACRegisterEvent(v, nil)
			_ZMAC.Debug3('UnRegisterEvent # szEvent: ' .. v .. ' 注销成功。')
		end
	else
		ZMACRegisterEvent(szEvent, nil)
		_ZMAC.Debug3('UnRegisterEvent # szEvent: ' .. szEvent .. ' 注销成功。')
	end
end
--//注销所有事件函数
function ZMACUnRegisterAllEvent()
	for k, v in pairs(_ZMAC_EVENT) do
		ZMACUnRegisterEvent(k)
	end
end
--//功能同
function ZMACRegisterSysEvent(szEvent, fnAction)
	local szKey = nil
	local nPos = StringFindW(szEvent, '.')   --#RET
	if nPos then
		szKey = s_sub(szEvent, nPos + 1)
		szEvent = s_sub(szEvent, 1, nPos - 1)
	end
	if not _ZMAC_Sys_EVENT[szEvent] then
		_ZMAC_Sys_EVENT[szEvent] = {}
		RegisterEvent(szEvent, EvenSystHandler)
	end
	local tEvent = _ZMAC_Sys_EVENT[szEvent]
	if fnAction then
		if not szKey then
			t_insert(tEvent, fnAction)
		else
			tEvent[szKey] = fnAction
		end
	else
		if not szKey then
			_ZMAC_Sys_EVENT[szEvent] = {}
		else
			tEvent[szKey] = nil
		end
		if next(tEvent) == nil then
			_ZMAC_Sys_EVENT[szEvent] = nil
			UnRegisterEvent(szEvent, EvenSystHandler)
		end
	end
end
--//功能同
function ZMACUnRegisterSysEvent(szEvent)
	ZMACRegisterSysEvent(szEvent, nil)
end

--//注册
if _ZMAC.FightBeginTime==nil  then _ZMAC.FightBeginTime= 0   end     --战斗时间
if not _ZMAC.tCast then _ZMAC.tCast={} end               --记录历史技能释放
if not _ZMAC.tHit then _ZMAC.tHit={}   end               --记录历史被技能攻击
if not _ZMAC.aPlayer then _ZMAC.aPlayer={}   end             --记录身边玩家
if not _ZMAC.aNpc then _ZMAC.aNpc={} end 
if not _ZMAC.TargetLog then _ZMAC.TargetLog = {} end

            
--玩家/NPC基本列表事件
RegisterEvent("PLAYER_ENTER_SCENE", function()
	_ZMAC.tCast[arg0]={}
	_ZMAC.tHit[arg0]={} 
	_ZMAC.aPlayer[arg0] = {} --全部玩家ID列表
end)
RegisterEvent("PLAYER_LEAVE_SCENE",function()
	_ZMAC.tCast[arg0]=nil 
	_ZMAC.tHit[arg0]=nil 
	_ZMAC.aPlayer[arg0] = nil
end)
RegisterEvent("NPC_ENTER_SCENE",function()
	_ZMAC.tCast[arg0]={}
	_ZMAC.tHit[arg0]={}
	_ZMAC.aNpc[arg0] = {}
end)
RegisterEvent("NPC_LEAVE_SCENE",function()
	_ZMAC.tCast[arg0]=nil 
	_ZMAC.tHit[arg0]=nil 
	_ZMAC.aNpc[arg0] = nil
end)

-- 取当前目标及切换时间，用于判断切目标时间，防止敌对目标buff获取延时导致的技能误丢
ZMACRegisterSysEvent('UPDATE_SELECT_TARGET.ZMAC', function()
	-- if TargetPanel_GetOpenState() then
		-- return
	-- end
	local me = GetClientPlayer()
	local dwType, dwID = me.GetTarget()
	
	if not _ZMAC.TargetLog[dwID] then _ZMAC.TargetLog[dwID] = {} end
	_ZMAC.TargetLog[dwID]['dwID'] = dwID
	_ZMAC.TargetLog[dwID]['dwType'] = dwType
	_ZMAC.TargetLog[dwID]['ChooseTime'] = GetLogicFrameCount()
	--Output(_ZMAC.TargetLog[dwID])
end)


--玩家技能释放历史&lastcast&mcast&mhit...
WY.nLastOtaTime = 0
WY.BailiTarget = nil
WY.Baili_nX = -1
WY.Baili_nY = -1
WY.Baili_nZ = -1


--自身反向读条开始(channel)
--[[ --2022.5.2,此处可能有bug，待查
WY.MePrepareOrChannel = false
ZMACRegisterSysEvent('DO_SKILL_CHANNEL_PROGRESS.ZMAC',function()
		
	local myID = GetClientPlayer().dwID
	_ZMAC.tCast[myID]=_ZMAC.tCast[myID] or {}
	_ZMAC.aPlayer[myID]=_ZMAC.aPlayer[myID] or {}
	local now=GetLogicFrameCount()
	if Table_GetSkillName(arg1,arg2)~= '' and BaseSkillList[Table_GetSkillName(arg1,arg2)]==nil then
		_ZMAC.tCast[myID][arg1]=now
		_ZMAC.tCast[myID][Table_GetSkillName(arg1,arg2)]=now
		_ZMAC.tCast[myID]['lastcastid'] = arg1
		_ZMAC.tCast[myID]['lastcastname'] = Table_GetSkillName(arg1,arg2)
		WY.MePrepareOrChannel =true
		
		local name = Table_GetSkillName(arg1, arg2)
		
		if  name == "盾舞" or name == "六合独尊" or name == "凝神聚气" or name == "快雪时晴" or name == "风来吴山" or name == "醉舞九天" or name == "千蝶吐瑞" or name == "玳弦急曲" or name == "回雪飘摇" or name == "左旋右转" or name == "月华倾泻" or name == "玲珑箜篌" or name == "酒中仙" or name == "笑醉狂" or name == "鬼斧神工" or name == "暴雨梨花針" or name == "连环弩" then
			WY.nLastOtaTime = GetTickCount()
		end
		
		--tbechasing(目标在被自己百里)
		--tbechasingdistance(目标距离百里中心的距离)
		if name == '百里追魂' then
			local tar = GetTargetHandle(GetClientPlayer().GetTarget())
			if tar ~= nil then
				WY.BailiTarget = tar
				WY.Baili_nX = tar.nX
				WY.Baili_nY = tar.nY
				WY.Baili_nZ = tar.nZ
			end
		else
			WY.BailiTarget = nil
			WY.Baili_nX = -1
			WY.Baili_nY = -1
			WY.Baili_nZ = -1
		end
		
	end
end)

--自身正向读条开始(prepare)


ZMACRegisterSysEvent('DO_SKILL_PREPARE_PROGRESS.ZMAC',function()

	local myID = GetClientPlayer().dwID
	_ZMAC.tCast[myID]=_ZMAC.tCast[myID] or {}
	_ZMAC.aPlayer[myID]=_ZMAC.aPlayer[myID] or {}
	local now=GetLogicFrameCount()
	if Table_GetSkillName(arg1,arg2)~= '' and BaseSkillList[Table_GetSkillName(arg1,arg2)]==nil then
		_ZMAC.tCast[myID][arg1]=now
		_ZMAC.tCast[myID][Table_GetSkillName(arg1,arg2)]=now
		_ZMAC.tCast[myID]['lastcastid'] = arg1
		_ZMAC.tCast[myID]['lastcastname'] = Table_GetSkillName(arg1,arg2)
		WY.MePrepareOrChannel = true
		
		local name = Table_GetSkillName(arg1, arg2)
		
		if  name == "盾舞" or name == "六合独尊" or name == "凝神聚气" or name == "快雪时晴" or name == "风来吴山" or name == "醉舞九天" or name == "千蝶吐瑞" or name == "玳弦急曲" or name == "回雪飘摇" or name == "左旋右转" or name == "月华倾泻" or name == "玲珑箜篌" or name == "酒中仙" or name == "笑醉狂" or name == "鬼斧神工" or name == "暴雨梨花針" or name == "连环弩" then
			WY.nLastOtaTime = GetTickCount()
		end	
	end
end)

--]]

local function k_include(tab, value)
    for k,v in pairs(tab) do
      if k == value then
          return true
      end
    end
    return false
end

local function v_include(tab, value)
    for k,v in pairs(tab) do
      if v == value then
          return true
      end
    end
    return false
end

--全场所有技能释放(不含正向反向技能开始，只包含击中？)
ZMACRegisterSysEvent('DO_SKILL_CAST.ZMAC', function()
	local hPlayer = GetClientPlayer()
	local caster = nil


	if GetPlayer(arg0) and type(arg1) == 'number' then 
		if k_include(BaseSkillList,Table_GetSkillName(arg1,arg2)) == true then return end
		
		_ZMAC.tCast[arg0]=_ZMAC.tCast[arg0] or {}
		_ZMAC.aPlayer[arg0]=_ZMAC.aPlayer[arg0] or {}
		local now=GetLogicFrameCount()
		
		if Table_GetSkillName(arg1,arg2)~= '' then
			if arg0 == UI_GetClientPlayerID() and WY.MePrepareOrChannel == true and _ZMAC.tCast[myID]['lastcastid'] == arg1 then
				WY.MePrepareOrChannel = false
			else
				_ZMAC.tCast[arg0][arg1]=now
				_ZMAC.tCast[arg0][Table_GetSkillName(arg1,arg2)]=now
				_ZMAC.tCast[arg0]['lastcastid'] = arg1
				_ZMAC.tCast[arg0]['lastcastname'] = Table_GetSkillName(arg1,arg2)
			end
		end

		local srcPlayer =GetTargetHandle(TARGET.PLAYER,arg0) 
		if srcPlayer then
			local tarPlayer = GetTargetHandle(srcPlayer.GetTarget())
			
		
			if tarPlayer and Table_GetSkillName(arg1,arg2) ~= '' and IsEnemy(arg0,tarPlayer.dwID) then --and (not BaseSkillList[Table_GetSkillName(arg1,arg2)] >0) 
				_ZMAC.tHit[tarPlayer.dwID]=_ZMAC.tHit[tarPlayer.dwID] or {}
				_ZMAC.tHit[tarPlayer.dwID][arg1] = GetLogicFrameCount()
				_ZMAC.tHit[tarPlayer.dwID][Table_GetSkillName(arg1,arg2)] = GetLogicFrameCount()
				_ZMAC.tHit[tarPlayer.dwID]['lasthitid']=arg1
				_ZMAC.tHit[tarPlayer.dwID]['lasthitname']=Table_GetSkillName(arg1,arg2)
			end
			
			
		end
	end
end)




--fighttime
ZMACRegisterSysEvent('FIGHT_HINT.ZMAC', function()
	local bFight = arg0
	if bFight then
		_ZMAC.FightBeginTime = GetCurrentTime()
	else
		_ZMAC.FightBeginTime = 0
	end
end)
--mhit/thit
ZMACRegisterSysEvent("SYS_MSG.ZMAC" , function()                --战斗频道的技能伤害事件
    if arg0 =='UI_OME_SKILL_EFFECT_LOG' then
		--arg1为攻击者的id,arg2为被攻击的角色ID,arg3未知,arg4 5 6未知,arg7为技能id,arg8未知,arg9为该技能造成的伤害列表
		for k, v in ipairs({
		SKILL_RESULT_TYPE.PHYSICS_DAMAGE, --外功伤害
		SKILL_RESULT_TYPE.SOLAR_MAGIC_DAMAGE,  --阳性内功伤害
		SKILL_RESULT_TYPE.NEUTRAL_MAGIC_DAMAGE, --混元内功
		SKILL_RESULT_TYPE.LUNAR_MAGIC_DAMAGE,  --阴性内功
		SKILL_RESULT_TYPE.POISON_DAMAGE, --毒性
		SKILL_RESULT_TYPE.REFLECTIED_DAMAGE, --反弹
		--SKILL_RESULT_TYPE.THERAPY, --治疗
		SKILL_RESULT_TYPE.STEAL_LIFE, --窃取生命
		SKILL_RESULT_TYPE.ABSORB_DAMAGE, --化解
		SKILL_RESULT_TYPE.SHIELD_DAMAGE , --抵消
		SKILL_RESULT_TYPE.PARRY_DAMAGE, --拆招
		SKILL_RESULT_TYPE.INSIGHT_DAMAGE,--识破
		--SKILL_RESULT_TYPE.TRANSFER_LIFE, --xx吸取了xx的xx点
		--SKILL_RESULT_TYPE.TRANSFER_MANA,--换蓝
		}) do
			if arg9[v]  then  --and arg9[v] > 0    arg9[v]为该技能所造成的伤害
				_ZMAC.tHit[arg2] =  _ZMAC.tHit[arg2] or {}
				_ZMAC.tHit[arg2][arg5] = GetLogicFrameCount()
				_ZMAC.tHit[arg2][Table_GetSkillName(arg5,1)] = GetLogicFrameCount()
			  break
			end
			
		end
		--Output(arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7)
    end
	if arg0 =='UI_OME_SKILL_CAST_LOG' and arg1 == GetClientPlayer().dwID then
		local name = Table_GetSkillName(arg2, arg3)
		
		if  name == "盾舞" or name == "六合独尊" or name == "凝神聚气" or name == "快雪时晴" or name == "风来吴山" or name == "醉舞九天" or name == "千蝶吐瑞" or name == "玳弦急曲" or name == "回雪飘摇" or name == "左旋右转" or name == "月华倾泻" or name == "玲珑箜篌" or name == "酒中仙" or name == "笑醉狂" or name == "鬼斧神工" or name == "暴雨梨花针" or name == "连环弩" then
			WY.nLastOtaTime = GetTickCount()
			
		--tbechasing(目标在被自己百里)
		--tbechasingdistance(目标距离百里中心的距离)
		-- if name == '百里追魂' then
			-- Output(111)
			-- local tar = GetTargetHandle(caster.GetTarget())
			-- if tar ~= nil then
				-- WY.BailiTarget = tar
				-- WY.Baili_nX = tar.nX
				-- WY.Baili_nY = tar.nY
				-- WY.Baili_nZ = tar.nZ
			-- end
		-- else
			-- WY.BailiTarget = nil
			-- WY.Baili_nX = -1
			-- WY.Baili_nY = -1
			-- WY.Baili_nZ = -1
		-- end	
			
		end
	end
	
	
end)


--//_ZMAC local function
local _ZMAC_Compare=function (cType, RealNum, cNum)
	local Boolean = false
	local RealNum = tonumber(RealNum)
	local cNum = tonumber(cNum)
	if cType=='>' then Boolean = RealNum>cNum end
	if cType=='<' then Boolean = RealNum<cNum end
	if cType=='=' then Boolean = RealNum==cNum end
	return Boolean
end
local _ZMAC_GetAllNpc = function()
	if GetAllNpc()~= nil then
		return GetAllNpc()
	end
	local m0 = {}
	for k,v in pairs(_ZMAC.aNpc) do
		t_insert(m0,GetNpc(k))
	end
	return m0
end
local _ZMAC_GetAllPlayer=function ()
	if GetAllPlayer()~= nil then
		return GetAllPlayer()
	end
	
	local m0 = {}
	for k,v in pairs(_ZMAC.aPlayer) do
		t_insert(m0,GetPlayer(k))
	end
	return m0
end
local _ZMAC_GetBuffList=function(tar)
	tar = tar or GetClientPlayer()
	
	_ZMAC.SmartRefreshBuff(tar.dwID)
	
	local aBuff = {}
	local nCount = tar.GetBuffCount()
	for i = 1, nCount do
		local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = tar.GetBuff(i - 1)
		
		if dwID and nEndFrame -GetLogicFrameCount() >0 then
			t_insert(aBuff, {
			dwID = dwID,
			nLevel = nLevel,
			bCanCancel = bCanCancel,
			nEndFrame = nEndFrame,
			nIndex = nIndex,
			nStackNum = nStackNum,
			dwSkillSrcID = dwSkillSrcID,
			bValid = bValid,
			nCount = i
			})
		end
	end
	return aBuff
end
local _ZMAC_SelTarget=function(pIDorName)
	if pIDorName == nil then pIDorName = 0 end
	local dwID = 0
	if tonumber(pIDorName) then 
		dwID =tonumber(pIDorName) 
	else
		for j,v in pairs(_ZMAC_GetAllPlayer() ) do
			local k = v.dwID
			local tmpPlayer = v
			if tmpPlayer and tmpPlayer.szName==pIDorName then
				dwID=tmpPlayer .dwID
			end
		end
		if dwID == 0 then
			for jj,vv in pairs(_ZMAC_GetAllNpc()) do
				local kk = vv.dwID
				local tmpNpc = vv
				if tmpNpc and tmpNpc.szName ==pIDorName then
					dwID=tmpNpc.dwID
				end
			end
		end
	end

	local dwType = TARGET.NO_TARGET
	if dwID >= 1073741824 then
		dwType = TARGET.NPC
	elseif dwID < 1073741824 and dwID ~= 0 then
		dwType = TARGET.PLAYER
	end
	SetTarget(dwType, dwID)
end
--//字符处理：分割关系符<>=
local function _ZMAC_SplitRelationSymbol(str,cType)
	local Boolean=false
	local Item=str
	local Type=0
	local Value=''
	local Location = s_find(str, cType)
	if Location then
		Boolean= true
		Item = s_sub(str, 1, Location - 1)
		Type = s_sub(str, Location, Location)
		Value  = s_sub(str, Location + 1, -1)
	end
	return Boolean,Item,Type,Value
end
--//字符处理：字符串→字符数组
local function _ZMAC_SplitStr2Array(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = s_find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = s_sub(szFullString, nFindStartIndex, s_len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = s_sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + 1
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end
local function Calc_TriAngleArea(p1, p2, p3)
	 if p1==nil or p2 ==nil or p3 ==nil then return 0 end
	 local x1, y1, x2, y2, x3, y3 = p1[1],p1[2],p2[1],p2[2],p3[1],p3[2]
	 if x1==nil or y1==nil or x2==nil or y2==nil or x3==nil or y3 ==nil  then 
		return 0 
	end
	 return 0.5 * m_abs(x2 * y3 + x1 * y2 + x3 * y1 - x3 * y2 - x2 * y1 - x1 * y3)
end
local function Str_Cut(str,s_begin,s_end)
 
	local StrLen = s_len(str)
	local s_begin_Len = s_len(s_begin)
	local s_end_Len = s_len(s_end)
	local s_begin_x = s_find(str, s_begin, 1)
	--print(s_begin_x)
	local s_end_x = s_find(str, s_end, s_begin_x+1)
	--print(s_end_x)
	local rs=(s_sub(str, s_begin_x+s_begin_Len, s_end_x-1))
	return rs
end

--内存强刷buff
_ZMAC.SmartRefreshBuff = function(dwID)
	if g_RefreshBuff then
		if ZMAC.Switch['强制取buff'] == true then
			if (not (GetClientTeam() and GetClientTeam().IsPlayerInTeam(dwID))) and IsPlayer(dwID) then --or (not IsPlayer(dwID)) 
				g_RefreshBuff(dwID)
			else
				return 'ally'
			end
		else
			return 'close'
		end	
	else
		return 'none'
	end
end

local function GetAllBuff (tar)
    tar = tar or GetClientPlayer()
	_ZMAC.SmartRefreshBuff(tar.dwID)
	
    local aBuff = {}
    local nCount = tar.GetBuffCount()
    for i = 1, nCount, 1 do
        local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = tar.GetBuff(i - 1)
        if dwID and nEndFrame -GetLogicFrameCount() >0  then
            table.insert(aBuff, {
                dwID = dwID, nLevel = nLevel, bCanCancel = bCanCancel, nEndFrame = nEndFrame,
                nIndex = nIndex, nStackNum = nStackNum, dwSkillSrcID = dwSkillSrcID, bValid = bValid,
            })
        end
    end
    return aBuff
end
local function getAngle(px1, py1, px2, py2)
	local x = px2-px1
	local y = py2-py1
	local hypotenuse = math.sqrt(x^2+y^2)
	local cos = x/hypotenuse
	local radian = math.acos(cos)
	local angle = 180/(math.pi/radian)
	if y < 0 then
		angle = 360 - angle
	elseif y == 0 and x < 0 then
		angle = 180
	end
	return math.floor(angle * 128 / 180)
end







--//_ZMAC Base function
_ZMAC.IsTestSever = function() 
	local nowSever = GetUserServer() --此函数会返回多个返回值,此时nowSever为第一个返回值,一般为所属顶层大区(测试区/怀旧大区等)
	if nowSever=='测试区' then return true end
	return false
end
_ZMAC.IsMindSever = function() 
	local _,_,nowSever = GetVersion()
	if nowSever=='classic' then 
		return true 
	else
		return false
	end
end
_ZMAC.IsNil=function(var)
	return var==nil
end
local IsNil=_ZMAC.IsNil
_ZMAC.Decimal =function(value)
	return value-value%0.01
end
_ZMAC.WriteToFile=function (szFilePath, szContent)
	io.output(szFilePath)
	io.write(szContent)
	io.close()
end
_ZMAC.GetCurrentTime=function ()
	return GetCurrentTime()
end
_ZMAC.GetDistance=function(nX, nY, nZ)
	local hPlayer = GetClientPlayer()
	if not hPlayer then
			return 0
	end
	if nX == 0 and nY == 0 then
		return 0
	end
	if not nY and not nZ then --如果只有单个参数，那么参数为目标
		local tar = nX
		nX, nY, nZ = tar.nX, tar.nY, tar.nZ
	elseif not nZ then  --如果有两个参数，则为X，Y坐标
		return m_floor(((hPlayer.nX - nX) ^ 2 + (hPlayer.nY - nY) ^ 2) ^ 0.5)/64
	end
	return m_floor(((hPlayer.nX - nX) ^ 2 + (hPlayer.nY - nY) ^ 2 + (hPlayer.nZ/8 - nZ/8) ^ 2) ^ 0.5)/64
end
_ZMAC.IsInTriAngle=function(x0,y0,x1,y1,x2,y2,x3,y3) 
	if x0==nil or y0==nil or x1==nil or y1==nil or x2==nil or y2==nil or x3==nil or y3==nil  then
		return false
	end

	
	local S = Calc_TriAngleArea({x1,y1},{x2,y2},{x3,y3})
	local S1 = Calc_TriAngleArea({x0,y0},{x2,y2},{x3,y3})
	local S2 = Calc_TriAngleArea({x1,y1},{x0,y0},{x3,y3})
	local S3 = Calc_TriAngleArea({x1,y1},{x2,y2},{x0,y0})
	return S==(S1+S2+S3),S
end
_ZMAC.GetPointDis=function(x1,y1,x2,y2)
	return (math.sqrt(math.pow((y2-y1),2)+math.pow((x2-x1),2)))/64
end
_ZMAC.SetTarget = function(dwType, dwID)
	if not dwType or dwType <= 0 then
		dwType, dwID = TARGET.NO_TARGET, 0
	elseif not dwID then
		dwID, dwType = dwType, TARGET.NPC
		if IsPlayer(dwID) then
			dwType = TARGET.PLAYER
		end
	end
	--SetTarget(dwType, dwID)
	SelectTarget(dwType, dwID)
end
_ZMAC.SetInsTarget = function(...)
	TargetPanel_SetOpenState(true)
	_ZMAC.SetTarget(...)
	TargetPanel_SetOpenState(false)
end

--//_ZMAC Skill function
function _ZMAC.GetSkillIdEx(szSkillName)
	local cmd = szSkillName
	if cmd == '后跳' or cmd == '后撤' then
		return 9007
	elseif cmd == '重弩' or cmd == '重弩形态' then
		return 3369
	elseif cmd == '连弩' or cmd == '连弩形态' then
		return 3368
	elseif cmd == '毒刹' or cmd == '毒刹形态' then
		return 3370	
	elseif cmd == '宠物攻击' then
		return 2442
	elseif cmd == '宠物跟随' then
		return 2446
	elseif cmd == '宠物停留' then
		return 2447
	elseif cmd == '主动型' then
		return 2443
	elseif cmd == '防御型' then
		return 2444
	elseif cmd == '被动型' then
		return 2445
	elseif cmd == '千机变攻击' then
		return 3360
	elseif cmd == '千机变停止' then
		return 3382
	elseif cmd == '煽弄' then
		return 2542
	elseif cmd == '归巢' then
		return 23337
	elseif cmd == '丝牵' then
		return 2479
	elseif cmd == '蝎蜇' then
		return 2475
	elseif cmd == '影滞' then
		return 2478
	elseif cmd == '幻击' then
		return 2477
	elseif cmd == '蟾躁' then
		return 2476
	elseif cmd == '遁影·一' then
		return 17587
	elseif cmd == '遁影·二' then
		return 17588
	-- elseif cmd == '遁影' then     --遁影需要用UI的方式特殊处理
		-- return 17587 -- {17587,17588}
	elseif tonumber(cmd) then
		return tonumber(cmd)
	end
	local  nSkillID =  g_SkillNameToID[cmd]
	local hPlayer = GetClientPlayer()
	local tmpNum = 999 -- 用于所有技能都不能用时，记录技能的最小num,防止因切体态导致的其他体态技能全都无法UITestCast+技能id是个表+该技能已经被释放情况下，取技能id不准，导致的num不准（如果没被释放，则所有id的技能层数一致，无bug）
	local ttt = nSkillID
	if nSkillID and type(nSkillID) == 'table' then
		for k, v in pairs(nSkillID) do
			local Skill = GetSkill(v, hPlayer.GetSkillLevel(v))
			if Skill and Skill.UITestCast(hPlayer.dwID, IsSkillCastMyself(Skill)) and (not s_find(Table_GetSkillDesc(v,1),'招式已删除')) then
				return v,ttt
			end
			--nSkillID = nSkillID[1]
			local num = _ZMAC.GetSkillIDNum(hPlayer,v)
			
			if tmpNum==999 then
				tmpNum = num
				nSkillID= v
			elseif num < tmpNum and  tmpNum~=999  then
				tmpNum = num
				nSkillID= v
			end
		end
	end
	-- if nSkillID==nil then
		-- Output(cmd,nSkillID)
	-- end
	--Output(nSkillID)
	return nSkillID , ttt
end
--获取技能信息列表，其中如果函数执行成功，返回技能信息的一个table，包含："CastTime": 释放时间，还有其余返回值见白名单
_ZMAC.GetSkillInfo=function (SkillName)
	local CurPlayer = GetClientPlayer()
	--local SkillId = AutoQuest.GetSkillId(SkillName)
	local SkillId= _ZMAC.GetSkillIdEx(SkillName)
	local SkillLevel = CurPlayer.GetSkillLevel(SkillId)
		if SkillLevel == 0 then
		SkillLevel = 1
	end
	local SkillKey = CurPlayer.GetSkillRecipeKey(SkillId, SkillLevel)
	return GetSkillInfo(SkillKey)
end
--force,school
_ZMAC.MySchoolName=function ()           
	local hPlayer = GetClientPlayer()
	local KungfuMount = hPlayer.GetKungfuMount()
	if KungfuMount then
		return KungfuMount.szSkillName
	end
	return "江湖"
end
--/cancelbuff
_ZMAC.CancelBuff=function(szBuffdwID)
	local hPlayer = GetClientPlayer()
	szBuffdwID = tonumber(szBuffdwID) or szBuffdwID
	local BuffList = GetAllBuff(hPlayer)
	for i = 1, #BuffList, 1 do
		if type(szBuffdwID) == 'number' then
			if BuffList[i].dwID == szBuffdwID then
				hPlayer.CancelBuff(BuffList[i].nIndex)
			end
		else
			if Table_GetBuffName(BuffList[i].dwID, BuffList[i].nLevel) == szBuffdwID then
				hPlayer.CancelBuff(BuffList[i].nIndex)
			end
		end
	end
end
--Cast
function _ZMAC.CanUseSkill(cmd)
	local hPlayer = GetClientPlayer()
	local szSkillID = tonumber(cmd) or g_SkillNameToID[cmd]
	--Output(cmd,szSkillID)
	if szSkillID == 9007 then
		return true, false
	end
	--Output('114  2')
	
	local SkillLevel = hPlayer.GetSkillLevel(szSkillID)
	if SkillLevel < 1 then SkillLevel = 1 end
	local bCool, CD, TotalCD = hPlayer.GetSkillCDProgress(szSkillID, SkillLevel)
	local CongNengCDID = Skill_GetCongNengCDID(szSkillID)
	local CnCD, CnCount = hPlayer.GetCDLeft(CongNengCDID)
	local Skill = GetSkill(szSkillID, SkillLevel)
	--2022.6.12,此处有BUG，在GCD期间，充能技能会判断为true，而非充能判定为false，会导致此时优先释放宏语句中位置靠后的读条技能，
	--[[例如：/cast 三星临
			  /cast 天斗旋
	--待解决]]

	if cmd == '天斗旋' or cmd == 24816  or cmd == 24817  or cmd == 24818 or cmd == 24372 then
		local KungfuMount = _ZMAC.MySchoolName()
		local gcdID=605 --骑御
		if KungfuMount=='焚影圣诀' or KungfuMount=='明尊琉璃体' then
			gcdID=3962 --赤日轮
		elseif KungfuMount=='笑尘诀' then
			gcdID=5258 --拨狗朝天
		end
		return _ZMAC.CheckSkillCool(gcdID),Skill.bIsChannelSkill
	end
	
	if Skill then
		if  (not bCool) or (CongNengCDID and CnCount > 0) or (CD == 0 and TotalCD == 0)  or (_ZMAC.GetSkillNum(GetClientPlayer(),szSkillID)>0 and _ZMAC.TouzhiSkillList[szSkillID]~=nil ) and Skill.UITestCast(hPlayer.dwID, IsSkillCastMyself(Skill))  then 
			return true, Skill.bIsChannelSkill
		end
	end
	return false, false
end
WY.IsCD = function(dwSkillID, dwSkillLevel)
	local player = GetClientPlayer()
	local bCool, nLeft, nTotal, nNum = player.GetSkillCDProgress(dwSkillID, dwSkillLevel)
	--if bCool and nTotal > 24 then 
	if dwSkillID == 13067 or dwSkillID == 13152 then
		if nNum == 0 then return true end
	else
		if bCool and nLeft > 0 then 
			return true
		end
	end
	return false
end
WY.CanDoSkill = function(dwSkillID, dwSkillLevel)
	local skill = GetSkill(dwSkillID, dwSkillLevel)
	if skill and skill.UITestCast(UI_GetClientPlayerID(), IsSkillCastMyself(skill)) then 
		return true
	end
	return false
end
WY.CheckSkill = function(dwSkillID, nLevel)
	if dwSkillID == 0 then 
		return false
	end 
	
	local player = GetClientPlayer()
	local nSkillLevel = player.GetSkillLevel(dwSkillID)
	if nSkillLevel ~= nLevel then 
		nLevel = nSkillLevel
	end
	
	if WY.IsCD(dwSkillID, nLevel) or not WY.CanDoSkill(dwSkillID, nLevel) then
		return false
	end
	
	return true	
end
WY.CancelBuff = function(nBuffID)
	local player = GetClientPlayer()
	local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid
	local nCount = player.GetBuffCount()
	for i = 1, nCount, 1 do
		dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = player.GetBuff(i - 1)
		if dwID and dwID == nBuffID then	--nBuffID
			player.CancelBuff(nIndex)
			break
		end
	end
end
_ZMAC.UseSkill = function(pnSkillID)
	local nSkillID = 0
	local ret = nil 
	if tonumber(pnSkillID) then
		nSkillID = tonumber(pnSkillID)
	else
		nSkillID = _ZMAC.GetSkillIdEx(pnSkillID)
	end
	if nSkillID~=0 then
		ret = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
	end
	return ret
end


--//_ZMAC Param function
--[prepare,channel,Config]
_ZMAC.GetOta=function(xPlayer)
	local bPrePare, dwID, dwLevel, fP 
	
	--if not _ZMAC.IsMindSever()  then  --正式服,正常获取
		bPrePare, dwID, dwLevel, fP = xPlayer.GetSkillOTActionState()
	--end

	if bPrePare ==nil then 
		bPrePare, _,_,_ = xPlayer.GetOTActionState() 
	end
	
	if dwID==nil or dwLevel==nil or fP==nil and (not _ZMAC.IsMindSever()) then
		_,dwID, dwLevel, fP = xPlayer.GetSkillPrepareState()  
	end

	return bPrePare, dwID, dwLevel, fP
end
--[prepare/otation/channel]
_ZMAC.CheckPrepare = function(t,str,otaType,...)
	if not t then return false end
	
	if (...)~=nil then              --仅判断读条百分比的时候,会有两个参数,此时str参数为cNum,(...)为比较cType
		local cNum = tonumber(str)
		local cType =(...)
		local bPrePare, dwID, dwLevel, fP = _ZMAC.GetOta(t)
		
		if (bPrePare==1 and otaType=='prepare' )
			or (bPrePare==2 and otaType=='channel' )
			or (bPrePare~=0 and otaType=='otaction' ) then
			return _ZMAC_Compare(cType,fP,cNum)
		end
		return false
		
	end

	if s_find(str, '-') then
		local szSkillNames = _ZMAC_SplitStr2Array(str, '-')
		for _,szSkillName in pairs(szSkillNames) do
			if not _ZMAC.CheckPrepare(t,szSkillName,otaType) then
				return false
			end
		end
		return true
	end

	local bPrePare, dwID, dwLevel, fP = _ZMAC.GetOta(t)
	--Output(bPrePare, dwID, dwLevel, fP)
	if (bPrePare == 1 or bPrePare == 9) and otaType == 'prepare' then --天下无狗的读条是9
		if str=='' then return true end
		local pNamestrs = _ZMAC_SplitStr2Array(str, '|')
		for _,pNamestr in pairs(pNamestrs) do
			local Boolean,skillName,Type,Value = _ZMAC_SplitRelationSymbol(pNamestr,'[><=]')
			if not Boolean then
				if Table_GetSkillName(dwID, dwLevel) == skillName then 
					return true 
				end
			else
				if Table_GetSkillName(dwID, dwLevel) == skillName and _ZMAC_Compare(Type,fP,Value) then 
					return true 
				end
			end
		end
		
	elseif bPrePare == 2 and otaType == 'channel' then
		if str=='' then return true end
		local pNamestrs = _ZMAC_SplitStr2Array(str, '|')
		for _,pNamestr in pairs(pNamestrs) do
			local Boolean,skillName,Type,Value = _ZMAC_SplitRelationSymbol(pNamestr,'[><=]')
			if not Boolean then
				if Table_GetSkillName(dwID, dwLevel) == skillName then 
					return true 
				end
			else
				if Table_GetSkillName(dwID, dwLevel) == skillName and _ZMAC_Compare(Type,fP,Value) then 
					return true 
				end
			end
		end
	elseif bPrePare~=0 and otaType == 'otaction' then
		if str=='' then return true end
		local pNamestrs = _ZMAC_SplitStr2Array(str, '|')
		for _,pNamestr in pairs(pNamestrs) do
			local Boolean,skillName,Type,Value = _ZMAC_SplitRelationSymbol(pNamestr,'[><=]')
			if not Boolean then
				if Table_GetSkillName(dwID, dwLevel) == skillName then 
					return true 
				end
			else
				if Table_GetSkillName(dwID, dwLevel) == skillName and _ZMAC_Compare(Type,fP,Value) then 
					return true 
				end
			end
		end
	end
	
	return false
end
--[mcast/tcast/mhit/thit]
_ZMAC.GetCastHitTime=function(pPlayer,CastorHit,SkillName)
	local xPlayer = pPlayer
	if not xPlayer then return Output('参数有误，玩家不存在') end
	if CastorHit=='Cast' then
		local tmpCast=_ZMAC.tCast[xPlayer.dwID] or {}
		local xPlayer_casttime = tmpCast[SkillName] and (GetLogicFrameCount()-tmpCast[SkillName])/GLOBAL.GAME_FPS
		--if not xPlayer_casttime then return false end
		return xPlayer_casttime
	elseif CastorHit=='Hit' then
		local tmpHit=_ZMAC.tCast[xPlayer.dwID] or {}
		local xPlayer_hittime = tmpHit[SkillName] and (GetLogicFrameCount()-tmpHit[SkillName])/GLOBAL.GAME_FPS
		--if not xPlayer_hittime then return false end
		return xPlayer_hittime
	end
end
--[recipe]
_ZMAC.IsRecipeActive=function(pPlayer,szRecipeName)--
	local tRecipe=_ZMAC.tAllRecipeList[szRecipeName]
	if not tRecipe then
		--_ZMAC.Print('MSG_SYS','无此秘籍：'..szRecipeName..'。\n')
		return false
	end
	local dwRecipeID,dwSkillID = tRecipe[1] , tRecipe[2]
	local Player=pPlayer
	if not Player then return false end
	for _,t in pairs(Player.GetSkillRecipeList(dwSkillID,1) ) do
		if t.recipe_id == dwRecipeID then
			if t.active==true then return true end
		end
	end
	return false
end
--[mcast/tcast/mhit/thit]
_ZMAC.CheckCastHitTime=function(pPlayer,CastorHit,str)
	local Boolean,SkillName,cType,cNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
	local xPlayer = pPlayer
	if not xPlayer then return false end
	if CastorHit=='Cast' then
		local tmpCast=_ZMAC.tCast[xPlayer.dwID] or {}
		local xPlayer_casttime = tmpCast[SkillName] and (GetLogicFrameCount()-tmpCast[SkillName])/GLOBAL.GAME_FPS
		if not xPlayer_casttime then 
			if cType=='>' then 
				return true
			else
				return false
			end
		end
		return _ZMAC_Compare(cType, xPlayer_casttime, cNum)
	elseif CastorHit=='Hit' then
		local tmpHit=_ZMAC.tHit[xPlayer.dwID] or {}
		local xPlayer_hittime = tmpHit[SkillName] and (GetLogicFrameCount()-tmpHit[SkillName])/GLOBAL.GAME_FPS
		if not xPlayer_hittime then  
			if cType=='>' then 
				return true
			else
				return false
			end
		end
		return _ZMAC_Compare(cType, xPlayer_hittime, cNum)
	end
end
--[puppet]
_ZMAC.IsPuppetOpened=function ()
	local hFrame = Station.Lookup('Normal/PuppetActionBar')
	if hFrame and hFrame:IsVisible() then
		return true
	end
	return false
end
--[buff/buffid/bufftime]含buff名、buff时间、buff层数
local _ZMAC_CheckBuff2 = function(t, str,TimeorStack,SrcSelf)
	if not t then return false end
	--Output(s_find(str, '-'))
	_ZMAC.SmartRefreshBuff(t.dwID)
	if not t.GetBuffCount() then return false end
	for i = 1, t.GetBuffCount(), 1 do   --疑似卡顿，算法待优化
		local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = t.GetBuff(i - 1)
		if dwID and nEndFrame -GetLogicFrameCount() >0  then
		--Output(str,1)
			local Buffstrs = _ZMAC_SplitStr2Array(str, '|')
			for _,Buffstr in ipairs(Buffstrs) do
			--Output(Buffstrs)
				local Boolean,BuffName,cType,cNum = _ZMAC_SplitRelationSymbol(Buffstr,'[><=]')

				if not SrcSelf or (SrcSelf and dwSkillSrcID == GetClientPlayer().dwID) then    --判断是否是自己的buff
					if TimeorStack== 't' then
						if Boolean then
							--local BuffTime = m_ceil((nEndFrame - GetLogicFrameCount()) / GLOBAL.GAME_FPS)
							local BuffTime = _ZMAC.Decimal((nEndFrame - GetLogicFrameCount()) / GLOBAL.GAME_FPS)
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								--Output(BuffTime)
								if _ZMAC_Compare(cType,BuffTime, cNum) then return true end
							end
						else       --时间判定的时候应该没有这个分支才对，待查
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								return true
							end
						end
					elseif TimeorStack== 's' then
						
						if Boolean then      --判定层数
							local StackNum = nStackNum
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								if _ZMAC_Compare(cType, StackNum, cNum) then
									return true
								end
							end
						else               --判定有无buff
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								return true
							end
						end
					end
				
				end
			end
		end
	end
	return false
end



local _ZMAC_CheckBuff = function(t, str,TimeorStack,SrcSelf)
	if not t then return false end
	
	_ZMAC.SmartRefreshBuff(t.dwID)
	if s_find(str, '-') then 
		local Buffstrs = _ZMAC_SplitStr2Array(str, '-')
		for _,Buffstr in pairs(Buffstrs) do
			if not _ZMAC_CheckBuff2(t,Buffstr,TimeorStack,SrcSelf) then
				return false
			end
		end
		return true 
	end
	
	if not t.GetBuffCount() then return false end
	
	for i = 1, t.GetBuffCount(), 1 do   --疑似卡顿，算法待优化
		local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = t.GetBuff(i - 1)
		if dwID   then   --nEndFrame -GetLogicFrameCount()>0    因加入了内存强刷buff，强刷有服务器延时，所以每次取到的是上一次刷的老buff表,那么就存在旧buff判定的问题
		
			local Buffstrs = _ZMAC_SplitStr2Array(str, '|')
			for _,Buffstr in pairs(Buffstrs) do
			
				local Boolean,BuffName,cType,cNum = _ZMAC_SplitRelationSymbol(Buffstr,'[><=]')
				
				
				if not SrcSelf or (SrcSelf and dwSkillSrcID == GetClientPlayer().dwID) then    --判断是否是自己的buff
					if TimeorStack== 't' then
						if Boolean then
							--local BuffTime = m_ceil((nEndFrame - GetLogicFrameCount()) / GLOBAL.GAME_FPS)
							local BuffTime = _ZMAC.Decimal((nEndFrame - GetLogicFrameCount()) / GLOBAL.GAME_FPS)
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								--Output(BuffTime)
								if _ZMAC_Compare(cType,BuffTime, cNum) then return true end
							end
						else       --时间判定的时候应该没有这个分支才对，待查
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								return true
							end
						end
					elseif TimeorStack== 's' then
						
						if Boolean then      --判定层数
							local StackNum = nStackNum
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								if _ZMAC_Compare(cType, StackNum, cNum) then
									return true
								end
							end
						else               --判定有无buff
							--Output(Boolean,BuffName,cType,cNum,Table_GetBuffName(dwID, nLevel),BuffName)
							
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								
								return true
							end
						end
					end
				
				end
			end
		end
	end
	return false
end


--[stats]
_ZMAC.CheckStats=function(pPlayer,pStats) 
	local hPlayer =pPlayer
	if s_find(pStats, '-') then
		local szSkillNames = _ZMAC_SplitStr2Array(pStats, '-')
		for _,szSkillName in ipairs(szSkillNames) do
			if not _ZMAC.CheckStats(hPlayer,szSkillName) then
				return false
			end
		end
		return true
	end
	local strs = _ZMAC_SplitStr2Array(pStats, '|')
	for k,str in pairs(strs) do
		if not hPlayer then return false end
		if str =='被控' then
			return _ZMAC.CheckStatus(hPlayer,'halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='不控' then  
			return _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='可控' then
			return not _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid|move|vmove')
		elseif str =='近战' then
			return _ZMAC.CheckMount(hPlayer,'傲血战意|铁牢律|易筋经|洗髓经|问水诀|山居剑意|太虚剑意|焚影圣诀|明尊琉璃体|笑尘诀|分山劲|铁骨衣|北傲诀|凌海诀|隐龙诀')
		elseif str =='远程' then	
			return _ZMAC.CheckMount(hPlayer,'紫霞功|冰心诀|云裳心经|离经易道|花间游|天罗诡道|惊羽诀|补天诀|毒经|莫问|相知|太玄经|五方|灵素')
		elseif str =='内功' then
			return _ZMAC.CheckMount(hPlayer,'易筋经|洗髓经|焚影圣诀|明尊琉璃体|紫霞功|冰心诀|云裳心经|离经易道|花间游|天罗诡道|补天诀|毒经|莫问|相知|太玄经|五方|灵素')
		elseif str =='外功' then
			return _ZMAC.CheckMount(hPlayer,'傲血战意|铁牢律|问水诀|山居剑意|太虚剑意|笑尘诀|惊羽诀|分山劲|铁骨衣|北傲诀|凌海诀|隐龙诀')
		elseif str =='治疗' then
			return _ZMAC.CheckMount(hPlayer,'云裳心经|离经易道|补天诀|相知|灵素')
		elseif str =='输出' then
			return _ZMAC.CheckMount(hPlayer,'傲血战意|问水诀|山居剑意|太虚剑意|紫霞功|笑尘诀|惊羽诀|天罗诡道|分山劲|隐龙诀|易筋经|北傲诀|凌海诀|焚影圣诀|冰心诀|花间游|毒经|莫问|太玄经|五方')	
		elseif str =='有爆发' then
			return _ZMAC_CheckBuff(hPlayer,'197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083,14352','s',false)
		elseif str =='无爆发' then	
			return not _ZMAC.CheckStats(hPlayer,'有爆发')
		elseif str =='有沉默' then
			return _ZMAC_CheckBuff(hPlayer,'573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091','s',false)
		elseif str =='无沉默' then	
			return not _ZMAC.CheckStats(hPlayer,'有沉默')
		elseif str =='有反弹' then
			return _ZMAC_CheckBuff(hPlayer,'388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744','s',false)
		elseif str =='无反弹' then	
			return not _ZMAC.CheckStats(hPlayer,'有反弹')
		elseif str =='有封内' then
			return _ZMAC_CheckBuff(hPlayer,'445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592','s',false)
		elseif str =='无封内' then	
			return not _ZMAC.CheckStats(hPlayer,'有封内')
		elseif str =='有封轻功' then
			return _ZMAC_CheckBuff(hPlayer,'562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246','s',false)
		elseif str =='无封轻功' then	
			return not _ZMAC.CheckStats(hPlayer,'有封轻功')
		elseif str =='有减伤' then
			return _ZMAC_CheckBuff(hPlayer,'126|2108|20799|17961|18001|16545|18203|17959|15897|15735|6739|6154|9073|9724|14644|6306|8495|13571|10118|12506|11319|11384|9810|6163|8300|6315|9506|122|9975|4339|9510|9337|3274|134|9534|6361|8291|360|367|368|384|399|684|993|996|1142|1173|1177|1547|1552|1802|2419|2447|2805|2849|2953|2983|3068|3107|3120|3171|3193|3259|3315|3447|3791|3792|4147|4245|4376|4439|4444|4575|5374|5704|5735|5744|5753|5778|5996|6090|6125|6200|6224|6240|6248|6257|6262|6264|6279|6492|6547|6616|6636|6637|7035|7054|7119|7387|7964|8265|8279|8292|8427|8650|8839|9293|9334|9544|9693|9694|9695|9696|9775|9781|9782|9803|9836|9873|9874|10014|10066|10369|11344|12530|13044|13771|14067|14105','s',false)
		elseif str =='无减伤' then	
			return not _ZMAC.CheckStats(hPlayer,'有减伤')	
		elseif str =='有减疗' then
			return _ZMAC_CheckBuff(hPlayer,'315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103','s',false)
		elseif str =='无减疗' then	
			return not _ZMAC.CheckStats(hPlayer,'有减疗')	
		elseif str =='有减速' then
			return _ZMAC_CheckBuff(hPlayer,'450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373','s',false)
		elseif str =='无减速' then	
			return not _ZMAC.CheckStats(hPlayer,'有减速')		
		elseif str =='有免控' then
			return _ZMAC_CheckBuff(hPlayer,'100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310','s',false)
		elseif str =='无免控' then	
			return not _ZMAC.CheckStats(hPlayer,'有免控')	
		elseif str =='有免伤' then
			return _ZMAC_CheckBuff(hPlayer,'160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151','s',false)
		elseif str =='无免伤' then	
			return not _ZMAC.CheckStats(hPlayer,'有免伤')	
		elseif str =='有免死' then
			return _ZMAC_CheckBuff(hPlayer,'203|6182|10370|12488','s',false)
		elseif str =='无免死' then	
			return not _ZMAC.CheckStats(hPlayer,'有免死')
		elseif str =='有免封内' then
			return _ZMAC_CheckBuff(hPlayer,'5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350','s',false)
		elseif str =='无免封内' then	
			return not _ZMAC.CheckStats(hPlayer,'有免封内')
		elseif str =='有闪避' then
			return _ZMAC_CheckBuff(hPlayer,'1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099','s',false)
		elseif str =='无闪避' then	
			return not _ZMAC.CheckStats(hPlayer,'有闪避')	
		elseif str =='有免缴械' then
			return _ZMAC_CheckBuff(hPlayer,'6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414','s',false) 
		elseif str =='无免缴械' then
			return not _ZMAC.CheckStats(hPlayer,'有免缴械')	
		elseif str =='不可缴械'  then
			return _ZMAC.CheckStats(hPlayer,'有免缴械')	
			or _ZMAC.CheckStats(hPlayer,'有沉默') 
			or (_ZMAC.CheckStats(hPlayer,'有封内') and _ZMAC.CheckStats(hPlayer,'内功'))
		elseif str =='可缴械' then
			return not _ZMAC.CheckStats(hPlayer,'不可缴械')		
		elseif str =='有免断'  then
			return _ZMAC_CheckBuff(hPlayer,'20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777','s',false)
		elseif str =='无免断'  then
			return not _ZMAC.CheckStats(hPlayer,'有免断')
		elseif str =='有免推'  then
			return _ZMAC_CheckBuff(hPlayer,'8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310','s',false)
		elseif str =='无免推'  then
			return not _ZMAC.CheckStats(hPlayer,'有免推')			
		else	
			_ZMAC.PrintRed('MSG_SYS','stats参数错误:-->'..str..'\r\n')
			return false
		end	
	end
	return false	
end
--[status]
_ZMAC.CheckStatus = function(t, str)
	if not t then return false end
	if s_find(str, '-') then 
		local StateTypes = _ZMAC_SplitStr2Array(str, '-')
		for _,StateType in ipairs(StateTypes) do
			if not _ZMAC.CheckStatus(t,StateType) then
				return false
			end
		end
		return true 
	end

	local MoveState = t.nMoveState
	local StateTypes = _ZMAC_SplitStr2Array(str,'|')
	for _, StateType in pairs(StateTypes) do
		if MoveState == nMoveStateList[StateType] then
			return true
		end
	end
	return false
end
--[mapname]
_ZMAC.CheckMapName=function(str)
	local hPlayer = GetClientPlayer()
	local tmpName = ''
	if tonumber(str) then 
		tmpName = Table_GetMapName(tonumber(str))
	else
		tmpName = str
	end
	if Table_GetMapName(hPlayer.GetScene().dwMapID) == tmpName then
		return true 
	end
	return false
end
--[haveskill]         
_ZMAC.CheckHaveSkill=function (pPlayer,pszSkillName)  
	if s_find(pszSkillName, '-') then
		local szSkillNames = _ZMAC_SplitStr2Array(pszSkillName, '-')
		for _,szSkillName in pairs(szSkillNames) do
			if not _ZMAC.CheckHaveSkill(pPlayer,szSkillName) then
				return false
			end
		end
		return true
	end
	
	local szSkillNames2 = _ZMAC_SplitStr2Array(pszSkillName, '|')
	for  _,szSkillName2 in pairs(szSkillNames2) do
		local ret = false
		local hPlayer = pPlayer
		local aSkill = hPlayer.GetAllSkillList() or {}                    --疑似卡顿
		for k, v in pairs(aSkill) do
			local szName = Table_GetSkillName(k, v)
			if szName == szSkillName2 then
				return true
			end
		end
	end
	return false
end
--[noskill]
_ZMAC.CheckNoSkill=function (pPlayer,pszSkillName)
    
	if s_find(pszSkillName, '-') then
		local szSkillNames = _ZMAC_SplitStr2Array(pszSkillName, '-')
		for _,szSkillName in ipairs(szSkillNames) do
			if not _ZMAC.CheckNoSkill(pPlayer,szSkillName) then
				return false
			end
		end
		return true
	end
	
	local szSkillNames2 = _ZMAC_SplitStr2Array(pszSkillName, '|')
	for  _,szSkillName in pairs(szSkillNames2) do
		local ret = false
		local hPlayer = pPlayer
		local aSkill = hPlayer.GetAllSkillList() or {}                  --疑似卡顿
		for k, v in pairs(aSkill) do
			local szName = Table_GetSkillName(k, v)
			if szName == szSkillName then
				return false
			end
		end
	end
	return true
end
--[cd/nocd]
_ZMAC.CheckSkillCool =function (nSkillID)
	local hPlayer = GetClientPlayer()
	if not nSkillID or nSkillID == 0 then return false end
	local nSkillLevel = hPlayer.GetSkillLevel(nSkillID)
	local bCool, nLeft, nTotal = hPlayer.GetSkillCDProgress(nSkillID, nSkillLevel)
	local CongNengCDID = Skill_GetCongNengCDID(nSkillID)
	local CnCD, CnCount = hPlayer.GetCDLeft(CongNengCDID)
	local SwiteBan = (CongNengCDID and CnCount > 0) or (nLeft == 0 and nTotal == 0) or false --判断技能是否为充能技能,和判断普通技能冷却
	if SwiteBan then
		return true
	end
	return false
end
--[npcnum/enemynpcnum/allynpcnum...]
_ZMAC.CheckNpcNum = function(str,pPlayer,tarType)
	if not pPlayer then return false end
	local Boolean,tDis,Type,Value = _ZMAC_SplitRelationSymbol(str,'[><=]')
	tDis = tonumber(tDis)
	local npcNum = 0
	if tarType=='enemy' then
		npcNum = _ZMAC.GetEnemyNpcNum(tDis,pPlayer)
	elseif tarType=='ally' then
		npcNum = _ZMAC.GetAllyNpcNum(tDis,pPlayer)
	end
	if Boolean then
		if _ZMAC_Compare(Type,npcNum, Value) then return true end
	end
	return false
end
--[enemynpcnum]
_ZMAC.GetEnemyNpcNum=function(tDis,pPlayer)
	local hPlayer = pPlayer
	if not hPlayer then return 0 end
	local Counet = 0
	tDis = tDis or 25
	for j, v in pairs(_ZMAC_GetAllNpc()) do  
		local k = v.dwID
		local Npc = v
		local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
		if Npc and IsEnemy(hPlayer.dwID, k) and Dis <= tDis then
			Counet = Counet + 1
		end
	end
	return Counet
end
--[allynpcnum]
_ZMAC.GetAllyNpcNum=function(tDis,pPlayer)
	local hPlayer = pPlayer
	if not hPlayer then return 0 end
	local Counet = 0
	tDis = tDis or 25
	for j, v in pairs(_ZMAC_GetAllNpc()) do
		local k = v.dwID
		local Npc =v
		local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
		if Npc and IsAlly(hPlayer.dwID, k) and Dis <= tDis then
			Counet = Counet + 1
		end
	end
	return Counet
end
--[playernum/enemyplayernum/allyplayernum...]
_ZMAC.CheckPlayerNum = function(str,pPlayer,tarType)
	if not pPlayer then return false end
	local Boolean,tDis,Type,Value = _ZMAC_SplitRelationSymbol(str,'[><=]')
	tDis = tonumber(tDis)
	local playerNum = 0
	if tarType=='enemy' then
		playerNum = _ZMAC.GetEnemyPlayerNum(tDis,pPlayer)
	elseif tarType=='ally' then
		playerNum = _ZMAC.GetAllyPlayerNum(tDis,pPlayer)
	elseif tarType=='party' then
		playerNum = _ZMAC.GetPartyPlayerNum(tDis,pPlayer)
	end
	if Boolean then
		if _ZMAC_Compare(Type,playerNum, Value) then return true end
	end
	return false
end
--[enemypalyernum]
_ZMAC.GetEnemyPlayerNum=function(tDis,pPlayer)
	local hPlayer = pPlayer
	if not hPlayer then return false end
	local Counet = 0
	for j, v in pairs(_ZMAC_GetAllPlayer() ) do
		local k = v.dwID
		local xPlayer = v
		local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
		if k  and Dis <= tDis and IsEnemy(hPlayer.dwID, k) then
			Counet = Counet + 1
		end
	end
	return Counet
end
--[allyplayernum]
_ZMAC.GetAllyPlayerNum=function(tDis,pPlayer)
	local hPlayer = pPlayer
	if not hPlayer then return false end
	local Counet = 0
	for j, v in pairs(_ZMAC_GetAllPlayer() ) do
		local k = v.dwID
		local xPlayer = v
		local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
		if k  and Dis <= tDis and IsAlly(hPlayer.dwID, k) then
			Counet = Counet + 1
		end
	end
	return Counet
end
--[partyplayernum]
_ZMAC.GetPartyPlayerNum=function(tDis,pPlayer)
	local hPlayer = pPlayer
	if not hPlayer then return false end
	local Counet = 0
	for j, v in pairs(_ZMAC_GetAllPlayer() ) do
		local k = v.dwID
		local xPlayer = v
		local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
		if k  and Dis <= tDis and IsParty(hPlayer.dwID, k) then
			Counet = Counet + 1
		end
	end
	return Counet
end
--[target/notarget/player/noplayer]
_ZMAC.CheckTarget = function(t, str)
	if not t then return false end
	local cTypes = _ZMAC_SplitStr2Array(str, '|')
	for _, cType in ipairs(cTypes) do
		if cType == '$player' then
			return IsPlayer(t.dwID)
		elseif cType == '$npc' then
			return not IsPlayer(t.dwID)
		elseif cType == '$boss' then
			return GetNpcIntensity(t) == 4
		elseif cType == '$noboss' then
			return GetNpcIntensity(t) ~= 4
		elseif cType == '$jingying' then
			return GetNpcIntensity(t) >= 2 and GetNpcIntensity(t) ~= 4
		end
	end
	return false
end
--[force/tforce/ttforce/tnoforce/ttnoforce]
_ZMAC.CheckForce = function(t,str)
	if (not t) or (not IsPlayer(t.dwID)) then return false end
	if s_find(str, '-') then 
		local Buffstrs = _ZMAC_SplitStr2Array(str, '-')
		for _,Buffstr in ipairs(Buffstrs) do
			if not _ZMAC.CheckForce(t,Buffstr) then
				return false
			end
		end
		return true 
	end
	
	local ForceNames = _ZMAC_SplitStr2Array(str, '|')
	for _, ForceName in ipairs(ForceNames) do
		if GetForceTitle(t.dwForceID) == ForceName then
			return true
		end
	end
	return false
end
--[name/tname/ttname]
_ZMAC.CheckName = function(t,str)
	local nName = '无目标'
	if not t then 
		nName = '无目标' 
	elseif t and t.szName then 
		nName= t.szName 
	end
	
	if s_find(str, '-') then 
		local StateTypes = _ZMAC_SplitStr2Array(str, '-')
		for _,StateType in ipairs(StateTypes) do
			if not _ZMAC.CheckName(t,StateType) then
				return false
			end
		end
		return true 
	end
	local str2 =''
	local tNames = _ZMAC_SplitStr2Array(str, '|')
	for _, tName in ipairs(tNames) do
		str2 = tName
		if str2 == '$myname' then str2 = GetClientPlayer().szName end
		if str2 == '$mytname' then 
			local nT = GetTargetHandle(GetClientPlayer().GetTarget())
			if nT and nT.szName then
				str2 = nT.szName
			else	
				return false	
			end
		end
		if nName == str2 then
			return true
		end
	end
	return false
end
--[lastcast/preskill]
_ZMAC.CheckLastCast=function (str)
	if str == '' then
		return false
	end
	--local LastCastSkillID = Skill_GetLastCast()    
	--Skill_GetLastCast()内置函数存储的是最后一次尝试释放的技能      
	--但是用_ZMAC.tCast表的方法也有bug,像翼绝云天这类持续攻击技能,也会被记录为lastcast 待解决
	local LastCastSkillName=''
	if _ZMAC.tCast[GetClientPlayer().dwID] then
		LastCastSkillName = _ZMAC.tCast[GetClientPlayer().dwID]['lastcastname']
		--Output(LastCastSkillName)
	else
		return false
	end
	
	if not LastCastSkillName then
		return false
	end
	local StrList = _ZMAC_SplitStr2Array(str, '|')
	for _, EvEnt in pairs(StrList) do
		if LastCastSkillName == EvEnt then
			return true --返回true条件成立
		end
	end
	return false
end
--[mount/tmount]
_ZMAC.CheckMount = function(t,str)
	if (not t) or (not IsPlayer(t.dwID)) then return false end
	if s_find(str, '-') then 
		local Buffstrs = _ZMAC_SplitStr2Array(str, '-')
		for _,Buffstr in ipairs(Buffstrs) do
			if not _ZMAC.CheckMount(t,Buffstr) then
				return false
			end
		end
		return true 
	end
	
	
	if t.dwID < 1073741824 and t.dwID ~= 0 then   --目标类型为PLAYER
		local Mount = t.GetKungfuMount()        --此处须加目标类型判断，否则出错
		if not Mount then return false end
		
		local MountStrs = _ZMAC_SplitStr2Array(str, '|')
		for _, MountNmae in ipairs(MountStrs) do
			if Mount.szSkillName == MountNmae then
				return true
			end
		end
	end
	return false
end
--[face]
_ZMAC.CheckFace = function(pPlayer,n)
	local player=pPlayer
	local target=GetTargetHandle(player.GetTarget())
	if player~=GetClientPlayer() then 
		target=GetClientPlayer()
	end
	if not target or not n then
		return false
	end
	local fDirection = m_abs(player.nFaceDirection - GetLogicDirection(target.nX - player.nX, target.nY - player.nY))
	
	if fDirection > 127.5 then
		fDirection = 255 - fDirection
	end

	if fDirection < n then
		return true
	end
	return false
end

--[role]
_ZMAC.CheckRole=function(t,str)
	local hPlayer = t
	if not t then return false end
	
	if s_find(str, '-') then 
		local Buffstrs = _ZMAC_SplitStr2Array(str, '-')
		for _,Buffstr in ipairs(Buffstrs) do
			if not _ZMAC.CheckRole(t,Buffstr,cType) then
				return false
			end
		end
		return true 
	end
	
	
	local szRole=g_tStrings.tRoleTypeFormalName[t.nRoleType]
	local str2 = _ZMAC_SplitStr2Array(str, '|')
	for _, EvEnt in ipairs(str2) do
		if szRole == EvEnt then 
			return true 
		end
	end
	return false

end
--[btype,detype]外功、阳性、混元、阴性、毒性、蛊
_ZMAC.CheckBType= function(t,str,cType)
	if not t then return false end
	_ZMAC.SmartRefreshBuff(t.dwID)
	if s_find(str, '-') then 
		local Buffstrs = _ZMAC_SplitStr2Array(str, '-')
		for _,Buffstr in ipairs(Buffstrs) do
			if not _ZMAC.CheckBType(t,Buffstr,cType) then
				return false
			end
		end
		return true 
	end

	for i = 1, t.GetBuffCount(), 1 do
		local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = t.GetBuff(i - 1)
		--if not dwID then return false end
		if dwID and nEndFrame -GetLogicFrameCount() >0  then
		
			local tmp=false
			local bufftypeid = GetBuffInfo(dwID, nLevel,{}).nDetachType
			if bufftypeid ~= 0 then
				local Bufftypes =_ZMAC_SplitStr2Array(str, '|')
				for _,Bufftype in pairs(Bufftypes) do
					if cType then  --增益buff
						if btype[bufftypeid]==Bufftype then
							return true
						end
					else           --debuff
						if detype[bufftypeid]==Bufftype then
							return true
						end
					end
				end
			end
		end
	end
	return false
end
--[rage,qidian,tm,energy]
function _ZMAC_CompareEnergy(cType, RealNum, cNum)
	local hPlayer=GetClientPlayer()
	local sun = hPlayer.nCurrentSunEnergy
	local moon = hPlayer.nCurrentMoonEnergy
	if cNum == 'moon' then --未知待查
		cNum = moon
		RealNum = sun
	end
	if cNum == 'sun' then
		cNum = sun
		RealNum = moon
	end
	local Boolean = false
	local RealNum = tonumber(RealNum)
	local cNum = tonumber(cNum)

	if cType=='>' then Boolean=RealNum>cNum end
	if cType=='<' then Boolean=RealNum<cNum end
	if cType=='=' then Boolean=RealNum==cNum end
	return Boolean
end
--[num/cancast]
function _ZMAC.GetSkillNum(pPlayer,cmd)
	local hPlayer = pPlayer
	local KungfuMount = hPlayer.GetKungfuMount()
	local szSkillID 
		
	szSkillID =tonumber(cmd) or _ZMAC.GetSkillIdEx(cmd)
	if type(szSkillID) == 'table' then      --实测同技能用不同id得到的结果一致
		szSkillID = szSkillID[1]
	end
	do if not szSkillID then  return 0 end end     
	local SkillLevel = hPlayer.GetSkillLevel(szSkillID)
	if SkillLevel < 1 then SkillLevel = 1 end
	local bCool, CD, TotalCD = hPlayer.GetSkillCDProgress(szSkillID, SkillLevel)

	local CongNengCDID = Skill_GetCongNengCDID(szSkillID)        --仅适用于充能技能，透支类不支持
	local CnCD, CnCount = hPlayer.GetCDLeft(CongNengCDID)
	
	local Skill = GetSkill(szSkillID, SkillLevel)
	if szSkillID==16620 then   --[封渊震煞]  点了渊冰才是3层充能
		if _ZMAC.CheckHaveSkill(hPlayer,'渊冰')==true then
			_ZMAC.TouzhiSkillList[16620][2] = 3
		else
			_ZMAC.TouzhiSkillList[16620][2] = 2
		end
	end
	
	if _ZMAC.TouzhiSkillList[szSkillID]~= nil then             --透支类
		local TouzhiCD,TouzhiCount = CD,_ZMAC.TouzhiSkillList[szSkillID][2]-TotalCD/(_ZMAC.TouzhiSkillList[szSkillID][1]*16)
		TouzhiCount = math.floor(TouzhiCount+0.5)   --_ZMAC.TouzhiSkillList[szSkillID][1]记录的cd时间，有可能会被奇穴等影响，所以直接取整，有小概率情况会bug
		return TouzhiCount
	elseif CongNengCDID then
		return CnCount
	else
		local gcdID=605 --骑御
		if KungfuMount=='焚影圣诀' or KungfuMount=='明尊琉璃体' then
			gcdID=3962 --赤日轮
		elseif KungfuMount=='笑尘诀' then
			gcdID=5258 --拨狗朝天
		end

		local GcdSkillLevel = hPlayer.GetSkillLevel(gcdID)
		local _, GCD, TotalGCD = hPlayer.GetSkillCDProgress(gcdID, GcdSkillLevel)

		if CD==0 and TotalCD==0 then   
			return 1 
		elseif  GCD== CD and TotalGCD == TotalCD  then  --cd与gcd完全相同时，则该技能没有cd，需要返回1
			return 1
		else 
			return 0
		end
	end
	
end

function _ZMAC.GetSkillIDNum(pPlayer,cmd)
	local hPlayer = pPlayer
	local KungfuMount = hPlayer.GetKungfuMount()
	local szSkillID 
		
	szSkillID =tonumber(cmd)  -- or _ZMAC.GetSkillIdEx(cmd)  --专门写的_ZMAC.GetSkillIDNum，防止取num和取id无限循环
	-- if type(szSkillID) == 'table' then      --实测同技能用不同id得到的结果一致
		-- szSkillID = szSkillID[1]
	-- end
	do if not szSkillID then return 0 end end     
	local SkillLevel = hPlayer.GetSkillLevel(szSkillID)
	if SkillLevel < 1 then SkillLevel = 1 end
	local bCool, CD, TotalCD = hPlayer.GetSkillCDProgress(szSkillID, SkillLevel)

	local CongNengCDID = Skill_GetCongNengCDID(szSkillID)        --仅适用于充能技能，透支类不支持
	local CnCD, CnCount = hPlayer.GetCDLeft(CongNengCDID)
	
	local Skill = GetSkill(szSkillID, SkillLevel)
	if szSkillID==16620 then   --[封渊震煞]  点了渊冰才是3层充能
		if _ZMAC.CheckHaveSkill(hPlayer,'渊冰')==true then
			_ZMAC.TouzhiSkillList[16620][2] = 3
		else
			_ZMAC.TouzhiSkillList[16620][2] = 2
		end
	end
	
	if _ZMAC.TouzhiSkillList[szSkillID]~= nil then             --透支类
		local TouzhiCD,TouzhiCount = CD,_ZMAC.TouzhiSkillList[szSkillID][2]-TotalCD/(_ZMAC.TouzhiSkillList[szSkillID][1]*16)
		TouzhiCount = math.floor(TouzhiCount+0.5)   --_ZMAC.TouzhiSkillList[szSkillID][1]记录的cd时间，有可能会被奇穴等影响，所以直接取整，有小概率情况会bug
		return TouzhiCount
	elseif CongNengCDID then
		return CnCount
	else
		local gcdID=605 --骑御
		if KungfuMount=='焚影圣诀' or KungfuMount=='明尊琉璃体' then
			gcdID=3962 --赤日轮
		elseif KungfuMount=='笑尘诀' then
			gcdID=5258 --拨狗朝天
		end

		local GcdSkillLevel = hPlayer.GetSkillLevel(gcdID)
		local _, GCD, TotalGCD = hPlayer.GetSkillCDProgress(gcdID, GcdSkillLevel)

		if CD==0 and TotalCD==0 then   
			return 1 
		elseif  GCD== CD and TotalGCD == TotalCD  then  --cd与gcd完全相同时，则该技能没有cd，需要返回1
			return 1
		else 
			return 0
		end
	end
	
end


--[life]
function _ZMAC.GetLifeValue(t, szCurrent)
	local hPlayer = GetClientPlayer()
	t = t or hPlayer
	szCurrent = tonumber(szCurrent)
	if szCurrent <= 1 then
		return t.nCurrentLife / t.nMaxLife
	elseif szCurrent > 100 then
		return t.nCurrentLife
	elseif szCurrent > 1 and szCurrent <= 100 then
		return _ZMAC.Decimal(100 * t.nCurrentLife / t.nMaxLife)
	end
end
--[mana]
function _ZMAC.GetManaValue(t, szCurrent)
	local hPlayer = GetClientPlayer()
	t = t or hPlayer
	szCurrent = tonumber(szCurrent)
	if szCurrent <= 1 then
		return t.nCurrentMana / t.nMaxMana
	elseif szCurrent > 100 then
		return t.nCurrentMana
	elseif szCurrent > 1 and szCurrent <= 100 then
		return _ZMAC.Decimal(100 * t.nCurrentMana / t.nMaxMana)
	end
end
--[fighttime]
function _ZMAC.GetFightTime()
	local hPlayer = GetClientPlayer()
	local Count = 0
	if hPlayer and hPlayer.bFightState and _ZMAC.FightBeginTime > 0 then
		local timenum = _ZMAC.Decimal(GetCurrentTime() - _ZMAC.FightBeginTime)
		Count = timenum
	end
	return Count
end

--[rage/moon/sun/qidian/dhun...]
function _ZMAC.GetValue(pPlayer)
	local hPlayer = pPlayer
	local Kungfu = hPlayer.GetKungfuMount()
	local nValue = 0
	if not Kungfu then
		return nValue
	end
	
	if Kungfu.dwSkillID == 10002 or Kungfu.dwSkillID == 10003 then --少林
		nValue = hPlayer.nAccumulateValue
		if nValue < 0 then nValue = 0 end
		if nValue > 3 then nValue = 3 end
	elseif Kungfu.dwSkillID == 10081 then --七秀
		nValue = hPlayer.nAccumulateValue
		if nValue < 0 then nValue = 0 end
		if nValue > 10 then nValue = 10 end
	elseif Kungfu.dwSkillID == 10464 then --霸刀
		local hFrame = Station.Lookup('Normal/Player')
		local BaDaoState = hFrame:Lookup('','')
		local BaDaoStateType = BaDaoState:Lookup('Handle_BaDao')
		local nPoseState = (BaDaoStateType and BaDaoStateType.nPoseState) or 2
		if nPoseState == 1 then --雾体
			nValue = hPlayer.nCurrentEnergy
		elseif nPoseState == 2 then --尘身
			nValue = hPlayer.nCurrentRage
		elseif nPoseState == 3 then --金屏
			nValue = hPlayer.nCurrentSunEnergy
		end
		if nValue < 0 then nValue = 0 end
		if nValue > 120 then nValue = 120 end
	elseif Kungfu.dwSkillID == 10014 or Kungfu.dwSkillID == 10015 then --纯阳
		nValue = hPlayer.nAccumulateValue
		if nValue > 10 then nValue = 10 end
		nValue = nValue + 1
		--nValue = nValue / 2  --纯阳5豆直接按10点能量计算
	elseif Kungfu.dwSkillID == 10144 or Kungfu.dwSkillID == 10145 or Kungfu.dwSkillID == 10389 or Kungfu.dwSkillID == 10390 then --藏剑 苍云
		nValue = hPlayer.nCurrentRage
	elseif Kungfu.dwSkillID == 10224 or Kungfu.dwSkillID == 10225 then --唐门
		nValue = hPlayer.nCurrentEnergy
	end
	return nValue
end


--//减伤系数获取
_ZMAC.ReductionList ={
	
[9975]={
["1"]={nLevel=1,[2]=0,szDesc="伤痛让森九岚变得更强，所有伤害增加20%",[3]=0,[1]=0,szName="不屈",dwID=9975}},
[9724]={
["1"]={nLevel=1,[2]=0,[4]=3,szDesc="外功防御等级提高<BUFF atPhysicsShieldBase>，被攻击则去掉一层并恢复少量气血值，且额外恢复自身3%最大气血值",[3]=0,[1]=0,szName="毫针",dwID=9724}},
[6154]={
["1"]={nLevel=1,[2]=50,szDesc="受到伤害降低50%",[3]=50,[1]=50,szName="落水打狗",dwID=6154}},
[1802]={
["1"]={nLevel=1,[2]=35,szDesc="受到的伤害降低35%",[3]=35,[1]=35,szName="御天",dwID=1802},
["3"]={nLevel=3,[2]=99,szDesc="受到的伤害降低99%",[3]=99,[1]=99,szName="御天",dwID=1802},
["2"]={nLevel=2,[2]=70,szDesc="受到的伤害降低70%",[3]=70,[1]=70,szName="御天",dwID=1802}},
[14067]={
["1"]={nLevel=1,[2]=10,szDesc="每层减伤效果提高10%",[3]=10,[1]=10,szName="遨宇",dwID=14067}},
[9736]={
["1"]={nLevel=1,[2]=0,szDesc="闪避几率提高30%",[3]=30,[1]=0,szName="慈悲愿",dwID=9736},
["3"]={nLevel=3,[2]=0,szDesc="闪避几率提高15%，威胁值提高30%",[3]=15,[1]=0,szName="慈悲愿",dwID=9736},
["2"]={nLevel=2,[2]=0,szDesc="闪避几率提高60%",[3]=60,[1]=0,szName="慈悲愿",dwID=9736}},
[4376]={
["1"]={nLevel=1,[2]=60,szDesc="受到的伤害降低60%",[3]=60,[1]=60,szName="守如山",dwID=4376}},
[9742]={
["1"]={nLevel=1,[2]=0,szDesc="气血值每低于10%，闪避几率提高2%",[3]=2,[1]=0,szName="华彩若英",dwID=9742}},
[6163]={
["1"]={nLevel=1,[2]=50,szDesc="受到伤害降低50%",[3]=50,[1]=50,szName="守如山",dwID=6163}},
[13571]={
["1"]={nLevel=1,[2]=0,szDesc="驭雕飞行",[3]=0,[1]=0,szName="横绝",dwID=13571}},
[1552]={
["1"]={nLevel=1,[2]=40,szDesc="受到的伤害降低40%",[3]=40,[1]=40,szName="春泥护花",dwID=1552}},
-- [7964]={
-- ["1"]={nLevel=1,[2]=0,szDesc="效果期间被击回复自身10%气血最大值",[3]=0,[1]=0,szName="贪魔体",dwID=7964}},
[9782]={
["1"]={nLevel=1,[2]=60,szDesc="化解受到的伤害60%",[3]=60,[1]=60,szName="天地低昂",dwID=9782}},
[126]={
["1"]={nLevel=1,[2]=0,[4]=6,szDesc="外功防御等级提高<BUFF atPhysicsShieldBase>，被攻击则去掉一层并恢复<Skill 5798 0 4%><Skill 5798 1 6%>最大气血值",[3]=0,[1]=0,szName="毫针",dwID=126}},
[4147]={
["1"]={nLevel=1,[2]=200,szDesc="反弹受到的伤害",[3]=200,[1]=200,szName="护体",dwID=4147}},
[20799]={
["1"]={nLevel=1,[2]=50,szDesc="承担50%的伤害",[3]=50,[1]=50,szName="凝壁",dwID=20799}},
[684]={
["1"]={nLevel=1,[2]=40,szDesc="化解受到的伤害40%",[3]=40,[1]=40,szName="天地低昂",dwID=684},
["2"]={nLevel=2,[2]=40,szDesc="化解受到的伤害60%",[3]=40,[1]=40,szName="天地低昂",dwID=684}},
[1173]={
["1"]={nLevel=1,[2]=80,szDesc="受到伤害降低80%，并且不会重伤倒下",[3]=80,[1]=80,szName="守如山",dwID=1173}},
[2849]={
["1"]={nLevel=1,[2]=35,szDesc="受到的伤害减少35%",[3]=35,[1]=35,szName="蝶戏水",dwID=2849}},
[9810]={
["1"]={nLevel=1,[2]=50,szDesc="受到伤害降低50%",[3]=50,[1]=50,szName="舍身",dwID=9810}},
[3107]={
["1"]={nLevel=1,[2]=50,szDesc="受到的伤害降低50%",[3]=50,[1]=50,szName="天地低昂",dwID=3107}},
[6200]={
["1"]={nLevel=1,[2]=60,szDesc="受到的伤害降低60%",[3]=60,[1]=60,szName="龙啸九天",dwID=6200}},
[8292]={
["1"]={nLevel=1,[2]=0,[4]=60,szDesc="化解自身最大气血值60%的伤害，每秒回复自身3%的气血",[3]=0,[1]=0,szName="战毅",dwID=8292},
["3"]={nLevel=3,[2]=0,[4]=60,szDesc="吸收自身最大气血值60%的伤害效果，每点招架等级额外提高10点伤害吸收效果",[3]=0,[1]=0,szName="盾壁",dwID=8292},
["2"]={nLevel=2,[2]=0,[4]=40,szDesc="吸收自身最大气血值40%的伤害效果，每点招架等级额外提高10点伤害吸收效果",[3]=0,[1]=0,szName="盾壁",dwID=8292},
["5"]={nLevel=5,[2]=0,[4]=100,szDesc="吸收自身最大气血值100%的伤害效果，每点招架等级额外提高10点伤害吸收效果",[3]=0,[1]=0,szName="盾壁",dwID=8292},
["4"]={nLevel=4,[2]=0,[4]=80,szDesc="吸收自身最大气血值80%的伤害效果，每点招架等级额外提高10点伤害吸收效果",[3]=0,[1]=0,szName="盾壁",dwID=8292},
["6"]={nLevel=6,[2]=0,[4]=100,szDesc="化解自身最大气血值100%的伤害，每秒回复自身3%的气血",[3]=0,[1]=0,szName="战毅",dwID=8292}},
[2983]={
["1"]={nLevel=1,[2]=20,szDesc="受到的伤害降低20%",[3]=20,[1]=20,szName="无我",dwID=2983},
["2"]={nLevel=2,[2]=50,szDesc="受到的伤害降低50%，受到“锁足”“定身”“眩晕”“击倒”控制效果持续时间缩短30%",[3]=50,[1]=50,szName="无我",dwID=2983}},
[8300]={
["1"]={nLevel=1,[2]=40,szDesc="使自身受到的伤害降低40%",[3]=40,[1]=40,szName="盾墙",dwID=8300},
["3"]={nLevel=3,[2]=60,szDesc="使自身受到的伤害降低60%",[3]=60,[1]=60,szName="盾墙",dwID=8300},
["2"]={nLevel=2,[2]=50,szDesc="使自身受到的伤害降低50%",[3]=50,[1]=50,szName="盾墙",dwID=8300}},
[9836]={
["1"]={nLevel=1,[2]="待",szDesc="受到的伤害降低80%",[3]="待",[1]=80,szName="摩咭",dwID=9836}},
[9073]={
["1"]={nLevel=1,[2]=0,szDesc="受到的伤害降低<BUFF_EX 1024 atGlobalResistPercent>%",[3]=0,[1]=0,szName="烟消云散",dwID=9073}},
[9334]={
["1"]={nLevel=1,[2]=30,szDesc="吸收大量伤害效果，该伤害吸收盾吸收值可通过过量治疗效果填充",[3]=30,[1]=30,szName="梅花三弄",dwID=9334},
["4"]={nLevel=4,[2]=30,szDesc="吸收大量伤害效果，招式调息速度提高15%，并使自身伤害招式无视目标15%内外功防御等级，该伤害吸收盾吸收值可通过过量治疗效果填充",[3]=30,[1]=30,szName="梅花三弄",dwID=9334},
["3"]={nLevel=3,[2]=30,szDesc="吸收大量伤害效果，招式调息速度提高15%，该伤害吸收盾吸收值可通过过量治疗效果填充",[3]=30,[1]=30,szName="梅花三弄",dwID=9334},
["2"]={nLevel=2,[2]=30,szDesc="吸收大量伤害效果，并使自身伤害招式无视目标15%内外功防御等级，该伤害吸收盾吸收值可通过过量治疗效果填充",[3]=30,[1]=30,szName="梅花三弄",dwID=9334}},
-- [5704]={
-- ["1"]={nLevel=1,[2]=0,szDesc="基础气血上限提高10%",[3]=0,[1]=0,szName="轮回",dwID=5704}},
[11384]={
["1"]={nLevel=1,[2]=25,szDesc="受到所有伤害降低25%",[3]=25,[1]=25,szName="西楚悲歌",dwID=11384}},
[3120]={
["1"]={nLevel=1,[2]=50,szDesc="受到的伤害降低50%",[3]=50,[1]=50,szName="春泥护花",dwID=3120}},
[15735]={
["1"]={nLevel=1,[2]=50,szDesc="格挡远程弹道技能，受到伤害降低50%",[3]=50,[1]=50,szName="斩无常",dwID=15735},
["2"]={nLevel=2,[2]=50,szDesc="免疫控制效果，格挡远程弹道技能，受到伤害降低50%",[3]=50,[1]=50,szName="斩无常",dwID=15735}},
[9874]={
["1"]={nLevel=1,[2]=40,szDesc="受到所有伤害降低40%",[3]=40,[1]=40,szName="散影",dwID=9874}},
[6739]={
["1"]={nLevel=1,[2]=40,szDesc="受到伤害降低40%",[3]=40,[1]=40,szName="息元",dwID=6739}},
[6492]={
["1"]={nLevel=1,[2]=75,szDesc="受到的伤害降低75%",[3]=75,[1]=75,szName="笑醉狂",dwID=6492}},
[2108]={
["1"]={nLevel=1,[2]=0,[4]=1,szDesc="外功防御等级提高<BUFF atPhysicsShieldBase>点，被攻击则去掉一层并恢复1000点气血值",[3]=0,[1]=0,szName="毫针",dwID=2108}},
[4711]={
["1"]={nLevel=1,[2]=7*0.08,szDesc="内功防御等级提高7%",[3]=0,[1]=0,szName="旷劫",dwID=4711},
["2"]={nLevel=2,[2]=15*0.08,szDesc="内功防御等级提高15%",[3]=0,[1]=0,szName="旷劫",dwID=4711}},
[17959]={
["1"]={nLevel=1,[2]=0,szDesc="下一个治疗招式将附带60%减伤效果",[3]=0,[1]=0,szName="司命",dwID=17959}},
[5735]={
["1"]={nLevel=1,[2]=15,szDesc="闪避几率提高15%且每点身法化解2点伤害",[3]=30,[1]=15,szName="泉凝月",dwID=5735},
["8"]={nLevel=8,[2]=15,szDesc="闪避几率提高15%且每点身法化解37.5点伤害，化解量随时间衰减",[3]=30,[1]=15,szName="泉凝月",dwID=5735},
["3"]={nLevel=3,[2]=15,szDesc="闪避几率提高15%且每点身法化解3点伤害",[3]=30,[1]=15,szName="泉凝月",dwID=5735},
["5"]={nLevel=5,[2]=15,szDesc="闪避几率提高15%且每点身法化解4点伤害",[3]=30,[1]=15,szName="泉凝月",dwID=5735},
["4"]={nLevel=4,[2]=15,szDesc="闪避几率提高15%且每点身法化解3点伤害",[3]=30,[1]=15,szName="泉凝月",dwID=5735},
["7"]={nLevel=7,[2]=15,szDesc="闪避几率提高15%且每点身法化解5点伤害",[3]=30,[1]=15,szName="泉凝月",dwID=5735},
["6"]={nLevel=6,[2]=15,szDesc="闪避几率提高15%且每点身法化解4点伤害",[3]=30,[1]=15,szName="泉凝月",dwID=5735}},
[3259]={
["1"]={nLevel=1,[2]=100,szDesc="被天狗的气劲所保护，免疫一切攻击",[3]=100,[1]=100,szName="护体",dwID=3259}},
[6248]={
["1"]={nLevel=1,[2]=40,szDesc="受到的伤害降低40%",[3]=40,[1]=40,szName="枯残蛊",dwID=6248}},
[5996]={
["1"]={nLevel=1,[2]=50,szDesc="受到伤害降低50%",[3]=50,[1]=50,szName="笑醉狂",dwID=5996},
["4"]={nLevel=4,[2]=95,szDesc="受到伤害降低95%",[3]=95,[1]=95,szName="笑醉狂",dwID=5996},
["3"]={nLevel=3,[2]=90,szDesc="受到伤害降低90%",[3]=90,[1]=90,szName="笑醉狂",dwID=5996},
["2"]={nLevel=2,[2]=55,szDesc="受到伤害降低55%",[3]=55,[1]=55,szName="笑醉狂",dwID=5996}},
[5744]={
["1"]={nLevel=1,[2]=40,szDesc="受到伤害降低40%",[3]=40,[1]=40,szName="贪魔体",dwID=5744}},
[6257]={
["1"]={nLevel=1,[2]=45,szDesc="受到伤害降低45%",[3]=45,[1]=45,szName="春泥护花",dwID=6257}},
[6262]={
["1"]={nLevel=1,[2]=30,szDesc="受到伤害降低30%",[3]=30,[1]=30,szName="金屋",dwID=6262}},
[5753]={
["1"]={nLevel=1,[2]=0,szDesc="强制目标",[3]=0,[1]=0,szName="贪魔体",dwID=5753}},
[6264]={
["1"]={nLevel=1,[2]=48,szDesc="受到伤害降低48%",[3]=48,[1]=48,szName="春泥护花",dwID=6264},
["3"]={nLevel=3,[2]=52,szDesc="受到伤害降低52%",[3]=52,[1]=52,szName="春泥护花",dwID=6264},
["2"]={nLevel=2,[2]=50,szDesc="受到伤害降低50%",[3]=50,[1]=50,szName="春泥护花",dwID=6264},
["5"]={nLevel=5,[2]=56,szDesc="受到伤害降低56%",[3]=56,[1]=56,szName="春泥护花",dwID=6264},
["4"]={nLevel=4,[2]=54,szDesc="受到伤害降低54%",[3]=54,[1]=54,szName="春泥护花",dwID=6264},
["7"]={nLevel=7,[2]=60,szDesc="受到伤害降低60%",[3]=60,[1]=60,szName="春泥护花",dwID=6264},
["6"]={nLevel=6,[2]=58,szDesc="受到伤害降低58%",[3]=58,[1]=58,szName="春泥护花",dwID=6264}},
[9693]={
["1"]={nLevel=1,[2]=40,szDesc="受到的所有伤害降低40%",[3]=40,[1]=40,szName="清绝影歌",dwID=9693}},
[9695]={
["1"]={nLevel=1,[2]=0,szDesc="无法受到治疗效果的影响",[3]=0,[1]=0,szName="清绝影歌",dwID=9695}},
[12506]={
["1"]={nLevel=1,[2]=50,szDesc="自身受到的伤害的50%转移给刀气障碍",[3]=50,[1]=50,szName="风身",dwID=12506}},
[7035]={
["1"]={nLevel=1,[2]=40,szDesc="受到伤害减小",[3]=40,[1]=40,szName="盾墙",dwID=7035}},
[18071]={
["1"]={nLevel=1,[2]=0,szDesc="闪避几率提高10%",[3]=10,[1]=0,szName="具智",dwID=18071}},
[16545]={
["1"]={nLevel=1,[2]=60,szDesc="受到的伤害降低60%",[3]=60,[1]=60,szName="璇妗",dwID=16545}},
[4489]={
["1"]={nLevel=1,[2]=0,szDesc="外功防御等级提高7%",[3]=7*0.08,[1]=0,szName="溯源",dwID=4489},
["2"]={nLevel=2,[2]=0,szDesc="外功基础防御等级提高15%",[3]=15*0.08,[1]=0,szName="溯源",dwID=4489}},
[3274]={
["1"]={nLevel=1,[2]=0,szDesc="受到的伤害降低<BUFF_EX 1024 atGlobalResistPercent>%",[3]=0,[1]=0,szName="烟消云散",dwID=3274}},
[4494]={
["1"]={nLevel=1,[2]=5*0.08,szDesc="内、外功基础防御提高5%",[3]=5*0.08,[1]=5*0.08,szName="明力",dwID=4494}},
[12530]={
["1"]={nLevel=1,[2]=60,szDesc="自身受到伤害降低60%,且使击破该效果的目标获得破绽效果",[3]=60,[1]=60,szName="乘龙戏水",dwID=12530}},
[13044]={
["1"]={nLevel=1,[2]=45,szDesc="受到的伤害降低45%",[3]=45,[1]=45,szName="无相诀",dwID=13044},
["3"]={nLevel=3,[2]=55,szDesc="受到的伤害降低55%",[3]=55,[1]=55,szName="无相诀",dwID=13044},
["2"]={nLevel=2,[2]=50,szDesc="受到的伤害降低50%",[3]=50,[1]=50,szName="无相诀",dwID=13044},
["5"]={nLevel=5,[2]=65,szDesc="受到的伤害降低65%",[3]=45,[1]=65,szName="无相诀",dwID=13044},
["4"]={nLevel=4,[2]=60,szDesc="受到的伤害降低60%",[3]=60,[1]=60,szName="无相诀",dwID=13044}},
[4244]={
["1"]={nLevel=1,[2]=0,[4]=15,szDesc="化解伤害",[3]=0,[1]=0,szName="渡厄",dwID=4244}},
[4245]={
["1"]={nLevel=1,[2]=60,szDesc="不受招式控制，受到的伤害降低60%",[3]=60,[1]=60,szName="圣体",dwID=4245}},
-- [5778]={
-- ["1"]={nLevel=1,[2]=0,szDesc="每5秒为周围10尺的小队成员恢复气血",[3]=0,[1]=0,szName="雾体",dwID=5778}},
[7054]={
["1"]={nLevel=1,[2]=40,szDesc="受到的伤害降低40%",[3]=40,[1]=40,szName="圣手织天",dwID=7054}},
[3791]={
["1"]={nLevel=1,[2]=40,szDesc="受到伤害降低40%",[3]=40,[1]=40,szName="盾墙",dwID=3791}},
[6547]={
["1"]={nLevel=1,[2]=5,szDesc="受到伤害降低5%",[3]=5,[1]=5,szName="御天",dwID=6547}},
[3792]={
["1"]={nLevel=1,[2]=0,[4]=50,szDesc="吸收180000点伤害后消除，并对周围友方单位产生庇护效果",[3]=0,[1]=0,szName="盾墙",dwID=3792},
["2"]={nLevel=2,[2]=0,[4]=200,szDesc="吸收648000点伤害后消除，并对周围友方单位产生庇护效果。只吸收近战伤害",[3]=0,[1]=0,szName="盾墙",dwID=3792}}, --特殊
[10014]={
["1"]={nLevel=1,[2]=50,szDesc="受到所有伤害降低50%，闪避几率提高30%",[3]=80,[1]=50,szName="绝歌",dwID=10014}},
[9506]={
["1"]={nLevel=1,[2]=0,szDesc="立琴拔剑，以近战形态攻击目标",[3]=0,[1]=0,szName="清绝影歌",dwID=9506}},
[9510]={
["1"]={nLevel=1,[2]=40,szDesc="受到的所有伤害降低40%",[3]=40,[1]=40,szName="青霄飞羽",dwID=9510}},
[18203]={
["1"]={nLevel=1,[2]=0,[4]=20,szDesc="化解自身最大气血值20%的伤害并降低其受到外功伤害的25%",[3]=0,[1]=0,szName="问吉",dwID=18203}},
[6306]={
["1"]={nLevel=1,[2]=0,szDesc="受到的伤害降低50%",[3]=0,[1]=0,szName="光明相",dwID=6306}},
[15897]={
["1"]={nLevel=1,[2]=0,szDesc="无法离开被链接目标10尺",[3]=0,[1]=0,szName="横云意",dwID=15897}},
[9781]={
["1"]={nLevel=1,[2]=60,szDesc="化解受到的伤害60%",[3]=60,[1]=60,szName="天地低昂",dwID=9781}},
[11319]={
["1"]={nLevel=1,[2]=60,szDesc="免疫控制效果且受到的伤害降低60%",[3]=60,[1]=60,szName="临渊蹈河",dwID=11319}},
[6315]={
["1"]={nLevel=1,[2]=50,szDesc="受到伤害降低50%",[3]=50,[1]=50,szName="零落",dwID=6315}},
[8265]={
["1"]={nLevel=1,[2]=0,szDesc="免疫所有控制效果",[3]=0,[1]=0,szName="盾墙",dwID=8265}},
[9544]={
["1"]={nLevel=1,[2]=40,szDesc="受到所有伤害降低40%",[3]=40,[1]=40,szName="笑傲光阴",dwID=9544},
["2"]={nLevel=2,[2]=70,szDesc="受到所有伤害降低70%",[3]=70,[1]=70,szName="笑傲光阴",dwID=9544}},
[399]={
["1"]={nLevel=1,[2]=35,szDesc="受到的伤害降低35%",[3]=35,[1]=35,szName="无相诀",dwID=399},
["4"]={nLevel=4,[2]=50,szDesc="受到的伤害降低50%",[3]=50,[1]=50,szName="无相诀",dwID=399},
["3"]={nLevel=3,[2]=45,szDesc="受到的伤害降低45%",[3]=45,[1]=45,szName="无相诀",dwID=399},
["2"]={nLevel=2,[2]=40,szDesc="受到的伤害降低40%",[3]=40,[1]=40,szName="无相诀",dwID=399}},
[8279]={
["1"]={nLevel=1,[2]=0,[4]=60,szDesc="化解自身最大气血值60%的伤害",[3]=0,[1]=0,szName="盾壁",dwID=8279},
["4"]={nLevel=4,[2]=0,[4]=80,szDesc="化解自身最大气血值80%的伤害",[3]=0,[1]=0,szName="盾壁",dwID=8279},
["5"]={nLevel=5,[2]=0,[4]=100,szDesc="化解自身最大气血值100%的伤害",[3]=0,[1]=0,szName="盾壁",dwID=8279},
["2"]={nLevel=2,[2]=0,[4]=40,szDesc="化解自身最大气血值40%的伤害",[3]=0,[1]=0,szName="盾壁",dwID=8279}},
[10066]={
["1"]={nLevel=1,[2]=50,szDesc="受到所有伤害降低50%",[3]=50,[1]=50,szName="无我",dwID=10066}},
[3171]={
["1"]={nLevel=1,[2]=40,szDesc="受到的伤害降低40%",[3]=40,[1]=40,szName="春泥护花",dwID=3171}},
[8291]={
["1"]={nLevel=1,[2]=0,[4]=5,szDesc="化解自身气血最大值5%的伤害效果",[3]=0,[1]=0,szName="盾护",dwID=8291},
["2"]={nLevel=2,[2]=0,[4]=10,szDesc="化解自身气血最大值10%的伤害效果",[3]=0,[1]=0,szName="盾护",dwID=8291}},
[368]={
["1"]={nLevel=1,[2]=80,szDesc="受到的伤害降低80%",[3]=80,[1]=80,szName="守如山-铁牢律",dwID=368}},
[384]={
["1"]={nLevel=1,[2]=60,szDesc="使纯阳诀下所有招式瞬发，不受无法施展内功招式效果的影响，并且自身受到的伤害降低60%",[3]=60,[1]=60,szName="转乾坤",dwID=384},
["2"]={nLevel=2,[2]=70,szDesc="使纯阳诀下所有招式瞬发，不受无法施展内功招式效果的影响，并且自身受到的伤害降低70%，每秒恢复自身8%气血最大值",[3]=70,[1]=70,szName="转乾坤",dwID=384}},
[9337]={
["1"]={nLevel=1,[2]=30,szDesc="效果期间使自身受到的所有伤害降低30%",[3]=30,[1]=30,szName="寒梅",dwID=9337},
["2"]={nLevel=2,[2]=30,szDesc="效果期间使自身受到的治疗效果提高30%，受到所有伤害降低30%",[3]=30,[1]=30,szName="寒梅",dwID=9337}},
[6090]={
["1"]={nLevel=1,[2]=0,szDesc="化解自身受到的伤害效果，根骨越高，化解量越大",[3]=0,[1]=0,szName="坐忘无我",dwID=6090}},
[8839]={
["1"]={nLevel=1,[2]=40,szDesc="受到伤害降低40%",[3]=40,[1]=40,szName="圣手织天",dwID=8839},
["2"]={nLevel=2,[2]=55,szDesc="受到伤害降低55%",[3]=55,[1]=55,szName="圣手织天",dwID=8839}},
[10118]={
["1"]={nLevel=1,[2]=50,szDesc="不受控制进入癫狂状态，移动速度提高50%，受到的伤害降低50%",[3]=50,[1]=50,szName="蚀心蛊",dwID=10118}},
[2419]={
["1"]={nLevel=1,[2]=100,szDesc="化解伤害",[3]=100,[1]=100,szName="御",dwID=2419}},
[7119]={
["1"]={nLevel=1,[2]=80,szDesc="受到的伤害降低80%",[3]=80,[1]=80,szName="轮回",dwID=7119}},
[9873]={
["1"]={nLevel=1,[2]=40,szDesc="受到的所有伤害降低40%",[3]=40,[1]=40,szName="曳光",dwID=9873}},
[15234]={
["1"]={nLevel=1,[2]=35,szDesc="被命中几率降低35%",[3]=35,[1]=35,szName="羁影",dwID=15234}},
[3315]={
["1"]={nLevel=1,[2]=40,szDesc="受到伤害降低40%，受到的“锁足”“定身”“眩晕”控制效果持续时间降低40%",[3]=40,[1]=40,szName="护体",dwID=3315}},
[4575]={
["1"]={nLevel=1,[2]=15*0.08,szDesc="防御提高15%，反弹远程伤害<BUFF atPoisonMagicReflection>点",[3]=15*0.08,[1]=15*0.08,szName="盾墙",dwID=4575}},
[6361]={
["1"]={nLevel=1,[2]=0,szDesc="不受控制招式效果影响(击退和被拉除外)",[3]=0,[1]=0,szName="突",dwID=6361}},
[19222]={
["1"]={nLevel=1,[2]=0,[4]=20,szDesc="化解自身最大气血值20%的伤害，期间自身伤害提高10%",[3]=0,[1]=0,szName="无间影狱",dwID=19222}},
[9745]={
["1"]={nLevel=1,[2]=30,szDesc="受到伤害降低30%，每秒回复5%气血最大值",[3]=30,[1]=30,szName="朝圣",dwID=9745}},
[6301]={
["1"]={nLevel=1,[2]=100,szDesc="每层化解一次伤害",[3]=100,[1]=100,szName="纵遇善缘",dwID=6301}},
[7387]={
["1"]={nLevel=1,[2]=100,szDesc="免疫一切伤害",[3]=100,[1]=100,szName="护体",dwID=7387}},
[3447]={
["1"]={nLevel=1,[2]=40,szDesc="携带玄水蛊术的目标为自身承担40%受到的伤害",[3]=40,[1]=40,szName="玄水蛊",dwID=3447},
["3"]={nLevel=3,[2]=50,szDesc="宠物承担主人50%受到的伤害",[3]=50,[1]=50,szName="玄水蛊",dwID=3447},
["2"]={nLevel=2,[2]=70,szDesc="宠物承担主人70%受到的伤害",[3]=70,[1]=70,szName="玄水蛊",dwID=3447}},
[18075]={
["1"]={nLevel=1,[2]=50,szDesc="免疫控制效果，被命中几率降低50%",[3]=50,[1]=50,szName="微妙风",dwID=18075},
["2"]={nLevel=2,[2]=70,szDesc="免疫控制效果，被命中几率降低70%",[3]=70,[1]=70,szName="微妙风",dwID=18075}},
[3193]={
["1"]={nLevel=1,[2]=80,szDesc="受到的伤害降低80%，并对攻击自身的目标造成伤害",[3]=80,[1]=80,szName="守如山",dwID=3193}},
[17961]={
["1"]={nLevel=1,[2]=60,szDesc="减少受到的伤害60%",[3]=60,[1]=60,szName="司命",dwID=17961}},
[122]={
["1"]={nLevel=1,[2]=28,[4]=3,szDesc="使其受到伤害降低28%，被攻击则消耗一层，每消耗一层则回复3%气血值",[3]=28,[1]=28,szName="春泥护花",dwID=122},  --处理
["2"]={nLevel=2,[2]=30,[4]=3,szDesc="使其受到伤害降低30%，被攻击则消耗一层，每消耗一层则回复3%气血值",[3]=30,[1]=30,szName="春泥护花",dwID=122},
["3"]={nLevel=3,[2]=32,[4]=3,szDesc="使其受到伤害降低32%，被攻击则消耗一层，每消耗一层则回复3%气血值",[3]=32,[1]=32,szName="春泥护花",dwID=122},
["5"]={nLevel=5,[2]=36,[4]=3,szDesc="使其受到伤害降低36%，被攻击则消耗一层，每消耗一层则回复3%气血值",[3]=36,[1]=36,szName="春泥护花",dwID=122},
["4"]={nLevel=4,[2]=34,[4]=3,szDesc="使其受到伤害降低34%，被攻击则消耗一层，每消耗一层则回复3%气血值",[3]=34,[1]=34,szName="春泥护花",dwID=122},
["7"]={nLevel=7,[2]=45,[4]=3,szDesc="使其受到伤害降低45%，被攻击则消耗一层，每消耗一层则回复3%气血值",[3]=45,[1]=45,szName="春泥护花",dwID=122},
["6"]={nLevel=6,[2]=38,[4]=3,szDesc="使其受到伤害降低38%，被攻击则消耗一层，每消耗一层则回复3%气血值",[3]=38,[1]=38,szName="春泥护花",dwID=122}},
[9696]={
["1"]={nLevel=1,[2]=80,szDesc="受到的伤害降低80%",[3]=80,[1]=80,szName="清绝影歌",dwID=9696}},
[4444]={
["1"]={nLevel=1,[2]=0,szDesc="受到的伤害降低80%",[3]=0,[1]=0,szName="贪魔体",dwID=4444}},
[3068]={
["1"]={nLevel=1,[2]=25,szDesc="受到的伤害降低25%，“女娲补天”的减速效果降低到35%，招式内力消耗降低15%",[3]=25,[1]=25,szName="雾体",dwID=3068},
["4"]={nLevel=4,[2]=50,szDesc="受到的伤害降低50%，“女娲补天”的减速效果降低到20%，招式内力消耗降低30%",[3]=50,[1]=50,szName="雾体",dwID=3068},
["2"]={nLevel=2,[2]=50,szDesc="受到的伤害降低50%，“女娲补天”的减速效果降低到20%，招式内力消耗降低15%",[3]=50,[1]=50,szName="雾体",dwID=3068}},
[134]={
["1"]={nLevel=1,[2]=30,szDesc="化解自身受到的伤害，根骨越高，化解量越大",[3]=30,[1]=30,szName="坐忘无我",dwID=134}},
[6224]={
["1"]={nLevel=1,[2]=30,szDesc="化解伤害",[3]=30,[1]=30,szName="枭泣",dwID=6224}},
[9919]={
["1"]={nLevel=1,[2]=0,[4]=3,szDesc="吸收自身下一次受到的攻击伤害，最多不超过自身气血最大值20%",[3]=0,[1]=0,szName="心火叹",dwID=9919}},
[6279]={
["1"]={nLevel=1,[2]=40,szDesc="受到伤害减少40%，不受移动限制（被拉除外）",[3]=40,[1]=40,szName="贪魔体",dwID=6279}},
[6125]={
["1"]={nLevel=1,[2]=0,szDesc="“突”还可以再施展一次",[3]=0,[1]=0,szName="长征",dwID=6125}},
[6636]={
["1"]={nLevel=1,[2]=45,szDesc="受到伤害降低45%",[3]=45,[1]=45,szName="圣手织天",dwID=6636},
["2"]={nLevel=2,[2]=45,szDesc="受到伤害降低55%",[3]=45,[1]=45,szName="圣手织天",dwID=6636}},
[6637]={
["1"]={nLevel=1,[2]=45,szDesc="受到伤害降低45%",[3]=45,[1]=45,szName="圣手织天",dwID=6637},
["2"]={nLevel=2,[2]=55,szDesc="受到伤害降低55%",[3]=45,[1]=55,szName="圣手织天",dwID=6637}},
[1177]={
["1"]={nLevel=1,[2]=30,szDesc="化解受到的伤害<BUFF atGlobalDamageAbsorb>点",[3]=30,[1]=30,szName="护体",dwID=1177}},
[10369]={
["1"]={nLevel=1,[2]=3,szDesc="每层减少所受伤害的3%",[3]=3,[1]=3,szName="守如山",dwID=10369}},
[13771]={
["1"]={nLevel=1,[2]=100,szDesc="海雕承担受到的伤害",[3]=100,[1]=100,szName="疾电叱羽",dwID=13771}},
[6616]={
["1"]={nLevel=1,[2]=99,szDesc="受到的伤害降低99%",[3]=99,[1]=99,szName="盾壁",dwID=6616}},
[11344]={
["1"]={nLevel=1,[2]=10,szDesc="每层减伤10%",[3]=10,[1]=10,szName="上将军印",dwID=11344}},
[6240]={
["1"]={nLevel=1,[2]=40,szDesc="使自身受到的伤害降低40%",[3]=40,[1]=40,szName="玄水蛊",dwID=6240}},
[9803]={
["1"]={nLevel=1,[2]=40,szDesc="受到的伤害降低40%",[3]=40,[1]=40,szName="无相诀",dwID=9803},
["4"]={nLevel=4,[2]=55,szDesc="受到的伤害降低55%",[3]=55,[1]=55,szName="无相诀",dwID=9803},
["3"]={nLevel=3,[2]=50,szDesc="受到的伤害降低50%",[3]=50,[1]=50,szName="无相诀",dwID=9803},
["2"]={nLevel=2,[2]=45,szDesc="受到的伤害降低45%",[3]=45,[1]=45,szName="无相诀",dwID=9803}},
--[996]={
--["1"]={nLevel=1,[2]=0,szDesc="移动速度降低50%",[3]=0,[1]=0,szName="无相诀",dwID=996},
--["2"]={nLevel=2,[2]=0,szDesc="移动速度降低10%",[3]=0,[1]=0,szName="无相诀",dwID=996}},
[18001]={
["1"]={nLevel=1,[2]=50,szDesc="免疫无法施展招式效果，受到伤害降低50%",[3]=50,[1]=50,szName="飞来",dwID=18001}},
[8495]={
["1"]={nLevel=1,[2]=40,szDesc="受到的伤害降低40%",[3]=40,[1]=40,szName="捍卫",dwID=8495}},
--[9694]={
--["1"]={nLevel=1,[2]=0,szDesc="受到治疗效果降低40%",[3]=0,[1]=0,szName="清绝影歌",dwID=9694}},
[5374]={
["1"]={nLevel=1,[2]=30*0.08,szDesc="防御提高20%，反弹30%的远程伤害",[3]=20*0.08,[1]=20*0.08,szName="盾墙",dwID=5374}},
[1547]={
["1"]={nLevel=1,[2]=100,szDesc="免疫一切伤害",[3]=100,[1]=100,szName="御",dwID=1547}},
[367]={
["1"]={nLevel=1,[2]=80,szDesc="受到的伤害降低80%",[3]=80,[1]=80,szName="守如山",dwID=367}},
[8427]={
["1"]={nLevel=1,[2]=50,szDesc="受到的伤害降低50%",[3]=50,[1]=50,szName="荣辉",dwID=8427}},
[9293]={
["1"]={nLevel=1,[2]=50,szDesc="受到所有伤害降低50%",[3]=50,[1]=50,szName="残影",dwID=9293}},
[9775]={
["1"]={nLevel=1,[2]=40,szDesc="化解受到的伤害40%",[3]=40,[1]=40,szName="天地低昂",dwID=9775}},
[2953]={
["1"]={nLevel=1,[2]=45,szDesc="受到的伤害降低45%",[3]=45,[1]=45,szName="圣手织天",dwID=2953},
["2"]={nLevel=2,[2]=55,szDesc="受到的伤害降低55%",[3]=55,[1]=55,szName="圣手织天",dwID=2953}},
[8650]={
["1"]={nLevel=1,[2]=30,szDesc="使自身受到的伤害降低30%",[3]=30,[1]=30,szName="盾墙",dwID=8650}},
[14105]={
["1"]={nLevel=1,[2]=80,szDesc="受到的伤害降低80%，并免疫控制效果",[3]=80,[1]=80,szName="定波砥澜",dwID=14105}},
-- [9534]={
-- ["1"]={nLevel=1,[2]=100,szDesc="被相如剑牢所困，打破剑牢解除",[3]=100,[1]=100,szName="青冥缚",dwID=9534},
-- ["3"]={nLevel=3,[2]=100,szDesc="被飞花蝶舞所困",[3]=100,[1]=100,szName="飞花缠足",dwID=9534},
-- ["2"]={nLevel=2,[2]=100,szDesc="被剑气锁足",[3]=100,[1]=100,szName="青冥锁",dwID=9534}},
[360]={
["1"]={nLevel=1,[2]=100,szDesc="每层化解一次伤害",[3]=100,[1]=100,szName="御",dwID=360}},
[4439]={
["1"]={nLevel=1,[2]=80,szDesc="受到的伤害降低<BUFF_EX 1024 atGlobalResistPercent>%，不受移动限制（被拉除外）",[3]=80,[1]=80,szName="贪魔体",dwID=4439}},
[2805]={
["1"]={nLevel=1,[2]=20,szDesc="受到的内功伤害降低20%",[3]=0,[1]=20,szName="玉骨",dwID=2805},
["2"]={nLevel=2,[2]=50,szDesc="受到的内功伤害降低50%",[3]=0,[1]=50,szName="玉骨",dwID=2805}},
[2251]={
["1"]={nLevel=1,szDesc="受到的伤害降低5%",[3]=50,dwID=2251,szName="春泥"}},

[9809]={
["1"]={nLevel=1,[2]=0,[5]=22.5,szDesc="反弹伤害22.5%，提高30%的破防等级，自身伤害40%转化为内力值，受到伤害有10%几率使自身回复5%气血最大值",[3]=0,[1]=0,szName="罗汉金身",dwID=9809},
["2"]={nLevel=2,[2]=0,[5]=0.5,[5]=15,szDesc="反弹伤害15%，提高30%的破防等级，自身伤害40%转化为内力值，自身体质的20%转换为阳性内功攻击，受到伤害有10%几率使自身回复5%气血最大值",[3]=0,[1]=0,szName="罗汉金身",dwID=9809}},
[11980]={
["1"]={nLevel=1,[2]=0,[5]=15,szDesc="伤害反弹15%，提高30%的破防等级，自身伤害40%转化为内力值且内功基础攻击提高30%，自身不受减速效果影响，受到伤害有15%几率使攻击者倒地3秒",[3]=0,[1]=0,szName="罗汉金身",dwID=11980}},
[388]={
["1"]={nLevel=1,[2]=0,[5]=13.3,szDesc="伤害反弹13.3%",[3]=0,[1]=0,szName="罗汉金身",dwID=388}},
[11981]={
["1"]={nLevel=1,[2]=0,[5]=22.5,szDesc="伤害反弹22.5%，提高30%的破防等级，自身伤害40%转化为内力值，内功基础攻击提高30%，受到伤害有10%几率使自身回复5%气血最大值",[3]=0,[1]=0,szName="罗汉金身",dwID=11981}},
[11979]={["1"]={nLevel=1,[2]=0,[5]=15,szDesc="伤害反弹15%，提高30%的破防等级，自身伤害40%转化为内力值且内功基础攻击提高30%，施展伤害招式有35%几率使自身下一个招式伤害提高30%，并顺势挥棍对自身前方6尺扇形区域最多6个敌对目标造成阳性内功伤害",[3]=0,[1]=0,szName="罗汉金身",dwID=11979}},
[2792]={
["1"]={nLevel=1,[2]=0,[5]=15.3,szDesc="伤害反弹15.3%",[3]=0,[1]=0,szName="罗汉金身",dwID=2792}},
[2794]={
["1"]={nLevel=1,[2]=0,[5]=46,szDesc="伤害反弹46%",[3]=0,[1]=0,szName="罗汉金身",dwID=2794}},
[2796]={
["1"]={nLevel=1,[2]=0,[5]=30,szDesc="伤害反弹30%",[3]=0,[1]=0,szName="罗汉金身",dwID=2796}},
[1152]={
["1"]={nLevel=1,[2]=0,[5]=50,szDesc="反弹自身受到伤害的50%",[3]=0,[1]=0,szName="罗汉金身",dwID=1152}},
[390]={
["1"]={nLevel=1,[2]=0,[5]=40,szDesc="伤害反弹40%",[3]=0,[1]=0,szName="罗汉金身",dwID=390}},
[389]={
["1"]={nLevel=1,[2]=0,[5]=26.7,szDesc="伤害反弹26.7%",[3]=0,[1]=0,szName="罗汉金身",dwID=389}},
[1561]={
["1"]={nLevel=1,[2]=0,[5]=100,szDesc="反弹自身受到的所有伤害",[3]=0,[1]=0,szName="罗汉金身",dwID=1561}},
[9806]={
["1"]={nLevel=1,[2]=0,[5]=15,szDesc="伤害反弹15%，提高30%的破防等级，伤害40%转化为内力值，自身不受减速效果影响，受到伤害有15%几率使攻击者倒地3秒",[3]=0,[1]=0,szName="罗汉金身",dwID=9806}},
[10486]={
["1"]={nLevel=1,[2]=0,[5]=70,szDesc="反弹受到的伤害70%",[3]=0,[1]=0,szName="无相诀",dwID=10486}},
[10493]={
["1"]={nLevel=1,[2]=5,[5]=70,szDesc="受到的伤害降低5%，反弹受到的70%伤害",[3]=5,[1]=5,szName="无相诀",dwID=10493}},
[9808]={
["1"]={nLevel=1,[2]=0,[5]=45,szDesc="反弹伤害45%",[3]=0,[1]=0,szName="罗汉金身",dwID=9808}},
[3198]={
["1"]={nLevel=1,[2]=0,[5]=200,szDesc="反弹所受到伤害200%",[3]=0,[1]=0,szName="罗汉金身",dwID=3198}},
[9807]={
["1"]={nLevel=1,[2]=0,[5]=30,szDesc="反弹伤害30%",[3]=0,[1]=0,szName="罗汉金身",dwID=9807}},
[9805]={
["1"]={nLevel=1,[2]=0,[5]=30,szDesc="伤害反弹30%，被击有10%几率使目标倒地3秒，有30%几率解除控制效果",[3]=0,[1]=0,szName="罗汉金身",dwID=9805}},
[2793]={
["1"]={nLevel=1,[2]=0,[5]=30.7,szDesc="伤害反弹30.7%",[3]=0,[1]=0,szName="罗汉金身",dwID=2793}},
[2795]={
["1"]={nLevel=1,[2]=0,[5]=20,szDesc="伤害反弹20%",[3]=0,[1]=0,szName="罗汉金身",dwID=2795}},
[2797]={
["1"]={nLevel=1,[2]=0,[5]=15,szDesc="伤害反弹15%，提高30%的破防等级，自身伤害40%转化为内力值",[3]=0,[1]=0,szName="罗汉金身",dwID=2797}},
-- [1261]={
-- ["1"]={nLevel=1,[2]=0,szDesc="经脉受损，气血最大值降低50%",[3]=0,[1]=0,szName="经错脉乱",dwID=1261}},
[9804]={
["1"]={nLevel=1,[2]=0,[5]=20,szDesc="伤害反弹20%，被击有10%几率使目标倒地3秒，有20%几率解除控制效果",[3]=0,[1]=0,szName="罗汉金身",dwID=9804}},
[13744]={
["1"]={nLevel=1,[2]=0,[5]=50,szDesc="受到攻击则可释放反击技能",[3]=0,[1]=0,szName="定波砥澜反击",dwID=13744}},
[2778]={
["1"]={nLevel=1,[2]=100,szDesc="承担100%伤害",[3]=100,[1]=100,szName="渊",dwID=2778}},
[1242]={
["1"]={nLevel=1,[2]=100,szDesc="承担100%伤害",[3]=100,[1]=100,szName="舍身",dwID=1242},
["2"]={nLevel=2,[2]=100,szDesc="承担100%伤害，每3秒解除阳性、阴性、混元、毒性不利效果各2个",[3]=100,[1]=100,szName="舍身",dwID=1242}},


--茗伊插件
[15948]={
["1"]={nLevel=1,[2]=0,[4]=60,szDesc="化解自身最大气血值60%的伤害",[3]=0,[1]=0,szName="气略",dwID=15948}},
[9933]={
["1"]={nLevel=1,[2]=30,[4]=25,szDesc="受到治疗效果提高45%，受到伤害降低30%，正常结束回复目标25%气血，可通过牺牲笼花效果使目标免于重伤并回复50%气血最大值",[3]=30,[1]=30,szName="笼花",dwID=9933}},
[17028]={
["1"]={nLevel=1,[2]=0,[4]=8,szDesc="化解自身最大气血值8%的伤害",[3]=0,[1]=0,szName="金戈",dwID=17028}},
[15919]={
["1"]={nLevel=1,[2]=50,szDesc="受到的伤害降低50%",[3]=50,[1]=50,szName="无相诀",dwID=15919},
["3"]={nLevel=3,[2]=60,szDesc="受到的伤害降低60%",[3]=60,[1]=60,szName="无相诀",dwID=15919},
["2"]={nLevel=2,[2]=55,szDesc="受到的伤害降低55%",[3]=55,[1]=55,szName="无相诀",dwID=15919},
["5"]={nLevel=5,[2]=70,szDesc="受到的伤害降低70%",[3]=70,[1]=70,szName="无相诀",dwID=15919},
["4"]={nLevel=4,[2]=65,szDesc="受到的伤害降低65%",[3]=65,[1]=65,szName="无相诀",dwID=15919},
["7"]={nLevel=7,[2]=80,szDesc="受到的伤害降低80%",[3]=80,[1]=80,szName="无相诀",dwID=15919},
["6"]={nLevel=6,[2]=75,szDesc="受到的伤害降低75%",[3]=75,[1]=75,szName="无相诀",dwID=15919},
["9"]={nLevel=9,[2]=90,szDesc="受到的伤害降低90%",[3]=90,[1]=90,szName="无相诀",dwID=15919},
["8"]={nLevel=8,[2]=85,szDesc="受到的伤害降低85%",[3]=85,[1]=85,szName="无相诀",dwID=15919},
["11"]={nLevel=11,[2]=90,szDesc="受到的伤害降低90%",[3]=90,[1]=90,szName="无相诀",dwID=15919},
["10"]={nLevel=10,[2]=90,szDesc="受到的伤害降低90%",[3]=90,[1]=90,szName="无相诀",dwID=15919}},
[9336]={
["1"]={nLevel=1,[2]=30,szDesc="使自身受到的下一次技能伤害降低30%",[3]=30,[1]=30,szName="寒梅",dwID=9336},
["2"]={nLevel=2,[2]=30,szDesc="使自身受到治疗效果提升30%，受到的下一次技能伤害降低30%",[3]=30,[1]=30,szName="寒梅",dwID=9336}},
[17094]={
["1"]={nLevel=1,[2]=0,[4]=20,szDesc="化解20%气血最大值伤害",[3]=0,[1]=0,szName="鸿轨",dwID=17094}},
[11920]={
["1"]={nLevel=1,[2]=28,szDesc="受到伤害降低28%",[3]=28,[1]=28,szName="春泥护花",dwID=11920},
["3"]={nLevel=3,[2]=32,szDesc="受到伤害降低32%",[3]=32,[1]=32,szName="春泥护花",dwID=11920},
["2"]={nLevel=2,[2]=30,szDesc="受到伤害降低30%",[3]=30,[1]=30,szName="春泥护花",dwID=11920},
["5"]={nLevel=5,[2]=36,szDesc="受到伤害降低36%",[3]=36,[1]=36,szName="春泥护花",dwID=11920},
["4"]={nLevel=4,[2]=34,szDesc="受到伤害降低34%",[3]=34,[1]=34,szName="春泥护花",dwID=11920},
["7"]={nLevel=7,[2]=45,szDesc="受到伤害降低45%",[3]=45,[1]=45,szName="春泥护花",dwID=11920},
["6"]={nLevel=6,[2]=38,szDesc="受到伤害降低38%",[3]=38,[1]=38,szName="春泥护花",dwID=11920},
["9"]={nLevel=9,[2]=45,szDesc="受到伤害降低45%",[3]=45,[1]=45,szName="春泥护花",dwID=11920},
["8"]={nLevel=8,[2]=43,szDesc="受到伤害降低43%",[3]=43,[1]=43,szName="春泥护花",dwID=11920},
["15"]={nLevel=15,[2]=0,szDesc="每层提高加速率5%，效果期间运功不会被打断，不受无法施展内功招式效果影响",[3]=0,[1]=0,szName="春泥护花",dwID=11920},
["14"]={nLevel=14,[2]=60,szDesc="受到伤害降低60%",[3]=60,[1]=60,szName="春泥护花",dwID=11920},
["13"]={nLevel=13,[2]=53,szDesc="受到伤害降低53%",[3]=53,[1]=53,szName="春泥护花",dwID=11920},
["12"]={nLevel=12,[2]=51,szDesc="受到伤害降低51%",[3]=51,[1]=51,szName="春泥护花",dwID=11920},
["11"]={nLevel=11,[2]=49,szDesc="受到伤害降低49%",[3]=49,[1]=49,szName="春泥护花",dwID=11920},
["10"]={nLevel=10,[2]=47,szDesc="受到伤害降低47%",[3]=47,[1]=47,szName="春泥护花",dwID=11920}},
[6434]={
["1"]={nLevel=1,[2]=0,szDesc="闪躲提高60%，外功攻击提高20%",[3]=60,[1]=0,szName="醉逍遥",dwID=6434}},
[10000]={
["1"]={nLevel=1,[2]=15,szDesc="每层使自身受到的伤害降低15%",[3]=15,[1]=15,szName="盏萤",dwID=10000}},
[11607]={
["1"]={nLevel=1,[2]=10,szDesc="伤害提升10%，受到伤害降低10%，每秒恢复5%的气血最大值",[3]=10,[1]=10,szName="战意",dwID=11607}},
[8867]={
["1"]={nLevel=1,[2]=25,szDesc="化解自身受到的伤害，身法越高，化解量越大",[3]=25,[1]=25,szName="坐忘无我",dwID=8867}},
[6120]={
["1"]={nLevel=1,[2]=25,szDesc="受到伤害降低25%",[3]=25,[1]=25,szName="百折",dwID=6120}},
[8868]={
["1"]={nLevel=1,[2]=25,szDesc="化解自身受到的伤害，身法越高，化解量越大",[3]=25,[1]=25,szName="坐忘无我",dwID=8868}},
[11201]={
["1"]={nLevel=1,[2]=0,szDesc="闪避提高100%",[3]=100,[1]=0,szName="流影",dwID=11201}},
[16730]={
["1"]={nLevel=1,[2]=50,szDesc="化解自身受到的伤害且伤害降低50%，身法越高，化解量越大",[3]=50,[1]=50,szName="坐忘无我",dwID=16730}},
[12558]={
["1"]={nLevel=1,[2]=100,szDesc="受到的伤害由“吞日月”承担",[3]=100,[1]=100,szName="合真",dwID=12558}},
--[5777]={
--["1"]={nLevel=1,[2]=0,szDesc="免疫缴械和无法运功效果",[3]=0,[1]=0,szName="圣手织天",dwID=5777}},
[8245]={
["1"]={nLevel=1,[2]=10*0.08,szDesc="使自身外功基础防御等级提高10%，内功基础防御等级提高10%，招式威胁值提高20%",[3]=10*0.08,[1]=10*0.08,szName="血怒",dwID=8245},
["3"]={nLevel=3,[2]=6*0.08,szDesc="使自身内外功防御等级提高6%，内功基础防御等级提高10%，招式威胁值提高20%",[3]=10*0.08,[1]=6*0.08,szName="血怒",dwID=8245},
["2"]={nLevel=2,[2]=4*0.08,szDesc="使自身内外功防御等级提高4%，内功基础防御等级提高10%，招式威胁值提高20%",[3]=10*0.08,[1]=4*0.08,szName="血怒",dwID=8245},
["5"]={nLevel=5,[2]=10*0.08,szDesc="使自身内外功防御等级提高10%，内功基础防御等级提高10%，招式威胁值提高20%",[3]=10*0.08,[1]=10*0.08,szName="血怒",dwID=8245},
["4"]={nLevel=4,[2]=8*0.08,szDesc="使自身内外功防御等级提高8%，内功基础防御等级提高10%，招式威胁值提高20%",[3]=8*0.08,[1]=8*0.08,szName="血怒",dwID=8245}},
[17990]={
["1"]={nLevel=1,[2]=0,[4]=20,szDesc="化解自身最大气血值20%的伤害",[3]=0,[1]=0,szName="茧灵",dwID=17990}},
[5668]={
["1"]={nLevel=1,[2]=0,szDesc="闪避几率提高60%",[3]=60,[1]=0,szName="风吹荷",dwID=5668}},
[18039]={
["1"]={nLevel=1,[2]=30,szDesc="受到的伤害降低30%",[3]=30,[1]=30,szName="龙马出河",dwID=18039}},
[2315]={
["1"]={nLevel=1,[2]=35,szDesc="基础疗伤成效提高50%，造成的威胁降低30%，免疫锁足、减速效果，移动速度降低20%，受到伤害降低35%，招式消耗降低30%，运功不会被伤害打退，可以与其他减伤效果叠加",[3]=35,[1]=35,szName="女娲补天",dwID=2315},
["3"]={nLevel=3,[2]=35,szDesc="基础疗伤成效提高100%，造成的威胁降低30%，免疫锁足、减速效果，受到伤害降低35%，招式消耗降低30%，运功不会被伤害打退，可以与其他减伤效果叠加",[3]=35,[1]=35,szName="女娲补天",dwID=2315},
["2"]={nLevel=2,[2]=35,szDesc="基础疗伤成效提高100%，造成的威胁降低30%，免疫锁足、减速效果，受到伤害降低35%，招式消耗降低30%，运功不会被伤害打退，可以与其他减伤效果叠加",[3]=35,[1]=35,szName="女娲补天",dwID=2315}},
[3214]={
["1"]={nLevel=1,[2]=45,szDesc="躲闪几率提高65%，受到内功伤害降低45%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214},
["3"]={nLevel=3,[2]=45,szDesc="躲闪几率提高45%，受到内功伤害降低45%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214},
["2"]={nLevel=2,[2]=45,szDesc="躲闪几率提高45%，受到内功伤害降低45%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214},
["5"]={nLevel=5,[2]=45,szDesc="躲闪几率提高55%，受到内功伤害降低45%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214},
["4"]={nLevel=4,[2]=45,szDesc="躲闪几率提高45%，受到内功伤害降低45%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214},
["7"]={nLevel=7,[2]=45,szDesc="躲闪几率提高55%，受到内功伤害降低45%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214},
["9"]={nLevel=9,[2]=45,szDesc="躲闪几率提高45%，受到内功伤害降低45%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214},
["12"]={nLevel=12,[2]=45,szDesc="躲闪几率提高80%，受到内功伤害降低60%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214},
["11"]={nLevel=11,[2]=45,szDesc="躲闪几率提高45%，受到内功伤害降低45%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214},
["10"]={nLevel=10,[2]=45,szDesc="躲闪几率提高45%，受到内功伤害降低45%",[3]=65,[1]=45,szName="惊鸿游龙",dwID=3214}},
-- [15494]={
-- ["1"]={nLevel=1,[2]=0,szDesc="增加大量气血上限，伤害和治疗结果增加10%，化劲增加350，御劲增加200，每秒回复2%最大气血值",[3]=0,[1]=0,szName="战意",dwID=15494},
-- ["2"]={nLevel=2,[2]=0,szDesc="增加大量气血上限，伤害和治疗结果增加15%，化劲增加700，御劲增加400，每秒回复2%最大气血值",[3]=0,[1]=0,szName="战意",dwID=15494}},
[6174]={
["1"]={nLevel=1,[2]=0,szDesc="闪避几率提高40%",[3]=40,[1]=0,szName="两生",dwID=6174}},
-- [15495]={
-- ["1"]={nLevel=1,[2]=0,szDesc="该首领内力正盛，不会受到伤害。且向其靠近的本阵营侠士将获得战意状态",[3]=0,[1]=0,szName="战意",dwID=15495}},
-- [3202]={
-- ["1"]={nLevel=1,[2]=0,szDesc="每2秒受到<BUFF atCallPhysicsDamage>点外功伤害",[3]=0,[1]=0,szName="逐星",dwID=3202}},
-- [16750]={
-- ["1"]={nLevel=1,[2]=0,szDesc="厌夜原地持鞭旋转并反弹部分伤害",[3]=0,[1]=0,szName="斩无常",dwID=16750}},
[12580]={
["1"]={nLevel=1,[2]=25,szDesc="受到的伤害降低25%",[3]=25,[1]=25,szName="逐星",dwID=12580}},
[6143]={
["1"]={nLevel=1,[2]=0,szDesc="闪避几率提高15%且每点身法化解56.25点伤害，化解量随时间衰减",[3]=15,[1]=0,szName="泉凝月",dwID=6143}},
[6299]={
["1"]={nLevel=1,[2]=0,szDesc="施展招式不产生威胁值，闪避几率提高50%",[3]=50,[1]=0,szName="御风而行",dwID=6299},
["2"]={nLevel=2,[2]=0,szDesc="施展招式不产生威胁值，闪避几率提高65%",[3]=65,[1]=0,szName="御风而行",dwID=6299}},
[12411]={
["1"]={nLevel=1,[2]=10,szDesc="自身受到伤害降低10%,且使击破该效果的目标获得破绽效果",[3]=10,[1]=10,szName="乘龙戏水",dwID=12411}},
[10617]={
["1"]={nLevel=1,[2]=0,szDesc="每层使自身闪避几率提高10%",[3]=10,[1]=0,szName="雾雨",dwID=10617}},
-- [3215]={
-- ["1"]={nLevel=1,[2]=0,szDesc="外功命中降低45%",[3]=0,[1]=0,szName="荆天棘地",dwID=3215}},
-- [13074]={
-- ["1"]={nLevel=1,[2]=0,szDesc="击伤敌人可使自己每秒回复气血值，持续30秒，不可叠加",[3]=0,[1]=0,szName="战意",dwID=13074}},
[9830]={
["1"]={nLevel=1,[2]=99,szDesc="受到伤害的99%转移给少林",[3]=99,[1]=99,szName="舍生",dwID=9830}},
-- [14965]={
-- ["1"]={nLevel=1,[2]=0,szDesc="锁足",[3]=0,[1]=0,szName="盏萤",dwID=14965}},
[2065]={
["1"]={nLevel=1,[2]=0,szDesc="闪躲几率提高50%",[3]=50,[1]=0,szName="云栖松",dwID=2065},
["2"]={nLevel=2,[2]=0,szDesc="闪躲几率提高75%",[3]=75,[1]=0,szName="云栖松",dwID=2065}},
[18084]={
["1"]={nLevel=1,[2]=100,szDesc="抵挡下一次受到的伤害,且使击破该效果的目标获得破绽效果",[3]=100,[1]=100,szName="乘龙戏水",dwID=18084}},
[9265]={
["1"]={nLevel=1,[2]=50,szDesc="与持有该效果的小队成员相互平摊伤害和治疗效果",[3]=50,[1]=50,szName="云生结海",dwID=9265}},
[9171]={
["1"]={nLevel=1,[2]=40,szDesc="受到的内功伤害降低40%",[3]=0,[1]=40,szName="玄德",dwID=9171}},
[18148]={
["1"]={nLevel=1,[2]=0,[4]=8,szDesc="化解自身8%最大气血值的伤害",[3]=0,[1]=0,szName="掠关",dwID=18148}},
[18088]={
["1"]={nLevel=1,[2]=0,szDesc="闪避几率提高45%",[3]=45,[1]=0,szName="共醉",dwID=18088}},
[17997]={
["1"]={nLevel=1,[2]=0,[4]=30,szDesc="化解自身最大气血值30%的伤害",[3]=0,[1]=0,szName="延年",dwID=17997}},
[17092]={
["1"]={nLevel=1,[2]=0,szDesc="被物化天行命中标记",[3]=0,[1]=0,szName="鸿轨",dwID=17092},
["2"]={nLevel=2,[2]=0,[4]=20,szDesc="化解20%气血最大值伤害",[3]=0,[1]=0,szName="鸿轨",dwID=17092}},
[14637]={
["1"]={nLevel=1,[2]=40,[5]=40,szDesc="携带玄水蛊术的目标为自身承担40%受到的伤害",[3]=40,[1]=40,szName="玄水蛊",dwID=14637},
["3"]={nLevel=3,[2]=55,[5]=55,szDesc="携带玄水蛊术的目标为自身承担55%受到的伤害",[3]=55,[1]=55,szName="玄水蛊",dwID=14637},
["2"]={nLevel=2,[2]=70,[5]=70,szDesc="宠物承担主人70%受到的伤害",[3]=70,[1]=70,szName="玄水蛊",dwID=14637}},
-- [8253]={
-- ["1"]={nLevel=1,[2]=0,szDesc="使自身化解相当于自身拆招值的伤害量",[3]=0,[1]=0,szName="雄峦",dwID=8253}},
[2542]={
["1"]={nLevel=1,[2]=0,[4]=15,szDesc="化解伤害",[3]=0,[1]=0,szName="玉蟾献祭",dwID=2542}},
[12361]={
["1"]={nLevel=1,[2]=50,szDesc="与释放者相互平摊伤害和治疗效果",[3]=50,[1]=50,szName="棠梨",dwID=12361}},
-- [1686]={
-- ["1"]={nLevel=1,[2]=0,szDesc="每秒发动一次攻击",[3]=0,[1]=0,szName="梦泉虎跑",dwID=1686}}

}


tb111 = {
"9830|9933|12558|6301|9919|4244|2542|6224|6143|5735|1686|1802|8279|8291|8253|15494|8292|11607|13074|15495|8245|9334|12361|9265|10000|14965|9293|2315|14637|3447|6240|5777|2953|6637|6636|8839|9874|9544|2849|2848|6262|11920|6257|6264|122|9724|367|6163|9073|384|6200|12411|12530|18084|7119|9803|10486|399|15919|10493|13044|684|11344|13571|9336|9171|2805|6120|15948|15735|16750|16730|8868|134|2983|8867|10066|17028|17092|17094|17961|17959|17997|17990|18148|18039|19222|3215|10617|6299|12580|3202|6174|3214|2065|5668|6434|11201|9736|18071|18088"
}


ZgetTb = function(szContent,Path)
	local m0 = _ZMAC_SplitStr2Array(szContent,'|')
	local m1 = {}
	for k,v in pairs(m0) do
		if m1[tonumber(v)]==nil and _ZMAC.ReductionList[tonumber(v)]==nil then
			
			for i = 1,100,1 do
				local name = Table_GetBuffName(tonumber(v),i)
				local desc = Table_GetBuffDesc(tonumber(v),i)
				if name~='' and desc~='' then
					if i ==1 then
						m1[tonumber(v)] = {}
					end
					
					local a,b,c = 0,0,0
					-- if _ZMAC.ReductionListBack[tonumber(v)] then
						-- --if tonumber(v)==9736 then Output(_ZMAC.ReductionList[tonumber(v)][1],_ZMAC.ReductionList[tonumber(v)][2],_ZMAC.ReductionList[tonumber(v)][3],_ZMAC.ReductionList[tonumber(v)]) end
						-- a= _ZMAC.ReductionListBack[tonumber(v)][1]
						-- b= _ZMAC.ReductionListBack[tonumber(v)][2]
						-- c= _ZMAC.ReductionListBack[tonumber(v)][3]
					-- end
					
					if i==1 then
						m1[tonumber(v)][tostring(i)] = { [1]=a, [2]=b, [3]=c, dwID=tonumber(v), szName=name, szDesc=desc , nLevel = i}
					elseif i>1 and m1[tonumber(v)]['1']~=nil    then
						if desc ~= m1[tonumber(v)]['1'].szDesc then
							m1[tonumber(v)][tostring(i)] = { [1]=a, [2]=b, [3]=c, dwID=tonumber(v), szName=name, szDesc=desc , nLevel = i}
						end
					end
					
				end
			end

		end
	end
	
	--table.sort(m1, function(a,b) return a.dwID < b.dwID end)
	local path2 = ''
	if Path ==nil then path2 ="E:/JX3/Game/JX3/bin/zhcn_hd/interface/m1.lua" else path2 = Path end
	Output(m1)
	SaveDataToFile(EncodeData(var2str(m1),true,false),path2)
	return m1
end



_ZMAC.GetReduction = function(pTar)
	if not pTar then return 1 end
	local BuffList = GetAllBuff(pTar)
	local nReductionPercent = 0
	local nReductionPercent1 = 0 --内功减伤
	local nReductionPercent2 = 0 --外功减伤
	
	local nReductionType = 1

	if ZMAC_OptionFunc.stats('内功')  then
		nReductionType =2
	elseif ZMAC_OptionFunc.stats('外功') then
		nReductionType =3
	end
	
	local MaxLifeUp = 0  --抵挡伤害，化解的气血百分比
	local Fantan = 0
	
	for i = 1, #BuffList, 1 do
		
		local buffid,bufflv,stack = BuffList[i].dwID ,BuffList[i].nLevel ,BuffList[i].nStackNum
		buffid = tonumber(buffid)
		bufflv = tostring(bufflv)
		stack = tonumber(stack)
		local stack1 = stack --减伤stack
		local stack2 = stack --气血stack
		
		if buffid == 1552 or buffid == 3120 or buffid == 6257 or buffid == 6264 or buffid == 3171 or buffid == 122 or buffid == 11920 then --春泥
			stack1 =1 
		end  
		if _ZMAC.ReductionList[buffid] then 
			if not _ZMAC.ReductionList[buffid][bufflv] and bufflv~= '1' then
				bufflv = '1'
			end
			if _ZMAC.ReductionList[buffid][bufflv][nReductionType] then
				--if _ZMAC.ReductionList[buffid][bufflv][nReductionType]> nReductionPercent then
				nReductionPercent = nReductionPercent + _ZMAC.ReductionList[buffid][bufflv][nReductionType]*stack1
				--end
			end
			if _ZMAC.ReductionList[buffid][bufflv][2] then --内功减伤
				nReductionPercent1 = nReductionPercent1 + _ZMAC.ReductionList[buffid][bufflv][2]*stack1
			end
			if _ZMAC.ReductionList[buffid][bufflv][3] then --外功减伤
				nReductionPercent2 = nReductionPercent2+ _ZMAC.ReductionList[buffid][bufflv][3]*stack1
			end
			if _ZMAC.ReductionList[buffid][bufflv][4] then  --化解气血百分比
				MaxLifeUp = MaxLifeUp + _ZMAC.ReductionList[buffid][bufflv][4]*stack2
			end
			if _ZMAC.ReductionList[buffid][bufflv][5] then  --反弹百分比
				Fantan = Fantan + _ZMAC.ReductionList[buffid][bufflv][5]*stack1
			end
			
		end
	end
	local upLife = pTar.nMaxLife * MaxLifeUp + pTar.nCurrentLife  --最大气血化解换算
	
	local nReuductionTmp =1 / ( 1 - nReductionPercent/100 )  --减伤系数换算
	local realLife = upLife * nReuductionTmp --真实血量
	local bb =( ( realLife-pTar.nCurrentLife) / realLife )  * 100   --最终减伤系数
	--Output(nReductionPercent1,nReductionPercent2)
	
	
	local nReuductionTmp2 =1 / ( 1 - (nReductionPercent1+ nReductionPercent2)/2/100 )  --减伤系数换算
	local realLife2 = upLife * nReuductionTmp2 --真实血量
	local aa =( ( realLife2-pTar.nCurrentLife) / realLife2 )  * 100   --最终减伤系数
	return bb/100,pTar.nCurrentLife/ (1-bb/100),nReductionPercent/100,MaxLifeUp/100,Fantan/100 ,aa/100--第3个为减伤系数，第4个为生命值化解百分比，第1个为综合系数，第2个为最终生命值换算,第五个为反弹系数,第六个为内外功平均减伤
end

--//Class Condition
local _ZMAC_OPtionDict = {
	['hdnum']='hdnum',
	['inhz']='inhz',
	['noinhz']='noinhz',
	['tinhz']='tinhz',
	['tnoinhz']='tnoinhz',
	['tlesshd']='tlesshd',
	['tnearhd']='tlesshd',
	
	['qijin']='qijin',
	['tqijin']='tqijin',
	['kyi'] = 'kyi',
	['tkyi'] = 'tkyi',
	['dhun'] = 'dhun',
	['tdhun'] = 'tdhun',
	['pose'] = 'pose',
	['tpose']='tpose',
	['test'] = 'test',
	['account'] = 'account',
	['noaccount'] = 'noaccount',
	['rtime'] = 'rtime',
	['life'] = 'life',     --血量百分比类
	['tlife'] = 'tlife',
	['ttlife'] = 'ttlife',
	['petlife']='petlife',

	['mana'] = 'mana',      --蓝量百分比类
	['tmana'] = 'tmana',
	['ttmana'] = 'ttmana',

	['rage'] = 'rage',       --苍云怒气、霸刀狂意、藏剑剑气、天策战意、衍天星运
	['nature']='nature',
	['tnature']='tnature',
	['warm']='warm',
	['twarm']='twarm',
	['cold']='cold',
	['tcold']='tcold',
	
	['kyi']='kyi',
	['trage'] = 'trage',
	['tkyi']='tkyi',
	['tm'] = 'tm',
	['energy'] = 'energy',      --刀魂、神机值
	['tenergy'] = 'tenergy',
	['qidian'] = 'qidian',       --禅那、气点、剑舞
	['tqidian'] = 'tqidian',
	['sun'] = 'sun',               --明教日灵、霸刀气劲
	['moon'] = 'moon',
	['fullsun'] = 'fullsun',
	['sun_power'] = 'sun_power',
	['fullmoon'] = 'fullmoon',
	['moon_power'] = 'moon_power',
	['nofullsun'] ='nofullsun',
	['nofullmoon'] = 'nofullmoon',
	['tsun'] = 'tsun',
	['tmoon'] = 'tmoon',
	['tfullsun'] = 'tfullsun',
	['tsun_power'] = 'tsun_power',
	['tfullmoon'] = 'tfullmoon',
	['tmoon_power'] = 'tmoon_power',
	['tnofullsun'] ='tnofullsun',
	['tnofullmoon'] = 'tnofullmoon',
	['moonlesssun']='moonlesssun',
	['moonlesseqsun']='moonlesseqsun',
	['sunlessmoon']='sunlessmoon',
	['sunlesseqmoon']='sunlesseqmoon',
	['suneqmoon']='suneqmoon',
	['mooneqsun']='suneqmoon',
	
	['combat'] = 'combat',
	['fight'] = 'fight',      --进战状态
	['petfight'] = 'petfight', 
	['nofight'] = 'nofight',
	['petnofight'] = 'petnofight', 
	['tfight'] = 'tfight',
	['tnofight'] = 'tnofight',
	['ttfight'] = 'ttfight',
	['ttnofight'] = 'ttnofight',
	['fighttime'] = 'fighttime',
	['horse'] = 'horse',      --骑御状态
	['nohorse'] = 'nohorse',
	['thorse'] = 'thorse',
	['tnohorse'] = 'tnohorse',
	['mount'] = 'mount',            --心法名称
	['tmount'] = 'tmount',
	['ttmount'] = 'ttmount',
	['nomount'] = 'nomount',
	['tnomount'] = 'tnomount',
	['ttnomount'] = 'ttnomount',
	['bufftime'] = 'bufftime',         --buff类
	['buffidtime'] = 'bufftime',
	['tbufftime'] = 'tbufftime',
	['tbuffidtime'] = 'tbufftime',
	['ttbufftime'] = 'ttbufftime',
	['ttbuffidtime'] = 'ttbufftime',
	['buff'] = 'buff',   
	['buffid'] = 'buff', 
	['tbuff'] = 'tbuff',
	['tbuffid'] = 'tbuff',
	['ttbuff'] = 'ttbuff',
	['ttbuffid'] = 'ttbuff',
	['nobuff'] = 'nobuff',
	['nobuffid'] = 'nobuff',
	['tnobuff'] = 'tnobuff',
	['tnobuffid'] = 'tnobuff',
	['ttnobuff'] = 'ttnobuff',
	['ttnobuffid'] = 'ttnobuff',
	['mbuff'] = 'mbuff',
	['mbuffid'] = 'mbuff',
	['nombuff'] = 'nombuff',
	['nombuffid'] = 'nombuff',
	['mbufftime'] = 'mbufftime',
	['mbuffidtime'] = 'mbufftime',
	['tmbuff']='tmbuff',
	['tmbuffid']='tmbuff',
	['tnombuff']='tnombuff',
	['tnombuffid']='tnombuff',
	['tmbufftime']='tmbufftime',
	['tmbuffidtime']='tmbufftime',
	['totherbuff']='totherbuff',
	['totherbuffid']='totherbuff',
	['tnootherbuff']='tnootherbuff',
	['tnootherbuffid']='tnootherbuff',
	['status'] = 'status',               --属性姿态
	['tstatus'] = 'tstatus',
	['ttstatus'] = 'ttstatus',
	['stats'] = 'stats',               --各自状态
	['tstats'] = 'tstats',
	['ttstats'] = 'ttstats',
	['nostats'] = 'nostats',               --各自状态
	['tnostats'] = 'tnostats',
	['ttnostats'] = 'ttnostats',
	['petstatus'] = 'petstatus',
	['nostatus'] = 'nostatus',
	['tnostatus'] = 'tnostatus',
	['ttnostatus'] = 'ttnostatus',
	['petnostatus'] = 'petnostatus',
	['line'] = 'line',                      --面向类
	['face'] = 'face',
	['range'] = 'range',
	['back'] = 'back',
	['norange'] = 'norange',
	['tline'] = 'tline',                      
	['tface'] = 'tface',
	['trange'] = 'trange',
	['tback'] = 'tback',
	['tnorange'] = 'tnorange',
	['bface']='bface',
	['tbface']='tbface',

	
	
	
	['otaction']='otaction',             --任意读条
	['nootaction']='nootaction',
	['totaction']='totaction',
	['tnootaction']='tnootaction',
	
	['prepare'] = 'prepare',              --正读条
	['preparename'] = 'prepare',
	['noprepare'] = 'noprepare',
	['tprepare'] = 'tprepare',
	['tpreparename'] = 'tprepare',
	['ttprepare'] = 'ttprepare',
	['tnoprepare'] = 'tnoprepare',
	['ttnoprepare'] = 'ttnoprepare',
	
	['channel']='channel',                      --逆读条
	['nochannel']='nochannel',
	['tchannel']='tchannel',
	['tnochannel']='tnochannel',
	--['channelskill']='prepare',
	['broken'] = 'broken',              --可打断
	['tbroken'] = 'tbroken',
	['nobroken'] = 'nobroken',
	['tnobroken'] = 'tnobroken',
	['tbrokenname'] = 'tbrokenname',
	['tbrokentime'] = 'tbrokentime',
	
	--['self'] = 'self',                --未知是啥
	['level'] = 'level',             --等级
	['bomb'] = 'bomb',                      --暗藏杀机
	['puppet'] = 'puppet',                  --机关
	['puppetdistance']='puppetdistance',
	['tpuppetdistance']='tpuppetdistance',
	['nopuppet'] = 'nopuppet',
	['pet'] = 'pet',                        --宠物
	['nopet'] = 'nopet',                    
	['jgnum'] = 'jgnum',                    --机关数量
	['pupdis']= 'pupdis',                   --千机变距离
	
	['enemynum']='enemynum',                   --玩家数量类
	['enemylookmenum']='enemylookmenum',
	['tenemynum']='tenemynum',
	['ttenemynum']='ttenemynum',
	['allynum']='allynum',
	['tallynum']='tallynum',
	['tpartynum']='tpartynum',
	['ttallynum']='ttallynum',
	['enemynpcnum'] = 'enemynpcnum',                  --NPC数量类
	['allynpcnum'] = 'allynpcnum',
	['partynum'] = 'partynum',
	['tenemynpcnum'] = 'tenemynpcnum',                  
	['tallynpcnum'] = 'tallynpcnum',
	
	['npcs']='npcs',                         --距离范围内npc是否存在类
	['nonpcs']='nonpcs',
	['mynpc']='mynpc',
	['nomynpc']='nomynpc',
	['tmynpc']='tmynpc',
	['tnomynpc']='tnomynpc',
	['allynpc']='allynpc',
	['noallynpc']='noallynpc',
	['tallynpc']='tallynpc',   
	['tnoallynpc']='tnoallynpc',
	['enemynpc']='enemynpc',
	['noenemynpc']='noenemynpc',
	['tenemynpc']='tenemynpc',
	['tnoenemynpc']='tnoenemynpc',
	
	['qcnum']='qcnum',
	['tqcnum']='tqcnum',
	['myqcnum']='myqcnum',
	['nomyqcnum']='nomyqcnum',
	['tmyqcnum']='tmyqcnum',
	['tnomyqcnum']='tnomyqcnum',
	['allyqcnum']='allyqcnum',
	['enemyqcnum']='enemyqcnum',
	['tallyqcnum']='tallyqcnum',
	['tenemyqcnum']='tenemyqcnum',
	
	--[[有bug待查
	['nonpcexist'] = 'nonpcexist',          
	['npcexistc'] = 'npcexist',
	['areanpccast'] = 'areanpccast',       --范围有怪物施展技能
	['npctalk'] = 'npctalk',                 --npc喊话
	['npclastcast'] = 'npclastcast',       --npc上次技能
	['npccasttime'] = 'npccasttime',              --npc释放技能间隔
	--]]
	
	['neutrality'] = 'neutrality',     --阵营关系--中立
	['tneutrality'] = 'tneutrality', 
	['ttneutrality '] = 'ttneutrality ',
	['ally'] = 'ally',             --同盟
	['tally'] = 'tally',
	['ttally'] = 'ttally',
	['enemy'] = 'enemy',             --敌对
	['tenemy'] = 'enemy',  
	['ttenemy'] = 'ttenemy',
	['isparty']='isparty',
	['tisparty']='tisparty',
	['ttisparty']='ttisparty',
	
	['tchoosetime'] = 'tchoosetime',
	
	['target'] = 'target',  --目标类型
	['ttarget'] = 'ttarget',
	['exists'] = 'exists',                 --目标是否存在
	['pettarget']='pettarget',             --宠物有无目标
	['texists'] = 'texists',
	['noexists'] = 'noexists',
	['petnotarget']='petnotarget',
	['tnoexists'] = 'tnoexists',
	['force'] = 'force',
	['tforce'] = 'tforce',--门派
	['ttforce'] = 'ttforce',
	['tnoforce'] = 'tnoforce',
	['ttnoforce'] = 'ttnoforce',
	['tname'] = 'tname',--目标名字
	['pettname']='pettname',
	['ttname'] = 'ttname',
	['tnoname'] = 'tnoname',
	['petnotname']='pettnoname',
	['ttnoname'] = 'ttnoname',
	['distance'] = 'tdistance',--距离
	['tdistance'] = 'tdistance',--距离
	['ttdistance'] = 'ttdistance',
	['distancenz'] = 'distancenz',
	['tbechasing'] = 'tbechasing',
	['tbechasingdistance'] = 'tbechasingdistance',
	['petdistance']='petdistance',
	['tpetdistance']='tpetdistance',
	
	['heightz'] = 'heightz',
	['tdistancenz'] = 'tdistancenz',
	
	['cd'] = 'cd',--CD类
	['nocd'] = 'nocd',
	['gcd']='gcd',
	['nogcd']='nogcd',
	['petcd'] = 'cd',--CD类
	['petnocd'] = 'nocd',
	['cdtime'] = 'cdtime',
	['num']='num',
	['mcast']='mcast',
	['tcast'] = 'tcast',
	['mhit']='mhit',
	['thit']='thit',
	
	['dead'] = 'dead',--死亡
	['nodead'] = 'nodead',
	['tdead'] = 'tdead',
	['tnodead'] = 'tnodead',
	['ttdead'] = 'ttdead',
	['ttnodead'] = 'ttnodead',
	['btype'] = 'btype',   --buff类型--外功、阳性、混元、阴性、毒性、蛊
	['tbtype'] = 'tbtype',   
	['ttbtype'] = 'ttbtype',
	['detype'] = 'detype',     --外功、阳性、混元、阴性、点穴、毒性、蛊
	['tdetype'] = 'tdetype',
	['ttdetype'] = 'ttdetype',
	['lastcast'] = 'lastcast',        --上一个技能
	['nolastcast'] = 'nolastcast',
	['preskill'] = 'lastcast',        --上一个技能
	['nopreskill'] = 'nolastcast',
	['haveskill'] = 'haveskill',
	['noskill'] = 'noskill',
	['thaveskill'] = 'thaveskill',
	['tnoskill'] = 'tnoskill',
	
	['miji']='miji',
	['tmiji']='tmiji',
	['nomiji']='nomiji',
	['tnomiji']='tnomiji',
	
	['mapname'] = 'mapname',
	['nomapname'] = 'nomapname',
	['mapid'] = 'mapid',
	['nomapid'] = 'nomapid',
	['player']='player',
	['noplayer']='noplayer',
	['tplayer']='player',
	['tnoplayer']='noplayer',
	
	['height']='height',
	['theight']='theight',
	['ttheight']='ttheight',
	['cancast'] = 'cancast',
	['nocancast'] = 'nocancast',
	['cannotcast'] = 'cannotcast',
	
	['fly']='fly',         --是否在轻功状态中
	['nofly']='nofly',
	
	['role']='role',         --体型
	['norole']='norole',
	['trole']='trole',
	['tnorole']='tnorole',
	['inallycfzy']='inallycfzy',
	
	['bmove']='bmove',        --丐帮霸刀僵直
	['tbmove'] = 'tbmove',
	
}

_ZMAC.checktarget = function(pTarget)
	local hPlayer = GetClientPlayer()
	
	if pTarget == 't' then
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tT, tID =hPlayer.GetTarget()
		if (not t) or  (tT ~= TARGET.PLAYER and tT ~= TARGET.NPC ) then return false end
		return t
	

	elseif pTarget == 'tt' then
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tT, tID =hPlayer.GetTarget()
		if (not t) or  (tT ~= TARGET.PLAYER and tT ~= TARGET.NPC ) then return false end
		local tt = GetTargetHandle(t.GetTarget())
		local ttT, ttID =t.GetTarget()
		if (not tt) or  (ttT ~= TARGET.PLAYER and ttT ~= TARGET.NPC ) then return false end
		return tt
	end
end




ZMAC_OptionFunc = {

	account = function(pAccount)
		local szAccount = GetUserAccount()
		return szAccount == pAccount
	end,
	
	noaccount = function(pAccount)
		local szAccount = GetUserAccount()
		return szAccount ~= pAccount
	end,
	
	rtime = function(pDate, cType)
		local pAAA = _ZMAC_SplitStr2Array(pDate,'-')
		local pYear ,pMonth,pDay,pHour,pMin,pSec = tonumber(pAAA[1]),tonumber(pAAA[2]),tonumber(pAAA[3]),tonumber(pAAA[4]),tonumber(pAAA[5]),tonumber(pAAA[6])
		
		local timelib = TimeToDate(GetCurrentTime())
		local nYear,nMonth,nDay,nHour,nMin,nSec = timelib['year'],timelib['month'],timelib['day'],timelib['hour'],timelib['minute'],timelib['second']
		
		local pTime11 = pYear*365 + pMonth*30 + pDay + pHour/24 + (pMin/24)/60 + (pSec/24)/360
		local nTime11 = nYear*365 + nMonth*30 + nDay + nHour/24 + (nMin/24)/60 + (nSec/24)/360
		return _ZMAC_Compare(cType, nTime11 , pTime11)
	end,

	bmove = function()
		return GetClientPlayer().nMoveState == 27        --丐帮/霸刀僵直
	end,
	
	tbmove=function()
		if _ZMAC.checktarget('t') then 
			local t = _ZMAC.checktarget('t')
			return t.nMoveState == 27        --丐帮/霸刀僵直
		else
			return false
		end
	end,

	life = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		local life_percent = _ZMAC.GetLifeValue(hPlayer, cNum)
		return _ZMAC_Compare(cType, life_percent, cNum)
	end,
	lifeval = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		--local life_percent = _ZMAC.GetLifeValue(hPlayer, cNum)
		local life_percent = hPlayer.nCurrentLife
		return _ZMAC_Compare(cType, life_percent, cNum)
	end,
	tlife = function(cNum, cType)
		if _ZMAC.checktarget('t') then 
			local t = _ZMAC.checktarget('t')
			local life_percent = _ZMAC.GetLifeValue(t, cNum)
			return _ZMAC_Compare(cType, life_percent, cNum)
		else
			return false
		end
	end,
	tlifeval = function(cNum, cType)
		if _ZMAC.checktarget('t') then 
			local t = _ZMAC.checktarget('t')
			--local life_percent = _ZMAC.GetLifeValue(t, cNum)
			local life_percent = t.nCurrentLife
			return _ZMAC_Compare(cType, life_percent, cNum)
		else
			return false
		end
	end,
	ttlife = function(cNum, cType)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		local life_percent = _ZMAC.GetLifeValue(tt, cNum)
		return _ZMAC_Compare(cType, life_percent, cNum)
	end,
	ttlife = function(cNum, cType)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		--local life_percent = _ZMAC.GetLifeValue(tt, cNum)
		local life_percent = tt.nCurrentLife
		return _ZMAC_Compare(cType, life_percent, cNum)
	end,
	
	petlife=function(cNum, cType)
		local hPlayer = GetClientPlayer()
		local hPet = hPlayer.GetPet()
		if not hPet then return end
		local pet_life_percent = _ZMAC.GetLifeValue(hPet, cNum)
		
		return _ZMAC_Compare(cType, pet_life_percent, cNum)
	end,
	
	mana = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		local mana_percent = _ZMAC.GetManaValue(hPlayer, cNum)
		return _ZMAC_Compare(cType, mana_percent, cNum)
	end,
	tmana = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local mana_percent = _ZMAC.GetManaValue(t, cNum)
		return _ZMAC_Compare(cType, mana_percent, cNum)
	end,
	ttmana = function(cNum, cType)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		local mana_percent = _ZMAC.GetManaValue(tt, cNum)
		return _ZMAC_Compare(cType, mana_percent, cNum)
	end,
	
	--苍云怒气、霸刀狂意、藏剑剑气、天策战意、衍天星运
	rage = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local Rage = hPlayer.nCurrentRage
		return _ZMAC_CompareEnergy(cType, Rage, cNum)
	end,
	kyi = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local Rage = hPlayer.nCurrentRage
		return _ZMAC_CompareEnergy(cType, Rage, cNum)
	end,
	
	trage = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Rage = t.nCurrentRage
		return _ZMAC_CompareEnergy(cType, Rage, cNum)
	end,
	tkyi = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Rage = t.nCurrentRage
		return _ZMAC_CompareEnergy(cType, Rage, cNum)
	end,
	--神机值
	tm = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local Energy= hPlayer.nCurrentEnergy
		return _ZMAC_Compare(cType, Energy, cNum)
	end,
	--刀魂、神机值
	energy = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local Energy= hPlayer.nCurrentEnergy
		return _ZMAC_CompareEnergy(cType, Energy, cNum)
	end,
	tenergy = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Energy = t.nCurrentEnergy
		return _ZMAC_CompareEnergy(cType, Energy, cNum)
	end,
	
	dhun = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local Energy= hPlayer.nCurrentEnergy
		return _ZMAC_CompareEnergy(cType, Energy, cNum)
	end,
	tdhun = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Energy = t.nCurrentEnergy
		return _ZMAC_CompareEnergy(cType, Energy, cNum)
	end,
	
	
	--北天药宗温寒性
	nature = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local Nature = hPlayer.nNaturePowerValue-100
		return _ZMAC_CompareEnergy(cType, Nature, cNum)
	end,
	tnature = function (cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Nature = t.nNaturePowerValue-100
		return _ZMAC_CompareEnergy(cType, Nature, cNum)
	end,
	
	--北天药宗温寒性
	warm = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local Nature = hPlayer.nNaturePowerValue -100
		if Nature<0 then 
			Nature = 0
		end
		return _ZMAC_CompareEnergy(cType, Nature, cNum)
	end,
	twarm = function (cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Nature = t.nNaturePowerValue -100
		if Nature<0 then 
			Nature = 0
		end
		return _ZMAC_CompareEnergy(cType, Nature, cNum)
	end,
	cold = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local Nature = hPlayer.nNaturePowerValue -100
		if Nature>0 then 
			Nature = 0
		end
		Nature = - Nature
		return _ZMAC_CompareEnergy(cType, Nature, cNum)
	end,
	tcold = function (cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Nature = t.nNaturePowerValue -100
		if Nature>0 then 
			Nature = 0
		end
		Nature = - Nature
		return _ZMAC_CompareEnergy(cType, Nature, cNum)
	end,
	
	--
	qidian = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local AccumulateValue = _ZMAC.GetValue(hPlayer)
		return _ZMAC_Compare(cType, AccumulateValue, cNum)
	end,
	tqidian = function (cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local AccumulateValue = _ZMAC.GetValue(t)
		return _ZMAC_Compare(cType, AccumulateValue, cNum)
	end,
	
	--明教日月灵
	sun = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local SunEnergy= hPlayer.nCurrentSunEnergy/100
		return _ZMAC_CompareEnergy(cType, SunEnergy, cNum)
	end,
	moon = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local MoonEnergy= hPlayer.nCurrentMoonEnergy/100
		return _ZMAC_CompareEnergy(cType, MoonEnergy, cNum)
	end,
	
	--霸刀气劲
	qijin = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local SunEnergy= hPlayer.nCurrentSunEnergy
		return _ZMAC_CompareEnergy(cType, SunEnergy, cNum)
	end,
	qjin = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local SunEnergy= hPlayer.nCurrentSunEnergy
		return _ZMAC_CompareEnergy(cType, SunEnergy, cNum)
	end,
	tqijin = function (cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local SunEnergy= t.nCurrentSunEnergy
		return _ZMAC_CompareEnergy(cType, SunEnergy, cNum)
	end,
	tqjin = function (cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local SunEnergy= t.nCurrentSunEnergy
		return _ZMAC_CompareEnergy(cType, SunEnergy, cNum)
	end,
	
	fullsun = function ()
		local hPlayer =GetClientPlayer()
		local SunPower= hPlayer.nSunPowerValue
		return SunPower==1
	end,
	sun_power = function ()
		local hPlayer =GetClientPlayer()
		local SunPower= hPlayer.nSunPowerValue
		return SunPower==1
	end,
	fullmoon = function ()
		local hPlayer =GetClientPlayer()
		local moonPower= hPlayer.nMoonPowerValue
		return moonPower==1
	end,
	moon_power = function ()
		local hPlayer =GetClientPlayer()
		local moonPower= hPlayer.nMoonPowerValue
		return moonPower==1
	end,
	
	nofullsun = function ()
		local hPlayer =GetClientPlayer()
		local SunPower= hPlayer.nSunPowerValue
		return SunPower==0
	end,
	nofullmoon = function ()
		local hPlayer =GetClientPlayer()
		local moonPower= hPlayer.nMoonPowerValue
		return moonPower==0
	end,
	tsun = function (cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local SunEnergy= t.nCurrentSunEnergy/100
		return _ZMAC_CompareEnergy(cType, SunEnergy, cNum)
	end,
	tmoon = function (cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local MoonEnergy= t.nCurrentMoonEnergy/100
		return _ZMAC_CompareEnergy(cType, MoonEnergy, cNum)
	end,
	tfullsun = function ()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local SunPower= t.nSunPowerValue
		return SunPower==1
	end,
	tsun_power = function ()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local SunPower= t.nSunPowerValue
		return SunPower==1
	end,
	tfullmoon = function ()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local moonPower= t.nMoonPowerValue
		return moonPower==1
	end,
	tmoon_power = function ()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local moonPower= t.nMoonPowerValue
		return moonPower==1
	end,
	
	tnofullsun = function ()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local SunPower= t.nSunPowerValue
		return SunPower==0
	end,
	tnofullmoon = function ()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local moonPower= t.nMoonPowerValue
		return moonPower==0
	end,
	moonlesssun=function()
		local hPlayer = GetClientPlayer()
		local SunEnergy= hPlayer.nCurrentSunEnergy/100
		local MoonEnergy= hPlayer.nCurrentMoonEnergy/100
		return SunEnergy>MoonEnergy
	end,
	sunlessmoon=function()
		local hPlayer = GetClientPlayer()
		local SunEnergy= hPlayer.nCurrentSunEnergy/100
		local MoonEnergy= hPlayer.nCurrentMoonEnergy/100
		return SunEnergy<MoonEnergy
	end,
	suneqmoon=function()
		local hPlayer = GetClientPlayer()
		local SunEnergy= hPlayer.nCurrentSunEnergy/100
		local MoonEnergy= hPlayer.nCurrentMoonEnergy/100
		return SunEnergy==MoonEnergy
	end,
	moonlesseqsun=function()
		local hPlayer = GetClientPlayer()
		local SunEnergy= hPlayer.nCurrentSunEnergy/100
		local MoonEnergy= hPlayer.nCurrentMoonEnergy/100
		return SunEnergy>=MoonEnergy
	end,
	sunlesseqmoon=function()
		local hPlayer = GetClientPlayer()
		local SunEnergy= hPlayer.nCurrentSunEnergy/100
		local MoonEnergy= hPlayer.nCurrentMoonEnergy/100
		return SunEnergy<=MoonEnergy
	end,
	
	combat = function()
		return GetClientPlayer().bFightState
	end,
	fight = function()
		return GetClientPlayer().bFightState
	end,
	petfight = function()
		local hPlayer = GetClientPlayer()
		local hPet = hPlayer.GetPet()
		if not hPet then return false end
		return hPet.bFightState
	end,
	nofight = function()
		return not GetClientPlayer().bFightState
	end,
	petnofight = function()
		local hPlayer = GetClientPlayer()
		local hPet = hPlayer.GetPet()
		if not hPet then return false end
		return not hPet.bFightState
	end,
	tfight = function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return t.bFightState
	end,
	tnofight = function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not t.bFightState
	end,
	ttfight = function()
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return tt.bFightState
	end,
	ttnofight = function()
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return not tt.bFightState
	end,
	fighttime = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		local szFightTime = _ZMAC.GetFightTime()
		return _ZMAC_Compare(cType, szFightTime, cNum)
	end,
	
	
	
	--骑御状态
	horse=function()
		return GetClientPlayer().bOnHorse
	end,
	nohorse=function()
		return not GetClientPlayer().bOnHorse
	end,
	thorse=function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if GetPlayer(t.dwID)and t.dwID ~= 0 then   --目标类型为PLAYER
			return t.bOnHorse
		else return false end
	end,
	tnohorse=function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if not t then return false end
		if GetPlayer(t.dwID) and t.dwID ~= 0 then   --目标类型为PLAYER
			return not t.bOnHorse
		else return false end
	end,
	--心法名称
	mount = function(str)
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckMount(hPlayer,str)
	end,
	tmount = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckMount(t,str)
	end,
	ttmount = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC.CheckMount(tt,str)
	end,
	nomount = function(str)
		local hPlayer = GetClientPlayer()
		return not _ZMAC.CheckMount(hPlayer,str)
	end,
	tnomount = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.CheckMount(t,str)
	end,
	ttnomount = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return not _ZMAC.CheckMount(tt,str)
	end,
	--buff类
	bufftime = function(str)
		local hPlayer = GetClientPlayer()
		return _ZMAC_CheckBuff(hPlayer,str,"t",false)
	end,
	tbufftime = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC_CheckBuff(t,str,"t",false)
	end,
	ttbufftime = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC_CheckBuff(tt,str,"t",false)
	end,
	buff = function(str)
		local hPlayer = GetClientPlayer()
		--Output(str,_ZMAC_CheckBuff(hPlayer,str,"s",false))
		
		return _ZMAC_CheckBuff(hPlayer,str,"s",false)
	end,
	tbuff = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC_CheckBuff(t,str,"s",false)
	end,
	ttbuff = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC_CheckBuff(tt,str,"s",false)
	end,
	nobuff = function(str)
		local hPlayer = GetClientPlayer()
		return not _ZMAC_CheckBuff(hPlayer,str,"s",false)

	end,
	tnobuff = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		
		return not _ZMAC_CheckBuff(t,str,"s",false)
	end,
	ttnobuff = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return not _ZMAC_CheckBuff(tt,str,"s",false)
	end,
	mbuff = function(str)
		local hPlayer = GetClientPlayer()
		--local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC_CheckBuff(hPlayer,str,"s",true)
	end,
	nombuff = function(str)
		local hPlayer = GetClientPlayer()
		--local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC_CheckBuff(hPlayer,str,"s",true)
	end,
	mbufftime = function(str)
		local hPlayer = GetClientPlayer()
		--local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC_CheckBuff(hPlayer,str,"t",true)

	end,
	tmbuff = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC_CheckBuff(t,str,"s",true)
	end,
	tnombuff = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC_CheckBuff(t,str,"s",true)
	end,
	tmbufftime = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC_CheckBuff(t,str,"t",true)
	end,
	
	totherbuff = function(str)
		if not _ZMAC.checktarget('t') then return false end
		return ZMAC_OptionFunc.tbuff(str) and not ZMAC_OptionFunc.tmbuff(str)
	end,
	tnootherbuff = function(str)
		if not _ZMAC.checktarget('t') then return false end
		return not ZMAC_OptionFunc.totherbuff(str)
	end,
	
	
	
	
	--姿态类
	status = function(str)
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckStatus(hPlayer,str)
	end,
	tstatus = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckStatus(t,str)
	end,
	ttstatus = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC.CheckStatus(tt,str)
	end,
	stats = function(str)
		local hPlayer = GetClientPlayer()
		--Output(str)
		--Output(_ZMAC.CheckStats(hPlayer,str))
		return _ZMAC.CheckStats(hPlayer,str)
	end,
	tstats = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckStats(t,str)
	end,
	ttstats = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC.CheckStats(tt,str)
	end,
	nostats = function(str)
		local hPlayer = GetClientPlayer()
		--Output(str)
		--Output(_ZMAC.CheckStats(hPlayer,str))
		return not _ZMAC.CheckStats(hPlayer,str)
	end,
	tnostats = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.CheckStats(t,str)
	end,
	ttnostats = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return not _ZMAC.CheckStats(tt,str)
	end,
	
	pettstatus = function(str)
		local hPlayer = GetClientPlayer()
		local hPet = hPlayer.GetPet()
		if not hPet then return false end
		return _ZMAC.CheckStatus(hPet,str)
	end,
	nostatus = function(str)
		local hPlayer = GetClientPlayer()
		return not _ZMAC.CheckStatus(hPlayer,str)
	end,
	tnostatus = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.CheckStatus(hPlayer,str)
	end,
	ttnostatus = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return not _ZMAC.CheckStatus(tt,str)
	end,
	pettnostatus = function(str)
		local hPlayer = GetClientPlayer()
		local hPet = hPlayer.GetPet()
		if not hPet then return false end
		return not _ZMAC.CheckStatus(hPet,str)
	end,
	--面向
	line =function() --on the same line
		return _ZMAC.CheckFace(GetClientPlayer(),30)
	end,
	
	range =function()
		return _ZMAC.CheckFace(GetClientPlayer(),63.5)
	end,
	back =function()
		return not _ZMAC.CheckFace(GetClientPlayer(),63.5)
	end,
	norange =function()
		return not _ZMAC.CheckFace(GetClientPlayer(),63.5)
	end,
	tline =function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckFace(t,30)
	end,
	
	
	trange =function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckFace(t,63.5)
	end,
	tback =function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.CheckFace(t,63.5)
	end,
	tnorange =function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.CheckFace(t,63.5)
	end,
	
	face =function()
		return _ZMAC.CheckFace(GetClientPlayer(),63.5)
	end,
	
	tface =function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckFace(t,63.5)
	end,
	
	
	
	
	
	bface = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local player = GetClientPlayer()
		local target=GetTargetHandle(player.GetTarget())
		-- if player~=GetClientPlayer() then 
			-- target=GetClientPlayer()
		-- end
		if (not target) or (not cNum) then
			return false
		end
		local fDirection = m_abs(player.nFaceDirection - GetLogicDirection(target.nX - player.nX, target.nY - player.nY))
		
		if fDirection > 127.5 then
			fDirection = 255 - fDirection
		end
		
		return _ZMAC_Compare(cType, fDirection, cNum)
	end,
	tbface = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		if not _ZMAC.checktarget('tt') then return false end
		local player = GetClientPlayer()
		local target=GetTargetHandle(player.GetTarget())

		if not target or not cNum then
			return false
		end
		
		local fDirection = m_abs(target.nFaceDirection - GetLogicDirection(player.nX - target.nX, player.nY - target.nY))
		
		if fDirection > 127.5 then
			fDirection = 255 - fDirection
		end
		
		return _ZMAC_Compare(cType, fDirection, cNum)
	end,

	
	--读条
	otaction = function(str,...)
		local hPlayer = GetClientPlayer()
		if str==nil then str="" end
		return _ZMAC.CheckPrepare(hPlayer,str,'otaction',...)
	end,
	nootaction = function(str,...)
		local hPlayer = GetClientPlayer()
		if str==nil then str="" end
		return not _ZMAC.CheckPrepare(hPlayer,str,'otaction',...)
	end,
	totaction = function(str,...)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if str==nil then str="" end
		return _ZMAC.CheckPrepare(t,str,'otaction',...)
	end,
	tnootaction = function(str,...)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if str==nil then str="" end
		return not _ZMAC.CheckPrepare(t,str,'otaction',...)
	end,
	prepare = function(str,...)
		local hPlayer = GetClientPlayer()
		if str==nil then str="" end
		return _ZMAC.CheckPrepare(hPlayer,str,'prepare',...)
	end,
	noprepare = function(str,...)
		local hPlayer = GetClientPlayer()
		if str==nil then str="" end
		return not _ZMAC.CheckPrepare(hPlayer,str,'prepare',...)
	end,
	tprepare = function(str,...)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if str==nil then str="" end
		return _ZMAC.CheckPrepare(t,str,'prepare',...)
	end,
	ttprepare = function(str,...)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC.CheckPrepare(tt,str,'prepare',...)
	end,
	tnoprepare = function(str,...)
		
		if not _ZMAC.checktarget('t') then return false end
		
		local hPlayer = GetClientPlayer()
		--Output(1)
		local t = GetTargetHandle(hPlayer.GetTarget())
		--Output(_ZMAC.CheckPrepare(t,str,'prepare',...))
		return not _ZMAC.CheckPrepare(t,str,'prepare',...)
	end,
	ttnoprepare = function(str,...)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return not _ZMAC.CheckPrepare(tt,str,'prepare',...)
	end,
	
	channel = function(str,...)
		local hPlayer = GetClientPlayer()
		if str==nil then str="" end
		return _ZMAC.CheckPrepare(hPlayer,str,'channel',...)
	end,
	nochannel = function(str,...)
		local hPlayer = GetClientPlayer()
		if str==nil then str="" end
		return not _ZMAC.CheckPrepare(hPlayer,str,'channel',...)
	end,
	tchannel = function(str,...)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if str==nil then str="" end
		return _ZMAC.CheckPrepare(t,str,'channel',...)
	end,
	tnochannel = function(str,...)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if str==nil then str="" end
		return not _ZMAC.CheckPrepare(t,str,'channel',...)
	end,
	
	
	
	--打断
	broken = function()
		local hPlayer = GetClientPlayer()
		--local t = GetTargetHandle(hPlayer.GetTarget())
		local t = hPlayer
		if not t then
			return false
		end
		if t.dwID < 1073741824 and t.dwID ~= 0 then   --目标类型为PLAYER
			local retxxx,PrepareState, PreSkillID, PreSkillLv, PrePer = pcall(t.GetSkillOTActionState)
			if retxxx ==false then --缘起
				PrepareState, PreSkillID, PreSkillLv, PrePer=t.GetSkillPrepareState()
				if PrepareState==false then PrepareState=0 end
			end
			
			if PrepareState == 1 or PrepareState == 2 then
				local SkillInfo = GetSkill(PreSkillID, PreSkillLv)
				local SkillName = Table_GetSkillName(PreSkillID, PreSkillLv)
				return SkillInfo.nBrokenRate > 0
			end
		end
		return false
	end,
	tbroken = function()       --mei写npc类的读条判断
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if GetPlayer(t.dwID) then   --目标类型为PLAYER
			--local PrepareState, PreSkillID, PreSkillLv,fP = t.GetSkillOTActionState()
			local retxxx,PrepareState, PreSkillID, PreSkillLv, PrePer = pcall(t.GetSkillOTActionState)
			if retxxx ==false then --缘起
				PrepareState, PreSkillID, PreSkillLv, PrePer=t.GetSkillPrepareState()
				if PrepareState==false then PrepareState=0 end
			end
			
			
			if PrepareState == 1 or PrepareState == 2 then
				local SkillInfo = GetSkill(PreSkillID, PreSkillLv)
				local SkillName = Table_GetSkillName(PreSkillID, PreSkillLv)
				return SkillInfo.nBrokenRate > 0
			end
		elseif GetNpc(t.dwID) then
			--local PrepareState, PreSkillID, PreSkillLv,fP = t.GetSkillOTActionState()
			
			local retxxx,PrepareState, PreSkillID, PreSkillLv, PrePer = pcall(t.GetSkillOTActionState)
			if retxxx ==false then --缘起
				PrepareState, PreSkillID, PreSkillLv, PrePer=t.GetSkillPrepareState()
				if PrepareState==false then PrepareState=0 end
			end
			
			if PrepareState == 1 or PrepareState == 2 then
				local SkillInfo = GetSkill(PreSkillID, PreSkillLv)
				local SkillName = Table_GetSkillName(PreSkillID, PreSkillLv)
				return SkillInfo.nBrokenRate > 0
			end
		end
		return false
	end,
	nobroken = function()
		return ZMAC_OptionFunc.broken()
	end,
	tnobroken = function()       --mei写npc类的读条判断
		if not _ZMAC.checktarget('t') then return false end
		return not ZMAC_OptionFunc.tbroken()
	end,
	
	tbrokenname=function(str,...)
		if not _ZMAC.checktarget('t') then return false end
		return (ZMAC_OptionFunc.tbroken() and ZMAC_OptionFunc.totaction(str,...))
	end,
	
	tbrokentime=function(str,...)
		if not _ZMAC.checktarget('t') then return false end
		return (ZMAC_OptionFunc.tbroken() and ZMAC_OptionFunc.totaction(str,...))
	end,
	
	
	
	
	--自身状态？？？
	self =function(str) 
		return _ZMAC.SelfJudgement(str)
	end,
	--等级
	level = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		return _ZMAC_Compare(cType, hPlayer.nLevel, cNum)
	end,
	
	
	
	
	--暗藏杀机
	bomb =function(str,...) --唐门释放暗藏杀机次数
		local hPlayer = GetClientPlayer()
		local Boolean,tDis,cType,Value = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if not Boolean then 
			Value = tDis
			cType = (...)
			tDis = 30       
		else
			tDis = tonumber(tDis)
		end	
	
		local nCount = 0
		local player = GetClientPlayer()
		if player then
			local aNpc = GetAllNpc() or {}
			for _, v in ipairs(aNpc) do
				local nDist = math.floor(((player.nX - v.nX) ^ 2 + (player.nY - v.nY) ^ 2 + (player.nZ/8 - v.nZ/8) ^ 2) ^ 0.5)/64
				if v.szName == "机关暗藏杀机" and nDist <= tDis and v.dwEmployer == player.dwID then
					nCount = nCount + 1
				end
			end
		end
		return _ZMAC_Compare(cType, nCount, tonumber(Value))
	end,
	
	tmbomb = function(str,...)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local Boolean,tDis,cType,Value = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if not Boolean then 
			Value = tDis
			cType = (...)
			tDis = 7     
		else
			tDis = tonumber(tDis)
		end
		local nCount = 0
		local t = GetTargetHandle(hPlayer.GetTarget())
		local aNpc = GetAllNpc() or {}
		for _, v in ipairs(aNpc) do
			local nDist = math.floor(((t.nX - v.nX) ^ 2 + (t.nY - v.nY) ^ 2 + (t.nZ/8 - v.nZ/8) ^ 2) ^ 0.5)/64
			if v.szName == "机关暗藏杀机" and nDist <= tDis and v.dwEmployer == hPlayer.dwID then
				nCount = nCount + 1
			end
		end
		return _ZMAC_Compare(cType, nCount, tonumber(Value))
		
	end,
	
	--机关
	puppet = function(str)
		if _ZMAC.IsPuppetOpened() then --有千机变
			local hFrame = Station.Lookup("Normal/PuppetActionBar")
			if str then --有条件
				local pup = GetNpc(GetClientPlayer().dwBatteryID)
				str = StringReplaceW(str, "%s", "")
				if str == "" then
					return true
				end
				if pup and pup.dwTemplateID == _ZMAC.Pup[str] then
					return true
				end
				return false
			end
			return true --如果无条件则直接返回true
		end
		return false
	end,
	puppetdistance = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		if _ZMAC.IsPuppetOpened() then --有千机变
			local hFrame = Station.Lookup("Normal/PuppetActionBar")
			local hPupet = GetNpc(GetClientPlayer().dwBatteryID)
			--Output(hPupet.szName)
			local Distance = m_floor(((hPupet.nX - hPlayer.nX) ^ 2 + (hPupet.nY - hPlayer.nY) ^ 2 + (hPupet.nZ/8 - hPlayer.nZ/8) ^ 2) ^ 0.5)/64
			return _ZMAC_Compare(cType, Distance, cNum)
		end
		return false
	end,
	tpuppetdistance = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if _ZMAC.IsPuppetOpened() then --有千机变
			local hFrame = Station.Lookup("Normal/PuppetActionBar")
			local hPupet = GetNpc(GetClientPlayer().dwBatteryID)
			--Output(hPupet.szName)
			local Distance = m_floor(((hPupet.nX - t.nX) ^ 2 + (hPupet.nY - t.nY) ^ 2 + (hPupet.nZ/8 - t.nZ/8) ^ 2) ^ 0.5)/64
			return _ZMAC_Compare(cType, Distance, cNum)
		end
		return false
	end,	
	nopuppet = function(str)
		if _ZMAC.IsPuppetOpened() then
			local hFrame = Station.Lookup("Normal/PuppetActionBar")
			if str then
				local pup = GetNpc(GetClientPlayer().dwBatteryID)
				str = StringReplaceW(str, "%s", "")
				if str == "" then
					return false
				end
				if pup and pup.dwTemplateID == _ZMAC.Pup[str] then
					return false
				end
				return true
			end
			return false
		end
		return true
	end,
	--宠物
	pet = function(...)
		local str = (...)
		local pet=GetClientPlayer().GetPet()
		if pet then
			if str then
				str = StringReplaceW(str, "%s", "")
				if pet.szName == str  or str == "" then
					return true
				end
			else
				return true
			end
		end
		return false
	end,
	nopet =function(...)
		local str = (...)
		local pet=GetClientPlayer().GetPet()
		if pet then
			
			if str then
				str = StringReplaceW(str, "%s", "")
				if pet.szName == str or str == "" then
					return false
				end
			else
				return false
			end
		end
		return true
	end,
	
	jgnum = function (cNum, cType) --唐门机关数量
		local WItemNum = TaiFengIsWItemNum()
		return _ZMAC_Compare(cType, WItemNum, cNum)
	end,
	pupdis = function(cNum, cType)        --千机变距离
		local hPlayer = GetClientPlayer()
		local QianJiBian = GetNpc(hPlayer.dwBatteryID)
		if not QianJiBian then return false end
		--local Distance = m_ceil(GetCharacterDistance(hPlayer.dwID, QianJiBian.dwID)/64)
		local Distance =_ZMAC.Decimal(GetCharacterDistance(hPlayer.dwID, QianJiBian.dwID)/64)
		--Output("千机变:" .. cNum,Distance,_ZMAC_Compare(cType, Distance, cNum))
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	
	enemynum = function(str)
		--if str == '' then return true end
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckPlayerNum(str,hPlayer,'enemy')
	end,
	enemylookmenum = function(str,...)
		--if str == '' then return true end
		local hPlayer = GetClientPlayer()
		local Boolean,tDis,Type,Value = _ZMAC_SplitRelationSymbol(str,'[><=]')

		if not Boolean then 
			--Output(Boolean,tDis,Type,Value,...)
			Value = tDis
			Type = (...)
			tDis = 30       
		else
			tDis = tonumber(tDis)
		end
		
		--获取范围内敌对目标看自己的人数
		local Count = 0

		for j, v in pairs(_ZMAC_GetAllPlayer() ) do
			local k = v.dwID
			local xPlayer = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			--Output(xPlayer.szName,Dis)
			
			local xPlayerTarget =  GetTargetHandle(xPlayer.GetTarget())
			
			if xPlayerTarget ~=nil and xPlayerTarget.szName ==hPlayer.szName  then     --该目标在看着我
				if  Dis <= tDis and IsEnemy(hPlayer.dwID, k) then
					Count = Count + 1
				end
			end
		end
		local playerNum = Count
		--Output(Type,playerNum, Value)
		return _ZMAC_Compare(Type,playerNum, Value)
	end,
	
	
	allynum = function(str)
		--if str == '' then return true end
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckPlayerNum(str,hPlayer,'ally')
	end,
	
	allylooktnum = function(str,...)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local Boolean,tDis,Type,Value = _ZMAC_SplitRelationSymbol(str,'[><=]')

		if not Boolean then 
			Value = tDis
			Type = (...)
			tDis = 30       
		else
			tDis = tonumber(tDis)
		end
		--获取范围内队友看目标的人数
		local Count = 0
		local t = GetTargetHandle(hPlayer.GetTarget())
		for j, v in pairs(_ZMAC_GetAllPlayer() ) do
			local k = v.dwID
			local xPlayer = v
			local Dis = GetCharacterDistance(t.dwID, k) / 64
			
			if IsParty(xPlayer.dwID,hPlayer.dwID) then
				local xPlayerTarget =  GetTargetHandle(xPlayer.GetTarget())
				if xPlayerTarget ~=nil and xPlayerTarget.szName ==t.szName and Dis <= tDis then     
					Count = Count + 1
				end
			end
		end
		local playerNum = Count + 1 --还有个我在看他
		return _ZMAC_Compare(Type,playerNum, Value)
	end,
	
	
	
	
	
	
	partynum = function(str)
		--if str == '' then return true end
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckPlayerNum(str,hPlayer,'party')
	end,
	

	tenemynum = function(str)
		--if str == '' then return true end
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckPlayerNum(str,t,'enemy')
	end,
	tallynum = function(str)
		if not _ZMAC.checktarget('t') then return false end
		--if str == '' then return true end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckPlayerNum(str,t,'ally')
	end,
	tpartynum = function(str)
		if not _ZMAC.checktarget('t') then return false end
		--if str == '' then return true end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckPlayerNum(str,t,'party')
	end,
	
	petenemynum = function(str)
		--if str == '' then return true end
		local hPlayer = GetClientPlayer()
		local t = hPlayer.GetPet()
		if not t then return false end
		return _ZMAC.CheckPlayerNum(str,t,'enemy')
	end,
	petallynum = function(str)
		--if str == '' then return true end
		local hPlayer = GetClientPlayer()
		local t = hPlayer.GetPet()
		if not t then return false end
		return _ZMAC.CheckPlayerNum(str,t,'ally')
	end,
	
	
	enemynpcnum = function (str) --NPC数量
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckNpcNum(str,hPlayer,'enemy')
	end,
	allynpcnum = function (str) --NPC数量
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckNpcNum(str,hPlayer,'ally')
	end,
	tenemynpcnum = function (str) --NPC数量
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckNpcNum(str,t,'enemy')
	end,
	tallynpcnum = function (str) --NPC数量
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckNpcNum(str,t,'ally')
	end,
	
	npcs=function(str)
		local hPlayer = GetClientPlayer()
		
		local Boolean,NpcName,Type,tDis = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if Boolean== false then
			tDis = 25
			Type ='<'
		end
		
		
		tDis = tonumber(tDis) or 25
		
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			if Npc.szName == NpcName then
				if Type =='>' then
					return Dis > tDis
				elseif Type =='<' then
					return Dis < tDis
				elseif Type =='=' then
					return Dis == tDis
				end
			end
		end
		return false
	end,
	nonpcs=function(str)
		return not ZMAC_OptionFunc.npcs(str)
	end,

	mynpc=function(str)
		local hPlayer = GetClientPlayer()
		
		local Boolean,NpcName,Type,tDis = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if Boolean== false then
			tDis = 25
			Type ='<'
		end

		tDis = tonumber(tDis) or 25
		
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			
			if Npc.szName == NpcName and Npc.dwEmployer ==hPlayer.dwID then  --Npc.dwEmployer为npc主人的ID
				if Type =='>' then
					return Dis > tDis
				elseif Type =='<' then
					return Dis < tDis
				elseif Type =='=' then
					return Dis == tDis
				end
			end
		end
		return false
	end,
	
	nomynpc=function(str)
		return not ZMAC_OptionFunc.mynpc(str)
	end,
	
	tmynpc=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())

		
		local Boolean,NpcName,Type,tDis = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if Boolean== false then
			tDis = 25
			Type ='<'
		end
		
		tDis = tonumber(tDis) or 25
		
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(t.dwID, k) / 64
			
			if Npc.szName == NpcName and Npc.dwEmployer ==hPlayer.dwID then  --Npc.dwEmployer为npc主人的ID
				if Type =='>' then
					return Dis > tDis
				elseif Type =='<' then
					return Dis < tDis
				elseif Type =='=' then
					return Dis == tDis
				end
			end
		end
		return false
	end,
	
	tnomynpc=function(str)
		return not ZMAC_OptionFunc.tmynpc(str)
	end,
	
	
	inallycfzy=function()
		--实测在驰风震域内会有7795的隐藏buff
		--有驰风震域的时候有3个buff,另外两个是14071和14242,作用未知
		return ZMAC_OptionFunc.buff('7795')
	end,
	
	
	
	allynpc=function(str)
		local hPlayer = GetClientPlayer()
		local Boolean,NpcName,Type,tDis = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if Boolean== false then
			tDis = 25
			Type ='<'
		end
		
		
		tDis = tonumber(tDis) or 25
		
		
		
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = v
			
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			
			if Npc.szName == NpcName and IsAlly(Npc.dwID,hPlayer.dwID) then  --Npc.dwEmployer为npc主人的ID
				
				if Type =='>' then
					return Dis > tDis
				elseif Type =='<' then
					return Dis < tDis
				elseif Type =='=' then
					return Dis == tDis
				end
			end
		end
		return false
	end,
	
	noallynpc=function(str)
		return not ZMAC_OptionFunc.allynpc(str)
	end,
	
	tallynpc=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Boolean,NpcName,Type,tDis = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if Boolean== false then
			tDis = 25
			Type ='<'
		end
		
		tDis = tonumber(tDis) or 25
		
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = GetNpc(k)
			local Dis = GetCharacterDistance(t.dwID, k) / 64
			
			if Npc.szName == NpcName and IsAlly(t.dwID,hPlayer.dwID) then  --Npc.dwEmployer为npc主人的ID
				if Type =='>' then
					return Dis > tDis
				elseif Type =='<' then
					return Dis < tDis
				elseif Type =='=' then
					return Dis == tDis
				end
			end
		end
		return false
	end,
	
	tnoallynpc=function(str)
		return not ZMAC_OptionFunc.tallynpc(str)
	end,
	
	enemynpc=function(str)
		local hPlayer = GetClientPlayer()
		local Boolean,NpcName,Type,tDis = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if Boolean== false then
			tDis = 25
			Type ='<'
		else
			tDis = tonumber(tDis) or 25
		end
		
		
		
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k =v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			
			if Npc.szName == NpcName and IsEnemy(Npc.dwID,hPlayer.dwID) then  --Npc.dwEmployer为npc主人的ID
				if Type =='>' then
					return Dis > tDis
				elseif Type =='<' then
					return Dis < tDis
				elseif Type =='=' then
					return Dis == tDis
				end
			end
		end
		return false
	end,
	
	noenemynpc=function(str)
		return not ZMAC_OptionFunc.enemynpc(str)
	end,
	
	tenemynpc=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())

		local Boolean,NpcName,Type,tDis = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if Boolean== false then
			tDis = 25
			Type ='<'
		end
		
		tDis = tonumber(tDis) or 25
		
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k =v.dwID
			local Npc =v
			local Dis = GetCharacterDistance(t.dwID, k) / 64
			
			if Npc.szName == NpcName and IsEnemy(t.dwID,hPlayer.dwID) then  --Npc.dwEmployer为npc主人的ID
				if Type =='>' then
					return Dis > tDis
				elseif Type =='<' then
					return Dis < tDis
				elseif Type =='=' then
					return Dis == tDis
				end
			end
		end
		return false
	end,
	
	tnoenemynpc=function(str)
		return not ZMAC_OptionFunc.tenemynpc(str)
	end,

	qcnum=function(str)
		local hPlayer = GetClientPlayer()
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		
		if Boolean== false then
			tDis = 25
			Type ='<'
		end
		
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,

	tqcnum=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(t.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,

	myqcnum=function(str)
		local hPlayer = GetClientPlayer()
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k =v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' and Npc.dwEmployer ==hPlayer.dwID then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,

	nomyqcnum=function(str)
		local hPlayer = GetClientPlayer()
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' and Npc.dwEmployer ~=hPlayer.dwID then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,

	tmyqcnum=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(t.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' and Npc.dwEmployer ==hPlayer.dwID then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,

	tnomyqcnum=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k =v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(t.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' and Npc.dwEmployer ~=hPlayer.dwID then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,


	allyqcnum=function(str)
		local hPlayer = GetClientPlayer()
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k =v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' and IsAlly(hPlayer.dwID, Npc.dwID) then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,


	enemyqcnum=function(str)
		local hPlayer = GetClientPlayer()
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k = v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' and IsEnemy(hPlayer.dwID, Npc.dwID) then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,


	tallyqcnum=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k  = v.dwID
			local Npc = v
			local Dis = GetCharacterDistance(t.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' and IsAlly(hPlayer.dwID, Npc.dwID) then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,


	tenemyqcnum=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		
		local Boolean,tDis,Type,tNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		tDis = tonumber(tDis) or 25
		tNum= tonumber(tNum) or 25
		local Counet = 0
		for j, v in pairs(_ZMAC_GetAllNpc()) do
			local k=v.dwID
			local Npc = GetNpc(k)
			local Dis = GetCharacterDistance(t.dwID, k) / 64
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='气场' and IsEnemy(hPlayer.dwID, Npc.dwID) then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,

	--目标为中立
	neutrality =function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local tT, tID =hPlayer.GetTarget()
		return IsNeutrality(hPlayer.dwID,tID)
	end,
	tneutrality =function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local tT, tID =hPlayer.GetTarget()
		return IsNeutrality(hPlayer.dwID,tID)
	end,
	ttneutrality =function()
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local ttT, ttID =t.GetTarget()
		return IsNeutrality(hPlayer.dwID,ttID)
	end,
	--同盟
	ally=function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tT, tID =hPlayer.GetTarget()
		return IsAlly(hPlayer.dwID,tID)
	end,
	tally=function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local tT, tID =hPlayer.GetTarget()
		if (not tT) or (not tID) then return false end
		--Output(IsAlly(hPlayer.dwID,tID))
		return IsAlly(hPlayer.dwID,tID)
	end,
	ttally =function()
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local ttT, ttID =t.GetTarget()
		return IsAlly(hPlayer.dwID,ttID)
	end,
	--敌对
	enemy=function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local tT, tID =hPlayer.GetTarget()
		return IsEnemy(hPlayer.dwID,tID)
	end,
	tenemy=function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local tT, tID =hPlayer.GetTarget()
		return IsEnemy(hPlayer.dwID,tID)
	end,
	ttenemy =function()
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local ttT, ttID =t.GetTarget()
		return IsEnemy(hPlayer.dwID,ttID)
	end,
	
	isparty = function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return IsParty(hPlayer.dwID,tID)
	end,
	
	tisparty = function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return IsParty(hPlayer.dwID,tID)
	end,
	
	ttisparty = function()
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local ttT, ttID =t.GetTarget()
		return IsParty(hPlayer.dwID,ttID)
	end,
	
	tchoosetime = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		local tType, tID = hPlayer.GetTarget()
		if tID == 0 then 
			return false
		elseif not _ZMAC.TargetLog[tID] then
			return false
		else 
			local tTime = _ZMAC.TargetLog[tID]['ChooseTime']
			local PastTime = (GetLogicFrameCount() - tTime)/GLOBAL.GAME_FPS
			
			--Output(tTime,PastTime) 
			return _ZMAC_Compare(cType, PastTime, cNum)
		end
	end,
	
	
	--目标类型
	target = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckTarget(t, str)
	end,
	ttarget = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC.CheckTarget(tt,str)
	end,

	--目标是否存在
	exists = function()
		if not _ZMAC.checktarget('t') then return false end
		local tT,tID = GetClientPlayer().GetTarget()
		return (tT == TARGET.PLAYER or tT == TARGET.NPC) and tID ~= 0
	end,
	pettarget = function()
		if not GetClientPlayer().GetPet() then return false end
		local tT,tID = GetClientPlayer().GetPet().GetTarget()
		return (tT == TARGET.PLAYER or tT == TARGET.NPC) and tID ~= 0
	end,
	texists = function()
		local tT,tID = GetClientPlayer().GetTarget()
		return (tT == TARGET.PLAYER or tT == TARGET.NPC) and tID ~= 0
	end,
	noexists=function()
		local tT,tID = GetClientPlayer().GetTarget()
		return tID==0 and tT ~= TARGET.PLAYER and tT ~= TARGET.NPC
	end,
	petnotarget = function()
		if not GetClientPlayer().GetPet() then return false end
		local tT,tID = GetClientPlayer().GetPet().GetTarget()
		return tID==0 and tT ~= TARGET.PLAYER and tT ~= TARGET.NPC
	end,
	tnoexists=function()
		local tT,tID = GetClientPlayer().GetTarget()
		return tID==0 and tT ~= TARGET.PLAYER and tT ~= TARGET.NPC
	end,
	force = function(str)
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckForce(hPlayer,str)
	end,
	--目标门派
	tforce = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckForce(t,str)
	end,
	ttforce = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC.CheckForce(tt,str)
	end,
	tnoforce = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.CheckForce(t,str)
	end,
	ttnoforce = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return not _ZMAC.CheckForce(tt,str)
	end,
	--目标名字
	tname = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget()) 
		return _ZMAC.CheckName(t,str)
	end,
	pettname = function(str)
		if not GetClientPlayer().GetPet() then return false end
		if str == '$myname' then str = GetClientPlayer().szName end
		if str == '$mytname' then 
			if GetTargetHandle(GetClientPlayer().GetTarget()) then
				str = GetTargetHandle(GetClientPlayer().GetTarget()).szName
			end
		end
		local hPlayer = GetClientPlayer()
		local hPet = GetTargetHandle(TARGET.NPC,GetClientPlayer().GetPet().dwID)
		if not hPet then return false end
		local hPetTarget = GetTargetHandle(hPet.GetTarget())
		if not hPetTarget then return false end
		local tName = hPetTarget.szName
		if not tName then return false end
		return tName == str
	end,
	ttname = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer() 
		local t = GetTargetHandle(hPlayer.GetTarget()) 
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC.CheckName(tt,str)
	end,
	tnoname = function(str)
		--if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.CheckName(t,str)
	end,
	pettnoname = function(str)
		if not GetClientPlayer().GetPet() then return false end
		if str == '$myname' then str = GetClientPlayer().szName end
		if str == '$mytname' then 
			if GetTargetHandle(GetClientPlayer().GetTarget()) then
				str = GetTargetHandle(GetClientPlayer().GetTarget()).szName
			else 
				str = ''
			end
		end
		local hPlayer = GetClientPlayer()
		local hPet = GetTargetHandle(TARGET.NPC,GetClientPlayer().GetPet().dwID)
		if not hPet then return false end
		local hPetTarget = GetTargetHandle(hPet.GetTarget())
		local tName
		if not hPetTarget then 
			tName = ''
		else 
			tName = hPetTarget.szName
		end
		
		return tName ~= str
	end,	
	
	ttnoname = function(str)
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if not t then return false end
		local tt = GetTargetHandle(t.GetTarget())
		return not _ZMAC.CheckName(tt,str)
	end,
	--距离
	distance = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Distance = (GetCharacterDistance(hPlayer.dwID, t.dwID)/64)-(GetCharacterDistance(hPlayer.dwID, t.dwID)/64)%0.01
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	tdistance = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Distance = (GetCharacterDistance(hPlayer.dwID, t.dwID)/64)-(GetCharacterDistance(hPlayer.dwID, t.dwID)/64)%0.01
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	distancenz = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Distance = m_abs((hPlayer.nZ - t.nZ)) / 494
		if Distance<0.15 then Distance =0 end
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	tbechasing = function()
		if not _ZMAC.checktarget('t') then return false end
		if not WY.BailiTarget then return false end
		local hPlayer = GetClientPlayer()
		if not _ZMAC.CheckPrepare(hPlayer,'百里追魂','channel',nil) then return false end
		local t = GetTargetHandle(hPlayer.GetTarget())
		return WY.BailiTarget.dwID == t.dwID
	end,
	
	
	tbechasingdistance = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		if not WY.BailiTarget then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Distance = m_floor(((t.nX - WY.Baili_nX) ^ 2 + (t.nY - WY.Baili_nY) ^ 2 + (t.nZ/8 - WY.Baili_nZ/8) ^ 2) ^ 0.5)/64
		Output(Distance)
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	
	tdistancenz = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Distance = m_abs((hPlayer.nZ - t.nZ)) / 494
		if Distance<0.15 then Distance =0 end
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	heightz = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Distance = m_abs((hPlayer.nZ - t.nZ)) / 494
		if Distance<0.15 then Distance =0 end
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	ttdistance = function(cNum, cType)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		local Distance = (GetCharacterDistance(hPlayer.dwID, tt.dwID)/64)-(GetCharacterDistance(hPlayer.dwID, tt.dwID)/64)%0.01
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	petdistance = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		local hPet = hPlayer.GetPet()
		if not hPet then return false end
		local Distance = m_floor(((hPet.nX - hPlayer.nX) ^ 2 + (hPet.nY - hPlayer.nY) ^ 2 + (hPet.nZ/8 - hPlayer.nZ/8) ^ 2) ^ 0.5)/64
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	tpetdistance = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local hPet = hPlayer.GetPet()
		if not hPet then return false end
		local t = GetTargetHandle(hPlayer.GetTarget())
		local Distance = m_floor(((hPet.nX - t.nX) ^ 2 + (hPet.nY - t.nY) ^ 2 + (hPet.nZ/8 - t.nZ/8) ^ 2) ^ 0.5)/64
		return _ZMAC_Compare(cType, Distance, cNum)
	end,
	
	--CD类
	cd = function(SkillName)
		return _ZMAC.GetSkillNum(GetClientPlayer(),SkillName)<1 
	end,
	nocd = function(SkillName)
		return _ZMAC.GetSkillNum(GetClientPlayer(),SkillName)>0 
	end,

	gcd = function()
		local KungfuMount = _ZMAC.MySchoolName()
		local gcdID=605 --骑御
		if KungfuMount=='焚影圣诀' or KungfuMount=='明尊琉璃体' then
			gcdID=3962 --赤日轮
		elseif KungfuMount=='笑尘诀' then
			gcdID=5258 --拨狗朝天
		end
		return _ZMAC.CheckSkillCool(gcdID)
	end,
	
	nogcd = function()
		local KungfuMount = _ZMAC.MySchoolName()
		local gcdID=605 --骑御
		if KungfuMount=='焚影圣诀' or KungfuMount=='明尊琉璃体' then
			gcdID=3962 --赤日轮
		elseif KungfuMount=='笑尘诀' then
			gcdID=5258 --拨狗朝天
		end
		return not _ZMAC.CheckSkillCool(gcdID)
	end,
	petcd = function(SkillName)
		local hPlayer = GetClientPlayer()
		local skill_num = _ZMAC.GetSkillNum(hPlayer,SkillName)
		return skill_num < 1
	end,
	petnocd = function(SkillName)
		local hPlayer = GetClientPlayer()
		local skill_num = _ZMAC.GetSkillNum(hPlayer,SkillName)
		return skill_num >= 1
	end,
	
	cdtime = function(str)  --充能cd没写
		local hPlayer = GetClientPlayer()
		local strs = _ZMAC_SplitStr2Array(str, "|")
		for _,SkillCD in ipairs(strs) do
			local Boolean,SkillName,cType,cNum=_ZMAC_SplitRelationSymbol(SkillCD,"[><=]")
			local szSkillID = _ZMAC.GetSkillIdEx(SkillName)
			local SkillLevel = hPlayer.GetSkillLevel(szSkillID)
			local _, CD, TotalCD = hPlayer.GetSkillCDProgress(szSkillID, SkillLevel)
			
			
			local gcdID=605 --骑御
			local KungfuMount = hPlayer.GetKungfuMount()
			if KungfuMount=='焚影圣诀' or KungfuMount=='明尊琉璃体' then
				gcdID=3962 --赤日轮
			elseif KungfuMount=='笑尘诀' then
				gcdID=5258 --拨狗朝天
			end

			local GcdSkillLevel = hPlayer.GetSkillLevel(gcdID)
			local _, GCD, TotalGCD = hPlayer.GetSkillCDProgress(gcdID, GcdSkillLevel)
			
			if GCD== CD and TotalGCD == TotalCD then --cd与gcd完全相同时，则该技能没有cd，将CD强行设置为0
				CD =0
			end

			local CD = CD / GLOBAL.GAME_FPS
			
			if Boolean then
				if _ZMAC_Compare(cType, CD, cNum) then -- and _ZMAC.GetSkillNum(hPlayer,SkillName)<1
					return true
				end
			end
		end
		return false

	end,
	
	
	num = function(str)
		local hPlayer = GetClientPlayer()
		local Boolean,SkillName,cType,cNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		--Output(Boolean,SkillName,cType,cNum)
		local skill_num = _ZMAC.GetSkillNum(hPlayer,SkillName)
		--Output(cType, skill_num, cNum)
		return _ZMAC_Compare(cType, skill_num, cNum)
	end,
	tnum = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(GetClientPlayer().GetTarget())
		local Boolean,SkillName,cType,cNum = _ZMAC_SplitRelationSymbol(str,'[><=]')
		local skill_num = _ZMAC.GetSkillNum(t,SkillName)
		return _ZMAC_Compare(cType, skill_num, cNum)

	end,
	
	mcast=function(str)
		return _ZMAC.CheckCastHitTime(GetClientPlayer(),'Cast',str)
	end,
	tcast=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(GetClientPlayer().GetTarget())
		return _ZMAC.CheckCastHitTime(t,'Cast',str)
	end,
	mhit=function(str)
		return _ZMAC.CheckCastHitTime(GetClientPlayer(),'Hit',str)
	end,
	thit=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(GetClientPlayer().GetTarget())
		return _ZMAC.CheckCastHitTime(t,'Hit',str)
	end,
	
	dead = function()
		local tT = TARGET.PLAYER
		local tID = GetClientPlayer().dwID
		if tT == TARGET.PLAYER then
			local hPlayer = GetPlayer(tID)
			if hPlayer and hPlayer.nMoveState == MOVE_STATE.ON_DEATH then
				return true
			end
		end
		return false
	end,
	nodead = function()
		local tT = TARGET.PLAYER
		local tID = GetClientPlayer().dwID
		if tT == TARGET.PLAYER then
			local hPlayer = GetPlayer(tID)
			if hPlayer and hPlayer.nMoveState ~= MOVE_STATE.ON_DEATH then
				return true
			end
		end
		return false
	end,
	tdead = function()
		if not _ZMAC.checktarget('t') then return false end
		local tT, tID = GetClientPlayer().GetTarget()
		if tT == TARGET.PLAYER then
			local hPlayer = GetPlayer(tID)
			if hPlayer and hPlayer.nMoveState == MOVE_STATE.ON_DEATH then
				return true
			end
		else--if tT == TARGET.NPC then             --扯淡
			local tLifePercent = GetTargetHandle(tT, tID).nCurrentLife/GetTargetHandle(tT, tID).nMaxLife
			if tLifePercent<0.004 ==true then
				return true
			end
		end
		return false
	end,
	tnodead = function()
		if not _ZMAC.checktarget('t') then return false end
		local tT, tID = GetClientPlayer().GetTarget()
		if tT == TARGET.PLAYER then
			local hPlayer = GetPlayer(tID)
			if hPlayer and hPlayer.nMoveState ~= MOVE_STATE.ON_DEATH then
				return true
			end
		else --if tT == TARGET.NPC then   
			local tLifePercent = GetTargetHandle(tT, tID).nCurrentLife/GetTargetHandle(tT, tID).nMaxLife
			if tLifePercent>0.004 ==true  then
				return true
			end
		end
		return false
	end,
	ttdead = function()
		if not _ZMAC.checktarget('tt') then return false end
		local t = GetTargetHandle(GetClientPlayer().GetTarget())
		local ttT, ttID = t.GetTarget()
		if ttT==TARGET.NO_TARGET then return false end
		if ttT == TARGET.PLAYER then
			local hPlayer = GetPlayer(ttID)
			if hPlayer and hPlayer.nMoveState == MOVE_STATE.ON_DEATH then
				return true
			end
		else--if ttT == TARGET.NPC then             
			local tLifePercent = GetTargetHandle(ttT, ttID).nCurrentLife/GetTargetHandle(ttT, ttID).nMaxLife
			if tLifePercent<0.004 then
				return true
			end
		end
		return false
	end,
	ttnodead = function()
		if not _ZMAC.checktarget('t') then return false end
		local t = GetTargetHandle(GetClientPlayer().GetTarget())
		local ttT, ttID = t.GetTarget()
		if ttT == TARGET.PLAYER then
			local hPlayer = GetPlayer(ttID)
			if hPlayer and hPlayer.nMoveState ~= MOVE_STATE.ON_DEATH then
				return true
			end
		else--if ttT == TARGET.NPC then             
			local tLifePercent = GetTargetHandle(ttT, ttID).nCurrentLife/GetTargetHandle(ttT, ttID).nMaxLife
			if tLifePercent>0.004 then
				return true
			end
		end
		return false
	end,
	
	
	--状态
	btype = function(str)
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckBType(hPlayer,str,true)
	end,
	tbtype = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckBType(t,str,true)
	end,
	ttbtype = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC.CheckBType(tt,str,true)
	end,
	detype = function(str)
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckBType(hPlayer,str,false)
	end,
	tdetype = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckBType(t,str,false)
	end,
	ttdetype = function(str)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		return _ZMAC.CheckBType(tt,str,false)
	end,
	
	
	
	
	lastcast = function(str)
		return _ZMAC.CheckLastCast(str)
	end,
	
	nolastcast = function(str)
		return not _ZMAC.CheckLastCast(str)
	end,
	--]]
	
	haveskill =function(szSkillName)
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckHaveSkill(hPlayer,szSkillName)
	end,
	noskill = function(szSkillName)
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckNoSkill(hPlayer,szSkillName)
	end,
	thaveskill =function(szSkillName)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckHaveSkill(t,szSkillName)
	end,
	tnoskill = function(szSkillName)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckNoSkill(t,szSkillName)
	end,
	
	miji=function(szRecipeName)
		return _ZMAC.IsRecipeActive(GetClientPlayer(),szRecipeName)
	end,
	nomiji=function(szRecipeName)
		return not _ZMAC.IsRecipeActive(GetClientPlayer(),szRecipeName)
	end,
	tmiji=function(szRecipeName)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.IsRecipeActive(t,szRecipeName)
	end,
	tnomiji=function(szRecipeName)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.IsRecipeActive(t,szRecipeName)
	end,
	mapname=function(str)
		return _ZMAC.CheckMapName(str)
	end,
	nomapname=function(str)
		return not _ZMAC.CheckMapName(str)
	end,
	mapid=function(str)
		return _ZMAC.CheckMapName(str)
	end,
	nomapid=function(str)
		return not _ZMAC.CheckMapName(str)
	end,
	
	
	player = function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckTarget (t, '$player')
	end,
	noplayer = function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.CheckTarget (t, '$player')
	end,
	
	
	height = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		local me_height = _ZMAC.Decimal(hPlayer.GetAltitude()/494)
		return _ZMAC_Compare(cType, me_height, cNum)
	end,
	
	theight = function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		--if (not t) or (not IsPlayer(t.dwID)) then return false end    --只有玩家才有高度属性，不然报错
		local t_height = 0
		if IsPlayer(t.dwID) then 
			t_height = _ZMAC.Decimal(t.GetAltitude()/494)
		end
		return _ZMAC_Compare(cType, t_height, cNum)
	end,
	
	ttheight = function(cNum, cType)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		local tt_height = 0
		if IsPlayer(tt.dwID) then 
			tt_height = _ZMAC.Decimal(tt.GetAltitude()/494)
		end
		return _ZMAC_Compare(cType, tt_height, cNum)
	end,


	--//参数相关:技能是否可释放
	cancast = function(pSkillName)
		local hPlayer = GetClientPlayer()
		local dwSkillID = tonumber(pSkillName) or _ZMAC.GetSkillIdEx(pSkillName)
		local Skill = GetSkill(dwSkillID, hPlayer.GetSkillLevel(dwSkillID))
		if Skill and Skill.UITestCast(hPlayer.dwID, IsSkillCastMyself(Skill))   then 
			return true 
		end
		return false
		-- local szSkillID = str
		-- if tonumber(szSkillID) then szSkillID = tonumber(szSkillID) end
		-- local ret,_ = _ZMAC.CanUseSkill(szSkillID)
		-- return ret
	end,

	nocancast = function(str)
		return not ZMAC_OptionFunc.cancast(str)
	end,
	cannotcast = function(str)
		return not ZMAC_OptionFunc.cancast(str)
	end,
	
	fly=function()
		local hPlayer = GetClientPlayer()
		return hPlayer.bSprintFlag
	end,
	
	nofly=function()
		local hPlayer = GetClientPlayer()
		return not hPlayer.bSprintFlag
	end,
	
	role = function(str)
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckRole(hPlayer,str)
	end,
	
	norole = function(str)
		local hPlayer = GetClientPlayer()
		return not _ZMAC.CheckRole(hPlayer,str)
	end,
	
	trole = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckRole(t,str)
	end,
	
	tnorole = function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return not _ZMAC.CheckRole(t,str)
	end,
	
	pose=function(str)
		local hPlayer = GetClientPlayer()
		if str == '擎盾' then
			return not ZMAC_OptionFunc.buff('8391')       --8391  盾飞buff
		elseif str == '擎刀' then
			return ZMAC_OptionFunc.buff('8391')
		elseif str == '雾体' or str == '松烟竹雾' or str == '竹雾体' then
			return ZMAC_OptionFunc.buff('10814')
		elseif str == '尘身' or str == '秀明尘身' or str == '尘身体' then
			return ZMAC_OptionFunc.buff('10815')
		elseif str == '雪絮金屏' or str == '金屏' or str == '金屏体' then
			return ZMAC_OptionFunc.buff('10816')
		end
	end,
	
	tpose=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if str == '擎盾' then
			return not ZMAC_OptionFunc.tbuff('8391')       --8391  盾飞buff
		elseif str == '擎刀' then
			return ZMAC_OptionFunc.tbuff('8391')
		end
	end,
	
	
	test = function()
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return true
	end,
	
	inhz=function()
		local t = GetClientPlayer()
		local hd1,hd2,hd3 ={},{},{}       --3个魂灯的坐标
		for k, v in pairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				hd1 = {tmpNpc.nX,tmpNpc.nY}
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				hd2 = {tmpNpc.nX,tmpNpc.nY}
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				hd3 = {tmpNpc.nX,tmpNpc.nY}
			end
		end
		--Output(#hd1,#hd2,#hd3)

		if #hd1~=0 and #hd2~=0 and #hd3~=0 then
			--Output(1112)
			local Sabc = Calc_TriAngleArea(hd1,hd2,hd3)
			local Sabp = Calc_TriAngleArea(hd1,hd2,{t.nX,t.nY})
			local Sacp = Calc_TriAngleArea(hd1,hd3,{t.nX,t.nY})
			local Sbcp = Calc_TriAngleArea(hd2,hd3,{t.nX,t.nY})
			return Sabc == (Sabp + Sacp + Sbcp)
		else
			--Output(111)
			return false	
		end
	end,
	noinhz=function()
		return not ZMAC_OptionFunc.inhz()
	end,

	tinhz=function()
		local t = _ZMAC.checktarget('t')
		if not t then return false end
		local hd1,hd2,hd3 ={},{},{}       --3个魂灯的坐标
		for k, v in ipairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				hd1 = {tmpNpc.nX,tmpNpc.nY}
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				hd2 = {tmpNpc.nX,tmpNpc.nY}
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				hd3 = {tmpNpc.nX,tmpNpc.nY}
			end
		end
		--Output(hd1,hd2,hd3)
		if #hd1~=0 and #hd2~=0 and #hd3~=0 then
			local Sabc = Calc_TriAngleArea(hd1,hd2,hd3)
			local Sabp = Calc_TriAngleArea(hd1,hd2,{t.nX,t.nY})
			local Sacp = Calc_TriAngleArea(hd1,hd3,{t.nX,t.nY})
			local Sbcp = Calc_TriAngleArea(hd2,hd3,{t.nX,t.nY})
			return Sabc == (Sabp + Sacp + Sbcp)
		else
			return false	
		end
	end,

	tnoinhz=function()
		return not ZMAC_OptionFunc.tinhz()
	end,

	tlesshd = function(cNum, cType)
		local t = _ZMAC.checktarget('t')
		if not t then return false  end
		local tDis1,tDis2,tDis3 =999,999,999       --3个魂灯离目标的距离
		for k, v in ipairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis1 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis2 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis3 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			end
		end
	
		local tlesshdNumber = 0 
		if m_min(table.unpack({tDis1,tDis2,tDis3})) == tDis1 then
			tlesshdNumber = 1
		elseif m_min(table.unpack({tDis1,tDis2,tDis3})) == tDis2 then
			tlesshdNumber = 2
		elseif m_min(table.unpack({tDis1,tDis2,tDis3})) == tDis3 then
			tlesshdNumber = 3
		end
		
		if tlesshdNumber>0 then
			return _ZMAC_Compare(cType, tlesshdNumber, cNum)
		end
		
		return false
	end,

	hdnum=function(cNum, cType)
		local hd1,hd2,hd3 =0,0,0      --3个魂灯的坐标
		for k, v in ipairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				hd1 = 1
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				hd2 = 1
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				hd3 = 1
			end
		end
		
		local hdNum = hd1+hd2+hd3
		return _ZMAC_Compare(cType, hdNum, cNum)	
	end,
	
	fxnum=function(cNum, cType)
		local hdNum = 0
		for k, v in pairs(GetAllNpc()) do
			local tmpNpc = v
			
			if tmpNpc.dwModelID == 26069 and GetCharacterDistance(GetClientPlayer().dwID,v.dwID)/64<=35 then 
				hdNum = hdNum +1
			elseif tmpNpc.dwModelID == 26106  and GetCharacterDistance(GetClientPlayer().dwID,v.dwID)/64<=35 then 
				hdNum = hdNum +1
			end
		end
		return _ZMAC_Compare(cType, hdNum, cNum)	
	end,
	
	-- fx1=function()
		-- for k, v in ipairs(GetAllNpc()) do
			-- local tmpNpc = v
			-- if tmpNpc.dwModelID == 26106 and tmpNpc.dwEmployer==GetClientPlayer().dwID  then 
				-- return true
			-- end
		-- end
		-- return false
	-- end,
	-- fx2=function()
		-- for k, v in ipairs(GetAllNpc()) do
			-- local tmpNpc = v
			-- if tmpNpc.dwModelID == 26106 and tmpNpc.dwEmployer==GetClientPlayer().dwID and GetCharacterDistance(GetClientPlayer().dwID,v.dwID)<=35 then 
				-- return true
			-- end
		-- end
		-- return false
	-- end,

	hd1distance = function(cNum, cType)
		local t = GetClientPlayer()
		if not t then return false  end
		local tDis1,tDis2,tDis3 =0,0,0       --3个魂灯离目标的距离
		for k, v in ipairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis1 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis2 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis3 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			end
		end
		
		if tDis1 == 0 then return false end
		return _ZMAC_Compare(cType, tDis1, cNum)	
	end,
	hd2distance = function(cNum, cType)
		local t = GetClientPlayer()
		if not t then return false  end
		local tDis1,tDis2,tDis3 =0,0,0       --3个魂灯离目标的距离
		for k, v in ipairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis1 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis2 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis3 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			end
		end
		
		if tDis2 == 0 then return false end
		return _ZMAC_Compare(cType, tDis2, cNum)	
	end,
	hd3distance = function(cNum, cType)
		local t = GetClientPlayer()
		if not t then return false  end
		local tDis1,tDis2,tDis3 =0,0,0       --3个魂灯离目标的距离
		for k, v in ipairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis1 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis2 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis3 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			end
		end
		
		if tDis3 == 0 then return false end
		return _ZMAC_Compare(cType, tDis3, cNum)	
	end,
	
	thd1distance = function(cNum, cType)
		local t = _ZMAC.checktarget('t')
		if not t then return false  end
		local tDis1,tDis2,tDis3 =0,0,0       --3个魂灯离目标的距离
		for k, v in ipairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis1 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis2 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis3 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			end
		end
		
		if tDis1 == 0 then return false end
		return _ZMAC_Compare(cType, tDis1, cNum)	
	end,
	thd2distance = function(cNum, cType)
		local t = _ZMAC.checktarget('t')
		if not t then return false  end
		local tDis1,tDis2,tDis3 =0,0,0       --3个魂灯离目标的距离
		for k, v in ipairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis1 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis2 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis3 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			end
		end
		
		if tDis2 == 0 then return false end
		return _ZMAC_Compare(cType, tDis2, cNum)	
	end,
	thd3distance = function(cNum, cType)
		local t = _ZMAC.checktarget('t')
		if not t then return false  end
		local tDis1,tDis2,tDis3 =0,0,0       --3个魂灯离目标的距离
		for k, v in ipairs(GetNearbyNpcList()) do
			local tmpNpc = GetNpc(v)
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis1 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis2 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			elseif tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer==GetClientPlayer().dwID then 
				tDis3 =GetCharacterDistance(t.dwID,tmpNpc.dwID)/64
			end
		end
		
		if tDis3 == 0 then return false end
		return _ZMAC_Compare(cType, tDis3, cNum)	
	end,
	
	combo=function(cNum, cType)
		local nComboNum = ComboPanel.nCount
		return _ZMAC_Compare(cType, nComboNum, cNum)
	end,
	
	--减伤系数
	defense=function(cNum, cType)
		local hPlayer = GetClientPlayer()
		local _,_,_,_,_,nReduction = _ZMAC.GetReduction(hPlayer)
		return _ZMAC_Compare(cType, nReduction, cNum)
	end,
	tdefense=function(cNum, cType)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local nReduction = _ZMAC.GetReduction(t)
		return _ZMAC_Compare(cType, nReduction, cNum)
		
	end,
	ttdefense=function(cNum, cType)
		if not _ZMAC.checktarget('tt') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local tt = GetTargetHandle(t.GetTarget())
		local nReduction = _ZMAC.GetReduction(tt)
		return _ZMAC_Compare(cType, nReduction, cNum)
	end,
	--参数尾
}

_TJ={}


_TJ.buff = function(szBuffid)
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					else
						buffName = s
						b[buffName] = nil
						c[buffName] = 0
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	local player = GetClientPlayer()
	if player then
		local pBuffList = GetAllBuff(player)
		for _, v in ipairs(pBuffList) do
			local pBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if pBuffName and a[pBuffName] then
				if b[pBuffName] == "<" and v.nStackNum < c[pBuffName] then
					return true
				elseif b[pBuffName] == ">" and v.nStackNum > c[pBuffName] then
					return true
				elseif b[pBuffName] == "=" and v.nStackNum == c[pBuffName] then
					return true
				elseif not b[pBuffName] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.nobuff = function(szBuffid)
	local bBuffName = {}
	szBuffid = szBuffid.."-"
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)
		if s ~= "" then
			bBuffName[s] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "-")
	end
	local player = GetClientPlayer()
	if player then
		local pBuffList = GetAllBuff(player)
		for _, v in ipairs(pBuffList) do
			local pBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if pBuffName and bBuffName[pBuffName] then
				return false
			end
		end
	end
	return true
end

_TJ.mbuff = function(szBuffid)
	local player = GetClientPlayer()
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					else
						buffName = s
						b[buffName] = nil
						c[buffName] = 0
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if player then
		local pBuffList = GetAllBuff(player)
		for _, v in ipairs(pBuffList) do
			local tBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if tBuffName and a[tBuffName] and GetClientPlayer().dwID == v.dwSkillSrcID then
				if b[tBuffName] == "<" and v.nStackNum < c[tBuffName] then
					return true
				elseif b[tBuffName] == ">" and v.nStackNum > c[tBuffName] then
					return true
				elseif b[tBuffName] == "=" and v.nStackNum == c[tBuffName] then
					return true
				elseif not b[tBuffName] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.buffid = function(szBuffid)
	local player = GetClientPlayer()
	local a = {}
	local b = {}
	local c = {}
	local buffid = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffid = string.sub(s, 1, pos1 - 1)
				b[buffid] = ">"
				c[buffid] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffid = string.sub(s, 1, pos1 - 1)
					b[buffid]= "<"
					c[buffid] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffid = string.sub(s, 1, pos1 - 1)
						b[buffid] = "="
						c[buffid] = tonumber(string.sub(s, pos1 + 1, -1))
					else
						buffid = s
						b[buffid] = nil
						c[buffid] = 0
					end
				end
			end
			a[buffid] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if player then
		local pBuffList = GetAllBuff(player)
		for _, v in ipairs(pBuffList) do
			local tbuffid = tostring(v.dwID)
			if a[tbuffid] then
				if b[tbuffid] == "<" and v.nStackNum < c[tbuffid] then
					return true
				elseif b[tbuffid] == ">" and v.nStackNum > c[tbuffid] then
					return true
				elseif b[tbuffid] == "=" and v.nStackNum == c[tbuffid] then
					return true
				elseif not b[tbuffid] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.nobuffid = function(szBuffid)
	local havebuff = {}
	szBuffid = szBuffid.."-"
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)
		if s ~= "" then
			havebuff[s] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "-")
	end
	local player = GetClientPlayer()
	if player then
		local pBuffList = GetAllBuff(player)
		for _, v in ipairs(pBuffList) do
			local buffid = tostring(v.dwID)
			if havebuff[buffid] then
				return false
			end
		end
	end
	return true
end

_TJ.pose = function(szName)
	if not szName then return false end
	if szName == "擎刀" then
		return _TJ.buffid("8391")
	elseif szName == "擎盾" then
		return _TJ.nobuffid("8391")
	elseif szName == "盾墻" then
		return _TJ.buffid("8300")
	else
		return false
	end
end

_TJ.bufftime = function(szBuffid)		--   *****
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	local player = GetClientPlayer()
	if player then
		local pBuffList = GetAllBuff(player)
		for _, v in ipairs(pBuffList) do
			local pBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if pBuffName and a[pBuffName] then
				if b[pBuffName] == "<" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS < c[pBuffName] then
					return true
				elseif b[pBuffName] == ">" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS > c[pBuffName] then
					return true
				elseif b[pBuffName] == "=" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS == c[pBuffName] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.buffidtime = function(szBuffid)
	local a = {}
	local b = {}
	local c = {}
	local buffid = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffid = string.sub(s, 1, pos1 - 1)
				b[buffid] = ">"
				c[buffid] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffid = string.sub(s, 1, pos1 - 1)
					b[buffid]= "<"
					c[buffid] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffid = string.sub(s, 1, pos1 - 1)
						b[buffid] = "="
						c[buffid] = tonumber(string.sub(s, pos1 + 1, -1))
					end
				end
			end
			a[buffid] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	local player = GetClientPlayer()
	if player then
		local pBuffList = GetAllBuff(player)
		for _, v in ipairs(pBuffList) do
			local pbuffid = tostring(v.dwID)
			if a[pbuffid] then
				if b[pbuffid] == "<" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS < c[pbuffid] then
					return true
				elseif b[pbuffid] == ">" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS > c[pbuffid] then
					return true
				elseif b[pbuffid] == "=" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS == c[pbuffid] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.tbuffid = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local havebuff = {}
	szBuffid = szBuffid.."|"
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)
		if s ~= "" then
			havebuff[s] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local bbuffid = tostring(v.dwID)
			if havebuff[bbuffid] then
				return true
			end
		end
	end
	return false
end

_TJ.tnobuffid = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local havebuff = {}
	szBuffid = szBuffid.."-"
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)
		if s ~= "" then
			havebuff[s] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "-")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local buffid = tostring(v.dwID)
			if havebuff[buffid] then
				return false
			end
		end
	end
	return true
end

_TJ.tbuff = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					else
						buffName = s
						b[buffName] = nil
						c[buffName] = 0
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if tBuffName and a[tBuffName] then
				if b[tBuffName] == "<" and v.nStackNum < c[tBuffName] then
					return true
				elseif b[tBuffName] == ">" and v.nStackNum > c[tBuffName] then
					return true
				elseif b[tBuffName] == "=" and v.nStackNum == c[tBuffName] then
					return true
				elseif not b[tBuffName] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.tnobuff = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local bBuffName = {}
	szBuffid = szBuffid.."-"
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)
		if s ~= "" then
			bBuffName[s] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "-")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if tBuffName and bBuffName[tBuffName] then
				return false
			end
		end
	end
	return true
end

_TJ.tbufftime = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if not target then
		return false
	end
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if tBuffName and a[tBuffName] then
				if b[tBuffName] == "<" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS < c[tBuffName] then
					return true
				elseif b[tBuffName] == ">" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS > c[tBuffName] then
					return true
				elseif b[tBuffName] == "=" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS == c[tBuffName] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.tbuffidtime = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if not target then
		return false
	end
	local a = {}
	local b = {}
	local c = {}
	local buffid = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffid = string.sub(s, 1, pos1 - 1)
				b[buffid] = ">"
				c[buffid] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffid = string.sub(s, 1, pos1 - 1)
					b[buffid]= "<"
					c[buffid] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffid = string.sub(s, 1, pos1 - 1)
						b[buffid] = "="
						c[buffid] = tonumber(string.sub(s, pos1 + 1, -1))
					end
				end
			end
			a[buffid] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tbuffid = tostring(v.dwID)
			if a[tbuffid] then
				if b[tbuffid] == "<" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS < c[tbuffid] then
					return true
				elseif b[tbuffid] == ">" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS > c[tbuffid] then
					return true
				elseif b[tbuffid] == "=" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS == c[tbuffid] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.tmbuff = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					else
						buffName = s
						b[buffName] = nil
						c[buffName] = 0
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if tBuffName and a[tBuffName] and GetClientPlayer().dwID == v.dwSkillSrcID then
				if b[tBuffName] == "<" and v.nStackNum < c[tBuffName] then
					return true
				elseif b[tBuffName] == ">" and v.nStackNum > c[tBuffName] then
					return true
				elseif b[tBuffName] == "=" and v.nStackNum == c[tBuffName] then
					return true
				elseif not b[tBuffName] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.tmbuffid = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local havebuff = {}
	szBuffid = szBuffid.."|"
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)
		if s ~= "" then
			havebuff[s] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local bbuffid = tostring(v.dwID)
			if havebuff[bbuffid] and GetClientPlayer().dwID == v.dwSkillSrcID then
				return true
			end
		end
	end
	return false
end

_TJ.tnombuffid = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local havebuff = {}
	szBuffid = szBuffid.."-"
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)
		if s ~= "" then
			havebuff[s] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "-")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local bbuffid = tostring(v.dwID)
			if havebuff[bbuffid] and GetClientPlayer().dwID == v.dwSkillSrcID then
				return false
			end
		end
	end
	return true
end

_TJ.tnombuff = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."-"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					else
						buffName = s
						b[buffName] = nil
						c[buffName] = 0
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "-")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if tBuffName and a[tBuffName] and GetClientPlayer().dwID == v.dwSkillSrcID then
				if b[tBuffName] == "<" and v.nStackNum < c[tBuffName] then
					return false
				elseif b[tBuffName] == ">" and v.nStackNum > c[tBuffName] then
					return false
				elseif b[tBuffName] == "=" and v.nStackNum == c[tBuffName] then
					return false
				elseif not b[tBuffName] then
					return false
				end
			end
		end
	end
	return true
end

_TJ.totherbuffid = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local havebuff = {}
	szBuffid = szBuffid.."|"
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)
		if s ~= "" then
			havebuff[s] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local bbuffid = tostring(v.dwID)
			if havebuff[bbuffid] and GetClientPlayer().dwID ~= v.dwSkillSrcID then
				return true
			end
		end
	end
	return false
end

_TJ.tnootherbuffid = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local havebuff = {}
	szBuffid = szBuffid.."-"
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)
		if s ~= "" then
			havebuff[s] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "-")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local bbuffid = tostring(v.dwID)
			if havebuff[bbuffid] and GetClientPlayer().dwID ~= v.dwSkillSrcID then
				return false
			end
		end
	end
	return true
end

_TJ.totherbuff = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					else
						buffName = s
						b[buffName] = nil
						c[buffName] = 0
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if tBuffName and a[tBuffName] and GetClientPlayer().dwID ~= v.dwSkillSrcID then
				if b[tBuffName] == "<" and v.nStackNum < c[tBuffName] then
					return true
				elseif b[tBuffName] == ">" and v.nStackNum > c[tBuffName] then
					return true
				elseif b[tBuffName] == "=" and v.nStackNum == c[tBuffName] then
					return true
				elseif not b[tBuffName] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.tnootherbuff = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."-"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					else
						buffName = s
						b[buffName] = nil
						c[buffName] = 0
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "-")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if tBuffName and a[tBuffName] and GetClientPlayer().dwID ~= v.dwSkillSrcID then
				if b[tBuffName] == "<" and v.nStackNum < c[tBuffName] then
					return false
				elseif b[tBuffName] == ">" and v.nStackNum > c[tBuffName] then
					return false
				elseif b[tBuffName] == "=" and v.nStackNum == c[tBuffName] then
					return false
				elseif not b[tBuffName] then
					return false
				end
			end
		end
	end
	return true
end

_TJ.tmbufftime = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if not target then
		return false
	end
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffName = string.sub(s, 1, pos1 - 1)
				b[buffName] = ">"
				c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffName = string.sub(s, 1, pos1 - 1)
					b[buffName]= "<"
					c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffName = string.sub(s, 1, pos1 - 1)
						b[buffName] = "="
						c[buffName] = tonumber(string.sub(s, pos1 + 1, -1))
					end
				end
			end
			a[buffName] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tBuffName = Table_GetBuffName(v.dwID, v.nLevel)
			if tBuffName and a[tBuffName] and GetClientPlayer().dwID == v.dwSkillSrcID then
				if b[tBuffName] == "<" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS < c[tBuffName] then
					return true
				elseif b[tBuffName] == ">" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS > c[tBuffName] then
					return true
				elseif b[tBuffName] == "=" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS == c[tBuffName] then
					return true
				end
			end
		end
	end
	return false
end

_TJ.tmbuffidtime = function(szBuffid)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if not target then
		return false
	end
	local a = {}
	local b = {}
	local c = {}
	local buffID = ""
	szBuffid = szBuffid.."|"--破風>5|流血<5|梅隱香|生陽
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--破風>5
		if s ~= "" then
			local pos1 = StringFindW(s, ">")
			if pos1 then
				buffID = string.sub(s, 1, pos1 - 1)
				b[buffID] = ">"
				c[buffID] = tonumber(string.sub(s, pos1 + 1, -1))
			else
				local pos1 = StringFindW(s, "<")
				if pos1 then
					buffID = string.sub(s, 1, pos1 - 1)
					b[buffID]= "<"
					c[buffID] = tonumber(string.sub(s, pos1 + 1, -1))
				else
					local pos1 = StringFindW(s, "=")
					if pos1 then
						buffID = string.sub(s, 1, pos1 - 1)
						b[buffID] = "="
						c[buffID] = tonumber(string.sub(s, pos1 + 1, -1))
					end
				end
			end
			a[buffID] = true
		end
		szBuffid = string.sub(szBuffid, pos + 1, -1)
		pos = StringFindW(szBuffid, "|")
	end
	if target then
		local tBuffList = GetAllBuff(target)
		for _, v in ipairs(tBuffList) do
			local tBuffID = tostring(v.dwID)
			if tBuffID and a[tBuffID] and GetClientPlayer().dwID == v.dwSkillSrcID then
				if b[tBuffID] == "<" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS < c[tBuffID] then
					return true
				elseif b[tBuffID] == ">" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS > c[tBuffID] then
					return true
				elseif b[tBuffID] == "=" and (v.nEndFrame-GetLogicFrameCount())/GLOBAL.GAME_FPS == c[tBuffID] then
					return true
				end
			end
		end
	end
	return false
end

ZMAC_OptionFunc.stats = function(pstr)
	local hPlayer = GetClientPlayer()
	if s_find(pstr, '-') then
		local szSkillNames = _ZMAC_SplitStr2Array(pstr, '-')
		for _,szSkillName in pairs(szSkillNames) do
			if not ZMAC_OptionFunc.stats(szSkillName) then
				return false
			end
		end
		return true
	end
	
	local strs = _ZMAC_SplitStr2Array(pstr, '|')
	for k,str in pairs(strs) do
		if str =='被控' then
			return _ZMAC.CheckStatus(hPlayer,'halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='不控' then  
			return _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='可控' then
			return not _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid|move|vmove')
		elseif str =='近战' then
			return _ZMAC.CheckMount(hPlayer,'傲血战意|铁牢律|易筋经|洗髓经|问水诀|山居剑意|太虚剑意|焚影圣诀|明尊琉璃体|笑尘诀|分山劲|铁骨衣|北傲诀|凌海诀|隐龙诀')
		elseif str =='远程' then	
			return _ZMAC.CheckMount(hPlayer,'紫霞功|冰心诀|云裳心经|离经易道|花间游|天罗诡道|惊羽诀|补天诀|毒经|莫问|相知|太玄经|无方|灵素')
		elseif str =='内功' then
			return _ZMAC.CheckMount(hPlayer,'易筋经|洗髓经|焚影圣诀|明尊琉璃体|紫霞功|冰心诀|云裳心经|离经易道|花间游|天罗诡道|补天诀|毒经|莫问|相知|太玄经|无方|灵素')
		elseif str =='外功' then
			return _ZMAC.CheckMount(hPlayer,'傲血战意|铁牢律|问水诀|山居剑意|太虚剑意|笑尘诀|惊羽诀|分山劲|铁骨衣|北傲诀|凌海诀|隐龙诀')
		elseif str =='治疗' then
			return _ZMAC.CheckMount(hPlayer,'云裳心经|离经易道|补天诀|相知|灵素')
		elseif str =='输出' then
			return _ZMAC.CheckMount(hPlayer,'傲血战意|问水诀|山居剑意|太虚剑意|紫霞功|笑尘诀|惊羽诀|天罗诡道|分山劲|隐龙诀|易筋经|北傲诀|凌海诀|焚影圣诀|冰心诀|花间游|毒经|莫问|太玄经|无方')	
		elseif str =='有爆发' then
			--return _ZMAC_CheckBuff(hPlayer,'197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083|14352','s',false)
			
			return _TJ.buffid('197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083,14352')
			
		elseif str =='无爆发' then	
			--return not _ZMAC.CheckStats(hPlayer,'有爆发')
			return _TJ.nobuffid('197-538-1378-1728-11456-9744-10175-10213-200-2840-1911-1915-1919-1922-2543-2719-2726-2757-2759-2761-2830-3028-3191-3316-3468-3488-3859-4375-4423-4930-5640-5724-5789-5790-5994-6121-6471-7118-7419-7923-8210-8474-9075-9769-9864-10192-10366-10373-11376-12556-14081-14083-14352')
		elseif str =='有沉默' then
			--return _ZMAC_CheckBuff(hPlayer,'573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091','s',false)
			return _TJ.buffid('573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091')
		elseif str =='无沉默' then	
			--return not _ZMAC.CheckStats(hPlayer,'有沉默')
			return _TJ.nobuffid('573-712-726-1549-2432-20060-18060-17962-15837-3185-3186-4053-5069-8450-9378-10283-11171-12321-14091')
		elseif str =='有反弹' then
			--return _ZMAC_CheckBuff(hPlayer,'388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744','s',false)
			return _TJ.buffid('388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744')
		elseif str =='无反弹' then	
			--return not _ZMAC.CheckStats(hPlayer,'有反弹')
			return _TJ.nobuffid('388-389-390-1152-1561-2792-2793-2794-2795-2796-2797-3198-9804-9805-9806-9807-9808-9809-10486-11980-11981-12612-13744')
		elseif str =='有封内' then
			--return _ZMAC_CheckBuff(hPlayer,'445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592','s',false)
			return _TJ.buffid('445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592')
		elseif str =='无封内' then	
			--return not _ZMAC.CheckStats(hPlayer,'有封内')
			return _TJ.nobuffid('445-557-585-690-692-708-1473-2182-2490-17974-15837-11171-12388-573-575-712-726-4053-8450-9263-10260-9378-14091-2807-2838-3209-3227-3821-7046-7047-7417-9214-9752-10592')
		elseif str =='有封轻功' then
			--return _ZMAC_CheckBuff(hPlayer,'562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246','s',false)
			return _TJ.buffid('562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246')
		elseif str =='无封轻功' then	
			--return not _ZMAC.CheckStats(hPlayer,'有封轻功')
			return _TJ.nobuffid('562-1939-17105-12388-12486-2838-535-4497-8257-6074-10246')
		elseif str =='有减伤' then
			return _TJ.buffid('126|2108|20799|17961|18001|16545|18203|17959|15897|15735|6739|6154|9073|9724|14644|6306|8495|13571|10118|12506|11319|11384|9810|6163|8300|6315|9506|122|9975|4339|9510|9337|3274|134|9534|6361|8291|360|367|368|384|399|684|993|996|1142|1173|1177|1547|1552|1802|2419|2447|2805|2849|2953|2983|3068|3107|3120|3171|3193|3259|3315|3447|3791|3792|4147|4245|4376|4439|4444|4575|5374|5704|5735|5744|5753|5778|5996|6090|6125|6200|6224|6240|6248|6257|6262|6264|6279|6492|6547|6616|6636|6637|7035|7054|7119|7387|7964|8265|8279|8292|8427|8650|8839|9293|9334|9544|9693|9694|9695|9696|9775|9781|9782|9803|9836|9873|9874|10014|10066|10369|11344|12530|13044|13771|14067|14105')
			--local _,_,_,_,_,aa = _ZMAC.GetReduction(GetClientPlayer())
			--return  aa >= 0.3
			
		elseif str =='无减伤' then	
			return _TJ.nobuffid('126-2108-20799-17961-18001-16545-18203-17959-15897-15735-6739-6154-9073-9724-14644-6306-8495-13571-10118-12506-11319-11384-9810-6163-8300-6315-9506-122-9975-4339-9510-9337-3274-134-9534-6361-8291-360-367-368-384-399-684-993-996-1142-1173-1177-1547-1552-1802-2419-2447-2805-2849-2953-2983-3068-3107-3120-3171-3193-3259-3315-3447-3791-3792-4147-4245-4376-4439-4444-4575-5374-5704-5735-5744-5753-5778-5996-6090-6125-6200-6224-6240-6248-6257-6262-6264-6279-6492-6547-6616-6636-6637-7035-7054-7119-7387-7964-8265-8279-8292-8427-8650-8839-9293-9334-9544-9693-9694-9695-9696-9775-9781-9782-9803-9836-9873-9874-10014-10066-10369-11344-12530-13044-13771-14067-14105')
			--local _,_,_,_,_,aa = _ZMAC.GetReduction(GetClientPlayer())
			--return aa <0.3
		elseif str =='有减疗' then
			--return _ZMAC_CheckBuff(hPlayer,'315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103','s',false)
			return _TJ.buffid('315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103')
		elseif str =='无减疗' then	
			--return not _ZMAC.CheckStats(hPlayer,'有减疗')	
			return _TJ.nobuffid('315-17105-18004-9694-9175-2488-6223-6155-9514-2502-574-576-2496-2774-3195-3538-3712-4030-4370-4670-5993-7048-7050-8487-9122-9156-11199-14103')
		elseif str =='有减速' then
			--return _ZMAC_CheckBuff(hPlayer,'450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373','s',false)
			return _TJ.buffid('450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373')
		elseif str =='无减速' then	
			--return not _ZMAC.CheckStats(hPlayer,'有减速')	
			return _TJ.nobuffid('450-461-549-555-560-17888-18061-11262-15956-18046-17581-17897-15802-14137-10001-10861-14186-14154-11245-1097-6275-563-6374-1079-523-3466-6078-6148-6145-6258-4054-4435-9532-9507-13733-584-1534-1720-1850-2297-3115-3148-3226-3484-4297-4816-4928-6130-6191-6987-7548-7549-8299-8398-8492-9217-9777-11168-1373')			
		elseif str =='有免控' then
			--return _ZMAC_CheckBuff(hPlayer,'15565|20780|22111|100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310','s',false)
			return _TJ.buffid('15565|20780|22111|100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310')
		elseif str =='无免控' then	
			--return not _ZMAC.CheckStats(hPlayer,'有免控')	
			return _TJ.nobuffid('15565-20780-22111-100-21202-20698-21276-20199-20666-20072-17901-17882-18189-18075-17888-12534-10118-14972-17939-18418-374-18124-17585-17905-18228-18248-16348-16448-15933-15897-15845-15621-15826-15749-15735-15083-14930-411-14644-14515-6213-14256-14080-13783-13590-13927-14247-14099-13778-412-14155-682-14105-12372-11385-11151-377-677-772-961-2830-3425-3578-855-4245-4439-6182-6219-6279-6284-6292-6314-1018-6369-7699-8265-8302-8303-9068-9107-1186-9534-10247-9934-1676-1686-1856-1862-1863-1903-2072-2544-2718-2756-2781-2840-2847-2951-3025-3026-3138-3275-3279-3376-3677-3822-3983-4033-4421-4449-4468-4672-4729-5653-5654-5725-5731-5733-5747-5754-5950-5995-6001-6015-6087-6131-6192-6247-6291-6361-6373-6459-6489-7979-8247-8293-8300-8449-8455-8458-8468-8483-8495-8716-8742-8864-9059-9294-9342-9354-9509-9510-9511-9567-9848-9855-9999-10186-10245-10258-10264-10417-10633-11077-11204-11319-11322-11361-11808-11991-12481-12559-12665-12857-13735-13742-14082-14273-14356-10130-9693-10173-11336-11335-11310')
		elseif str =='有免伤' then
			--return _ZMAC_CheckBuff(hPlayer,'13744|160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151','s',false)
			return _TJ.buffid('13744|160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151')
		elseif str =='无免伤' then	
			--return not _ZMAC.CheckStats(hPlayer,'有免伤')	
			return _TJ.nobuffid('13744-160-12534-15717-13927-14099-13778-682-6182-961-9534-377-620-772-1740-3091-3425-3759-3851-6000-6213-6580-7929-8303-8371-8438-8624-9158-9835-9934-11151')
		elseif str =='有免死' then
			--return _ZMAC_CheckBuff(hPlayer,'203|6182|10370|12488','s',false)
			return _TJ.buffid('203|6182|10370|12488')
		elseif str =='无免死' then	
			--return not _ZMAC.CheckStats(hPlayer,'有免死')
			return _TJ.nobuffid('203-6182-10370-12488')
		elseif str =='有免封内' then
			--return _ZMAC_CheckBuff(hPlayer,'5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350','s',false)
			return _TJ.buffid('5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350')
		elseif str =='无免封内' then	
			--return not _ZMAC.CheckStats(hPlayer,'有免封内')
			return _TJ.nobuffid('5777-20883-21202-20667-17901-18065-10258-9294-12613-6182-6213-13927-14099-13778-14155-9934-6414-9342-384-5789-8458-6256-8864-8293-377-1186-4439-6279-4245-9999-9509-9506-10173-10618-6350')
		elseif str =='有闪避' then
			--return _ZMAC_CheckBuff(hPlayer,'1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099','s',false)
			return _TJ.buffid('1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099')
		elseif str =='无闪避' then	
			--return not _ZMAC.CheckStats(hPlayer,'有闪避')
			return _TJ.nobuffid('1730-2065-15826-18071-15234-18075-18088-17585-15621-10618-6146-677-6174-6182-10014-2114-2126-3214-4619-4620-5668-5780-6298-6299-6434-8866-9736-9783-9846-10617-11201-13778-14099')
		elseif str =='有免缴械' then
			--return _ZMAC_CheckBuff(hPlayer,'19217|6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414','s',false) 
			return _TJ.buffid('19217|6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414')
		elseif str =='无免缴械' then
			--return not _ZMAC.CheckStats(hPlayer,'有免缴械')	
			return _TJ.nobuffid('19217-6256-21202-20667-17901-1186-12488-10618-8864-5777-19313-9509-9999-9342-9377-1686-1856-12481-5995-11077-13742-15749-15735-18065-6414')
		elseif str =='不可缴械'  then
			return ZMAC_OptionFunc.stats('有免缴械')	
			or ZMAC_OptionFunc.stats('有沉默') 
			or (ZMAC_OptionFunc.stats('有免封内') and ZMAC_OptionFunc.stats('内功'))
			or (ZMAC_OptionFunc.stats('有封内') and ZMAC_OptionFunc.stats('内功'))
		elseif str =='可缴械' then
			--return not ZMAC_OptionFunc.stats('不可缴械')	
			return ZMAC_OptionFunc.stats('无免缴械') and  ZMAC_OptionFunc.stats('无沉默') and (ZMAC_OptionFunc.stats('外功') or (ZMAC_OptionFunc.stats('内功') and ZMAC_OptionFunc.stats('无封内') and ZMAC_OptionFunc.stats('无免封内')))
		elseif str =='有免断'  then
			--return _ZMAC_CheckBuff(hPlayer,'19217|373|20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777','s',false)
			return _TJ.buffid('19217|373|20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777')
		elseif str =='无免断'  then
			--return not _ZMAC.CheckStats(hPlayer,'有免断')
			return _TJ.nobuffid('19217-373-20883-21202-20667-17901-17973-18001-18065-5995-10258-12613-4245-373-8458-9377-376-6350-5789-6256-8864-5777')
		elseif str =='有免推'  then
			--return _ZMAC_CheckBuff(hPlayer,'22145|8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310','s',false)
			return _TJ.buffid('22145|8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310')
		elseif str =='无免推'  then
			--return not _ZMAC.CheckStats(hPlayer,'有免推')	
			return _TJ.nobuffid('22145-8864-21202-20667-20072-2756-10245-2781-377-9934-6213-1903-1856-1686-10130-3425-4439-6279-4245-5754-5995-8265-8303-8483-9509-9693-10173-11151-11336-11361-11385-11319-11322-11335-11310')
		else	
			_ZMAC.PrintRed('MSG_SYS','stats参数错误:-->'..str..'\r\n')
			return false
		end	
	end
	return false
	

end

ZMAC_OptionFunc.tstats = function(p)
	local dwTargetType, dwTargetID = GetClientPlayer().GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return false
	end
	hPlayer = target
	if s_find(p, '-') then
		local szSkillNames = _ZMAC_SplitStr2Array(p, '-')
		for _,szSkillName in pairs(szSkillNames) do
			if not ZMAC_OptionFunc.stats(szSkillName) then
				return false
			end
		end
		return true
	end
	
	local strs = _ZMAC_SplitStr2Array(p, '|')
	for k,str in pairs(strs) do
		if str =='被控' then
			return _ZMAC.CheckStatus(hPlayer,'halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='不控' then  
			return _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='可控' then
			return not _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid|move|vmove')
		elseif str =='近战' then
			return _ZMAC.CheckMount(hPlayer,'傲血战意|铁牢律|易筋经|洗髓经|问水诀|山居剑意|太虚剑意|焚影圣诀|明尊琉璃体|笑尘诀|分山劲|铁骨衣|北傲诀|凌海诀|隐龙诀')
		elseif str =='远程' then	
			return _ZMAC.CheckMount(hPlayer,'紫霞功|冰心诀|云裳心经|离经易道|花间游|天罗诡道|惊羽诀|补天诀|毒经|莫问|相知|太玄经|无方|灵素')
		elseif str =='内功' then
			return _ZMAC.CheckMount(hPlayer,'易筋经|洗髓经|焚影圣诀|明尊琉璃体|紫霞功|冰心诀|云裳心经|离经易道|花间游|天罗诡道|补天诀|毒经|莫问|相知|太玄经|无方|灵素')
		elseif str =='外功' then
			return _ZMAC.CheckMount(hPlayer,'傲血战意|铁牢律|问水诀|山居剑意|太虚剑意|笑尘诀|惊羽诀|分山劲|铁骨衣|北傲诀|凌海诀|隐龙诀')
		elseif str =='治疗' then
			return _ZMAC.CheckMount(hPlayer,'云裳心经|离经易道|补天诀|相知|灵素')
		elseif str =='输出' then
			return _ZMAC.CheckMount(hPlayer,'傲血战意|问水诀|山居剑意|太虚剑意|紫霞功|笑尘诀|惊羽诀|天罗诡道|分山劲|隐龙诀|易筋经|北傲诀|凌海诀|焚影圣诀|冰心诀|花间游|毒经|莫问|太玄经|无方')	
		elseif str =='有爆发' then
			--return _ZMAC_CheckBuff(hPlayer,'197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083|14352','s',false)
			
			return _TJ.tbuffid('197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083,14352')
			
		elseif str =='无爆发' then	
			--return not _ZMAC.CheckStats(hPlayer,'有爆发')
			return _TJ.tnobuffid('197-538-1378-1728-11456-9744-10175-10213-200-2840-1911-1915-1919-1922-2543-2719-2726-2757-2759-2761-2830-3028-3191-3316-3468-3488-3859-4375-4423-4930-5640-5724-5789-5790-5994-6121-6471-7118-7419-7923-8210-8474-9075-9769-9864-10192-10366-10373-11376-12556-14081-14083-14352')
		elseif str =='有沉默' then
			--return _ZMAC_CheckBuff(hPlayer,'573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091','s',false)
			return _TJ.tbuffid('573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091')
		elseif str =='无沉默' then	
			--return not _ZMAC.CheckStats(hPlayer,'有沉默')
			return _TJ.tnobuffid('573-712-726-1549-2432-20060-18060-17962-15837-3185-3186-4053-5069-8450-9378-10283-11171-12321-14091')
		elseif str =='有反弹' then
			--return _ZMAC_CheckBuff(hPlayer,'388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744','s',false)
			return _TJ.tbuffid('388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744')
		elseif str =='无反弹' then	
			--return not _ZMAC.CheckStats(hPlayer,'有反弹')
			return _TJ.tnobuffid('388-389-390-1152-1561-2792-2793-2794-2795-2796-2797-3198-9804-9805-9806-9807-9808-9809-10486-11980-11981-12612-13744')
		elseif str =='有封内' then
			--return _ZMAC_CheckBuff(hPlayer,'445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592','s',false)
			return _TJ.tbuffid('445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592')
		elseif str =='无封内' then	
			--return not _ZMAC.CheckStats(hPlayer,'有封内')
			return _TJ.tnobuffid('445-557-585-690-692-708-1473-2182-2490-17974-15837-11171-12388-573-575-712-726-4053-8450-9263-10260-9378-14091-2807-2838-3209-3227-3821-7046-7047-7417-9214-9752-10592')
		elseif str =='有封轻功' then
			--return _ZMAC_CheckBuff(hPlayer,'562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246','s',false)
			return _TJ.tbuffid('562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246')
		elseif str =='无封轻功' then	
			--return not _ZMAC.CheckStats(hPlayer,'有封轻功')
			return _TJ.tnobuffid('562-1939-17105-12388-12486-2838-535-4497-8257-6074-10246')
		elseif str =='有减伤' then
			return _TJ.tbuffid('126|2108|20799|17961|18001|16545|18203|17959|15897|15735|6739|6154|9073|9724|14644|6306|8495|13571|10118|12506|11319|11384|9810|6163|8300|6315|9506|122|9975|4339|9510|9337|3274|134|9534|6361|8291|360|367|368|384|399|684|993|996|1142|1173|1177|1547|1552|1802|2419|2447|2805|2849|2953|2983|3068|3107|3120|3171|3193|3259|3315|3447|3791|3792|4147|4245|4376|4439|4444|4575|5374|5704|5735|5744|5753|5778|5996|6090|6125|6200|6224|6240|6248|6257|6262|6264|6279|6492|6547|6616|6636|6637|7035|7054|7119|7387|7964|8265|8279|8292|8427|8650|8839|9293|9334|9544|9693|9694|9695|9696|9775|9781|9782|9803|9836|9873|9874|10014|10066|10369|11344|12530|13044|13771|14067|14105')
			--return ZMAC_OptionFunc.tdefense('>0.299')
			
		elseif str =='无减伤' then	
			return _TJ.tnobuffid('126-2108-20799-17961-18001-16545-18203-17959-15897-15735-6739-6154-9073-9724-14644-6306-8495-13571-10118-12506-11319-11384-9810-6163-8300-6315-9506-122-9975-4339-9510-9337-3274-134-9534-6361-8291-360-367-368-384-399-684-993-996-1142-1173-1177-1547-1552-1802-2419-2447-2805-2849-2953-2983-3068-3107-3120-3171-3193-3259-3315-3447-3791-3792-4147-4245-4376-4439-4444-4575-5374-5704-5735-5744-5753-5778-5996-6090-6125-6200-6224-6240-6248-6257-6262-6264-6279-6492-6547-6616-6636-6637-7035-7054-7119-7387-7964-8265-8279-8292-8427-8650-8839-9293-9334-9544-9693-9694-9695-9696-9775-9781-9782-9803-9836-9873-9874-10014-10066-10369-11344-12530-13044-13771-14067-14105')
			--return ZMAC_OptionFunc.tdefense('<0.3')
		elseif str =='有减疗' then
			--return _ZMAC_CheckBuff(hPlayer,'315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103','s',false)
			return _TJ.tbuffid('315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103')
		elseif str =='无减疗' then	
			--return not _ZMAC.CheckStats(hPlayer,'有减疗')	
			return _TJ.tnobuffid('315-17105-18004-9694-9175-2488-6223-6155-9514-2502-574-576-2496-2774-3195-3538-3712-4030-4370-4670-5993-7048-7050-8487-9122-9156-11199-14103')
		elseif str =='有减速' then
			--return _ZMAC_CheckBuff(hPlayer,'450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373','s',false)
			return _TJ.tbuffid('450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373')
		elseif str =='无减速' then	
			--return not _ZMAC.CheckStats(hPlayer,'有减速')	
			return _TJ.tnobuffid('450-461-549-555-560-17888-18061-11262-15956-18046-17581-17897-15802-14137-10001-10861-14186-14154-11245-1097-6275-563-6374-1079-523-3466-6078-6148-6145-6258-4054-4435-9532-9507-13733-584-1534-1720-1850-2297-3115-3148-3226-3484-4297-4816-4928-6130-6191-6987-7548-7549-8299-8398-8492-9217-9777-11168-1373')			
		elseif str =='有免控' then
			--return _ZMAC_CheckBuff(hPlayer,'15565|20780|22111|100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310','s',false)
			return _TJ.tbuffid('15565|20780|22111|100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310')
		elseif str =='无免控' then	
			--return not _ZMAC.CheckStats(hPlayer,'有免控')	
			return _TJ.tnobuffid('15565-20780-22111-100-21202-20698-21276-20199-20666-20072-17901-17882-18189-18075-17888-12534-10118-14972-17939-18418-374-18124-17585-17905-18228-18248-16348-16448-15933-15897-15845-15621-15826-15749-15735-15083-14930-411-14644-14515-6213-14256-14080-13783-13590-13927-14247-14099-13778-412-14155-682-14105-12372-11385-11151-377-677-772-961-2830-3425-3578-855-4245-4439-6182-6219-6279-6284-6292-6314-1018-6369-7699-8265-8302-8303-9068-9107-1186-9534-10247-9934-1676-1686-1856-1862-1863-1903-2072-2544-2718-2756-2781-2840-2847-2951-3025-3026-3138-3275-3279-3376-3677-3822-3983-4033-4421-4449-4468-4672-4729-5653-5654-5725-5731-5733-5747-5754-5950-5995-6001-6015-6087-6131-6192-6247-6291-6361-6373-6459-6489-7979-8247-8293-8300-8449-8455-8458-8468-8483-8495-8716-8742-8864-9059-9294-9342-9354-9509-9510-9511-9567-9848-9855-9999-10186-10245-10258-10264-10417-10633-11077-11204-11319-11322-11361-11808-11991-12481-12559-12665-12857-13735-13742-14082-14273-14356-10130-9693-10173-11336-11335-11310')
		elseif str =='有免伤' then
			--return _ZMAC_CheckBuff(hPlayer,'13744|160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151','s',false)
			return _TJ.tbuffid('13744|160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151')
		elseif str =='无免伤' then	
			--return not _ZMAC.CheckStats(hPlayer,'有免伤')	
			return _TJ.tnobuffid('13744-160-12534-15717-13927-14099-13778-682-6182-961-9534-377-620-772-1740-3091-3425-3759-3851-6000-6213-6580-7929-8303-8371-8438-8624-9158-9835-9934-11151')
		elseif str =='有免死' then
			--return _ZMAC_CheckBuff(hPlayer,'203|6182|10370|12488','s',false)
			return _TJ.tbuffid('203|6182|10370|12488')
		elseif str =='无免死' then	
			--return not _ZMAC.CheckStats(hPlayer,'有免死')
			return _TJ.tnobuffid('203-6182-10370-12488')
		elseif str =='有免封内' then
			--return _ZMAC_CheckBuff(hPlayer,'5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350','s',false)
			return _TJ.tbuffid('5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350')
		elseif str =='无免封内' then	
			--return not _ZMAC.CheckStats(hPlayer,'有免封内')
			return _TJ.tnobuffid('5777-20883-21202-20667-17901-18065-10258-9294-12613-6182-6213-13927-14099-13778-14155-9934-6414-9342-384-5789-8458-6256-8864-8293-377-1186-4439-6279-4245-9999-9509-9506-10173-10618-6350')
		elseif str =='有闪避' then
			--return _ZMAC_CheckBuff(hPlayer,'1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099','s',false)
			return _TJ.tbuffid('1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099')
		elseif str =='无闪避' then	
			--return not _ZMAC.CheckStats(hPlayer,'有闪避')
			return _TJ.tnobuffid('1730-2065-15826-18071-15234-18075-18088-17585-15621-10618-6146-677-6174-6182-10014-2114-2126-3214-4619-4620-5668-5780-6298-6299-6434-8866-9736-9783-9846-10617-11201-13778-14099')
		elseif str =='有免缴械' then
			--return _ZMAC_CheckBuff(hPlayer,'19217|6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414','s',false) 
			return _TJ.tbuffid('19217|6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414')
		elseif str =='无免缴械' then
			--return not _ZMAC.CheckStats(hPlayer,'有免缴械')	
			return _TJ.tnobuffid('19217-6256-21202-20667-17901-1186-12488-10618-8864-5777-19313-9509-9999-9342-9377-1686-1856-12481-5995-11077-13742-15749-15735-18065-6414')
		elseif str =='不可缴械'  then
			return ZMAC_OptionFunc.tstats('有免缴械')	
			or ZMAC_OptionFunc.tstats('有沉默') 
			or (ZMAC_OptionFunc.tstats('有免封内') and ZMAC_OptionFunc.tstats('内功'))
			or (ZMAC_OptionFunc.tstats('有封内') and ZMAC_OptionFunc.tstats('内功'))
		elseif str =='可缴械' then
			--return not ZMAC_OptionFunc.tstats('不可缴械')	
			return ZMAC_OptionFunc.tstats('无免缴械') and  ZMAC_OptionFunc.tstats('无沉默') and (ZMAC_OptionFunc.tstats('外功') or (ZMAC_OptionFunc.tstats('内功') and ZMAC_OptionFunc.tstats('无封内') and ZMAC_OptionFunc.tstats('无免封内')))		
		elseif str =='有免断'  then
			--return _ZMAC_CheckBuff(hPlayer,'19217|373|20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777','s',false)
			return _TJ.tbuffid('19217|373|20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777')
		elseif str =='无免断'  then
			--return not _ZMAC.CheckStats(hPlayer,'有免断')
			return _TJ.tnobuffid('19217-373-20883-21202-20667-17901-17973-18001-18065-5995-10258-12613-4245-373-8458-9377-376-6350-5789-6256-8864-5777')
		elseif str =='有免推'  then
			--return _ZMAC_CheckBuff(hPlayer,'22145|8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310','s',false)
			return _TJ.tbuffid('22145|8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310')
		elseif str =='无免推'  then
			--return not _ZMAC.CheckStats(hPlayer,'有免推')	
			return _TJ.tnobuffid('22145-8864-21202-20667-20072-2756-10245-2781-377-9934-6213-1903-1856-1686-10130-3425-4439-6279-4245-5754-5995-8265-8303-8483-9509-9693-10173-11151-11336-11361-11385-11319-11322-11335-11310')
		else	
			_ZMAC.PrintRed('MSG_SYS','stats参数错误:-->'..str..'\r\n')
			return false
		end	
	end
	return false
	

end


--//
local function SplitRelationSymbol(str,cType)
	local Boolean=false
	local Item=str
	local Type=0
	local Value=''
	local Location = s_find(str, cType)
	if Location then
		Boolean= true
		Item = s_sub(str, 1, Location - 1)
		Type = s_sub(str, Location, Location)
		Value  = s_sub(str, Location + 1, -1)
	end
	return Boolean,Item,Type,Value
end
local function SplitStr2Array(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = s_find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = s_sub(szFullString, nFindStartIndex, s_len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = s_sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + 1
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end
--Single Param Check AND/OR
local function ZMAC_OptionFuncYuHuoHandle(pOption,pStr,cType)
	if pOption == '' then
		_ZMAC.PrintRed('可能存在中括号、逗号、分号中间未写参数的情况。')
		return false
	end
	if not ZMAC_OptionFunc[pOption] then
		if _ZMAC_OPtionDict[pOption] then
			pOption = _ZMAC_OPtionDict[pOption] 
		else
			_ZMAC.PrintRed('无此参数：'.. pOption)
			return false
		end
	end

	if pOption =='rtime' then --时间参数和-|冲突  直接返回
		return ZMAC_OptionFunc[pOption]()
	end
	if  pStr==nil and cType==nil then --如果有3个参数，则此参数为xxx>1的写法，不需要判断-|
		return ZMAC_OptionFunc[pOption]()
	end
	
	if  pStr~=nil and cType~=nil then --如果有3个参数，则此参数为xxx>1的写法，不需要判断-|
		return ZMAC_OptionFunc[pOption](pStr,cType)
	end
	
	--if pStr ~= nil and cType == nil  ,只有一个pStr参数时，判断是否含 - |
	if s_find(pStr,'|') then
		local StrHuos = SplitStr2Array(pStr, '|')
		for _,Strhuo in pairs(StrHuos) do
			if ZMAC_OptionFuncYuHuoHandle(pOption,Strhuo,cType) then 
				return true
			end	
		end
		return false
	end

	if s_find(pStr,'-') then 
		local StrYus =  SplitStr2Array(pStr, '-')
		for _,StrYu in pairs(StrYus) do
			if not ZMAC_OptionFuncYuHuoHandle(pOption,StrYu,cType) then 
				return false
			end	
		end
		return true
	end
	
	if (not s_find(pStr,'|')) and  (not s_find(pStr,'|')) then
		return ZMAC_OptionFunc[pOption](pStr)
	end
	
end
--Whole Param Check AND
local function TestYu(szCondition)	
	szCondition = StringLowerW(szCondition)..","
	szCondition = StringReplaceW(szCondition, " ", "")
	local nEnd = StringFindW(szCondition, ",")
	while nEnd do
		local s = string.sub(szCondition, 1, nEnd - 1)	--buff:xxx|xxx
		local Boolean,Option,cType,cValue=SplitRelationSymbol(s,'[><=:]')
		if Option == nil then 
			Output(s)
		end
		if Boolean then
			if cType==':' then
				if not ZMAC_OptionFuncYuHuoHandle(Option,cValue) then 
					return false
				end
			else
				if not ZMAC_OptionFuncYuHuoHandle(Option,cValue,cType) then 
					return false
				end
			end
		else
			if Option == 'true' then 
				--return true
			elseif Option == 'false' then 
				return false
			elseif not ZMAC_OptionFuncYuHuoHandle(Option) then
				return false
			end
		end

		-- if not bijiao(fn, symbol, num) then
			-- return false
		-- end
		szCondition = string.sub(szCondition, nEnd + 1, -1)
		nEnd = StringFindW(szCondition, ",")
	end
	return true
end
--Whole Param Check OR
local function TestHuo(szCondition)	--buff:aaa|aaa;buff:vvv|vvv,buff:aaa|aaa;
	szCondition = StringLowerW(szCondition)..";"
	szCondition = StringReplaceW(szCondition, " ", "")
	local nEnd = StringFindW(szCondition, ";")
	while nEnd do
		local s = string.sub(szCondition, 1, nEnd - 1)	--buff:xxx|xxx
		if TestYu(s) then
			return true
		end
		szCondition = string.sub(szCondition, nEnd + 1, -1)
		nEnd = StringFindW(szCondition, ";")
	end
	return false
end
--Whole Param Check Brackt
local function TestKuoHao(szCondition)
	local nEnd1 = StringFindW(szCondition, "(")
	local nEnd2 = StringFindW(szCondition, ")")
	if nEnd1 then
		szCondition = string.sub(szCondition, 1, nEnd1 - 1)..tostring(TestHuo(string.sub(szCondition, nEnd1 + 1, nEnd2 - 1)))..TestKuoHao(string.sub(szCondition, nEnd2 + 1, -1))
		return szCondition
	else
		return szCondition
	end
end
--Whole Param Check
local function TestCondition(szCondition)	--條件1,(條件2;條件3),條件4,(條件5;條件6)
	if not szCondition or szCondition == "" then
		return true
	end
	szCondition = TestKuoHao(szCondition)
	return TestHuo(szCondition)
end
--Whole Param Get
local function GetCondition(szContent)
	local szSkill, szCondition = "", ""
	local nEnd = StringFindW(szContent, "[")
	if nEnd then
		szContent = string.sub(szContent, nEnd + 1, -1)
		nEnd = StringFindW(szContent, "]")
		if nEnd then
			szSkill = string.sub(szContent, nEnd + 1, -1)
			szCondition = string.sub(szContent, 1, nEnd - 1)
		end
	else
		szSkill = szContent
	end
	return szCondition, szSkill
end


--//Command
_ZMAC.ChannelProtect = true     --保护引导
_ZMAC.ConfigProtect = true      --Config条件
--/script
local function ExucteScriptCommand(szScript)
	local f = loadstring(szScript)
	if f then
		local r = pcall(f)
		if r ~= true then
			return SKILL_RESULT_CODE.FAILED
		end
	end
	return SKILL_RESULT_CODE.FAILED
end
--/cast
WY.nLastProtectTime = 0

ZMAC.PetStatus = '主动型'

function Cast(szContent,pSelfOnSkill)  
	local szCondition, szSkill = GetCondition(szContent)
	
	local szSelfOnSkill =false
	--if selfFlag ~= nil then szSelfOnSkill = selfFlag end  --selfFlag:因Cast内有循环，可能导致$的自身判定符号无效，所以需要加个参数
	
	local nEnd = StringFindW(szSkill, ",")
	while nEnd do
		local s = string.sub(szSkill, 1, nEnd - 1)
		Cast("["..szCondition.."]"..s)
		szSkill = string.sub(szSkill, nEnd + 1, -1)
		nEnd = StringFindW(szSkill, ",")
	end
	
	if not ConfigFlag then return SKILL_RESULT_CODE.FAILED end  --返回false会导致GetMacroFunction()跳出循环，从而导致宏无法正常向下执行
	if not bIsThisAccount then return SKILL_RESULT_CODE.FAILED end
	
	
	
	
	if s_find(szSkill,'%$')~=nil then
		szSkill = s_gsub(szSkill,'%$','') 
		--Output(szSkill)
		szSelfOnSkill =true
	end
	
	
	
	szSkill = StringReplaceW(szSkill, " ", "")
	
	if ZMAC.Switch[szSkill] ==false then return SKILL_RESULT_CODE.FAILED end
	local player = GetClientPlayer()
	
	if  TestCondition(szCondition)   then
		
		local pos = StringFindW(szSkill, ":")
		if pos and string.sub(szSkill, 1, pos - 1) == "pet" then
			szSkill = string.sub(szSkill, pos + 1, -1)
			local dwID = g_SkillNameToID[szSkill]
			
			
			local dwLevel = 1
			local pet = player.GetPet()
			if pet then
				if szSkill == "攻击" then
					if not WY.IsCD(2442, 1) then
						pet.CastSkill(2442, 1)
						return SKILL_RESULT_CODE.FAILED
					end
				else
					if not WY.IsCD(dwID, dwLevel) then
						_ZMAC.UseSkill(dwID)
						return SKILL_RESULT_CODE.FAILED
					end
				end
			end
		end
		if pos and string.sub(szSkill, 1, pos - 1) == "puppet" then
			szSkill = string.sub(szSkill, pos + 1, -1)
			local dwLevel = 1
			local dwID = 0
			local QianJiBian = GetNpc(player.dwBatteryID)
			if not QianJiBian then
				return
			else
				if szSkill == "攻击" then
					dwID = 3360
				elseif szSkill == "停止" then
					dwID = 3382
				elseif szSkill == "连弩形态" then
					dwID = 3368
				elseif szSkill == "重弩形态" then
					dwID = 3369
				elseif szSkill == "毒刹形态" then
					dwID = 3370
				end
				if not WY.IsCD(dwID, dwLevel) then
					_ZMAC.UseSkill(dwID)
					return SKILL_RESULT_CODE.FAILED
				end
			end
		end
		local bPrePare, dwIDx, dwLevelx, fPx = GetClientPlayer().GetOTActionState()
		
		if bProtectChannel == true  and  (bPrePare~= 0  or GetTickCount() - WY.nLastOtaTime < 50)  and szSkill~='中断读条' and szSkill~='释放蓄力' then -- 
			return SKILL_RESULT_CODE.FAILED
		end

		if _ZMAC.FakeSkillList[szSkill]  then	
			return  _ZMAC.ExcuteFakeCommand(szSkill)
		end
		
		if szSkill == '遁影' then
			ChangGeShadow.ReleaseShadowSkill(1)
			return SKILL_RESULT_CODE.FAILED
		end
		
		
		local dwID = 0
		local dwIDback = 0
		if tonumber(szSkill) then 
			dwID = tonumber(szSkill) 
		else 
			dwIDback , dwID =  _ZMAC.GetSkillIdEx(szSkill)
			if dwID== nil then
				dwID = dwIDback
			end
		end
		
		
		if dwID and type(dwID)=='table' then
			local castRet = -1
			for k,v in pairs(dwID) do
				local Skill222 = GetSkill(v, GetClientPlayer().GetSkillLevel(v))
				if Skill222 and Skill222.UITestCast(GetClientPlayer().dwID, IsSkillCastMyself(Skill222)) and (not s_find(Table_GetSkillDesc(v,GetClientPlayer().GetSkillLevel(v)),'招式已删除')) then
					
					if szSelfOnSkill ==true then
						castRet = CastSelf(tostring(v))
						
					else
						castRet = Cast(tostring(v)) --,szSelfOnSkill
					end
					
					if castRet == SKILL_RESULT_CODE.SUCCESS and v ~= 17587 and v ~= 17588 then
						return castRet
						--break
					end
				end
			end
			return SKILL_RESULT_CODE.FAILED
		end
		
		local dwLevel = player.GetSkillLevel(dwID)
		
		
		
		if  s_find(Table_GetSkillDesc(dwID,dwLevel),'招式已删除') then 
			return SKILL_RESULT_CODE.FAILED
		end

		FireUIEvent("HELP_EVENT","OnUseSkill",dwID,dwLevel)
		--FireHelpEvent("OnUseSkill", _ARG_0_, 1)
		FireUIEvent("ON_RLCMD","stop local origin sfx")
		--rlcmd("stop local origin sfx")
		
		local skill = GetSkill(dwID, dwLevel)
		
		local IsCanUseSkill, IsChannelSkill = _ZMAC.CanUseSkill(dwID)
		--Output(dwID,Table_GetSkillName(dwID, 1),IsCanUseSkill)
		--2022.6.12,此处有BUG，在GCD期间，充能技能会判断为true，而非充能判定为false，会导致此时优先释放宏语句中位置靠后的读条技能，
		--[[例如：/cast 三星临
				  /cast 天斗旋
		--待解决]] 
		if IsCanUseSkill ==true  then 
			local name = Table_GetSkillName(dwID, 1)
			
			if SelfProtectSkill[name]~=nil then
				WY.nLastOtaTime = GetTickCount()
			end
			--Output(dwID, szSelfOnSkill)
			return _ZMAC.ExcuteRealCommand(dwID, szSelfOnSkill)
		end
	end
	return SKILL_RESULT_CODE.FAILED	
end

function CastSelf(szContent)  
	local szCondition, szSkill = GetCondition(szContent)
	
	local szSelfOnSkill =true
	--if selfFlag ~= nil then szSelfOnSkill = selfFlag end  --selfFlag:因Cast内有循环，可能导致$的自身判定符号无效，所以需要加个参数
	
	local nEnd = StringFindW(szSkill, ",")
	while nEnd do
		local s = string.sub(szSkill, 1, nEnd - 1)
		Cast("["..szCondition.."]"..s)
		szSkill = string.sub(szSkill, nEnd + 1, -1)
		nEnd = StringFindW(szSkill, ",")
	end
	
	if not ConfigFlag then return SKILL_RESULT_CODE.FAILED end  --返回false会导致GetMacroFunction()跳出循环，从而导致宏无法正常向下执行
	if not bIsThisAccount then return SKILL_RESULT_CODE.FAILED end

	-- if s_find(szSkill,'%$')~=nil then
		-- szSkill = s_gsub(szSkill,'%$','') 
		-- szSelfOnSkill =true
	-- end

	szSkill = StringReplaceW(szSkill, " ", "")
	
	if ZMAC.Switch[szSkill] ==false then return SKILL_RESULT_CODE.FAILED end
	local player = GetClientPlayer()
	
	if  TestCondition(szCondition)   then
		
		local pos = StringFindW(szSkill, ":")
		if pos and string.sub(szSkill, 1, pos - 1) == "pet" then
			szSkill = string.sub(szSkill, pos + 1, -1)
			local dwID = g_SkillNameToID[szSkill]
			
			
			local dwLevel = 1
			local pet = player.GetPet()
			if pet then
				if szSkill == "攻击" then
					if not WY.IsCD(2442, 1) then
						pet.CastSkill(2442, 1)
						return SKILL_RESULT_CODE.FAILED
					end
				else
					if not WY.IsCD(dwID, dwLevel) then
						_ZMAC.UseSkill(dwID)
						return SKILL_RESULT_CODE.FAILED
					end
				end
			end
		end
		if pos and string.sub(szSkill, 1, pos - 1) == "puppet" then
			szSkill = string.sub(szSkill, pos + 1, -1)
			local dwLevel = 1
			local dwID = 0
			local QianJiBian = GetNpc(player.dwBatteryID)
			if not QianJiBian then
				return
			else
				if szSkill == "攻击" then
					dwID = 3360
				elseif szSkill == "停止" then
					dwID = 3382
				elseif szSkill == "连弩形态" then
					dwID = 3368
				elseif szSkill == "重弩形态" then
					dwID = 3369
				elseif szSkill == "毒刹形态" then
					dwID = 3370
				end
				if not WY.IsCD(dwID, dwLevel) then
					_ZMAC.UseSkill(dwID)
					return SKILL_RESULT_CODE.FAILED
				end
			end
		end
		local bPrePare, dwIDx, dwLevelx, fPx = GetClientPlayer().GetOTActionState()
		
		if bProtectChannel == true  and  (bPrePare~= 0  or GetTickCount() - WY.nLastOtaTime < 50)  and szSkill~='中断读条' and szSkill~='释放蓄力' then -- 
			return SKILL_RESULT_CODE.FAILED
		end

		if _ZMAC.FakeSkillList[szSkill]  then	
			return  _ZMAC.ExcuteFakeCommand(szSkill)
		end
		
		if szSkill == '遁影' then
			ChangGeShadow.ReleaseShadowSkill(1)
			return SKILL_RESULT_CODE.FAILED
		end
		
		
		local dwID = 0
		local dwIDback = 0
		if tonumber(szSkill) then 
			dwID = tonumber(szSkill) 
		else 
			dwIDback , dwID =  _ZMAC.GetSkillIdEx(szSkill)
			if dwID== nil then
				dwID = dwIDback
			end
		end
		
		
		if dwID and type(dwID)=='table' then
			local castRet = -1
			for k,v in pairs(dwID) do
				local Skill222 = GetSkill(v, GetClientPlayer().GetSkillLevel(v))
				if Skill222 and Skill222.UITestCast(GetClientPlayer().dwID, IsSkillCastMyself(Skill222)) and (not s_find(Table_GetSkillDesc(v,GetClientPlayer().GetSkillLevel(v)),'招式已删除')) then
					
					
					castRet = CastSelf(tostring(v)) --,szSelfOnSkill
					if castRet == SKILL_RESULT_CODE.SUCCESS and v ~= 17587 and v ~= 17588 then
						return castRet
						--break
					end
				end
			end
			return SKILL_RESULT_CODE.FAILED
		end
		
		local dwLevel = player.GetSkillLevel(dwID)
		
		if  s_find(Table_GetSkillDesc(dwID,dwLevel),'招式已删除') then 
			return SKILL_RESULT_CODE.FAILED
		end

		FireUIEvent("HELP_EVENT","OnUseSkill",dwID,dwLevel)
		--FireHelpEvent("OnUseSkill", _ARG_0_, 1)
		FireUIEvent("ON_RLCMD","stop local origin sfx")
		--rlcmd("stop local origin sfx")
		
		local skill = GetSkill(dwID, dwLevel)
		
		local IsCanUseSkill, IsChannelSkill = _ZMAC.CanUseSkill(dwID)

		if IsCanUseSkill ==true  then 
			local name = Table_GetSkillName(dwID, 1)
			
			if SelfProtectSkill[name]~=nil then
				WY.nLastOtaTime = GetTickCount()
			end
			--Output(dwID, szSelfOnSkill)
			return _ZMAC.ExcuteRealCommand(dwID, szSelfOnSkill)
		end
	end
	return SKILL_RESULT_CODE.FAILED	
end



--/cast GameSkill
function _ZMAC.ExcuteRealCommand(szSkillID, szSelfSkill)
	
	--if szSkillID==28594 then return end   --明教不允许释放BUG日月晦
	
	local hPlayer = GetClientPlayer()
	local dwType, dwID = hPlayer.GetTarget()
	-- if dwType and dwType == TARGET.PLAYER then --玩家类型返回.锁？
		-- return
	-- end
	local hTarget = GetTargetHandle(dwType, dwID)        
	-- if not hTarget then return false end           --youbug，这样写会导致无目标时不释放轻功等技能
	local nSkillLevel = hPlayer.GetSkillLevel(szSkillID)
	if nSkillLevel <= 0 then nSkillLevel = 1 end
	local hSkill = GetSkill(szSkillID, nSkillLevel)
	
	--Output(hSkill,hSkill.nCastMode,SKILL_CAST_MODE.POINT_AREA)
	
	FireUIEvent("HELP_EVENT","OnUseSkill",szSkillID,nSkillLevel)
	FireUIEvent("HELP_EVENT","CastSkillXYZ",szSkillID,nSkillLevel)
	--FireHelpEvent("OnUseSkill", _ARG_0_, 1)
	FireUIEvent("ON_RLCMD","stop local origin sfx")
	--rlcmd("stop local origin sfx")
	
	
    --Output(hSkill.nCastMode,SKILL_CAST_MODE.POINT_AREA,szSelfSkill)
	
	if hSkill and hSkill.nCastMode ~= SKILL_CAST_MODE.POINT_AREA then--OnUseSkill(szSkillID, nSkillLevel)
		local bTargetSelf = IsSkillCastMyself(hSkill) or false
		if szSelfSkill then	
			--return OnUseSkill(szSkillID, szSkillID * (szSkillID % 10 + 1))
			return _ZMAC.OnUseSkillToMyselfOnce(szSkillID)
		elseif hSkill.bHoardSkill then            --密藏技能？
			return OnUseSkill(szSkillID, nSkillLevel, nil, true) 
		else 
			--return CastSkill(szSkillID, nSkillLevel, bTargetSelf)
			return OnUseSkill(szSkillID, szSkillID * (szSkillID % 10 + 1))
		end
		
		FireUIEvent("HELP_EVENT","OnUseSkill",szSkillID,nSkillLevel)
		--FireHelpEvent("OnUseSkill", _ARG_0_, 1)
		FireUIEvent("ON_RLCMD","stop local origin sfx")
		--rlcmd("stop local origin sfx")
	
	elseif hSkill and hSkill.nCastMode == SKILL_CAST_MODE.POINT_AREA then
		--Output(szSkillID,hSkill.nCastMode,SKILL_CAST_MODE.POINT_AREA,hSkill.nCastMode==SKILL_CAST_MODE.POINT_AREA )
		if szSelfSkill then
			--Output(szSkillID,nSkillLevel, hPlayer.nX, hPlayer.nY, hPlayer.nZ,hPlayer.szName)
			return CastSkillXYZ(szSkillID, nSkillLevel, hPlayer.nX, hPlayer.nY, hPlayer.nZ)
		else 
			if not hTarget then
				return SKILL_RESULT_CODE.FAILED
			end
			return CastSkillXYZ(szSkillID, nSkillLevel, hTarget.nX, hTarget.nY, hTarget.nZ)
		end
		
		FireUIEvent("HELP_EVENT","CastSkillXYZ",szSkillID,nSkillLevel)
		--FireHelpEvent("CastSkillXYZ", _ARG_0_, 1)
		FireUIEvent("ON_RLCMD","stop local origin sfx")
		--rlcmd("stop local origin sfx")
		
		
	end
end
--/cast GameSkill→Self
_ZMAC.OnUseSkillToMyselfOnce=function(pSkillID)

	local hPlayer = GetClientPlayer()
	local t = GetTargetHandle(hPlayer.GetTarget())
	local tType , tId = hPlayer.GetTarget()
	
	local nSkillLevel = hPlayer.GetSkillLevel(szSkillID)
	FireUIEvent("HELP_EVENT","OnUseSkill",pSkillID,nSkillLevel)
	FireUIEvent("HELP_EVENT","CastSkillXYZ",szSkillID,nSkillLevel)
	--FireHelpEvent("OnUseSkill", _ARG_0_, 1)
	FireUIEvent("ON_RLCMD","stop local origin sfx")
	--rlcmd("stop local origin sfx")
	if not t then  
		--_ZMAC_SelTarget(GetClientPlayer().dwID)  --2021.9.19 所有带$和/castEx会卡顿，疑似是因为_ZMAC_SelTarget()会无限遍历所有玩家和npc导致，效率极低
		SetTarget(TARGET.PLAYER ,GetClientPlayer().dwID)
		local aaa = OnUseSkill(pSkillID, pSkillID * (pSkillID % 10 + 1))
		--_ZMAC_SelTarget(0)
		
		
		SetTarget(tType , tId )
		return aaa
	else 
		--_ZMAC_SelTarget(GetClientPlayer().dwID)
		SetTarget(TARGET.PLAYER ,GetClientPlayer().dwID)
		local bbb = OnUseSkill(pSkillID, pSkillID * (pSkillID % 10 + 1))
		--_ZMAC_SelTarget(t.dwID)
		
		SetTarget(tType , tId )
		return bbb
	end
end
--/cast CustomSkill
function _ZMAC.ExcuteFakeCommand(cmd)
	if cmd=='返回登录' then
		ReInitUI(1)
	elseif cmd == '日月晦·隐' then	
		OnUseSkill(28594, 28594 * (28594 % 10 + 1))  
		return SKILL_RESULT_CODE.FAILED
		
	elseif cmd == '日月晦一段假' then	
		local hPlayer=GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local angle= GetLogicDirection(t.nX - hPlayer.nX, t.nY - hPlayer.nY)
		if (not t  or t ==hPlayer ) then 
			--return OnUseSkill(28593, 28593 * (28593 % 10 + 1))  
			TurnTo(angle)
			return CastSkillXYZ(28593, 1, hPlayer.nX, hPlayer.nY, hPlayer.nZ)
		end
		
		TurnTo(angle)
		CastSkillXYZ(28593, 1, t.nX, t.nY, t.nZ)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '日月晦二段假' then	
		local hPlayer=GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local angle= GetLogicDirection(t.nX - hPlayer.nX, t.nY - hPlayer.nY)
		if (not t  or t ==hPlayer ) then 
			--return OnUseSkill(28595, 28595 * (28595 % 10 + 1))  
			TurnTo(angle)
			return CastSkillXYZ(28595, 1, hPlayer.nX, hPlayer.nY, hPlayer.nZ) 
		end
		TurnTo(angle)
		CastSkillXYZ(28595, 1, t.nX, t.nY, t.nZ)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '日月晦三段假' then	
		local hPlayer=GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		local angle= GetLogicDirection(t.nX - hPlayer.nX, t.nY - hPlayer.nY)
		if (not t  or t ==hPlayer ) then 
			--return OnUseSkill(28596, 28596 * (28596 % 10 + 1))  
			TurnTo(angle)
			return CastSkillXYZ(28596, 1, hPlayer.nX, hPlayer.nY, hPlayer.nZ)
		end
		
		TurnTo(angle)
		CastSkillXYZ(28596, 1, t.nX, t.nY, t.nZ)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '全局转火' then
		_ZMAC.SelcectDyingEnemy()
		return SKILL_RESULT_CODE.FAILED
	elseif 	cmd == '自动魂灯' then
		_ZMAC.AutoHunDeng()
		return SKILL_RESULT_CODE.FAILED	
	elseif 	cmd == '全局打断' then
		_ZMAC.GlobalBroken()
		return SKILL_RESULT_CODE.FAILED		
	elseif 	cmd == '全局断奶' then
		_ZMAC.GlobalBrokenHealer()
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == '全局群人' then
		_ZMAC.SelectGatherEnemy()
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '全局治疗' then
		_ZMAC.SelectDyingParty()
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == '全局决斗' then
		_ZMAC.GlobalJuedou()
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == '飞星·改' then
		local x1,y1,z1 = GetClientPlayer().nX,GetClientPlayer().nY,GetClientPlayer().nZ
		Output(x1,y1,z1)
		local ret = _ZMAC.UseSkill(17587)
		
		-- if ret ~= SKILL_RESULT_CODE.SUCCESS then  --ret不准
			-- ret = _ZMAC.UseSkill(17588)
		-- end
		_ZMAC.DelayCall(100,function()
			local x2,y2,z2 = GetClientPlayer().nX,GetClientPlayer().nY,GetClientPlayer().nZ
			if x2==x1 then
				_ZMAC.UseSkill(17588)
			end
		end)
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == '全局蚀奶' then
		_ZMAC.GlobalShixinHealer()
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == '中断读条' or cmd == '打断自己' then
		--local bPrePare, dwID, dwLevel, fP = hPlayer.GetSkillOTActionState()
		local hPlayer = GetClientPlayer()
		local retxxx,bPrePare, dwID, dwLevel, fP = pcall(hPlayer.GetSkillOTActionState)
		if retxxx ==false then --缘起
			bPrePare, dwID, dwLevel, fP = GetClientPlayer().GetSkillPrepareState()   
			if bPrePare==false then bPrePare =0 end
		end
		if bPrePare >0 then
			hPlayer.StopCurrentAction()
		end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '停止执行' then
		--local bPrePare, dwID, dwLevel, fP = hPlayer.GetSkillOTActionState()
		local retxxx,bPrePare, dwID, dwLevel, fP = pcall(hPlayer.GetSkillOTActionState)
		if retxxx ==false then --缘起
			bPrePare, dwID, dwLevel, fP = GetClientPlayer().GetSkillPrepareState()   
			if bPrePare==false then bPrePare =0 end
		end
		if bPrePare == 1 then
			hPlayer.StopCurrentAction()
		end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '停止移动' then
		--Camera_EnableControl(CONTROL_FORWARD, false)
		--MoveForwardStop()
		--Camera_EnableControl(CONTROL_BACKWARD, false)
		--MoveBackwardStop()
		
		MoveAction_StopAll()
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '面对目标' then
		local hPlayer=GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if (not t  or t ==hPlayer ) then return SKILL_RESULT_CODE.FAILED end
		local angle= GetLogicDirection(t.nX - hPlayer.nX, t.nY - hPlayer.nY)
		TurnTo(angle)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '背对目标' then
		local hPlayer=GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if not t then return end
		local backangle= GetLogicDirection(hPlayer.nX-t.nX ,hPlayer.nY- t.nY )
		TurnTo(backangle)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '向前移动' then
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		Cast('停止移动')
		Camera_EnableControl(CONTROL_FORWARD, true)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '向后移动' then
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		Cast('停止移动')
		Camera_EnableControl(CONTROL_BACKWARD, true)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '自动绕背' then
		if not GetTargetHandle(GetClientPlayer().GetTarget()) then Camera_EnableControl(CONTROL_FORWARD, false) end
		if ZMAC_OptionFunc.tnodead() and ZMAC_OptionFunc.nobuff('怖畏暗刑-剑飞惊天-雷云-井仪-霞流宝石') and ZMAC_OptionFunc.tdistance('30','<') then
			Cast('面对目标')
			Cast('跟随目标')
			Cast('[tdistance<2,trange,nobuff:暗尘弥散] 向前移动')
			Cast('[tdistance<0.9,tnorange] 停止移动')
		end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '选择自己' then
		_ZMAC_SelTarget(GetClientPlayer().dwID)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '轻功躲避' then
		Cast('迎风回浪')
		Cast('凌霄揽胜')
		Cast('瑶台枕鹤')
		Cast('后跳')
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '破魔' then 
		_ZMAC.CancelBuff(4439)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '破盾' then
		_ZMAC.CancelBuff(8300)
		_ZMAC.CancelBuff(8265)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '破壁' then
		_ZMAC.CancelBuff(8279)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '下马' then
		_ZMAC.CancelBuff(244)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '跟随目标' then
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		AutoMoveToTarget(GetClientPlayer().GetTarget())
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '小轻功' then
		return _ZMAC.UseXiaoQingGong()
	elseif cmd == '测试' then
		Output('测试成功')
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '跳' then
		Jump()
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '向上轻功' or cmd == '向前轻功' or cmd == '向后轻功' or cmd == '向前上轻功' or cmd == '向后上轻功' then
		return _ZMAC.AppointQingGong(cmd)
	elseif cmd == '秒无狗' then
		
		-- local hPlayer = GetClientPlayer()
		-- local szSkillID = 5354 --秒无狗是拨狗之后无法亢龙才去想着接秒无狗的
		-- local SkillLevel = hPlayer.GetSkillLevel(szSkillID)
		-- if SkillLevel < 1 then SkillLevel = 1 end
		-- local Skill = GetSkill(szSkillID, SkillLevel)
		-- if Skill.UITestCast(hPlayer.dwID, IsSkillCastMyself(Skill)) then
			_ZMAC.ExcuteRealCommand(5260) --天下无狗
			GetControlPlayer().CastHoardSkill()
		--end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '释放蓄力' then
		-- local hPlayer = GetClientPlayer()
		-- local bPrepare ,_,_,_ = _ZMAC.GetOta(hPlayer)
		-- Output(bPrepare,tonumber(bPrePare) ==9)
		-- if bPrePare ==9 then
			GetControlPlayer().CastHoardSkill()
		--end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '烟雨行前' then	
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		local xxx =5505
		OnUseSkill(xxx, xxx * (xxx % 10 + 1))  
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '烟雨行后' then	
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		local xxx =5506
		OnUseSkill(xxx, xxx * (xxx % 10 + 1))  
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '烟雨行左' then	
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		local xxx =5507
		OnUseSkill(xxx, xxx * (xxx % 10 + 1))  
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '烟雨行右' then	
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		local xxx =5508
		OnUseSkill(xxx, xxx * (xxx % 10 + 1))  
		return SKILL_RESULT_CODE.FAILED
	end
	
	return SKILL_RESULT_CODE.FAILED
end
--/roll
local nLastTime = 0
local function Roll(szRollNumber)
	local nCurrentTime = GetCurrentTime()
	if nCurrentTime - nLastTime < 2 then
		return
	end
	nLastTime = nCurrentTime
	--[[
	宏命令幫助：如/ROLL ? 或者/ROLL HELP，？支持中英文，HELP支持大小寫，希望以后所有的宏命令都統一加上幫助。
	--]]
	--
	local lowRollNumber = string.lower(szRollNumber)
	if lowRollNumber == "help" or lowRollNumber == "?" or lowRollNumber == "？" then
		OutputMessage("MSG_SYS", tHelp["roll"] .. "\n")
		return
	end
	--幫助結束
	local nDefaultMin, nDefaultMax = 1, 100

	if not szRollNumber or szRollNumber == "" then							--沒有參數
		RemoteCallToServer("ClientNormalRoll", nDefaultMin, nDefaultMax)
		return
	end

	local szRolllow, szRollHigh = szRollNumber:match("^%s*(%d+)%s*(%d*)%s*$")

	if not szRolllow or szRolllow == "" then								--沒有參數
		RemoteCallToServer("ClientNormalRoll", nDefaultMin, nDefaultMax)
		return
	end

	if not szRollHigh or szRollHigh == "" then								--是否有第二個參數
		szRollHigh = szRolllow
		szRolllow = tostring(nDefaultMin)
	end

	local nRolllow = tonumber(szRolllow:sub(1,5))
	local nRollHigh = tonumber(szRollHigh:sub(1,5))

	if nRolllow and nRollHigh and nRolllow < nRollHigh then				--第二個參數是否合法
		RemoteCallToServer("ClientNormalRoll", nRolllow, nRollHigh)
	else
		RemoteCallToServer("ClientNormalRoll", nDefaultMin, nDefaultMax)
	end
end
--/help
local function Help(szWhichOne)
	local szLowString = string.lower(szWhichOne)
	local szHelp = aCommandHelp[szLowString]
	if not szHelp or szHelp == "" then
		szHelp = g_tStrings.HELPME_HELP
	end

	if szHelp and szHelp ~= "" then
		OutputMessage("MSG_SYS", szHelp .. "\n")
	end
	return SKILL_RESULT_CODE.FAILED
end
--/call
function MacroCall(szName)
	for k, t in pairs(g_Macro) do
		if t.szName == tostring(szName) then
			ExcuteMacroByID(k)
			break
		end
	end
	return SKILL_RESULT_CODE.FAILED
end
--/msg
function myMessage(szMessage)
	OutputMessage("MSG_SYS", "[提示] " .. tostring(szMessage) .. "\n")
	OutputMessage("MSG_ANNOUNCE_YELLOW", "[提示] " .. tostring(szMessage))
	return SKILL_RESULT_CODE.FAILED
end
--/use
function Use(szContent)
	local szCondition, szItem = GetCondition(szContent)
	if TestCondition(szCondition) then
		while string.sub(szItem, 1, 1) == " " do
			szItem = string.sub(szItem, 2, -1)
		end

		while string.sub(szItem, -1, -1) == " " do
			szItem = string.sub(szItem, 1, -2)
		end

		local t = g_ItemNameToID[szItem]
		if t then
	    	local dwBox, dwX = GetClientPlayer().GetItemPos(t[1], t[2])
	    	if dwBox and dwX then
	    		OnUseItem(dwBox, dwX)
				
	    	end
		end
	end
	return SKILL_RESULT_CODE.FAILED
end
--/cancelbuff
local function CancelBuff(szContent)
	local szCondition, szBuff = GetCondition(szContent)
	if TestCondition(szCondition) then
		while string.sub(szBuff, 1, 1) == " " do
			szBuff = string.sub(szBuff, 2, -1)
		end

		while string.sub(szBuff, -1, -1) == " " do
			szBuff = string.sub(szBuff, 1, -2)
		end

		_ZMAC.CancelBuff(szBuff)
		
	end
	return SKILL_RESULT_CODE.FAILED
end
--/target  /player  /select
WY.PrevTarget = 0
local function MacroTarget(szContent)
	local szCondition, szContent = GetCondition(szContent)
	if szContent ~= "" then
		szContent = StringReplaceW(szContent, " ", "")
	end

	if TestCondition(szCondition) then
		if szContent == "$myname" then
			SelectSelf()
			return
		end
		_ZMAC_SelTarget(szContent)
		
	end
	return SKILL_RESULT_CODE.FAILED
end
--/config
local function Config(szContent)
	if szContent ~= "" then
		szContent = StringReplaceW(szContent, " ", "")
	end
	if szContent == "null" then
		ConfigFlag = true
	elseif szContent == "保护引导" then
		bProtectChannel = true
	elseif szContent == "不保护引导" then
		bProtectChannel = false
	else
		local szCondition = string.sub(szContent, 2, -2)
		ConfigFlag = TestCondition(szCondition)
	end
	return SKILL_RESULT_CODE.FAILED
end
--/stop
local function Stop(szContent)
	if szContent ~= "" then
		szContent = StringReplaceW(szContent, " ", "")
	end

	local szCondition = string.sub(szContent, 2, -2)
	local ret  = TestCondition(szCondition)
	if ret ==false then
		return SKILL_RESULT_CODE.FAILED
	else
		return 'stop'
	end
end
--/account
local function account(szContent)
	if szContent ~= "" then
		szContent = StringReplaceW(szContent, " ", "")
	end
	local szCondition = string.sub(szContent, 2, -2)
	bIsThisAccount = TestCondition(szCondition)
	return SKILL_RESULT_CODE.FAILED
end

--//Custom Skill function
--小轻功
function _ZMAC.UseXiaoQingGong()
	local hPlayer = GetClientPlayer()
	local SkillList = {9004, 9006, 9005, 9003}
	for k, v in pairs(SkillList) do
		local szSkillLevel = hPlayer.GetSkillLevel(v)
		local bCool, nLeft, nTotal = hPlayer.GetSkillCDProgress(v, szSkillLevel)
		if nLeft == 0 and nTotal == 0 then
			_ZMAC.ExcuteRealCommand(v)
			break
		end
	end
end



--定向职业轻功
_ZMAC.AppointQingGong=function(pType)
	local hPlayer = GetClientPlayer()
	local ret =nil 
	
	local tForceName = GetForceTitle(hPlayer.dwForceID)
	local QingGongIDs={}
	local tHeight = 20
	
	if tForceName == '明教' then
		QingGongIDs ={18633,3970} --幻光步
	elseif tForceName == '蓬莱' then
		--[[
		if ZMAC_OptionFunc.haveskill('横绝') and ZMAC_OptionFunc.num('驭羽骋风>0') then
			--OnUseSkill(19984, 19984 * (19984 % 10 + 1))  --原版无位移解控
			QingGongIDs ={21772} --	横绝下的[驭羽骋风]
			tHeight = 20
		else
			OnUseSkill(20949, 20949 * (20949 % 10 + 1))     --20949为物华天下·上升,防止因为上一段物化还没有上升导致的无法释放
			QingGongIDs ={20049} --物华天行	
			tHeight = 30
		end
		--]]
		
		OnUseSkill(20949, 20949 * (20949 % 10 + 1))     --20949为物华天下·上升,防止因为上一段物化还没有上升导致的无法释放
		QingGongIDs ={20049} --物华天行	
		tHeight = 30
		
	elseif tForceName == '苍云' then
		QingGongIDs ={13424} --撼地
	elseif tForceName == '唐门' then
		OnUseSkill(3119, 3119 * (3119 % 10 + 1))  --[鸟翔碧空·滞空]319
		QingGongIDs ={3120} --[鸟翔碧空·降落]3120   
		tHeight = 30
	elseif tForceName == '少林' then
		QingGongIDs ={18604} --千斤坠
	elseif tForceName == '凌雪' then
		QingGongIDs ={22614,22616} --孤风飒踏
	else
		return SKILL_RESULT_CODE.FAILED
	end

	local t = GetTargetHandle(hPlayer.GetTarget())
	_ZMAC_SelTarget(0)
	
	for hhh,QingGongID in pairs(QingGongIDs) do
		for iii = tHeight,5,-1 do
			if ret == SKILL_RESULT_CODE.SUCCESS then 
				break
			end
			if     pType == '向上轻功' then
				ret = CastSkillXYZ(QingGongID, 1, hPlayer.nX, hPlayer.nY, hPlayer.nZ + 494 * (iii-0.5))
			elseif pType == '向前轻功' then
				local nFace =  math.pi /180 * hPlayer.nFaceDirection / 256 * 360
				local y = hPlayer.nY + (iii-1) * 64 * math.sin(nFace)
				local x = hPlayer.nX + (iii-1) * 64 * math.cos(nFace)
				ret = CastSkillXYZ(QingGongID, 1, x,y, hPlayer.nZ+1)
			elseif pType == '向后轻功' then
				local nBackFaceDirection = hPlayer.nFaceDirection -127.5
				if nBackFaceDirection<0 then nBackFaceDirection = nBackFaceDirection+255 end
				local nFace =  math.pi /180 * nBackFaceDirection / 256 * 360
				local y = hPlayer.nY + (iii-1) * 64 * math.sin(nFace)
				local x = hPlayer.nX + (iii-1) * 64 * math.cos(nFace)
				ret = CastSkillXYZ(QingGongID, 1, x,y, hPlayer.nZ+1)
			elseif pType == '向前上轻功' then
				local nFace =  math.pi /180 * hPlayer.nFaceDirection / 256 * 360
				local y = hPlayer.nY + (iii-1) * 64 * math.sin(nFace)
				local x = hPlayer.nX + (iii-1) * 64 * math.cos(nFace)
				ret = CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * (iii-0.5))
			elseif pType == '向后上轻功' then
				iii = iii/(2^(1/2))          --取直角边长
				local nBackFaceDirection = hPlayer.nFaceDirection -127.5
				if nBackFaceDirection<0 then nBackFaceDirection = nBackFaceDirection+255 end
				local nFace =  math.pi /180 * nBackFaceDirection / 256 * 360
				local y = hPlayer.nY + (iii-1) * 64 * math.sin(nFace)
				local x = hPlayer.nX + (iii-1) * 64 * math.cos(nFace)
				ret = CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * (iii-0.5))
			end
		end
		
	end

	if t then _ZMAC_SelTarget(t.dwID) end
	return ret
end

--全局群人
_ZMAC.SelectGatherEnemy = function()
	
	local hPlayer = GetClientPlayer()
	if not hPlayer then return false end

	local tDis =  _ZMAC.SelectFeet
	local nSelectWho = nil
	local MostEnemyNumber = 1
	local tType,tID = hPlayer.GetTarget()
	
	
	for j, v in pairs(_ZMAC_GetAllPlayer() ) do
		local k =v.dwID
		local xPlayer = v
		local tmpLife = v.nCurrentLife/v.nMaxLife
		if  IsEnemy(hPlayer.dwID, k) and v.nMoveState ~= MOVE_STATE.ON_DEATH   and tmpLife >0.0035  then
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			local tmpMostEnemyNumber = _ZMAC.GetEnemyPlayerNum(6.1,xPlayer)   --该目标6迟内敌人数量
			if Dis <= tDis  and tmpMostEnemyNumber>= MostEnemyNumber then  
				nSelectWho = xPlayer
				MostEnemyNumber = tmpMostEnemyNumber
			end
		end
	end
	
	if nSelectWho and nSelectWho~= GetTargetHandle(hPlayer.GetTarget())  then
		OutputMessage("MSG_SYS"," 选择群攻目标："..nSelectWho.szName.. ' | 目标6尺范围内人数:'..MostEnemyNumber .."\n")
		_ZMAC_SelTarget(nSelectWho.dwID)
	else
		--OutputMessage("MSG_SYS"," 无抱团敌对目标。\n")
	end

end
--面对目标
local function facetotarget()
	local player = GetClientPlayer()
	local dwTargetType, dwTargetID = player.GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return
	end
	local angle = getAngle(player.nX, player.nY, target.nX, target.nY)
	TurnTo(angle)
end
--背对目标
local function backtotarget()
	local player = GetClientPlayer()
	local dwTargetType, dwTargetID = player.GetTarget()
    local target = nil
	if IsPlayer(dwTargetID) then
		target = GetPlayer(dwTargetID)
	else
		target = GetNpc(dwTargetID)
	end
	if target == nil then
		return
	end
	local angle = getAngle(player.nX, player.nY, target.nX, target.nY)
	TurnTo(angle + 128)
end
--盾收
local function CancelDQ()
	local player = GetClientPlayer()
	local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid
	local nCount = player.GetBuffCount()
	for i = 1, nCount, 1 do
		dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = player.GetBuff(i - 1)
		if dwID and (dwID == 8300) then	--盾墻
			player.CancelBuff(nIndex)
			break
		end
	end
end
--破魔
local function CancelTMT()
	local player = GetClientPlayer()
	local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid
	local nCount = player.GetBuffCount()
	for i = 1, nCount, 1 do
		dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = player.GetBuff(i - 1)
		if dwID and (dwID == 4439 or dwID == 3973 or dwID == 6279) then	--貪魔體
			player.CancelBuff(nIndex)
			break
		end
	end
end
--下马
local function CancelQY()
	local player = GetClientPlayer()
	local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid
	local nCount = player.GetBuffCount()
	for i = 1, nCount, 1 do
		dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = player.GetBuff(i - 1)
		if dwID and dwID == 244 then	--騎禦
			player.CancelBuff(nIndex)
			break
		end
	end
end
--自动魂灯
_ZMAC.AutoHunDeng=function()
	local GetHDList = function()
		local m0 ={}
		
		for k, v in ipairs(_ZMAC_GetAllNpc()) do
			local tmpNpc = v
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer ==GetClientPlayer().dwID then 
			
				
				m0['hd1']={tmpNpc.nX,tmpNpc.nY,tmpNpc.nZ}
				
				
			end	
			if tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer ==GetClientPlayer().dwID then 
				m0['hd2']={tmpNpc.nX,tmpNpc.nY,tmpNpc.nZ}
			end
			if tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer ==GetClientPlayer().dwID then 
				m0['hd3']={tmpNpc.nX,tmpNpc.nY,tmpNpc.nZ}
			end
		end
		return m0
	end
	
	local t_len =function (T)
	  local count = 0
	  for _ in pairs(T) do count = count + 1 end
	  return count
	end
	
	local hPlayer =GetClientPlayer()
	local hdlist = GetHDList()
	if t_len(hdlist) + _ZMAC.GetSkillNum(hPlayer,'奇门飞宫') <3 then return end
	
	local tHeight = 25
	if ZMAC_OptionFunc.noskill('洞彻九宫') ==true then tHeight = 20 end

	--if ZMAC_OptionFunc.nomiji('奇门飞宫真传残页') then tHeight = tHeight-2 end
	--if ZMAC_OptionFunc.nomiji('奇门飞宫真传断篇') then tHeight = tHeight-3 end
	
	local QingGongID = 24378
	
	if t_len(hdlist)==0 then  --如果没灯,则直接在自己的左后方顶部释放一个灯
		
		local ZuohouDirection = hPlayer.nFaceDirection +256/3
		if ZuohouDirection>256 then 
			ZuohouDirection = ZuohouDirection%256
		elseif ZuohouDirection<0 then
			ZuohouDirection = ZuohouDirection+256
		end

		local nFace =  math.pi /180 * ZuohouDirection / 256 * 360
		
		local y = hPlayer.nY + (tHeight-1) * 64 * math.sin(nFace)
		local x = hPlayer.nX + (tHeight-1) * 64 * math.cos(nFace)
		CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * (tHeight-0.5))   --左后上方
	elseif t_len(hdlist)==1 then
		--有一个灯:
		--判断有无目标,有目标则按目标位置释放120°角的灯
		--无目标则按自身旋转120°角释放灯
		local t = GetTargetHandle(hPlayer.GetTarget())
		local xPlayer = t or GetClientPlayer()
		local hd1 = hdlist['hd1'] or hdlist['hd2'] or hdlist['hd3']

		--灯不是和自己重叠的灯
		if hd1[1]~=GetClientPlayer().nX and hd1[2]~=GetClientPlayer().nY then

			local Direction= GetLogicDirection( hd1[1] - xPlayer.nX , hd1[2] - xPlayer.nY)+256/3 --逆时针转120°
			if Direction>256 then 
				Direction = Direction%256
			elseif Direction<0 then
				Direction = Direction+256
			end

			local nFace =  math.pi /180 * Direction / 256 * 360
			for i=50,1,-1 do
				local y = xPlayer.nY + i * 64 * math.sin(nFace)
				local x = xPlayer.nX + i * 64 * math.cos(nFace)
				local ret = CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * i) 
				if ret == SKILL_RESULT_CODE.SUCCESS then break end
			end
		
		--如果是重叠灯，则直接左侧释放
		else 
			local ZuohouDirection = hPlayer.nFaceDirection +256/4
			if ZuohouDirection>256 then 
				ZuohouDirection = ZuohouDirection%256
			elseif ZuohouDirection<0 then
				ZuohouDirection = ZuohouDirection+256
			end

			local nFace =  math.pi /180 * ZuohouDirection / 256 * 360
			
			local y = hPlayer.nY + (tHeight-1) * 64 * math.sin(nFace)
			local x = hPlayer.nX + (tHeight-1) * 64 * math.cos(nFace)
			CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * (tHeight-0.5))   --左侧
		end
		
		
	elseif t_len(hdlist)==2 then
		--有两个灯
		--计算合适夹角释放灯,同样判断是否有目标,有目标则要把目标框进去
		
		if ZMAC_OptionFunc.num('鬼星开穴')==0 then return end
		
		local hd1 ={}
		local hd2={}
		if hdlist['hd1']==nil then
			hd1 = hdlist['hd2']
			hd2 = hdlist['hd3']
		elseif hdlist['hd2']==nil then
			hd1 = hdlist['hd1']
			hd2 = hdlist['hd3']	
		elseif hdlist['hd3']==nil then
			hd1 = hdlist['hd1']
			hd2 = hdlist['hd2']	
		end
		local xPlayer = GetTargetHandle(hPlayer.GetTarget()) or GetClientPlayer()
		
		local x0 , y0 = hPlayer.nX , hPlayer.nY
		local r = tHeight-1

		local LargestS = 0
		local FinalyX,FinalyY = 0,0
		
		--有和自身重叠的灯且没有目标,则直接往正前方丢
		--Output(not hPlayer.GetTarget(),hPlayer.nX,hPlayer.nY,hd1[1],hd1[2])
		if (hPlayer.nX==hd1[1] and hPlayer.nY == hd1[2]) then --(not hPlayer.GetTarget()) and 
			local ZuohouDirection = hPlayer.nFaceDirection
			local nFace =  math.pi /180 * ZuohouDirection / 256 * 360
			FinalyY = hPlayer.nY + (tHeight-1) * 64 * math.sin(nFace)
			FinalyX = hPlayer.nX + (tHeight-1) * 64 * math.cos(nFace)
		else
			for angle=0,360,1 do
				local xX = x0   +   r*64   *   math.cos(angle   *   3.14   /180   )  
				local yY = y0   +   r*64   *   math.sin(angle   *   3.14   /180   )  
				local isInTriangle,S = _ZMAC.IsInTriAngle(xPlayer.nX,xPlayer.nY,xX,yY,hd1[1],hd1[2],hd2[1],hd2[2])
				
				--Output(r,angle,xX,yY,isInTriangle,S,LargestS)
				--此处判定，要求第三个灯必须与前两个灯的距离大于25尺，但如果有灯和自己重叠，此时释放距离本身要求与自己必须小于25尺，则无法得到有效的目标点
				--所以将距离限制改为了大于15尺小于50尺
				if isInTriangle and S>LargestS 
				and _ZMAC.GetPointDis(xX,yY,hd1[1],hd1[2]) <50  and _ZMAC.GetPointDis(xX,yY,hd1[1],hd1[2])>15 
				and _ZMAC.GetPointDis(xX,yY,hd2[1],hd2[2]) <50  and _ZMAC.GetPointDis(xX,yY,hd2[1],hd2[2])>15
				and _ZMAC.GetPointDis(hd2[1],hd2[2],hd1[1],hd1[2]) <50 
				then
					FinalyX = xX
					FinalyY = yY
				end
			end
		end
		


		--Output(FinalyX,FinalyY,hPlayer.nZ + 494 * (tHeight-0.5),_ZMAC.GetDistance(FinalyX,FinalyY,hPlayer.nZ + 494 * (tHeight-0.5)))
		local ret = CastSkillXYZ(QingGongID, 1, FinalyX, FinalyY, hPlayer.nZ + 494 * (tHeight-0.5)) 
		return ret
		
	
		--[=[
		local Direction1 = GetLogicDirection( hd1[1] - xPlayer.nX , hd1[2] - xPlayer.nY)
		local Direction2 = GetLogicDirection( hd2[1] - xPlayer.nX , hd2[2] - xPlayer.nY)
		local Direction = (Direction1+Direction2)/2

		--情形1,如果敌人不在两灯的直线外,正常释放
		--情形2,敌人在两灯连线所在的直线外,不能再正常释放,否则会一字长蛇阵
		local angle =  m_abs(Direction-Direction1)
		if angle <256/3 and angle>10 then   --若小于256/3,则代表处于同一个方向了,需要+256/2,调整到反方向
			Direction = Direction +256/2
			if Direction>256 then 
				Direction = Direction%256
			elseif Direction<0 then
				Direction = Direction+256
			end
		elseif angle<=10 then
			--local dis1 = math.sqrt(math.pow((y2-y1),2)+math.pow((x2-x1),2))
			--local dis2 = math.sqrt(math.pow((y2-y1),2)+math.pow((x2-x1),2))
			--可考虑作移灯处理,防止一字长蛇阵
	
		end
		
		local nFace =  math.pi /180 * Direction / 256 * 360
		for i=50,1,-1 do
			local y = xPlayer.nY + i * 64 * math.sin(nFace)
			local x = xPlayer.nX + i * 64 * math.cos(nFace)
			
			local S_1_2_xPlayer = Calc_TriAngleArea({hd1[1],hd1[2]},{hd2[1],hd2[2]},{xPlayer.nX,xPlayer.nY})
			local S_newPoint_2_xPlayer = Calc_TriAngleArea({x,y},{hd2[1],hd2[2]},{xPlayer.nX,xPlayer.nY})
			local S_newPoint_1_xPlayer = Calc_TriAngleArea({x,y},{hd1[1],hd1[2]},{xPlayer.nX,xPlayer.nY})
			local S_newPoint_1_2 = Calc_TriAngleArea({x,y},{hd1[1],hd1[2]},{hd2[1],hd2[2]})
			--新选的点释放后,可以罩住目标才释放
			if S_newPoint_1_2 == (S_1_2_xPlayer+S_newPoint_2_xPlayer+S_newPoint_1_xPlayer) then 
				local ret = CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * i) 
				if ret == SKILL_RESULT_CODE.SUCCESS then break end
			end
		end
		
		
		--]=]
	elseif t_len(hdlist)==3 then
		--有三个灯,判断有无目标
		--无目标不做任何动作
		--有目标则选择合适的灯,移灯过去把敌人罩住(目前默认选择两灯与目标夹角最大的两个灯之外的灯)
		local xPlayer = GetTargetHandle(hPlayer.GetTarget())
		if (not xPlayer) or xPlayer == GetClientPlayer() then return end      --无目标/目标是自己时不移灯
		
		local hd1 =nil
		local hd2 =nil
		local hd3 =nil
		
		for k, v in ipairs(_ZMAC_GetAllNpc()) do
			local tmpNpc = v
			if tmpNpc.dwModelID == 76101 and tmpNpc.dwEmployer ==GetClientPlayer().dwID then 
				hd1=tmpNpc
			end	
			if tmpNpc.dwModelID == 73149 and tmpNpc.dwEmployer ==GetClientPlayer().dwID then 
				hd2=tmpNpc
			end
			if tmpNpc.dwModelID == 73150 and tmpNpc.dwEmployer ==GetClientPlayer().dwID then 
				hd3=tmpNpc
			end
		end
		
		local retttt,_ =_ZMAC.IsInTriAngle(xPlayer.nX,xPlayer.nY,hd2.nX,hd2.nY,hd1.nX,hd1.nY,hd3.nX,hd3.nY)
		if retttt then return end                            --目标已经在魂阵里时不移灯
		local x0 , y0 = hPlayer.nX , hPlayer.nY
		local r = tHeight-1

		local LargestS = 0
		local YidengSkillID = 0   
		local FinalyX,FinalyY = 0,0
		
		--此时仅在圈上循环,个别情况应该圈内面积更大,此处不作考虑
		--循环hd1
		for angle=0,360,1 do
			local xX = x0   +   r*64   *   math.cos(angle   *   3.14   /180   )  
			local yY = y0   +   r*64   *   math.sin(angle   *   3.14   /180   )  
			local isInTriangle,S = _ZMAC.IsInTriAngle(xPlayer.nX,xPlayer.nY,xX,yY,hd2.nX,hd2.nY,hd3.nX,hd3.nY)
			if isInTriangle and S>LargestS 
			and _ZMAC.GetPointDis(xX,yY,hd3.nX,hd3.nY) <50  and _ZMAC.GetPointDis(xX,yY,hd3.nX,hd3.nY)>25
			and _ZMAC.GetPointDis(xX,yY,hd2.nX,hd2.nY) <50 and _ZMAC.GetPointDis(xX,yY,hd2.nX,hd2.nY)>25
			and _ZMAC.GetPointDis(hd3.nX,hd3.nY,hd2.nX,hd2.nY) <50 then
				YidengSkillID =24858 --一
				FinalyX = xX
				FinalyY = yY
			end
			
		end
		
		--循环hd2
		for angle=0,360,1 do
			local xX = x0   +   r*64   *   math.cos(angle   *   3.14   /180   )  
			local yY = y0   +   r*64   *   math.sin(angle   *   3.14   /180   )  
			local isInTriangle,S = _ZMAC.IsInTriAngle(xPlayer.nX,xPlayer.nY,xX,yY,hd1.nX,hd1.nY,hd3.nX,hd3.nY)
			if isInTriangle and S>LargestS 
			and _ZMAC.GetPointDis(xX,yY,hd1.nX,hd1.nY) <50  and _ZMAC.GetPointDis(xX,yY,hd1.nX,hd1.nY) >25
			and _ZMAC.GetPointDis(xX,yY,hd3.nX,hd3.nY) <50 and _ZMAC.GetPointDis(xX,yY,hd3.nX,hd3.nY) >25
			and _ZMAC.GetPointDis(hd1.nX,hd1.nY,hd3.nX,hd3.nY) <50
			then
				YidengSkillID =24859 --二
				FinalyX = xX
				FinalyY = yY
			end
			
		end
		--循环hd3
		for angle=0,360,1 do
			local xX = x0   +   r*64   *   math.cos(angle   *   3.14   /180   )  
			local yY = y0   +   r*64   *   math.sin(angle   *   3.14   /180   )  
			local isInTriangle,S = _ZMAC.IsInTriAngle(xPlayer.nX,xPlayer.nY,xX,yY,hd1.nX,hd1.nY,hd2.nX,hd2.nY)
			if isInTriangle and S>LargestS 
			and _ZMAC.GetPointDis(xX,yY,hd1.nX,hd1.nY) <50  and _ZMAC.GetPointDis(xX,yY,hd1.nX,hd1.nY) >25
			and _ZMAC.GetPointDis(xX,yY,hd2.nX,hd2.nY) <50 and _ZMAC.GetPointDis(xX,yY,hd2.nX,hd2.nY) >25
			and _ZMAC.GetPointDis(hd1.nX,hd1.nY,hd2.nX,hd2.nY) <50 then
				YidengSkillID =24860 --纵横三才·三
				FinalyX = xX
				FinalyY = yY
			end
			
		end
		
		local ret = CastSkillXYZ(YidengSkillID, 1, FinalyX, FinalyY, hPlayer.nZ + 494 * (tHeight-0.5)) 
		return ret
		
	end
end
--面对目标
_ZMAC.TurnToTarget=function(xPlayer)
	local hPlayer=GetClientPlayer()
	local t = xPlayer
	if (not t  or t ==hPlayer ) then return SKILL_RESULT_CODE.FAILED end
	local angle= GetLogicDirection(t.nX - hPlayer.nX, t.nY - hPlayer.nY)
	TurnTo(angle)
end
--全局打断
_ZMAC.GlobalBroken =function(...)
	local hPlayer = GetClientPlayer()
	local nSkillID,tDis=0,0
	if (...)==nil then
		local brokenskilllist = {
			['厥阴指'] ={183,20},
			['乘龙箭'] ={2603,25} ,
			['崩'] ={482,4} ,
			['八卦洞玄'] ={370,20} ,
			['剑飞惊天'] ={310,20} ,
			['剑心通明'] ={547,20} ,
			['灵蛊'] ={18584,20} ,
			['蟾啸'] ={6626,20} ,
			['梅花针'] ={3092,20} ,
			['玉虹贯日'] ={1577,20} ,
			['棒打狗头 '] ={5259,20} ,
			['寒月耀'] ={3961,20} ,
			['清音长啸'] ={14095,20} ,
			['雷走风切'] ={16598,12} ,
			['翔极碧落'] ={20065,20} ,
			['血覆黄泉'] ={22274,20} ,
			['寒月耀'] ={3961,20} ,
			['神皆寂'] ={20511,20} ,
			}
		for SkillName,SkillID_dis in pairs(brokenskilllist) do
			if ZMAC_OptionFunc.haveskill(SkillName) then 
				nSkillID=SkillID_dis[1]
				tDis=SkillID_dis[2]-0.5
			end
		end
	else
		nSkillID=(...)[1]
		tDis=(...)[2] or 20
	end
	
	local t = GetTargetHandle(hPlayer.GetTarget()) 
	if nSkillID>0 and tDis>0 and ZMAC_OptionFunc.num(tostring(nSkillID) .. '>0')then
		
		for k,v in pairs(_ZMAC_GetAllPlayer()) do
			if IsEnemy(hPlayer.dwID, v.dwID) and GetCharacterDistance(hPlayer.dwID,v.dwID)/64 <= tDis then
				_ZMAC_SelTarget(v.dwID)	
				if ZMAC_OptionFunc.tbroken()   then
					_ZMAC.TurnToTarget(v)
					local aaa = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
					if aaa ==SKILL_RESULT_CODE.SUCCESS then 
						OutputMessage('MSG_SYS','已向目标: ' .. v.szName ..' 释放全屏打断。\n')
						break
					end
				end	
			end
		end
		
	end	
	
	if not t then 
		_ZMAC_SelTarget(0)
	else
		_ZMAC.TurnToTarget(t)
		_ZMAC_SelTarget(t.dwID)
	end
	
	
	
end
--全局鸿蒙
_ZMAC.GlobalHongmengHealer =function(...)
	local hPlayer = GetClientPlayer()
	local nSkillID,tDis=24385,20
	local t = GetTargetHandle(hPlayer.GetTarget()) 
	if not t then return end
	if not IsEnemy(hPlayer.dwID, t.dwID) then return end
	
	local KungfuMountX = t.GetKungfuMount()
	local mountX = ''
	if KungfuMountX then
		mountX = KungfuMountX.szSkillName
	end
	if mountX== '离经易道' or mountX== '补天诀'  or mountX== '相知' or mountX== '云裳心经' then return end
	
	
	if nSkillID>0 and tDis>0 and ZMAC_OptionFunc.num(tostring(nSkillID) .. '>0') and ZMAC_OptionFunc.tlife('<0.35') then
		for k,v in pairs(_ZMAC_GetAllPlayer()) do
			if IsEnemy(hPlayer.dwID, v.dwID) and GetCharacterDistance(hPlayer.dwID,v.dwID)/64 <= tDis then
					
				local KungfuMount = v.GetKungfuMount()
				local mount = ''
				if KungfuMount then
					mount = KungfuMount.szSkillName
				end
				if mount== '离经易道' or mount== '补天诀'  or mount== '相知' or mount== '云裳心经' then
					_ZMAC_SelTarget(v.dwID)
					_ZMAC.TurnToTarget(v)
					local aaa = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
					if aaa ==SKILL_RESULT_CODE.SUCCESS then 
						OutputMessage('MSG_SYS','已向目标: ' .. v.szName ..' 释放全屏鸿蒙天禁。\n')
						break
					end
				end	
			end
		end
		
	end	
end
--全局断奶
_ZMAC.GlobalBrokenHealer =function(...)
	local hPlayer = GetClientPlayer()
	local nSkillID,tDis=0,0
	if (...)==nil then
		local brokenskilllist = {
			['寒月耀'] ={3961,20} ,
			['厥阴指'] ={183,20},
			['乘龙箭'] ={2603,25} ,
			['崩'] ={482,4} ,
			['八卦洞玄'] ={370,20} ,
			['剑飞惊天'] ={310,20} ,
			['剑心通明'] ={547,20} ,
			['灵蛊'] ={18584,20} ,
			['蟾啸'] ={6626,20} ,
			['梅花针'] ={3092,20} ,
			['玉虹贯日'] ={1577,20} ,
			['棒打狗头 '] ={5259,20} ,
			['清音长啸'] ={14095,20} ,
			['雷走风切'] ={16598,12} ,
			['翔极碧落'] ={20065,20} ,
			['血覆黄泉'] ={22274,20} ,
			['神皆寂'] ={20511,20} ,
			}
		for SkillName,SkillID_dis in pairs(brokenskilllist) do
			if ZMAC_OptionFunc.haveskill(SkillName) then 
				nSkillID=SkillID_dis[1]
				tDis=SkillID_dis[2]-0.5
			end
		end
	else
		nSkillID=(...)[1]
		tDis=(...)[2] or 20
	end
	
	local t = GetTargetHandle(hPlayer.GetTarget()) 
	if nSkillID>0 and tDis>0 and ZMAC_OptionFunc.num(tostring(nSkillID) .. '>0') then
		for k,v in pairs(_ZMAC_GetAllPlayer()) do
			if IsEnemy(hPlayer.dwID, v.dwID) and GetCharacterDistance(hPlayer.dwID,v.dwID)/64 <= tDis then
				_ZMAC_SelTarget(v.dwID)	
				local KungfuMount = v.GetKungfuMount()
				local mount = ''
				if KungfuMount then
					mount = KungfuMount.szSkillName
				end
				if ZMAC_OptionFunc.tbroken()  and (
				mount== '离经易道'
				or mount== '补天诀' 
				or mount== '相知'
				or mount== '云裳心经'
				) then
					
					_ZMAC.TurnToTarget(v)
					local aaa = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
					if aaa ==SKILL_RESULT_CODE.SUCCESS then 
						OutputMessage('MSG_SYS','已向目标: ' .. v.szName ..' 释放全屏打断。\n')
						break
					end
				end	
			end
		end
		
	end	
	if not t then 
		_ZMAC_SelTarget(0)
	else
		_ZMAC.TurnToTarget(t)
		_ZMAC_SelTarget(t.dwID)
	end
end
--全局决斗.   奇穴：扬旌沙场[mapname:华山之巅|乐山大佛窟|天山碎冰谷|青竹书院|拭剑台|墟海之眼|藏剑武库 在JJC中自家奶妈血量低于百分之30且被控，选择敌方目标是自家奶妈的DPS，进行决斗
_ZMAC.GlobalJuedou = function()
	local hPlayer = GetClientPlayer()
	local f = ZMAC_OptionFunc.haveskill('扬旌沙场') and ZMAC_OptionFunc.mapname("华山之巅|乐山大佛窟|天山碎冰谷|青竹书院|拭剑台|墟海之眼|藏剑武库") 
	if not f then return end
	local aPlayer = _ZMAC_GetAllPlayer()
	for k,v in pairs(aPlayer) do
	
		local KungfuMount = v.GetKungfuMount()
		local mount = ''
		if KungfuMount then
			mount = KungfuMount.szSkillName
		end
		if (not IsEnemy(hPlayer.dwID,v.dwID)) and v.nCurrentLife/v.nMaxLife < 0.3 and (
		mount== '离经易道'
		or mount== '补天诀' 
		or mount== '相知'
		or mount== '云裳心经'
		) then  --尚未添加被控条件
			for m,n in pairs(aPlayer) do
				local _,EnemyTarID = n.GetTarget()
				local KungfuMount2 = n.GetKungfuMount()
				local mount2 = ''
				if KungfuMount2 then
					mount2 = KungfuMount2.szSkillName
				end
				if IsEnemy(hPlayer.dwID,n.dwID) and EnemyTarID == v.dwID and 
				(mount2 ~= '离经易道'
				and mount2 ~= '补天诀' 
				and mount2 ~= '相知'
				and mount2 ~= '云裳心经') then
					_ZMAC_SelTarget(n.dwID)
					_ZMAC.TurnToTarget(n)
					local nSkillID=15196
					local aaa = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
					if aaa ==SKILL_RESULT_CODE.SUCCESS then 
						OutputMessage('MSG_SYS','已向目标: ' .. v.szName ..' 释放[扬旌沙场]拆火。\n')
						break
					end
				end
			end
		end
	end
end
--全局蚀奶
_ZMAC.GlobalShixinHealer=function()
	local hPlayer = GetClientPlayer()
	local nSkillID,tDis=15121,20
	local t = GetTargetHandle(hPlayer.GetTarget()) 
	if not t then return end
	if nSkillID>0 and tDis>0 and ZMAC_OptionFunc.num(tostring(nSkillID) .. '>0')  and t.nCurrentLife/t.nMaxLife <0.3 and IsEnemy(t.dwID,hPlayer.dwID) then
		for k,v in pairs(_ZMAC_GetAllPlayer()) do
			local KungfuMount = v.GetKungfuMount()
			local mount = ''
			if KungfuMount then
				mount = KungfuMount.szSkillName
			end
			if IsEnemy(hPlayer.dwID, v.dwID) and GetCharacterDistance(hPlayer.dwID,v.dwID)/64 <= tDis  and
			(
			mount== '离经易道'
			or mount== '补天诀' 
			or mount== '相知'
			or mount== '云裳心经'
			) then
				_ZMAC.TurnToTarget(v)
				local aaa = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
				if aaa ==SKILL_RESULT_CODE.SUCCESS then 
					OutputMessage('MSG_SYS','已向目标: ' .. v.szName ..' 释放[全屏噬奶]。\n')
					break
				end
			end
		end
	end
end
--全局舍身
_ZMAC.GlobalSheshen=function()
	loadstring(
	[[
	local hPlayer = GetClientPlayer()
	local leastLife=0.25
	local leastDistance = 20
	local t = GetTargetHandle(hPlayer.GetTarget()) 
	
	if ZMAC_OptionFunc.life('<0.4') then  --收回舍身
		_ZMAC.UseSkill(21693)
	end
	
	for j, v in pairs(_ZMAC_GetAllPlayer()) do 
		local k = v.dwID
		local tmpPlayer = v
		local tmpLife = tmpPlayer.nCurrentLife/tmpPlayer.nMaxLife
		local tmpDistance = _ZMAC.GetDistance(tmpPlayer)
		
		if IsParty(hPlayer.dwID, k) and  tmpDistance < leastDistance and tmpPlayer.nMoveState ~= MOVE_STATE.ON_DEATH and tmpLife < leastLife and ZMAC_OptionFunc.num('258>0')  then   --and ( or tID == nil)
			if _ZMAC.CheckStats (v,'无减伤') then
				_ZMAC_SelTarget(k)
				local aaa = _ZMAC.UseSkill(258)
				if aaa ==SKILL_RESULT_CODE.SUCCESS then 
					OutputMessage('MSG_SYS','已向目标: ' .. v.szName ..' 释放全屏舍身。\n')
					break
				end
			end
		end
	end

	if not t then 
		_ZMAC_SelTarget(0)
	else
		_ZMAC.TurnToTarget(t)
		_ZMAC_SelTarget(t.dwID)
	end
	
	]])()
end
--全局探梅
_ZMAC.GlobalTanmei=function()
	if ZMAC_OptionFunc.haveskill("探梅") and ZMAC_OptionFunc.num("探梅>0") then
		local me = GetClientPlayer()
		local prevTarID = 0
		local aPlayer = GetAllPlayer() or {}
		for k, v in pairs(aPlayer) do
			if me.dwID ~= v.dwID and me.IsPlayerInMyParty(v.dwID) and _ZMAC.GetDistance(v) <= 15 then 

				local _, prevTarID = me.GetTarget()
				if not prevTarID then prevTarID = 0 end
				_ZMAC.SetInsTarget(v.dwID)
				
				local f = ZMAC_OptionFunc.tally() and ZMAC_OptionFunc.tstats("被控")
				--Output(f,ZMAC_OptionFunc.tally(),ZMAC_OptionFunc.tstats("被控"))
				if prevTarID == 0 then
					_ZMAC.SetInsTarget(TARGET.NO_TARGET, 0)
				else
					_ZMAC.SetInsTarget(prevTarID)
				end
				
				if f then
					local _, prevTarID = me.GetTarget()
					if not prevTarID then prevTarID = 0 end
					_ZMAC.SetTarget(TARGET.PLAYER, v.dwID)
					_ZMAC.TurnToTarget(v)
					_ZMAC.UseSkill("探梅")
					

					if prevTarID == 0 then
						_ZMAC.SetTarget(TARGET.NO_TARGET, 0)
					else
						_ZMAC.SetTarget(prevTarID)
					end
					break
				end
			end
		end
	end
end
--日月晦·隐
local function SunMoonDamage() --明教日月晦BUG
	OnUseSkill(28594, 28594 * (28594 % 10 + 1)) 
	return SKILL_RESULT_CODE.SUCCESS
end

--//系统原生宏Hook==================================================================================
--取纯净宏，将#打头的注释及空行屏蔽
local function GetPureMacro(szMacro)
	local szPureMacro = ""

	szMacro = "\n"..szMacro
	local i, j = StringFindW(szMacro, "\n#")
	while i do
		szPureMacro = szPureMacro..string.sub(szMacro, 1, i - 1)
		szMacro = string.sub(szMacro, j, -1)
		i, j = StringFindW(szMacro, "\n#")
		local i1, j1 = StringFindW(szMacro, "\n/")
		if not i or (i1 and i > i1) then
			i, j = i1, j1
		end
		if i then
			szMacro = string.sub(szMacro, i, -1)
		else
			szMacro = ""
		end
		i, j = StringFindW(szMacro, "\n#")
	end
	szPureMacro = szPureMacro..szMacro
	return szPureMacro
end
--取单句function，
local function ProcessCommand(szCmd, szLeft)
	local szKey, szParam
	local i = StringFindW(szCmd, " ")
	if i then
		szKey = string.sub(szCmd, 1, i - 1)
		szParam = string.sub(szCmd, i + 1, -1)
	else
		szKey, szParam = szCmd, ""
	end
	szKey = StringLowerW(szKey)
	--Output('ProcessCommandself',szKey,ConfigFlag)
	if szKey and aCommand[szKey] then
		
		local r1, r2 = aCommand[szKey](szParam, szLeft)
		if r1 == nil then
			r1, r2 = true, nil
		end
		return r1, r2
	end
	return false
end
--取单句
local function GetCommand(szMacro)
	local szCmd, szLeft
	local i, j = StringFindW(szMacro, "\n/")
	if i then
		szCmd = string.sub(szMacro, 1, i - 1)
		szLeft = string.sub(szMacro, j, - 1)
	else
		szCmd, szLeft = szMacro, ""
	end
	while string.sub(szCmd, -1, -1) == "\n" do
		szCmd = string.sub(szCmd, 1, -2)
	end
	return szCmd, szLeft
end
--取宏内容，用于ExcuteMacroByID(dwID)
local function GetMacroContent(dwID)
	local t = g_Macro[dwID]
	if t then
		return t.szMacro or ""
	end
	return ""
end
--取宏功能，并不断循环执行

local function GetMacroFunction()
	local fnExcute = function(szMacro)
		local r = true
		local szCmd, szLeft = "", szMacro
		while true do
			szCmd, szLeft = GetCommand(szLeft)
			--Output('GetCommand',ConfigFlag,szCmd)
			if szCmd == "" then
				if szLeft == "" then
					break
				end
			else

				local r1, r2 = ProcessCommand(szCmd, szLeft)

				if not r1 or r1=='stop' then
					r = false
					break
				end

			end
		end
		return r
	end
	return fnExcute
end
--//原生宏备份
if not _ZMAC.OriginExcuteMacro then 
	_ZMAC.OriginExcuteMacro=ExcuteMacro   --保存原始宏处理函数
end
--//PVE用宏接口
function _ZMAC.ExcuteMacroPVE(...)
	if s_find((...),'/script') then 
		loadstring(Str_Cut((...),'/script','/cast'))()
		local i = StringFindW((...), "/cast")
		local szMacro = string.sub((...), i, -1)
		return _ZMAC.OriginExcuteMacro(szMacro)
	else
		return _ZMAC.OriginExcuteMacro(...)
	end
end
--原生宏Hook
_ZMAC.ExcuteDelay = 250
_ZMAC.nLastExcuteTime = GetTickCount()
function ExcuteMacro(Macro)
	local szMacro = GetPureMacro(Macro)
	if ZMAC.Switch['启用PVE宏'] ==true then
		return _ZMAC.ExcuteMacroPVE(szMacro)
	end
	
	if GetTickCount()-_ZMAC.nLastExcuteTime>_ZMAC.ExcuteDelay then
		_ZMAC.nLastExcuteTime = GetTickCount()
		return GetMacroFunction()(szMacro)
	end
end
--快捷栏Hook，ExcuteMacroByID
function ExcuteMacroByID(dwID)
	local szMacro = ""
	szMacro = GetMacroContent(dwID)
	if szMacro ~= "" then
		if _ZMAC.Macro[dwID] ~= nil then
			ExcuteMacro(_ZMAC.Macro[dwID])
		else
			ExcuteMacro(szMacro)
		end
	end
end
--添加宏指令
local function AppendCommand(key, fn, szHelp)
	key = StringLowerW(key)
	aCommand["/"..key] = fn
	if szHelp then
		aCommandHelp[key] = szHelp
	end
end


--//MacroSettingPanel Hook
--宏长度
if not g_Oldwstringlen then g_Oldwstringlen = wstring.len  end
function wstring.len(szText)  
	if s_find(szText, '/cast')  then 
		return 120 
	end 
	return g_Oldwstringlen(szText) 
end
--缘起
if not g_Oldwstringlen2 then g_Oldwstringlen2 = string.len  end
function string.len(szText)  
	if s_find(szText, '/cast')  then 
		return 120 
	end 
	return g_Oldwstringlen2(szText) 
end
--改变宏字节数
local mylimit = 80000
if  not orig_MacroSettingPanel_OnFrameCreate then 
	orig_MacroSettingPanel_OnFrameCreate =MacroSettingPanel.OnFrameCreate  
end
function MacroSettingPanel.OnFrameCreate() 
	this:RegisterEvent("UI_SCALED")
	MacroSettingPanel.OnEvent("UI_SCALED")
	this:Lookup("Edit_Content"):SetLimit(mylimit)
	orig_MacroSettingPanel_OnFrameCreate() 
	this : Lookup('', 'Text_MaxByte') : SetText(FormatString(g_tStrings.MACRO_INPUT_LIMIT, 0, mylimit)) 
	this:Lookup("Edit_Content"):SetLimit(mylimit)
	Station.Lookup("Topmost/MacroSettingPanel"):Lookup("Edit_Content"):SetLimit(-1)  
end 
function MacroSettingPanel.OnEditChanged() 
	local szName = this : GetName() 
	local frame = this : GetParent() 
	if frame.dwID then 
		frame : Lookup('Btn_Apply') : Enable(true) 
	end 
	if szName == 'Edit_Content' then 
		local nUse = this : GetTextLength(false) 
		frame : Lookup('', 'Text_MaxByte') : SetText(FormatString(g_tStrings.MACRO_INPUT_LIMIT, nUse, mylimit)) 
	end 
	Station.Lookup("Topmost/MacroSettingPanel"):Lookup("Edit_Content"):SetLimit(-1) --缘起字节突破
end
--密文自动解密保存
function MacroSettingPanel.ChangeMacro(frame)
	if not frame.dwID then
		frame:Lookup("Btn_Apply"):Enable(false)
		return
	end
	
	local szName = frame:Lookup("Edit_Name"):GetText()
	local szDesc = frame:Lookup("Edit_Desc"):GetText()
	local szContent = frame:Lookup("Edit_Content"):GetText()
	if s_find(szContent,'/script')
			or s_find(szContent,'/cast') 
			or s_find(szContent,'/config')
			or s_find(szContent,'/castEx') 
			or s_find(szContent,'/use') 
			or s_find(szContent,'/select') 
			or s_find(szContent,'/player') 
			or s_find(szContent,'/castid') 
			or s_find(szContent,'/castidEx') 
			or s_find(szContent,'/stop')
			or s_find(szContent,'/cancelbuff') 
			or s_find(szContent,'/fcast') 			then
		if not _ZMAC.Macro then _ZMAC.Macro ={} end
		_ZMAC.Macro[frame.dwID] = nil
	else
		_ZMAC.Macro[frame.dwID] = _ZMAC_transMacro.jiemi(szContent)
		
	end
	local nIconID = frame:Lookup("", "Handle_Icon").nIconID
	SetMacro(frame.dwID, szName, nIconID, szDesc, szContent)
	local hList = frame:Lookup("", "Handle_List")
	local nCount = hList:GetItemCount() - 1
	for i = 0, nCount, 1 do
		local hI = hList:Lookup(i)
		if hI.dwID == frame.dwID then
			hI:Lookup("Name"):SetText(szName)
			hI:Lookup("Box_Skill"):SetObjectIcon(nIconID)
		end
	end
	frame:Lookup("Btn_Apply"):Enable(false)
end
function MacroSettingPanel.DelMacro(frame)
	if not frame.dwID then
		frame:Lookup("Btn_Delete"):Enable(false)
		return
	end
	if _ZMAC.Macro[frame.dwID] then
		_ZMAC.Macro[frame.dwID] = nil
	end
	RemoveMacro(frame.dwID)
	
	local nIndex = nil
	local hList = frame:Lookup("", "Handle_List")
	local nCount = hList:GetItemCount() - 1
	for i = 0, nCount, 1 do
		local hI = hList:Lookup(i)
		if hI.dwID == frame.dwID then
			hList:RemoveItem(i)
			nIndex = i
			break
		end
	end
	nIndex = nIndex or 0
	if nIndex >= hList:GetItemCount() then
		nIndex = hList:GetItemCount() - 1
	end
	if nIndex < 0 then
		nIndex = 0
	end
	local hI = hList:Lookup(nIndex)
	if hI then
		MacroSettingPanel.Sel(hI)
	else
		frame.dwID = nil
		MacroSettingPanel.UpdateSelect(frame)
	end
	MacroSettingPanel.UpdateScrollInfo(hList)
end
--快捷栏多宏间隔取消
OriginCanUseMacro = CanUseMacro
function CanUseMacro (...)
    return true
end
OriginUpdateMacroCDProgress = UpdateMacroCDProgress
function UpdateMacroCDProgress(_ARG_0_, _ARG_1_)
  --Output(_ARG_0_, _ARG_1_)
  -- if not _UPVALUE0_ or _ARG_1_:GetObjectData() == _UPVALUE0_ or _UPVALUE1_ <= 0 then
    -- _ARG_1_:SetObjectCoolDown(false)
    -- return
  -- end
  g_MacroInfo[_ARG_1_:GetObjectData()] = g_MacroInfo[_ARG_1_:GetObjectData()] or {bCool = false}
  -- if 0 >= _UPVALUE1_ - (GetTickCount() - _UPVALUE2_) then
    -- if g_MacroInfo[_ARG_1_:GetObjectData()].bCool then
      -- _ARG_1_:SetObjectSparking(true)
    -- end
    -- _ARG_1_:SetObjectCoolDown(false)
    -- g_MacroInfo[_ARG_1_:GetObjectData()].bCool = false
    -- return 0
  -- else
  _ARG_1_:SetObjectCoolDown(false)
  --_ARG_1_:SetCoolDownPercentage((_UPVALUE1_ - _UPVALUE1_) / _UPVALUE1_)
  g_MacroInfo[_ARG_1_:GetObjectData()].bCool = false
  _UPVALUE1_ =0
  return 0
  --end
end  --取消多段宏官方执行间隔   -- _UPVALUE1_测试一个值改掉应该就可以


--//自动执行
WY.Auto = false
WY.Key = ""
WY.speed = 4	--設置執行速度	次/每秒
WY.js = 1
function isActionBarDown()
	for i = 1, 5, 1 do 
		for j = 1, 16, 1 do 
			if IsKeyDown(GetKeyName(Hotkey.Get("ACTIONBAR"..i.."_BUTTON"..j))) then
				return true,i,j
			end
		end
	end
	return false,i,j
end
function WY.Breathe()
	--WY.Breathe()
	local nKey, bShift, bCtrl, bAlt  = Hotkey.Get("PressMacro")
	if nKey ~= 0 then
		WY.Key = GetKeyName(nKey)
	end
	local a,b,c = isActionBarDown()
	if WY.Auto and a then
		ActionButtonDown(b,c)
		ActionButtonUp(b,c)
	end
	if WY.Auto and not a or WY.Key ~= "" and IsKeyDown(WY.Key) then
		if WY.js % math.floor(16 / WY.speed) == 0 then
			ExcuteMacroByID(1)
		end
		WY.js = WY.js + 1
	end
end
_ZMAC.BreatheCall('WY_Breath',function() WY.Breathe() end,62.5)
function WY.OpenOrClose()
	if WY.Auto then
		WY.Auto = false
		myMessage("已关闭自动执行宏命令！")
	else
		WY.Auto = true
		myMessage("已开启自动执行宏命令！")
	end
end
function WY.SetSpeed()
	GetUserInput("在下面的输入框中输入宏每秒执行的次数，单位（次/秒），设置的值范围（1-16）", function(szText)
		if szText ~= "" then
			WY.speed = tonumber(szText)
			if WY.speed > 16 then
				WY.speed = 16
			end
			myMessage("宏执行速度设置完毕！当前执行速度：" .. WY.speed .. "次/秒")
			WY.speed = math.ceil(WY.speed/2)
		end
	end)
end


--//函数宏绑定
AppendCommand("msg", myMessage)
--AppendCommand("call", MacroCall)
AppendCommand("cast", Cast, "格式：/cast [條件1,(條件2;條件3)] 技能名1,技能名2")
AppendCommand("castid", Cast, "格式：/cast [條件1,(條件2;條件3)] 技能名1,技能名2")
AppendCommand("castEx", Cast, "格式：/cast [條件1,(條件2;條件3)] 技能名1,技能名2")
AppendCommand("castidEx", Cast, "格式：/cast [條件1,(條件2;條件3)] 技能名1,技能名2")
AppendCommand("do", Cast, "格式：/cast [條件1,(條件2;條件3)] 技能名1,技能名2")
AppendCommand("skill", Cast, "格式：/cast [條件1,(條件2;條件3)] 技能名1,技能名2")
AppendCommand("use", Use, "格式：/use [條件]")  --未写
AppendCommand("config", Config, "格式：/config [條件]")  --未写
--AppendCommand("account", account, "格式：/account [條件]")  --剔除
AppendCommand("script", ExucteScriptCommand, "格式：/script 代碼段")
AppendCommand("target", MacroTarget, "格式：/target [條件] 目標名字") --未写
AppendCommand("player", MacroTarget, "格式：/target [條件] 目標名字") --未写
AppendCommand("select", MacroTarget, "格式：/target [條件] 目標名字") --未写
--AppendCommand("showerrmsg", function(szShow) g_ShowLuaErrMsg = szShow == "true" end) --剔除
AppendCommand("roll", Roll, g_tStrings.HELPME_ROLL) 
AppendCommand("help", Help, g_tStrings.HELPME_HELP)
AppendCommand("stop", Stop, "格式：/stop [條件]")




--//快捷键
--选人范围
_ZMAC.SelectFeet = 20
_ZMAC.SetSelectFeet = function()
	--此处如果不实用loadstring,只要带上_ZMAC.ExcuteDelay就失效,猜测应该是全局变量不能放进来的原因
	local function fnSure(nNum)
		_ZMAC.SelectFeet = nNum
		OutputMessage('MSG_SYS','智能选人范围已设置为 '..tostring(_ZMAC.SelectFeet)..'尺。\r\n')
	end
	GetUserInputNumber(1, 99,{1920/2,1080/2,10,10} , fnSure)
end
--选人血量
_ZMAC.SelectLife = 30
_ZMAC.SetSelectLife = function()
	--此处如果不实用loadstring,只要带上_ZMAC.ExcuteDelay就失效,猜测应该是全局变量不能放进来的原因
	local function fnSure(nNum)
		_ZMAC.SelectLife = nNum
		OutputMessage('MSG_SYS','智能选人血量门槛已设置为:百分之 '..tostring(_ZMAC.SelectLife)..' \r\n')
	end
	GetUserInputNumber(1, 100,{1920/2,1080/2,10,10} , fnSure)
end
--残血敌人
_ZMAC.SelcectDyingEnemy = function()
	local leastLife=_ZMAC.SelectLife/100
	local leastDistance = _ZMAC.SelectFeet
	local nSelectWho = nil
	local tType,tID = GetClientPlayer().GetTarget()
	
	for j, v in pairs(_ZMAC_GetAllPlayer() ) do 
		local k = v.dwID
		local tmpLife = v.nCurrentLife/v.nMaxLife
		local tmpDistance = _ZMAC.GetDistance(v)
        if IsEnemy(GetClientPlayer().dwID, v.dwID) and   tmpDistance < leastDistance and v.nMoveState ~= MOVE_STATE.ON_DEATH  and  tmpLife < leastLife  and tmpLife >0.0035 then   --and (or tID == nil)    --
			leastLife = tmpLife
            nSelectWho = v
        end
	end
	
	if nSelectWho then
		if nSelectWho ~= GetTargetHandle(tType,tID ) then
			--OutputMessage("MSG_SYS"," 选择最低血敌人："..nSelectWho.szName.."\n")
			_ZMAC_SelTarget(nSelectWho.dwID)
		end
	else
		--OutputMessage("MSG_SYS"," 无低血目标。\n")
	end
end
--残血队友
_ZMAC.SelectDyingParty=function()
	local hPlayer = GetClientPlayer()
	local leastLife=1.0001
	local leastDistance = _ZMAC.SelectFeet
	local nSelectWho = nil
	local tType,tID = hPlayer.GetTarget()

	for j, v in pairs(_ZMAC_GetAllPlayer()) do 
		
		local k = v.dwID
		local tmpPlayer = v
		local tmpLife = tmpPlayer.nCurrentLife/tmpPlayer.nMaxLife
		local tmpDistance = _ZMAC.GetDistance(tmpPlayer)
		
		if IsParty(hPlayer.dwID, k) and  tmpDistance < leastDistance and tmpPlayer.nMoveState ~= MOVE_STATE.ON_DEATH and tmpLife < leastLife and k ~= hPlayer.dwID then   --and ( or tID == nil) --
			leastLife = tmpLife
			nSelectWho =tmpPlayer
		end
	end

	--不选自己
	-- if nSelectWho~=nil and hPlayer.nCurrentLife/hPlayer.nMaxLife<= leastLife then
		-- nSelectWho = hPlayer
	-- end

	if nSelectWho and nSelectWho~= GetTargetHandle(hPlayer.GetTarget())  then
		_ZMAC_SelTarget(nSelectWho.dwID)
		--OutputMessage("MSG_SYS"," 选择最低血队友："..nSelectWho.szName.."\n")
	end
end

--//快捷键======================================================================================

--//开关执行热键------------------------------------------------------------------------------
ZMAC.AutoExcuteMacroFirst_Kaiguan = false
ZMAC.AutoExcuteMacroFirst = function()
	if ZMAC.AutoExcuteMacroFirst_Kaiguan then 
		ZMAC.AutoExcuteMacroFirst_Kaiguan = false
		ZMAC.BreatheCall('autoexcutemacrofirst')
		OutputMessage('MSG_SYS',' 停止执行。\r\n')
	elseif ZMAC.AutoExcuteMacroFirst_Kaiguan ==false then
		ZMAC.AutoExcuteMacroFirst_Kaiguan =true
		local tmpFnAction = function()	
			ExcuteMacroByID(1)
		end
		ZMAC.BreatheCall('autoexcutemacrofirst',tmpFnAction,62.5)
		OutputMessage('MSG_SYS',' 开始执行。\r\n')
	end
end

--//按住执行热键------------------------------------------------------------------------------
ZMAC.AutoExcuteMacroFirstStart = function()
	local tmpFnAction = function()	
		ExcuteMacroByID(1)
	end
	ZMAC.BreatheCall('autoexcutemacrofirst2',tmpFnAction,ZMAC.ExcuteDelay)
end
ZMAC.AutoExcuteMacroFirstEnd = function()
	ZMAC.BreatheCall('autoexcutemacrofirst2')
end





--快捷键绑定
--Hotkey.AddBinding("AutoMacro", "【自动执行】", "【实用PVP】",function() ExucteScriptCommand("WY.OpenOrClose()") end,nil)
--Hotkey.AddBinding("PressMacro", "【按住执行】", "",function() end,nil)
--Hotkey.AddBinding("SetSpeed", "【执行速度】", "",function() ExucteScriptCommand("WY.SetSpeed()") end,nil)
Hotkey.AddBinding("ZMAC_开关执行", '【开关执行】','【实用PVP】', function() ExucteScriptCommand("ZMAC.AutoExcuteMacroFirst()") end, nil)
Hotkey.AddBinding("ZMAC_按住执行", '【按住执行】','', function() ExucteScriptCommand("ZMAC.AutoExcuteMacroFirstStart()") end, function() ExucteScriptCommand("ZMAC.AutoExcuteMacroFirstEnd()") end)
--//执行速度设置------------------------------------------------------------------------------
ZMAC.SetDelay = function()
	local function fnSure(nNum)
		_ZMAC.ExcuteDelay = (16/(nNum))*62.5
		OutputMessage('MSG_SYS','执行速度已设置为: '..tostring(nNum)..'次/秒。\r\n')
	end
	GetUserInputNumber(1, 1000,{1920/2,1080/2,10,10} , fnSure)
	
end
Hotkey.AddBinding("ZMAC_SetDelay", '【执行速度】','', function() ExucteScriptCommand("ZMAC.SetDelay()") end , nil)
Hotkey.AddBinding("_ZMAC_SetSelectFeet", '【选人距离】','', function() ExucteScriptCommand("_ZMAC.SetSelectFeet()") end , nil)
Hotkey.AddBinding("_ZMAC_SetSelectLife", '【选人血量】','', function() ExucteScriptCommand("_ZMAC.SetSelectLife()") end , nil)
Hotkey.AddBinding("_ZMAC_残血敌人", '【一键转火】','', function() ExucteScriptCommand("_ZMAC.SelcectDyingEnemy()") end , nil)
Hotkey.AddBinding("_ZMAC_残血队友", '【一键治疗】','', function() ExucteScriptCommand("_ZMAC.SelectDyingParty()") end, nil)
ZMAC.DelayCall = _ZMAC.DelayCall
function _ZMAC.OneKeyWantedPublish()
	loadstring([[
	local tarType,tarID = GetClientPlayer().GetTarget()
	g_Set_Wanted_Money = function()  --g_Set_Wanted_Money or 
	  local frame = Station.Lookup("Normal/Wanted_Publish")
	  if frame and frame.bPlugin then
		frame.hPlayerMoney:SetText("3000")
	  end
	end
	if tarType == TARGET.PLAYER then
	  local frame = Wnd.OpenWindow("Wanted_Publish")
	  UnRegisterEvent("ON_GET_WANTED_MIN_MONEY_LIMIT",g_Set_Wanted_Money)
	  RegisterEvent("ON_GET_WANTED_MIN_MONEY_LIMIT",g_Set_Wanted_Money)
	  frame.bPlugin = true
	  frame.hPlayerName = frame:Lookup("Edit_PlayerName")
	  frame.hPlayerMoney = frame:Lookup("Edit_PlayerMoney")
	  frame.hPlayerName:SetText(GetPlayer(tarID).szName)
	  Station.SetFocusWindow(frame.hPlayerName)
	  Station.SetFocusWindow(frame.hPlayerMoney)
	  frame:BringToTop()
	  ZMAC.DelayCall(1500,function() Wnd.CloseWindow("WantedPanel") end)
	end]])()
	
end
Hotkey.AddBinding("ZMAC_一键悬赏", '【一键悬赏】','', _ZMAC.OneKeyWantedPublish, nil)

--//Menu
function _ZMAC.AddMenu(szMenu,pSzOption,IsDevide)
	szMenu = szMenu .. "|"
	local nEnd = StringFindW(szMenu, "|")
	_ZMAC.menu = {}
	_ZMAC.menu_b = {szOption = pSzOption}
	if IsDevide == true then
		table.insert(_ZMAC.menu, {bDevide = true})
	end
	table.insert(_ZMAC.menu, _ZMAC.menu_b)

	while nEnd do
		local s = string.sub(szMenu, 1, nEnd - 1)
		if s == "" then 
			table.insert(_ZMAC.menu_b, {bDevide = true})
		else
			ZMAC.Switch[s] = true
			table.insert(_ZMAC.menu_b, {szOption = s,bCheck = true,bChecked = function() return ZMAC.Switch[s] end,fnAction = function() ZMAC.Switch[s] = not ZMAC.Switch[s] end,fnAutoClose = function() return true end})
		end
		szMenu = string.sub(szMenu, nEnd + 1, -1)
		nEnd = StringFindW(szMenu, "|")
	end
	TraceButton_AppendAddonMenu(_ZMAC.menu)
end

function ZMAC.OnMacroInit()
	local me = GetClientPlayer()
	if not me then
		return
	end

	local MyJob = GetForceTitle(GetClientPlayer().dwForceID)
	local QinggongList = '扶摇直上|蹑云逐月|凌霄揽胜|迎风回浪|瑶台枕鹤|后撤|'
	local FaskList = '全局治疗|全局转火|全局打断|全局断奶|全局群人|面对目标|背对目标|轻功躲避|跟随目标|自动绕背|下马|'
	--门派1  少林
	if MyJob == '少林' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|韦陀献杵|横扫六合|普渡四方|摩诃无量|大狮子吼|罗汉金身|归去来棍|立地成佛|万佛朝宗||拿云式|守缺式|捉影式|捕风式|抢珠式|千斤坠||锻骨诀|擒龙诀|无相诀|般若诀|轮回诀|舍身诀|舍身诀·收||二业依缘|舍身弘法|醍醐灌顶|心诤","技能开关",true) end
	--门派2  万花
	if MyJob == '万花' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|阳明指|厥阴指|太阴指|商阳指||玉石俱焚|兰摧玉折|钟林毓秀|芙蓉并蒂|快雪时晴|乱洒青荷|浮花浪蕊|听风吹雪||星楼月影|水月无间|碧水滔天|清风垂露|春泥护花|清心静气||长针|提针|握针|彼针|利针|大针|锋针||定式黑白|南风吐月|乘墨由心|洛川神韵|天工甲士|折叶笼花||守拙","技能开关",true) end	
	--门派3  天策	
	if MyJob == '天策' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|灭|突|崩|御|渊|疾||定军|霹雳|龙牙|龙吟|穿云|沧月||疾如风|守如山|啸如虎|撼如雷||断魂刺|破坚阵|任驰骋|战八方|破重围|乘龙箭|力破万钧|号令三军","技能开关",true) end
	--门派4  纯阳
	if MyJob == '纯阳' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|合虚|镇山河|生太极|吞日月|碎星辰|破苍穹|化三清|梯云纵|行天道|转乾坤|凌云剑|凌云剑·破||八荒归元|无我无剑|天地无极|万剑归宗|三环套月|人剑合一|大道无术|剑冲阴阳|剑飞惊天||太极无极|两仪化形|三才化生|四象轮回|五方行尽|六合独尊|七星拱瑞|八卦洞玄|九转归一|万世不竭||凭虚御风|坐忘无我|紫气东来|剑出鸿蒙|穹隆化生","技能开关",true) end
	--门派5 七秀	
	if MyJob == '七秀' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|剑破虚空|剑气长江|剑灵寰宇|剑影留痕|剑心通明|剑转流云|玳弦急曲|江海凝光||雷霆震怒|帝骖龙翔|天地低昂|繁音急节|名动四方|水榭花盈||风袖低昂|王母挥袂|回雪飘摇|上元点鬟|左旋右转|红绡倩风|跳珠憾玉|妙舞神扬|感时曲终||雨霖铃|鹊踏枝|蝶弄足|婆罗门|点绛唇|心鼓弦|广陵月||霜天剑泠|月出东山|余寒映日|九微飞花","技能开关",true) end	
	--门派6  五毒
	if MyJob == '五毒' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|灵蛊|幻蛊|玄水蛊|凤凰蛊||蚀心蛊|连缘蛊|圣元阵||蛊虫献祭|蛊虫狂暴||蝎心|蛇影|蟾啸|千丝|百足|化蝶||圣蝎引|灵蛇引|玉蟾引|天蛛引|风蜈引|碧蝶引||千蝶吐瑞|醉舞九天|圣手织天|冰蚕牵丝|女娲补天|蛊惑众生|仙王蛊鼎|迷仙引梦|迷仙引梦·收||蝶鸾|幻击|蝎蛰|蟾躁|蟾噬|丝牵|影滞|归巢||攻击|跟随|停留||主动型|被动型|防御型","技能开关",true) end	
	--门派7  唐门	
	if MyJob == '唐门' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|追命箭|夺魄箭|逐星箭|裂石弩|蚀肌弹|穿心弩||雷震子|迷神钉|梅花针|孔雀翎||鬼斧神工|千机变|千机变·飞天|千机变攻击|千机变停止|重弩形态|连弩形态|毒刹形态||鉆心刺骨|荆天棘地|暴雨梨花针||浮光掠影|惊鸿游龙|飞星遁影|遁影|心无旁骛|子母飞爪|暗藏杀机|图穷匕见|鸟翔碧空|鸟翔碧空·滞空|鸟翔碧空·降落||蚀肌弹·飞天|天绝地灭|天绝地灭·飞天|天绝地灭·引爆|天女散花|天女散花·飞天||百里追魂|流火连星|诡面埋伏|不负霜雪|千秋万劫|千秋万劫·开火||弩箭制造|机关制造","技能开关",true) end	
	--门派8 藏剑
	if MyJob == '藏剑' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|啸日|醉月|惊涛|听雷|探梅||泉凝月|云栖松|莺鸣柳|风吹荷||玉虹贯日|平湖断月|黄龙吐翠|梦泉虎跑|玉泉鱼跃|九溪弥烟||夕照雷峰|云飞玉皇|鹤归孤山|峰插云景|霞流宝石|风来吴山||松舍问霞|飞来闻踪|剑锋百锻","技能开关",true) end
	--门派9  丐帮
	if MyJob == '丐帮' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|笑醉狂|酒中仙|醉逍遥|祭湘君|天隼击||烟雨行||亢龙有悔|龙跃于渊|龙战于野||潜龙勿用|蜀犬吠日|恶狗拦路|犬牙交错|御鸿于天|拨狗朝天|横打双獒|棒打狗头|斜打狗背|反截狗臀|按狗低头|落水打狗||天下无狗|天下无狗瞬发||蛟龙翻江|双龙取水|龙游天地|龙腾五岳||乘龙戏水|见龙在田|神龙摆尾|飞龙在天|神龙降世||时乘六龙|狂龙乱舞|龙啸九天","技能开关",true) end
	--门派10  明教
	if MyJob == '明教' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|暗尘弥散|暗尘弥散·解|怖畏暗刑|贪魔体||日月晦|日月晦·月|日月晦·晦|生灭予夺|冥月渡心|伏明众生|诛邪镇魔|净世破魔击|生死劫|光明相|极乐引|驱夜断愁|银月斩|烈日斩|幽月轮|赤日轮|幻光步|流光囚影|暗步追踪|寒月耀|无明魂锁|明齐日月|微妙风|慈悲愿|戒火斩|渡厄力|心火叹|朝圣言","职业技能",true) end
	--门派21 苍云
	if MyJob == '苍云' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|盾压|盾猛|盾击|盾刀||绝刀|斩刀|闪刀|隐刀|血刀|劫刀||盾飞|收盾|盾回|盾立|盾壁|盾墙|盾毅|盾抛|盾挡|盾反|盾舞|盾舞·强化||撼地|血怒|无惧||扬旌沙场|断马摧城|矢尽兵穷|寒啸千军","技能开关",true) end
	--门派22  长歌
	if MyJob == '长歌' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|宫|商|角|徵|羽||变宫|变徵||剑·宫|剑·商|剑·羽||高山流水|阳春白雪|平沙落雁|梅花三弄||移形换影|清音长啸|清绝影歌|孤影化双|一指回鸾|||青霄飞羽云生结海|江逐月天|迴梦逐光|笑傲光阴||疏影横斜|琴音共鸣|歌尽影生|杯水留影||游太清|不愧君","技能开关",true) end
	--门派23 霸刀
	if MyJob == '霸刀' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|松烟竹雾|秀明尘身|雪絮金屏||停止释放||龙骧虎步|踏宴扬旗|雷走风切||擒龙六斩|逐鹰式|控鹤式|起凤式|腾蛟式|擒龙式|降麒式||碎江天|散流霞|闹须弥||临渊蹈河|刀啸风吟|醉斩白蛇|坚壁清野|楚河汉界||封渊震煞|西楚悲歌|项王击鼎|破釜沉舟|割据秦宫|上将军印||鸣震九霄|横断山河|横断山河·二式","技能开关",true) end	
	--门派24 蓬莱
	if MyJob == '蓬莱' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|击水三千|木落雁归|定波砥澜|定波砥澜·反击|海运南冥|溟海御波|逐波灵游|跃潮斩波||翼绝云天|翼绝云天·召回|驭羽骋风|疾电叱羽|振翅图南|翔极碧落|空桑舞瑟||鸿渐于飞|飞刃破风|澹然若海|飞倾列缺|风云重锁||浮游天地|浮游天地·落地|逸尘步虚|物化天行|物化天行·上升","技能开关",true) end	
	--门派25 凌雪
	if MyJob == '凌雪' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|星垂平野|金戈回澜|骤雨寒江||横云意|寂洪荒|乱天狼|隐风雷|斩无常||日月吴钩|崔嵬鬼步|飞刃回转|十方玄机|血覆黄泉|幽冥窥月|铁马冰河|孤风飒踏||青山共我|修罗暗度|链魂","技能开关",true) end	
	--门派211 衍天
	if MyJob == '衍天' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|三星临|兵主逆|天斗旋|往者定|踏星行|神皆寂||纵横三才·一|纵横三才·二|纵横三才·三||起卦|祝由·水坎|祝由·山艮|祝由·火离|变卦|奇门飞宫|鬼星开穴|返闭惊魂|天人合一|天人合一·解|巨门北落|斗转星移|鸿蒙天禁||龙马出河|杀星在尾|连极阵|天杀","技能开关",true) end	
	--门派212 药宗
	if MyJob == '药宗' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."|商陆缀寒|钩吻断肠|川乌射罔|沾衣未妨|且待时休||银光照雪|凌然天风|惊鸿掠水|回风微澜|含锋破月|飞叶满襟||白芷含芳|赤芍寒香|当归四逆|龙葵自苦|七情和合|灵素还生||千枝绽蕊|千枝伏藏|苍棘缚地|紫叶沉疴|青川濯莲|逐云寒蕊|绿野蔓生|枯木苏息||并蒂夺株|青圃着尘|百药宣时|旋生飞草","技能开关",true) end	
	--门派0 江湖
	if MyJob == '江湖' then _ZMAC.AddMenu("启用PVE宏||"..QinggongList..FaskList .."","技能开关",true) end	


	if not ZMAC.Switch then 
		_ZMAC.AddMenu("启用PVE宏||"..FaskList .."|菜单错误","技能开关",true)	
	end
	ZMAC.Switch['启用PVE宏'] = false
	OutputMessage('MSG_SYS','欢迎使用【实用PVP】,宏管理器长度已改为50000,可直接改写使用。命令/cast /config /use等。 \r\n')

end

ZMAC.OnMacroInit()
-- RegisterEvent("LOADING_ENDING", function()
	-- ZMAC.OnMacroInit()
-- end)


ZMAC.transMacro = {}
ZMAC.transMacro.jiemiZMAC = function(str)
	local tmp = ''
	tmp = s_gsub(str, "['=''N''O''a''b''c''t''u''w''x''H''V''I''W''J''X''K''Y''L''Z''o''M''p''0''q''1''r''2''s''3''4''6''5''7''d''8''e''9''f''+''g''P''h''Q''i''R''j''m''k''n''l''A''B''C''D''S''E''T''F''U''G''/''v''y''z''\r''\n''\r']", _Dictmacro2base_ZMAC)
	tmp = _Base64.decode(tmp) 
	tmp = s_gsub(tmp ,'\r\n','\n')--不加这句的话,会bug,加密器加密过来的数据,换行符有的是\n  有的是\r  有的是\r\n        但是jx3 lua换行只认\n  所以要把所有\r替换掉
	--tmp = s_gsub(tmp ,'\r','')      --已废弃,因为有可能误伤\r的字符串
	return tmp
end

ZMAC.BreatheCall = _ZMAC.BreatheCall
ZMAC.GetOta = _ZMAC.GetOta
ZMAC.UseSkill = _ZMAC.UseSkill
ZMAC.IsMindSever =_ZMAC.IsMindSever
ZMAC.GetOta =_ZMAC.GetOta
ZMAC.GetSkillNum = _ZMAC.GetSkillNum
ZMAC.SmartRefreshBuff = _ZMAC.SmartRefreshBuff
ZMAC_CheckBuff = _ZMAC_CheckBuff
ZMAC.WriteToFile = _ZMAC.WriteToFile
ZMAC.GetSkillIdEx = _ZMAC.GetSkillIdEx
ZMAC.GetSkillNum = _ZMAC.GetSkillNum
ZMAC.SetInsTarget = _ZMAC.SetInsTarget
ZMAC.SetTarget = _ZMAC.SetTarget
ZMAC.TurnToTarget = _ZMAC.TurnToTarget
ZMAC.UseSkill = _ZMAC.UseSkill
ZMAC.CancelBuff = _ZMAC.CancelBuff
ZMAC.GetDistance = _ZMAC.GetDistance


ZMAC.ChatWith = function(pName)
	local hPlayer = GetClientPlayer()
	for k , v in pairs(GetAllNpc()) do       --k为物品dwID,value是类型  
		local Dis = GetCharacterDistance(hPlayer.dwID, v.dwID) / 64
		if Dis < 6 then
			if v.szName == pName or v.dwID == pName then
				--Output(v.szName)
				InteractNpc(v.dwID)
			end 
		end
	end
	
	for kk , vv in pairs(GetAllDoodad()) do       --k为物品dwID,value是类型
		local nX,nY,nZ = vv.nX, vv.nY, vv.nZ
		local Dis2 = m_floor(((hPlayer.nX - nX) ^ 2 + (hPlayer.nY - nY) ^ 2 + (hPlayer.nZ/8 - nZ/8) ^ 2) ^ 0.5)/64
		if Dis2 < 6 then 		
			if vv.szName == pName or vv.dwID == pName then
				InteractDoodad(vv.dwID)	
			end
		end
	end
end


function _ZMAC.RoundBuff()  --不能用，会检测
	for k,v in pairs(GetAllPlayer()) do
		--Output(v.dwID)
		_ZMAC.SmartRefreshBuff(v.dwID)
	end
end

--_ZMAC.BreatheCall('ZMAC_RoundBuff',function() _ZMAC.RoundBuff() end,62.5)   --此功能运行才几分钟就断开了服务器连接，会被检测


ZMAC.RoundBuff = _ZMAC.RoundBuff

--字符串找功能
--SaveDataToFile(EncodeData(var2str(g_tStrings),true,false),"E:/JX3/Game/JX3/bin/zhcn_hd/interface/g_tStrings.lua")
ZMAC.GetReduction = _ZMAC.GetReduction
ZMAC.AutoHunDeng = _ZMAC.AutoHunDeng
