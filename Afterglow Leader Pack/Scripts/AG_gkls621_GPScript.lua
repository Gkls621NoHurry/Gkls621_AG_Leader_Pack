local TRAIT_AG = "TRAIT_CIVILIZATION_AG_gkls621"
local LEADER_RAN = "LEADER_RAN_gkls621"
local LEADER_MOCA = "LEADER_MOCA_gkls621"
local LEADER_HIMARI = "LEADER_HIMARI_gkls621"
local LEADER_TOMOE = "LEADER_TOMOE_gkls621"
local LEADER_TSUGUMI = "LEADER_TSUGUMI_gkls621"
local ROOFTOP_INDEX = GameInfo.Buildings["BUILDING_ROOFTOP_gkls621"].Index or -1
local MONUMENT_INDEX = GameInfo.Buildings["BUILDING_MONUMENT"].Index or -1
--local OBELISK_INDEX = GameInfo.Buildings["BUILDING_OLD_GOD_OBELISK"].Index or -1
local MOCA_GOV_INDEX = GameInfo.Improvements["IMPROVEMENT_MOCA_GOV_gkls621"].Index or -1
local MOCA_DIP_INDEX = GameInfo.Improvements["IMPROVEMENT_MOCA_DIP_gkls621"].Index or -1
local ENGINEER_CLASS_INDEX = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_ENGINEER"].Index

local PLANTATION_LUXURIES :table = DB.Query("SELECT r.ResourceType FROM Improvement_ValidResources iv JOIN Resources r ON iv.ResourceType = r.ResourceType WHERE r.ResourceClassType = 'RESOURCECLASS_LUXURY' AND iv.ImprovementType = 'IMPROVEMENT_PLANTATION'") or {}

local BABANBO_CLASS_INDEX = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_BABANBO_gkls621"].Index or -1
local BABANBO_INDIVIDUAL_INDEX = GameInfo.GreatPersonIndividuals["GREAT_PERSON_INDIVIDUAL_BABANBO_gkls621"].Index or -1
local BABANBO_UNIT_INDEX = GameInfo.Units["UNIT_BABANBO_gkls621"].Index or -1
local BABANBO_REVIVAL_INDEX = GameInfo.Projects["PROJECT_BABANBO_REVIVAL_gkls621"].Index or -1
local BABANBO_STATUE_INDEX = GameInfo.Buildings["BUILDING_BABANBO_STATUE_gkls621"].Index or -1
local BABANBO_PROMOTIONS :table = {"PROMOTION_REMEDY_gkls621", "PROMOTION_VOUCHER_gkls621", "PROMOTION_MELONPAN_gkls621", "PROMOTION_GOUKOKU_gkls621", "PROMOTION_QUICKTONGUE_gkls621", "PROMOTION_TRANSFAT_gkls621", "PROMOTION_USUAL_gkls621"}

local CITY_STATE_TYPES :table = DB.Query("SELECT DISTINCT InheritFrom FROM Leaders WHERE InheritFrom LIKE '%MINOR%'")

ExposedMembers.GameEvents = GameEvents

function GklsCivTraitMatches(playerID, TraitType)
	local config = PlayerConfigurations[playerID]
	if config ~= nil then
		local CivType = config:GetCivilizationTypeName()
	    for tRow in GameInfo.CivilizationTraits() do
			if tRow.CivilizationType == CivType and tRow.TraitType == TraitType then 
				print("This game has civ trait: "..TraitType)
				return true 
			end
		end
	end
    return false
end

function GklsLeaderMatches(playerID, leaderType)
	if playerID == -1 then
		return false
	end
	local pPlayerConfig = PlayerConfigurations[playerID]
	if pPlayerConfig == nil then
		return false
	end
	if pPlayerConfig:GetLeaderTypeName() == leaderType then
		print("GklsLeaderMatches("..playerID.." "..leaderType..")")
		return true
	end
	print("GklsLeaderMatches("..playerID.." "..leaderType..") find it unmatchable")
	return false
end

function Vanilla_RuivoGetRingPlotIndexes(iX, iY, maxRing)
    --print("Vanilla_RuivoGetRingPlotIndexes( "..iX.." , "..iY.." , "..maxRing..") starts")
    local resultPlotIndex = {}   -- 存储最终结果的格子索引列表
    local visited = {}           -- 标记已经访问过的格子，防止重复访问
    local queue = {}             -- 用于广度优先搜索的队列（FIFO）

    local centerPlot = Map.GetPlot(iX, iY)  -- 获取中心格对象
    if not centerPlot then return resultPlotIndex end  -- 如果中心格无效，返回空结果

    local centerIndex = centerPlot:GetIndex()  -- 获取中心格的索引
    visited[centerIndex] = true                -- 标记中心格为已访问
    table.insert(resultPlotIndex, centerIndex) -- 加入结果列表
    table.insert(queue, centerIndex)           -- 加入队列，开始BFS搜索

    -- 广度优先搜索，逐层扩展格子
    while #queue > 0 do
        local currentIndex = table.remove(queue, 1)        -- 取出当前处理的格子索引
        local plot = Map.GetPlotByIndex(currentIndex)      -- 获取对应格子对象
        local dist = Map.GetPlotDistance(iX, iY, plot:GetX(), plot:GetY()) -- 计算该格子与中心格的距离

        -- 如果该格子在 maxRing 范围内，继续扩展它的相邻格子
        if dist < maxRing then
            local adjPlots = Map.GetAdjacentPlots(plot:GetX(), plot:GetY()) -- 获取相邻格子
            for _, adj in ipairs(adjPlots) do
                if adj then
                    local adjIndex = adj:GetIndex()  -- 获取相邻格子的索引
                    if not visited[adjIndex] then   -- 如果未访问过
                        visited[adjIndex] = true    -- 标记为已访问
                        table.insert(resultPlotIndex, adjIndex) -- 加入结果列表
                        --print(adjIndex.." inserted into all plots within "..maxRing)
                        table.insert(queue, adjIndex)           -- 加入队列以便后续扩展
                    end
                end
            end
        end
    end

    return resultPlotIndex  -- 返回所有在 maxRing 范围内的格子索引
end

function GklsAGOnPlayerEraChanged(playerID, eraID)
    if not (GklsCivTraitMatches(playerID, TRAIT_AG)) then return; end
    local eraString = GameInfo.Eras[eraID].EraType
    local pPlayer = Players[playerID]
    if pPlayer == nil or eraID == 0 then return; end
    local pPlayerCities = pPlayer:GetCities()
    for _,pCity in ipairs(pPlayerCities) do
        if pCity ~= nil then
            if pCity:GetBuildings():HasBuilding(MONUMENT_INDEX) then
                pCity:AttachModifierByID("AG_MONUMENT_FAITH_gkls621")
                --pPlayer:AttachModifierByID("AG_MONUMENT_INFLUENCE_gkls621")
                --pPlayer:AttachModifierByID("AG_MONUMENT_FAVOR_gkls621")
                print("AG player "..playerID.." entered new era, monuments' faith increased")
            elseif #(DB.Query("SELECT 1 FROM Buildings WHERE BuildingType = 'BUILDING_OLD_GOD_OBELISK'") or {})>0 then
                local OBELISK_INDEX = GameInfo.Buildings["BUILDING_OLD_GOD_OBELISK"].Index or -1
                if pCity:GetBuildings():HasBuilding(OBELISK_INDEX) then
                    pCity:AttachModifierByID("AG_MONUMENT_FAITH_gkls621")
                    print("AG player "..playerID.." entered new era, OBELISKS' faith increased")
                    --pPlayer:AttachModifierByID("AG_MONUMENT_INFLUENCE_gkls621")
                    --pPlayer:AttachModifierByID("AG_MONUMENT_FAVOR_gkls621")
                end
            end
        end
    end
    pPlayer:AttachModifierByID("AG_"..eraString.."_EUREKAS_gkls621")
    pPlayer:AttachModifierByID("AG_"..eraString.."_INSPIRATIONS_gkls621")
    print("AG player "..playerID.." entered new era, eurekas and inspirations")
end

function GklsAGAttachClassicalDedication(previousEra, newEra)
    if newEra ~= GameInfo.Eras["ERA_MEDIEVAL"].Index then return; end
    for _, pPlayer in ipairs(PlayerManager.GetAliveMajors()) do
        local playerID = pPlayer:GetID()
        if GklsCivTraitMatches(playerID, TRAIT_AG) then
            local classic = pPlayer:GetProperty("AG_CLASSICAL_DEDICATION") or -1
            if classic ~= -1 then
                local commemorationType = GameInfo.CommemorationTypes[classic].CommemorationType
                local modifierList :table = DB.Query("SELECT ModifierId FROM CommemorationModifiers WHERE CommemorationType = '"..commemorationType.."'")
                if (modifierList ~= nil) and (#modifierList > 0) then
                    for _, iModifier in ipairs(modifierList) do
                        pPlayer:AttachModifierByID(iModifier.ModifierId)
                        print("AG player "..playerID.." get attached classical dedication modifier "..iModifier.ModifierId)
                    end
                end
            end
        end
    end
end

function GklsAGOnRooftopBuilt(iX, iY, buildingID, playerID)
    if (buildingID == -1) or (playerID == -1) then return; end
    if not(GklsCivTraitMatches(playerID, TRAIT_AG)) then return; end
    if buildingID ~= ROOFTOP_INDEX then return; end
    local visPlots = Vanilla_RuivoGetRingPlotIndexes(iX, iY, 10)
    local visibility = PlayersVisibility[playerID]
    for _,plotIndex in ipairs(visPlots) do
        visibility:ChangeVisibilityCount(plotIndex, 1)
    end
    print("Rooftop built in "..iX.." "..iY)
end

--[[ function GklsRanMeetDecreaseAmenity(player1ID, player2ID)
    if GklsLeaderMatches(player1ID, LEADER_RAN) and Players[player2ID]:IsMajor() then
        local pPlayer = Players[player1ID] 
        pPlayer:AttachModifierByID("RAN_CAPITAL_AMENITY_SUBTRACT_gkls621")
        local NumOfMet = pPlayer:GetProperty("MAJORS_RAN_MET") or 0
        if NumOfMet % 2  == 1 then
            pPlayer:SetProperty("MAJORS_RAN_MET", NumOfMet+1)
        end
        
    end
    if GklsLeaderMatches(player2ID, LEADER_RAN) and Players[player1ID]:IsMajor() then
        local pPlayer = Players[player2ID] 
        pPlayer:AttachModifierByID("RAN_CAPITAL_AMENITY_SUBTRACT_gkls621")
        local NumOfMet = pPlayer:GetProperty("MAJORS_RAN_MET") or 0
        if NumOfMet %2 == 1 then
            pPlayer:SetProperty("MAJORS_RAN_MET", NumOfMet+1)
        end
        
    end
end ]]

function GklsRanSetWearinessProperty(playerID, sum)
    if (playerID == -1) then return; end
    local pPlayer = Players[playerID]
    if (pPlayer == nil) then return; end
    local result = math.floor(sum)
    if result > 200 then result = 200; end
    for i, pUnit in pPlayer:GetUnits():Members() do
        if (pUnit ~= nil) and (pUnit:GetCombat() > 0) then 
            if not(pUnit:IsDead() or pUnit:IsDelayedDeath()) then
                pUnit:SetProperty("RAN_WAR_WEARINESS_PROPERTY", result)
            end
        end
    end
end

local IkebanaCompletedSwitch = false
function GklsRanIkebanaPlantLuxury(playerID, districtID, cityID, iX, iY, districtType, era, civilization, iPercentComplete, iAppeal, isPillaged)
    if (iPercentComplete ~= 100) then return; end
    if (playerID == -1) or (cityID == -1) then return; end
    --if not(GklsLeaderMatches(playerID, LEADER_RAN)) then return; end
    local IKEBANA_INDEX = GameInfo.Districts["DISTRICT_IKEBANA_FAMILY_gkls621"].Index or -1
    if (IKEBANA_INDEX == -1) or (districtType ~= IKEBANA_INDEX) then return; end

    local pCity = CityManager.GetCity(playerID, cityID)
    local HasIkebana = pCity:GetProperty("CITY_HAS_IKEBANA") or 0
    if (HasIkebana ~= 0) then return; end
    pCity:SetProperty("CITY_HAS_IKEBANA", 1)

    if IkebanaCompletedSwitch then
        IkebanaCompletedSwitch = false
        return
    end
    IkebanaCompletedSwitch = true 

    UnitManager.InitUnitValidAdjacentHex(playerID, "UNIT_FELLOW_GANG_gkls621", iX, iY, 1)

    local pPlot = Map.GetPlot(iX, iY)
    local adjPlots = Map.GetAdjacentPlots(pPlot:GetX(), pPlot:GetY())

    --local i = 0
    for _, adj in ipairs(adjPlots) do
        if (adj:GetResourceType() == -1) and (adj:GetDistrictType() == -1) and (adj:GetImprovementType() == -1) then
            if (not adj:IsImpassable()) and (not adj:IsNaturalWonder()) and (not adj:IsWater()) then
                local flag = 0
                --local times = 0
                while (flag ~= 1) do
                    --times = times + 1
                    local seed = Game.GetRandNum(#PLANTATION_LUXURIES, "A CERTAIN TYPE OF LUXURY TO BE ADDED")
                    local resourceIndex = GameInfo.Resources[PLANTATION_LUXURIES[seed].ResourceType].Index
                    --if ResourceBuilder.CanHaveResource(adj, resourceIndex) then
                    ResourceBuilder.SetResourceType(adj, resourceIndex, 1)
                    adj:SetOwner(-1)
                    adj:SetOwner(playerID)
                    print(resourceIndex.." planted at "..adj:GetIndex())
                    --i = i + 1
                    flag = 1
                    --if (i >= 2) then return; end
                    --end
                end
            end
        end
    end
end

function GklsMocaOnImprovementBuilt(PlotX, PlotY, ImprovementID, playerID, ResourceID, Unknown1, Unknown2)
    if not(GklsLeaderMatches(playerID, LEADER_MOCA)) then return;end
    if (ImprovementID == MOCA_GOV_INDEX) then
        local iPlot = Map.GetPlot(PlotX, PlotY)
		local pCity = Cities.GetPlotPurchaseCity(iPlot)
		--ImprovementBuilder.SetImprovementType(iPlot, -1, 0)
		pCity:GetBuildQueue():CreateDistrict(GameInfo.Districts["DISTRICT_GOVERNMENT"].Index, iPlot)
	end
    if (ImprovementID == MOCA_DIP_INDEX) then
        local iPlot = Map.GetPlot(PlotX, PlotY)
		local pCity = Cities.GetPlotPurchaseCity(iPlot)
		--ImprovementBuilder.SetImprovementType(iPlot, -1, 0)
		pCity:GetBuildQueue():CreateDistrict(GameInfo.Districts["DISTRICT_DIPLOMATIC_QUARTER"].Index, iPlot)
	end
end
--------------------
--BABANBO PART
--------------------
-- Babanbo Design Acknowledgement: Gilgamesh's Enkidu from Harmony in Diversity
function GklsMocaGetBabanbo(playerID, cityID, iX, iY)
    if not (GklsLeaderMatches(playerID, LEADER_MOCA)) then return; end
    local pPlayer = Players[playerID]
    local CapitalSettled = pPlayer:GetProperty("MOCA_CAPITAL_SETTLED") or 0
    if CapitalSettled == 1 then return; end
    local era = Game.GetEras():GetCurrentEra();
	Game.GetGreatPeople():GrantPerson(BABANBO_INDIVIDUAL_INDEX, BABANBO_CLASS_INDEX, era, 0, playerID, false);
    print("Moca player "..playerID.." granted Babanbo Sama!")
    pPlayer:SetProperty("MOCA_CAPITAL_SETTLED", 1)
    for i, pUnit in pPlayer:GetUnits():Members() do
        if (pUnit ~= nil) then
            if not(pUnit:IsDead() or pUnit:IsDelayedDeath()) then
                if (pUnit:GetType() == BABANBO_UNIT_INDEX) then
                    local exp = pUnit:GetExperience():GetExperienceForNextLevel()
                    pUnit:GetExperience():ChangeExperience()
                end
            end
        end
    end
end

function GklsMocaReviveBabanbo(playerID, cityID, projectID, buildingIndex, iX, iY, bCancelled)
    if (projectID == -1) or (cityID == -1) then return; end
    if not(GklsLeaderMatches(playerID, LEADER_MOCA)) then return; end
    if projectID == BABANBO_REVIVAL_INDEX then
        local era = Game.GetEras():GetCurrentEra();
	    Game.GetGreatPeople():GrantPerson(BABANBO_INDIVIDUAL_INDEX, BABANBO_CLASS_INDEX, era, 0, playerID, false);
        local pPlayer = Players[playerID]
        local capital = pPlayer:GetCities():GetCapitalCity()
        --local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
        -- Remove Babanbo Statue
        --[[ if capital:GetBuildings():HasBuilding(BABANBO_STATUE_INDEX) then
            capital:GetBuildings():RemoveBuilding(BABANBO_STATUE_INDEX)
        end ]]
        print("Babanbo Sama revived by Moca player "..playerID)
        local promotionFlag = 0
        for i, pUnit in pPlayer:GetUnits():Members() do
            if (pUnit ~= nil) then
                if not(pUnit:IsDead() or pUnit:IsDelayedDeath()) then
                    if (pUnit:GetType() == BABANBO_UNIT_INDEX) then
                        local ClassesGet = pPlayer:GetProperty("MOCA_CLASSES_OF_GREAT_PERSON") or 0                    
                        pUnit:SetProperty("MOCA_GREAT_PERSON_TYPES", 12*(ClassesGet))
                        for _, promotionType in ipairs(BABANBO_PROMOTIONS) do
                            promotionFlag = pPlayer:GetProperty("MOCA_BABANBO_HAS_"..promotionType) or 0
                            if promotionFlag == 1 then
                                pUnit:GetExperience():SetPromotion(GameInfo.UnitPromotions["PROMOTION_VOUCHER_gkls621"].Index)
                            end
                        end
                    end
                end
            end
        end
    end
end

function GklsMocaTransitBabanboStatue(iX, iY, buildingID, playerID, misc2, misc3)
    -- Move the Babanbo Statue if Moca lost capital
    if GklsLeaderMatches(playerID, LEADER_MOCA) and (buildingID == GameInfo.Buildings["BUILDING_PALACE"].Index) then
        --if (ExposedMembers.GklsAG.GklsAGIsOriginalCapital(oldPlayerID, newCityID)) then
        local pOldPlayer = Players[playerID]
        local IsFirstPalace = pOldPlayer:GetProperty("MOCA_IS_FIRST_PALACE") or 0
        if (IsFirstPalace == 0) then return;
        else pOldPlayer:SetProperty("MOCA_IS_FIRST_PALACE", 1); end
        local capital = pOldPlayer:GetCities():GetCapitalCity()
        capital:GetBuildQueue():CreateBuilding(BABANBO_STATUE_INDEX)            
        --end
    end
end

function GklsMocaExtraGPPlusBabanboStrength(playerID, unitID, unitGreatPersonClassID, unitGreatPersonID)
    if (not GklsLeaderMatches(playerID, LEADER_MOCA)) then return; end
    if (unitGreatPersonClassID == BABANBO_CLASS_INDEX) then return; end
    local pPlayer = Players[playerID]
    local HasGetThisClass = pPlayer:GetProperty("MOCA_HAS_"..unitGreatPersonClassID) or 0
    local ClassesGet = pPlayer:GetProperty("MOCA_CLASSES_OF_GREAT_PERSON") or 0
    if (HasGetThisClass ~= 1) then
        if (GameInfo.GreatPersonClasses[unitGreatPersonClassID].MaxPlayerInstances == nil) or (GameInfo.GreatPersonClasses[unitGreatPersonClassID].MaxPlayerInstances > 1) then
            pPlayer:AttachModifierByID("MOCA_GRANT_EXTRA_"..GameInfo.GreatPersonClasses[unitGreatPersonClassID].GreatPersonClassType.."_gkls621")
        end
        pPlayer:SetProperty("MOCA_HAS_"..unitGreatPersonClassID, 1)
        pPlayer:SetProperty("MOCA_CLASSES_OF_GREAT_PERSON", ClassesGet +1)
        for i, pUnit in pPlayer:GetUnits():Members() do
            if (pUnit ~= nil) then
                if not(pUnit:IsDead() or pUnit:IsDelayedDeath()) then
                    if (pUnit:GetType() == BABANBO_UNIT_INDEX) then
                        pUnit:SetProperty("MOCA_GREAT_PERSON_TYPES", 6*(ClassesGet +1))
                    end
                end
            end
        end
    end
end

-- Reference: Pen's Firefly
function GklsMocaBabanboCombat(pCombatResult)
    local attacker			= pCombatResult[CombatResultParameters.ATTACKER]
	local defender			= pCombatResult[CombatResultParameters.DEFENDER]
	local attackeradvance 	= pCombatResult[CombatResultParameters.ATTACKER_ADVANCES] --近战攻击为true
	
	local atkplayerID       = attacker[CombatResultParameters.ID].player
	local attUnitID 		= attacker[CombatResultParameters.ID].id
	local attUnitFDT		= attacker[CombatResultParameters.FINAL_DAMAGE_TO]
	local attUnit 			= UnitManager.GetUnit(atkplayerID, attUnitID)

	local defplayerID       = defender[CombatResultParameters.ID].player
	local defUnitID 		= defender[CombatResultParameters.ID].id
	local defUnitFDT 		= defender[CombatResultParameters.FINAL_DAMAGE_TO]
	local defUnit 			= UnitManager.GetUnit(defplayerID, defUnitID)
    if not GklsLeaderMatches(atkplayerID, LEADER_MOCA) then return; end
    local pUnit = UnitManager.GetUnit(atkplayerID, attUnitID)
    if (pUnit:GetType() ~= BABANBO_UNIT_INDEX) then return; end
    if not pUnit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_VOUCHER_gkls621"].Index) then return; end
    local pPlayer = Players[atkplayerID]
    local amount = math.abs(attUnitFDT) + math.abs(defUnitFDT)
    pPlayer:GetReligion():ChangeFaithBalance(amount)
    Game.AddWorldViewText(atkplayerID, '[COLOR:ResFaithLabelCS]+' .. tostring(amount) .. '[ENDCOLOR][ICON_Faith]', pUnit:GetX(), pUnit:GetY())
    pPlayer:GetCulture():ChangeCurrentCulturalProgress(amount)
    Game.AddWorldViewText(atkplayerID, '[COLOR:ResCultureLabelCS]+' .. tostring(amount) .. '[ENDCOLOR][ICON_Culture]', pUnit:GetX(), pUnit:GetY())
end

function GklsMocaBabanboOnUnitKilled(killedPlayerID, killedUnitID, playerID, unitID)
    if GklsLeaderMatches(playerID, LEADER_MOCA) then
        local pUnit = UnitManager.GetUnit(playerID, unitID)
        if (pUnit:GetType() == BABANBO_UNIT_INDEX) then
            -- Melonpan Part
            if pUnit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_MELONPAN_gkls621"].Index) then
                local LAST_TURN = Players[playerID]:GetProperty("BABANBO_MELONPAN_LAST_TURN") or -10
                local currentTurn = Game.GetCurrentGameTurn()
                if (currentTurn - LAST_TURN >= 5) then 
                    for _, plotIndex in ipairs(Vanilla_RuivoGetRingPlotIndexes(pUnit:GetX(), pUnit:GetY(), 3)) do
                        local pPlot = Map.GetPlotByIndex(plotIndex)
                        if pPlot == nil then return; end
                        if pPlot:IsUnit() then
                            for _, expUnit in ipairs(Units.GetUnitsInPlot(pPlot)) do
                                if expUnit and (expUnit:GetOwner() == playerID) and (expUnit:GetType() ~= BABANBO_UNIT_INDEX) then
                                    local exp = expUnit:GetExperience():GetExperienceForNextLevel()
                                    expUnit:GetExperience():ChangeExperience()
                                end
                            end
                        end
                    end
                    Players[playerID]:SetProperty("BABANBO_MELONPAN_LAST_TURN", currentTurn)
                end
            end
            -- Quick-Tongue Part1
            if pUnit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_QUICKTONGUE_gkls621"].Index) then
                local pPlayer = Players[playerID]
                pPlayer:GetInfluence():ChangeTokensToGive(1)
                Game.AddWorldViewText(playerID, '[COLOR:RED] +1 [ICON_Envoy] [ENDCOLOR]', pUnit:GetX(), pUnit:GetY())
            end
        end
    end
    
    if GklsLeaderMatches(killedPlayerID, LEADER_MOCA) then
        local killedUnit = UnitManager.GetUnit(killedPlayerID, killedUnitID)
        if (killedUnit:GetType() == BABANBO_UNIT_INDEX) then
            -- Create Babanbo Statue
            local killedPlayer = Players[killedPlayerID]
            local capital = killedPlayer:GetCities():GetCapitalCity()
            --local capitalPlot = Map.GetPlot(capital:GetX(), capital:GetY())
            capital:GetBuildQueue():CreateBuilding(BABANBO_STATUE_INDEX)
            -- Save Babanbo's current promotions
            for _,promotionType in ipairs(BABANBO_PROMOTIONS) do
                if killedUnit:GetExperience():HasPromotion(GameInfo.UnitPromotions[promotionType].Index) then
                    killedPlayer:SetProperty("MOCA_BABANBO_HAS_"..promotionType, 1)
                    -- Usual Part
                    if promotionType == "PROMOTION_USUAL_gkls621" then
                        killedPlayer:AttachModifierByID("ANGKORWAT_ADDPOPULATION")
                        killedPlayer:AttachModifierByID("ANGKORWAT_ADDHOUSING")
                        killedPlayer:AttachModifierByID("MOCA_BABANBO_USUAL_POPULATION_PRODUCTION_gkls621")
                        killedPlayer:AttachModifierByID("MOCA_BABANBO_USUAL_CITIES_AMENITY_gkls621")
                        Game.AddWorldViewText(killedPlayerID, '[COLOR:Red]'.. Locale.Lookup('LOC_GREAT_PERSON_CLASS_BABANBO_gkls621_NAME') .. ':' .. Locale.Lookup('LOC_PROMOTION_USUAL_gkls621_NAME') .. '[ENDCOLOR]', killedUnit:GetX(), killedUnit:GetY())
                    end
                end
            end
        end
    end
end

function GklsMocaBabanboOnCityConquered(newPlayerID, oldPlayerID, newCityID, iX, iY)
    if GklsLeaderMatches(newPlayerID, LEADER_MOCA) then
        local pPlot = Map.GetPlot(iX, iY) 
        if (pPlot ~= nil) and (pPlot:IsUnit()) then
            -- Quick-Tongue Part2
            for _, pUnit in ipairs(Units.GetUnitsInPlot(pPlot)) do
                if (pUnit:GetType() == BABANBO_UNIT_INDEX) then
                    if pUnit:GetExperience():HasPromotion(GameInfo.UnitPromotions["PROMOTION_QUICKTONGUE_gkls621"].Index) then
                        local pPlayer = Players[newPlayerID]
                        pPlayer:GetGovernors():ChangeGovernorPoints(1)
                        pPlayer:GetGovernors():ChangeGovernorPoints(1)
                        Game.AddWorldViewText(playerID, '[COLOR:RED] +2 [ICON_Governor] [ENDCOLOR]', pUnit:GetX(), pUnit:GetY())
                        pPlayer:AttachModifierByID("GOODY_SCIENCE_GRANT_ONE_TECH")
                    end
                end
            end
        end
    end
    -- Remove the Babanbo Statue if Moca's capital was this city
    local pNewCity = CityManager.GetCityAt(iX, iY)
    if (pNewCity ~= nil) then
        if pNewCity:GetBuildings():HasBuilding(BABANBO_STATUE_INDEX) then
            pNewCity:GetBuildings():RemoveBuilding(BABANBO_STATUE_INDEX)
        end
    end
end

function GklsHimariOnCityPopulationChanged(cityOwner, cityID, ChangeAmount)
    if GklsLeaderMatches(cityOwner, LEADER_HIMARI) then
        if ChangeAmount >= 0 then return; end
        local pPlayer = Players[cityOwner]
        local pCity = CityManager.GetCity(cityOwner, cityID)
        if pCity == nil then return; end
        for i = 1, (-1)*ChangeAmount, 1 do
            pCity:AttachModifierByID("HIMARI_CITY_INDUSTRY_PRODUCTION_BONUS_gkls621")
            pCity:AttachModifierByID("HIMARI_CITY_INDUSTRY_GOLD_BONUS_gkls621")
            pCity:AttachModifierByID("HIMARI_CITY_INDUSTRY_FAITH_BONUS_gkls621")
            pCity:AttachModifierByID("HIMARI_CITY_INDUSTRY_SCIENCE_BONUS_gkls621")
            pCity:AttachModifierByID("HIMARI_CITY_INDUSTRY_CULTURE_BONUS_gkls621")
            pCity:AttachModifierByID("HIMARI_CITY_INDUSTRY_FOOD_BONUS_gkls621")
        end
        local totalBonus = pPlayer:GetProperty("HIMARI_POPULATION_LOSS_BONUS") or 0
        pPlayer:SetProperty("HIMARI_POPULATION_LOSS_BONUS", (-1)*ChangeAmount + totalBonus)
        Game.AddWorldViewText(cityOwner, '[COLOR:ResProductionLabelCS] +'..tostring(((-1)*ChangeAmount + totalBonus)*100).."% "..Locale.Lookup("LOC_HIMARI_POPULATION_LOSS_BONUS").."[ENDCOLOR]", pCity:GetX(), pCity:GetY())
        print("Himari lost "..ChangeAmount.." residents in "..cityID.." but gain adjacency.")
    end
end

function GklsHimariOnEngineerActivated(unitOwner, unitID, greatPersonClassID, greatPersonIndividualID)
    if not(GklsLeaderMatches(unitOwner, LEADER_HIMARI)) then return; end
    if (greatPersonClassID ~= ENGINEER_CLASS_INDEX) then return; end
    local pPlayer = Players[unitOwner]
    local totalBonus = pPlayer:GetProperty("HIMARI_ENGINEER_TIMES") or 0
    pPlayer:SetProperty("HIMARI_ENGINEER_TIMES", totalBonus +1)
    print("Himari activated engineer "..GameInfo.GreatPersonIndividuals[greatPersonIndividualID].GreatPersonIndividualType)
end

function GklsHimariGrantEngineerPoint(playerID)
    local pPlayer = Players[playerID]
    --local ENGINEER_CLASS_INDEX = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_ENGINEER"].Index
    local reward = 50
    pPlayer:GetGreatPeoplePoints():ChangePointsTotal(ENGINEER_CLASS_INDEX, reward)
end

function GklsTomoeGenerateGoodyHut (playerID, location:table)
    --if not (GklsLeaderMatches(playerID, LEADER_TOMOE)) then return; end
    local seed = Game.GetRandNum(100, "WHETHER THIS CREATES A NEW GOODY HUT REMAINS UNCERTAIN")
    if (seed < 50) then return; end
    local resultPlotIndex =  Vanilla_RuivoGetRingPlotIndexes(location.x, location.y, 6)
    local goodyIndex = GameInfo.Improvements["IMPROVEMENT_GOODY_HUT"].Index
    for _, plotIndex in ipairs(resultPlotIndex) do
        local pPlot = Map.GetPlotByIndex(plotIndex)
        
        --if  (not pPlot:IsOwned()) and (pPlot:GetImprovementType() ~= -1) and (ImprovementBuilder.CanHaveImprovement(pPlot, goodyIndex, -1)) then
        if GklsAGCanPlaceGoodyAt(pPlot) then
            ImprovementBuilder.SetImprovementType(pPlot, goodyIndex, -1)
            print("Taiko Team: Goody Hut generated at "..location.x.." "..location.y)
            break;
        end
    end
end

function GklsAGCanPlaceGoodyAt(plot)

	--local improvementID = improvement.RowId - 1;
    local improvementID = GameInfo.Improvements["IMPROVEMENT_GOODY_HUT"].Index
	local NO_TEAM = -1;
	local NO_RESOURCE = -1;
	local NO_IMPROVEMENT = -1;

    if (plot:IsOwned()) then return false; end

	if (plot:IsWater()) then
		return false;
	end

	if (not ImprovementBuilder.CanHaveImprovement(plot, improvementID, NO_TEAM)) then
		return false;
	end
	

	if (plot:GetImprovementType() ~= NO_IMPROVEMENT) then
		return false;
	end

	if (plot:GetResourceType() ~= NO_RESOURCE) then
		return false;
	end

	if (plot:IsImpassable()) then
		return false;
	end

	if (plot:IsMountain()) then
		return false;
	end

    return true;
end

function GklsTomoeGainYieldOnUnitKilled(killedPlayerID, killedUnitID, playerID, unitID)
    if GklsLeaderMatches(playerID, LEADER_TOMOE) then
        local pPlayer = Players[playerID]
        for _, tRow in ipairs(CITY_STATE_TYPES) do
            --[[ if GklsAGGetSuzerainTypeNum(playerID, tRow.InheritFrom) >= 1 then
                if tRow.InheritFrom == "LEADER_MINOR_CIV_SCIENTIFIC" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_SCIENCE_gkls621")
                    print("Tomoe: Yield from scientific state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CULTURAL" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_CULTURE_gkls621")
                    print("Tomoe: Yield from cultural state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_RELIGIOUS" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_FAITH_gkls621")
                    print("Tomoe: Yield from religious state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_TRADE" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_GOLD_gkls621")
                    print("Tomoe: Yield from commercial state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_INDUSTRIAL" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_PRODUCTION_gkls621")
                    print("Tomoe: Yield from industrial state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_MILITARISTIC" then
                    print("Tomoe: Yield from militaristic state!")
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_PRODUCTION_gkls621")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CSE_AGRICULTURAL" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_FOOD_gkls621")
                    print("Tomoe: Yield from agricultural state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CSE_MARITIME" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_FOOD_gkls621")
                    print("Tomoe: Yield from maritime state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CSE_ENTERTAINMENT" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_AMENITY_gkls621")
                    print("Tomoe: Yield from entertainment state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CSE_CONSULAR" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_FAVOR_gkls621")
                    print("Tomoe: Yield from consular state!")
                end
            end ]]
            if GklsAGGetSuzerainTypeNum(playerID, tRow.InheritFrom) > 1 then
                if tRow.InheritFrom == "LEADER_MINOR_CIV_SCIENTIFIC" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_SCIENCE_gkls621")
                    print("Tomoe: EXTRA Yield from scientific state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CULTURAL" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_CULTURE_gkls621")
                    print("Tomoe: EXTRA Yield from cultural state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_RELIGIOUS" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_FAITH_gkls621")
                    print("Tomoe: EXTRA Yield from religious state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_TRADE" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_GOLD_gkls621")
                    print("Tomoe: EXTRA Yield from commercial state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_INDUSTRIAL" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_PRODUCTION_gkls621")
                    print("Tomoe: EXTRA Yield from industrial state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_MILITARISTIC" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_PRODUCTION_gkls621")
                    print("Tomoe: EXTRA Yield from militaristic state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CSE_AGRICULTURAL" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_FOOD_gkls621")
                    print("Tomoe: EXTRA Yield from agricultural state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CSE_MARITIME" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_FOOD_gkls621")
                    print("Tomoe: EXTRA Yield from maritime state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CSE_ENTERTAINMENT" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_AMENITY_gkls621")
                    print("Tomoe: EXTRA Yield from entertainment state!")
                elseif tRow.InheritFrom == "LEADER_MINOR_CIV_CSE_CONSULAR" then
                    pPlayer:AttachModifierByID("TOMOE_CAPITAL_FAVOR_gkls621")
                    print("Tomoe: EXTRA Yield from consular state!")
                end
            end
        end
    end
end

function GklsTomoeGoodyHutEnvoy(playerID, unitID, iUnknown1, iUnknown2)
    if (GklsLeaderMatches(playerID, LEADER_TOMOE)) then
        local pPlayer = Players[playerID]
        pPlayer:AttachModifierByID("GOODY_DIPLOMACY_GRANT_ENVOY")
    end
end

function GklsTomoeSetSuzerainty(playerID, cityStatePlayerID, numTokens)
    local pPlayer = Players[playerID]
    local pInfluence = pPlayer:GetInfluence()
    for i = 1, numTokens, 1 do
        pInfluence:GiveFreeTokenToPlayer(cityStatePlayerID)
    end
    print(tostring(numTokens).." Tomoe envoys to city-state "..playerID)
end

function GklsAGGetSuzerainTypeNum(playerID, cityStateType :string)
    local pPlayer = Players[playerID]
    local num = pPlayer:GetProperty("AG_SUZERAIN_NUM_OF_"..cityStateType) or 0
    print("GklsAGGetSuzerainTypeNum("..playerID..", "..cityStateType..") = "..num)
    return num
end

function GklsTsugumiCaffeGrantBuilder(playerID, iX, iY)
    if (playerID == -1) or (iX == -1) or (iY == -1) then return; end
    UnitManager.InitUnitValidAdjacentHex(playerID, "UNIT_BUILDER", iX, iY, 2)
end

function GklsAGSetPlayerProperty(playerID:number, kParam:table)
    if (playerID == -1) or (kParam == nil) then return; end
    print("GklsAGSetPlayerProperty processing "..kParam.propertyString)
    local pPlayer = Players[playerID]
    pPlayer:SetProperty(kParam.propertyString, kParam.value)
end

function GklsAGInitialise()
    Events.PlayerEraChanged.Add(GklsAGOnPlayerEraChanged)
    Events.GameEraChanged.Add(GklsAGAttachClassicalDedication)
    Events.BuildingAddedToMap.Add(GklsAGOnRooftopBuilt)
    --Events.DiplomacyMeet.Add(GklsRanMeetDecreaseAmenity)
    Events.DistrictBuildProgressChanged.Add(GklsRanIkebanaPlantLuxury)
    Events.ImprovementAddedToMap.Add(GklsMocaOnImprovementBuilt)
    Events.CityAddedToMap.Add(GklsMocaGetBabanbo)
    Events.CityProjectCompleted.Add(GklsMocaReviveBabanbo)
    Events.BuildingAddedToMap.Add(GklsMocaTransitBabanboStatue)
    Events.UnitGreatPersonCreated.Add(GklsMocaExtraGPPlusBabanboStrength)
    Events.Combat.Add(GklsMocaBabanboCombat)
    Events.UnitKilledInCombat.Add(GklsMocaBabanboOnUnitKilled)
    GameEvents.CityConquered.Add(GklsMocaBabanboOnCityConquered)
    GameEvents.OnCityPopulationChanged.Add(GklsHimariOnCityPopulationChanged)
    Events.UnitGreatPersonActivated.Add(GklsHimariOnEngineerActivated)
    Events.UnitKilledInCombat.Add(GklsTomoeGainYieldOnUnitKilled)
    Events.GoodyHutReward.Add(GklsTomoeGoodyHutEnvoy)


    GameEvents.GklsAGSetPlayerProperty.Add(GklsAGSetPlayerProperty)
    GameEvents.GklsAGSetPlotProperty.Add(function(plotIndex, key, value)
        local pPlot = Map.GetPlotByIndex(plotIndex)
        --  print(pPlot:GetX(), pPlot:GetY(), pPlot)
        pPlot:SetProperty(key, value);
    end)
    GameEvents.GklsAGSetCityProperty.Add(function(playerID, cityID, key, value)
        local pCity = CityManager.GetCity(playerID, cityID)
        pCity:SetProperty(key, value);
    end)
    GameEvents.GklsRanSetWearinessProperty.Add(GklsRanSetWearinessProperty)
    GameEvents.GklsHimariGrantEngineerPoint.Add(GklsHimariGrantEngineerPoint)
    GameEvents.GklsTomoeGenerateGoodyHut.Add(GklsTomoeGenerateGoodyHut)
    GameEvents.GklsTomoeSetSuzerainty.Add(GklsTomoeSetSuzerainty)
    GameEvents.GklsTsugumiCaffeGrantBuilder.Add(GklsTsugumiCaffeGrantBuilder)

    --[[ PLANTATION_LUXURIES = DB.Query("SELECT iv.ResourceType FROM Improvement_ValidResources iv"..
    "JOIN Resources r"..
    "WHERE iv.ResourceType = r.ResourceType AND r.ResourceClassType = 'RESOURCECLASS_LUXURY' AND iv.ImprovementType = 'IMPROVEMENT_PLANTATION'")
    for _, tRow in ipairs(tQuery) do
        table.insert(PLANTATION_LUXURIES, tRow.ResourceType)
    end ]]
    
    local RELOAD_PREVENTION = Game:GetProperty("AG_GAME_RELOADED") or 0
	if RELOAD_PREVENTION == 1 then return; end
	local tMajors = PlayerManager.GetAliveMajorIDs()
	local currentTurn = Game.GetCurrentGameTurn()
	local startTurn = GameConfiguration.GetStartTurn()
    local techID = GameInfo.Technologies["TECH_IRRIGATION"].Index
	Game:SetProperty("AG_GAME_RELOADED", 1)
	for _, playerID in ipairs(tMajors) do
		if GklsLeaderMatches(playerID, LEADER_RAN) then
			if (currentTurn == startTurn) and (RELOAD_PREVENTION == 0) then
				local pPlayer = Players[playerID]
                if not (pPlayer:GetTechs():HasTech(techID) ) then
                    pPlayer:GetTechs():SetResearchProgress(techID, 0.62*pPlayer:GetTechs():GetResearchCost(techID))
				    print("IRRIGATION: 60 percent progress for Ran!")
                end
            end
        end
    end
end

Events.LoadGameViewStateDone.Add(GklsAGInitialise)