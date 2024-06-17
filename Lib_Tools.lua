---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Gin.
--- DateTime: 2024/3/28 22:08
---

function findClosestCoordinateIndex(coordinate)

    local x, y, z = pos()
    local closestCoordinateIndex = cur
    local minDistance = math.huge

    local coordinates = coordinate
    local len = #coordinate
    for i = 1, len do
        local _x, _y, _z = coordinates[i][1], coordinates[i][2], coordinates[i][3]
        local distance = math.abs(x - _x) + math.abs(y - _y) + math.abs(z - _z)
        if minDistance > distance then
            minDistance = distance
            closestCoordinateIndex = i
        end
    end

    return closestCoordinateIndex
end

g_tools = {}

g_tools.cur = 1
g_tools.name = "NONE"
g_tools.len = 0

--function autoMove(coordinate, reverse)
--    initAutoMove(coordinate)
--    print(g_tools.cur.."/".. g_tools.len)
--    print("333"..g_tools.cur.."/".. g_tools.len)
--
--
--    if reverse then
--        if g_tools.cur > g_tools.len or g_tools.cur < 1 then
--            print("4")
--            return true
--        end
--    else
--        if g_tools.cur < 1 then
--            return true
--        end
--    end
--
--
--    if nobuff("����") and nobuff("�߻���") then
--        cast(53)
--        print(555)
--        return false
--    end
--
--    print(666)
--    if next(coordinate) then
--        if reverse then
--            g_tools.cur = g_tools.cur - 1
--        else
--            g_tools.cur = g_tools.cur + 1
--        end
--    else
--        moveto(coordinate[g_tools.cur][1], coordinate[g_tools.cur][2], coordinate[g_tools.cur][3])
--    end
--
--    return false
--end

function autoMove(coordinate, name, reverse)
    if name ~= g_tools.name then
        initAutoMove(coordinate, name)
    end
    print(g_tools.cur .. "/" .. g_tools.len)
    if reverse then
        if g_tools.cur < 1 then
            return true
        end
    else
        if g_tools.cur > g_tools.len then
            return true
        end
    end

    if nobuff("����") and nobuff("�߻���") then
        cast(53)
        return false
    end

    if autoNext(coordinate) then
        if reverse then
            g_tools.cur = g_tools.cur - 1
        else
            g_tools.cur = g_tools.cur + 1
        end
    else
        moveto(coordinate[g_tools.cur][1], coordinate[g_tools.cur][2], coordinate[g_tools.cur][3])
    end

    return false
end

function resetAutoMove()
    g_tools.cur = nil
end

function autoNext(coordinate)
    if g_tools.cur < 1 or g_tools.cur > g_tools.len then
        return true
    end

    local x, y, z = pos()
    local _x, _y, _z = coordinate[g_tools.cur][1], coordinate[g_tools.cur][2], coordinate[g_tools.cur][3]

    if (math.abs(x - _x) < 100 and math.abs(y - _y) < 100) then
        return true
    else
        if math.abs(x - _x) > 2000 or math.abs(y - _y) > 2000 then
            g_tools.cur = findClosestCoordinateIndex(coordinate)
            print("findClosestCoordinateIndex")
        end
        return false
    end

end

function initAutoMove(coordinate, name)
    g_tools.cur = findClosestCoordinateIndex(coordinate)
    g_tools.len = #coordinate
    g_tools.name = name
end

function startDelay()
    deltimer("delay")
    settimer("delay")
end

function getDelay()
    return gettimer("delay")
end

function delayed()
    return gettimer("delay") ~= 0
end