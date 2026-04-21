# New Pharmaceutical Items for `qb-core/shared/items.lua`

If you are using `ox_inventory`, you can add these to `ox_inventory/data/items.lua`.
If using standard QBCore, add these to `qb-core/shared/items.lua`.

```lua
	-- Pharmaceutical / Pill Press Items
	['industrial_powder'] 			 = {['name'] = 'industrial_powder', 			  	['label'] = 'Industrial Powder', 			['weight'] = 500, 		['type'] = 'item', 		['image'] = 'industrial_powder.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'Bulk binding powder for pill pressing.'},
	['pressed_pills'] 			     = {['name'] = 'pressed_pills', 			  		['label'] = 'Pressed Pills', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'pressed_pills.png', 			    ['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Medical grade pressed pills. Low toxicity, low risk.'},
	['lab_maintenance_kit'] 		 = {['name'] = 'lab_maintenance_kit', 			  	['label'] = 'Lab Maintenance Kit', 		['weight'] = 5000, 		['type'] = 'item', 		['image'] = 'maintenance_kit.png', 			    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'Industrial cleaning and maintenance tools for drug laboratories.'},
```
