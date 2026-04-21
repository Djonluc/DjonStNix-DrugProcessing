local Core = exports['DjonStNix-Bridge']:GetCore()

RegisterServerEvent('DjonStNix-DrugProcessing:pickedUpHydrochloricAcid', function()
	local src = source
	Core.Items.AddItem(src, "hydrochloric_acid", 1)
end)

RegisterServerEvent('DjonStNix-DrugProcessing:pickedUpSodiumHydroxide', function()
	local src = source
	Core.Items.AddItem(src, "sodium_hydroxide", 1)
end)

RegisterServerEvent('DjonStNix-DrugProcessing:pickedUpSulfuricAcid', function()
	local src = source
	Core.Items.AddItem(src, "sulfuric_acid", 1)
end)

RegisterServerEvent('DjonStNix-DrugProcessing:processChemicals', function()
	local src = source

	if Core.Items.RemoveItem(src, "sulfuric_acid", Config.MethProcessing.SulfAcid) then
		if Core.Items.RemoveItem(src, "hydrochloric_acid", Config.MethProcessing.HydAcid) then
			if Core.Items.RemoveItem(src, "sodium_hydroxide", Config.MethProcessing.SodHyd) then
				if Core.Items.AddItem(src, "liquidmix", 1) then
					-- Success
				else
					Core.Items.AddItem(src, "sulfuric_acid", Config.MethProcessing.SulfAcid)
					Core.Items.AddItem(src, "hydrochloric_acid", Config.MethProcessing.HydAcid)
					Core.Items.AddItem(src, "sodium_hydroxide", Config.MethProcessing.SodHyd)
				end
			else
				Core.Items.AddItem(src, "sulfuric_acid", Config.MethProcessing.SulfAcid)
				Core.Items.AddItem(src, "hydrochloric_acid", Config.MethProcessing.HydAcid)
				Core.UI.Notify(src, Lang:t("error.no_sodium_hydroxide"), "error")
			end
		else
			Core.Items.AddItem(src, "sulfuric_acid", Config.MethProcessing.SulfAcid)
			Core.UI.Notify(src, Lang:t("error.no_hydrochloric_acid"), "error")
		end
	else
		Core.UI.Notify(src, Lang:t("error.no_sulfuric_acid"), "error")
	end
end)

RegisterServerEvent('DjonStNix-DrugProcessing:processTempUp', function()
	local src = source

	if Core.Items.RemoveItem(src, "liquidmix", 1) then
		if Core.Items.AddItem(src, "chemicalvapor", 1) then
			-- Success
		else
			Core.Items.AddItem(src, "liquidmix", 1)
		end
	else
		Core.UI.Notify(src, Lang:t("error.no_liquidmix"), "error")
	end
end)

RegisterServerEvent('DjonStNix-DrugProcessing:processTempDown', function()
	local src = source

	if Core.Items.RemoveItem(src, "chemicalvapor", 1) then
		if Core.Items.AddItem(src, "methtray", 1) then
			-- Success
		else
			Core.Items.AddItem(src, "chemicalvapor", 1)
		end
	else
		Core.UI.Notify(src, Lang:t("error.no_chemicalvapor"), "error")
	end
end)

RegisterServerEvent('DjonStNix-DrugProcessing:processMeth', function()
	local src = source
	if Core.Items.RemoveItem(src, "methtray", 1) then
		if Core.Items.AddItem(src, "meth", Config.MethProcessing.Meth) then
			Core.UI.Notify(src, Lang:t("success.meth"), "success")
		else
			Core.Items.AddItem(src, "methtray", 1)
		end
	else
		Core.UI.Notify(src, Lang:t("error.no_methtray"), "error")
	end
end)

RegisterServerEvent('DjonStNix-DrugProcessing:processFailUp', function()
	local src = source
	Core.Items.RemoveItem(src, "liquidmix", 1)
	Core.UI.Notify(src, Lang:t("error.temp_too_high"), "error")
end)

RegisterServerEvent('DjonStNix-DrugProcessing:processFailDown', function()
	local src = source
	Core.Items.RemoveItem(src, "chemicalvapor", 1)
	Core.UI.Notify(src, Lang:t("error.temp_too_low"), "error")
end)
