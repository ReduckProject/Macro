---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Gin.
--- DateTime: 2024/2/18 9:15
---

g_map = {}
g_map_move = {
    moveToNpc = true,
    coordinateLength = -1,
    currentStep = -1,
    currentMap = "",
    currentGoods = -1,
    counter = 1
}

g_map_move["移动"] = function()
    g_map_move["初始化"]()
    if g_map_move.currentGoods == -1 then
        return
    end
    local coordinates = g_map[g_map_move.currentMap]
    moveto(coordinates[g_map_move.currentStep][1], coordinates[g_map_move.currentStep][2], coordinates[g_map_move.currentStep][3])

    if g_map_move["下一步"]() then
        if g_map_move.moveToNpc then
            if g_map_move.coordinateLength > g_map_move.currentStep then
                g_map_move.currentStep = g_map_move.currentStep + 1
                print("+1")
            end
        else
            if g_map_move.currentStep > 1 then
                g_map_move.currentStep = g_map_move.currentStep - 1
                print("调整-1，", g_map_move.currentStep)
            end
        end
    end
end

g_map_move["初始化"] = function()
    local mapName = map()
    if mapName ~= g_map_move.currentMap then
        g_map_move.currentMap = mapName
        g_map_move.coordinateLength = #g_map[mapName]
    end

    if self().GetItemAmountInPackage(5, 21245) < 120 and self().GetItemAmountInPackage(5, 21244) < 120 and self().GetItemAmountInPackage(5, 21246) < 120 then
        print("wait.....")
        g_map_move.currentGoods = -1
        return
    end

    if g_map_move.currentStep == -1 then
        if g_map_move.moveToNpc then
            g_map_move.currentStep = g_map_move.coordinateLength
        else
            g_map_move.currentStep = 1
        end
    end

    print("----")
    if self().GetItemAmountInPackage(5, 21245) >= 120 and mapName == "龙门荒漠" and (not g_map_move.moveToNpc or g_map_move.currentGoods ~= 21245) then
        g_map_move.moveToNpc = true
        g_map_move.currentStep = 1
        g_map_move.currentGoods = 21245
        g_map_move["最近点"]()
    elseif self().GetItemAmountInPackage(5, 21244) >= 120 and mapName == "龙门荒漠" and (g_map_move.moveToNpc or g_map_move.currentGoods ~= 21244) then
        g_map_move.moveToNpc = false
        g_map_move.currentStep = g_map_move.coordinateLength
        g_map_move.currentGoods = 21244
        g_map_move["最近点"]()
    elseif self().GetItemAmountInPackage(5, 21244) >= 120 and mapName == "马嵬驿" and (not g_map_move.moveToNpc or g_map_move.currentGoods ~= 21244) then
        g_map_move.moveToNpc = true
        g_map_move.currentStep = 1
        g_map_move.currentGoods = 21244
        g_map_move["最近点"]()
    elseif (self().GetItemAmountInPackage(5, 21245) >= 120 and mapName == "马嵬驿") and (g_map_move.moveToNpc or g_map_move.currentGoods ~= 21245) then
        g_map_move.moveToNpc = false
        g_map_move.currentStep = g_map_move.coordinateLength
        g_map_move.currentGoods = 21245
        g_map_move["最近点"]()
    elseif self().GetItemAmountInPackage(5, 21245) >= 120 and mapName == "巴陵县" and (not g_map_move.moveToNpc or g_map_move.currentGoods ~= 21245) then
        g_map_move.moveToNpc = true
        g_map_move.currentStep = 1
        g_map_move.currentGoods = 21245
        g_map_move["最近点"]()
    elseif self().GetItemAmountInPackage(5, 21246) >= 120 and mapName == "巴陵县" and (g_map_move.moveToNpc or g_map_move.currentGoods ~= 21246) then
        g_map_move.moveToNpc = false
        g_map_move.currentStep = g_map_move.coordinateLength
        g_map_move.currentGoods = 21246
        g_map_move["最近点"]()
    elseif self().GetItemAmountInPackage(5, 21246) >= 120 and mapName == "洛道" and (not g_map_move.moveToNpc or g_map_move.currentGoods ~= 21246) then
        g_map_move.moveToNpc = true
        g_map_move.currentStep = 1
        g_map_move.currentGoods = 21246
        g_map_move["最近点"]()
    elseif self().GetItemAmountInPackage(5, 21245) >= 120 and mapName == "洛道" and (g_map_move.moveToNpc or g_map_move.currentGoods ~= 21245) then
        g_map_move.moveToNpc = false
        g_map_move.currentStep = g_map_move.coordinateLength
        g_map_move.currentGoods = 21245
        g_map_move["最近点"]()
    else
        --print("???")
        --g_map_move.currentGoods = -1
    end
end

g_map_move["最近点"] = function()

    local x, y, z = pos()
    local closestCoordinateIndex = g_map_move.currentStep
    local minDistance = math.huge

    local coordinates = g_map[g_map_move.currentMap]
    for i = 1, g_map_move.coordinateLength do
        local _x, _y, _z = coordinates[i][1], coordinates[i][2], coordinates[i][3]
        local distance = math.abs(x - _x) + math.abs(y - _y) + math.abs(z - _z)
        if minDistance > distance then
            minDistance = distance
            closestCoordinateIndex = i
        end
    end

    print("最近点", closestCoordinateIndex)
    g_map_move.currentStep = closestCoordinateIndex
end

g_map_move["下一步"] = function()
    g_map_move.counter = g_map_move.counter + 1
    local x, y, z = pos()
    local coordinates = g_map[g_map_move.currentMap]
    local _x, _y, _z = coordinates[g_map_move.currentStep][1], coordinates[g_map_move.currentStep][2], coordinates[g_map_move.currentStep][3]
    if (math.abs(x - _x) < 100 and math.abs(y - _y) < 100 and math.abs(z - _z) < 500) then
        --print(coordinates[_state.index][1], coordinates[_state.index][2], coordinates[_state.index][3])
        print("下一步")
        return true
    else
        print(math.abs(x - _x), math.abs(y - _y), math.abs(z - _z))
        --if g_map_move.counter % 50 == 0 then
        --    if (math.abs(x - _x) + math.abs(y - _y) + math.abs(z - _z)) > 1000 then
        --        g_map_move["最近点"]()
        --    end
        --end

        return false
    end
end

g_map["龙门荒漠"] = {
    { 48678, 4036, 1059392 },
    { 48801, 3904, 1059456 },
    { 48801, 3904, 1059456 },
    { 48801, 3904, 1059456 },
    { 48801, 3904, 1059456 },
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

g_map["马嵬驿"] = {
    { 26914, 38195, 1236480 },
    { 26914, 38195, 1236480 },
    { 27145, 38472, 1236672 },
    { 27423, 38805, 1236992 },
    { 27712, 39196, 1237248 },
    { 28105, 39481, 1237440 },
    { 28399, 39800, 1237824 },
    { 28723, 40165, 1238592 },
    { 29063, 40525, 1239296 },
    { 29334, 40812, 1239872 },
    { 29672, 41170, 1240192 },
    { 29978, 41494, 1240704 },
    { 30315, 41851, 1241728 },
    { 30611, 42165, 1242560 },
    { 30939, 42513, 1243584 },
    { 31269, 42863, 1244736 },
    { 31562, 43174, 1245568 },
    { 31898, 43528, 1246336 },
    { 32239, 43859, 1247296 },
    { 32431, 44245, 1248320 },
    { 32646, 44670, 1249152 },
    { 32851, 45051, 1249728 },
    { 33081, 45476, 1250624 },
    { 33299, 45884, 1251584 },
    { 33594, 46155, 1251968 },
    { 33930, 46441, 1251904 },
    { 34233, 46725, 1252096 },
    { 34517, 47056, 1251584 },
    { 34788, 47449, 1251392 },
    { 34980, 47842, 1251584 },
    { 35139, 48306, 1251584 },
    { 35283, 48720, 1251776 },
    { 35443, 49180, 1251968 },
    { 35597, 49644, 1251584 },
    { 35732, 50066, 1251200 },
    { 35882, 50536, 1251072 },
    { 36037, 50947, 1251008 },
    { 36254, 51384, 1250880 },
    { 36484, 51813, 1250496 },
    { 36691, 52200, 1250304 },
    { 36921, 52630, 1250048 },
    { 37128, 53016, 1249664 },
    { 37358, 53446, 1249024 },
    { 37588, 53876, 1248384 },
    { 37790, 54265, 1247744 },
    { 37902, 54737, 1247168 },
    { 37938, 55169, 1246912 },
    { 37978, 55649, 1246528 },
    { 38018, 56122, 1246144 },
    { 38054, 56554, 1245760 },
    { 38094, 57034, 1245376 },
    { 38130, 57466, 1245120 },
    { 38161, 57946, 1244992 },
    { 38162, 58425, 1244672 },
    { 38162, 58854, 1244224 },
    { 38162, 59332, 1243776 },
    { 38162, 59764, 1243520 },
    { 38162, 60244, 1243328 },
    { 38167, 60723, 1243072 },
    { 38224, 61150, 1242752 },
    { 38403, 61598, 1242240 },
    { 38609, 61983, 1242176 },
    { 38963, 62321, 1241984 },
    { 39393, 62543, 1241792 },
    { 39780, 62746, 1241408 },
    { 40256, 62852, 1241280 },
    { 40663, 63003, 1241280 },
    { 41122, 63155, 1241280 },
    { 41601, 63215, 1241152 },
    { 42034, 63219, 1241152 },
    { 42514, 63249, 1241152 },
    { 42946, 63276, 1241152 },
    { 43438, 63288, 1241152 },
    { 43938, 63288, 1241024 },
    { 44374, 63272, 1241024 },
    { 44858, 63259, 1241088 },
    { 45284, 63267, 1241856 },
    { 45746, 63260, 1243136 },
    { 46209, 63255, 1244608 },
    { 46626, 63255, 1245632 },
    { 47104, 63255, 1246080 },
    { 47541, 63255, 1246208 },
    { 48041, 63255, 1246272 },
    { 48529, 63255, 1246272 },
    { 48961, 63255, 1246272 },
    { 49441, 63255, 1246208 },
    { 49873, 63255, 1246144 },
    { 50353, 63256, 1245888 },
    { 50764, 63265, 1244224 },
    { 51192, 63275, 1242432 },
    { 51672, 63285, 1242368 },
    { 52072, 63306, 1239808 },
    { 52424, 63324, 1237696 },
    { 52861, 63349, 1235904 },
    { 53293, 63380, 1235904 },
    { 53773, 63434, 1235904 },
    { 54205, 63520, 1235904 },
    { 54676, 63639, 1235904 },
    { 55146, 63773, 1235904 },
    { 55569, 63899, 1235904 },
    { 56040, 64035, 1235904 },
    { 56522, 64064, 1235968 },
    { 56953, 63969, 1235904 },
    { 57431, 63855, 1235904 },
    { 57854, 63720, 1235904 },
    { 58324, 63576, 1235904 },
    { 58804, 63494, 1235904 },
    { 59236, 63459, 1235904 },
    { 59716, 63429, 1235904 },
    { 60148, 63402, 1235904 },
    { 60628, 63372, 1236224 },
    { 61052, 63347, 1238208 },
    { 61441, 63351, 1240192 },
    { 61896, 63380, 1242432 },
    { 62285, 63387, 1244224 },
    { 62728, 63387, 1246400 },
    { 63165, 63387, 1248384 },
    { 63579, 63376, 1249664 },
    { 64059, 63346, 1249728 },
    { 64545, 63342, 1249664 },
    { 64995, 63342, 1249664 },
    { 65473, 63303, 1249664 },
    { 65642, 62994, 1249664 },
    { 65656, 62621, 1249664 },
    { 65586, 62234, 1249664 },
    { 65554, 62323, 1249664 }
}

g_map["巴陵县"] = {
    { 91806, 43301, 1062336 },
    { 91806, 43301, 1062336 },
    { 91806, 43301, 1062336 },
    { 91806, 43301, 1062336 },
    { 91569, 43278, 1062400 },
    { 91140, 43262, 1062528 },
    { 90791, 43107, 1062720 },
    { 90453, 42834, 1062784 },
    { 90165, 42573, 1062848 },
    { 89846, 42275, 1062656 },
    { 89509, 41999, 1062016 },
    { 89162, 41816, 1061504 },
    { 88755, 41660, 1061056 },
    { 88375, 41553, 1060672 },
    { 87945, 41454, 1060608 },
    { 87515, 41385, 1060416 },
    { 87128, 41347, 1060096 },
    { 86698, 41279, 1059712 },
    { 86311, 41216, 1059456 },
    { 85881, 41146, 1059200 },
    { 85494, 41083, 1059008 },
    { 85065, 41013, 1058880 },
    { 84635, 40959, 1058688 },
    { 84248, 40923, 1058368 },
    { 83818, 40883, 1058112 },
    { 83388, 40843, 1058112 },
    { 83001, 40807, 1057920 },
    { 82571, 40791, 1057728 },
    { 82182, 40783, 1057472 },
    { 81750, 40791, 1057280 },
    { 81322, 40801, 1057088 },
    { 80935, 40802, 1056832 },
    { 80489, 40802, 1056768 },
    { 80102, 40800, 1056832 },
    { 79672, 40783, 1056896 },
    { 79238, 40757, 1056832 },
    { 78851, 40757, 1056832 },
    { 78421, 40773, 1056896 },
    { 78034, 40791, 1056832 },
    { 77604, 40811, 1056704 },
    { 77218, 40829, 1056640 },
    { 76788, 40855, 1056640 },
    { 76358, 40931, 1056768 },
    { 75973, 41019, 1056832 },
    { 75543, 41119, 1056832 },
    { 75118, 41214, 1056768 },
    { 74733, 41302, 1056640 },
    { 74303, 41402, 1056576 },
    { 73920, 41501, 1056448 },
    { 73501, 41640, 1056256 },
    { 73081, 41776, 1056128 },
    { 72699, 41841, 1056128 },
    { 72265, 41818, 1056000 },
    { 71887, 41692, 1056064 },
    { 71469, 41552, 1055936 },
    { 71063, 41394, 1056064 },
    { 70714, 41217, 1056384 },
    { 70357, 40972, 1056320 },
    { 70054, 40725, 1056320 },
    { 69724, 40446, 1056192 },
    { 69394, 40167, 1056128 },
    { 69061, 39963, 1056320 },
    { 68686, 39746, 1056256 },
    { 68353, 39539, 1056256 },
    { 67993, 39294, 1056320 },
    { 67639, 39039, 1056256 },
    { 67305, 38835, 1056320 },
    { 66884, 38733, 1056320 },
    { 66453, 38733, 1056192 },
    { 66069, 38750, 1056320 },
    { 65682, 38786, 1056320 },
    { 65252, 38826, 1056448 },
    { 64822, 38866, 1056512 },
    { 64435, 38902, 1056384 },
    { 64006, 38942, 1056320 },
    { 63619, 39014, 1056320 },
    { 63189, 39074, 1056320 },
    { 62758, 39092, 1056256 },
    { 62371, 39059, 1056320 },
    { 61941, 39019, 1056320 },
    { 61554, 38993, 1056320 },
    { 61124, 38995, 1056448 },
    { 60695, 39034, 1056704 },
    { 60308, 39110, 1056768 },
    { 60011, 39411, 1056960 },
    { 59786, 39735, 1056896 },
    { 59557, 40088, 1056000 },
    { 59340, 40443, 1056576 },
    { 59152, 40764, 1057280 },
    { 58920, 41130, 1057600 },
    { 58665, 41483, 1057408 },
    { 58415, 41787, 1056640 },
    { 58135, 42127, 1057088 },
    { 57881, 42422, 1057536 },
    { 57588, 42740, 1057728 },
    { 57288, 43059, 1057536 },
    { 57018, 43345, 1057216 },
    { 56718, 43665, 1057088 },
    { 56448, 43953, 1057152 },
    { 56143, 44261, 1057408 },
    { 55858, 44518, 1057344 },
    { 55519, 44797, 1057600 },
    { 55183, 45074, 1057792 },
    { 54852, 45347, 1058240 },
    { 54546, 45599, 1058368 },
    { 54207, 45878, 1058624 },
    { 53906, 46130, 1058368 },
    { 53583, 46420, 1057792 },
    { 53297, 46691, 1058112 },
    { 52989, 46999, 1058432 },
    { 52684, 47313, 1058432 },
    { 52433, 47612, 1058368 },
    { 52187, 47950, 1057664 },
    { 51963, 48273, 1057856 },
    { 51714, 48632, 1057216 },
    { 51490, 48955, 1057280 },
    { 51233, 49303, 1057856 },
    { 50953, 49643, 1057792 },
    { 50676, 49980, 1057600 },
    { 50425, 50283, 1057664 },
    { 50156, 50561, 1057152 },
    { 49831, 50849, 1056960 },
    { 49494, 51104, 1057536 },
    { 49156, 51301, 1057408 },
    { 48766, 51507, 1057536 },
    { 48353, 51657, 1057600 },
    { 47977, 51782, 1057728 },
    { 47557, 51922, 1057536 },
    { 47182, 52045, 1057664 },
    { 46763, 52184, 1057728 },
    { 46344, 52321, 1057728 },
    { 45960, 52415, 1057920 },
    { 45530, 52512, 1057984 },
    { 45143, 52585, 1057984 },
    { 44713, 52665, 1057984 },
    { 44286, 52762, 1057984 },
    { 43918, 52903, 1057984 },
    { 43533, 53103, 1057984 },
    { 43197, 53373, 1058112 },
    { 42921, 53649, 1057984 },
    { 42623, 53968, 1057984 },
    { 42389, 54283, 1058048 },
    { 42129, 54632, 1057984 },
    { 42010, 54970, 1057536 },
    { 41939, 55382, 1057024 },
    { 41555, 55575, 1057024 },
    { 41168, 55638, 1057024 },
    { 40738, 55655, 1057024 },
    { 40308, 55618, 1057024 },
    { 39921, 55586, 1057088 },
    { 39500, 55675, 1057024 },
    { 39273, 55985, 1057472 },
    { 39236, 56383, 1058880 },
    { 39321, 56813, 1058880 },
    { 39411, 57200, 1058880 },
    { 39520, 57623, 1058880 },
    { 39556, 57749, 1058880 },
    { 39556, 57749, 1058880 }
}

g_map["洛道"] = {
    { 6377, 2610, 1065152 },
    { 6377, 2610, 1065152 },
    { 6461, 2903, 1064704 },
    { 6569, 3327, 1064000 },
    { 6627, 3757, 1063744 },
    { 6670, 4141, 1063424 },
    { 6690, 4569, 1062976 },
    { 6708, 4944, 1062080 },
    { 6728, 5366, 1061184 },
    { 6746, 5748, 1060416 },
    { 6768, 6169, 1059648 },
    { 6906, 6577, 1059136 },
    { 7151, 6872, 1058176 },
    { 7532, 7069, 1057472 },
    { 7957, 7113, 1056704 },
    { 8342, 7122, 1056256 },
    { 8771, 7122, 1055936 },
    { 9158, 7122, 1055808 },
    { 9603, 7122, 1055808 },
    { 9994, 7126, 1055872 },
    { 10424, 7174, 1055872 },
    { 10854, 7254, 1055808 },
    { 11240, 7326, 1055744 },
    { 11669, 7411, 1055680 },
    { 12056, 7492, 1055616 },
    { 12483, 7582, 1055552 },
    { 12913, 7672, 1055616 },
    { 13299, 7753, 1055616 },
    { 13729, 7819, 1055616 },
    { 14161, 7789, 1055616 },
    { 14506, 7614, 1055616 },
    { 14756, 7273, 1056384 },
    { 14762, 6910, 1057280 },
    { 14746, 6474, 1057280 },
    { 14629, 6071, 1056832 },
    { 14411, 5747, 1056832 },
    { 14281, 5572, 1056832 },
    { 14281, 5572, 1056832 }
}