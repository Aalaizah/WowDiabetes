-- Utility functions/variables
local L = WowDiabetesLocalization

local function ColorPrint(text, color)
	color = color or "ffffff00" -- Default to yellow
	print("|c" .. color .. text)
end

-- Called when the main frame first loads
function WowDiabetes_OnLoad(frame)
	-- Combat enter/leave
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	-- Food/drink consumption
	frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("BAG_UPDATE")
	-- Mouse handling
	frame:RegisterForClicks("RightButtonUp")
	frame:RegisterForDrag("LeftButton")
end

-- Called whenever an event is triggered
function WowDiabetes_OnEvent(frame, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		WowDiabetes_HandleEnterCombat(...)
	elseif event == "PLAYER_REGEN_ENABLED" then
		WowDiabetes_HandleExitCombat(...)
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		WowDiabetes_HandleSpellCast(...)
	elseif event == "UNIT_AURA" then
		WowDiabetes_HandleUnitAuraChanged(...)
	elseif event == "BAG_UPDATE" then
		WowDiabetes_HandleBagUpdate(...)
	end
end

-- Called whenever the user clicks on the main WowDiabetes frame
function WowDiabetes_OnClickFrame()
	ColorPrint("Frame clicked")
end

-- Called whenever the player enters combat
function WowDiabetes_HandleEnterCombat()
	ColorPrint("Player entered combat!")
end

-- Called whenever the player exits combat
function WowDiabetes_HandleExitCombat()
	ColorPrint("Player exited combat!")
end

-- Called whenever a spell is cast, including usage of food/drink
function WowDiabetes_HandleSpellCast(unitId, spell, rank, lineId, spellId)
	if unitId == "player" then
		-- Check for food/drink
		if spell == L["DRINK_AURA_NAME"] then
			ColorPrint("Player is about to drink")
		elseif spell == L["FOOD_AURA_NAME"] then
			ColorPrint("Player is about to eat")
		end
	end
end

-- Called whenever someone's buffs/debuffs (auras) change
function WowDiabetes_HandleUnitAuraChanged(unitId)
	if unitId == "player" then
		ColorPrint("Player's auras (buffs/debuffs) changed!")
	end
end

-- Called whenever there is a change in bags
function WowDiabetes_HandleBagUpdate(bagId)
	ColorPrint("Bag number " .. bagId .. " changed!")
	--TODO: check for items consumed to see if it was food/drink
end