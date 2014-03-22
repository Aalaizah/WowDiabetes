if GetLocale() == "frFR" then
	if not WowDiabetesLocalization then
		WowDiabetesLocalization = {}
	end

	WowDiabetesLocalization["DRINK_AURA_NAME"] = "Boisson"
	WowDiabetesLocalization["FOOD_AURA_NAME"] = "Nourriture"

	TITLE_TEXT = "WoW Diabète"
	GLUCOSE_STRING_TEXT = "Glucose"
	GLUCOSE_BUTTON_TEXT = "Vérifier"
	MEDICINE_STRING_TEXT = "Médecine"
	MEDICINE_BUTTON_TEXT = "Utilisez"
	CLOSE_BUTTON_TEXT = "Proche"
end