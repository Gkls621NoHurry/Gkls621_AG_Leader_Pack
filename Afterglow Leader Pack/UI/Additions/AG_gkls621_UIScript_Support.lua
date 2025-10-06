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