-------------------------------------------------------------------------------
-- Utility functions and variables
-------------------------------------------------------------------------------
local L = WowDiabetesLocalization

-- Prints text with a specific color.
-- NOTE: Any inlined color changes (e.g. from links) will cancel out the color
-- 
local function ColorPrint(text, color)
	color = color or "ff00ffff" -- Default to cyan
	print("|c" .. color .. text)
end

-------------------------------------------------------------------------------
-- Local variables
-------------------------------------------------------------------------------
-- Tells the addon to check the for the next reduction in food/drink
local playerIsAboutToEat = false
local playerIsAboutToDrink = false

-- Keeps track of the items in the player's bags
local bagCounts = {}

-- Blood level
local glucoseLevel = 89
local glucoseLevelString = "good"
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======

-- medicine
local insulin = 10
>>>>>>> parent of c94d7ab... fixed saved variables

-- medicine
local insulin = 10
>>>>>>> parent of c94d7ab... fixed saved variables

-- medicine
local insulin = 10

-- timers
local meterTimer = 0
local dayTimer = 0

-- screen res
local screenRes = ""

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
-- glucose variables
p1 = 0
p2 = 0
p3 = 0
Vs = 0
Gb = 0

Gt = 0
Xt = 0
Ipt = 0
Rat = 0
=======
-- test variable
local purpleBag = 0
>>>>>>> parent of c94d7ab... fixed saved variables
=======
-- test variable
local purpleBag = 0
>>>>>>> parent of c94d7ab... fixed saved variables
=======
-- test variable
local purpleBag = 0
>>>>>>> parent of c94d7ab... fixed saved variables

-- Glycemic Loads where g is the glicemic load of its food
local foodList = {{name="Tough Hunk of Bread", g=29.44}, {name="Freshly Baked Bread", g=288}, {name="Moist Cornbread", g=244.1}, 
	{name="Slitherskin Mackerel", g=0}, {name="Longjaw Mud Snapper", g=0}, {name="Bristle Whisker Catfish", g=0}, 
	{name="Forest Mushroom Cap", g=0}, {name="Red-speckled Mushroom", g=0}, {name="Spongy Morel", g=1}, 
	{name="Tough Jerky", g=1}, {name="Haunch of Meat", g=0}, {name="Mutton Chop", g=0}, 
	{name="Darnassian Bleu", g=0}, {name="Dalaran Sharp", g=0}, {name="Dwarven Mild",g=0}, 
	{name="Shiny Red Apple", g=6.1}, {name="Tel'Abim Banana", g=10.4}, {name="Snapvine Watermelon", g=3.6}}
local drinkList = {"Refreshing Spring Water", "Ice Cold Milk", "Melon Juice", "Bottle of Pinot Noir", "Skin of Dwarven Stout", "Flask of Port", 
	"Flagon of Mead", "Junglevine Wine", "Rhapsody Malt", "Thunder Ale"}

-------------------------------------------------------------------------------
-- Main AddOn logic
-------------------------------------------------------------------------------
-- Called when the main frame first loads
function WowDiabetes_OnLoad(frame)
	frame:RegisterEvent("ADDON_LOADED")
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
	WowDiabetesFrameMedsAmountString:SetText(insulin)
end

-- Changes the color of the glucose bar depending on how well the player is doing
function ChangeGlucoseBarColor()
	-- good glucose level
	if glucoseLevel > 89 and glucoseLevel < 110 then
		--WowBlurryEffect:Hide()
		WowDiabetesFrameGlucoseLevelBar:SetStatusBarColor(0,1,0,1)
		if glucoseLevelString ~= "good" then
			ColorPrint(GOOD_TEXT, "ff00ff00")
			UIErrorsFrame:AddMessage(GOOD_TEXT, 0, 1, 0)
			glucoseLevelString = "good"
		end
	-- Slighty bad glucose level, character is dizzy
	elseif glucoseLevel > 70 and glucoseLevel < 90 then
<<<<<<< HEAD
		--WowBlurryEffect:Show()
		--WowBlurryEffect:SetAlpha(.2)
=======
		WowBlurryEffect:Show()
		WowBlurryEffect:SetAlpha(.5)
>>>>>>> 5ee06ea4885b444fedd8aef0b947aa40e26c5e81
		WowDiabetesFrameGlucoseLevelBar:SetStatusBarColor(1,1,0,1)
		if(glucoseLevelString ~= "okay") then
			ColorPrint(OKAY_TEXT, "ffffff00")
			UIErrorsFrame:AddMessage(OKAY_TEXT, 1, 1, 0)
			glucoseLevelString = "okay"
		end
	-- Very bad glucose level, character is about to pass out
	elseif glucoseLevel > 110 and glucoseLevel < 130 then
<<<<<<< HEAD
		--WowBlurryEffect:Show()
		--WowBlurryEffect:SetAlpha(.4)
=======
	WowBlurryEffect:Show()
		WowBlurryEffect:SetAlpha(.8)
>>>>>>> 5ee06ea4885b444fedd8aef0b947aa40e26c5e81
		WowDiabetesFrameGlucoseLevelBar:SetStatusBarColor(1,1,0,1)
		if(glucoseLevelString ~= "okay") then
			ColorPrint(OKAY_TEXT, "ffffff00")
			UIErrorsFrame:AddMessage(OKAY_TEXT, 1, 1, 0)
			glucoseLevelString = "okay"
		end
	-- the worst glucos level, low end
	elseif glucoseLevel < 70 then
<<<<<<< HEAD
		--WowBlurryEffect:Show()
		--WowBlurryEffect:SetAlpha(.6)
=======
	WowBlurryEffect:Show()
		WowBlurryEffect:SetAlpha(1)
>>>>>>> 5ee06ea4885b444fedd8aef0b947aa40e26c5e81
		WowDiabetesFrameGlucoseLevelBar:SetStatusBarColor(1,0,0,1)
		if(glucoseLevelString ~= "bad") then
			ColorPrint(BAD_TEXT, "ffff0f0f")
			UIErrorsFrame:AddMessage(BAD_TEXT, 1, 0, 0)
			glucoseLevelString = "bad"
		end
	-- the worst glucose level, high end
	elseif glucoseLevel > 130 then
<<<<<<< HEAD
		--WowBlurryEffect:Show()
		--WowBlurryEffect:SetAlpha(.6)
=======
	WowBlurryEffect:Show()
		WowBlurryEffect:SetAlpha(1)
>>>>>>> 5ee06ea4885b444fedd8aef0b947aa40e26c5e81
		WowDiabetesFrameGlucoseLevelBar:SetStatusBarColor(1,0,0,1)
		if(glucoseLevelString ~= "bad") then
			ColorPrint(BAD_TEXT, "ffff0f0f")
			UIErrorsFrame:AddMessage(BAD_TEXT, 1, 0, 0)
			glucoseLevelString = "bad"
		end
	end	
end

-- Called when the status bar loads
function WowDiabetesGlucoseLevelBar_OnLoad(statusBar)
	statusBar:SetMinMaxValues(40,180)
    statusBar:SetValue(glucoseLevel)
    statusBar:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
    WowDiabetesFrameGlucoseLevelString:SetText(statusBar:GetValue() .. " mg/dL")
	ChangeGlucoseBarColor()
end

-- Called whenever an event is triggered
function WowDiabetes_OnEvent(frame, event, ...)
	if event == "ADDON_LOADED" and ... == "WowDiabetes" then
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
		ColorPrint("hi")
		if glucoseLevel == nil then
			glucoseLevel = 90
			glucoseLevelString = "good"
			insulin = 10
			timeGood = 0
			isFirstTime = false
		end
=======
>>>>>>> parent of c94d7ab... fixed saved variables
=======
>>>>>>> parent of c94d7ab... fixed saved variables
=======
>>>>>>> parent of c94d7ab... fixed saved variables
		for bagId = 0, NUM_BAG_SLOTS do
			WowDiabetes_ScanBag(bagId, false)
		end
		frame:UnregisterEvent("ADDON_LOADED")
		frame:RegisterEvent("BAG_UPDATE")
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
		WowDiabetesFrameMedsAmountString:SetText(insulin)
		WowDiabetesGlucoseLevelBar_OnLoad(WowDiabetesFrameGlucoseLevelBar)
=======
>>>>>>> parent of c94d7ab... fixed saved variables
=======
>>>>>>> parent of c94d7ab... fixed saved variables
=======
>>>>>>> parent of c94d7ab... fixed saved variables
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
	glucoseLevel = glucoseLevel - 1
	WowDiabetesFrameGlucoseLevelBar:SetValue(glucoseLevel)
	if UnitIsTrivial("target") then
		ColorPrint(UnitIsTrivial("target"))
	end
	ColorPrint(UnitLevel("target"))
end

-- Called whenever the player exits combat
function WowDiabetes_HandleExitCombat()
	ColorPrint("Player exited combat!")
	insulin = insulin + 1
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
		ColorPrint("Player's auras (buffs/debuffs) changed!")
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
				purpleBag = itemName
				for i=1, #foodList do
					if foodList[i].name == itemName then
						ColorPrint(foodList[i].g)
					end
				end
				playerIsAboutToEat = false
			elseif playerIsAboutToDrink then
				ColorPrint("Player drank: " .. link .. ", change in count: " .. count)
				playerIsAboutToDrink = false
			end
		end
		glucoseLevel = glucoseLevel + 1
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


-- If the frame has been completely open for longer than a minute, 
-- hide part of it so the player has to learn to keep track on their own
 function WowDiabetes_OnUpdate(self, elapsed)
	if WowDiabetesFrameGlucoseLevelBar:IsShown() then
		meterTimer = meterTimer + elapsed
		if meterTimer >= 30 then
			WowDiabetesFrameGlucoseLevelBar:Hide()
			WowDiabetesFrameGlucoseLevelString:Hide()
			WowDiabetesFrameCloseButton:Hide()
			WowDiabetesFrame:SetSize(200, 114)
			meterTimer = 0
		end
	end
	dayTimer = dayTimer + elapsed
	--Gt/dt = (-p1-Xt)Gt+(p1 x Gb) + Rat/Vs
	if dayTimer > 1440 then
		dayTimer = 0
	end
end

-- Hide the frame entirely
function WowDiabetesCloseButton_OnClick()
	WowDiabetesFrame:Hide()
end

-- Shows the frame entirely so player can check glucose levels
function WowDiabetesGlucoseButton_OnClick()
	WowDiabetesFrame:SetSize(200, 185)
	WowDiabetesFrameGlucoseLevelBar:Show()
	WowDiabetesFrameGlucoseLevelString:Show()
	WowDiabetesFrameCloseButton:Show()
end

-- Raise your glucose level when medicine is used
function WowDiabetesMedicineButton_OnClick()
	if insulin > 0 then
		glucoseLevel = glucoseLevel + 5
		WowDiabetesFrameGlucoseLevelBar:SetValue(glucoseLevel)
		insulin = insulin - 1
		WowDiabetesFrameMedsAmountString:SetText(insulin)
	end
end

-- Update string above status bar with the new glucose level
function WowDiabetesGlucoseLevelBar_OnValueChanged()
	WowDiabetesFrameGlucoseLevelString:SetText(glucoseLevel .. " mg/dL")
	ChangeGlucoseBarColor()
end
