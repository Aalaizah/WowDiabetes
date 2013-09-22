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
		print("Combat entered")
	elseif event == "PLAYER_REGEN_ENABLED" then
		-- Combat exited
		print("Combat exited")
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		-- Spell cast; may be food/drink consumed
		print("Spell cast")
	elseif event == "UNIT_AURA" then
		-- Player buffs changed, may be due to food/drink
		print("Auras changed")
	elseif event == "BAG_UPDATE" then
		-- Bags have changed; check for food/drink consumed if needed
		print("Bags changed")
	end
end

-- Called whenever the user clicks on the main WowDiabetes frame
function WowDiabetes_OnClickFrame()
	print("Frame clicked")
end

