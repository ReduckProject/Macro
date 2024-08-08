

function Main()
    --/cast 御鸿于天
    --/cast 蜀犬吠日
    --/cast [buff:龙跃于渊] 亢龙有悔
    --/cast 龙战于野
    --/cast [buff:龙战于野] 龙跃于渊
    --/cast 酒中仙
    --/cast 拨狗朝天
    --/cast 蛟龙翻江

    cast("御鸿于天")
    cast("蜀犬吠日")
    if buff("龙跃于渊") then
        cast("亢龙有悔")
    end
    cast("龙战于野")
    if buff("龙战于野") then
        cast("龙跃于渊")
    end
	cast("酒中仙")
	cast("拨狗朝天")
	cast("蛟龙翻江")
end