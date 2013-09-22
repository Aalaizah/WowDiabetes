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
		-- Combat entered
		ColorPrint("Combat entered")
	elseif event == "PLAYER_REGEN_ENABLED" then
		-- Combat exited
		ColorPrint("Combat exited")
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		-- Spell cast; may be food/drink consumed
		WowDiabetes_HandleSpellCast(...)
	elseif event == "UNIT_AURA" then
		-- Player buffs changed, may be due to food/drink
		ColorPrint("Auras changed")
	elseif event == "BAG_UPDATE" then
		-- Bags have changed; check for food/drink consumed if needed
		ColorPrint("Bags changed")
	end
end

-- Called whenever the user clicks on the main WowDiabetes frame
function WowDiabetes_OnClickFrame()
	ColorPrint("Frame clicked")
end

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