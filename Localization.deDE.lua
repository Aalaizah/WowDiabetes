if GetLocale() == "deDE" then
	if not WowDiabetesLocalization then
		WowDiabetesLocalization = {}
	end

	WowDiabetesLocalization["DRINK_AURA_NAME"] = "Trinken"
	WowDiabetesLocalization["FOOD_AURA_NAME"] = "Essen"

	TITLE_TEXT = "Wow Suikerziekte"
	GLUCOSE_STRING_TEXT = "Glucose"
	GLUCOSE_BUTTON_TEXT = "Controleren"
	MEDICINE_STRING_TEXT = "Geneeskunde"
	MEDICINE_BUTTON_TEXT = "Gebruiken"
	CLOSE_BUTTON_TEXT = "Afsluiten"
end