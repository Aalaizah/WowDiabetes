--- add way to spit out data to give to website, GetUnitName("thistoon", true), + others

-------------------------------------------------------------------------------
-- Utility functions and variables
-------------------------------------------------------------------------------
local L = WowDiabetesLocalization

-- Prints text with a specific color.
-- NOTE: Any inlined color changes (e.g. from links) will cancel out the color
-- 
local function ColorPrint(text, color)
	color = color or "6F0948ff" -- Default to cyan
	print("|c" .. color .. text)
end

-- Update interval for changing glucose
WowDiabetes_UpdateInterval = 1.0

-------------------------------------------------------------------------------
-- Local variables
-------------------------------------------------------------------------------
-- Tells the addon to check the for the next reduction in food/drink
local playerIsAboutToEat = false
local playerIsAboutToDrink = false

-- Keeps track of the items in the player's bags
local bagCounts = {}

-- Boolean to check if first time loading
isFirstTime = true

-- timers
local meterTimer = 0
local dayTimer = 0
local combatTimer = 0

local insulinChance = 40
local inCombat = false

-- screen res
local screenRes = ""

-- minimap button
WowDiabetes_Settings = {
	MinimapPos = 45 -- default position of the minimap icon in degrees
}

-- Glycemic Loads where g is the glicemic load of its food
local foodList = foodListTable
local drinkList = drinkListTable

-- Scaling Variable
local scaleAmt = 5

-------------------------------------------------------------------------------
-- Main AddOn logic
-------------------------------------------------------------------------------
-- Called when the main frame first loads
function WowDiabetes_OnLoad(frame)
	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("VARIABLES_LOADED")
	-- Combat enter/leave
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	-- Food/drink consumption
	frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	frame:RegisterEvent("UNIT_AURA")
	-- Mouse handling
	--frame:RegisterForClicks("RightButtonUp")
	frame:RegisterForDrag("LeftButton")
	screenRes = GetCVar("gxResolution")
end

-- Changes the color of the glucose bar depending on how well the player is doing
function ChangeGlucoseBarColor()
	-- good glucose level
	if glucoseLevel > 89 and glucoseLevel < 110 then
		goodGlucose(UIErrorsFrame)
	-- Slighty bad glucose level, character is dizzy
	elseif glucoseLevel > 70 and glucoseLevel < 90 then
		okayGlucose(UIErrorsFrame)
	-- Very bad glucose level, character is about to pass out
	elseif glucoseLevel > 110 and glucoseLevel < 130 then
		okayGlucose(UIErrorsFrame)
	-- the worst glucos level, low end
	elseif glucoseLevel < 70 then
		badGlucose(UIErrorsFrame)
	-- the worst glucose level, high end
	elseif glucoseLevel > 130 then
		badGlucose(UIErrorsFrame)
	end	
end

-- Good Glucose Level
function goodGlucose(frame)
	WowBlurryEffect:Hide()
	WowDiabetesFrameGlucoseLevelBar:SetStatusBarColor(0,1,0,1)
	if glucoseLevelString ~= "good" then
		ColorPrint(GOOD_TEXT, "ff00ff00")
		frame:AddMessage(GOOD_TEXT, 0, 1, 0)
		glucoseLevelString = "good"
	end
end

-- Okay Glucose Level
function okayGlucose(frame)
	WowBlurryEffect:Show()
	WowBlurryEffect:SetAlpha(.4)
	WowDiabetesFrameGlucoseLevelBar:SetStatusBarColor(1,1,0,1)
	if(glucoseLevelString ~= "okay") then
		ColorPrint(OKAY_TEXT, "ffffff00")
		frame:AddMessage(OKAY_TEXT, 1, 1, 0)
		glucoseLevelString = "okay"
	end
end

-- Bad Glucose Level
function badGlucose(frame)
	local frameH = frame:GetAttribute("height")
	WowBlurryEffect:Show()
	WowBlurryEffect:SetAlpha(.6)
	WowDiabetesFrameGlucoseLevelBar:SetStatusBarColor(1,0,0,1)
	if(glucoseLevelString ~= "bad") then
		ColorPrint(BAD_TEXT, "ffff0f0f")
		frame:AddMessage(BAD_TEXT, 1, 0, 0)
		glucoseLevelString = "bad"
	end
end

-- Called after the variables have loaded
function WowDiabetesGlucoseLevelBar_Setup(statusBar)
	statusBar:SetMinMaxValues(40,180)
	statusBar:SetValue(glucoseLevel)
    statusBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
    WowDiabetesFrameGlucoseLevelString:SetText(string.format("%.0f", statusBar:GetValue()) .. " mg/dL")
	ChangeGlucoseBarColor()
end

-- Called whenever an event is triggered
function WowDiabetes_OnEvent(frame, event, ...)
	if event == "ADDON_LOADED" and ... == "WowDiabetes" then
		for bagId = 0, NUM_BAG_SLOTS do
			WowDiabetes_ScanBag(bagId, false)
		end
		frame:UnregisterEvent("ADDON_LOADED")
		frame:RegisterEvent("BAG_UPDATE")
		if glucoseLevel == nil then
			glucoseLevel = 90
			glucoseLevelString = "good"
			insulin = 10
			insulinUsed = 0
			foodEaten = 0
			timeGood = 0
		end
	elseif event == "VARIABLES_LOADED" then
		glucoseLevel = tonumber(glucoseLevel)
		insulin = tonumber(insulin)
		insulinUsed = tonumber(insulinUsed)
		foodEaten = tonumber(foodEaten)
		timeGood = tonumber(timeGood)
		WowDiabetesFrameMedsAmountString:SetText(insulin)
		WowDiabetesGlucoseLevelBar_Setup(WowDiabetesFrameGlucoseLevelBar)
		function WowDiabetes_MinimapButton_Reposition()
			WowDiabetes_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(WowDiabetes_Settings.MinimapPos)),(80*sin(WowDiabetes_Settings.MinimapPos))-52)
		end
		WowDiabetesGlucoseLevelBar_Setup(WowDiabetesFrameGlucoseLevelBar)
	elseif event == "PLAYER_REGEN_DISABLED" then
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
	inCombat = true
	combatTimer = 0
end

function WowDiabetes_ScaleActivity()
	if(GetInstanceInfo() == "raid") then
		scaleAmt = 60
	elseif(GetInstanceInfo() == "party") then
		scaleAmt = 45
	else
		scaleAmt = 5
	end
end

-- Called whenever the player exits combat
function WowDiabetes_HandleExitCombat()
	local checkGluc
	--local insulinCheck = 0
	ColorPrint("Player exited combat!")
	insulinCheck = random(0,100)
	--ColorPrint(insulinCheck)
	if insulinCheck > insulinChance then
		insulin = insulin + 1
	end
	WowDiabetes_ScaleActivity()
	--ColorPrint(scaleAmt)
	checkGluc = combatTimer % scaleAmt
	newGlucose = combatTimer / scaleAmt
	ColorPrint(newGlucose .. " " .. checkGluc .. " " .. combatTimer)
	if 0 > newGlucose then
		newGlucose = checkGluc
	end
	if glucoseLevel > 46 then
		glucoseLevel = glucoseLevel - newGlucose
	end
	
	combatTimer = 0
	WowDiabetesFrameGlucoseLevelBar:SetValue(glucoseLevel)
	WowDiabetesFrameMedsAmountString:SetText(insulin)
end

-- Called whenever a spell is cast, including usage of food/drink
function WowDiabetes_HandleSpellCast(unitId, spell, rank, lineId, spellId)
	if unitId == "player" then
		-- Check for food/drink
		if spell == L["DRINK_AURA_NAME"] then
			ColorPrint("Player is about to drink")
			playerIsAboutToDrink = true
		elseif spell == L["FOOD_AURA_NAME"] then
			ColorPrint("Player is about to eat")
			playerIsAboutToEat = true
		end
	end
end

-- Called whenever someone's buffs/debuffs (auras) change
function WowDiabetes_HandleUnitAuraChanged(unitId)
	if unitId == "player" then
		--ColorPrint("Player's auras (buffs/debuffs) changed!")
	end
end

-- Called whenever there is a change in bags
function WowDiabetes_HandleBagUpdate(bagId)
	-- Update bag counts
	local changedItems = WowDiabetes_ScanBag(bagId)

	-- If necessary, print changed item(s)
	if playerIsAboutToEat or playerIsAboutToDrink then
		for itemId, count in pairs(changedItems) do
			local itemName, link = GetItemInfo(itemId)

			if playerIsAboutToEat then
				ColorPrint("Player ate: " .. link .. ", change in count: " .. count)
				local foodVal = foodList[itemId]
				ColorPrint("Item: " .. itemName .. " Value: " .. foodVal)
				if foodVal > 20 then
					glucoseLevel = glucoseLevel + (foodVal / 5)
				else
					glucoseLevel = glucoseLevel + foodVal
				end
				foodEaten = foodEaten + 1
				playerIsAboutToEat = false
			elseif playerIsAboutToDrink then
				ColorPrint("Player drank: " .. link .. ", change in count: " .. count)
				foodEaten = foodEaten + 1
				playerIsAboutToDrink = false
			end
		end
		--glucoseLevel = glucoseLevel + 1
		WowDiabetesFrameGlucoseLevelBar:SetValue(glucoseLevel)
	end
end

-- Counts and stores the number of items in each bag
-- @param bagId The bag index to check
-- @param returnChanges (Defaults to true) If true, will return a collection of items changed
--                      where returnVal[itemId] == changeInCount
function WowDiabetes_ScanBag(bagId, returnChanges)
	returnChanges = returnChanges or true

	-- Count the number of each item in the bag
	if not bagCounts[bagId] then
		bagCounts[bagId] = {}
	end

	local itemCounts = {}
	for slot = 0, GetContainerNumSlots(bagId) do
		local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bagId, slot)

		if texture then
			local itemId = tonumber(link:match("|Hitem:(%d+):"))
			if not itemCounts[itemId] then
				itemCounts[itemId] = count
			else
				itemCounts[itemId] = itemCounts[itemId] + count
			end
		end
	end

	-- Compare against the old counts
	local changedItems = {}
	if returnChanges then
		for itemId, oldCount in pairs(bagCounts[bagId]) do
			local newCount = itemCounts[itemId] or 0

			if oldCount ~= newCount then
				changedItems[itemId] = newCount - oldCount
			end
		end
	end

	-- Store the new item counts
	bagCounts[bagId] = itemCounts

	if returnChanges then
		return changedItems
	end
end


-- If the frame has been completely open for longer than 15 seconds, 
-- hide part of it so the player has to learn to keep track on their own
 function WowDiabetes_OnUpdate(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed
	
	while ( self.TimeSinceLastUpdate > WowDiabetes_UpdateInterval) do
		if WowDiabetesFrameGlucoseLevelBar:IsShown() then
			meterTimer = meterTimer + WowDiabetes_UpdateInterval
			if meterTimer >= 10 then
				WowDiabetesFrameGlucoseLevelBar:Hide()
				WowDiabetesFrameGlucoseLevelString:Hide()
				WowDiabetesFrameCloseButton:Hide()
				WowDiabetesFrameCloseButton2:Show()
				WowDiabetesFrameWebsiteButton:Hide()
				WowDiabetesFrameWebsiteButton2:Show()
				WowDiabetesFrame:SetSize(200, 138)
				meterTimer = 0
			end
		end
		dayTimer = dayTimer + WowDiabetes_UpdateInterval
		if dayTimer > 1440 then
			dayTimer = 0
		end
		combatTimer = combatTimer + WowDiabetes_UpdateInterval
		
		self.TimeSinceLastUpdate = self.TimeSinceLastUpdate - WowDiabetes_UpdateInterval
	end

end

-- Hide the frame entirely
function WowDiabetesCloseButton_OnClick()
	WowDiabetesFrame:Hide()
end

-- Show the frame entirely
function WowDiabetes_MinimapButton_OnClick()
	if WowDiabetesFrame:IsShown() then
		WowDiabetesFrame:Hide()
	else
		WowDiabetesFrame:Show()
	end
end

-- Shows the frame entirely so player can check glucose levels
function WowDiabetesGlucoseButton_OnClick()
	WowDiabetesFrame:SetSize(200, 185)
	WowDiabetesFrameGlucoseLevelBar:Show()
	WowDiabetesFrameGlucoseLevelString:Show()
	WowDiabetesFrameCloseButton:Show()
	WowDiabetesFrameCloseButton2:Hide()
	WowDiabetesFrameWebsiteButton:Show()
	WowDiabetesFrameWebsiteButton2:Hide()
end

-- Raise your glucose level when medicine is used
function WowDiabetesMedicineButton_OnClick()
	if insulin > 0 then
		local insulinVal = math.random(8, 12)
		glucoseLevel = glucoseLevel + insulinVal
		WowDiabetesFrameGlucoseLevelBar:SetValue(glucoseLevel)
		insulin = insulin - 1
		insulinUsed = insulinUsed + 1
		WowDiabetesFrameMedsAmountString:SetText(insulin)
	end
end

-- Open the website panel for uploading/downloading your data
function WowDiabetesWebsiteButton_OnClick()
	if WebsiteFrame:IsShown() then
		WebsiteFrame:Hide()
	else
		WebsiteFrame:Show()
		WowDiabetesUploadButton_OnClick()
	end
end	
	
-- Recreate the string if needed
function WowDiabetesUploadButton_OnClick()
	local exportString = WowDiabetes_CreateUploadString()
	WebsiteFrameEditBox:SetText(exportString)
	WebsiteFrameEditBox:SetMultiLine(true)
	WebsiteFrameEditBox:HighlightText()
end

-- Take the input string and save the data back in
function WowDiabetesDownloadButton_OnClick()
	WowDiabetes_SaveDownloadInfo(WebsiteFrameEditBox:GetText())
end

function WowDiabetes_SaveDownloadInfo(data)
		
	if data == nil then
		return "error"
	end
	
	local tempData = { strsplit(",", data) }
	
	timeGood = tempData[3]
	glucoseLevel = tempData[4]
	insulin = tempData[5]
	insulinUsed = tempData[6]
	foodEaten = tempData[7]
end

-- Create the String for uploading data
function WowDiabetes_CreateUploadString()
	local tempName = GetUnitName("player", true)
	local location = string.find(tempName, "-")
	if location ~= nil then
		Name = string.sub(tempName, 1, location)
		Server = string.sub(tempName, location)
	else
		Name = tempName
		Server = GetRealmName()
	end
	
	UploadString = (Name .. "," .. Server .. "," .. timeGood .. "," .. glucoseLevel .. "," .. insulin .. "," .. insulinUsed .. "," .. foodEaten)
	return UploadString
end

-- Update string above status bar with the new glucose level
function WowDiabetesGlucoseLevelBar_OnValueChanged()
	WowDiabetesFrameGlucoseLevelString:SetText(string.format("%.0f", glucoseLevel) .. " mg/dL")
	ChangeGlucoseBarColor()
end

-- Move the minimap button
function WowDiabetes_MinimapButton_DraggingFrame_OnUpdate()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
	ypos = ypos/UIParent:GetScale()-ymin-70

	WowDiabetes_Settings.MinimapPos = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
	WowDiabetes_MinimapButton_Reposition() -- move the button
end

-- Show minimap tooltip
function WowDiabetes_MinimapButton_OnEnter(self)
	if self.dragging then
		return
	end
	GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT")
	WowDiabetes_MinimapButton_Details(GameTooltip)
end

function WowDiabetes_MinimapButton_Details(tt, ldb)
	tt:SetText(TITLE_TEXT)
end

SLASH_WOWDIABETES1, SLASH_WOWDIABETES2 = '/wowdiabetes', '/wd'
function SlashCmdList.WOWDIABETES(msg, editbox)
	WowDiabetesFrame:Show()
end
