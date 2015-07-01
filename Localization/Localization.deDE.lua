if GetLocale() == "deDE" then
	if not WowDiabetesLocalization then
		WowDiabetesLocalization = {}
	end

	WowDiabetesLocalization["DRINK_AURA_NAME"] = "Trinken"
	WowDiabetesLocalization["FOOD_AURA_NAME"] = "Essen"
    WowDiabetesLocalization["WEAK_ALCOHOL_AURA_NAME"] = "Schwacher Alkohol"
    WowDiabetesLocalization["STRONG_ALCOHOL_AURA_NAME"] = "Starker Alkohol"

	TITLE_TEXT = "WoW Suikerziekte"
	GLUCOSE_STRING_TEXT = "Glucose"
	GLUCOSE_BUTTON_TEXT = "Controleren"
	MEDICINE_STRING_TEXT = "Geneeskunde"
	MEDICINE_BUTTON_TEXT = "Gebruiken"
	CLOSE_BUTTON_TEXT = "Afsluiten"
	WEBSITE_BUTTON_TEXT = "Website"
	UPLOAD_BUTTON_TEXT = "Export"
	DOWNLOAD_BUTTON_TEXT = "Import"
	GOOD_TEXT = "Jullie beginnen zich beter te voelen"
	OKAY_TEXT = "Je begint te duizelig voelt"
	BAD_TEXT = "Je voelt je alsof je over te geven uit bent"
end