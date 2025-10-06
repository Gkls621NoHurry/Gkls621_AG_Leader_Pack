-- Acknowledgement: HUAN's MyGO!!!!! (I copied your method) 
include("GovernorPanel")
include("AG_gkls621_UIScript_Support")

local BASE_AddGovernorCandidate = AddGovernorCandidate
local TRAIT_AG = "TRAIT_CIVILIZATION_AG_gkls621"
local OVERRIDE_LIST = {"TRAIT_CIVILIZATION_HUAN_GBP_MYGO", "TRAIT_CIVILIZATION_AG_gkls621"}
local INACTIVATE_LIST_AG = DB.Query("SELECT GovernorType FROM Governors WHERE TraitType IS NULL")
local INACTIVATE_LIST_COMMON = {'GOVERNOR_THE_DEFENDER','GOVERNOR_THE_AMBASSADOR','GOVERNOR_THE_CARDINAL','GOVERNOR_THE_RESOURCE_MANAGER','GOVERNOR_THE_BUILDER','GOVERNOR_THE_EDUCATOR','GOVERNOR_THE_MERCHANT'}

function AddGovernorCandidate(governorDef:table, canAppoint:boolean)
    if (governorDef == nil) then return; end
    local precautionFlag :table = {}
    local playerID = Game.GetLocalPlayer()
    for _, overrideTrait in ipairs(OVERRIDE_LIST) do
	    if PlayerHasCivTraitUI(playerID, overrideTrait) and precautionFlag[playerID] == nil then
            precautionFlag[playerID] = 1
            if overrideTrait == TRAIT_AG then
                for _,governorString in ipairs(INACTIVATE_LIST_AG) do
                    print(playerID.." with "..overrideTrait.." Now processing "..governorString.GovernorType)
                    if governorDef.GovernorType == governorString.GovernorType then
                        print(playerID.." "..governorString.GovernorType.." to be overrode, return.")
                        return
                    end
                end
            else
                for _,governorString in ipairs(INACTIVATE_LIST_COMMON) do
                    print(playerID.." with "..overrideTrait.." Now processing "..governorString)
                    if governorDef.GovernorType == governorString then
                        print(playerID.." "..governorString.." to be overrode, return.")
                        return
                    end
                end
            end
        end
	end
    -- Back to default
    BASE_AddGovernorCandidate(governorDef,canAppoint)
end