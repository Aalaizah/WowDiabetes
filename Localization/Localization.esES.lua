if GetLocale() == "esES" then
	if not WowDiabetesLocalization then
		WowDiabetesLocalization = {}
	end

	WowDiabetesLocalization["DRINK_AURA_NAME"] = "Beber"
	WowDiabetesLocalization["FOOD_AURA_NAME"] = "Comida"

	TITLE_TEXT = "WoW Diabetes"
	GLUCOSE_STRING_TEXT = "Glucosa"
	GLUCOSE_BUTTON_TEXT = "Controlar"
	MEDICINE_STRING_TEXT = "Medicina"
	MEDICINE_BUTTON_TEXT = "Utilizar"
	CLOSE_BUTTON_TEXT = "Cerrar"		
	GOOD_TEXT = "Usted está comenzando a sentirse mejor"
	OKAY_TEXT = "Vous commencez à vous sentir étourdi"
	BAD_TEXT = "Te sientes como si estuvieras a punto de desmayarse"
end