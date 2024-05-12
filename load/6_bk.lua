--//��ʼ��
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

_ZMAC.Macro = {}    --�������ϵͳ��������༭ʱ���Զ������������˱�
ZMAC.Switch = {}    --���ܿ���

local aCommand = {}  --�������ֵ���������ӡ�/cast��ָ���롰Cast�� function
local aCommandHelp = {}  --������ĵ�
local bIsThisAccount = true   
local ConfigFlag = true  --config�����õı������ж������Ƿ����
local bProtectChannel = false			--/config�Ƿ񱣻�����

WY={} --�Ϻ�����

local SCHOOL_NAME = {
	["��ʿ"] = 0,
	["���"] = 1,
	["��"] = 2,
	["����"] = 3,
	["����"] = 4,
	["����"] = 5,
	["�ؽ�"] = 6,
	["ؤ��"] = 7,
	["����"] = 8,
	["�嶾"] = 9,
	["����"] = 10,
	["ؤ��"] = 0,
	--...
}

local KUNG_FU_MOUNT = {
	["��Ѫս��"] = 10026,
	["������"] = 10062,
	["�׽"] = 10003,
	["ϴ�辭"] = 10002,
	["��ˮ��"] = 10144,
	["ɽ�ӽ���"] = 10145,
	["̫̓����"] = 10015,
	["��ϼ��"] = 10014,
	["���ľ�"] = 10081,
	["�����ľ�"] = 10080,
	["�뾭�׵�"] = 10028,
	["������"] = 10021,
	["���޹��"] = 10225,
	["�����"] = 10224,
	["�����"] = 10176,
	["����"] = 10175,
	["��Ӱʥ��"] = 10242,
	["����������"] = 10243,
	["Ц����"] = 10268,
	["��ɽ��"] = 10390,
	["������"] = 10389,
}

local TARGET_TYPE ={
	["���"] = TARGET.PLAYER,
	["��ͨ"] = 1,
	["����"] = 2,
	["ͷĿ"] = 3,
	["����"] = 4,
}

local MOVE_STATUS = {
	["dash"] = MOVE_STATE.ON_DASH,						--�n��
	["death"] = MOVE_STATE.ON_DEATH,					--�؂�
	["entrap"] = MOVE_STATE.ON_ENTRAP,					--����
	["float"] = MOVE_STATE.ON_FLOAT,					--ˮ�БҸ�
	["freeze"] = MOVE_STATE.ON_FREEZE,					--����
	["halt"] = MOVE_STATE.ON_HALT,						--ѣ��
	["jump"] = MOVE_STATE.ON_JUMP,						--���S
	["back"] = MOVE_STATE.ON_KNOCKED_BACK,				--������
	["down"] = MOVE_STATE.ON_KNOCKED_DOWN,				--������
	["off"] = MOVE_STATE.ON_KNOCKED_OFF,				--�����w
	["pull"] = MOVE_STATE.ON_PULL,						--��ץ
	["repulsed"] = MOVE_STATE.ON_REPULSED,				--����
	["rise"] = MOVE_STATE.ON_RISE,						--����
	["run"] = MOVE_STATE.ON_RUN,						--�ܲ�
	["sit"] = MOVE_STATE.ON_SIT,						--����
	["skid"] = MOVE_STATE.ON_SKID,						--����
	["stand"] = MOVE_STATE.ON_STAND,					--վ��
	["swim"] = MOVE_STATE.ON_SWIM,						--��Ӿ
	["swimjump"] = MOVE_STATE.ON_SWIM_JUMP,				--ˮ�����S
	["walk"] = MOVE_STATE.ON_WALK,						--��·
	["move"] = 26,						--����λ�Ơ�B
	["bmove"] = 27,						--����λ�Ơ�B
	["Ӳֱ"] = 28,						--Ӳֱ
}

local nMoveStateList = {       --Ե����û��MOVE_STATE��������Ҫ�ֶ���or����
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
	['repulsed']=MOVE_STATE.ON_REPULSED or 19,  --����
	['rise'] = MOVE_STATE.ON_RISE or 20,
	['skid'] = MOVE_STATE.ON_SKID or 21,
	['sprintbreak'] =MOVE_STATE.ON_SPRINT_BREAK or 22,
	["move"] = 26,						--����λ�Ơ�B
	["bmove"] = 27,						--����λ�Ơ�B
	["recover"] = 28,						--Ӳֱ
	['invalid'] = MOVE_STATE.INVALID or 0,   --����λ�ơ���ֱ�����С����С��Ṧ���Ƕ����������յ�δд
}

--���������ļ���,���ڼ�¼�Լ�����ͷż��ܵ�ʱ��,��function Cast�м�����������ִֹ�й���϶���
local SelfProtectSkill ={
	['������']=true,
	['����']=true,
	['���϶���']=true,
	['�������']=true,
	['��ѩʱ��']=true,
	['������ɽ']=true,
	['�������']=true,
	['ǧ������']=true,
	['���Ҽ���']=true,
	['��ѩƮҡ']=true,
	['������ת']=true,
	['�»���к']=true,
	['��������']=true,
	['Ц���']=true,
	['����']=true,
	['�����滨��']=true,
	['������']=true,
	['��ʥ��']=true,
	['��������']=true,
	['��ն����']=true,
	--['��������']=true,
	['��']=true,
	['��������']=true,
	['ն�޳�']=true,
	['���޹�']=true,
	
}

local btype = {}
btype[1] = '�⹥'
btype[3] = '����'
btype[5] = '��Ԫ'
btype[7] = '����'
btype[11] = '����'
btype[13] = '��'
local detype = {}
detype[2] = '�⹥'
detype[4] = '����'
detype[6] = '��Ԫ'
detype[8] = '����'
detype[10] = '��Ѩ'
detype[12] = '����'
detype[14] = '��'

--͸֧����ʱ���ֵ䣬�����ж�͸֧���ܲ���,cd�����
_ZMAC.TouzhiSkillList = {
	[16602]={9,2},          --�Ƹ�����
	[16629]={16,3},         --���߷���
	[16608]={40,3},         --ɢ��ϼ
	[16633]={20,3},         --̤������
	[16479]={16,3},         --����ع�
	[16620]={40,2},         --��Ԩ��ɷ
	[27556]={10,2},         --��������
	[312]  ={18,2},          --��������
	
	[28680]={35,3},         --�������
	}


_ZMAC.Pup={
	['����'] = 16175,
	['����'] = 16176,
	['��ɲ'] = 16177,
	['����'] = 16174,
}
--���＼��ID
local g_PetSkillNameToID = {['������']=2225,['ʥЫ��']=2221,['������']=2224,['������']=2223,['�����']=2222,['�̵���']=2965}
--�Ᵽ����������
local Dict_NoBrokenSKill={
	['�ж϶���']=true,
	['������ѩ']=true,
	['����']=true,
	['���Ŀ��']=true,
	['���﹥��']=true,['�������']=true,['����ͣ��']=true,['������']=true,['������']=true,['������']=true,
	['ɿŪ']=true,['�鳲']=true,['˿ǣ']=true,['Ы��']=true,['Ӱ��']=true,['�û�']=true,['���']=true,
	['ǧ���乥��']=true,['ǧ����ֹͣ']=true,
	['������̬']=true,['������̬']=true,['��ɲ��̬']=true,['����']=true,['����']=true,['��ɲ']=true,
	['���ص�¼']=true,
	['�Ϸ�����']=true,['��Ҷ����']=true,['��ɽ��']=true, --��������,���ӱ���
}

_ZMAC.FakeSkillList = {
	['���ص�¼']=true,
	['�Զ����']=true,
	['�Զ����2']=true,
	['ȫ������']=true,
	['ȫ�ִ��']=true,
	['ȫ�ֶ���']=true,
	['ȫ��ת��']=true,
	['ȫ��Ⱥ��']=true,
	['ȫ�־���']=true,
	
	['���ǡ���']=true,
	['ȫ��ʴ��']=true,
	['�ж϶���']=true,
	['����Լ�']=true,
	['ִֹͣ��']=true,
	['ֹͣ�ƶ�']=true,
	['���Ŀ��']=true,
	['����Ŀ��']=true,
	['�Զ��Ʊ�']=true,
	['��ǰ�ƶ�']=true,
	['����ƶ�']=true,
	['ѡ���Լ�']=true,
	['�ƶ�']=true,
	['��ħ']=true,
	['�Ṧ���']=true,
	['�Ʊ�']=true,
	['����']=true,
	['����Ŀ��']=true,
	['С�Ṧ']=true,
	['����']=true,
	['��']=true,
	['�����Ṧ']=true,
	['��ǰ�Ṧ']=true,
	['����Ṧ']=true,
	['��ǰ���Ṧ']=true,
	['������Ṧ']=true,
	['���»ޡ���']=true,
	['���޹�']=true,
	['������ǰ']=true,
	['�����к�']=true,
	['��������']=true,
	['��������']=true,
	
	['���»�һ�μ�']=true,
	['���»޶��μ�']=true,
	['���»����μ�']=true,
	
}

local BaseSkillList = {
			['���Ϲ�'] =  11,
			['÷��ǹ��'] =  12,
			['���񽣷�'] =  13,
			['��ȭ']=14,  
			['����˫��']= 15,
			['�йٱʷ�'] = 16,
			['�ļ�����']=1795,	
			['��ĵѷ�']=2183, 			
			['��ڷ�']=3121,
			['��Į����']=4326,
			['��ѩ��']=13039, 
			['��������']=14063,  
			['˪�絶��']=16010, 
			['Ʈңɡ��']=19712,
			['�����']=22126, 
			['���']=25512, 
			['��Ҷ����'] = 27451,
			['ҩ��δ֪����']=000,   --������
			}
			
--�ؼ��б�
_ZMAC.tAllRecipeList={}         --��ȡȫְҵ�����ؼ��б� szRecipeNmae = recipe_id
do
	for i=1,g_tTable.SkillRecipe:GetRowCount() do
		
		local tSkillRecipe = g_tTable.SkillRecipe:GetRow(i)
		if tSkillRecipe then
			local szName = tSkillRecipe.szName
			if szName and szName~='' and tSkillRecipe.dwSkillID~=0 then
				local szSkillName,szRecipe = szName:match('��(.+)��(.+)')
				if szSkillName and szRecipe then
					_ZMAC.tAllRecipeList[szSkillName..szRecipe] = {tSkillRecipe.dwID , tSkillRecipe.dwSkillID}
				end
			end
		end
	end
end

--//�ӽ���
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
			t[i]=EncodeSZ(v,255,0,0)    --��д��Ĭ�Ϻ�ɫ
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
		szHead = szHead or '�������'
		szType = szType or 'MSG_SYS'
		local tTime = TimeToDate((GetLocalTime()))
		OutputMessage(szType, '['..s_format('%02d:%02d:%02d',tTime.hour, tTime.minute, tTime.second)..'  '..szHead .. '] ' .. szMsg .. '\n')
	end
end
-- �������ݔ��һ���S�֣�ֻ�Ю�ǰ�Ñ���Ҋ��
-- (void) WY.Sysmsg(string szMsg[, string szHead])
-- szMsg -- Ҫݔ�������փ���
-- szHead -- ݔ��ǰ�Y���ԄӼ�������̖��Ĭ�J�飺�������
WY.Sysmsg = function(szMsg, szHead, szType)
	szHead = szHead or "��"
	szType = szType or "MSG_SYS"
	OutputMessage(szType, "[" .. szHead .. "] " .. szMsg .. "\n")
end
-- �������ݔ���{ԇ��Ϣ���� WY.Sysmsg ��ƣ�����2�����څ^�ֵķ�̖��ӛ
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
	nTime = nTime or 62.5 --Ĭ���ӳ�1��16��
	local key = StringLowerW(szKey)
	if fnAction and type(fnAction) == 'function' then 	--����еڶ�����������ע��
		local nFrame = 1
		if nTime and nTime > 0 then
			nFrame =  m_ceil(nTime / 62.5)
		end
		local data = tBreatheCall[key]
		if not data then
			tBreatheCall[key] = { fnAction = fnAction, nNext = GetLogicFrameCount() + 1, nFrame = nFrame }
			--_ZMAC.Debug3('Start # ' .. szKey .. ' # ' .. nFrame)
		end
	else --���û�еڶ�����������ֱ��ע������
		local data = tBreatheCall[key]
		if data then
			tBreatheCall[key] = nil
			--_ZMAC.Debug3('Stop # ' .. szKey)
		end
	end
end
--//���ָ�������Ƿ���ִ��
function _ZMAC.CheckBreatheCall(szKey)
	local data = tBreatheCall[StringLowerW(szKey)]
	if data then return true end
	return false
end
--//�������Ƿ�Ϊ��
function _ZMAC.CheckAllBreatheCall()
	_ZMAC.Debug3('tBreatheCall # ' .. tostring(#tBreatheCall))
	if #tBreatheCall > 0 then
		return true
	end
	return false
end
--//��ָ�������ӳ�
_ZMAC.BreatheCallDelay = function(szKey, nTime)
	local t = tBreatheCall[StringLowerW(szKey)]
	if t then
		t.nFrame =  m_ceil(nTime / 62.5)
		t.nNext = GetLogicFrameCount() + t.nFrame
	end
end
--//��ָ������������ʱ
_ZMAC.BreatheCallDelayOnce = function(szKey, nTime)
	local t = tBreatheCall[StringLowerW(szKey)]
	if t then
		t.nNext = GetLogicFrameCount() +  m_ceil(nTime / 62.5)
	end
end
--//����ͬ_ZMAC.BreatheCall��tSystemBreatheCallע����tSystemBreatheCall{}
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
--��ʱִ��funcһ��
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
--//ִ��EVENT
function EventHandler(szEvent)
	-- local nTime = GetTime()
	for k, v in pairs(_ZMAC_EVENT[szEvent]) do
		local res, err = pcall(v, szEvent)
		if not res then
			_ZMAC.Debug3('EVENT#' .. szEvent .. '.' .. k ..' ERROR: ' .. err)
		end
	end
	-- �������������������
	-- Log('EventHandler ' .. szEvent .. ' cost:' .. GetTime() - nTime ..'ms')
end
--//ִ��Sys_EVENT
function EvenSystHandler(szEvent)
	-- local nTime = GetTime()
	for k, v in pairs(_ZMAC_Sys_EVENT[szEvent]) do
		local res, err = pcall(v, szEvent)
		if not res then
			_ZMAC.Debug3('EVENT#' .. szEvent .. '.' .. k ..' ERROR: ' .. err)
		end
	end
	-- �������������������
	-- Log('SysEventHandler ' .. szEvent .. ' cost:' .. GetTime() - nTime ..'ms')
end
--//ע���¼�����ϵͳ���������ڿ���ָ��һ�� KEY ��ֹ��μ���
--//szEvent.szKey,����ӵ��ʶ�ַ���,��ֹ�ظ�/ȡ����,�� LOADING_END.xxx
--//fnAction(arg0~arg9),����nil�൱��ȡ�����¼�
--//�ر�ע�⣺�� fnActionΪnil����szKeyҲΪnilʱ��ȡ������ͨ��������ע����¼�������
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
--//����ZMAC_RegisterEvent��ʵ�ְ���ע���¼�
function ZMACRegisterEvent(szEvent, fnAction)
	if type(szEvent) == 'table' then
		for _, v in ipairs(szEvent) do
			ZMAC_RegisterEvent(v, fnAction)
		end
	else
		ZMAC_RegisterEvent(szEvent, fnAction)
	end
end
--//ע���¼�����
function ZMACUnRegisterEvent(szEvent)
	if type(szEvent) == 'table' then
		for _, v in ipairs(szEvent) do
			ZMACRegisterEvent(v, nil)
			_ZMAC.Debug3('UnRegisterEvent # szEvent: ' .. v .. ' ע���ɹ���')
		end
	else
		ZMACRegisterEvent(szEvent, nil)
		_ZMAC.Debug3('UnRegisterEvent # szEvent: ' .. szEvent .. ' ע���ɹ���')
	end
end
--//ע�������¼�����
function ZMACUnRegisterAllEvent()
	for k, v in pairs(_ZMAC_EVENT) do
		ZMACUnRegisterEvent(k)
	end
end
--//����ͬ
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
--//����ͬ
function ZMACUnRegisterSysEvent(szEvent)
	ZMACRegisterSysEvent(szEvent, nil)
end

--//ע��
if _ZMAC.FightBeginTime==nil  then _ZMAC.FightBeginTime= 0   end     --ս��ʱ��
if not _ZMAC.tCast then _ZMAC.tCast={} end               --��¼��ʷ�����ͷ�
if not _ZMAC.tHit then _ZMAC.tHit={}   end               --��¼��ʷ�����ܹ���
if not _ZMAC.aPlayer then _ZMAC.aPlayer={}   end             --��¼������
if not _ZMAC.aNpc then _ZMAC.aNpc={} end 
if not _ZMAC.TargetLog then _ZMAC.TargetLog = {} end

            
--���/NPC�����б��¼�
RegisterEvent("PLAYER_ENTER_SCENE", function()
	_ZMAC.tCast[arg0]={}
	_ZMAC.tHit[arg0]={} 
	_ZMAC.aPlayer[arg0] = {} --ȫ�����ID�б�
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

-- ȡ��ǰĿ�꼰�л�ʱ�䣬�����ж���Ŀ��ʱ�䣬��ֹ�ж�Ŀ��buff��ȡ��ʱ���µļ�����
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


--��Ҽ����ͷ���ʷ&lastcast&mcast&mhit...
WY.nLastOtaTime = 0
WY.BailiTarget = nil
WY.Baili_nX = -1
WY.Baili_nY = -1
WY.Baili_nZ = -1


--�����������ʼ(channel)
--[[ --2022.5.2,�˴�������bug������
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
		
		if  name == "����" or name == "���϶���" or name == "�������" or name == "��ѩʱ��" or name == "������ɽ" or name == "�������" or name == "ǧ������" or name == "���Ҽ���" or name == "��ѩƮҡ" or name == "������ת" or name == "�»���к" or name == "��������" or name == "������" or name == "Ц���" or name == "����" or name == "�����滨�" or name == "������" then
			WY.nLastOtaTime = GetTickCount()
		end
		
		--tbechasing(Ŀ���ڱ��Լ�����)
		--tbechasingdistance(Ŀ�����������ĵľ���)
		if name == '����׷��' then
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

--�������������ʼ(prepare)


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
		
		if  name == "����" or name == "���϶���" or name == "�������" or name == "��ѩʱ��" or name == "������ɽ" or name == "�������" or name == "ǧ������" or name == "���Ҽ���" or name == "��ѩƮҡ" or name == "������ת" or name == "�»���к" or name == "��������" or name == "������" or name == "Ц���" or name == "����" or name == "�����滨�" or name == "������" then
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

--ȫ�����м����ͷ�(�����������ܿ�ʼ��ֻ�������У�)
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
ZMACRegisterSysEvent("SYS_MSG.ZMAC" , function()                --ս��Ƶ���ļ����˺��¼�
    if arg0 =='UI_OME_SKILL_EFFECT_LOG' then
		--arg1Ϊ�����ߵ�id,arg2Ϊ�������Ľ�ɫID,arg3δ֪,arg4 5 6δ֪,arg7Ϊ����id,arg8δ֪,arg9Ϊ�ü�����ɵ��˺��б�
		for k, v in ipairs({
		SKILL_RESULT_TYPE.PHYSICS_DAMAGE, --�⹦�˺�
		SKILL_RESULT_TYPE.SOLAR_MAGIC_DAMAGE,  --�����ڹ��˺�
		SKILL_RESULT_TYPE.NEUTRAL_MAGIC_DAMAGE, --��Ԫ�ڹ�
		SKILL_RESULT_TYPE.LUNAR_MAGIC_DAMAGE,  --�����ڹ�
		SKILL_RESULT_TYPE.POISON_DAMAGE, --����
		SKILL_RESULT_TYPE.REFLECTIED_DAMAGE, --����
		--SKILL_RESULT_TYPE.THERAPY, --����
		SKILL_RESULT_TYPE.STEAL_LIFE, --��ȡ����
		SKILL_RESULT_TYPE.ABSORB_DAMAGE, --����
		SKILL_RESULT_TYPE.SHIELD_DAMAGE , --����
		SKILL_RESULT_TYPE.PARRY_DAMAGE, --����
		SKILL_RESULT_TYPE.INSIGHT_DAMAGE,--ʶ��
		--SKILL_RESULT_TYPE.TRANSFER_LIFE, --xx��ȡ��xx��xx��
		--SKILL_RESULT_TYPE.TRANSFER_MANA,--����
		}) do
			if arg9[v]  then  --and arg9[v] > 0    arg9[v]Ϊ�ü�������ɵ��˺�
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
		
		if  name == "����" or name == "���϶���" or name == "�������" or name == "��ѩʱ��" or name == "������ɽ" or name == "�������" or name == "ǧ������" or name == "���Ҽ���" or name == "��ѩƮҡ" or name == "������ת" or name == "�»���к" or name == "��������" or name == "������" or name == "Ц���" or name == "����" or name == "�����滨��" or name == "������" then
			WY.nLastOtaTime = GetTickCount()
			
		--tbechasing(Ŀ���ڱ��Լ�����)
		--tbechasingdistance(Ŀ�����������ĵľ���)
		-- if name == '����׷��' then
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
--//�ַ������ָ��ϵ��<>=
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
--//�ַ������ַ������ַ�����
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

--�ڴ�ǿˢbuff
_ZMAC.SmartRefreshBuff = function(dwID)
	if g_RefreshBuff then
		if ZMAC.Switch['ǿ��ȡbuff'] == true then
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
	local nowSever = GetUserServer() --�˺����᷵�ض������ֵ,��ʱnowSeverΪ��һ������ֵ,һ��Ϊ�����������(������/���ɴ�����)
	if nowSever=='������' then return true end
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
	if not nY and not nZ then --���ֻ�е�����������ô����ΪĿ��
		local tar = nX
		nX, nY, nZ = tar.nX, tar.nY, tar.nZ
	elseif not nZ then  --�����������������ΪX��Y����
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
	if cmd == '����' or cmd == '��' then
		return 9007
	elseif cmd == '����' or cmd == '������̬' then
		return 3369
	elseif cmd == '����' or cmd == '������̬' then
		return 3368
	elseif cmd == '��ɲ' or cmd == '��ɲ��̬' then
		return 3370	
	elseif cmd == '���﹥��' then
		return 2442
	elseif cmd == '�������' then
		return 2446
	elseif cmd == '����ͣ��' then
		return 2447
	elseif cmd == '������' then
		return 2443
	elseif cmd == '������' then
		return 2444
	elseif cmd == '������' then
		return 2445
	elseif cmd == 'ǧ���乥��' then
		return 3360
	elseif cmd == 'ǧ����ֹͣ' then
		return 3382
	elseif cmd == 'ɿŪ' then
		return 2542
	elseif cmd == '�鳲' then
		return 23337
	elseif cmd == '˿ǣ' then
		return 2479
	elseif cmd == 'Ы��' then
		return 2475
	elseif cmd == 'Ӱ��' then
		return 2478
	elseif cmd == '�û�' then
		return 2477
	elseif cmd == '���' then
		return 2476
	elseif cmd == '��Ӱ��һ' then
		return 17587
	elseif cmd == '��Ӱ����' then
		return 17588
	-- elseif cmd == '��Ӱ' then     --��Ӱ��Ҫ��UI�ķ�ʽ���⴦��
		-- return 17587 -- {17587,17588}
	elseif tonumber(cmd) then
		return tonumber(cmd)
	end
	local  nSkillID =  g_SkillNameToID[cmd]
	local hPlayer = GetClientPlayer()
	local tmpNum = 999 -- �������м��ܶ�������ʱ����¼���ܵ���Сnum,��ֹ������̬���µ�������̬����ȫ���޷�UITestCast+����id�Ǹ���+�ü����Ѿ����ͷ�����£�ȡ����id��׼�����µ�num��׼�����û���ͷţ�������id�ļ��ܲ���һ�£���bug��
	local ttt = nSkillID
	if nSkillID and type(nSkillID) == 'table' then
		for k, v in pairs(nSkillID) do
			local Skill = GetSkill(v, hPlayer.GetSkillLevel(v))
			if Skill and Skill.UITestCast(hPlayer.dwID, IsSkillCastMyself(Skill)) and (not s_find(Table_GetSkillDesc(v,1),'��ʽ��ɾ��')) then
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
--��ȡ������Ϣ�б������������ִ�гɹ������ؼ�����Ϣ��һ��table��������"CastTime": �ͷ�ʱ�䣬�������෵��ֵ��������
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
	return "����"
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
	--2022.6.12,�˴���BUG����GCD�ڼ䣬���ܼ��ܻ��ж�Ϊtrue�����ǳ����ж�Ϊfalse���ᵼ�´�ʱ�����ͷź������λ�ÿ���Ķ������ܣ�
	--[[���磺/cast ������
			  /cast �춷��
	--�����]]

	if cmd == '�춷��' or cmd == 24816  or cmd == 24817  or cmd == 24818 or cmd == 24372 then
		local KungfuMount = _ZMAC.MySchoolName()
		local gcdID=605 --����
		if KungfuMount=='��Ӱʥ��' or KungfuMount=='����������' then
			gcdID=3962 --������
		elseif KungfuMount=='Ц����' then
			gcdID=5258 --��������
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
	
	--if not _ZMAC.IsMindSever()  then  --��ʽ��,������ȡ
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
	
	if (...)~=nil then              --���ж϶����ٷֱȵ�ʱ��,������������,��ʱstr����ΪcNum,(...)Ϊ�Ƚ�cType
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
	if (bPrePare == 1 or bPrePare == 9) and otaType == 'prepare' then --�����޹��Ķ�����9
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
	if not xPlayer then return Output('����������Ҳ�����') end
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
		--_ZMAC.Print('MSG_SYS','�޴��ؼ���'..szRecipeName..'��\n')
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
--[buff/buffid/bufftime]��buff����buffʱ�䡢buff����
local _ZMAC_CheckBuff2 = function(t, str,TimeorStack,SrcSelf)
	if not t then return false end
	--Output(s_find(str, '-'))
	_ZMAC.SmartRefreshBuff(t.dwID)
	if not t.GetBuffCount() then return false end
	for i = 1, t.GetBuffCount(), 1 do   --���ƿ��٣��㷨���Ż�
		local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = t.GetBuff(i - 1)
		if dwID and nEndFrame -GetLogicFrameCount() >0  then
		--Output(str,1)
			local Buffstrs = _ZMAC_SplitStr2Array(str, '|')
			for _,Buffstr in ipairs(Buffstrs) do
			--Output(Buffstrs)
				local Boolean,BuffName,cType,cNum = _ZMAC_SplitRelationSymbol(Buffstr,'[><=]')

				if not SrcSelf or (SrcSelf and dwSkillSrcID == GetClientPlayer().dwID) then    --�ж��Ƿ����Լ���buff
					if TimeorStack== 't' then
						if Boolean then
							--local BuffTime = m_ceil((nEndFrame - GetLogicFrameCount()) / GLOBAL.GAME_FPS)
							local BuffTime = _ZMAC.Decimal((nEndFrame - GetLogicFrameCount()) / GLOBAL.GAME_FPS)
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								--Output(BuffTime)
								if _ZMAC_Compare(cType,BuffTime, cNum) then return true end
							end
						else       --ʱ���ж���ʱ��Ӧ��û�������֧�Ŷԣ�����
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								return true
							end
						end
					elseif TimeorStack== 's' then
						
						if Boolean then      --�ж�����
							local StackNum = nStackNum
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								if _ZMAC_Compare(cType, StackNum, cNum) then
									return true
								end
							end
						else               --�ж�����buff
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
	
	for i = 1, t.GetBuffCount(), 1 do   --���ƿ��٣��㷨���Ż�
		local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = t.GetBuff(i - 1)
		if dwID   then   --nEndFrame -GetLogicFrameCount()>0    ��������ڴ�ǿˢbuff��ǿˢ�з�������ʱ������ÿ��ȡ��������һ��ˢ����buff��,��ô�ʹ��ھ�buff�ж�������
		
			local Buffstrs = _ZMAC_SplitStr2Array(str, '|')
			for _,Buffstr in pairs(Buffstrs) do
			
				local Boolean,BuffName,cType,cNum = _ZMAC_SplitRelationSymbol(Buffstr,'[><=]')
				
				
				if not SrcSelf or (SrcSelf and dwSkillSrcID == GetClientPlayer().dwID) then    --�ж��Ƿ����Լ���buff
					if TimeorStack== 't' then
						if Boolean then
							--local BuffTime = m_ceil((nEndFrame - GetLogicFrameCount()) / GLOBAL.GAME_FPS)
							local BuffTime = _ZMAC.Decimal((nEndFrame - GetLogicFrameCount()) / GLOBAL.GAME_FPS)
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								--Output(BuffTime)
								if _ZMAC_Compare(cType,BuffTime, cNum) then return true end
							end
						else       --ʱ���ж���ʱ��Ӧ��û�������֧�Ŷԣ�����
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								return true
							end
						end
					elseif TimeorStack== 's' then
						
						if Boolean then      --�ж�����
							local StackNum = nStackNum
							if Table_GetBuffName(dwID, nLevel) == BuffName or dwID==tonumber(BuffName) then
								if _ZMAC_Compare(cType, StackNum, cNum) then
									return true
								end
							end
						else               --�ж�����buff
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
		if str =='����' then
			return _ZMAC.CheckStatus(hPlayer,'halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='����' then  
			return _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='�ɿ�' then
			return not _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid|move|vmove')
		elseif str =='��ս' then
			return _ZMAC.CheckMount(hPlayer,'��Ѫս��|������|�׽|ϴ�辭|��ˮ��|ɽ�ӽ���|̫�齣��|��Ӱʥ��|����������|Ц����|��ɽ��|������|������|�躣��|������')
		elseif str =='Զ��' then	
			return _ZMAC.CheckMount(hPlayer,'��ϼ��|���ľ�|�����ľ�|�뾭�׵�|������|���޹��|�����|�����|����|Ī��|��֪|̫����|�巽|����')
		elseif str =='�ڹ�' then
			return _ZMAC.CheckMount(hPlayer,'�׽|ϴ�辭|��Ӱʥ��|����������|��ϼ��|���ľ�|�����ľ�|�뾭�׵�|������|���޹��|�����|����|Ī��|��֪|̫����|�巽|����')
		elseif str =='�⹦' then
			return _ZMAC.CheckMount(hPlayer,'��Ѫս��|������|��ˮ��|ɽ�ӽ���|̫�齣��|Ц����|�����|��ɽ��|������|������|�躣��|������')
		elseif str =='����' then
			return _ZMAC.CheckMount(hPlayer,'�����ľ�|�뾭�׵�|�����|��֪|����')
		elseif str =='���' then
			return _ZMAC.CheckMount(hPlayer,'��Ѫս��|��ˮ��|ɽ�ӽ���|̫�齣��|��ϼ��|Ц����|�����|���޹��|��ɽ��|������|�׽|������|�躣��|��Ӱʥ��|���ľ�|������|����|Ī��|̫����|�巽')	
		elseif str =='�б���' then
			return _ZMAC_CheckBuff(hPlayer,'197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083,14352','s',false)
		elseif str =='�ޱ���' then	
			return not _ZMAC.CheckStats(hPlayer,'�б���')
		elseif str =='�г�Ĭ' then
			return _ZMAC_CheckBuff(hPlayer,'573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091','s',false)
		elseif str =='�޳�Ĭ' then	
			return not _ZMAC.CheckStats(hPlayer,'�г�Ĭ')
		elseif str =='�з���' then
			return _ZMAC_CheckBuff(hPlayer,'388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744','s',false)
		elseif str =='�޷���' then	
			return not _ZMAC.CheckStats(hPlayer,'�з���')
		elseif str =='�з���' then
			return _ZMAC_CheckBuff(hPlayer,'445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592','s',false)
		elseif str =='�޷���' then	
			return not _ZMAC.CheckStats(hPlayer,'�з���')
		elseif str =='�з��Ṧ' then
			return _ZMAC_CheckBuff(hPlayer,'562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246','s',false)
		elseif str =='�޷��Ṧ' then	
			return not _ZMAC.CheckStats(hPlayer,'�з��Ṧ')
		elseif str =='�м���' then
			return _ZMAC_CheckBuff(hPlayer,'126|2108|20799|17961|18001|16545|18203|17959|15897|15735|6739|6154|9073|9724|14644|6306|8495|13571|10118|12506|11319|11384|9810|6163|8300|6315|9506|122|9975|4339|9510|9337|3274|134|9534|6361|8291|360|367|368|384|399|684|993|996|1142|1173|1177|1547|1552|1802|2419|2447|2805|2849|2953|2983|3068|3107|3120|3171|3193|3259|3315|3447|3791|3792|4147|4245|4376|4439|4444|4575|5374|5704|5735|5744|5753|5778|5996|6090|6125|6200|6224|6240|6248|6257|6262|6264|6279|6492|6547|6616|6636|6637|7035|7054|7119|7387|7964|8265|8279|8292|8427|8650|8839|9293|9334|9544|9693|9694|9695|9696|9775|9781|9782|9803|9836|9873|9874|10014|10066|10369|11344|12530|13044|13771|14067|14105','s',false)
		elseif str =='�޼���' then	
			return not _ZMAC.CheckStats(hPlayer,'�м���')	
		elseif str =='�м���' then
			return _ZMAC_CheckBuff(hPlayer,'315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103','s',false)
		elseif str =='�޼���' then	
			return not _ZMAC.CheckStats(hPlayer,'�м���')	
		elseif str =='�м���' then
			return _ZMAC_CheckBuff(hPlayer,'450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373','s',false)
		elseif str =='�޼���' then	
			return not _ZMAC.CheckStats(hPlayer,'�м���')		
		elseif str =='�����' then
			return _ZMAC_CheckBuff(hPlayer,'100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310','s',false)
		elseif str =='�����' then	
			return not _ZMAC.CheckStats(hPlayer,'�����')	
		elseif str =='������' then
			return _ZMAC_CheckBuff(hPlayer,'160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151','s',false)
		elseif str =='������' then	
			return not _ZMAC.CheckStats(hPlayer,'������')	
		elseif str =='������' then
			return _ZMAC_CheckBuff(hPlayer,'203|6182|10370|12488','s',false)
		elseif str =='������' then	
			return not _ZMAC.CheckStats(hPlayer,'������')
		elseif str =='�������' then
			return _ZMAC_CheckBuff(hPlayer,'5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350','s',false)
		elseif str =='�������' then	
			return not _ZMAC.CheckStats(hPlayer,'�������')
		elseif str =='������' then
			return _ZMAC_CheckBuff(hPlayer,'1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099','s',false)
		elseif str =='������' then	
			return not _ZMAC.CheckStats(hPlayer,'������')	
		elseif str =='�����е' then
			return _ZMAC_CheckBuff(hPlayer,'6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414','s',false) 
		elseif str =='�����е' then
			return not _ZMAC.CheckStats(hPlayer,'�����е')	
		elseif str =='���ɽ�е'  then
			return _ZMAC.CheckStats(hPlayer,'�����е')	
			or _ZMAC.CheckStats(hPlayer,'�г�Ĭ') 
			or (_ZMAC.CheckStats(hPlayer,'�з���') and _ZMAC.CheckStats(hPlayer,'�ڹ�'))
		elseif str =='�ɽ�е' then
			return not _ZMAC.CheckStats(hPlayer,'���ɽ�е')		
		elseif str =='�����'  then
			return _ZMAC_CheckBuff(hPlayer,'20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777','s',false)
		elseif str =='�����'  then
			return not _ZMAC.CheckStats(hPlayer,'�����')
		elseif str =='������'  then
			return _ZMAC_CheckBuff(hPlayer,'8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310','s',false)
		elseif str =='������'  then
			return not _ZMAC.CheckStats(hPlayer,'������')			
		else	
			_ZMAC.PrintRed('MSG_SYS','stats��������:-->'..str..'\r\n')
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
		local aSkill = hPlayer.GetAllSkillList() or {}                    --���ƿ���
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
		local aSkill = hPlayer.GetAllSkillList() or {}                  --���ƿ���
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
	local SwiteBan = (CongNengCDID and CnCount > 0) or (nLeft == 0 and nTotal == 0) or false --�жϼ����Ƿ�Ϊ���ܼ���,���ж���ͨ������ȴ
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
	local nName = '��Ŀ��'
	if not t then 
		nName = '��Ŀ��' 
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
	--Skill_GetLastCast()���ú����洢�������һ�γ����ͷŵļ���      
	--������_ZMAC.tCast��ķ���Ҳ��bug,������������������������,Ҳ�ᱻ��¼Ϊlastcast �����
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
			return true --����true��������
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
	
	
	if t.dwID < 1073741824 and t.dwID ~= 0 then   --Ŀ������ΪPLAYER
		local Mount = t.GetKungfuMount()        --�˴����Ŀ�������жϣ��������
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
--[btype,detype]�⹦�����ԡ���Ԫ�����ԡ����ԡ���
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
					if cType then  --����buff
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
	if cNum == 'moon' then --δ֪����
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
	if type(szSkillID) == 'table' then      --ʵ��ͬ�����ò�ͬid�õ��Ľ��һ��
		szSkillID = szSkillID[1]
	end
	do if not szSkillID then  return 0 end end     
	local SkillLevel = hPlayer.GetSkillLevel(szSkillID)
	if SkillLevel < 1 then SkillLevel = 1 end
	local bCool, CD, TotalCD = hPlayer.GetSkillCDProgress(szSkillID, SkillLevel)

	local CongNengCDID = Skill_GetCongNengCDID(szSkillID)        --�������ڳ��ܼ��ܣ�͸֧�಻֧��
	local CnCD, CnCount = hPlayer.GetCDLeft(CongNengCDID)
	
	local Skill = GetSkill(szSkillID, SkillLevel)
	if szSkillID==16620 then   --[��Ԩ��ɷ]  ����Ԩ������3�����
		if _ZMAC.CheckHaveSkill(hPlayer,'Ԩ��')==true then
			_ZMAC.TouzhiSkillList[16620][2] = 3
		else
			_ZMAC.TouzhiSkillList[16620][2] = 2
		end
	end
	
	if _ZMAC.TouzhiSkillList[szSkillID]~= nil then             --͸֧��
		local TouzhiCD,TouzhiCount = CD,_ZMAC.TouzhiSkillList[szSkillID][2]-TotalCD/(_ZMAC.TouzhiSkillList[szSkillID][1]*16)
		TouzhiCount = math.floor(TouzhiCount+0.5)   --_ZMAC.TouzhiSkillList[szSkillID][1]��¼��cdʱ�䣬�п��ܻᱻ��Ѩ��Ӱ�죬����ֱ��ȡ������С���������bug
		return TouzhiCount
	elseif CongNengCDID then
		return CnCount
	else
		local gcdID=605 --����
		if KungfuMount=='��Ӱʥ��' or KungfuMount=='����������' then
			gcdID=3962 --������
		elseif KungfuMount=='Ц����' then
			gcdID=5258 --��������
		end

		local GcdSkillLevel = hPlayer.GetSkillLevel(gcdID)
		local _, GCD, TotalGCD = hPlayer.GetSkillCDProgress(gcdID, GcdSkillLevel)

		if CD==0 and TotalCD==0 then   
			return 1 
		elseif  GCD== CD and TotalGCD == TotalCD  then  --cd��gcd��ȫ��ͬʱ����ü���û��cd����Ҫ����1
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
		
	szSkillID =tonumber(cmd)  -- or _ZMAC.GetSkillIdEx(cmd)  --ר��д��_ZMAC.GetSkillIDNum����ֹȡnum��ȡid����ѭ��
	-- if type(szSkillID) == 'table' then      --ʵ��ͬ�����ò�ͬid�õ��Ľ��һ��
		-- szSkillID = szSkillID[1]
	-- end
	do if not szSkillID then return 0 end end     
	local SkillLevel = hPlayer.GetSkillLevel(szSkillID)
	if SkillLevel < 1 then SkillLevel = 1 end
	local bCool, CD, TotalCD = hPlayer.GetSkillCDProgress(szSkillID, SkillLevel)

	local CongNengCDID = Skill_GetCongNengCDID(szSkillID)        --�������ڳ��ܼ��ܣ�͸֧�಻֧��
	local CnCD, CnCount = hPlayer.GetCDLeft(CongNengCDID)
	
	local Skill = GetSkill(szSkillID, SkillLevel)
	if szSkillID==16620 then   --[��Ԩ��ɷ]  ����Ԩ������3�����
		if _ZMAC.CheckHaveSkill(hPlayer,'Ԩ��')==true then
			_ZMAC.TouzhiSkillList[16620][2] = 3
		else
			_ZMAC.TouzhiSkillList[16620][2] = 2
		end
	end
	
	if _ZMAC.TouzhiSkillList[szSkillID]~= nil then             --͸֧��
		local TouzhiCD,TouzhiCount = CD,_ZMAC.TouzhiSkillList[szSkillID][2]-TotalCD/(_ZMAC.TouzhiSkillList[szSkillID][1]*16)
		TouzhiCount = math.floor(TouzhiCount+0.5)   --_ZMAC.TouzhiSkillList[szSkillID][1]��¼��cdʱ�䣬�п��ܻᱻ��Ѩ��Ӱ�죬����ֱ��ȡ������С���������bug
		return TouzhiCount
	elseif CongNengCDID then
		return CnCount
	else
		local gcdID=605 --����
		if KungfuMount=='��Ӱʥ��' or KungfuMount=='����������' then
			gcdID=3962 --������
		elseif KungfuMount=='Ц����' then
			gcdID=5258 --��������
		end

		local GcdSkillLevel = hPlayer.GetSkillLevel(gcdID)
		local _, GCD, TotalGCD = hPlayer.GetSkillCDProgress(gcdID, GcdSkillLevel)

		if CD==0 and TotalCD==0 then   
			return 1 
		elseif  GCD== CD and TotalGCD == TotalCD  then  --cd��gcd��ȫ��ͬʱ����ü���û��cd����Ҫ����1
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
	
	if Kungfu.dwSkillID == 10002 or Kungfu.dwSkillID == 10003 then --����
		nValue = hPlayer.nAccumulateValue
		if nValue < 0 then nValue = 0 end
		if nValue > 3 then nValue = 3 end
	elseif Kungfu.dwSkillID == 10081 then --����
		nValue = hPlayer.nAccumulateValue
		if nValue < 0 then nValue = 0 end
		if nValue > 10 then nValue = 10 end
	elseif Kungfu.dwSkillID == 10464 then --�Ե�
		local hFrame = Station.Lookup('Normal/Player')
		local BaDaoState = hFrame:Lookup('','')
		local BaDaoStateType = BaDaoState:Lookup('Handle_BaDao')
		local nPoseState = (BaDaoStateType and BaDaoStateType.nPoseState) or 2
		if nPoseState == 1 then --����
			nValue = hPlayer.nCurrentEnergy
		elseif nPoseState == 2 then --����
			nValue = hPlayer.nCurrentRage
		elseif nPoseState == 3 then --����
			nValue = hPlayer.nCurrentSunEnergy
		end
		if nValue < 0 then nValue = 0 end
		if nValue > 120 then nValue = 120 end
	elseif Kungfu.dwSkillID == 10014 or Kungfu.dwSkillID == 10015 then --����
		nValue = hPlayer.nAccumulateValue
		if nValue > 10 then nValue = 10 end
		nValue = nValue + 1
		--nValue = nValue / 2  --����5��ֱ�Ӱ�10����������
	elseif Kungfu.dwSkillID == 10144 or Kungfu.dwSkillID == 10145 or Kungfu.dwSkillID == 10389 or Kungfu.dwSkillID == 10390 then --�ؽ� ����
		nValue = hPlayer.nCurrentRage
	elseif Kungfu.dwSkillID == 10224 or Kungfu.dwSkillID == 10225 then --����
		nValue = hPlayer.nCurrentEnergy
	end
	return nValue
end


--//����ϵ����ȡ
_ZMAC.ReductionList ={
	
[9975]={
["1"]={nLevel=1,[2]=0,szDesc="��ʹ��ɭ��ᰱ�ø�ǿ�������˺�����20%",[3]=0,[1]=0,szName="����",dwID=9975}},
[9724]={
["1"]={nLevel=1,[2]=0,[4]=3,szDesc="�⹦�����ȼ����<BUFF atPhysicsShieldBase>����������ȥ��һ�㲢�ָ�������Ѫֵ���Ҷ���ָ�����3%�����Ѫֵ",[3]=0,[1]=0,szName="����",dwID=9724}},
[6154]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ��˺�����50%",[3]=50,[1]=50,szName="��ˮ��",dwID=6154}},
[1802]={
["1"]={nLevel=1,[2]=35,szDesc="�ܵ����˺�����35%",[3]=35,[1]=35,szName="����",dwID=1802},
["3"]={nLevel=3,[2]=99,szDesc="�ܵ����˺�����99%",[3]=99,[1]=99,szName="����",dwID=1802},
["2"]={nLevel=2,[2]=70,szDesc="�ܵ����˺�����70%",[3]=70,[1]=70,szName="����",dwID=1802}},
[14067]={
["1"]={nLevel=1,[2]=10,szDesc="ÿ�����Ч�����10%",[3]=10,[1]=10,szName="����",dwID=14067}},
[9736]={
["1"]={nLevel=1,[2]=0,szDesc="���ܼ������30%",[3]=30,[1]=0,szName="�ȱ�Ը",dwID=9736},
["3"]={nLevel=3,[2]=0,szDesc="���ܼ������15%����вֵ���30%",[3]=15,[1]=0,szName="�ȱ�Ը",dwID=9736},
["2"]={nLevel=2,[2]=0,szDesc="���ܼ������60%",[3]=60,[1]=0,szName="�ȱ�Ը",dwID=9736}},
[4376]={
["1"]={nLevel=1,[2]=60,szDesc="�ܵ����˺�����60%",[3]=60,[1]=60,szName="����ɽ",dwID=4376}},
[9742]={
["1"]={nLevel=1,[2]=0,szDesc="��Ѫֵÿ����10%�����ܼ������2%",[3]=2,[1]=0,szName="������Ӣ",dwID=9742}},
[6163]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ��˺�����50%",[3]=50,[1]=50,szName="����ɽ",dwID=6163}},
[13571]={
["1"]={nLevel=1,[2]=0,szDesc="Ԧ�����",[3]=0,[1]=0,szName="���",dwID=13571}},
[1552]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ����˺�����40%",[3]=40,[1]=40,szName="���໤��",dwID=1552}},
-- [7964]={
-- ["1"]={nLevel=1,[2]=0,szDesc="Ч���ڼ䱻���ظ�����10%��Ѫ���ֵ",[3]=0,[1]=0,szName="̰ħ��",dwID=7964}},
[9782]={
["1"]={nLevel=1,[2]=60,szDesc="�����ܵ����˺�60%",[3]=60,[1]=60,szName="��صͰ�",dwID=9782}},
[126]={
["1"]={nLevel=1,[2]=0,[4]=6,szDesc="�⹦�����ȼ����<BUFF atPhysicsShieldBase>����������ȥ��һ�㲢�ָ�<Skill 5798 0 4%><Skill 5798 1 6%>�����Ѫֵ",[3]=0,[1]=0,szName="����",dwID=126}},
[4147]={
["1"]={nLevel=1,[2]=200,szDesc="�����ܵ����˺�",[3]=200,[1]=200,szName="����",dwID=4147}},
[20799]={
["1"]={nLevel=1,[2]=50,szDesc="�е�50%���˺�",[3]=50,[1]=50,szName="����",dwID=20799}},
[684]={
["1"]={nLevel=1,[2]=40,szDesc="�����ܵ����˺�40%",[3]=40,[1]=40,szName="��صͰ�",dwID=684},
["2"]={nLevel=2,[2]=40,szDesc="�����ܵ����˺�60%",[3]=40,[1]=40,szName="��صͰ�",dwID=684}},
[1173]={
["1"]={nLevel=1,[2]=80,szDesc="�ܵ��˺�����80%�����Ҳ������˵���",[3]=80,[1]=80,szName="����ɽ",dwID=1173}},
[2849]={
["1"]={nLevel=1,[2]=35,szDesc="�ܵ����˺�����35%",[3]=35,[1]=35,szName="��Ϸˮ",dwID=2849}},
[9810]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ��˺�����50%",[3]=50,[1]=50,szName="����",dwID=9810}},
[3107]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ����˺�����50%",[3]=50,[1]=50,szName="��صͰ�",dwID=3107}},
[6200]={
["1"]={nLevel=1,[2]=60,szDesc="�ܵ����˺�����60%",[3]=60,[1]=60,szName="��Х����",dwID=6200}},
[8292]={
["1"]={nLevel=1,[2]=0,[4]=60,szDesc="�������������Ѫֵ60%���˺���ÿ��ظ�����3%����Ѫ",[3]=0,[1]=0,szName="ս��",dwID=8292},
["3"]={nLevel=3,[2]=0,[4]=60,szDesc="�������������Ѫֵ60%���˺�Ч����ÿ���мܵȼ��������10���˺�����Ч��",[3]=0,[1]=0,szName="�ܱ�",dwID=8292},
["2"]={nLevel=2,[2]=0,[4]=40,szDesc="�������������Ѫֵ40%���˺�Ч����ÿ���мܵȼ��������10���˺�����Ч��",[3]=0,[1]=0,szName="�ܱ�",dwID=8292},
["5"]={nLevel=5,[2]=0,[4]=100,szDesc="�������������Ѫֵ100%���˺�Ч����ÿ���мܵȼ��������10���˺�����Ч��",[3]=0,[1]=0,szName="�ܱ�",dwID=8292},
["4"]={nLevel=4,[2]=0,[4]=80,szDesc="�������������Ѫֵ80%���˺�Ч����ÿ���мܵȼ��������10���˺�����Ч��",[3]=0,[1]=0,szName="�ܱ�",dwID=8292},
["6"]={nLevel=6,[2]=0,[4]=100,szDesc="�������������Ѫֵ100%���˺���ÿ��ظ�����3%����Ѫ",[3]=0,[1]=0,szName="ս��",dwID=8292}},
[2983]={
["1"]={nLevel=1,[2]=20,szDesc="�ܵ����˺�����20%",[3]=20,[1]=20,szName="����",dwID=2983},
["2"]={nLevel=2,[2]=50,szDesc="�ܵ����˺�����50%���ܵ������㡱��������ѣ�Ρ�������������Ч������ʱ������30%",[3]=50,[1]=50,szName="����",dwID=2983}},
[8300]={
["1"]={nLevel=1,[2]=40,szDesc="ʹ�����ܵ����˺�����40%",[3]=40,[1]=40,szName="��ǽ",dwID=8300},
["3"]={nLevel=3,[2]=60,szDesc="ʹ�����ܵ����˺�����60%",[3]=60,[1]=60,szName="��ǽ",dwID=8300},
["2"]={nLevel=2,[2]=50,szDesc="ʹ�����ܵ����˺�����50%",[3]=50,[1]=50,szName="��ǽ",dwID=8300}},
[9836]={
["1"]={nLevel=1,[2]="��",szDesc="�ܵ����˺�����80%",[3]="��",[1]=80,szName="Ħ��",dwID=9836}},
[9073]={
["1"]={nLevel=1,[2]=0,szDesc="�ܵ����˺�����<BUFF_EX 1024 atGlobalResistPercent>%",[3]=0,[1]=0,szName="������ɢ",dwID=9073}},
[9334]={
["1"]={nLevel=1,[2]=30,szDesc="���մ����˺�Ч�������˺����ն�����ֵ��ͨ����������Ч�����",[3]=30,[1]=30,szName="÷����Ū",dwID=9334},
["4"]={nLevel=4,[2]=30,szDesc="���մ����˺�Ч������ʽ��Ϣ�ٶ����15%����ʹ�����˺���ʽ����Ŀ��15%���⹦�����ȼ������˺����ն�����ֵ��ͨ����������Ч�����",[3]=30,[1]=30,szName="÷����Ū",dwID=9334},
["3"]={nLevel=3,[2]=30,szDesc="���մ����˺�Ч������ʽ��Ϣ�ٶ����15%�����˺����ն�����ֵ��ͨ����������Ч�����",[3]=30,[1]=30,szName="÷����Ū",dwID=9334},
["2"]={nLevel=2,[2]=30,szDesc="���մ����˺�Ч������ʹ�����˺���ʽ����Ŀ��15%���⹦�����ȼ������˺����ն�����ֵ��ͨ����������Ч�����",[3]=30,[1]=30,szName="÷����Ū",dwID=9334}},
-- [5704]={
-- ["1"]={nLevel=1,[2]=0,szDesc="������Ѫ�������10%",[3]=0,[1]=0,szName="�ֻ�",dwID=5704}},
[11384]={
["1"]={nLevel=1,[2]=25,szDesc="�ܵ������˺�����25%",[3]=25,[1]=25,szName="��������",dwID=11384}},
[3120]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ����˺�����50%",[3]=50,[1]=50,szName="���໤��",dwID=3120}},
[15735]={
["1"]={nLevel=1,[2]=50,szDesc="��Զ�̵������ܣ��ܵ��˺�����50%",[3]=50,[1]=50,szName="ն�޳�",dwID=15735},
["2"]={nLevel=2,[2]=50,szDesc="���߿���Ч������Զ�̵������ܣ��ܵ��˺�����50%",[3]=50,[1]=50,szName="ն�޳�",dwID=15735}},
[9874]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ������˺�����40%",[3]=40,[1]=40,szName="ɢӰ",dwID=9874}},
[6739]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��˺�����40%",[3]=40,[1]=40,szName="ϢԪ",dwID=6739}},
[6492]={
["1"]={nLevel=1,[2]=75,szDesc="�ܵ����˺�����75%",[3]=75,[1]=75,szName="Ц���",dwID=6492}},
[2108]={
["1"]={nLevel=1,[2]=0,[4]=1,szDesc="�⹦�����ȼ����<BUFF atPhysicsShieldBase>�㣬��������ȥ��һ�㲢�ָ�1000����Ѫֵ",[3]=0,[1]=0,szName="����",dwID=2108}},
[4711]={
["1"]={nLevel=1,[2]=7*0.08,szDesc="�ڹ������ȼ����7%",[3]=0,[1]=0,szName="����",dwID=4711},
["2"]={nLevel=2,[2]=15*0.08,szDesc="�ڹ������ȼ����15%",[3]=0,[1]=0,szName="����",dwID=4711}},
[17959]={
["1"]={nLevel=1,[2]=0,szDesc="��һ��������ʽ������60%����Ч��",[3]=0,[1]=0,szName="˾��",dwID=17959}},
[5735]={
["1"]={nLevel=1,[2]=15,szDesc="���ܼ������15%��ÿ��������2���˺�",[3]=30,[1]=15,szName="Ȫ����",dwID=5735},
["8"]={nLevel=8,[2]=15,szDesc="���ܼ������15%��ÿ��������37.5���˺�����������ʱ��˥��",[3]=30,[1]=15,szName="Ȫ����",dwID=5735},
["3"]={nLevel=3,[2]=15,szDesc="���ܼ������15%��ÿ��������3���˺�",[3]=30,[1]=15,szName="Ȫ����",dwID=5735},
["5"]={nLevel=5,[2]=15,szDesc="���ܼ������15%��ÿ��������4���˺�",[3]=30,[1]=15,szName="Ȫ����",dwID=5735},
["4"]={nLevel=4,[2]=15,szDesc="���ܼ������15%��ÿ��������3���˺�",[3]=30,[1]=15,szName="Ȫ����",dwID=5735},
["7"]={nLevel=7,[2]=15,szDesc="���ܼ������15%��ÿ��������5���˺�",[3]=30,[1]=15,szName="Ȫ����",dwID=5735},
["6"]={nLevel=6,[2]=15,szDesc="���ܼ������15%��ÿ��������4���˺�",[3]=30,[1]=15,szName="Ȫ����",dwID=5735}},
[3259]={
["1"]={nLevel=1,[2]=100,szDesc="���칷������������������һ�й���",[3]=100,[1]=100,szName="����",dwID=3259}},
[6248]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ����˺�����40%",[3]=40,[1]=40,szName="�ݲй�",dwID=6248}},
[5996]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ��˺�����50%",[3]=50,[1]=50,szName="Ц���",dwID=5996},
["4"]={nLevel=4,[2]=95,szDesc="�ܵ��˺�����95%",[3]=95,[1]=95,szName="Ц���",dwID=5996},
["3"]={nLevel=3,[2]=90,szDesc="�ܵ��˺�����90%",[3]=90,[1]=90,szName="Ц���",dwID=5996},
["2"]={nLevel=2,[2]=55,szDesc="�ܵ��˺�����55%",[3]=55,[1]=55,szName="Ц���",dwID=5996}},
[5744]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��˺�����40%",[3]=40,[1]=40,szName="̰ħ��",dwID=5744}},
[6257]={
["1"]={nLevel=1,[2]=45,szDesc="�ܵ��˺�����45%",[3]=45,[1]=45,szName="���໤��",dwID=6257}},
[6262]={
["1"]={nLevel=1,[2]=30,szDesc="�ܵ��˺�����30%",[3]=30,[1]=30,szName="����",dwID=6262}},
[5753]={
["1"]={nLevel=1,[2]=0,szDesc="ǿ��Ŀ��",[3]=0,[1]=0,szName="̰ħ��",dwID=5753}},
[6264]={
["1"]={nLevel=1,[2]=48,szDesc="�ܵ��˺�����48%",[3]=48,[1]=48,szName="���໤��",dwID=6264},
["3"]={nLevel=3,[2]=52,szDesc="�ܵ��˺�����52%",[3]=52,[1]=52,szName="���໤��",dwID=6264},
["2"]={nLevel=2,[2]=50,szDesc="�ܵ��˺�����50%",[3]=50,[1]=50,szName="���໤��",dwID=6264},
["5"]={nLevel=5,[2]=56,szDesc="�ܵ��˺�����56%",[3]=56,[1]=56,szName="���໤��",dwID=6264},
["4"]={nLevel=4,[2]=54,szDesc="�ܵ��˺�����54%",[3]=54,[1]=54,szName="���໤��",dwID=6264},
["7"]={nLevel=7,[2]=60,szDesc="�ܵ��˺�����60%",[3]=60,[1]=60,szName="���໤��",dwID=6264},
["6"]={nLevel=6,[2]=58,szDesc="�ܵ��˺�����58%",[3]=58,[1]=58,szName="���໤��",dwID=6264}},
[9693]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��������˺�����40%",[3]=40,[1]=40,szName="���Ӱ��",dwID=9693}},
[9695]={
["1"]={nLevel=1,[2]=0,szDesc="�޷��ܵ�����Ч����Ӱ��",[3]=0,[1]=0,szName="���Ӱ��",dwID=9695}},
[12506]={
["1"]={nLevel=1,[2]=50,szDesc="�����ܵ����˺���50%ת�Ƹ������ϰ�",[3]=50,[1]=50,szName="����",dwID=12506}},
[7035]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��˺���С",[3]=40,[1]=40,szName="��ǽ",dwID=7035}},
[18071]={
["1"]={nLevel=1,[2]=0,szDesc="���ܼ������10%",[3]=10,[1]=0,szName="����",dwID=18071}},
[16545]={
["1"]={nLevel=1,[2]=60,szDesc="�ܵ����˺�����60%",[3]=60,[1]=60,szName="��",dwID=16545}},
[4489]={
["1"]={nLevel=1,[2]=0,szDesc="�⹦�����ȼ����7%",[3]=7*0.08,[1]=0,szName="��Դ",dwID=4489},
["2"]={nLevel=2,[2]=0,szDesc="�⹦���������ȼ����15%",[3]=15*0.08,[1]=0,szName="��Դ",dwID=4489}},
[3274]={
["1"]={nLevel=1,[2]=0,szDesc="�ܵ����˺�����<BUFF_EX 1024 atGlobalResistPercent>%",[3]=0,[1]=0,szName="������ɢ",dwID=3274}},
[4494]={
["1"]={nLevel=1,[2]=5*0.08,szDesc="�ڡ��⹦�����������5%",[3]=5*0.08,[1]=5*0.08,szName="����",dwID=4494}},
[12530]={
["1"]={nLevel=1,[2]=60,szDesc="�����ܵ��˺�����60%,��ʹ���Ƹ�Ч����Ŀ��������Ч��",[3]=60,[1]=60,szName="����Ϸˮ",dwID=12530}},
[13044]={
["1"]={nLevel=1,[2]=45,szDesc="�ܵ����˺�����45%",[3]=45,[1]=45,szName="�����",dwID=13044},
["3"]={nLevel=3,[2]=55,szDesc="�ܵ����˺�����55%",[3]=55,[1]=55,szName="�����",dwID=13044},
["2"]={nLevel=2,[2]=50,szDesc="�ܵ����˺�����50%",[3]=50,[1]=50,szName="�����",dwID=13044},
["5"]={nLevel=5,[2]=65,szDesc="�ܵ����˺�����65%",[3]=45,[1]=65,szName="�����",dwID=13044},
["4"]={nLevel=4,[2]=60,szDesc="�ܵ����˺�����60%",[3]=60,[1]=60,szName="�����",dwID=13044}},
[4244]={
["1"]={nLevel=1,[2]=0,[4]=15,szDesc="�����˺�",[3]=0,[1]=0,szName="�ɶ�",dwID=4244}},
[4245]={
["1"]={nLevel=1,[2]=60,szDesc="������ʽ���ƣ��ܵ����˺�����60%",[3]=60,[1]=60,szName="ʥ��",dwID=4245}},
-- [5778]={
-- ["1"]={nLevel=1,[2]=0,szDesc="ÿ5��Ϊ��Χ10�ߵ�С�ӳ�Ա�ָ���Ѫ",[3]=0,[1]=0,szName="����",dwID=5778}},
[7054]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ����˺�����40%",[3]=40,[1]=40,szName="ʥ��֯��",dwID=7054}},
[3791]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��˺�����40%",[3]=40,[1]=40,szName="��ǽ",dwID=3791}},
[6547]={
["1"]={nLevel=1,[2]=5,szDesc="�ܵ��˺�����5%",[3]=5,[1]=5,szName="����",dwID=6547}},
[3792]={
["1"]={nLevel=1,[2]=0,[4]=50,szDesc="����180000���˺���������������Χ�ѷ���λ�����ӻ�Ч��",[3]=0,[1]=0,szName="��ǽ",dwID=3792},
["2"]={nLevel=2,[2]=0,[4]=200,szDesc="����648000���˺���������������Χ�ѷ���λ�����ӻ�Ч����ֻ���ս�ս�˺�",[3]=0,[1]=0,szName="��ǽ",dwID=3792}}, --����
[10014]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ������˺�����50%�����ܼ������30%",[3]=80,[1]=50,szName="����",dwID=10014}},
[9506]={
["1"]={nLevel=1,[2]=0,szDesc="���ٰν����Խ�ս��̬����Ŀ��",[3]=0,[1]=0,szName="���Ӱ��",dwID=9506}},
[9510]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��������˺�����40%",[3]=40,[1]=40,szName="��������",dwID=9510}},
[18203]={
["1"]={nLevel=1,[2]=0,[4]=20,szDesc="�������������Ѫֵ20%���˺����������ܵ��⹦�˺���25%",[3]=0,[1]=0,szName="�ʼ�",dwID=18203}},
[6306]={
["1"]={nLevel=1,[2]=0,szDesc="�ܵ����˺�����50%",[3]=0,[1]=0,szName="������",dwID=6306}},
[15897]={
["1"]={nLevel=1,[2]=0,szDesc="�޷��뿪������Ŀ��10��",[3]=0,[1]=0,szName="������",dwID=15897}},
[9781]={
["1"]={nLevel=1,[2]=60,szDesc="�����ܵ����˺�60%",[3]=60,[1]=60,szName="��صͰ�",dwID=9781}},
[11319]={
["1"]={nLevel=1,[2]=60,szDesc="���߿���Ч�����ܵ����˺�����60%",[3]=60,[1]=60,szName="��Ԩ����",dwID=11319}},
[6315]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ��˺�����50%",[3]=50,[1]=50,szName="����",dwID=6315}},
[8265]={
["1"]={nLevel=1,[2]=0,szDesc="�������п���Ч��",[3]=0,[1]=0,szName="��ǽ",dwID=8265}},
[9544]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ������˺�����40%",[3]=40,[1]=40,szName="Ц������",dwID=9544},
["2"]={nLevel=2,[2]=70,szDesc="�ܵ������˺�����70%",[3]=70,[1]=70,szName="Ц������",dwID=9544}},
[399]={
["1"]={nLevel=1,[2]=35,szDesc="�ܵ����˺�����35%",[3]=35,[1]=35,szName="�����",dwID=399},
["4"]={nLevel=4,[2]=50,szDesc="�ܵ����˺�����50%",[3]=50,[1]=50,szName="�����",dwID=399},
["3"]={nLevel=3,[2]=45,szDesc="�ܵ����˺�����45%",[3]=45,[1]=45,szName="�����",dwID=399},
["2"]={nLevel=2,[2]=40,szDesc="�ܵ����˺�����40%",[3]=40,[1]=40,szName="�����",dwID=399}},
[8279]={
["1"]={nLevel=1,[2]=0,[4]=60,szDesc="�������������Ѫֵ60%���˺�",[3]=0,[1]=0,szName="�ܱ�",dwID=8279},
["4"]={nLevel=4,[2]=0,[4]=80,szDesc="�������������Ѫֵ80%���˺�",[3]=0,[1]=0,szName="�ܱ�",dwID=8279},
["5"]={nLevel=5,[2]=0,[4]=100,szDesc="�������������Ѫֵ100%���˺�",[3]=0,[1]=0,szName="�ܱ�",dwID=8279},
["2"]={nLevel=2,[2]=0,[4]=40,szDesc="�������������Ѫֵ40%���˺�",[3]=0,[1]=0,szName="�ܱ�",dwID=8279}},
[10066]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ������˺�����50%",[3]=50,[1]=50,szName="����",dwID=10066}},
[3171]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ����˺�����40%",[3]=40,[1]=40,szName="���໤��",dwID=3171}},
[8291]={
["1"]={nLevel=1,[2]=0,[4]=5,szDesc="����������Ѫ���ֵ5%���˺�Ч��",[3]=0,[1]=0,szName="�ܻ�",dwID=8291},
["2"]={nLevel=2,[2]=0,[4]=10,szDesc="����������Ѫ���ֵ10%���˺�Ч��",[3]=0,[1]=0,szName="�ܻ�",dwID=8291}},
[368]={
["1"]={nLevel=1,[2]=80,szDesc="�ܵ����˺�����80%",[3]=80,[1]=80,szName="����ɽ-������",dwID=368}},
[384]={
["1"]={nLevel=1,[2]=60,szDesc="ʹ��������������ʽ˲���������޷�ʩչ�ڹ���ʽЧ����Ӱ�죬���������ܵ����˺�����60%",[3]=60,[1]=60,szName="תǬ��",dwID=384},
["2"]={nLevel=2,[2]=70,szDesc="ʹ��������������ʽ˲���������޷�ʩչ�ڹ���ʽЧ����Ӱ�죬���������ܵ����˺�����70%��ÿ��ָ�����8%��Ѫ���ֵ",[3]=70,[1]=70,szName="תǬ��",dwID=384}},
[9337]={
["1"]={nLevel=1,[2]=30,szDesc="Ч���ڼ�ʹ�����ܵ��������˺�����30%",[3]=30,[1]=30,szName="��÷",dwID=9337},
["2"]={nLevel=2,[2]=30,szDesc="Ч���ڼ�ʹ�����ܵ�������Ч�����30%���ܵ������˺�����30%",[3]=30,[1]=30,szName="��÷",dwID=9337}},
[6090]={
["1"]={nLevel=1,[2]=0,szDesc="���������ܵ����˺�Ч��������Խ�ߣ�������Խ��",[3]=0,[1]=0,szName="��������",dwID=6090}},
[8839]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��˺�����40%",[3]=40,[1]=40,szName="ʥ��֯��",dwID=8839},
["2"]={nLevel=2,[2]=55,szDesc="�ܵ��˺�����55%",[3]=55,[1]=55,szName="ʥ��֯��",dwID=8839}},
[10118]={
["1"]={nLevel=1,[2]=50,szDesc="���ܿ��ƽ�����״̬���ƶ��ٶ����50%���ܵ����˺�����50%",[3]=50,[1]=50,szName="ʴ�Ĺ�",dwID=10118}},
[2419]={
["1"]={nLevel=1,[2]=100,szDesc="�����˺�",[3]=100,[1]=100,szName="��",dwID=2419}},
[7119]={
["1"]={nLevel=1,[2]=80,szDesc="�ܵ����˺�����80%",[3]=80,[1]=80,szName="�ֻ�",dwID=7119}},
[9873]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��������˺�����40%",[3]=40,[1]=40,szName="ҷ��",dwID=9873}},
[15234]={
["1"]={nLevel=1,[2]=35,szDesc="�����м��ʽ���35%",[3]=35,[1]=35,szName="�Ӱ",dwID=15234}},
[3315]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��˺�����40%���ܵ��ġ����㡱��������ѣ�Ρ�����Ч������ʱ�併��40%",[3]=40,[1]=40,szName="����",dwID=3315}},
[4575]={
["1"]={nLevel=1,[2]=15*0.08,szDesc="�������15%������Զ���˺�<BUFF atPoisonMagicReflection>��",[3]=15*0.08,[1]=15*0.08,szName="��ǽ",dwID=4575}},
[6361]={
["1"]={nLevel=1,[2]=0,szDesc="���ܿ�����ʽЧ��Ӱ��(���˺ͱ�������)",[3]=0,[1]=0,szName="ͻ",dwID=6361}},
[19222]={
["1"]={nLevel=1,[2]=0,[4]=20,szDesc="�������������Ѫֵ20%���˺����ڼ������˺����10%",[3]=0,[1]=0,szName="�޼�Ӱ��",dwID=19222}},
[9745]={
["1"]={nLevel=1,[2]=30,szDesc="�ܵ��˺�����30%��ÿ��ظ�5%��Ѫ���ֵ",[3]=30,[1]=30,szName="��ʥ",dwID=9745}},
[6301]={
["1"]={nLevel=1,[2]=100,szDesc="ÿ�㻯��һ���˺�",[3]=100,[1]=100,szName="������Ե",dwID=6301}},
[7387]={
["1"]={nLevel=1,[2]=100,szDesc="����һ���˺�",[3]=100,[1]=100,szName="����",dwID=7387}},
[3447]={
["1"]={nLevel=1,[2]=40,szDesc="Я����ˮ������Ŀ��Ϊ����е�40%�ܵ����˺�",[3]=40,[1]=40,szName="��ˮ��",dwID=3447},
["3"]={nLevel=3,[2]=50,szDesc="����е�����50%�ܵ����˺�",[3]=50,[1]=50,szName="��ˮ��",dwID=3447},
["2"]={nLevel=2,[2]=70,szDesc="����е�����70%�ܵ����˺�",[3]=70,[1]=70,szName="��ˮ��",dwID=3447}},
[18075]={
["1"]={nLevel=1,[2]=50,szDesc="���߿���Ч���������м��ʽ���50%",[3]=50,[1]=50,szName="΢���",dwID=18075},
["2"]={nLevel=2,[2]=70,szDesc="���߿���Ч���������м��ʽ���70%",[3]=70,[1]=70,szName="΢���",dwID=18075}},
[3193]={
["1"]={nLevel=1,[2]=80,szDesc="�ܵ����˺�����80%�����Թ��������Ŀ������˺�",[3]=80,[1]=80,szName="����ɽ",dwID=3193}},
[17961]={
["1"]={nLevel=1,[2]=60,szDesc="�����ܵ����˺�60%",[3]=60,[1]=60,szName="˾��",dwID=17961}},
[122]={
["1"]={nLevel=1,[2]=28,[4]=3,szDesc="ʹ���ܵ��˺�����28%��������������һ�㣬ÿ����һ����ظ�3%��Ѫֵ",[3]=28,[1]=28,szName="���໤��",dwID=122},  --����
["2"]={nLevel=2,[2]=30,[4]=3,szDesc="ʹ���ܵ��˺�����30%��������������һ�㣬ÿ����һ����ظ�3%��Ѫֵ",[3]=30,[1]=30,szName="���໤��",dwID=122},
["3"]={nLevel=3,[2]=32,[4]=3,szDesc="ʹ���ܵ��˺�����32%��������������һ�㣬ÿ����һ����ظ�3%��Ѫֵ",[3]=32,[1]=32,szName="���໤��",dwID=122},
["5"]={nLevel=5,[2]=36,[4]=3,szDesc="ʹ���ܵ��˺�����36%��������������һ�㣬ÿ����һ����ظ�3%��Ѫֵ",[3]=36,[1]=36,szName="���໤��",dwID=122},
["4"]={nLevel=4,[2]=34,[4]=3,szDesc="ʹ���ܵ��˺�����34%��������������һ�㣬ÿ����һ����ظ�3%��Ѫֵ",[3]=34,[1]=34,szName="���໤��",dwID=122},
["7"]={nLevel=7,[2]=45,[4]=3,szDesc="ʹ���ܵ��˺�����45%��������������һ�㣬ÿ����һ����ظ�3%��Ѫֵ",[3]=45,[1]=45,szName="���໤��",dwID=122},
["6"]={nLevel=6,[2]=38,[4]=3,szDesc="ʹ���ܵ��˺�����38%��������������һ�㣬ÿ����һ����ظ�3%��Ѫֵ",[3]=38,[1]=38,szName="���໤��",dwID=122}},
[9696]={
["1"]={nLevel=1,[2]=80,szDesc="�ܵ����˺�����80%",[3]=80,[1]=80,szName="���Ӱ��",dwID=9696}},
[4444]={
["1"]={nLevel=1,[2]=0,szDesc="�ܵ����˺�����80%",[3]=0,[1]=0,szName="̰ħ��",dwID=4444}},
[3068]={
["1"]={nLevel=1,[2]=25,szDesc="�ܵ����˺�����25%����Ů洲��족�ļ���Ч�����͵�35%����ʽ�������Ľ���15%",[3]=25,[1]=25,szName="����",dwID=3068},
["4"]={nLevel=4,[2]=50,szDesc="�ܵ����˺�����50%����Ů洲��족�ļ���Ч�����͵�20%����ʽ�������Ľ���30%",[3]=50,[1]=50,szName="����",dwID=3068},
["2"]={nLevel=2,[2]=50,szDesc="�ܵ����˺�����50%����Ů洲��족�ļ���Ч�����͵�20%����ʽ�������Ľ���15%",[3]=50,[1]=50,szName="����",dwID=3068}},
[134]={
["1"]={nLevel=1,[2]=30,szDesc="���������ܵ����˺�������Խ�ߣ�������Խ��",[3]=30,[1]=30,szName="��������",dwID=134}},
[6224]={
["1"]={nLevel=1,[2]=30,szDesc="�����˺�",[3]=30,[1]=30,szName="����",dwID=6224}},
[9919]={
["1"]={nLevel=1,[2]=0,[4]=3,szDesc="����������һ���ܵ��Ĺ����˺�����಻����������Ѫ���ֵ20%",[3]=0,[1]=0,szName="�Ļ�̾",dwID=9919}},
[6279]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ��˺�����40%�������ƶ����ƣ��������⣩",[3]=40,[1]=40,szName="̰ħ��",dwID=6279}},
[6125]={
["1"]={nLevel=1,[2]=0,szDesc="��ͻ����������ʩչһ��",[3]=0,[1]=0,szName="����",dwID=6125}},
[6636]={
["1"]={nLevel=1,[2]=45,szDesc="�ܵ��˺�����45%",[3]=45,[1]=45,szName="ʥ��֯��",dwID=6636},
["2"]={nLevel=2,[2]=45,szDesc="�ܵ��˺�����55%",[3]=45,[1]=45,szName="ʥ��֯��",dwID=6636}},
[6637]={
["1"]={nLevel=1,[2]=45,szDesc="�ܵ��˺�����45%",[3]=45,[1]=45,szName="ʥ��֯��",dwID=6637},
["2"]={nLevel=2,[2]=55,szDesc="�ܵ��˺�����55%",[3]=45,[1]=55,szName="ʥ��֯��",dwID=6637}},
[1177]={
["1"]={nLevel=1,[2]=30,szDesc="�����ܵ����˺�<BUFF atGlobalDamageAbsorb>��",[3]=30,[1]=30,szName="����",dwID=1177}},
[10369]={
["1"]={nLevel=1,[2]=3,szDesc="ÿ����������˺���3%",[3]=3,[1]=3,szName="����ɽ",dwID=10369}},
[13771]={
["1"]={nLevel=1,[2]=100,szDesc="����е��ܵ����˺�",[3]=100,[1]=100,szName="����߳��",dwID=13771}},
[6616]={
["1"]={nLevel=1,[2]=99,szDesc="�ܵ����˺�����99%",[3]=99,[1]=99,szName="�ܱ�",dwID=6616}},
[11344]={
["1"]={nLevel=1,[2]=10,szDesc="ÿ�����10%",[3]=10,[1]=10,szName="�Ͻ���ӡ",dwID=11344}},
[6240]={
["1"]={nLevel=1,[2]=40,szDesc="ʹ�����ܵ����˺�����40%",[3]=40,[1]=40,szName="��ˮ��",dwID=6240}},
[9803]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ����˺�����40%",[3]=40,[1]=40,szName="�����",dwID=9803},
["4"]={nLevel=4,[2]=55,szDesc="�ܵ����˺�����55%",[3]=55,[1]=55,szName="�����",dwID=9803},
["3"]={nLevel=3,[2]=50,szDesc="�ܵ����˺�����50%",[3]=50,[1]=50,szName="�����",dwID=9803},
["2"]={nLevel=2,[2]=45,szDesc="�ܵ����˺�����45%",[3]=45,[1]=45,szName="�����",dwID=9803}},
--[996]={
--["1"]={nLevel=1,[2]=0,szDesc="�ƶ��ٶȽ���50%",[3]=0,[1]=0,szName="�����",dwID=996},
--["2"]={nLevel=2,[2]=0,szDesc="�ƶ��ٶȽ���10%",[3]=0,[1]=0,szName="�����",dwID=996}},
[18001]={
["1"]={nLevel=1,[2]=50,szDesc="�����޷�ʩչ��ʽЧ�����ܵ��˺�����50%",[3]=50,[1]=50,szName="����",dwID=18001}},
[8495]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ����˺�����40%",[3]=40,[1]=40,szName="����",dwID=8495}},
--[9694]={
--["1"]={nLevel=1,[2]=0,szDesc="�ܵ�����Ч������40%",[3]=0,[1]=0,szName="���Ӱ��",dwID=9694}},
[5374]={
["1"]={nLevel=1,[2]=30*0.08,szDesc="�������20%������30%��Զ���˺�",[3]=20*0.08,[1]=20*0.08,szName="��ǽ",dwID=5374}},
[1547]={
["1"]={nLevel=1,[2]=100,szDesc="����һ���˺�",[3]=100,[1]=100,szName="��",dwID=1547}},
[367]={
["1"]={nLevel=1,[2]=80,szDesc="�ܵ����˺�����80%",[3]=80,[1]=80,szName="����ɽ",dwID=367}},
[8427]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ����˺�����50%",[3]=50,[1]=50,szName="�ٻ�",dwID=8427}},
[9293]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ������˺�����50%",[3]=50,[1]=50,szName="��Ӱ",dwID=9293}},
[9775]={
["1"]={nLevel=1,[2]=40,szDesc="�����ܵ����˺�40%",[3]=40,[1]=40,szName="��صͰ�",dwID=9775}},
[2953]={
["1"]={nLevel=1,[2]=45,szDesc="�ܵ����˺�����45%",[3]=45,[1]=45,szName="ʥ��֯��",dwID=2953},
["2"]={nLevel=2,[2]=55,szDesc="�ܵ����˺�����55%",[3]=55,[1]=55,szName="ʥ��֯��",dwID=2953}},
[8650]={
["1"]={nLevel=1,[2]=30,szDesc="ʹ�����ܵ����˺�����30%",[3]=30,[1]=30,szName="��ǽ",dwID=8650}},
[14105]={
["1"]={nLevel=1,[2]=80,szDesc="�ܵ����˺�����80%�������߿���Ч��",[3]=80,[1]=80,szName="��������",dwID=14105}},
-- [9534]={
-- ["1"]={nLevel=1,[2]=100,szDesc="�����罣�����������ƽ��ν��",[3]=100,[1]=100,szName="��ڤ��",dwID=9534},
-- ["3"]={nLevel=3,[2]=100,szDesc="���ɻ���������",[3]=100,[1]=100,szName="�ɻ�����",dwID=9534},
-- ["2"]={nLevel=2,[2]=100,szDesc="����������",[3]=100,[1]=100,szName="��ڤ��",dwID=9534}},
[360]={
["1"]={nLevel=1,[2]=100,szDesc="ÿ�㻯��һ���˺�",[3]=100,[1]=100,szName="��",dwID=360}},
[4439]={
["1"]={nLevel=1,[2]=80,szDesc="�ܵ����˺�����<BUFF_EX 1024 atGlobalResistPercent>%�������ƶ����ƣ��������⣩",[3]=80,[1]=80,szName="̰ħ��",dwID=4439}},
[2805]={
["1"]={nLevel=1,[2]=20,szDesc="�ܵ����ڹ��˺�����20%",[3]=0,[1]=20,szName="���",dwID=2805},
["2"]={nLevel=2,[2]=50,szDesc="�ܵ����ڹ��˺�����50%",[3]=0,[1]=50,szName="���",dwID=2805}},
[2251]={
["1"]={nLevel=1,szDesc="�ܵ����˺�����5%",[3]=50,dwID=2251,szName="����"}},

[9809]={
["1"]={nLevel=1,[2]=0,[5]=22.5,szDesc="�����˺�22.5%�����30%���Ʒ��ȼ��������˺�40%ת��Ϊ����ֵ���ܵ��˺���10%����ʹ����ظ�5%��Ѫ���ֵ",[3]=0,[1]=0,szName="�޺�����",dwID=9809},
["2"]={nLevel=2,[2]=0,[5]=0.5,[5]=15,szDesc="�����˺�15%�����30%���Ʒ��ȼ��������˺�40%ת��Ϊ����ֵ���������ʵ�20%ת��Ϊ�����ڹ��������ܵ��˺���10%����ʹ����ظ�5%��Ѫ���ֵ",[3]=0,[1]=0,szName="�޺�����",dwID=9809}},
[11980]={
["1"]={nLevel=1,[2]=0,[5]=15,szDesc="�˺�����15%�����30%���Ʒ��ȼ��������˺�40%ת��Ϊ����ֵ���ڹ������������30%�������ܼ���Ч��Ӱ�죬�ܵ��˺���15%����ʹ�����ߵ���3��",[3]=0,[1]=0,szName="�޺�����",dwID=11980}},
[388]={
["1"]={nLevel=1,[2]=0,[5]=13.3,szDesc="�˺�����13.3%",[3]=0,[1]=0,szName="�޺�����",dwID=388}},
[11981]={
["1"]={nLevel=1,[2]=0,[5]=22.5,szDesc="�˺�����22.5%�����30%���Ʒ��ȼ��������˺�40%ת��Ϊ����ֵ���ڹ������������30%���ܵ��˺���10%����ʹ����ظ�5%��Ѫ���ֵ",[3]=0,[1]=0,szName="�޺�����",dwID=11981}},
[11979]={["1"]={nLevel=1,[2]=0,[5]=15,szDesc="�˺�����15%�����30%���Ʒ��ȼ��������˺�40%ת��Ϊ����ֵ���ڹ������������30%��ʩչ�˺���ʽ��35%����ʹ������һ����ʽ�˺����30%����˳�ƻӹ�������ǰ��6�������������6���ж�Ŀ����������ڹ��˺�",[3]=0,[1]=0,szName="�޺�����",dwID=11979}},
[2792]={
["1"]={nLevel=1,[2]=0,[5]=15.3,szDesc="�˺�����15.3%",[3]=0,[1]=0,szName="�޺�����",dwID=2792}},
[2794]={
["1"]={nLevel=1,[2]=0,[5]=46,szDesc="�˺�����46%",[3]=0,[1]=0,szName="�޺�����",dwID=2794}},
[2796]={
["1"]={nLevel=1,[2]=0,[5]=30,szDesc="�˺�����30%",[3]=0,[1]=0,szName="�޺�����",dwID=2796}},
[1152]={
["1"]={nLevel=1,[2]=0,[5]=50,szDesc="���������ܵ��˺���50%",[3]=0,[1]=0,szName="�޺�����",dwID=1152}},
[390]={
["1"]={nLevel=1,[2]=0,[5]=40,szDesc="�˺�����40%",[3]=0,[1]=0,szName="�޺�����",dwID=390}},
[389]={
["1"]={nLevel=1,[2]=0,[5]=26.7,szDesc="�˺�����26.7%",[3]=0,[1]=0,szName="�޺�����",dwID=389}},
[1561]={
["1"]={nLevel=1,[2]=0,[5]=100,szDesc="���������ܵ��������˺�",[3]=0,[1]=0,szName="�޺�����",dwID=1561}},
[9806]={
["1"]={nLevel=1,[2]=0,[5]=15,szDesc="�˺�����15%�����30%���Ʒ��ȼ����˺�40%ת��Ϊ����ֵ�������ܼ���Ч��Ӱ�죬�ܵ��˺���15%����ʹ�����ߵ���3��",[3]=0,[1]=0,szName="�޺�����",dwID=9806}},
[10486]={
["1"]={nLevel=1,[2]=0,[5]=70,szDesc="�����ܵ����˺�70%",[3]=0,[1]=0,szName="�����",dwID=10486}},
[10493]={
["1"]={nLevel=1,[2]=5,[5]=70,szDesc="�ܵ����˺�����5%�������ܵ���70%�˺�",[3]=5,[1]=5,szName="�����",dwID=10493}},
[9808]={
["1"]={nLevel=1,[2]=0,[5]=45,szDesc="�����˺�45%",[3]=0,[1]=0,szName="�޺�����",dwID=9808}},
[3198]={
["1"]={nLevel=1,[2]=0,[5]=200,szDesc="�������ܵ��˺�200%",[3]=0,[1]=0,szName="�޺�����",dwID=3198}},
[9807]={
["1"]={nLevel=1,[2]=0,[5]=30,szDesc="�����˺�30%",[3]=0,[1]=0,szName="�޺�����",dwID=9807}},
[9805]={
["1"]={nLevel=1,[2]=0,[5]=30,szDesc="�˺�����30%��������10%����ʹĿ�굹��3�룬��30%���ʽ������Ч��",[3]=0,[1]=0,szName="�޺�����",dwID=9805}},
[2793]={
["1"]={nLevel=1,[2]=0,[5]=30.7,szDesc="�˺�����30.7%",[3]=0,[1]=0,szName="�޺�����",dwID=2793}},
[2795]={
["1"]={nLevel=1,[2]=0,[5]=20,szDesc="�˺�����20%",[3]=0,[1]=0,szName="�޺�����",dwID=2795}},
[2797]={
["1"]={nLevel=1,[2]=0,[5]=15,szDesc="�˺�����15%�����30%���Ʒ��ȼ��������˺�40%ת��Ϊ����ֵ",[3]=0,[1]=0,szName="�޺�����",dwID=2797}},
-- [1261]={
-- ["1"]={nLevel=1,[2]=0,szDesc="����������Ѫ���ֵ����50%",[3]=0,[1]=0,szName="��������",dwID=1261}},
[9804]={
["1"]={nLevel=1,[2]=0,[5]=20,szDesc="�˺�����20%��������10%����ʹĿ�굹��3�룬��20%���ʽ������Ч��",[3]=0,[1]=0,szName="�޺�����",dwID=9804}},
[13744]={
["1"]={nLevel=1,[2]=0,[5]=50,szDesc="�ܵ���������ͷŷ�������",[3]=0,[1]=0,szName="������������",dwID=13744}},
[2778]={
["1"]={nLevel=1,[2]=100,szDesc="�е�100%�˺�",[3]=100,[1]=100,szName="Ԩ",dwID=2778}},
[1242]={
["1"]={nLevel=1,[2]=100,szDesc="�е�100%�˺�",[3]=100,[1]=100,szName="����",dwID=1242},
["2"]={nLevel=2,[2]=100,szDesc="�е�100%�˺���ÿ3�������ԡ����ԡ���Ԫ�����Բ���Ч����2��",[3]=100,[1]=100,szName="����",dwID=1242}},


--�������
[15948]={
["1"]={nLevel=1,[2]=0,[4]=60,szDesc="�������������Ѫֵ60%���˺�",[3]=0,[1]=0,szName="����",dwID=15948}},
[9933]={
["1"]={nLevel=1,[2]=30,[4]=25,szDesc="�ܵ�����Ч�����45%���ܵ��˺�����30%�����������ظ�Ŀ��25%��Ѫ����ͨ����������Ч��ʹĿ���������˲��ظ�50%��Ѫ���ֵ",[3]=30,[1]=30,szName="����",dwID=9933}},
[17028]={
["1"]={nLevel=1,[2]=0,[4]=8,szDesc="�������������Ѫֵ8%���˺�",[3]=0,[1]=0,szName="���",dwID=17028}},
[15919]={
["1"]={nLevel=1,[2]=50,szDesc="�ܵ����˺�����50%",[3]=50,[1]=50,szName="�����",dwID=15919},
["3"]={nLevel=3,[2]=60,szDesc="�ܵ����˺�����60%",[3]=60,[1]=60,szName="�����",dwID=15919},
["2"]={nLevel=2,[2]=55,szDesc="�ܵ����˺�����55%",[3]=55,[1]=55,szName="�����",dwID=15919},
["5"]={nLevel=5,[2]=70,szDesc="�ܵ����˺�����70%",[3]=70,[1]=70,szName="�����",dwID=15919},
["4"]={nLevel=4,[2]=65,szDesc="�ܵ����˺�����65%",[3]=65,[1]=65,szName="�����",dwID=15919},
["7"]={nLevel=7,[2]=80,szDesc="�ܵ����˺�����80%",[3]=80,[1]=80,szName="�����",dwID=15919},
["6"]={nLevel=6,[2]=75,szDesc="�ܵ����˺�����75%",[3]=75,[1]=75,szName="�����",dwID=15919},
["9"]={nLevel=9,[2]=90,szDesc="�ܵ����˺�����90%",[3]=90,[1]=90,szName="�����",dwID=15919},
["8"]={nLevel=8,[2]=85,szDesc="�ܵ����˺�����85%",[3]=85,[1]=85,szName="�����",dwID=15919},
["11"]={nLevel=11,[2]=90,szDesc="�ܵ����˺�����90%",[3]=90,[1]=90,szName="�����",dwID=15919},
["10"]={nLevel=10,[2]=90,szDesc="�ܵ����˺�����90%",[3]=90,[1]=90,szName="�����",dwID=15919}},
[9336]={
["1"]={nLevel=1,[2]=30,szDesc="ʹ�����ܵ�����һ�μ����˺�����30%",[3]=30,[1]=30,szName="��÷",dwID=9336},
["2"]={nLevel=2,[2]=30,szDesc="ʹ�����ܵ�����Ч������30%���ܵ�����һ�μ����˺�����30%",[3]=30,[1]=30,szName="��÷",dwID=9336}},
[17094]={
["1"]={nLevel=1,[2]=0,[4]=20,szDesc="����20%��Ѫ���ֵ�˺�",[3]=0,[1]=0,szName="���",dwID=17094}},
[11920]={
["1"]={nLevel=1,[2]=28,szDesc="�ܵ��˺�����28%",[3]=28,[1]=28,szName="���໤��",dwID=11920},
["3"]={nLevel=3,[2]=32,szDesc="�ܵ��˺�����32%",[3]=32,[1]=32,szName="���໤��",dwID=11920},
["2"]={nLevel=2,[2]=30,szDesc="�ܵ��˺�����30%",[3]=30,[1]=30,szName="���໤��",dwID=11920},
["5"]={nLevel=5,[2]=36,szDesc="�ܵ��˺�����36%",[3]=36,[1]=36,szName="���໤��",dwID=11920},
["4"]={nLevel=4,[2]=34,szDesc="�ܵ��˺�����34%",[3]=34,[1]=34,szName="���໤��",dwID=11920},
["7"]={nLevel=7,[2]=45,szDesc="�ܵ��˺�����45%",[3]=45,[1]=45,szName="���໤��",dwID=11920},
["6"]={nLevel=6,[2]=38,szDesc="�ܵ��˺�����38%",[3]=38,[1]=38,szName="���໤��",dwID=11920},
["9"]={nLevel=9,[2]=45,szDesc="�ܵ��˺�����45%",[3]=45,[1]=45,szName="���໤��",dwID=11920},
["8"]={nLevel=8,[2]=43,szDesc="�ܵ��˺�����43%",[3]=43,[1]=43,szName="���໤��",dwID=11920},
["15"]={nLevel=15,[2]=0,szDesc="ÿ����߼�����5%��Ч���ڼ��˹����ᱻ��ϣ������޷�ʩչ�ڹ���ʽЧ��Ӱ��",[3]=0,[1]=0,szName="���໤��",dwID=11920},
["14"]={nLevel=14,[2]=60,szDesc="�ܵ��˺�����60%",[3]=60,[1]=60,szName="���໤��",dwID=11920},
["13"]={nLevel=13,[2]=53,szDesc="�ܵ��˺�����53%",[3]=53,[1]=53,szName="���໤��",dwID=11920},
["12"]={nLevel=12,[2]=51,szDesc="�ܵ��˺�����51%",[3]=51,[1]=51,szName="���໤��",dwID=11920},
["11"]={nLevel=11,[2]=49,szDesc="�ܵ��˺�����49%",[3]=49,[1]=49,szName="���໤��",dwID=11920},
["10"]={nLevel=10,[2]=47,szDesc="�ܵ��˺�����47%",[3]=47,[1]=47,szName="���໤��",dwID=11920}},
[6434]={
["1"]={nLevel=1,[2]=0,szDesc="�������60%���⹦�������20%",[3]=60,[1]=0,szName="����ң",dwID=6434}},
[10000]={
["1"]={nLevel=1,[2]=15,szDesc="ÿ��ʹ�����ܵ����˺�����15%",[3]=15,[1]=15,szName="յө",dwID=10000}},
[11607]={
["1"]={nLevel=1,[2]=10,szDesc="�˺�����10%���ܵ��˺�����10%��ÿ��ָ�5%����Ѫ���ֵ",[3]=10,[1]=10,szName="ս��",dwID=11607}},
[8867]={
["1"]={nLevel=1,[2]=25,szDesc="���������ܵ����˺�����Խ�ߣ�������Խ��",[3]=25,[1]=25,szName="��������",dwID=8867}},
[6120]={
["1"]={nLevel=1,[2]=25,szDesc="�ܵ��˺�����25%",[3]=25,[1]=25,szName="����",dwID=6120}},
[8868]={
["1"]={nLevel=1,[2]=25,szDesc="���������ܵ����˺�����Խ�ߣ�������Խ��",[3]=25,[1]=25,szName="��������",dwID=8868}},
[11201]={
["1"]={nLevel=1,[2]=0,szDesc="�������100%",[3]=100,[1]=0,szName="��Ӱ",dwID=11201}},
[16730]={
["1"]={nLevel=1,[2]=50,szDesc="���������ܵ����˺����˺�����50%����Խ�ߣ�������Խ��",[3]=50,[1]=50,szName="��������",dwID=16730}},
[12558]={
["1"]={nLevel=1,[2]=100,szDesc="�ܵ����˺��ɡ������¡��е�",[3]=100,[1]=100,szName="����",dwID=12558}},
--[5777]={
--["1"]={nLevel=1,[2]=0,szDesc="���߽�е���޷��˹�Ч��",[3]=0,[1]=0,szName="ʥ��֯��",dwID=5777}},
[8245]={
["1"]={nLevel=1,[2]=10*0.08,szDesc="ʹ�����⹦���������ȼ����10%���ڹ����������ȼ����10%����ʽ��вֵ���20%",[3]=10*0.08,[1]=10*0.08,szName="Ѫŭ",dwID=8245},
["3"]={nLevel=3,[2]=6*0.08,szDesc="ʹ�������⹦�����ȼ����6%���ڹ����������ȼ����10%����ʽ��вֵ���20%",[3]=10*0.08,[1]=6*0.08,szName="Ѫŭ",dwID=8245},
["2"]={nLevel=2,[2]=4*0.08,szDesc="ʹ�������⹦�����ȼ����4%���ڹ����������ȼ����10%����ʽ��вֵ���20%",[3]=10*0.08,[1]=4*0.08,szName="Ѫŭ",dwID=8245},
["5"]={nLevel=5,[2]=10*0.08,szDesc="ʹ�������⹦�����ȼ����10%���ڹ����������ȼ����10%����ʽ��вֵ���20%",[3]=10*0.08,[1]=10*0.08,szName="Ѫŭ",dwID=8245},
["4"]={nLevel=4,[2]=8*0.08,szDesc="ʹ�������⹦�����ȼ����8%���ڹ����������ȼ����10%����ʽ��вֵ���20%",[3]=8*0.08,[1]=8*0.08,szName="Ѫŭ",dwID=8245}},
[17990]={
["1"]={nLevel=1,[2]=0,[4]=20,szDesc="�������������Ѫֵ20%���˺�",[3]=0,[1]=0,szName="����",dwID=17990}},
[5668]={
["1"]={nLevel=1,[2]=0,szDesc="���ܼ������60%",[3]=60,[1]=0,szName="�紵��",dwID=5668}},
[18039]={
["1"]={nLevel=1,[2]=30,szDesc="�ܵ����˺�����30%",[3]=30,[1]=30,szName="�������",dwID=18039}},
[2315]={
["1"]={nLevel=1,[2]=35,szDesc="�������˳�Ч���50%����ɵ���в����30%���������㡢����Ч�����ƶ��ٶȽ���20%���ܵ��˺�����35%����ʽ���Ľ���30%���˹����ᱻ�˺����ˣ���������������Ч������",[3]=35,[1]=35,szName="Ů洲���",dwID=2315},
["3"]={nLevel=3,[2]=35,szDesc="�������˳�Ч���100%����ɵ���в����30%���������㡢����Ч�����ܵ��˺�����35%����ʽ���Ľ���30%���˹����ᱻ�˺����ˣ���������������Ч������",[3]=35,[1]=35,szName="Ů洲���",dwID=2315},
["2"]={nLevel=2,[2]=35,szDesc="�������˳�Ч���100%����ɵ���в����30%���������㡢����Ч�����ܵ��˺�����35%����ʽ���Ľ���30%���˹����ᱻ�˺����ˣ���������������Ч������",[3]=35,[1]=35,szName="Ů洲���",dwID=2315}},
[3214]={
["1"]={nLevel=1,[2]=45,szDesc="�����������65%���ܵ��ڹ��˺�����45%",[3]=65,[1]=45,szName="��������",dwID=3214},
["3"]={nLevel=3,[2]=45,szDesc="�����������45%���ܵ��ڹ��˺�����45%",[3]=65,[1]=45,szName="��������",dwID=3214},
["2"]={nLevel=2,[2]=45,szDesc="�����������45%���ܵ��ڹ��˺�����45%",[3]=65,[1]=45,szName="��������",dwID=3214},
["5"]={nLevel=5,[2]=45,szDesc="�����������55%���ܵ��ڹ��˺�����45%",[3]=65,[1]=45,szName="��������",dwID=3214},
["4"]={nLevel=4,[2]=45,szDesc="�����������45%���ܵ��ڹ��˺�����45%",[3]=65,[1]=45,szName="��������",dwID=3214},
["7"]={nLevel=7,[2]=45,szDesc="�����������55%���ܵ��ڹ��˺�����45%",[3]=65,[1]=45,szName="��������",dwID=3214},
["9"]={nLevel=9,[2]=45,szDesc="�����������45%���ܵ��ڹ��˺�����45%",[3]=65,[1]=45,szName="��������",dwID=3214},
["12"]={nLevel=12,[2]=45,szDesc="�����������80%���ܵ��ڹ��˺�����60%",[3]=65,[1]=45,szName="��������",dwID=3214},
["11"]={nLevel=11,[2]=45,szDesc="�����������45%���ܵ��ڹ��˺�����45%",[3]=65,[1]=45,szName="��������",dwID=3214},
["10"]={nLevel=10,[2]=45,szDesc="�����������45%���ܵ��ڹ��˺�����45%",[3]=65,[1]=45,szName="��������",dwID=3214}},
-- [15494]={
-- ["1"]={nLevel=1,[2]=0,szDesc="���Ӵ�����Ѫ���ޣ��˺������ƽ������10%����������350����������200��ÿ��ظ�2%�����Ѫֵ",[3]=0,[1]=0,szName="ս��",dwID=15494},
-- ["2"]={nLevel=2,[2]=0,szDesc="���Ӵ�����Ѫ���ޣ��˺������ƽ������15%����������700����������400��ÿ��ظ�2%�����Ѫֵ",[3]=0,[1]=0,szName="ս��",dwID=15494}},
[6174]={
["1"]={nLevel=1,[2]=0,szDesc="���ܼ������40%",[3]=40,[1]=0,szName="����",dwID=6174}},
-- [15495]={
-- ["1"]={nLevel=1,[2]=0,szDesc="������������ʢ�������ܵ��˺��������俿���ı���Ӫ��ʿ�����ս��״̬",[3]=0,[1]=0,szName="ս��",dwID=15495}},
-- [3202]={
-- ["1"]={nLevel=1,[2]=0,szDesc="ÿ2���ܵ�<BUFF atCallPhysicsDamage>���⹦�˺�",[3]=0,[1]=0,szName="����",dwID=3202}},
-- [16750]={
-- ["1"]={nLevel=1,[2]=0,szDesc="��ҹԭ�سֱ���ת�����������˺�",[3]=0,[1]=0,szName="ն�޳�",dwID=16750}},
[12580]={
["1"]={nLevel=1,[2]=25,szDesc="�ܵ����˺�����25%",[3]=25,[1]=25,szName="����",dwID=12580}},
[6143]={
["1"]={nLevel=1,[2]=0,szDesc="���ܼ������15%��ÿ��������56.25���˺�����������ʱ��˥��",[3]=15,[1]=0,szName="Ȫ����",dwID=6143}},
[6299]={
["1"]={nLevel=1,[2]=0,szDesc="ʩչ��ʽ��������вֵ�����ܼ������50%",[3]=50,[1]=0,szName="�������",dwID=6299},
["2"]={nLevel=2,[2]=0,szDesc="ʩչ��ʽ��������вֵ�����ܼ������65%",[3]=65,[1]=0,szName="�������",dwID=6299}},
[12411]={
["1"]={nLevel=1,[2]=10,szDesc="�����ܵ��˺�����10%,��ʹ���Ƹ�Ч����Ŀ��������Ч��",[3]=10,[1]=10,szName="����Ϸˮ",dwID=12411}},
[10617]={
["1"]={nLevel=1,[2]=0,szDesc="ÿ��ʹ�������ܼ������10%",[3]=10,[1]=0,szName="����",dwID=10617}},
-- [3215]={
-- ["1"]={nLevel=1,[2]=0,szDesc="�⹦���н���45%",[3]=0,[1]=0,szName="���켬��",dwID=3215}},
-- [13074]={
-- ["1"]={nLevel=1,[2]=0,szDesc="���˵��˿�ʹ�Լ�ÿ��ظ���Ѫֵ������30�룬���ɵ���",[3]=0,[1]=0,szName="ս��",dwID=13074}},
[9830]={
["1"]={nLevel=1,[2]=99,szDesc="�ܵ��˺���99%ת�Ƹ�����",[3]=99,[1]=99,szName="����",dwID=9830}},
-- [14965]={
-- ["1"]={nLevel=1,[2]=0,szDesc="����",[3]=0,[1]=0,szName="յө",dwID=14965}},
[2065]={
["1"]={nLevel=1,[2]=0,szDesc="���㼸�����50%",[3]=50,[1]=0,szName="������",dwID=2065},
["2"]={nLevel=2,[2]=0,szDesc="���㼸�����75%",[3]=75,[1]=0,szName="������",dwID=2065}},
[18084]={
["1"]={nLevel=1,[2]=100,szDesc="�ֵ���һ���ܵ����˺�,��ʹ���Ƹ�Ч����Ŀ��������Ч��",[3]=100,[1]=100,szName="����Ϸˮ",dwID=18084}},
[9265]={
["1"]={nLevel=1,[2]=50,szDesc="����и�Ч����С�ӳ�Ա�໥ƽ̯�˺�������Ч��",[3]=50,[1]=50,szName="�����ả",dwID=9265}},
[9171]={
["1"]={nLevel=1,[2]=40,szDesc="�ܵ����ڹ��˺�����40%",[3]=0,[1]=40,szName="����",dwID=9171}},
[18148]={
["1"]={nLevel=1,[2]=0,[4]=8,szDesc="��������8%�����Ѫֵ���˺�",[3]=0,[1]=0,szName="�ӹ�",dwID=18148}},
[18088]={
["1"]={nLevel=1,[2]=0,szDesc="���ܼ������45%",[3]=45,[1]=0,szName="����",dwID=18088}},
[17997]={
["1"]={nLevel=1,[2]=0,[4]=30,szDesc="�������������Ѫֵ30%���˺�",[3]=0,[1]=0,szName="����",dwID=17997}},
[17092]={
["1"]={nLevel=1,[2]=0,szDesc="���ﻯ�������б��",[3]=0,[1]=0,szName="���",dwID=17092},
["2"]={nLevel=2,[2]=0,[4]=20,szDesc="����20%��Ѫ���ֵ�˺�",[3]=0,[1]=0,szName="���",dwID=17092}},
[14637]={
["1"]={nLevel=1,[2]=40,[5]=40,szDesc="Я����ˮ������Ŀ��Ϊ����е�40%�ܵ����˺�",[3]=40,[1]=40,szName="��ˮ��",dwID=14637},
["3"]={nLevel=3,[2]=55,[5]=55,szDesc="Я����ˮ������Ŀ��Ϊ����е�55%�ܵ����˺�",[3]=55,[1]=55,szName="��ˮ��",dwID=14637},
["2"]={nLevel=2,[2]=70,[5]=70,szDesc="����е�����70%�ܵ����˺�",[3]=70,[1]=70,szName="��ˮ��",dwID=14637}},
-- [8253]={
-- ["1"]={nLevel=1,[2]=0,szDesc="ʹ�������൱���������ֵ���˺���",[3]=0,[1]=0,szName="����",dwID=8253}},
[2542]={
["1"]={nLevel=1,[2]=0,[4]=15,szDesc="�����˺�",[3]=0,[1]=0,szName="����׼�",dwID=2542}},
[12361]={
["1"]={nLevel=1,[2]=50,szDesc="���ͷ����໥ƽ̯�˺�������Ч��",[3]=50,[1]=50,szName="����",dwID=12361}},
-- [1686]={
-- ["1"]={nLevel=1,[2]=0,szDesc="ÿ�뷢��һ�ι���",[3]=0,[1]=0,szName="��Ȫ����",dwID=1686}}

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
	local nReductionPercent1 = 0 --�ڹ�����
	local nReductionPercent2 = 0 --�⹦����
	
	local nReductionType = 1

	if ZMAC_OptionFunc.stats('�ڹ�')  then
		nReductionType =2
	elseif ZMAC_OptionFunc.stats('�⹦') then
		nReductionType =3
	end
	
	local MaxLifeUp = 0  --�ֵ��˺����������Ѫ�ٷֱ�
	local Fantan = 0
	
	for i = 1, #BuffList, 1 do
		
		local buffid,bufflv,stack = BuffList[i].dwID ,BuffList[i].nLevel ,BuffList[i].nStackNum
		buffid = tonumber(buffid)
		bufflv = tostring(bufflv)
		stack = tonumber(stack)
		local stack1 = stack --����stack
		local stack2 = stack --��Ѫstack
		
		if buffid == 1552 or buffid == 3120 or buffid == 6257 or buffid == 6264 or buffid == 3171 or buffid == 122 or buffid == 11920 then --����
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
			if _ZMAC.ReductionList[buffid][bufflv][2] then --�ڹ�����
				nReductionPercent1 = nReductionPercent1 + _ZMAC.ReductionList[buffid][bufflv][2]*stack1
			end
			if _ZMAC.ReductionList[buffid][bufflv][3] then --�⹦����
				nReductionPercent2 = nReductionPercent2+ _ZMAC.ReductionList[buffid][bufflv][3]*stack1
			end
			if _ZMAC.ReductionList[buffid][bufflv][4] then  --������Ѫ�ٷֱ�
				MaxLifeUp = MaxLifeUp + _ZMAC.ReductionList[buffid][bufflv][4]*stack2
			end
			if _ZMAC.ReductionList[buffid][bufflv][5] then  --�����ٷֱ�
				Fantan = Fantan + _ZMAC.ReductionList[buffid][bufflv][5]*stack1
			end
			
		end
	end
	local upLife = pTar.nMaxLife * MaxLifeUp + pTar.nCurrentLife  --�����Ѫ���⻻��
	
	local nReuductionTmp =1 / ( 1 - nReductionPercent/100 )  --����ϵ������
	local realLife = upLife * nReuductionTmp --��ʵѪ��
	local bb =( ( realLife-pTar.nCurrentLife) / realLife )  * 100   --���ռ���ϵ��
	--Output(nReductionPercent1,nReductionPercent2)
	
	
	local nReuductionTmp2 =1 / ( 1 - (nReductionPercent1+ nReductionPercent2)/2/100 )  --����ϵ������
	local realLife2 = upLife * nReuductionTmp2 --��ʵѪ��
	local aa =( ( realLife2-pTar.nCurrentLife) / realLife2 )  * 100   --���ռ���ϵ��
	return bb/100,pTar.nCurrentLife/ (1-bb/100),nReductionPercent/100,MaxLifeUp/100,Fantan/100 ,aa/100--��3��Ϊ����ϵ������4��Ϊ����ֵ����ٷֱȣ���1��Ϊ�ۺ�ϵ������2��Ϊ��������ֵ����,�����Ϊ����ϵ��,������Ϊ���⹦ƽ������
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
	['life'] = 'life',     --Ѫ���ٷֱ���
	['tlife'] = 'tlife',
	['ttlife'] = 'ttlife',
	['petlife']='petlife',

	['mana'] = 'mana',      --�����ٷֱ���
	['tmana'] = 'tmana',
	['ttmana'] = 'ttmana',

	['rage'] = 'rage',       --����ŭ�����Ե����⡢�ؽ����������ս�⡢��������
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
	['energy'] = 'energy',      --���ꡢ���ֵ
	['tenergy'] = 'tenergy',
	['qidian'] = 'qidian',       --���ǡ����㡢����
	['tqidian'] = 'tqidian',
	['sun'] = 'sun',               --�������顢�Ե�����
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
	['fight'] = 'fight',      --��ս״̬
	['petfight'] = 'petfight', 
	['nofight'] = 'nofight',
	['petnofight'] = 'petnofight', 
	['tfight'] = 'tfight',
	['tnofight'] = 'tnofight',
	['ttfight'] = 'ttfight',
	['ttnofight'] = 'ttnofight',
	['fighttime'] = 'fighttime',
	['horse'] = 'horse',      --����״̬
	['nohorse'] = 'nohorse',
	['thorse'] = 'thorse',
	['tnohorse'] = 'tnohorse',
	['mount'] = 'mount',            --�ķ�����
	['tmount'] = 'tmount',
	['ttmount'] = 'ttmount',
	['nomount'] = 'nomount',
	['tnomount'] = 'tnomount',
	['ttnomount'] = 'ttnomount',
	['bufftime'] = 'bufftime',         --buff��
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
	['status'] = 'status',               --������̬
	['tstatus'] = 'tstatus',
	['ttstatus'] = 'ttstatus',
	['stats'] = 'stats',               --����״̬
	['tstats'] = 'tstats',
	['ttstats'] = 'ttstats',
	['nostats'] = 'nostats',               --����״̬
	['tnostats'] = 'tnostats',
	['ttnostats'] = 'ttnostats',
	['petstatus'] = 'petstatus',
	['nostatus'] = 'nostatus',
	['tnostatus'] = 'tnostatus',
	['ttnostatus'] = 'ttnostatus',
	['petnostatus'] = 'petnostatus',
	['line'] = 'line',                      --������
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

	
	
	
	['otaction']='otaction',             --�������
	['nootaction']='nootaction',
	['totaction']='totaction',
	['tnootaction']='tnootaction',
	
	['prepare'] = 'prepare',              --������
	['preparename'] = 'prepare',
	['noprepare'] = 'noprepare',
	['tprepare'] = 'tprepare',
	['tpreparename'] = 'tprepare',
	['ttprepare'] = 'ttprepare',
	['tnoprepare'] = 'tnoprepare',
	['ttnoprepare'] = 'ttnoprepare',
	
	['channel']='channel',                      --�����
	['nochannel']='nochannel',
	['tchannel']='tchannel',
	['tnochannel']='tnochannel',
	--['channelskill']='prepare',
	['broken'] = 'broken',              --�ɴ��
	['tbroken'] = 'tbroken',
	['nobroken'] = 'nobroken',
	['tnobroken'] = 'tnobroken',
	['tbrokenname'] = 'tbrokenname',
	['tbrokentime'] = 'tbrokentime',
	
	--['self'] = 'self',                --δ֪��ɶ
	['level'] = 'level',             --�ȼ�
	['bomb'] = 'bomb',                      --����ɱ��
	['puppet'] = 'puppet',                  --����
	['puppetdistance']='puppetdistance',
	['tpuppetdistance']='tpuppetdistance',
	['nopuppet'] = 'nopuppet',
	['pet'] = 'pet',                        --����
	['nopet'] = 'nopet',                    
	['jgnum'] = 'jgnum',                    --��������
	['pupdis']= 'pupdis',                   --ǧ�������
	
	['enemynum']='enemynum',                   --���������
	['enemylookmenum']='enemylookmenum',
	['tenemynum']='tenemynum',
	['ttenemynum']='ttenemynum',
	['allynum']='allynum',
	['tallynum']='tallynum',
	['tpartynum']='tpartynum',
	['ttallynum']='ttallynum',
	['enemynpcnum'] = 'enemynpcnum',                  --NPC������
	['allynpcnum'] = 'allynpcnum',
	['partynum'] = 'partynum',
	['tenemynpcnum'] = 'tenemynpcnum',                  
	['tallynpcnum'] = 'tallynpcnum',
	
	['npcs']='npcs',                         --���뷶Χ��npc�Ƿ������
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
	
	--[[��bug����
	['nonpcexist'] = 'nonpcexist',          
	['npcexistc'] = 'npcexist',
	['areanpccast'] = 'areanpccast',       --��Χ�й���ʩչ����
	['npctalk'] = 'npctalk',                 --npc����
	['npclastcast'] = 'npclastcast',       --npc�ϴμ���
	['npccasttime'] = 'npccasttime',              --npc�ͷż��ܼ��
	--]]
	
	['neutrality'] = 'neutrality',     --��Ӫ��ϵ--����
	['tneutrality'] = 'tneutrality', 
	['ttneutrality '] = 'ttneutrality ',
	['ally'] = 'ally',             --ͬ��
	['tally'] = 'tally',
	['ttally'] = 'ttally',
	['enemy'] = 'enemy',             --�ж�
	['tenemy'] = 'enemy',  
	['ttenemy'] = 'ttenemy',
	['isparty']='isparty',
	['tisparty']='tisparty',
	['ttisparty']='ttisparty',
	
	['tchoosetime'] = 'tchoosetime',
	
	['target'] = 'target',  --Ŀ������
	['ttarget'] = 'ttarget',
	['exists'] = 'exists',                 --Ŀ���Ƿ����
	['pettarget']='pettarget',             --��������Ŀ��
	['texists'] = 'texists',
	['noexists'] = 'noexists',
	['petnotarget']='petnotarget',
	['tnoexists'] = 'tnoexists',
	['force'] = 'force',
	['tforce'] = 'tforce',--����
	['ttforce'] = 'ttforce',
	['tnoforce'] = 'tnoforce',
	['ttnoforce'] = 'ttnoforce',
	['tname'] = 'tname',--Ŀ������
	['pettname']='pettname',
	['ttname'] = 'ttname',
	['tnoname'] = 'tnoname',
	['petnotname']='pettnoname',
	['ttnoname'] = 'ttnoname',
	['distance'] = 'tdistance',--����
	['tdistance'] = 'tdistance',--����
	['ttdistance'] = 'ttdistance',
	['distancenz'] = 'distancenz',
	['tbechasing'] = 'tbechasing',
	['tbechasingdistance'] = 'tbechasingdistance',
	['petdistance']='petdistance',
	['tpetdistance']='tpetdistance',
	
	['heightz'] = 'heightz',
	['tdistancenz'] = 'tdistancenz',
	
	['cd'] = 'cd',--CD��
	['nocd'] = 'nocd',
	['gcd']='gcd',
	['nogcd']='nogcd',
	['petcd'] = 'cd',--CD��
	['petnocd'] = 'nocd',
	['cdtime'] = 'cdtime',
	['num']='num',
	['mcast']='mcast',
	['tcast'] = 'tcast',
	['mhit']='mhit',
	['thit']='thit',
	
	['dead'] = 'dead',--����
	['nodead'] = 'nodead',
	['tdead'] = 'tdead',
	['tnodead'] = 'tnodead',
	['ttdead'] = 'ttdead',
	['ttnodead'] = 'ttnodead',
	['btype'] = 'btype',   --buff����--�⹦�����ԡ���Ԫ�����ԡ����ԡ���
	['tbtype'] = 'tbtype',   
	['ttbtype'] = 'ttbtype',
	['detype'] = 'detype',     --�⹦�����ԡ���Ԫ�����ԡ���Ѩ�����ԡ���
	['tdetype'] = 'tdetype',
	['ttdetype'] = 'ttdetype',
	['lastcast'] = 'lastcast',        --��һ������
	['nolastcast'] = 'nolastcast',
	['preskill'] = 'lastcast',        --��һ������
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
	
	['fly']='fly',         --�Ƿ����Ṧ״̬��
	['nofly']='nofly',
	
	['role']='role',         --����
	['norole']='norole',
	['trole']='trole',
	['tnorole']='tnorole',
	['inallycfzy']='inallycfzy',
	
	['bmove']='bmove',        --ؤ��Ե���ֱ
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
		return GetClientPlayer().nMoveState == 27        --ؤ��/�Ե���ֱ
	end,
	
	tbmove=function()
		if _ZMAC.checktarget('t') then 
			local t = _ZMAC.checktarget('t')
			return t.nMoveState == 27        --ؤ��/�Ե���ֱ
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
	
	--����ŭ�����Ե����⡢�ؽ����������ս�⡢��������
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
	--���ֵ
	tm = function (cNum, cType)
		local hPlayer = GetClientPlayer()
		local Energy= hPlayer.nCurrentEnergy
		return _ZMAC_Compare(cType, Energy, cNum)
	end,
	--���ꡢ���ֵ
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
	
	
	--����ҩ���º���
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
	
	--����ҩ���º���
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
	
	--����������
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
	
	--�Ե�����
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
	
	
	
	--����״̬
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
		if GetPlayer(t.dwID)and t.dwID ~= 0 then   --Ŀ������ΪPLAYER
			return t.bOnHorse
		else return false end
	end,
	tnohorse=function()
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if not t then return false end
		if GetPlayer(t.dwID) and t.dwID ~= 0 then   --Ŀ������ΪPLAYER
			return not t.bOnHorse
		else return false end
	end,
	--�ķ�����
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
	--buff��
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
	
	
	
	
	--��̬��
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
	--����
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

	
	--����
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
	
	
	
	--���
	broken = function()
		local hPlayer = GetClientPlayer()
		--local t = GetTargetHandle(hPlayer.GetTarget())
		local t = hPlayer
		if not t then
			return false
		end
		if t.dwID < 1073741824 and t.dwID ~= 0 then   --Ŀ������ΪPLAYER
			local retxxx,PrepareState, PreSkillID, PreSkillLv, PrePer = pcall(t.GetSkillOTActionState)
			if retxxx ==false then --Ե��
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
	tbroken = function()       --meiдnpc��Ķ����ж�
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if GetPlayer(t.dwID) then   --Ŀ������ΪPLAYER
			--local PrepareState, PreSkillID, PreSkillLv,fP = t.GetSkillOTActionState()
			local retxxx,PrepareState, PreSkillID, PreSkillLv, PrePer = pcall(t.GetSkillOTActionState)
			if retxxx ==false then --Ե��
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
			if retxxx ==false then --Ե��
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
	tnobroken = function()       --meiдnpc��Ķ����ж�
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
	
	
	
	
	--����״̬������
	self =function(str) 
		return _ZMAC.SelfJudgement(str)
	end,
	--�ȼ�
	level = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		return _ZMAC_Compare(cType, hPlayer.nLevel, cNum)
	end,
	
	
	
	
	--����ɱ��
	bomb =function(str,...) --�����ͷŰ���ɱ������
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
				if v.szName == "���ذ���ɱ��" and nDist <= tDis and v.dwEmployer == player.dwID then
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
			if v.szName == "���ذ���ɱ��" and nDist <= tDis and v.dwEmployer == hPlayer.dwID then
				nCount = nCount + 1
			end
		end
		return _ZMAC_Compare(cType, nCount, tonumber(Value))
		
	end,
	
	--����
	puppet = function(str)
		if _ZMAC.IsPuppetOpened() then --��ǧ����
			local hFrame = Station.Lookup("Normal/PuppetActionBar")
			if str then --������
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
			return true --�����������ֱ�ӷ���true
		end
		return false
	end,
	puppetdistance = function(cNum, cType)
		local hPlayer = GetClientPlayer()
		if _ZMAC.IsPuppetOpened() then --��ǧ����
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
		if _ZMAC.IsPuppetOpened() then --��ǧ����
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
	--����
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
	
	jgnum = function (cNum, cType) --���Ż�������
		local WItemNum = TaiFengIsWItemNum()
		return _ZMAC_Compare(cType, WItemNum, cNum)
	end,
	pupdis = function(cNum, cType)        --ǧ�������
		local hPlayer = GetClientPlayer()
		local QianJiBian = GetNpc(hPlayer.dwBatteryID)
		if not QianJiBian then return false end
		--local Distance = m_ceil(GetCharacterDistance(hPlayer.dwID, QianJiBian.dwID)/64)
		local Distance =_ZMAC.Decimal(GetCharacterDistance(hPlayer.dwID, QianJiBian.dwID)/64)
		--Output("ǧ����:" .. cNum,Distance,_ZMAC_Compare(cType, Distance, cNum))
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
		
		--��ȡ��Χ�ڵж�Ŀ�꿴�Լ�������
		local Count = 0

		for j, v in pairs(_ZMAC_GetAllPlayer() ) do
			local k = v.dwID
			local xPlayer = v
			local Dis = GetCharacterDistance(hPlayer.dwID, k) / 64
			--Output(xPlayer.szName,Dis)
			
			local xPlayerTarget =  GetTargetHandle(xPlayer.GetTarget())
			
			if xPlayerTarget ~=nil and xPlayerTarget.szName ==hPlayer.szName  then     --��Ŀ���ڿ�����
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
		--��ȡ��Χ�ڶ��ѿ�Ŀ�������
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
		local playerNum = Count + 1 --���и����ڿ���
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
	
	
	enemynpcnum = function (str) --NPC����
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckNpcNum(str,hPlayer,'enemy')
	end,
	allynpcnum = function (str) --NPC����
		local hPlayer = GetClientPlayer()
		return _ZMAC.CheckNpcNum(str,hPlayer,'ally')
	end,
	tenemynpcnum = function (str) --NPC����
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		return _ZMAC.CheckNpcNum(str,t,'enemy')
	end,
	tallynpcnum = function (str) --NPC����
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
			
			if Npc.szName == NpcName and Npc.dwEmployer ==hPlayer.dwID then  --Npc.dwEmployerΪnpc���˵�ID
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
			
			if Npc.szName == NpcName and Npc.dwEmployer ==hPlayer.dwID then  --Npc.dwEmployerΪnpc���˵�ID
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
		--ʵ���ڳ۷������ڻ���7795������buff
		--�г۷������ʱ����3��buff,����������14071��14242,����δ֪
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
			
			if Npc.szName == NpcName and IsAlly(Npc.dwID,hPlayer.dwID) then  --Npc.dwEmployerΪnpc���˵�ID
				
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
			
			if Npc.szName == NpcName and IsAlly(t.dwID,hPlayer.dwID) then  --Npc.dwEmployerΪnpc���˵�ID
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
			
			if Npc.szName == NpcName and IsEnemy(Npc.dwID,hPlayer.dwID) then  --Npc.dwEmployerΪnpc���˵�ID
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
			
			if Npc.szName == NpcName and IsEnemy(t.dwID,hPlayer.dwID) then  --Npc.dwEmployerΪnpc���˵�ID
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' then
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' then
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' and Npc.dwEmployer ==hPlayer.dwID then
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' and Npc.dwEmployer ~=hPlayer.dwID then
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' and Npc.dwEmployer ==hPlayer.dwID then
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' and Npc.dwEmployer ~=hPlayer.dwID then
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' and IsAlly(hPlayer.dwID, Npc.dwID) then
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' and IsEnemy(hPlayer.dwID, Npc.dwID) then
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' and IsAlly(hPlayer.dwID, Npc.dwID) then
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
			if Npc and Dis <= tDis and s_sub(Npc.szName,1,4) =='����' and IsEnemy(hPlayer.dwID, Npc.dwID) then
				Counet = Counet + 1
			end
		end
		return _ZMAC_Compare(Type,Counet, tNum)
	end,

	--Ŀ��Ϊ����
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
	--ͬ��
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
	--�ж�
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
	
	
	--Ŀ������
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

	--Ŀ���Ƿ����
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
	--Ŀ������
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
	--Ŀ������
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
	--����
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
		if not _ZMAC.CheckPrepare(hPlayer,'����׷��','channel',nil) then return false end
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
	
	--CD��
	cd = function(SkillName)
		return _ZMAC.GetSkillNum(GetClientPlayer(),SkillName)<1 
	end,
	nocd = function(SkillName)
		return _ZMAC.GetSkillNum(GetClientPlayer(),SkillName)>0 
	end,

	gcd = function()
		local KungfuMount = _ZMAC.MySchoolName()
		local gcdID=605 --����
		if KungfuMount=='��Ӱʥ��' or KungfuMount=='����������' then
			gcdID=3962 --������
		elseif KungfuMount=='Ц����' then
			gcdID=5258 --��������
		end
		return _ZMAC.CheckSkillCool(gcdID)
	end,
	
	nogcd = function()
		local KungfuMount = _ZMAC.MySchoolName()
		local gcdID=605 --����
		if KungfuMount=='��Ӱʥ��' or KungfuMount=='����������' then
			gcdID=3962 --������
		elseif KungfuMount=='Ц����' then
			gcdID=5258 --��������
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
	
	cdtime = function(str)  --����cdûд
		local hPlayer = GetClientPlayer()
		local strs = _ZMAC_SplitStr2Array(str, "|")
		for _,SkillCD in ipairs(strs) do
			local Boolean,SkillName,cType,cNum=_ZMAC_SplitRelationSymbol(SkillCD,"[><=]")
			local szSkillID = _ZMAC.GetSkillIdEx(SkillName)
			local SkillLevel = hPlayer.GetSkillLevel(szSkillID)
			local _, CD, TotalCD = hPlayer.GetSkillCDProgress(szSkillID, SkillLevel)
			
			
			local gcdID=605 --����
			local KungfuMount = hPlayer.GetKungfuMount()
			if KungfuMount=='��Ӱʥ��' or KungfuMount=='����������' then
				gcdID=3962 --������
			elseif KungfuMount=='Ц����' then
				gcdID=5258 --��������
			end

			local GcdSkillLevel = hPlayer.GetSkillLevel(gcdID)
			local _, GCD, TotalGCD = hPlayer.GetSkillCDProgress(gcdID, GcdSkillLevel)
			
			if GCD== CD and TotalGCD == TotalCD then --cd��gcd��ȫ��ͬʱ����ü���û��cd����CDǿ������Ϊ0
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
		else--if tT == TARGET.NPC then             --����
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
	
	
	--״̬
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
		--if (not t) or (not IsPlayer(t.dwID)) then return false end    --ֻ����Ҳ��и߶����ԣ���Ȼ����
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


	--//�������:�����Ƿ���ͷ�
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
		if str == '���' then
			return not ZMAC_OptionFunc.buff('8391')       --8391  �ܷ�buff
		elseif str == '�浶' then
			return ZMAC_OptionFunc.buff('8391')
		elseif str == '����' or str == '��������' or str == '������' then
			return ZMAC_OptionFunc.buff('10814')
		elseif str == '����' or str == '��������' or str == '������' then
			return ZMAC_OptionFunc.buff('10815')
		elseif str == 'ѩ������' or str == '����' or str == '������' then
			return ZMAC_OptionFunc.buff('10816')
		end
	end,
	
	tpose=function(str)
		if not _ZMAC.checktarget('t') then return false end
		local hPlayer = GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if str == '���' then
			return not ZMAC_OptionFunc.tbuff('8391')       --8391  �ܷ�buff
		elseif str == '�浶' then
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
		local hd1,hd2,hd3 ={},{},{}       --3����Ƶ�����
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
		local hd1,hd2,hd3 ={},{},{}       --3����Ƶ�����
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
		local tDis1,tDis2,tDis3 =999,999,999       --3�������Ŀ��ľ���
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
		local hd1,hd2,hd3 =0,0,0      --3����Ƶ�����
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
		local tDis1,tDis2,tDis3 =0,0,0       --3�������Ŀ��ľ���
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
		local tDis1,tDis2,tDis3 =0,0,0       --3�������Ŀ��ľ���
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
		local tDis1,tDis2,tDis3 =0,0,0       --3�������Ŀ��ľ���
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
		local tDis1,tDis2,tDis3 =0,0,0       --3�������Ŀ��ľ���
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
		local tDis1,tDis2,tDis3 =0,0,0       --3�������Ŀ��ľ���
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
		local tDis1,tDis2,tDis3 =0,0,0       --3�������Ŀ��ľ���
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
	
	--����ϵ��
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
	--����β
}

_TJ={}


_TJ.buff = function(szBuffid)
	local a = {}
	local b = {}
	local c = {}
	local buffName = ""
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	if szName == "�浶" then
		return _TJ.buffid("8391")
	elseif szName == "���" then
		return _TJ.nobuffid("8391")
	elseif szName == "�܉�" then
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."-"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."-"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "-")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
	szBuffid = szBuffid.."|"--���L>5|��Ѫ<5|÷�[��|���
	szBuffid = StringReplaceW(szBuffid, " ", "")
	local pos = StringFindW(szBuffid, "|")
	while pos do
		local s = string.sub(szBuffid, 1, pos - 1)--���L>5
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
		if str =='����' then
			return _ZMAC.CheckStatus(hPlayer,'halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='����' then  
			return _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='�ɿ�' then
			return not _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid|move|vmove')
		elseif str =='��ս' then
			return _ZMAC.CheckMount(hPlayer,'��Ѫս��|������|�׽|ϴ�辭|��ˮ��|ɽ�ӽ���|̫�齣��|��Ӱʥ��|����������|Ц����|��ɽ��|������|������|�躣��|������')
		elseif str =='Զ��' then	
			return _ZMAC.CheckMount(hPlayer,'��ϼ��|���ľ�|�����ľ�|�뾭�׵�|������|���޹��|�����|�����|����|Ī��|��֪|̫����|�޷�|����')
		elseif str =='�ڹ�' then
			return _ZMAC.CheckMount(hPlayer,'�׽|ϴ�辭|��Ӱʥ��|����������|��ϼ��|���ľ�|�����ľ�|�뾭�׵�|������|���޹��|�����|����|Ī��|��֪|̫����|�޷�|����')
		elseif str =='�⹦' then
			return _ZMAC.CheckMount(hPlayer,'��Ѫս��|������|��ˮ��|ɽ�ӽ���|̫�齣��|Ц����|�����|��ɽ��|������|������|�躣��|������')
		elseif str =='����' then
			return _ZMAC.CheckMount(hPlayer,'�����ľ�|�뾭�׵�|�����|��֪|����')
		elseif str =='���' then
			return _ZMAC.CheckMount(hPlayer,'��Ѫս��|��ˮ��|ɽ�ӽ���|̫�齣��|��ϼ��|Ц����|�����|���޹��|��ɽ��|������|�׽|������|�躣��|��Ӱʥ��|���ľ�|������|����|Ī��|̫����|�޷�')	
		elseif str =='�б���' then
			--return _ZMAC_CheckBuff(hPlayer,'197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083|14352','s',false)
			
			return _TJ.buffid('197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083,14352')
			
		elseif str =='�ޱ���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�б���')
			return _TJ.nobuffid('197-538-1378-1728-11456-9744-10175-10213-200-2840-1911-1915-1919-1922-2543-2719-2726-2757-2759-2761-2830-3028-3191-3316-3468-3488-3859-4375-4423-4930-5640-5724-5789-5790-5994-6121-6471-7118-7419-7923-8210-8474-9075-9769-9864-10192-10366-10373-11376-12556-14081-14083-14352')
		elseif str =='�г�Ĭ' then
			--return _ZMAC_CheckBuff(hPlayer,'573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091','s',false)
			return _TJ.buffid('573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091')
		elseif str =='�޳�Ĭ' then	
			--return not _ZMAC.CheckStats(hPlayer,'�г�Ĭ')
			return _TJ.nobuffid('573-712-726-1549-2432-20060-18060-17962-15837-3185-3186-4053-5069-8450-9378-10283-11171-12321-14091')
		elseif str =='�з���' then
			--return _ZMAC_CheckBuff(hPlayer,'388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744','s',false)
			return _TJ.buffid('388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744')
		elseif str =='�޷���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�з���')
			return _TJ.nobuffid('388-389-390-1152-1561-2792-2793-2794-2795-2796-2797-3198-9804-9805-9806-9807-9808-9809-10486-11980-11981-12612-13744')
		elseif str =='�з���' then
			--return _ZMAC_CheckBuff(hPlayer,'445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592','s',false)
			return _TJ.buffid('445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592')
		elseif str =='�޷���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�з���')
			return _TJ.nobuffid('445-557-585-690-692-708-1473-2182-2490-17974-15837-11171-12388-573-575-712-726-4053-8450-9263-10260-9378-14091-2807-2838-3209-3227-3821-7046-7047-7417-9214-9752-10592')
		elseif str =='�з��Ṧ' then
			--return _ZMAC_CheckBuff(hPlayer,'562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246','s',false)
			return _TJ.buffid('562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246')
		elseif str =='�޷��Ṧ' then	
			--return not _ZMAC.CheckStats(hPlayer,'�з��Ṧ')
			return _TJ.nobuffid('562-1939-17105-12388-12486-2838-535-4497-8257-6074-10246')
		elseif str =='�м���' then
			return _TJ.buffid('126|2108|20799|17961|18001|16545|18203|17959|15897|15735|6739|6154|9073|9724|14644|6306|8495|13571|10118|12506|11319|11384|9810|6163|8300|6315|9506|122|9975|4339|9510|9337|3274|134|9534|6361|8291|360|367|368|384|399|684|993|996|1142|1173|1177|1547|1552|1802|2419|2447|2805|2849|2953|2983|3068|3107|3120|3171|3193|3259|3315|3447|3791|3792|4147|4245|4376|4439|4444|4575|5374|5704|5735|5744|5753|5778|5996|6090|6125|6200|6224|6240|6248|6257|6262|6264|6279|6492|6547|6616|6636|6637|7035|7054|7119|7387|7964|8265|8279|8292|8427|8650|8839|9293|9334|9544|9693|9694|9695|9696|9775|9781|9782|9803|9836|9873|9874|10014|10066|10369|11344|12530|13044|13771|14067|14105')
			--local _,_,_,_,_,aa = _ZMAC.GetReduction(GetClientPlayer())
			--return  aa >= 0.3
			
		elseif str =='�޼���' then	
			return _TJ.nobuffid('126-2108-20799-17961-18001-16545-18203-17959-15897-15735-6739-6154-9073-9724-14644-6306-8495-13571-10118-12506-11319-11384-9810-6163-8300-6315-9506-122-9975-4339-9510-9337-3274-134-9534-6361-8291-360-367-368-384-399-684-993-996-1142-1173-1177-1547-1552-1802-2419-2447-2805-2849-2953-2983-3068-3107-3120-3171-3193-3259-3315-3447-3791-3792-4147-4245-4376-4439-4444-4575-5374-5704-5735-5744-5753-5778-5996-6090-6125-6200-6224-6240-6248-6257-6262-6264-6279-6492-6547-6616-6636-6637-7035-7054-7119-7387-7964-8265-8279-8292-8427-8650-8839-9293-9334-9544-9693-9694-9695-9696-9775-9781-9782-9803-9836-9873-9874-10014-10066-10369-11344-12530-13044-13771-14067-14105')
			--local _,_,_,_,_,aa = _ZMAC.GetReduction(GetClientPlayer())
			--return aa <0.3
		elseif str =='�м���' then
			--return _ZMAC_CheckBuff(hPlayer,'315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103','s',false)
			return _TJ.buffid('315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103')
		elseif str =='�޼���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�м���')	
			return _TJ.nobuffid('315-17105-18004-9694-9175-2488-6223-6155-9514-2502-574-576-2496-2774-3195-3538-3712-4030-4370-4670-5993-7048-7050-8487-9122-9156-11199-14103')
		elseif str =='�м���' then
			--return _ZMAC_CheckBuff(hPlayer,'450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373','s',false)
			return _TJ.buffid('450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373')
		elseif str =='�޼���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�м���')	
			return _TJ.nobuffid('450-461-549-555-560-17888-18061-11262-15956-18046-17581-17897-15802-14137-10001-10861-14186-14154-11245-1097-6275-563-6374-1079-523-3466-6078-6148-6145-6258-4054-4435-9532-9507-13733-584-1534-1720-1850-2297-3115-3148-3226-3484-4297-4816-4928-6130-6191-6987-7548-7549-8299-8398-8492-9217-9777-11168-1373')			
		elseif str =='�����' then
			--return _ZMAC_CheckBuff(hPlayer,'15565|20780|22111|100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310','s',false)
			return _TJ.buffid('15565|20780|22111|100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310')
		elseif str =='�����' then	
			--return not _ZMAC.CheckStats(hPlayer,'�����')	
			return _TJ.nobuffid('15565-20780-22111-100-21202-20698-21276-20199-20666-20072-17901-17882-18189-18075-17888-12534-10118-14972-17939-18418-374-18124-17585-17905-18228-18248-16348-16448-15933-15897-15845-15621-15826-15749-15735-15083-14930-411-14644-14515-6213-14256-14080-13783-13590-13927-14247-14099-13778-412-14155-682-14105-12372-11385-11151-377-677-772-961-2830-3425-3578-855-4245-4439-6182-6219-6279-6284-6292-6314-1018-6369-7699-8265-8302-8303-9068-9107-1186-9534-10247-9934-1676-1686-1856-1862-1863-1903-2072-2544-2718-2756-2781-2840-2847-2951-3025-3026-3138-3275-3279-3376-3677-3822-3983-4033-4421-4449-4468-4672-4729-5653-5654-5725-5731-5733-5747-5754-5950-5995-6001-6015-6087-6131-6192-6247-6291-6361-6373-6459-6489-7979-8247-8293-8300-8449-8455-8458-8468-8483-8495-8716-8742-8864-9059-9294-9342-9354-9509-9510-9511-9567-9848-9855-9999-10186-10245-10258-10264-10417-10633-11077-11204-11319-11322-11361-11808-11991-12481-12559-12665-12857-13735-13742-14082-14273-14356-10130-9693-10173-11336-11335-11310')
		elseif str =='������' then
			--return _ZMAC_CheckBuff(hPlayer,'13744|160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151','s',false)
			return _TJ.buffid('13744|160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151')
		elseif str =='������' then	
			--return not _ZMAC.CheckStats(hPlayer,'������')	
			return _TJ.nobuffid('13744-160-12534-15717-13927-14099-13778-682-6182-961-9534-377-620-772-1740-3091-3425-3759-3851-6000-6213-6580-7929-8303-8371-8438-8624-9158-9835-9934-11151')
		elseif str =='������' then
			--return _ZMAC_CheckBuff(hPlayer,'203|6182|10370|12488','s',false)
			return _TJ.buffid('203|6182|10370|12488')
		elseif str =='������' then	
			--return not _ZMAC.CheckStats(hPlayer,'������')
			return _TJ.nobuffid('203-6182-10370-12488')
		elseif str =='�������' then
			--return _ZMAC_CheckBuff(hPlayer,'5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350','s',false)
			return _TJ.buffid('5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350')
		elseif str =='�������' then	
			--return not _ZMAC.CheckStats(hPlayer,'�������')
			return _TJ.nobuffid('5777-20883-21202-20667-17901-18065-10258-9294-12613-6182-6213-13927-14099-13778-14155-9934-6414-9342-384-5789-8458-6256-8864-8293-377-1186-4439-6279-4245-9999-9509-9506-10173-10618-6350')
		elseif str =='������' then
			--return _ZMAC_CheckBuff(hPlayer,'1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099','s',false)
			return _TJ.buffid('1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099')
		elseif str =='������' then	
			--return not _ZMAC.CheckStats(hPlayer,'������')
			return _TJ.nobuffid('1730-2065-15826-18071-15234-18075-18088-17585-15621-10618-6146-677-6174-6182-10014-2114-2126-3214-4619-4620-5668-5780-6298-6299-6434-8866-9736-9783-9846-10617-11201-13778-14099')
		elseif str =='�����е' then
			--return _ZMAC_CheckBuff(hPlayer,'19217|6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414','s',false) 
			return _TJ.buffid('19217|6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414')
		elseif str =='�����е' then
			--return not _ZMAC.CheckStats(hPlayer,'�����е')	
			return _TJ.nobuffid('19217-6256-21202-20667-17901-1186-12488-10618-8864-5777-19313-9509-9999-9342-9377-1686-1856-12481-5995-11077-13742-15749-15735-18065-6414')
		elseif str =='���ɽ�е'  then
			return ZMAC_OptionFunc.stats('�����е')	
			or ZMAC_OptionFunc.stats('�г�Ĭ') 
			or (ZMAC_OptionFunc.stats('�������') and ZMAC_OptionFunc.stats('�ڹ�'))
			or (ZMAC_OptionFunc.stats('�з���') and ZMAC_OptionFunc.stats('�ڹ�'))
		elseif str =='�ɽ�е' then
			--return not ZMAC_OptionFunc.stats('���ɽ�е')	
			return ZMAC_OptionFunc.stats('�����е') and  ZMAC_OptionFunc.stats('�޳�Ĭ') and (ZMAC_OptionFunc.stats('�⹦') or (ZMAC_OptionFunc.stats('�ڹ�') and ZMAC_OptionFunc.stats('�޷���') and ZMAC_OptionFunc.stats('�������')))
		elseif str =='�����'  then
			--return _ZMAC_CheckBuff(hPlayer,'19217|373|20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777','s',false)
			return _TJ.buffid('19217|373|20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777')
		elseif str =='�����'  then
			--return not _ZMAC.CheckStats(hPlayer,'�����')
			return _TJ.nobuffid('19217-373-20883-21202-20667-17901-17973-18001-18065-5995-10258-12613-4245-373-8458-9377-376-6350-5789-6256-8864-5777')
		elseif str =='������'  then
			--return _ZMAC_CheckBuff(hPlayer,'22145|8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310','s',false)
			return _TJ.buffid('22145|8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310')
		elseif str =='������'  then
			--return not _ZMAC.CheckStats(hPlayer,'������')	
			return _TJ.nobuffid('22145-8864-21202-20667-20072-2756-10245-2781-377-9934-6213-1903-1856-1686-10130-3425-4439-6279-4245-5754-5995-8265-8303-8483-9509-9693-10173-11151-11336-11361-11385-11319-11322-11335-11310')
		else	
			_ZMAC.PrintRed('MSG_SYS','stats��������:-->'..str..'\r\n')
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
		if str =='����' then
			return _ZMAC.CheckStatus(hPlayer,'halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='����' then  
			return _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid')
		elseif str =='�ɿ�' then
			return not _ZMAC.CheckStatus(hPlayer,'dash|halt|freeze|entrap|down|back|off|pull|repulsed|skid|move|vmove')
		elseif str =='��ս' then
			return _ZMAC.CheckMount(hPlayer,'��Ѫս��|������|�׽|ϴ�辭|��ˮ��|ɽ�ӽ���|̫�齣��|��Ӱʥ��|����������|Ц����|��ɽ��|������|������|�躣��|������')
		elseif str =='Զ��' then	
			return _ZMAC.CheckMount(hPlayer,'��ϼ��|���ľ�|�����ľ�|�뾭�׵�|������|���޹��|�����|�����|����|Ī��|��֪|̫����|�޷�|����')
		elseif str =='�ڹ�' then
			return _ZMAC.CheckMount(hPlayer,'�׽|ϴ�辭|��Ӱʥ��|����������|��ϼ��|���ľ�|�����ľ�|�뾭�׵�|������|���޹��|�����|����|Ī��|��֪|̫����|�޷�|����')
		elseif str =='�⹦' then
			return _ZMAC.CheckMount(hPlayer,'��Ѫս��|������|��ˮ��|ɽ�ӽ���|̫�齣��|Ц����|�����|��ɽ��|������|������|�躣��|������')
		elseif str =='����' then
			return _ZMAC.CheckMount(hPlayer,'�����ľ�|�뾭�׵�|�����|��֪|����')
		elseif str =='���' then
			return _ZMAC.CheckMount(hPlayer,'��Ѫս��|��ˮ��|ɽ�ӽ���|̫�齣��|��ϼ��|Ц����|�����|���޹��|��ɽ��|������|�׽|������|�躣��|��Ӱʥ��|���ľ�|������|����|Ī��|̫����|�޷�')	
		elseif str =='�б���' then
			--return _ZMAC_CheckBuff(hPlayer,'197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083|14352','s',false)
			
			return _TJ.tbuffid('197|538|1378|1728|11456|9744|10175|10213|200|2840|1911|1915|1919|1922|2543|2719|2726|2757|2759|2761|2830|3028|3191|3316|3468|3488|3859|4375|4423|4930|5640|5724|5789|5790|5994|6121|6471|7118|7419|7923|8210|8474|9075|9769|9864|10192|10366|10373|11376|12556|14081|14083,14352')
			
		elseif str =='�ޱ���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�б���')
			return _TJ.tnobuffid('197-538-1378-1728-11456-9744-10175-10213-200-2840-1911-1915-1919-1922-2543-2719-2726-2757-2759-2761-2830-3028-3191-3316-3468-3488-3859-4375-4423-4930-5640-5724-5789-5790-5994-6121-6471-7118-7419-7923-8210-8474-9075-9769-9864-10192-10366-10373-11376-12556-14081-14083-14352')
		elseif str =='�г�Ĭ' then
			--return _ZMAC_CheckBuff(hPlayer,'573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091','s',false)
			return _TJ.tbuffid('573|712|726|1549|2432|20060|18060|17962|15837|3185|3186|4053|5069|8450|9378|10283|11171|12321|14091')
		elseif str =='�޳�Ĭ' then	
			--return not _ZMAC.CheckStats(hPlayer,'�г�Ĭ')
			return _TJ.tnobuffid('573-712-726-1549-2432-20060-18060-17962-15837-3185-3186-4053-5069-8450-9378-10283-11171-12321-14091')
		elseif str =='�з���' then
			--return _ZMAC_CheckBuff(hPlayer,'388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744','s',false)
			return _TJ.tbuffid('388|389|390|1152|1561|2792|2793|2794|2795|2796|2797|3198|9804|9805|9806|9807|9808|9809|10486|11980|11981|12612|13744')
		elseif str =='�޷���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�з���')
			return _TJ.tnobuffid('388-389-390-1152-1561-2792-2793-2794-2795-2796-2797-3198-9804-9805-9806-9807-9808-9809-10486-11980-11981-12612-13744')
		elseif str =='�з���' then
			--return _ZMAC_CheckBuff(hPlayer,'445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592','s',false)
			return _TJ.tbuffid('445|557|585|690|692|708|1473|2182|2490|17974|15837|11171|12388|573|575|712|726|4053|8450|9263|10260|9378|14091|2807|2838|3209|3227|3821|7046|7047|7417|9214|9752|10592')
		elseif str =='�޷���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�з���')
			return _TJ.tnobuffid('445-557-585-690-692-708-1473-2182-2490-17974-15837-11171-12388-573-575-712-726-4053-8450-9263-10260-9378-14091-2807-2838-3209-3227-3821-7046-7047-7417-9214-9752-10592')
		elseif str =='�з��Ṧ' then
			--return _ZMAC_CheckBuff(hPlayer,'562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246','s',false)
			return _TJ.tbuffid('562|1939|17105|12388|12486|2838|535|4497|8257|6074|10246')
		elseif str =='�޷��Ṧ' then	
			--return not _ZMAC.CheckStats(hPlayer,'�з��Ṧ')
			return _TJ.tnobuffid('562-1939-17105-12388-12486-2838-535-4497-8257-6074-10246')
		elseif str =='�м���' then
			return _TJ.tbuffid('126|2108|20799|17961|18001|16545|18203|17959|15897|15735|6739|6154|9073|9724|14644|6306|8495|13571|10118|12506|11319|11384|9810|6163|8300|6315|9506|122|9975|4339|9510|9337|3274|134|9534|6361|8291|360|367|368|384|399|684|993|996|1142|1173|1177|1547|1552|1802|2419|2447|2805|2849|2953|2983|3068|3107|3120|3171|3193|3259|3315|3447|3791|3792|4147|4245|4376|4439|4444|4575|5374|5704|5735|5744|5753|5778|5996|6090|6125|6200|6224|6240|6248|6257|6262|6264|6279|6492|6547|6616|6636|6637|7035|7054|7119|7387|7964|8265|8279|8292|8427|8650|8839|9293|9334|9544|9693|9694|9695|9696|9775|9781|9782|9803|9836|9873|9874|10014|10066|10369|11344|12530|13044|13771|14067|14105')
			--return ZMAC_OptionFunc.tdefense('>0.299')
			
		elseif str =='�޼���' then	
			return _TJ.tnobuffid('126-2108-20799-17961-18001-16545-18203-17959-15897-15735-6739-6154-9073-9724-14644-6306-8495-13571-10118-12506-11319-11384-9810-6163-8300-6315-9506-122-9975-4339-9510-9337-3274-134-9534-6361-8291-360-367-368-384-399-684-993-996-1142-1173-1177-1547-1552-1802-2419-2447-2805-2849-2953-2983-3068-3107-3120-3171-3193-3259-3315-3447-3791-3792-4147-4245-4376-4439-4444-4575-5374-5704-5735-5744-5753-5778-5996-6090-6125-6200-6224-6240-6248-6257-6262-6264-6279-6492-6547-6616-6636-6637-7035-7054-7119-7387-7964-8265-8279-8292-8427-8650-8839-9293-9334-9544-9693-9694-9695-9696-9775-9781-9782-9803-9836-9873-9874-10014-10066-10369-11344-12530-13044-13771-14067-14105')
			--return ZMAC_OptionFunc.tdefense('<0.3')
		elseif str =='�м���' then
			--return _ZMAC_CheckBuff(hPlayer,'315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103','s',false)
			return _TJ.tbuffid('315|17105|18004|9694|9175|2488|6223|6155|9514|2502|574|576|2496|2774|3195|3538|3712|4030|4370|4670|5993|7048|7050|8487|9122|9156|11199|14103')
		elseif str =='�޼���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�м���')	
			return _TJ.tnobuffid('315-17105-18004-9694-9175-2488-6223-6155-9514-2502-574-576-2496-2774-3195-3538-3712-4030-4370-4670-5993-7048-7050-8487-9122-9156-11199-14103')
		elseif str =='�м���' then
			--return _ZMAC_CheckBuff(hPlayer,'450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373','s',false)
			return _TJ.tbuffid('450|461|549|555|560|17888|18061|11262|15956|18046|17581|17897|15802|14137|10001|10861|14186|14154|11245|1097|6275|563|6374|1079|523|3466|6078|6148|6145|6258|4054|4435|9532|9507|13733|584|1534|1720|1850|2297|3115|3148|3226|3484|4297|4816|4928|6130|6191|6987|7548|7549|8299|8398|8492|9217|9777|11168|1373')
		elseif str =='�޼���' then	
			--return not _ZMAC.CheckStats(hPlayer,'�м���')	
			return _TJ.tnobuffid('450-461-549-555-560-17888-18061-11262-15956-18046-17581-17897-15802-14137-10001-10861-14186-14154-11245-1097-6275-563-6374-1079-523-3466-6078-6148-6145-6258-4054-4435-9532-9507-13733-584-1534-1720-1850-2297-3115-3148-3226-3484-4297-4816-4928-6130-6191-6987-7548-7549-8299-8398-8492-9217-9777-11168-1373')			
		elseif str =='�����' then
			--return _ZMAC_CheckBuff(hPlayer,'15565|20780|22111|100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310','s',false)
			return _TJ.tbuffid('15565|20780|22111|100|21202|20698|21276|20199|20666|20072|17901|17882|18189|18075|17888|12534|10118|14972|17939|18418|374|18124|17585|17905|18228|18248|16348|16448|15933|15897|15845|15621|15826|15749|15735|15083|14930|411|14644|14515|6213|14256|14080|13783|13590|13927|14247|14099|13778|412|14155|682|14105|12372|11385|11151|377|677|772|961|2830|3425|3578|855|4245|4439|6182|6219|6279|6284|6292|6314|1018|6369|7699|8265|8302|8303|9068|9107|1186|9534|10247|9934|1676|1686|1856|1862|1863|1903|2072|2544|2718|2756|2781|2840|2847|2951|3025|3026|3138|3275|3279|3376|3677|3822|3983|4033|4421|4449|4468|4672|4729|5653|5654|5725|5731|5733|5747|5754|5950|5995|6001|6015|6087|6131|6192|6247|6291|6361|6373|6459|6489|7979|8247|8293|8300|8449|8455|8458|8468|8483|8495|8716|8742|8864|9059|9294|9342|9354|9509|9510|9511|9567|9848|9855|9999|10186|10245|10258|10264|10417|10633|11077|11204|11319|11322|11361|11808|11991|12481|12559|12665|12857|13735|13742|14082|14273|14356|10130|9693|10173|11336|11335|11310')
		elseif str =='�����' then	
			--return not _ZMAC.CheckStats(hPlayer,'�����')	
			return _TJ.tnobuffid('15565-20780-22111-100-21202-20698-21276-20199-20666-20072-17901-17882-18189-18075-17888-12534-10118-14972-17939-18418-374-18124-17585-17905-18228-18248-16348-16448-15933-15897-15845-15621-15826-15749-15735-15083-14930-411-14644-14515-6213-14256-14080-13783-13590-13927-14247-14099-13778-412-14155-682-14105-12372-11385-11151-377-677-772-961-2830-3425-3578-855-4245-4439-6182-6219-6279-6284-6292-6314-1018-6369-7699-8265-8302-8303-9068-9107-1186-9534-10247-9934-1676-1686-1856-1862-1863-1903-2072-2544-2718-2756-2781-2840-2847-2951-3025-3026-3138-3275-3279-3376-3677-3822-3983-4033-4421-4449-4468-4672-4729-5653-5654-5725-5731-5733-5747-5754-5950-5995-6001-6015-6087-6131-6192-6247-6291-6361-6373-6459-6489-7979-8247-8293-8300-8449-8455-8458-8468-8483-8495-8716-8742-8864-9059-9294-9342-9354-9509-9510-9511-9567-9848-9855-9999-10186-10245-10258-10264-10417-10633-11077-11204-11319-11322-11361-11808-11991-12481-12559-12665-12857-13735-13742-14082-14273-14356-10130-9693-10173-11336-11335-11310')
		elseif str =='������' then
			--return _ZMAC_CheckBuff(hPlayer,'13744|160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151','s',false)
			return _TJ.tbuffid('13744|160|12534|15717|13927|14099|13778|682|6182|961|9534|377|620|772|1740|3091|3425|3759|3851|6000|6213|6580|7929|8303|8371|8438|8624|9158|9835|9934|11151')
		elseif str =='������' then	
			--return not _ZMAC.CheckStats(hPlayer,'������')	
			return _TJ.tnobuffid('13744-160-12534-15717-13927-14099-13778-682-6182-961-9534-377-620-772-1740-3091-3425-3759-3851-6000-6213-6580-7929-8303-8371-8438-8624-9158-9835-9934-11151')
		elseif str =='������' then
			--return _ZMAC_CheckBuff(hPlayer,'203|6182|10370|12488','s',false)
			return _TJ.tbuffid('203|6182|10370|12488')
		elseif str =='������' then	
			--return not _ZMAC.CheckStats(hPlayer,'������')
			return _TJ.tnobuffid('203-6182-10370-12488')
		elseif str =='�������' then
			--return _ZMAC_CheckBuff(hPlayer,'5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350','s',false)
			return _TJ.tbuffid('5777|20883|21202|20667|17901|18065|10258|9294|12613|6182|6213|13927|14099|13778|14155|9934|6414|9342|384|5789|8458|6256|8864|8293|377|1186|4439|6279|4245|9999|9509|9506|10173|10618|6350')
		elseif str =='�������' then	
			--return not _ZMAC.CheckStats(hPlayer,'�������')
			return _TJ.tnobuffid('5777-20883-21202-20667-17901-18065-10258-9294-12613-6182-6213-13927-14099-13778-14155-9934-6414-9342-384-5789-8458-6256-8864-8293-377-1186-4439-6279-4245-9999-9509-9506-10173-10618-6350')
		elseif str =='������' then
			--return _ZMAC_CheckBuff(hPlayer,'1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099','s',false)
			return _TJ.tbuffid('1730|2065|15826|18071|15234|18075|18088|17585|15621|10618|6146|677|6174|6182|10014|2114|2126|3214|4619|4620|5668|5780|6298|6299|6434|8866|9736|9783|9846|10617|11201|13778|14099')
		elseif str =='������' then	
			--return not _ZMAC.CheckStats(hPlayer,'������')
			return _TJ.tnobuffid('1730-2065-15826-18071-15234-18075-18088-17585-15621-10618-6146-677-6174-6182-10014-2114-2126-3214-4619-4620-5668-5780-6298-6299-6434-8866-9736-9783-9846-10617-11201-13778-14099')
		elseif str =='�����е' then
			--return _ZMAC_CheckBuff(hPlayer,'19217|6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414','s',false) 
			return _TJ.tbuffid('19217|6256|21202|20667|17901|1186|12488|10618|8864|5777|19313|9509|9999|9342|9377|1686|1856|12481|5995|11077|13742|15749|15735|18065|6414')
		elseif str =='�����е' then
			--return not _ZMAC.CheckStats(hPlayer,'�����е')	
			return _TJ.tnobuffid('19217-6256-21202-20667-17901-1186-12488-10618-8864-5777-19313-9509-9999-9342-9377-1686-1856-12481-5995-11077-13742-15749-15735-18065-6414')
		elseif str =='���ɽ�е'  then
			return ZMAC_OptionFunc.tstats('�����е')	
			or ZMAC_OptionFunc.tstats('�г�Ĭ') 
			or (ZMAC_OptionFunc.tstats('�������') and ZMAC_OptionFunc.tstats('�ڹ�'))
			or (ZMAC_OptionFunc.tstats('�з���') and ZMAC_OptionFunc.tstats('�ڹ�'))
		elseif str =='�ɽ�е' then
			--return not ZMAC_OptionFunc.tstats('���ɽ�е')	
			return ZMAC_OptionFunc.tstats('�����е') and  ZMAC_OptionFunc.tstats('�޳�Ĭ') and (ZMAC_OptionFunc.tstats('�⹦') or (ZMAC_OptionFunc.tstats('�ڹ�') and ZMAC_OptionFunc.tstats('�޷���') and ZMAC_OptionFunc.tstats('�������')))		
		elseif str =='�����'  then
			--return _ZMAC_CheckBuff(hPlayer,'19217|373|20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777','s',false)
			return _TJ.tbuffid('19217|373|20883|21202|20667|17901|17973|18001|18065|5995|10258|12613|4245|373|8458|9377|376|6350|5789|6256|8864|5777')
		elseif str =='�����'  then
			--return not _ZMAC.CheckStats(hPlayer,'�����')
			return _TJ.tnobuffid('19217-373-20883-21202-20667-17901-17973-18001-18065-5995-10258-12613-4245-373-8458-9377-376-6350-5789-6256-8864-5777')
		elseif str =='������'  then
			--return _ZMAC_CheckBuff(hPlayer,'22145|8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310','s',false)
			return _TJ.tbuffid('22145|8864|21202|20667|20072|2756|10245|2781|377|9934|6213|1903|1856|1686|10130|3425|4439|6279|4245|5754|5995|8265|8303|8483|9509|9693|10173|11151|11336|11361|11385|11319|11322|11335|11310')
		elseif str =='������'  then
			--return not _ZMAC.CheckStats(hPlayer,'������')	
			return _TJ.tnobuffid('22145-8864-21202-20667-20072-2756-10245-2781-377-9934-6213-1903-1856-1686-10130-3425-4439-6279-4245-5754-5995-8265-8303-8483-9509-9693-10173-11151-11336-11361-11385-11319-11322-11335-11310')
		else	
			_ZMAC.PrintRed('MSG_SYS','stats��������:-->'..str..'\r\n')
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
		_ZMAC.PrintRed('���ܴ��������š����š��ֺ��м�δд�����������')
		return false
	end
	if not ZMAC_OptionFunc[pOption] then
		if _ZMAC_OPtionDict[pOption] then
			pOption = _ZMAC_OPtionDict[pOption] 
		else
			_ZMAC.PrintRed('�޴˲�����'.. pOption)
			return false
		end
	end

	if pOption =='rtime' then --ʱ�������-|��ͻ  ֱ�ӷ���
		return ZMAC_OptionFunc[pOption]()
	end
	if  pStr==nil and cType==nil then --�����3����������˲���Ϊxxx>1��д��������Ҫ�ж�-|
		return ZMAC_OptionFunc[pOption]()
	end
	
	if  pStr~=nil and cType~=nil then --�����3����������˲���Ϊxxx>1��д��������Ҫ�ж�-|
		return ZMAC_OptionFunc[pOption](pStr,cType)
	end
	
	--if pStr ~= nil and cType == nil  ,ֻ��һ��pStr����ʱ���ж��Ƿ� - |
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
local function TestCondition(szCondition)	--�l��1,(�l��2;�l��3),�l��4,(�l��5;�l��6)
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
_ZMAC.ChannelProtect = true     --��������
_ZMAC.ConfigProtect = true      --Config����
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

ZMAC.PetStatus = '������'

function Cast(szContent,pSelfOnSkill)  
	local szCondition, szSkill = GetCondition(szContent)
	
	local szSelfOnSkill =false
	--if selfFlag ~= nil then szSelfOnSkill = selfFlag end  --selfFlag:��Cast����ѭ�������ܵ���$�������ж�������Ч��������Ҫ�Ӹ�����
	
	local nEnd = StringFindW(szSkill, ",")
	while nEnd do
		local s = string.sub(szSkill, 1, nEnd - 1)
		Cast("["..szCondition.."]"..s)
		szSkill = string.sub(szSkill, nEnd + 1, -1)
		nEnd = StringFindW(szSkill, ",")
	end
	
	if not ConfigFlag then return SKILL_RESULT_CODE.FAILED end  --����false�ᵼ��GetMacroFunction()����ѭ�����Ӷ����º��޷���������ִ��
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
				if szSkill == "����" then
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
				if szSkill == "����" then
					dwID = 3360
				elseif szSkill == "ֹͣ" then
					dwID = 3382
				elseif szSkill == "������̬" then
					dwID = 3368
				elseif szSkill == "������̬" then
					dwID = 3369
				elseif szSkill == "��ɲ��̬" then
					dwID = 3370
				end
				if not WY.IsCD(dwID, dwLevel) then
					_ZMAC.UseSkill(dwID)
					return SKILL_RESULT_CODE.FAILED
				end
			end
		end
		local bPrePare, dwIDx, dwLevelx, fPx = GetClientPlayer().GetOTActionState()
		
		if bProtectChannel == true  and  (bPrePare~= 0  or GetTickCount() - WY.nLastOtaTime < 50)  and szSkill~='�ж϶���' and szSkill~='�ͷ�����' then -- 
			return SKILL_RESULT_CODE.FAILED
		end

		if _ZMAC.FakeSkillList[szSkill]  then	
			return  _ZMAC.ExcuteFakeCommand(szSkill)
		end
		
		if szSkill == '��Ӱ' then
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
				if Skill222 and Skill222.UITestCast(GetClientPlayer().dwID, IsSkillCastMyself(Skill222)) and (not s_find(Table_GetSkillDesc(v,GetClientPlayer().GetSkillLevel(v)),'��ʽ��ɾ��')) then
					
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
		
		
		
		if  s_find(Table_GetSkillDesc(dwID,dwLevel),'��ʽ��ɾ��') then 
			return SKILL_RESULT_CODE.FAILED
		end

		FireUIEvent("HELP_EVENT","OnUseSkill",dwID,dwLevel)
		--FireHelpEvent("OnUseSkill", _ARG_0_, 1)
		FireUIEvent("ON_RLCMD","stop local origin sfx")
		--rlcmd("stop local origin sfx")
		
		local skill = GetSkill(dwID, dwLevel)
		
		local IsCanUseSkill, IsChannelSkill = _ZMAC.CanUseSkill(dwID)
		--Output(dwID,Table_GetSkillName(dwID, 1),IsCanUseSkill)
		--2022.6.12,�˴���BUG����GCD�ڼ䣬���ܼ��ܻ��ж�Ϊtrue�����ǳ����ж�Ϊfalse���ᵼ�´�ʱ�����ͷź������λ�ÿ���Ķ������ܣ�
		--[[���磺/cast ������
				  /cast �춷��
		--�����]] 
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
	--if selfFlag ~= nil then szSelfOnSkill = selfFlag end  --selfFlag:��Cast����ѭ�������ܵ���$�������ж�������Ч��������Ҫ�Ӹ�����
	
	local nEnd = StringFindW(szSkill, ",")
	while nEnd do
		local s = string.sub(szSkill, 1, nEnd - 1)
		Cast("["..szCondition.."]"..s)
		szSkill = string.sub(szSkill, nEnd + 1, -1)
		nEnd = StringFindW(szSkill, ",")
	end
	
	if not ConfigFlag then return SKILL_RESULT_CODE.FAILED end  --����false�ᵼ��GetMacroFunction()����ѭ�����Ӷ����º��޷���������ִ��
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
				if szSkill == "����" then
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
				if szSkill == "����" then
					dwID = 3360
				elseif szSkill == "ֹͣ" then
					dwID = 3382
				elseif szSkill == "������̬" then
					dwID = 3368
				elseif szSkill == "������̬" then
					dwID = 3369
				elseif szSkill == "��ɲ��̬" then
					dwID = 3370
				end
				if not WY.IsCD(dwID, dwLevel) then
					_ZMAC.UseSkill(dwID)
					return SKILL_RESULT_CODE.FAILED
				end
			end
		end
		local bPrePare, dwIDx, dwLevelx, fPx = GetClientPlayer().GetOTActionState()
		
		if bProtectChannel == true  and  (bPrePare~= 0  or GetTickCount() - WY.nLastOtaTime < 50)  and szSkill~='�ж϶���' and szSkill~='�ͷ�����' then -- 
			return SKILL_RESULT_CODE.FAILED
		end

		if _ZMAC.FakeSkillList[szSkill]  then	
			return  _ZMAC.ExcuteFakeCommand(szSkill)
		end
		
		if szSkill == '��Ӱ' then
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
				if Skill222 and Skill222.UITestCast(GetClientPlayer().dwID, IsSkillCastMyself(Skill222)) and (not s_find(Table_GetSkillDesc(v,GetClientPlayer().GetSkillLevel(v)),'��ʽ��ɾ��')) then
					
					
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
		
		if  s_find(Table_GetSkillDesc(dwID,dwLevel),'��ʽ��ɾ��') then 
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
	
	--if szSkillID==28594 then return end   --���̲������ͷ�BUG���»�
	
	local hPlayer = GetClientPlayer()
	local dwType, dwID = hPlayer.GetTarget()
	-- if dwType and dwType == TARGET.PLAYER then --������ͷ���.����
		-- return
	-- end
	local hTarget = GetTargetHandle(dwType, dwID)        
	-- if not hTarget then return false end           --youbug������д�ᵼ����Ŀ��ʱ���ͷ��Ṧ�ȼ���
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
		elseif hSkill.bHoardSkill then            --�ܲؼ��ܣ�
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
--/cast GameSkill��Self
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
		--_ZMAC_SelTarget(GetClientPlayer().dwID)  --2021.9.19 ���д�$��/castEx�Ῠ�٣���������Ϊ_ZMAC_SelTarget()�����ޱ���������Һ�npc���£�Ч�ʼ���
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
	if cmd=='���ص�¼' then
		ReInitUI(1)
	elseif cmd == '���»ޡ���' then	
		OnUseSkill(28594, 28594 * (28594 % 10 + 1))  
		return SKILL_RESULT_CODE.FAILED
		
	elseif cmd == '���»�һ�μ�' then	
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
	elseif cmd == '���»޶��μ�' then	
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
	elseif cmd == '���»����μ�' then	
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
	elseif cmd == 'ȫ��ת��' then
		_ZMAC.SelcectDyingEnemy()
		return SKILL_RESULT_CODE.FAILED
	elseif 	cmd == '�Զ����' then
		_ZMAC.AutoHunDeng()
		return SKILL_RESULT_CODE.FAILED	
	elseif 	cmd == 'ȫ�ִ��' then
		_ZMAC.GlobalBroken()
		return SKILL_RESULT_CODE.FAILED		
	elseif 	cmd == 'ȫ�ֶ���' then
		_ZMAC.GlobalBrokenHealer()
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == 'ȫ��Ⱥ��' then
		_ZMAC.SelectGatherEnemy()
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == 'ȫ������' then
		_ZMAC.SelectDyingParty()
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == 'ȫ�־���' then
		_ZMAC.GlobalJuedou()
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == '���ǡ���' then
		local x1,y1,z1 = GetClientPlayer().nX,GetClientPlayer().nY,GetClientPlayer().nZ
		Output(x1,y1,z1)
		local ret = _ZMAC.UseSkill(17587)
		
		-- if ret ~= SKILL_RESULT_CODE.SUCCESS then  --ret��׼
			-- ret = _ZMAC.UseSkill(17588)
		-- end
		_ZMAC.DelayCall(100,function()
			local x2,y2,z2 = GetClientPlayer().nX,GetClientPlayer().nY,GetClientPlayer().nZ
			if x2==x1 then
				_ZMAC.UseSkill(17588)
			end
		end)
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == 'ȫ��ʴ��' then
		_ZMAC.GlobalShixinHealer()
		return SKILL_RESULT_CODE.FAILED	
	elseif cmd == '�ж϶���' or cmd == '����Լ�' then
		--local bPrePare, dwID, dwLevel, fP = hPlayer.GetSkillOTActionState()
		local hPlayer = GetClientPlayer()
		local retxxx,bPrePare, dwID, dwLevel, fP = pcall(hPlayer.GetSkillOTActionState)
		if retxxx ==false then --Ե��
			bPrePare, dwID, dwLevel, fP = GetClientPlayer().GetSkillPrepareState()   
			if bPrePare==false then bPrePare =0 end
		end
		if bPrePare >0 then
			hPlayer.StopCurrentAction()
		end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == 'ִֹͣ��' then
		--local bPrePare, dwID, dwLevel, fP = hPlayer.GetSkillOTActionState()
		local retxxx,bPrePare, dwID, dwLevel, fP = pcall(hPlayer.GetSkillOTActionState)
		if retxxx ==false then --Ե��
			bPrePare, dwID, dwLevel, fP = GetClientPlayer().GetSkillPrepareState()   
			if bPrePare==false then bPrePare =0 end
		end
		if bPrePare == 1 then
			hPlayer.StopCurrentAction()
		end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == 'ֹͣ�ƶ�' then
		--Camera_EnableControl(CONTROL_FORWARD, false)
		--MoveForwardStop()
		--Camera_EnableControl(CONTROL_BACKWARD, false)
		--MoveBackwardStop()
		
		MoveAction_StopAll()
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '���Ŀ��' then
		local hPlayer=GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if (not t  or t ==hPlayer ) then return SKILL_RESULT_CODE.FAILED end
		local angle= GetLogicDirection(t.nX - hPlayer.nX, t.nY - hPlayer.nY)
		TurnTo(angle)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '����Ŀ��' then
		local hPlayer=GetClientPlayer()
		local t = GetTargetHandle(hPlayer.GetTarget())
		if not t then return end
		local backangle= GetLogicDirection(hPlayer.nX-t.nX ,hPlayer.nY- t.nY )
		TurnTo(backangle)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '��ǰ�ƶ�' then
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		Cast('ֹͣ�ƶ�')
		Camera_EnableControl(CONTROL_FORWARD, true)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '����ƶ�' then
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		Cast('ֹͣ�ƶ�')
		Camera_EnableControl(CONTROL_BACKWARD, true)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '�Զ��Ʊ�' then
		if not GetTargetHandle(GetClientPlayer().GetTarget()) then Camera_EnableControl(CONTROL_FORWARD, false) end
		if ZMAC_OptionFunc.tnodead() and ZMAC_OptionFunc.nobuff('��η����-���ɾ���-����-����-ϼ����ʯ') and ZMAC_OptionFunc.tdistance('30','<') then
			Cast('���Ŀ��')
			Cast('����Ŀ��')
			Cast('[tdistance<2,trange,nobuff:������ɢ] ��ǰ�ƶ�')
			Cast('[tdistance<0.9,tnorange] ֹͣ�ƶ�')
		end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == 'ѡ���Լ�' then
		_ZMAC_SelTarget(GetClientPlayer().dwID)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '�Ṧ���' then
		Cast('ӭ�����')
		Cast('������ʤ')
		Cast('��̨���')
		Cast('����')
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '��ħ' then 
		_ZMAC.CancelBuff(4439)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '�ƶ�' then
		_ZMAC.CancelBuff(8300)
		_ZMAC.CancelBuff(8265)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '�Ʊ�' then
		_ZMAC.CancelBuff(8279)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '����' then
		_ZMAC.CancelBuff(244)
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '����Ŀ��' then
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		AutoMoveToTarget(GetClientPlayer().GetTarget())
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == 'С�Ṧ' then
		return _ZMAC.UseXiaoQingGong()
	elseif cmd == '����' then
		Output('���Գɹ�')
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '��' then
		Jump()
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '�����Ṧ' or cmd == '��ǰ�Ṧ' or cmd == '����Ṧ' or cmd == '��ǰ���Ṧ' or cmd == '������Ṧ' then
		return _ZMAC.AppointQingGong(cmd)
	elseif cmd == '���޹�' then
		
		-- local hPlayer = GetClientPlayer()
		-- local szSkillID = 5354 --���޹��ǲ���֮���޷�������ȥ���Ž����޹���
		-- local SkillLevel = hPlayer.GetSkillLevel(szSkillID)
		-- if SkillLevel < 1 then SkillLevel = 1 end
		-- local Skill = GetSkill(szSkillID, SkillLevel)
		-- if Skill.UITestCast(hPlayer.dwID, IsSkillCastMyself(Skill)) then
			_ZMAC.ExcuteRealCommand(5260) --�����޹�
			GetControlPlayer().CastHoardSkill()
		--end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '�ͷ�����' then
		-- local hPlayer = GetClientPlayer()
		-- local bPrepare ,_,_,_ = _ZMAC.GetOta(hPlayer)
		-- Output(bPrepare,tonumber(bPrePare) ==9)
		-- if bPrePare ==9 then
			GetControlPlayer().CastHoardSkill()
		--end
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '������ǰ' then	
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		local xxx =5505
		OnUseSkill(xxx, xxx * (xxx % 10 + 1))  
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '�����к�' then	
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		local xxx =5506
		OnUseSkill(xxx, xxx * (xxx % 10 + 1))  
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '��������' then	
		local bPrePareX,_,_,_ = GetClientPlayer().GetOTActionState()
		if bPrePareX~=0 then return SKILL_RESULT_CODE.FAILED end
		GetControlPlayer().CastHoardSkill()
		local xxx =5507
		OnUseSkill(xxx, xxx * (xxx % 10 + 1))  
		return SKILL_RESULT_CODE.FAILED
	elseif cmd == '��������' then	
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
	�������������/ROLL ? ����/ROLL HELP����֧����Ӣ�ģ�HELP֧�ִ�С����ϣ���Ժ����еĺ�����yһ���ώ�����
	--]]
	--
	local lowRollNumber = string.lower(szRollNumber)
	if lowRollNumber == "help" or lowRollNumber == "?" or lowRollNumber == "��" then
		OutputMessage("MSG_SYS", tHelp["roll"] .. "\n")
		return
	end
	--�����Y��
	local nDefaultMin, nDefaultMax = 1, 100

	if not szRollNumber or szRollNumber == "" then							--�]�Ѕ���
		RemoteCallToServer("ClientNormalRoll", nDefaultMin, nDefaultMax)
		return
	end

	local szRolllow, szRollHigh = szRollNumber:match("^%s*(%d+)%s*(%d*)%s*$")

	if not szRolllow or szRolllow == "" then								--�]�Ѕ���
		RemoteCallToServer("ClientNormalRoll", nDefaultMin, nDefaultMax)
		return
	end

	if not szRollHigh or szRollHigh == "" then								--�Ƿ��еڶ�������
		szRollHigh = szRolllow
		szRolllow = tostring(nDefaultMin)
	end

	local nRolllow = tonumber(szRolllow:sub(1,5))
	local nRollHigh = tonumber(szRollHigh:sub(1,5))

	if nRolllow and nRollHigh and nRolllow < nRollHigh then				--�ڶ��������Ƿ�Ϸ�
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
	OutputMessage("MSG_SYS", "[��ʾ] " .. tostring(szMessage) .. "\n")
	OutputMessage("MSG_ANNOUNCE_YELLOW", "[��ʾ] " .. tostring(szMessage))
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
	elseif szContent == "��������" then
		bProtectChannel = true
	elseif szContent == "����������" then
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
--С�Ṧ
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



--����ְҵ�Ṧ
_ZMAC.AppointQingGong=function(pType)
	local hPlayer = GetClientPlayer()
	local ret =nil 
	
	local tForceName = GetForceTitle(hPlayer.dwForceID)
	local QingGongIDs={}
	local tHeight = 20
	
	if tForceName == '����' then
		QingGongIDs ={18633,3970} --�ùⲽ
	elseif tForceName == '����' then
		--[[
		if ZMAC_OptionFunc.haveskill('���') and ZMAC_OptionFunc.num('Ԧ��ҷ�>0') then
			--OnUseSkill(19984, 19984 * (19984 % 10 + 1))  --ԭ����λ�ƽ��
			QingGongIDs ={21772} --	����µ�[Ԧ��ҷ�]
			tHeight = 20
		else
			OnUseSkill(20949, 20949 * (20949 % 10 + 1))     --20949Ϊ�ﻪ���¡�����,��ֹ��Ϊ��һ���ﻯ��û���������µ��޷��ͷ�
			QingGongIDs ={20049} --�ﻪ����	
			tHeight = 30
		end
		--]]
		
		OnUseSkill(20949, 20949 * (20949 % 10 + 1))     --20949Ϊ�ﻪ���¡�����,��ֹ��Ϊ��һ���ﻯ��û���������µ��޷��ͷ�
		QingGongIDs ={20049} --�ﻪ����	
		tHeight = 30
		
	elseif tForceName == '����' then
		QingGongIDs ={13424} --����
	elseif tForceName == '����' then
		OnUseSkill(3119, 3119 * (3119 % 10 + 1))  --[����̿ա��Ϳ�]319
		QingGongIDs ={3120} --[����̿ա�����]3120   
		tHeight = 30
	elseif tForceName == '����' then
		QingGongIDs ={18604} --ǧ��׹
	elseif tForceName == '��ѩ' then
		QingGongIDs ={22614,22616} --�·��̤
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
			if     pType == '�����Ṧ' then
				ret = CastSkillXYZ(QingGongID, 1, hPlayer.nX, hPlayer.nY, hPlayer.nZ + 494 * (iii-0.5))
			elseif pType == '��ǰ�Ṧ' then
				local nFace =  math.pi /180 * hPlayer.nFaceDirection / 256 * 360
				local y = hPlayer.nY + (iii-1) * 64 * math.sin(nFace)
				local x = hPlayer.nX + (iii-1) * 64 * math.cos(nFace)
				ret = CastSkillXYZ(QingGongID, 1, x,y, hPlayer.nZ+1)
			elseif pType == '����Ṧ' then
				local nBackFaceDirection = hPlayer.nFaceDirection -127.5
				if nBackFaceDirection<0 then nBackFaceDirection = nBackFaceDirection+255 end
				local nFace =  math.pi /180 * nBackFaceDirection / 256 * 360
				local y = hPlayer.nY + (iii-1) * 64 * math.sin(nFace)
				local x = hPlayer.nX + (iii-1) * 64 * math.cos(nFace)
				ret = CastSkillXYZ(QingGongID, 1, x,y, hPlayer.nZ+1)
			elseif pType == '��ǰ���Ṧ' then
				local nFace =  math.pi /180 * hPlayer.nFaceDirection / 256 * 360
				local y = hPlayer.nY + (iii-1) * 64 * math.sin(nFace)
				local x = hPlayer.nX + (iii-1) * 64 * math.cos(nFace)
				ret = CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * (iii-0.5))
			elseif pType == '������Ṧ' then
				iii = iii/(2^(1/2))          --ȡֱ�Ǳ߳�
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

--ȫ��Ⱥ��
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
			local tmpMostEnemyNumber = _ZMAC.GetEnemyPlayerNum(6.1,xPlayer)   --��Ŀ��6���ڵ�������
			if Dis <= tDis  and tmpMostEnemyNumber>= MostEnemyNumber then  
				nSelectWho = xPlayer
				MostEnemyNumber = tmpMostEnemyNumber
			end
		end
	end
	
	if nSelectWho and nSelectWho~= GetTargetHandle(hPlayer.GetTarget())  then
		OutputMessage("MSG_SYS"," ѡ��Ⱥ��Ŀ�꣺"..nSelectWho.szName.. ' | Ŀ��6�߷�Χ������:'..MostEnemyNumber .."\n")
		_ZMAC_SelTarget(nSelectWho.dwID)
	else
		--OutputMessage("MSG_SYS"," �ޱ��ŵж�Ŀ�ꡣ\n")
	end

end
--���Ŀ��
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
--����Ŀ��
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
--����
local function CancelDQ()
	local player = GetClientPlayer()
	local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid
	local nCount = player.GetBuffCount()
	for i = 1, nCount, 1 do
		dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = player.GetBuff(i - 1)
		if dwID and (dwID == 8300) then	--�܉�
			player.CancelBuff(nIndex)
			break
		end
	end
end
--��ħ
local function CancelTMT()
	local player = GetClientPlayer()
	local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid
	local nCount = player.GetBuffCount()
	for i = 1, nCount, 1 do
		dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = player.GetBuff(i - 1)
		if dwID and (dwID == 4439 or dwID == 3973 or dwID == 6279) then	--؝ħ�w
			player.CancelBuff(nIndex)
			break
		end
	end
end
--����
local function CancelQY()
	local player = GetClientPlayer()
	local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid
	local nCount = player.GetBuffCount()
	for i = 1, nCount, 1 do
		dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = player.GetBuff(i - 1)
		if dwID and dwID == 244 then	--�T�R
			player.CancelBuff(nIndex)
			break
		end
	end
end
--�Զ����
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
	if t_len(hdlist) + _ZMAC.GetSkillNum(hPlayer,'���ŷɹ�') <3 then return end
	
	local tHeight = 25
	if ZMAC_OptionFunc.noskill('�����Ź�') ==true then tHeight = 20 end

	--if ZMAC_OptionFunc.nomiji('���ŷɹ��洫��ҳ') then tHeight = tHeight-2 end
	--if ZMAC_OptionFunc.nomiji('���ŷɹ��洫��ƪ') then tHeight = tHeight-3 end
	
	local QingGongID = 24378
	
	if t_len(hdlist)==0 then  --���û��,��ֱ�����Լ�����󷽶����ͷ�һ����
		
		local ZuohouDirection = hPlayer.nFaceDirection +256/3
		if ZuohouDirection>256 then 
			ZuohouDirection = ZuohouDirection%256
		elseif ZuohouDirection<0 then
			ZuohouDirection = ZuohouDirection+256
		end

		local nFace =  math.pi /180 * ZuohouDirection / 256 * 360
		
		local y = hPlayer.nY + (tHeight-1) * 64 * math.sin(nFace)
		local x = hPlayer.nX + (tHeight-1) * 64 * math.cos(nFace)
		CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * (tHeight-0.5))   --����Ϸ�
	elseif t_len(hdlist)==1 then
		--��һ����:
		--�ж�����Ŀ��,��Ŀ����Ŀ��λ���ͷ�120��ǵĵ�
		--��Ŀ����������ת120����ͷŵ�
		local t = GetTargetHandle(hPlayer.GetTarget())
		local xPlayer = t or GetClientPlayer()
		local hd1 = hdlist['hd1'] or hdlist['hd2'] or hdlist['hd3']

		--�Ʋ��Ǻ��Լ��ص��ĵ�
		if hd1[1]~=GetClientPlayer().nX and hd1[2]~=GetClientPlayer().nY then

			local Direction= GetLogicDirection( hd1[1] - xPlayer.nX , hd1[2] - xPlayer.nY)+256/3 --��ʱ��ת120��
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
		
		--������ص��ƣ���ֱ������ͷ�
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
			CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * (tHeight-0.5))   --���
		end
		
		
	elseif t_len(hdlist)==2 then
		--��������
		--������ʼн��ͷŵ�,ͬ���ж��Ƿ���Ŀ��,��Ŀ����Ҫ��Ŀ����ȥ
		
		if ZMAC_OptionFunc.num('���ǿ�Ѩ')==0 then return end
		
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
		
		--�к������ص��ĵ���û��Ŀ��,��ֱ������ǰ����
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
				--�˴��ж���Ҫ��������Ʊ�����ǰ�����Ƶľ������25�ߣ�������еƺ��Լ��ص�����ʱ�ͷž��뱾��Ҫ�����Լ�����С��25�ߣ����޷��õ���Ч��Ŀ���
				--���Խ��������Ƹ�Ϊ�˴���15��С��50��
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

		--����1,������˲������Ƶ�ֱ����,�����ͷ�
		--����2,�����������������ڵ�ֱ����,�����������ͷ�,�����һ�ֳ�����
		local angle =  m_abs(Direction-Direction1)
		if angle <256/3 and angle>10 then   --��С��256/3,�������ͬһ��������,��Ҫ+256/2,������������
			Direction = Direction +256/2
			if Direction>256 then 
				Direction = Direction%256
			elseif Direction<0 then
				Direction = Direction+256
			end
		elseif angle<=10 then
			--local dis1 = math.sqrt(math.pow((y2-y1),2)+math.pow((x2-x1),2))
			--local dis2 = math.sqrt(math.pow((y2-y1),2)+math.pow((x2-x1),2))
			--�ɿ������Ƶƴ���,��ֹһ�ֳ�����
	
		end
		
		local nFace =  math.pi /180 * Direction / 256 * 360
		for i=50,1,-1 do
			local y = xPlayer.nY + i * 64 * math.sin(nFace)
			local x = xPlayer.nX + i * 64 * math.cos(nFace)
			
			local S_1_2_xPlayer = Calc_TriAngleArea({hd1[1],hd1[2]},{hd2[1],hd2[2]},{xPlayer.nX,xPlayer.nY})
			local S_newPoint_2_xPlayer = Calc_TriAngleArea({x,y},{hd2[1],hd2[2]},{xPlayer.nX,xPlayer.nY})
			local S_newPoint_1_xPlayer = Calc_TriAngleArea({x,y},{hd1[1],hd1[2]},{xPlayer.nX,xPlayer.nY})
			local S_newPoint_1_2 = Calc_TriAngleArea({x,y},{hd1[1],hd1[2]},{hd2[1],hd2[2]})
			--��ѡ�ĵ��ͷź�,������סĿ����ͷ�
			if S_newPoint_1_2 == (S_1_2_xPlayer+S_newPoint_2_xPlayer+S_newPoint_1_xPlayer) then 
				local ret = CastSkillXYZ(QingGongID, 1, x, y, hPlayer.nZ + 494 * i) 
				if ret == SKILL_RESULT_CODE.SUCCESS then break end
			end
		end
		
		
		--]=]
	elseif t_len(hdlist)==3 then
		--��������,�ж�����Ŀ��
		--��Ŀ�겻���κζ���
		--��Ŀ����ѡ����ʵĵ�,�Ƶƹ�ȥ�ѵ�����ס(ĿǰĬ��ѡ��������Ŀ��н�����������֮��ĵ�)
		local xPlayer = GetTargetHandle(hPlayer.GetTarget())
		if (not xPlayer) or xPlayer == GetClientPlayer() then return end      --��Ŀ��/Ŀ�����Լ�ʱ���Ƶ�
		
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
		if retttt then return end                            --Ŀ���Ѿ��ڻ�����ʱ���Ƶ�
		local x0 , y0 = hPlayer.nX , hPlayer.nY
		local r = tHeight-1

		local LargestS = 0
		local YidengSkillID = 0   
		local FinalyX,FinalyY = 0,0
		
		--��ʱ����Ȧ��ѭ��,�������Ӧ��Ȧ���������,�˴���������
		--ѭ��hd1
		for angle=0,360,1 do
			local xX = x0   +   r*64   *   math.cos(angle   *   3.14   /180   )  
			local yY = y0   +   r*64   *   math.sin(angle   *   3.14   /180   )  
			local isInTriangle,S = _ZMAC.IsInTriAngle(xPlayer.nX,xPlayer.nY,xX,yY,hd2.nX,hd2.nY,hd3.nX,hd3.nY)
			if isInTriangle and S>LargestS 
			and _ZMAC.GetPointDis(xX,yY,hd3.nX,hd3.nY) <50  and _ZMAC.GetPointDis(xX,yY,hd3.nX,hd3.nY)>25
			and _ZMAC.GetPointDis(xX,yY,hd2.nX,hd2.nY) <50 and _ZMAC.GetPointDis(xX,yY,hd2.nX,hd2.nY)>25
			and _ZMAC.GetPointDis(hd3.nX,hd3.nY,hd2.nX,hd2.nY) <50 then
				YidengSkillID =24858 --һ
				FinalyX = xX
				FinalyY = yY
			end
			
		end
		
		--ѭ��hd2
		for angle=0,360,1 do
			local xX = x0   +   r*64   *   math.cos(angle   *   3.14   /180   )  
			local yY = y0   +   r*64   *   math.sin(angle   *   3.14   /180   )  
			local isInTriangle,S = _ZMAC.IsInTriAngle(xPlayer.nX,xPlayer.nY,xX,yY,hd1.nX,hd1.nY,hd3.nX,hd3.nY)
			if isInTriangle and S>LargestS 
			and _ZMAC.GetPointDis(xX,yY,hd1.nX,hd1.nY) <50  and _ZMAC.GetPointDis(xX,yY,hd1.nX,hd1.nY) >25
			and _ZMAC.GetPointDis(xX,yY,hd3.nX,hd3.nY) <50 and _ZMAC.GetPointDis(xX,yY,hd3.nX,hd3.nY) >25
			and _ZMAC.GetPointDis(hd1.nX,hd1.nY,hd3.nX,hd3.nY) <50
			then
				YidengSkillID =24859 --��
				FinalyX = xX
				FinalyY = yY
			end
			
		end
		--ѭ��hd3
		for angle=0,360,1 do
			local xX = x0   +   r*64   *   math.cos(angle   *   3.14   /180   )  
			local yY = y0   +   r*64   *   math.sin(angle   *   3.14   /180   )  
			local isInTriangle,S = _ZMAC.IsInTriAngle(xPlayer.nX,xPlayer.nY,xX,yY,hd1.nX,hd1.nY,hd2.nX,hd2.nY)
			if isInTriangle and S>LargestS 
			and _ZMAC.GetPointDis(xX,yY,hd1.nX,hd1.nY) <50  and _ZMAC.GetPointDis(xX,yY,hd1.nX,hd1.nY) >25
			and _ZMAC.GetPointDis(xX,yY,hd2.nX,hd2.nY) <50 and _ZMAC.GetPointDis(xX,yY,hd2.nX,hd2.nY) >25
			and _ZMAC.GetPointDis(hd1.nX,hd1.nY,hd2.nX,hd2.nY) <50 then
				YidengSkillID =24860 --�ݺ����š���
				FinalyX = xX
				FinalyY = yY
			end
			
		end
		
		local ret = CastSkillXYZ(YidengSkillID, 1, FinalyX, FinalyY, hPlayer.nZ + 494 * (tHeight-0.5)) 
		return ret
		
	end
end
--���Ŀ��
_ZMAC.TurnToTarget=function(xPlayer)
	local hPlayer=GetClientPlayer()
	local t = xPlayer
	if (not t  or t ==hPlayer ) then return SKILL_RESULT_CODE.FAILED end
	local angle= GetLogicDirection(t.nX - hPlayer.nX, t.nY - hPlayer.nY)
	TurnTo(angle)
end
--ȫ�ִ��
_ZMAC.GlobalBroken =function(...)
	local hPlayer = GetClientPlayer()
	local nSkillID,tDis=0,0
	if (...)==nil then
		local brokenskilllist = {
			['����ָ'] ={183,20},
			['������'] ={2603,25} ,
			['��'] ={482,4} ,
			['���Զ���'] ={370,20} ,
			['���ɾ���'] ={310,20} ,
			['����ͨ��'] ={547,20} ,
			['���'] ={18584,20} ,
			['�Х'] ={6626,20} ,
			['÷����'] ={3092,20} ,
			['������'] ={1577,20} ,
			['����ͷ '] ={5259,20} ,
			['����ҫ'] ={3961,20} ,
			['������Х'] ={14095,20} ,
			['���߷���'] ={16598,12} ,
			['�輫����'] ={20065,20} ,
			['Ѫ����Ȫ'] ={22274,20} ,
			['����ҫ'] ={3961,20} ,
			['��Լ�'] ={20511,20} ,
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
						OutputMessage('MSG_SYS','����Ŀ��: ' .. v.szName ..' �ͷ�ȫ����ϡ�\n')
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
--ȫ�ֺ���
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
	if mountX== '�뾭�׵�' or mountX== '�����'  or mountX== '��֪' or mountX== '�����ľ�' then return end
	
	
	if nSkillID>0 and tDis>0 and ZMAC_OptionFunc.num(tostring(nSkillID) .. '>0') and ZMAC_OptionFunc.tlife('<0.35') then
		for k,v in pairs(_ZMAC_GetAllPlayer()) do
			if IsEnemy(hPlayer.dwID, v.dwID) and GetCharacterDistance(hPlayer.dwID,v.dwID)/64 <= tDis then
					
				local KungfuMount = v.GetKungfuMount()
				local mount = ''
				if KungfuMount then
					mount = KungfuMount.szSkillName
				end
				if mount== '�뾭�׵�' or mount== '�����'  or mount== '��֪' or mount== '�����ľ�' then
					_ZMAC_SelTarget(v.dwID)
					_ZMAC.TurnToTarget(v)
					local aaa = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
					if aaa ==SKILL_RESULT_CODE.SUCCESS then 
						OutputMessage('MSG_SYS','����Ŀ��: ' .. v.szName ..' �ͷ�ȫ�����������\n')
						break
					end
				end	
			end
		end
		
	end	
end
--ȫ�ֶ���
_ZMAC.GlobalBrokenHealer =function(...)
	local hPlayer = GetClientPlayer()
	local nSkillID,tDis=0,0
	if (...)==nil then
		local brokenskilllist = {
			['����ҫ'] ={3961,20} ,
			['����ָ'] ={183,20},
			['������'] ={2603,25} ,
			['��'] ={482,4} ,
			['���Զ���'] ={370,20} ,
			['���ɾ���'] ={310,20} ,
			['����ͨ��'] ={547,20} ,
			['���'] ={18584,20} ,
			['�Х'] ={6626,20} ,
			['÷����'] ={3092,20} ,
			['������'] ={1577,20} ,
			['����ͷ '] ={5259,20} ,
			['������Х'] ={14095,20} ,
			['���߷���'] ={16598,12} ,
			['�輫����'] ={20065,20} ,
			['Ѫ����Ȫ'] ={22274,20} ,
			['��Լ�'] ={20511,20} ,
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
				mount== '�뾭�׵�'
				or mount== '�����' 
				or mount== '��֪'
				or mount== '�����ľ�'
				) then
					
					_ZMAC.TurnToTarget(v)
					local aaa = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
					if aaa ==SKILL_RESULT_CODE.SUCCESS then 
						OutputMessage('MSG_SYS','����Ŀ��: ' .. v.szName ..' �ͷ�ȫ����ϡ�\n')
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
--ȫ�־���.   ��Ѩ�����ɳ��[mapname:��ɽ֮��|��ɽ����|��ɽ�����|������Ժ|�ý�̨|�溣֮��|�ؽ���� ��JJC���Լ�����Ѫ�����ڰٷ�֮30�ұ��أ�ѡ��з�Ŀ�����Լ������DPS�����о���
_ZMAC.GlobalJuedou = function()
	local hPlayer = GetClientPlayer()
	local f = ZMAC_OptionFunc.haveskill('���ɳ��') and ZMAC_OptionFunc.mapname("��ɽ֮��|��ɽ����|��ɽ�����|������Ժ|�ý�̨|�溣֮��|�ؽ����") 
	if not f then return end
	local aPlayer = _ZMAC_GetAllPlayer()
	for k,v in pairs(aPlayer) do
	
		local KungfuMount = v.GetKungfuMount()
		local mount = ''
		if KungfuMount then
			mount = KungfuMount.szSkillName
		end
		if (not IsEnemy(hPlayer.dwID,v.dwID)) and v.nCurrentLife/v.nMaxLife < 0.3 and (
		mount== '�뾭�׵�'
		or mount== '�����' 
		or mount== '��֪'
		or mount== '�����ľ�'
		) then  --��δ��ӱ�������
			for m,n in pairs(aPlayer) do
				local _,EnemyTarID = n.GetTarget()
				local KungfuMount2 = n.GetKungfuMount()
				local mount2 = ''
				if KungfuMount2 then
					mount2 = KungfuMount2.szSkillName
				end
				if IsEnemy(hPlayer.dwID,n.dwID) and EnemyTarID == v.dwID and 
				(mount2 ~= '�뾭�׵�'
				and mount2 ~= '�����' 
				and mount2 ~= '��֪'
				and mount2 ~= '�����ľ�') then
					_ZMAC_SelTarget(n.dwID)
					_ZMAC.TurnToTarget(n)
					local nSkillID=15196
					local aaa = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
					if aaa ==SKILL_RESULT_CODE.SUCCESS then 
						OutputMessage('MSG_SYS','����Ŀ��: ' .. v.szName ..' �ͷ�[���ɳ��]���\n')
						break
					end
				end
			end
		end
	end
end
--ȫ��ʴ��
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
			mount== '�뾭�׵�'
			or mount== '�����' 
			or mount== '��֪'
			or mount== '�����ľ�'
			) then
				_ZMAC.TurnToTarget(v)
				local aaa = OnUseSkill(nSkillID, nSkillID * (nSkillID % 10 + 1))
				if aaa ==SKILL_RESULT_CODE.SUCCESS then 
					OutputMessage('MSG_SYS','����Ŀ��: ' .. v.szName ..' �ͷ�[ȫ������]��\n')
					break
				end
			end
		end
	end
end
--ȫ������
_ZMAC.GlobalSheshen=function()
	loadstring(
	[[
	local hPlayer = GetClientPlayer()
	local leastLife=0.25
	local leastDistance = 20
	local t = GetTargetHandle(hPlayer.GetTarget()) 
	
	if ZMAC_OptionFunc.life('<0.4') then  --�ջ�����
		_ZMAC.UseSkill(21693)
	end
	
	for j, v in pairs(_ZMAC_GetAllPlayer()) do 
		local k = v.dwID
		local tmpPlayer = v
		local tmpLife = tmpPlayer.nCurrentLife/tmpPlayer.nMaxLife
		local tmpDistance = _ZMAC.GetDistance(tmpPlayer)
		
		if IsParty(hPlayer.dwID, k) and  tmpDistance < leastDistance and tmpPlayer.nMoveState ~= MOVE_STATE.ON_DEATH and tmpLife < leastLife and ZMAC_OptionFunc.num('258>0')  then   --and ( or tID == nil)
			if _ZMAC.CheckStats (v,'�޼���') then
				_ZMAC_SelTarget(k)
				local aaa = _ZMAC.UseSkill(258)
				if aaa ==SKILL_RESULT_CODE.SUCCESS then 
					OutputMessage('MSG_SYS','����Ŀ��: ' .. v.szName ..' �ͷ�ȫ������\n')
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
--ȫ��̽÷
_ZMAC.GlobalTanmei=function()
	if ZMAC_OptionFunc.haveskill("̽÷") and ZMAC_OptionFunc.num("̽÷>0") then
		local me = GetClientPlayer()
		local prevTarID = 0
		local aPlayer = GetAllPlayer() or {}
		for k, v in pairs(aPlayer) do
			if me.dwID ~= v.dwID and me.IsPlayerInMyParty(v.dwID) and _ZMAC.GetDistance(v) <= 15 then 

				local _, prevTarID = me.GetTarget()
				if not prevTarID then prevTarID = 0 end
				_ZMAC.SetInsTarget(v.dwID)
				
				local f = ZMAC_OptionFunc.tally() and ZMAC_OptionFunc.tstats("����")
				--Output(f,ZMAC_OptionFunc.tally(),ZMAC_OptionFunc.tstats("����"))
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
					_ZMAC.UseSkill("̽÷")
					

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
--���»ޡ���
local function SunMoonDamage() --�������»�BUG
	OnUseSkill(28594, 28594 * (28594 % 10 + 1)) 
	return SKILL_RESULT_CODE.SUCCESS
end

--//ϵͳԭ����Hook==================================================================================
--ȡ�����꣬��#��ͷ��ע�ͼ���������
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
--ȡ����function��
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
--ȡ����
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
--ȡ�����ݣ�����ExcuteMacroByID(dwID)
local function GetMacroContent(dwID)
	local t = g_Macro[dwID]
	if t then
		return t.szMacro or ""
	end
	return ""
end
--ȡ�깦�ܣ�������ѭ��ִ��

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
--//ԭ���걸��
if not _ZMAC.OriginExcuteMacro then 
	_ZMAC.OriginExcuteMacro=ExcuteMacro   --����ԭʼ�괦����
end
--//PVE�ú�ӿ�
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
--ԭ����Hook
_ZMAC.ExcuteDelay = 250
_ZMAC.nLastExcuteTime = GetTickCount()
function ExcuteMacro(Macro)
	local szMacro = GetPureMacro(Macro)
	if ZMAC.Switch['����PVE��'] ==true then
		return _ZMAC.ExcuteMacroPVE(szMacro)
	end
	
	if GetTickCount()-_ZMAC.nLastExcuteTime>_ZMAC.ExcuteDelay then
		_ZMAC.nLastExcuteTime = GetTickCount()
		return GetMacroFunction()(szMacro)
	end
end
--�����Hook��ExcuteMacroByID
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
--��Ӻ�ָ��
local function AppendCommand(key, fn, szHelp)
	key = StringLowerW(key)
	aCommand["/"..key] = fn
	if szHelp then
		aCommandHelp[key] = szHelp
	end
end


--//MacroSettingPanel Hook
--�곤��
if not g_Oldwstringlen then g_Oldwstringlen = wstring.len  end
function wstring.len(szText)  
	if s_find(szText, '/cast')  then 
		return 120 
	end 
	return g_Oldwstringlen(szText) 
end
--Ե��
if not g_Oldwstringlen2 then g_Oldwstringlen2 = string.len  end
function string.len(szText)  
	if s_find(szText, '/cast')  then 
		return 120 
	end 
	return g_Oldwstringlen2(szText) 
end
--�ı���ֽ���
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
	Station.Lookup("Topmost/MacroSettingPanel"):Lookup("Edit_Content"):SetLimit(-1) --Ե���ֽ�ͻ��
end
--�����Զ����ܱ���
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
--����������ȡ��
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
end  --ȡ����κ�ٷ�ִ�м��   -- _UPVALUE1_����һ��ֵ�ĵ�Ӧ�þͿ���


--//�Զ�ִ��
WY.Auto = false
WY.Key = ""
WY.speed = 4	--�O�È����ٶ�	��/ÿ��
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
		myMessage("�ѹر��Զ�ִ�к����")
	else
		WY.Auto = true
		myMessage("�ѿ����Զ�ִ�к����")
	end
end
function WY.SetSpeed()
	GetUserInput("�������������������ÿ��ִ�еĴ�������λ����/�룩�����õ�ֵ��Χ��1-16��", function(szText)
		if szText ~= "" then
			WY.speed = tonumber(szText)
			if WY.speed > 16 then
				WY.speed = 16
			end
			myMessage("��ִ���ٶ�������ϣ���ǰִ���ٶȣ�" .. WY.speed .. "��/��")
			WY.speed = math.ceil(WY.speed/2)
		end
	end)
end


--//�������
AppendCommand("msg", myMessage)
--AppendCommand("call", MacroCall)
AppendCommand("cast", Cast, "��ʽ��/cast [�l��1,(�l��2;�l��3)] ������1,������2")
AppendCommand("castid", Cast, "��ʽ��/cast [�l��1,(�l��2;�l��3)] ������1,������2")
AppendCommand("castEx", Cast, "��ʽ��/cast [�l��1,(�l��2;�l��3)] ������1,������2")
AppendCommand("castidEx", Cast, "��ʽ��/cast [�l��1,(�l��2;�l��3)] ������1,������2")
AppendCommand("do", Cast, "��ʽ��/cast [�l��1,(�l��2;�l��3)] ������1,������2")
AppendCommand("skill", Cast, "��ʽ��/cast [�l��1,(�l��2;�l��3)] ������1,������2")
AppendCommand("use", Use, "��ʽ��/use [�l��]")  --δд
AppendCommand("config", Config, "��ʽ��/config [�l��]")  --δд
--AppendCommand("account", account, "��ʽ��/account [�l��]")  --�޳�
AppendCommand("script", ExucteScriptCommand, "��ʽ��/script ���a��")
AppendCommand("target", MacroTarget, "��ʽ��/target [�l��] Ŀ������") --δд
AppendCommand("player", MacroTarget, "��ʽ��/target [�l��] Ŀ������") --δд
AppendCommand("select", MacroTarget, "��ʽ��/target [�l��] Ŀ������") --δд
--AppendCommand("showerrmsg", function(szShow) g_ShowLuaErrMsg = szShow == "true" end) --�޳�
AppendCommand("roll", Roll, g_tStrings.HELPME_ROLL) 
AppendCommand("help", Help, g_tStrings.HELPME_HELP)
AppendCommand("stop", Stop, "��ʽ��/stop [�l��]")




--//��ݼ�
--ѡ�˷�Χ
_ZMAC.SelectFeet = 20
_ZMAC.SetSelectFeet = function()
	--�˴������ʵ��loadstring,ֻҪ����_ZMAC.ExcuteDelay��ʧЧ,�²�Ӧ����ȫ�ֱ������ܷŽ�����ԭ��
	local function fnSure(nNum)
		_ZMAC.SelectFeet = nNum
		OutputMessage('MSG_SYS','����ѡ�˷�Χ������Ϊ '..tostring(_ZMAC.SelectFeet)..'�ߡ�\r\n')
	end
	GetUserInputNumber(1, 99,{1920/2,1080/2,10,10} , fnSure)
end
--ѡ��Ѫ��
_ZMAC.SelectLife = 30
_ZMAC.SetSelectLife = function()
	--�˴������ʵ��loadstring,ֻҪ����_ZMAC.ExcuteDelay��ʧЧ,�²�Ӧ����ȫ�ֱ������ܷŽ�����ԭ��
	local function fnSure(nNum)
		_ZMAC.SelectLife = nNum
		OutputMessage('MSG_SYS','����ѡ��Ѫ���ż�������Ϊ:�ٷ�֮ '..tostring(_ZMAC.SelectLife)..' \r\n')
	end
	GetUserInputNumber(1, 100,{1920/2,1080/2,10,10} , fnSure)
end
--��Ѫ����
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
			--OutputMessage("MSG_SYS"," ѡ�����Ѫ���ˣ�"..nSelectWho.szName.."\n")
			_ZMAC_SelTarget(nSelectWho.dwID)
		end
	else
		--OutputMessage("MSG_SYS"," �޵�ѪĿ�ꡣ\n")
	end
end
--��Ѫ����
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

	--��ѡ�Լ�
	-- if nSelectWho~=nil and hPlayer.nCurrentLife/hPlayer.nMaxLife<= leastLife then
		-- nSelectWho = hPlayer
	-- end

	if nSelectWho and nSelectWho~= GetTargetHandle(hPlayer.GetTarget())  then
		_ZMAC_SelTarget(nSelectWho.dwID)
		--OutputMessage("MSG_SYS"," ѡ�����Ѫ���ѣ�"..nSelectWho.szName.."\n")
	end
end

--//��ݼ�======================================================================================

--//����ִ���ȼ�------------------------------------------------------------------------------
ZMAC.AutoExcuteMacroFirst_Kaiguan = false
ZMAC.AutoExcuteMacroFirst = function()
	if ZMAC.AutoExcuteMacroFirst_Kaiguan then 
		ZMAC.AutoExcuteMacroFirst_Kaiguan = false
		ZMAC.BreatheCall('autoexcutemacrofirst')
		OutputMessage('MSG_SYS',' ִֹͣ�С�\r\n')
	elseif ZMAC.AutoExcuteMacroFirst_Kaiguan ==false then
		ZMAC.AutoExcuteMacroFirst_Kaiguan =true
		local tmpFnAction = function()	
			ExcuteMacroByID(1)
		end
		ZMAC.BreatheCall('autoexcutemacrofirst',tmpFnAction,62.5)
		OutputMessage('MSG_SYS',' ��ʼִ�С�\r\n')
	end
end

--//��סִ���ȼ�------------------------------------------------------------------------------
ZMAC.AutoExcuteMacroFirstStart = function()
	local tmpFnAction = function()	
		ExcuteMacroByID(1)
	end
	ZMAC.BreatheCall('autoexcutemacrofirst2',tmpFnAction,ZMAC.ExcuteDelay)
end
ZMAC.AutoExcuteMacroFirstEnd = function()
	ZMAC.BreatheCall('autoexcutemacrofirst2')
end





--��ݼ���
--Hotkey.AddBinding("AutoMacro", "���Զ�ִ�С�", "��ʵ��PVP��",function() ExucteScriptCommand("WY.OpenOrClose()") end,nil)
--Hotkey.AddBinding("PressMacro", "����סִ�С�", "",function() end,nil)
--Hotkey.AddBinding("SetSpeed", "��ִ���ٶȡ�", "",function() ExucteScriptCommand("WY.SetSpeed()") end,nil)
Hotkey.AddBinding("ZMAC_����ִ��", '������ִ�С�','��ʵ��PVP��', function() ExucteScriptCommand("ZMAC.AutoExcuteMacroFirst()") end, nil)
Hotkey.AddBinding("ZMAC_��סִ��", '����סִ�С�','', function() ExucteScriptCommand("ZMAC.AutoExcuteMacroFirstStart()") end, function() ExucteScriptCommand("ZMAC.AutoExcuteMacroFirstEnd()") end)
--//ִ���ٶ�����------------------------------------------------------------------------------
ZMAC.SetDelay = function()
	local function fnSure(nNum)
		_ZMAC.ExcuteDelay = (16/(nNum))*62.5
		OutputMessage('MSG_SYS','ִ���ٶ�������Ϊ: '..tostring(nNum)..'��/�롣\r\n')
	end
	GetUserInputNumber(1, 1000,{1920/2,1080/2,10,10} , fnSure)
	
end
Hotkey.AddBinding("ZMAC_SetDelay", '��ִ���ٶȡ�','', function() ExucteScriptCommand("ZMAC.SetDelay()") end , nil)
Hotkey.AddBinding("_ZMAC_SetSelectFeet", '��ѡ�˾��롿','', function() ExucteScriptCommand("_ZMAC.SetSelectFeet()") end , nil)
Hotkey.AddBinding("_ZMAC_SetSelectLife", '��ѡ��Ѫ����','', function() ExucteScriptCommand("_ZMAC.SetSelectLife()") end , nil)
Hotkey.AddBinding("_ZMAC_��Ѫ����", '��һ��ת��','', function() ExucteScriptCommand("_ZMAC.SelcectDyingEnemy()") end , nil)
Hotkey.AddBinding("_ZMAC_��Ѫ����", '��һ�����ơ�','', function() ExucteScriptCommand("_ZMAC.SelectDyingParty()") end, nil)
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
Hotkey.AddBinding("ZMAC_һ������", '��һ�����͡�','', _ZMAC.OneKeyWantedPublish, nil)

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
	local QinggongList = '��ҡֱ��|��������|������ʤ|ӭ�����|��̨���|��|'
	local FaskList = 'ȫ������|ȫ��ת��|ȫ�ִ��|ȫ�ֶ���|ȫ��Ⱥ��|���Ŀ��|����Ŀ��|�Ṧ���|����Ŀ��|�Զ��Ʊ�|����|'
	--����1  ����
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|Τ������|��ɨ����|�ն��ķ�|Ħڭ����|��ʨ�Ӻ�|�޺�����|��ȥ����|���سɷ�|�����||����ʽ|��ȱʽ|׽Ӱʽ|����ʽ|����ʽ|ǧ��׹||�͹Ǿ�|������|�����|������|�ֻؾ�|�����|���������||��ҵ��Ե|����뷨|�����ඥ|��ں","���ܿ���",true) end
	--����2  ��
	if MyJob == '��' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|����ָ|����ָ|̫��ָ|����ָ||��ʯ���|��������|����ع��|ܽ�ز���|��ѩʱ��|�������|��������|���紵ѩ||��¥��Ӱ|ˮ���޼�|��ˮ����|��紹¶|���໤��|���ľ���||����|����|����|����|����|����|����||��ʽ�ڰ�|�Ϸ�����|��ī����|�崨����|�칤��ʿ|��Ҷ����||��׾","���ܿ���",true) end	
	--����3  ���	
	if MyJob == '���' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|��|ͻ|��|��|Ԩ|��||����|����|����|����|����|����||�����|����ɽ|Х�绢|������||�ϻ��|�Ƽ���|�γ۳�|ս�˷�|����Χ|������|�������|��������","���ܿ���",true) end
	--����4  ����
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|����|��ɽ��|��̫��|������|���ǳ�|�Ʋ��|������|������|�����|תǬ��|���ƽ�|���ƽ�����||�˻Ĺ�Ԫ|�����޽�|����޼�|�򽣹���|��������|�˽���һ|�������|��������|���ɾ���||̫���޼�|���ǻ���|���Ż���|�����ֻ�|�巽�о�|���϶���|���ǹ���|���Զ���|��ת��һ|��������||ƾ������|��������|��������|��������|�¡����","���ܿ���",true) end
	--����5 ����	
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|�������|��������|�������|��Ӱ����|����ͨ��|��ת����|���Ҽ���|��������||������ŭ|��������|��صͰ�|��������|�����ķ�|ˮ鿻�ӯ||����Ͱ�|��ĸ����|��ѩƮҡ|��Ԫ����|������ת|���ٻ��|���麶��|��������|��ʱ����||������|ȵ̤֦|��Ū��|������|��筴�|�Ĺ���|������||˪�콣��|�³���ɽ|�ຮӳ��|��΢�ɻ�","���ܿ���",true) end	
	--����6  �嶾
	if MyJob == '�嶾' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|���|�ù�|��ˮ��|��˹�||ʴ�Ĺ�|��Ե��|ʥԪ��||�Ƴ��׼�|�Ƴ��||Ы��|��Ӱ|�Х|ǧ˿|����|����||ʥЫ��|������|�����|������|������|�̵���||ǧ������|�������|ʥ��֯��|����ǣ˿|Ů洲���|�ƻ�����|�����ƶ�|��������|�������Ρ���||���|�û�|Ы��|���|���|˿ǣ|Ӱ��|�鳲||����|����|ͣ��||������|������|������","���ܿ���",true) end	
	--����7  ����	
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|׷����|���Ǽ�|���Ǽ�|��ʯ��|ʴ����|������||������|����|÷����|��ȸ��||����|ǧ����|ǧ���䡤����|ǧ���乥��|ǧ����ֹͣ|������̬|������̬|��ɲ��̬||�@�Ĵ̹�|���켬��|�����滨��||������Ӱ|��������|���Ƕ�Ӱ|��Ӱ|��������|��ĸ��צ|����ɱ��|ͼ��ذ��|����̿�|����̿ա��Ϳ�|����̿ա�����||ʴ����������|�������|������𡤷���|�����������|��Ůɢ��|��Ůɢ��������||����׷��|��������|�������|����˪ѩ|ǧ�����|ǧ����١�����||�������|��������","���ܿ���",true) end	
	--����8 �ؽ�
	if MyJob == '�ؽ�' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|Х��|����|����|����|̽÷||Ȫ����|������|ݺ����|�紵��||������|ƽ������|�����´�|��Ȫ����|��Ȫ��Ծ|��Ϫ����||Ϧ���׷�|�Ʒ����|�׹��ɽ|����ƾ�|ϼ����ʯ|������ɽ||������ϼ|��������|����ٶ�","���ܿ���",true) end
	--����9  ؤ��
	if MyJob == 'ؤ��' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|Ц���|������|����ң|�����|������||������||�����л�|��Ծ��Ԩ|��ս��Ұ||Ǳ������|��Ȯ����|����·|Ȯ������|��������|��������|���˫��|����ͷ|б�򹷱�|���ع���|������ͷ|��ˮ��||�����޹�|�����޹�˲��||��������|˫��ȡˮ|�������|��������||����Ϸˮ|��������|������β|��������|��������||ʱ������|��������|��Х����","���ܿ���",true) end
	--����10  ����
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|������ɢ|������ɢ����|��η����|̰ħ��||���»�|���»ޡ���|���»ޡ���|�������|ڤ�¶���|��������|��а��ħ|������ħ��|������|������|������|��ҹ�ϳ�|����ն|����ն|������|������|�ùⲽ|������Ӱ|����׷��|����ҫ|��������|��������|΢���|�ȱ�Ը|���ն|�ɶ���|�Ļ�̾|��ʥ��","ְҵ����",true) end
	--����21 ����
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|��ѹ|����|�ܻ�|�ܵ�||����|ն��|����|����|Ѫ��|�ٵ�||�ܷ�|�ն�|�ܻ�|����|�ܱ�|��ǽ|����|����|�ܵ�|�ܷ�|����|���衤ǿ��||����|Ѫŭ|�޾�||���ɳ��|����ݳ�|ʸ������|��Хǧ��","���ܿ���",true) end
	--����22  ����
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|��|��|��|��|��||�乬|����||������|������|������||��ɽ��ˮ|������ѩ|ƽɳ����|÷����Ū||���λ�Ӱ|������Х|���Ӱ��|��Ӱ��˫|һָ���|||�������������ả|��������|ޒ�����|Ц������||��Ӱ��б|��������|�辡Ӱ��|��ˮ��Ӱ||��̫��|������","���ܿ���",true) end
	--����23 �Ե�
	if MyJob == '�Ե�' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|��������|��������|ѩ������||ֹͣ�ͷ�||��������|̤������|���߷���||������ն|��ӥʽ|�غ�ʽ|���ʽ|����ʽ|����ʽ|����ʽ||�齭��|ɢ��ϼ|������||��Ԩ����|��Х����|��ն����|�����Ұ|���Ӻ���||��Ԩ��ɷ|��������|��������|�Ƹ�����|����ع�|�Ͻ���ӡ||�������|���ɽ��|���ɽ�ӡ���ʽ","���ܿ���",true) end	
	--����24 ����
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|��ˮ��ǧ|ľ�����|��������|��������������|������ڤ|�麣����|������|Ծ��ն��||�������|������졤�ٻ�|Ԧ��ҷ�|����߳��|���ͼ��|�輫����|��ɣ��ɪ||�轥�ڷ�|�����Ʒ�|�Ȼ����|������ȱ|��������||�������|������ء����|�ݳ�����|�ﻯ����|�ﻯ���С�����","���ܿ���",true) end	
	--����25 ��ѩ
	if MyJob == '��ѩ' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|�Ǵ�ƽҰ|������|���꺮��||������|�ź��|������|������|ն�޳�||�����⹳|���͹�|���л�ת|ʮ������|Ѫ����Ȫ|��ڤ����|�������|�·��̤||��ɽ����|���ް���|����","���ܿ���",true) end	
	--����211 ����
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|������|������|�춷��|���߶�|̤����|��Լ�||�ݺ����š�һ|�ݺ����š���|�ݺ����š���||����|ף�ɡ�ˮ��|ף�ɡ�ɽ��|ף�ɡ�����|����|���ŷɹ�|���ǿ�Ѩ|���վ���|���˺�һ|���˺�һ����|���ű���|��ת����|�������||�������|ɱ����β|������|��ɱ","���ܿ���",true) end	
	--����212 ҩ��
	if MyJob == 'ҩ��' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."|��½׺��|���Ƕϳ�|��������|մ��δ��|�Ҵ�ʱ��||������ѩ|��Ȼ���|������ˮ|�ط�΢��|��������|��Ҷ����||���ƺ���|���ֺ���|��������|�����Կ�|����ͺ�|���ػ���||ǧ֦����|ǧ֦����|�Լ�����|��Ҷ����|�ന���|���ƺ���|��Ұ����|��ľ��Ϣ||���ٶ���|�����ų�|��ҩ��ʱ|�����ɲ�","���ܿ���",true) end	
	--����0 ����
	if MyJob == '����' then _ZMAC.AddMenu("����PVE��||"..QinggongList..FaskList .."","���ܿ���",true) end	


	if not ZMAC.Switch then 
		_ZMAC.AddMenu("����PVE��||"..FaskList .."|�˵�����","���ܿ���",true)	
	end
	ZMAC.Switch['����PVE��'] = false
	OutputMessage('MSG_SYS','��ӭʹ�á�ʵ��PVP��,������������Ѹ�Ϊ50000,��ֱ�Ӹ�дʹ�á�����/cast /config /use�ȡ� \r\n')

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
	tmp = s_gsub(tmp ,'\r\n','\n')--�������Ļ�,��bug,���������ܹ���������,���з��е���\n  �е���\r  �е���\r\n        ����jx3 lua����ֻ��\n  ����Ҫ������\r�滻��
	--tmp = s_gsub(tmp ,'\r','')      --�ѷ���,��Ϊ�п�������\r���ַ���
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
	for k , v in pairs(GetAllNpc()) do       --kΪ��ƷdwID,value������  
		local Dis = GetCharacterDistance(hPlayer.dwID, v.dwID) / 64
		if Dis < 6 then
			if v.szName == pName or v.dwID == pName then
				--Output(v.szName)
				InteractNpc(v.dwID)
			end 
		end
	end
	
	for kk , vv in pairs(GetAllDoodad()) do       --kΪ��ƷdwID,value������
		local nX,nY,nZ = vv.nX, vv.nY, vv.nZ
		local Dis2 = m_floor(((hPlayer.nX - nX) ^ 2 + (hPlayer.nY - nY) ^ 2 + (hPlayer.nZ/8 - nZ/8) ^ 2) ^ 0.5)/64
		if Dis2 < 6 then 		
			if vv.szName == pName or vv.dwID == pName then
				InteractDoodad(vv.dwID)	
			end
		end
	end
end


function _ZMAC.RoundBuff()  --�����ã�����
	for k,v in pairs(GetAllPlayer()) do
		--Output(v.dwID)
		_ZMAC.SmartRefreshBuff(v.dwID)
	end
end

--_ZMAC.BreatheCall('ZMAC_RoundBuff',function() _ZMAC.RoundBuff() end,62.5)   --�˹������вż����ӾͶϿ��˷��������ӣ��ᱻ���


ZMAC.RoundBuff = _ZMAC.RoundBuff

--�ַ����ҹ���
--SaveDataToFile(EncodeData(var2str(g_tStrings),true,false),"E:/JX3/Game/JX3/bin/zhcn_hd/interface/g_tStrings.lua")
ZMAC.GetReduction = _ZMAC.GetReduction
ZMAC.AutoHunDeng = _ZMAC.AutoHunDeng
