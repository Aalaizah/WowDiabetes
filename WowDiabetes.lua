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

-- test variable
local purpleBag = 0;

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
end

-- Called whenever an event is triggered
function WowDiabetes_OnEvent(frame, event, ...)
	if event == "ADDON_LOADED" and ... == "WowDiabetes" then
		for bagId = 0, NUM_BAG_SLOTS do
			WowDiabetes_ScanBag(bagId, false)
		end
		frame:UnregisterEvent("ADDON_LOADED")
		frame:RegisterEvent("BAG_UPDATE")
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
				playerIsAboutToEat = false
			elseif playerIsAboutToDrink then
				ColorPrint("Player drank: " .. link .. ", change in count: " .. count)
				playerIsAboutToDrink = false
			end
		end
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

-- Glycemic Indexes
local foodList = {"Tough Hunk of Bread", "Freshly Baked Bread", "Moist Cornbread", "Slitherskin Mackerel", "Longjaw Mud Snapper", "Bristle Whisker Catfish",
	"Forest Mushroom Cap", "Red-speckled Mushroom", "Tough Jerky", "Haunch of Meat", "Mutton Chop", "Darnassian Bleu", "Dalaran Sharp", "Dwarven Mild",
	"Shiny Red Apple", "Tel'Abim Banana", "Snapvine Watermelon"}
local drinkList = {"Refreshing Spring Water", "Ice Cold Milk", "Melon Juice", "Bottle of Pinot Noir", "Skin of Dwarven Stout", "Flask of Port", 
	"Flagon of Mead", "Junglevine Wine", "Rhapsody Malt", "Thunder Ale"}