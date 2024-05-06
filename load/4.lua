if not ZMAC then ZMAC =  {} end
----------------------------------------------加解密
--ZMAC.Base64用于字符串base64转换
--ZMAC.transMacro用于替换字符串形成加密

ZMAC.Base64 = {}
local string = string

local t_insert, t_sort, t_remove, t_concat       = table.insert, table.sort, table.remove, table.concat
local s_sub,s_find,s_format,s_match,s_gsub,s_len ,s_byte,s_char= string.sub,string.find,string.format,string.match,string.gsub,string.len,string.byte,string.char
local m_floor, m_min ,m_ceil,m_abs               = math.floor, math.min,math.ceil,math.abs

ZMAC.Base64.__code = {
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
            'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
            'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/',
        };
ZMAC.Base64.__decode = {}
for k,v in pairs(ZMAC.Base64.__code) do
    ZMAC.Base64.__decode[s_byte(v,1)] = k - 1
end
function ZMAC.Base64.encode(text)
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
            res[index] = ZMAC.Base64.__code[curPos]
            index = index + 1
        end
    end

    if left == 1 then
        ZMAC.Base64.__left1(res, index, text, len11)
    elseif left == 2 then
        ZMAC.Base64.__left2(res, index, text, len11)        
    end
    return t_concat(res)
end
function ZMAC.Base64.__left2(res, index, text, len11)
    local num1 = s_byte(text, len11 + 1)
    num1 = num1 * 1024 --lshift 10 
    local num2 = s_byte(text, len11 + 2)
    num2 = num2 * 4 --lshift 2 
    local num = num1 + num2
   
    local tmp1 = m_floor(num / 4096) --rShift 12
    local curPos = tmp1 % 64 + 1
    res[index] = ZMAC.Base64.__code[curPos]
    local tmp2 = m_floor(num / 64)
    curPos = tmp2 % 64 + 1
    res[index + 1] = ZMAC.Base64.__code[curPos]

    curPos = num % 64 + 1
    res[index + 2] = ZMAC.Base64.__code[curPos]
    
    res[index + 3] = "=" 
end
function ZMAC.Base64.__left1(res, index,text, len11)
    local num = s_byte(text, len11 + 1)
    num = num * 16 
    
    tmp = m_floor(num / 64)
    local curPos = tmp % 64 + 1
    res[index ] = ZMAC.Base64.__code[curPos]
    
    curPos = num % 64 + 1
    res[index + 1] = ZMAC.Base64.__code[curPos]
    
    res[index + 2] = "=" 
    res[index + 3] = "=" 
end
function ZMAC.Base64.decode(text)
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
    local decode = ZMAC.Base64.__decode
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
        ZMAC.Base64.__decodeLeft1(res, index, text, len11)
    elseif left == 2 then
        ZMAC.Base64.__decodeLeft2(res, index, text, len11)
    end
    return t_concat(res)
end
function ZMAC.Base64.__decodeLeft1(res, index, text, len11)
    local decode = ZMAC.Base64.__decode
    local a = decode[s_byte(text, len11 + 1)] 
    local b = decode[s_byte(text, len11 + 2)] 
    local c = decode[s_byte(text, len11 + 3)] 
    local num = a * 4096 + b * 64 + c
    
    local num1 = m_floor(num / 1024) % 256
    local num2 = m_floor(num / 4) % 256
    res[index] = s_char(num1)
    res[index + 1] = s_char(num2)
end
function ZMAC.Base64.__decodeLeft2(res, index, text, len11)
    local decode = ZMAC.Base64.__decode
    local a = decode[s_byte(text, len11 + 1)] 
    local b = decode[s_byte(text, len11 + 2)]
    local num = a * 64 + b
    num = m_floor(num / 16)
    res[index] = s_char(num)
end
ZMAC.transMacro={}

local OriginTXT = {   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'a', 'B', 'b', 'C', 'c', 'D', 'd', 'E', 'e', 'f', 'F', 'g', 'G', 'h', 'H', 'i', 'I', 'j', 'J', 'K', 'k', 'L', 'l', 'M', 'm', 'N', 'n', 'O', 'o', 'P', 'p', 'Q', 'q', 'R', 'r', 'S', 's', 'T', 't', 'U', 'u', 'v', 'V', 'W', 'w', 'X', 'x', 'Y', 'y', 'Z', 'z', '+','/','='}

local EncodeTXT =  { "x","p","W","9","4","Q","7","/","n","L","o","1","M","d","3","j","f","=","G","w","b","Z","X","8","s","P","S","A","k","g","E","i","F","B","a","C","t","z","U","c","V","v","r","Y","D","R","I","T","0","J","5","2","K","e","l","h","O","y","H","u","q","N","+","6","m"}
--加密字典

local EncodeZMAC = { '9', 'x', 'p', 'W', '4', '7', '/', 'n', 'L', 'o', '1', 'M', 'd', '3', 'j', 'f', '=', 'G', 'w', 'b', 'Z', 'X', '8', 's', 'P', 'S', 'A', 'k', 'g', 'E', 'i', 'F', 'B', 'a', 'C', 't', 'z', 'U', 'c', 'V', 'v', 'r', 'Y', 'D', 'R', 'I', 'T', '0', 'J', '5', '2', 'K', 'e', 'h', 'O', 'y', 'l', 'H', 'Q', 'u', 'q', 'N', '+', '6', 'm' }



--[[此为铁头宏解密
local OriginTXT = {  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "a", "B", "b", "C", "c", "D", "d", "E", "e", "f", "F", "g", "G", "h", "H", "i", "I", "j", "J", "K", "k", "L", "l", "M", "m", "N", "n", "O", "o", "P", "p", "Q", "q", "R", "r", "S", "s", "T", "t", "U", "u", "v", "V", "W", "w", "X", "x", "Y", "y", "Z", "z", "+", "/","="}

local EncodeTXT =  {  "N", "O", "a", "b", "c", "t", "u", "v", "w", "x", "H", "V", "I", "W", "J", "X", "K", "Y", "L", "Z", "o", "M", "p", "0", "q", "1", "r", "2", "s", "3", "4", "6", "5", "7", "d", "8", "e", "9", "f", "+", "g", "P", "h", "Q", "i", "R", "j", "m", "k", "n", "l", "A", "B", "C", "D", "S", "E", "T", "F", "U", "G", "/", "y", "z" ,"="}
--]]

ZMAC.transMacro_Dictbase2macro = {}
ZMAC.transMacro_Dictmacro2base = {}
ZMAC.transMacro_Dictmacro2baseZMAC ={}
for k,v in pairs(OriginTXT) do
	ZMAC.transMacro_Dictbase2macro[v] = EncodeTXT[k]
	
end
for k,v in pairs(EncodeTXT) do
	ZMAC.transMacro_Dictmacro2base[v] = OriginTXT[k]
end

for k,v in pairs(EncodeZMAC) do
	ZMAC.transMacro_Dictmacro2baseZMAC[v] = OriginTXT[k]
end



ZMAC.transMacro_Dictmacro2base={
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
}
ZMAC.transMacro_Dictbase2macro={
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

--随机解密序列并存档方便复制
-- local jiajiemipaixu = ''
-- for k,v in pairs(ZMAC.transMacro_Dictbase2macro) do
	-- jiajiemipaixu = jiajiemipaixu .."\""..v.."\","
-- end
-- ZMAC.WriteToFile("c:\\jiajiemipaixu.txt",jiajiemipaixu)



ZMAC.transMacro.jiemi = function(str)
	local tmp = ''
	tmp = s_gsub(str, "['=''N''O''a''b''c''t''u''w''x''H''V''I''W''J''X''K''Y''L''Z''o''M''p''0''q''1''r''2''s''3''4''6''5''7''d''8''e''9''f''+''g''P''h''Q''i''R''j''m''k''n''l''A''B''C''D''S''E''T''F''U''G''/''v''y''z''\r''\n''\r']", ZMAC.transMacro_Dictmacro2base)
	tmp = ZMAC.Base64.decode(tmp) 
	tmp = s_gsub(tmp ,'\r\n','\n')--不加这句的话,会bug,加密器加密过来的数据,换行符有的是\n  有的是\r  有的是\r\n        但是jx3 lua换行只认\n  所以要把所有\r替换掉
	--tmp = s_gsub(tmp ,'\r','')      --已废弃,因为有可能误伤\r的字符串
	return tmp
end
ZMAC.transMacro.jiami = function(str)
	local tmp = ''
	tmp =  ZMAC.Base64.encode(str)
	tmp2 = s_gsub(tmp ,"['=''0''1''2''3''4''5''6''7''8''9''a''b''c''d''e''f''g''h''i''j''k''l''m''n''o''p''q''r''s''t''u''v''w''x''y''z''A''B''C''D''E''F''G''H''I''J''K''L''M''N''O''P''Q''R''S''T''U''V''W''X''Y''Z''+''/']", ZMAC.transMacro_Dictbase2macro)
	return tmp2
end

--用于ZMAC.lua文件解密
ZMAC.transMacro.jiemiZMAC = function(str)
	local tmp = ''
	tmp = s_gsub(str, "['=''N''O''a''b''c''t''u''w''x''H''V''I''W''J''X''K''Y''L''Z''o''M''p''0''q''1''r''2''s''3''4''6''5''7''d''8''e''9''f''+''g''P''h''Q''i''R''j''m''k''n''l''A''B''C''D''S''E''T''F''U''G''/''v''y''z''\r''\n''\r']", ZMAC.transMacro_Dictmacro2baseZMAC)
	tmp = ZMAC.Base64.decode(tmp) 
	tmp = s_gsub(tmp ,'\r\n','\n')--不加这句的话,会bug,加密器加密过来的数据,换行符有的是\n  有的是\r  有的是\r\n        但是jx3 lua换行只认\n  所以要把所有\r替换掉
	--tmp = s_gsub(tmp ,'\r','')      --已废弃,因为有可能误伤\r的字符串
	return tmp
end