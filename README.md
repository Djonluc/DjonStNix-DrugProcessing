# DjonStNix-DrugProcessing

DjonStNix-DrugProcessing is a highly optimized, modular drug harvesting and multi-stage processing system. This script provides an immersive, advanced layout for chemical management and substance creation tailored for the DjonStNix ecosystem.

## Dependencies

- [PolyZone](https://github.com/mkafrin/PolyZone)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_lib](https://github.com/overextended/ox_lib)
- [Meth Lab IPL](https://github.com/Bob74/bob74_ipl/tree/master/dlc_tuner)

## Features

- Comprehensive processing mechanics for Coke, Weed, Meth, LSD, Heroin.
- Chemical mixing and handling logic.
- Full UI integration with progress bars and targeted tasks.
- DjonStNix-Overdose compliant.

## Drug Processing Workflow Guide

### ❄️ Cocaine Chain (Multi-Stage)
| Stage | Requirement | Result | Location |
| :--- | :--- | :--- | :--- |
| **Harvest** | - | 1x Coca Leaf | Coca Field |
| **Extraction** | 100x Coca Leaf | 50x Coke (Powder) | Coke Lab (Station 1) |
| **Refining** | 50x Coke (Powder) | 1x Coke Small Brick | Coke Lab (Station 2) |
| **Packing** | 2x Coke Small Brick | 1x Big Cocaine Brick | Coke Lab (Station 3) |
| **Breakdown** | 1x Big Brick + Scale + 100 Bags | 90-100 Coke Baggies | Inventory Use |

### 💎 Meth Chain (High Volume Batch)
| Stage | Requirement | Result | Location |
| :--- | :--- | :--- | :--- |
| **Harvest** | - | 1x Chemicals | Chemical Field |
| **Chemistry** | 1x Chemicals | 10x Acids / 10x LSA | Chemical Drum |
| **Mixing** | 25x of each Acid/Base | 1x Liquid Mix | Meth Lab (Station 1) |
| **Heating** | 1x Liquid Mix | 1x Chemical Vapor | Meth Lab (Station 2) |
| **Cooling** | 1x Chemical Vapor | 1x Meth Tray | Meth Lab (Station 3) |
| **Packing** | 1x Meth Tray | 1x Sealed Meth Tray | Meth Lab (Station 4) |
| **Breakdown** | 1x Tray + Scale + 100 Bags | 90-100 Meth Baggies | Inventory Use |

### 🌿 Weed Chain
| Stage | Requirement | Result | Location |
| :--- | :--- | :--- | :--- |
| **Harvest** | - | 1x Cannabis | Weed Field |
| **Drying** | 25x Cannabis | 10x Marijuana | Weed Lab (Station 1) |
| **Packing** | 100x Marijuana | 1x Weed Brick | Weed Lab (Station 2) |
| **Breakdown** | 1x Brick + Scale + 100 Bags | 90-100 Weed Baggies | Inventory Use |

### 💉 Heroin Chain (2-Stage)
| Stage | Requirement | Result | Location |
| :--- | :--- | :--- | :--- |
| **Harvest** | - | 1x Poppy Resin | Poppy Field |
| **Cooking** | 25x Poppy Resin | 1x Heroin Paste | Heroin Lab (Cooker) |
| **Dosing** | 1x Paste + 5 Syringes | 10x Heroin (Doses) | Heroin Lab (Table) |

### 🔬 LSD Chain
- **Thionyl Chloride**: 10x LSA + 5x Chemicals $\rightarrow$ 1x Thionyl Chloride.
- **Pure LSD**: 10x LSA + 1x Thionyl Chloride $\rightarrow$ 25x LSD Tabs.

## Items

### ox_inventory Format

Place the following items configuration in your `ox_inventory/data/items.lua`:

```lua
	['wet_weed'] = {
		label = 'Moist Weed',
		weight = 3000,
		description = 'Wet weed that needs to be treated!'
	},
	['coke'] = {
		label = 'Cocaine',
		weight = 1000,
		description = 'Processed cocaine'
	},
	['coca_leaf'] = {
		label = 'Cocaine leaves',
		weight = 1500,
		description = 'Cocaine leaves that must be processed!'
	},
	['cannabis'] = {
		label = 'Cannabis',
		weight = 2500,
		description = 'Uncured cannabis'
	},
	['marijuana'] = {
		label = 'Marijuana',
		weight = 500,
		consume = 0,
		description = 'Some fine smelling buds.'
	},
	['chemicals'] = {
		label = 'Chemicals',
		weight = 1500,
		description = 'Chemicals, handle with care...'
	},
	['poppyresin'] = {
		label = 'Poppy resin',
		weight = 2000,
		description = 'It sticks to your fingers when you handle it.'
	},
	['heroin'] = {
		label = 'Heroin',
		weight = 500,
		description = 'Really addictive depressant...'
	},
	['lsa'] = {
		label = 'LSA',
		weight = 500,
		description = 'Almost ready to party...'
	},
	['lsd'] = {
		label = 'LSD',
		weight = 500,
		description = 'Lets get this party started!'
	},
	['meth'] = {
		label = 'Meth',
		weight = 500,
		consume = 0,
		description = 'Really addictive stimulant...'
	},
	['hydrochloric_acid'] = {
		label = 'Hydrochloric Acid',
		weight = 1500,
		description = 'Chemicals, handle with care!'
	},
	['sodium_hydroxide'] = {
		label = 'Sodium Hydroxide',
		weight = 1500,
		description = 'Chemicals, handle with care!'
	},

	['sulfuric_acid'] = {
		label = 'Sulfuric Acid',
		weight = 1500,
		description = 'Chemicals, handle with care!'
	},
	['thionyl_chloride'] = {
		label = 'Thionyl Chloride',
		weight = 1500,
		description = 'Chemicals, handle with care!'
	},
	['liquidmix'] = {
		label = 'Liquid Chem Mix',
		weight = 1500,
		description = 'Chemicals, handle with care!'
	},
	['bakingsoda'] = {
		label = 'Baking Soda',
		weight = 1500,
		description = 'Household Baking Soda!'
	},
	['chemicalvapor'] = {
		label = 'Chemical Vapors',
		weight = 1500,
		description = 'High Pressure Chemical Vapors, Explosive!'
	},
	['trimming_scissors'] = {
		label = 'Trimming Scissors',
		weight = 1500,
		description = 'Very Sharp Trimming Scissors'
	},
	['methtray'] = {
		label = 'Meth Tray',
		weight = 200,
		description = 'make some meth'
	},
	['methkey'] = {
		label = 'Key A',
		weight = 200,
		description = 'Random Key, with "Walter" Engraved on the Back...'
	},
	['cocainekey'] = {
		label = 'Key B',
		weight = 200,
		description = 'Random Key, with a "Razorblade" Engraved on the Back...'
	},
	['weedkey'] = {
		label = 'Key C',
		weight = 200,
		description = 'Random Key, with a "Seed" Engraved on the Back...'
	},
	['finescale'] = {
		label = 'Fine Scale',
		weight = 200,
		description = 'Scale Used for Fine Powders and Materials.'
	},
	['coke_small_brick'] = {
		label = 'Coke Package',
		weight = 350,
		description = 'Small package of cocaine, mostly used for deals and takes a lot of space'
	},
```

### qb-core Format

Place the following items configuration in your `qb-core/shared/items.lua`:

```lua
    wet_weed 		 	 	 	 = {name = "wet_weed",           			label = "Moist Weed",	 			weight = 3000, 		type = "item", 		image = "wet_weed.png", 			unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Wet weed that needs to be treated!"},
    coke 		 	 	 	     = {name = "coke",           				label = "Cocaine", 					weight = 1000,		type = "item", 		image = "coke.png", 				unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Processed cocaine"},
    coca_leaf 		 	 	 	 = {name = "coca_leaf",           			label = "Cocaine leaves",	 		weight = 1500,		type = "item", 		image = "coca_leaf.png", 			unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Cocaine leaves that must be processed !"},
    cannabis 			 		 = {name = "cannabis", 						label = "Cannabis", 				weight = 2500, 		type = "item", 		image = "cannabis.png", 			unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   expire = 90,  description = "Uncured cannabis"},
    marijuana 			 		 = {name = "marijuana", 					label = "Marijuana", 				weight = 500,		type = "item", 		image = "marijuana.png", 			unique = false, 	useable = false, 	shouldClose = true,	   combinable = nil,   expire = 90,  description = "Some fine smelling buds."},
    chemicals 		 	 	 	 = {name = "chemicals",           			label = "Chemicals",	 			weight = 1500, 		type = "item", 		image = "chemicals.png", 			unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Chemicals, handle with care..."},
    poppyresin 		 	 	 	 = {name = "poppyresin",           			label = "Poppy resin",	 			weight = 2000, 		type = "item", 		image = "poppyresin.png", 			unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "It sticks to your fingers when you handle it."},
    heroin 		 	 	 	     = {name = "heroin",           				label = "Heroin",	 				weight = 500, 		type = "item", 		image = "heroin.png", 				unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Really addictive depressant..."},
    lsa 		 	 	 	     = {name = "lsa",           				label = "LSA",	 					weight = 500, 		type = "item", 		image = "lsa.png", 					unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Almost ready to party..."},
    lsd 		 	 	 	     = {name = "lsd",           				label = "LSD",	 					weight = 500, 		type = "item", 		image = "lsd.png", 					unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Lets get this party started!"},
    meth 		 	 	 	     = {name = "meth",           				label = "Meth",	 					weight = 500, 		type = "item", 		image = "meth.png", 				unique = false, 	useable = true, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Really addictive stimulant..."},
    hydrochloric_acid 			 = {name = "hydrochloric_acid", 			label = "Hydrochloric Acid",		weight = 1500, 		type = "item", 		image = "hydrochloric_acid.png", 	unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   expire = 90,  description = "Chemicals, handle with care!"},
    sodium_hydroxide 			 = {name = "sodium_hydroxide", 				label = "Sodium Hydroxide", 		weight = 1500, 		type = "item", 		image = "sodium_hydroxide.png", 	unique = false, 	useable = true, 	shouldClose = true,	   combinable = nil,   expire = 90,  description = "Chemicals, handle with care!"},
    sulfuric_acid 		 	 	 = {name = "sulfuric_acid",           		label = "Sulfuric Acid",	 		weight = 1500, 		type = "item", 		image = "sulfuric_acid.png", 		unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Chemicals, handle with care!"},
    thionyl_chloride 		 	 = {name = "thionyl_chloride",           	label = "Thionyl Chloride",	 		weight = 1500, 		type = "item", 		image = "thionyl_chloride.png", 	unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Chemicals, handle with care!"},
    liquidmix 		 	 	     = {name = "liquidmix",           		    label = "Liquid Chem Mix",	 		weight = 1500, 		type = "item", 		image = "liquidmix.png", 		    unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Chemicals, handle with care!"},
    bakingsoda 		 	 	     = {name = "bakingsoda",           		    label = "Baking Soda",	 		    weight = 1500, 		type = "item", 		image = "bakingsoda.png", 		    unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Household Baking Soda!"},
    chemicalvapor 		 	     = {name = "chemicalvapor",           	    label = "Chemical Vapors",	 		weight = 1500, 		type = "item", 		image = "chemicalvapor.png", 	    unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "High Pressure Chemical Vapors, Explosive!"},
    trimming_scissors 		 	 = {name = "trimming_scissors",           	label = "Trimming Scissors",	 	weight = 1500, 		type = "item", 		image = "trimming_scissors.png", 	unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   expire = 90,  description = "Very Sharp Trimming Scissors"},
    methtray 					 = {name = 'methtray', 						label = 'Meth Tray', 				weight = 200, 		type = 'item', 		image = 'meth_tray.png', 			unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   description = 'make some meth'},
    methkey 					 = {name = 'methkey', 						label = 'Key A', 				    weight = 200, 		type = 'item', 		image = 'keya.png', 			    unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   description = 'Random Key, with "Walter" Engraved on the Back...'},
    cocainekey 					 = {name = 'cocainekey', 					label = 'Key B', 				    weight = 200, 		type = 'item', 		image = 'keyb.png', 			    unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   description = 'Random Key, with a "Razorblade" Engraved on the Back...'},
    weedkey 					 = {name = 'weedkey', 						label = 'Key C', 				    weight = 200, 		type = 'item', 		image = 'keyc.png', 			    unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   description = 'Random Key, with a "Seed" Engraved on the Back...'},
    finescale 					 = {name = 'finescale', 					label = 'Fine Scale', 			    weight = 200, 		type = 'item', 		image = 'finescale.png', 			unique = false, 	useable = false, 	shouldClose = false,   combinable = nil,   description = 'Scale Used for Fine Powders and Materials.'},
    coke_small_brick 		 	 = {name = 'coke_small_brick', 				label = 'Coke Package', 			weight = 350, 		type = 'item', 		image = 'coke_small_brick.png', 	unique = false, 	useable = false, 	shouldClose = true,	   combinable = nil,   description = 'Small package of cocaine, mostly used for deals and takes a lot of space'},
```
