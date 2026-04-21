local Core = exports['DjonStNix-Bridge']:GetCore()

-- Joint rolling and bagging logic (Remaining unique inventory-crafting)

RegisterServerEvent('DjonStNix-DrugProcessing:rollJoint', function()
	local src = source

	if Core.Items.RemoveItem(src, 'marijuana', 1) then
		if Core.Items.RemoveItem(src, 'rolling_paper', 1) then
			if Core.Items.AddItem(src, 'joint', 1) then
				Core.UI.Notify(src, Lang:t("success.joint"), "success")
			else
				Core.Items.AddItem(src, 'marijuana', 1)
				Core.Items.AddItem(src, 'rolling_paper', 1)
			end
		else
			Core.Items.AddItem(src, 'marijuana', 1)
			Core.UI.Notify(src, Lang:t("error.no_item", {item = "Rolling Paper"}), "error")
		end
	else
		Core.UI.Notify(src, Lang:t("error.no_marijuhana"), "error")
	end
end)

Core.Items.RegisterUsableItem("rolling_paper", function(source, item)
    TriggerClientEvent('DjonStNix-DrugProcessing:client:rollJoint', source, 'marijuana', item)
end)

RegisterServerEvent('DjonStNix-DrugProcessing:bagskunk', function()
	local src = source

	if Core.Items.RemoveItem(src, 'marijuana', 1) then
		if Core.Items.RemoveItem(src, 'empty_weed_bag', 1) then
			if Core.Items.AddItem(src, 'weed_skunk', 1) then
				Core.UI.Notify(src, Lang:t("success.baggy"), "success")
			else
				Core.Items.AddItem(src, 'marijuana', 1)
				Core.Items.AddItem(src, 'empty_weed_bag', 1)
			end
		else
			Core.Items.AddItem(src, 'marijuana', 1)
			Core.UI.Notify(src, Lang:t("error.no_item", {item = "Empty Weed Bag"}), "error")
		end
	else
		Core.UI.Notify(src, Lang:t("error.no_marijuhana"), "error")
	end
end)

Core.Items.RegisterUsableItem("empty_weed_bag", function(source, item)
    TriggerClientEvent('DjonStNix-DrugProcessing:client:bagskunk', source, 'marijuana', item)
end)
