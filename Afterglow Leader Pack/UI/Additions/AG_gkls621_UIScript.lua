local TRAIT_AG = "TRAIT_CIVILIZATION_AG_gkls621"
local TRAIT_RAN = "TRAIT_LEADER_RAN_gkls621"
local TRAIT_HIMARI = "TRAIT_LEADER_HIMARI_gkls621"
local TRAIT_TOMOE = "TRAIT_LEADER_TOMOE_gkls621"
local TRAIT_TSUGUMI = "TRAIT_LEADER_TSUGUMI_gkls621"
local TAIKO_TEAM_INDEX = GameInfo.Units["UNIT_TAIKO_TEAM_gkls621"].Index or -1
local TRADER_INDEX = GameInfo.Units["UNIT_TRADER"].Index or -1

GameEvents = ExposedMembers.GameEvents;

function PlayerHasLeaderTraitUI(playerID, sTraitType)
	local config = PlayerConfigurations[playerID]
	if config ~= nil then
		local sLeaderType = config:GetLeaderTypeName()
	    for tRow in GameInfo.LeaderTraits() do
			if tRow.LeaderType == sLeaderType and tRow.TraitType == sTraitType then 
				print("Has_LA:"..sTraitType)
				return true 
			end
		end
	end
    return false
end

function PlayerHasCivTraitUI(playerID, sTraitType)
	local config = PlayerConfigurations[playerID]
	if config ~= nil then
		local sCivType = config:GetCivilizationTypeName()
	    for tRow in GameInfo.CivilizationTraits() do
			if tRow.CivilizationType == sCivType and tRow.TraitType == sTraitType then 
				print("Has_UA:"..sTraitType)
				return true 
			end
		end
	end
    return false
end

function GklsAGClassicDedication(playerID, operationID)
    if not PlayerHasCivTraitUI(playerID, TRAIT_AG) then return; end
    if operationID ~= PlayerOperations.COMMEMORATE then return; end
    local pGameEras = Game.GetEras()
    if pGameEras:GetCurrentEra() ~= GameInfo.Eras["ERA_CLASSICAL"].Index then return; end
    local activeCommemorations = pGameEras:GetPlayerActiveCommemorations(playerID)
    local pPlayer = Players[playerID]
    for _, activeCommemoration in ipairs(activeCommemorations) do
		local kParam :table = {}
		kParam.OnStart = "GklsAGSetPlayerProperty"
		--kParam.playerID = playerID
		kParam.propertyString = "AG_CLASSICAL_DEDICATION"
		kParam.value = activeCommemoration
		UI.RequestPlayerOperation(playerID, PlayerOperations.EXECUTE_SCRIPT, kParam)
        --pPlayer:SetProperty("AG_CLASSICAL_DEDICATION", activeCommemoration)
    end
end

function GklsTomoePantheonSuzerainty(playerID)
    if playerID == -1 then return; end
    if not PlayerHasLeaderTraitUI(playerID, TRAIT_TOMOE) then return; end
    local m_kEnvoyChanges :table  = {}
    local pPlayer = Players[playerID]
    local playerDiplomacy = pPlayer:GetDiplomacy()

    for i, pMinor in ipairs(PlayerManager.GetAliveMinors()) do
		local iMinorID = pMinor:GetID();
		--local isCanReceiveInfluence		:boolean= false;
		local envoyTokens				:number	= 0;
		local envoyTokensMostReceived	:number	= 0;
		local suzerainID				:number	= -1;
		local pMinorInfluence			:table	= pMinor:GetInfluence();		
        
		if pMinorInfluence ~= nil and playerDiplomacy:HasMet(iMinorID) then
			isCanReceiveInfluence	= pMinorInfluence:CanReceiveInfluence();
			envoyTokens				= pMinorInfluence:GetTokensReceived(playerID);
			envoyTokensMostReceived = pMinorInfluence:GetMostTokensReceived();
			suzerainID				= pMinorInfluence:GetSuzerain();
			if isCanReceiveInfluence then
				if (suzerainID ~= -1) and (envoyTokens < envoyTokensMostReceived) then
					m_kEnvoyChanges[iMinorID] = envoyTokensMostReceived - envoyTokens + 1; 
				else 
					m_kEnvoyChanges[iMinorID] = 3; 
				end		
			end
		end
    end

	for cityStatePlayerID,numTokens in pairs(m_kEnvoyChanges) do
		GameEvents.GklsTomoeSetSuzerainty.Call(playerID, cityStatePlayerID, numTokens)
	end
	--[[for cityStatePlayerID,numTokens in pairs(m_kEnvoyChanges) do
		for i=1,numTokens,1 do
			local parameters:table = {};
			parameters[ PlayerOperations.PARAM_PLAYER_ONE ] = cityStatePlayerID;
			UI.RequestPlayerOperation( playerID, PlayerOperations.GIVE_INFLUENCE_TOKEN, parameters);
			print("Tmoe: A free token to City State "..PlayerConfigurations[cityStatePlayerID]:GetLeaderTypeName())	
		end
	end]]--
end

function GklsTomoeTravelRoundWorld(iMoment, hMoment)
	local playerID = Game.GetHistoryManager():GetMomentData(iMoment).ActingPlayer
	if not PlayerHasLeaderTraitUI(playerID, TRAIT_TOMOE) then return; end
	local momentType = GameInfo.Moments[hMoment].MomentType
	if (momentType == "MOMENT_WORLD_CIRCUMNAVIGATED") or (momentType == "MOMENT_WORLD_CIRCUMNAVIGATED_FIRST_IN_WORLD") then
		GklsTomoePantheonSuzerainty(playerID)
		print("Tomoe has travelled round the world!")
	end
end

function GklsTomoeTaikoChargeChanged(playerID, unitID, newCharges, oldCharges)
	--if not (PlayerHasLeaderTraitUI(playerID, TRAIT_TOMOE)) then return; end
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	if (pUnit ~= nil) then
		if (pUnit:GetType() == TAIKO_TEAM_INDEX) then
			local location = pUnit:GetLocation()
			GameEvents.GklsTomoeGenerateGoodyHut.Call(playerID, location)
			print("Taiko Team worked at "..location.x.." "..location.y)
		end
	end
end

-- Algorithm acknowledgement: Flactine & Sukritact & Ruivo
function GklsRanDetectAmenity(playerID, cityID)
	if not (PlayerHasLeaderTraitUI(playerID, TRAIT_RAN)) then return; end
	local pCity = CityManager.GetCity(playerID, cityID)
	if (pCity == nil) then 
    	return; 
    end
    local iX = pCity:GetX(); local iY = pCity:GetY();
    local pPlot = Map.GetPlot(cityX, cityY)
    local plotIndex = pPlot:GetIndex()
    local pCityGrowth = pCity:GetGrowth()
	local grossAmenity = pCityGrowth:GetAmenities()
	-- Reference: Ruivo
	local Population = pCity:GetPopulation();
    local CITY_POP_PER_AMENITY = GameInfo.GlobalParameters['CITY_POP_PER_AMENITY'].Value
    --print("消耗1个宜居度的人口数：", CITY_POP_PER_AMENITY)
    local AmenitiesNeeded_FromPopulation = math.ceil(Population / CITY_POP_PER_AMENITY);--向上取整，1个人口也消耗1宜居，2个也消耗1宜居
    --print("人口消耗宜居度（向上取整）：", AmenitiesNeeded_FromPopulation);
    local CITY_AMENITIES_FOR_FREE = GameInfo.GlobalParameters['CITY_AMENITIES_FOR_FREE'].Value
    local netAmenity = grossAmenity + CITY_AMENITIES_FOR_FREE - AmenitiesNeeded_FromPopulation;
    
	-- Update City Plot Properties about Happiness Level
	for tHappiness in GameInfo.Happinesses() do
		local iMin = tHappiness.MinimumAmenityScore or -math.huge
		local iMax = tHappiness.MaximumAmenityScore or math.huge
		local propertyString = 'AG_CITY_AMENITY_LEVEL_'..tHappiness.HappinessType
		if (netAmenity >= iMin) and (netAmenity <= iMax) then			
			GameEvents.GklsAGSetPlotProperty.Call(plotIndex, propertyString, 1)
			print('AG_CITY_AMENITY_LEVEL_'..tHappiness.HappinessType.." set to 1")
		else
			GameEvents.GklsAGSetPlotProperty.Call(plotIndex, propertyString, 0)
			print('AG_CITY_AMENITY_LEVEL_'..tHappiness.HappinessType.." set to 0")
		end
	end

	-- Count and Update the War-Weariness Property for Ran
	GklsRanCountWeariness(playerID)
end

function GklsRanCountWeariness(playerID)
	if not (PlayerHasLeaderTraitUI(playerID, TRAIT_RAN)) then return; end
    local pPlayer = Players[playerID]
	local sum = 0
	for _, pCity in pPlayer:GetCities():Members() do
		local pCityGrowth = pCity:GetGrowth()
		local warWeariness = math.abs(pCityGrowth:GetAmenitiesLostFromWarWeariness()) or -1
		if warWeariness == -1 then
			print("War Weariness in "..pCity:GetName().." ERROR!")
		else
			local cityMaxWeariness = pCity:GetProperty("CITY_HISTORY_MAX_WAR_WEARINESS") or 0
			if (cityMaxWeariness < warWeariness) then
				sum = sum + warWeariness
				GameEvents.GklsAGSetCityProperty.Call(playerID, pCity:GetID(), "CITY_HISTORY_MAX_WAR_WEARINESS", warWeariness)
				print("City "..pCity:GetID().." war max weariness updated: "..cityMaxWeariness.." to "..warWeariness)
			else
				sum = sum + cityMaxWeariness
			end
		end
	end
	GameEvents.GklsRanSetWearinessProperty.Call(playerID, sum)
	print("Ran's Weariness situation transit to GP")
end

function GklsRanUnitsRefreshProperty(playerID, cityID, iConstructionType, itemID, bCancelled)
	if not (PlayerHasLeaderTraitUI(playerID, TRAIT_RAN)) then return; end
	if (iConstructionType == 0) then -- representing units
		GklsRanCountWeariness(playerID)
	end
end

function GklsRanOnTurnBegin()
	for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		if PlayerHasLeaderTraitUI(playerID, TRAIT_RAN) then
			local pPlayer = Players[playerID]
			for _, pCity in pPlayer:GetCities():Members() do
				GklsRanDetectAmenity(playerID, pCity:GetID())
			end
			GklsRanCountWeariness(playerID)
		end
	end
end

function GklsHimariSucceedingEmergency(playerID, eTargetPlayer, iTurn)
	if (PlayerHasLeaderTraitUI(playerID, TRAIT_HIMARI)) then
		local crisisData = Game.GetEmergencyManager():GetEmergencyInfoTable(localPlayerID);
		for _, crisis in ipairs(crisisData) do
			if (crisis.HasBegun) and (crisis.TurnsLeft == -1 or crisis.TurnsLeft == 0) then
				if(crisis.bSuccess == true) then
					GameEvents.GklsHimariGrantEngineerPoint(playerID)
					return
				end
			end
		end
	end
end

-- Reference: Siqi's "Arknights: Papyrus and Rose Salt"
function GklsTsugumiOnTraderAtCaffe(playerID, unitID, iX, iY)
	if not (PlayerHasLeaderTraitUI(playerID, TRAIT_TSUGUMI)) then return; end
	local CAFFE_INDEX = GameInfo.Districts["DISTRICT_CAFFE_gkls621"].Index or -1
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	if (pUnit == nil) then return; end
	if (pUnit:GetType() == TRADER_INDEX) then
		local pPlot = Map.GetPlot(iX, iY)
        if pPlot:GetDistrictType() == CAFFE_INDEX then
			GameEvents.GklsTsugumiCaffeGrantBuilder.Call(playerID, iX, iY)
		end
	end
end

function GklsTsugumiUpdateTradeProperty(playerID, OriginPlayerID, OriginCityID, TargetPlayerID, TargetCityID)
	if (PlayerHasLeaderTraitUI(OriginPlayerID, TRAIT_TSUGUMI)) then
		local pCity = CityManager.GetCity(OriginPlayerID, OriginCityID)
		local cityTrade = pCity:GetTrade()
		local numOut = (# cityTrade:GetOutgoingRoutes()) or 0
		print("City "..OriginCityID.." has "..numOut.." outgoing trade routes.")
		local numIn = (# cityTrade:GetIncomingRoutes()) or 0
		print("City "..OriginCityID.." has "..numIn.." incoming trade routes.")
		GameEvents.GklsAGSetCityProperty.Call(OriginPlayerID, OriginCityID, "TSUGU_CITY_OUTGOING_ROUTES", numOut)
		GameEvents.GklsAGSetCityProperty.Call(OriginPlayerID, OriginCityID, "TSUGU_CITY_INCOMING_ROUTES", numIn)
	end
	if (PlayerHasLeaderTraitUI(TargetPlayerID, TRAIT_TSUGUMI)) then
		local pCity = CityManager.GetCity(TargetPlayerID, TargetCityID)
		local cityTrade = pCity:GetTrade()
		local numOut = (# cityTrade:GetOutgoingRoutes()) or 0
		print("City "..TargetCityID.." has "..numOut.." outgoing trade routes.")
		local numIn = (# cityTrade:GetIncomingRoutes()) or 0
		print("City "..TargetCityID.." has "..numIn.." incoming trade routes.")
		GameEvents.GklsAGSetCityProperty.Call(TargetPlayerID, TargetCityID, "TSUGU_CITY_OUTGOING_ROUTES", numOut)
		GameEvents.GklsAGSetCityProperty.Call(TargetPlayerID, TargetCityID, "TSUGU_CITY_INCOMING_ROUTES", numIn)
	end
end

function GklsAGCountSuzerainTypes(cityStateID)
	--if not(PlayerHasLeaderTraitUI(playerID, TRAIT_TOMOE)) then return; end
    local pMinor = Players[cityStateID]
    --local pPlayer = Players[playerID]
	local leader :string = PlayerConfigurations[cityStateID]:GetLeaderTypeName()
	print("GklsAGCountSuzerainTypes("..cityStateID..") : City-State leader is "..leader)
	local leaderInfo :table	= GameInfo.Leaders[leader]
	print("GklsAGCountSuzerainTypes("..cityStateID..") : City-State TYPE is "..leaderInfo.InheritFrom)
    --local leaderInfo :table = GameInfo.Leaders[PlayerConfigurations[cityStateID]:GetLeaderTypeName()]
	--local playerSuzerainNum = pPlayer:GetProperty("AG_SUZERAIN_NUM_OF_"..leaderInfo.InheritFrom) or 0
    local oldSuzerain = pMinor:GetProperty("AG_SUZERAIN_PLAYER_ID") or -1
	local nowSuzerain = pMinor:GetInfluence():GetSuzerain() or -1
	--print("GklsAGCountSuzerainTypes("..cityStateID..") : playerSuzerainNum = "..playerSuzerainNum)
	print("GklsAGCountSuzerainTypes("..cityStateID..") : oldSuzerain = "..oldSuzerain)
	print("GklsAGCountSuzerainTypes("..cityStateID..") : nowSuzerain = "..nowSuzerain)

	-- Update the suzerainty information on the city state itself
	kParam = {}
	kParam.OnStart = "GklsAGSetPlayerProperty"
	kParam.propertyString = "AG_SUZERAIN_PLAYER_ID"
	kParam.value = nowSuzerain
	GameEvents.GklsAGSetPlayerProperty.Call(cityStateID, kParam)
	print("City-State "..leader.." suzerain updated.")

	-- Update Tomoe's Property
	if (not PlayerHasLeaderTraitUI(oldSuzerain, TRAIT_TOMOE)) and (not PlayerHasLeaderTraitUI(nowSuzerain, TRAIT_TOMOE)) then return; end
    if (oldSuzerain ~= nowSuzerain) then
		if (PlayerHasLeaderTraitUI(oldSuzerain, TRAIT_TOMOE)) then
			local kParam:table = {}
			kParam.OnStart = "GklsAGSetPlayerProperty"
			kParam.propertyString = "AG_SUZERAIN_NUM_OF_"..leaderInfo.InheritFrom
			local playerSuzerainNum = Players[oldSuzerain]:GetProperty("AG_SUZERAIN_NUM_OF_"..leaderInfo.InheritFrom) or 0
			if (playerSuzerainNum > 0) then
				kParam.value = playerSuzerainNum - 1
			else kParam.value = 0; end
			UI.RequestPlayerOperation(oldSuzerain, PlayerOperations.EXECUTE_SCRIPT, kParam)
		end
		if (PlayerHasLeaderTraitUI(nowSuzerain, TRAIT_TOMOE)) then
			local kParam:table = {}
			kParam.OnStart = "GklsAGSetPlayerProperty"
			kParam.propertyString = "AG_SUZERAIN_NUM_OF_"..leaderInfo.InheritFrom
			local playerSuzerainNum = Players[nowSuzerain]:GetProperty("AG_SUZERAIN_NUM_OF_"..leaderInfo.InheritFrom) or 0
			if (playerSuzerainNum < 0) then kParam.value = 0;
			else kParam.value = playerSuzerainNum + 1; end
			UI.RequestPlayerOperation(nowSuzerain, PlayerOperations.EXECUTE_SCRIPT, kParam)
		end
	end	
end

--[[function GklsAGIsMinor(playerID)
	if (Players[playerID]:IsMinor()) then return true; end
	return false;
end

function GklsAGIsOriginalCapital(playerID, cityID)
	local pCity = CityManager.GetCity(playerID, cityID)
	if pCity == nil then return false; end
	if pCity:IsOriginalCapital() and (pCity:GetOriginalOwner() == playerID) then
		return true
	end
	return false
end]]--

function GklsAGInitialise_UI()
	Events.PlayerOperationComplete.Add(GklsAGClassicDedication)
	Events.TurnBegin.Add(GklsRanOnTurnBegin)
	Events.CityAddedToMap.Add(GklsRanDetectAmenity)
	Events.UnitKilledInCombat.Add(GklsRanCountWeariness)
	Events.CityProductionCompleted.Add(GklsRanUnitsRefreshProperty)
	Events.EmergencyCompleted.Add(GklsHimariSucceedingEmergency)
    Events.PantheonFounded.Add(GklsTomoePantheonSuzerainty)
	Events.GameHistoryMomentRecorded.Add(GklsTomoeTravelRoundWorld)
	Events.UnitChargesChanged.Add(GklsTomoeTaikoChargeChanged)
	Events.InfluenceGiven.Add(GklsAGCountSuzerainTypes)
	Events.UnitMoveComplete.Add(GklsTsugumiOnTraderAtCaffe)
	Events.TradeRouteActivityChanged.Add(GklsTsugumiUpdateTradeProperty)

	--ExposedMembers.GklsAG = ExposedMembers.GklsAG or {}
	--ExposedMembers.GklsAG.GklsAGIsOriginalCapital = GklsAGIsOriginalCapital 
	--ExposedMembers.GklsAG.GklsAGIsMinor = GklsAGIsMinor
end

Events.LoadGameViewStateDone.Add(GklsAGInitialise_UI)