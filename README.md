# 👑 DjonStNix-DrugProcessing (Elite Tier)

DjonStNix-DrugProcessing is a high-fidelity, institutional-grade drug economy system for FiveM. Built on the **Sovereign Economy** model, it transforms drug production into a modular, persistent, and skill-based experience.

---

## 🚀 Key Features

*   **🛠️ Lab Maintenance (Phase 4):** Labs degrade with use. Low condition reduces purity and increases toxic exposure. Use Maintenance Kits to restore them.
*   **📈 Dynamic Market (Phase 7):** Prices fluctuate based on server-wide supply and demand. Saturating the market drops prices; waiting for resets recovers them.
*   **🎖️ Dealer Reputation:** Sell high-purity product to level up. Higher ranks unlock massive payout bonuses and protection.
*   **🔬 Pharmaceutical Refinement (Phase 6):** Press "Pressed Pills" with low toxicity and high medical utility for elite players.
*   **🛡️ Toxicity System:** Fully integrated with `DjonStNix-Overdose`. Processing chemicals without protection (Gas Masks) will slowly poison you.
*   **⚖️ Purity-Based Payouts:** Every batch has a unique purity (0-100%). Quality directly affects your street price.
*   **🚔 Undercover Risk:** 2% chance that any street dealer is an undercover cop.

---

## 📦 Dependencies

*   [qb-core](https://github.com/qbcore-framework/qb-core)
*   [ox_lib](https://github.com/overextended/ox_lib)
*   [ox_target](https://github.com/overextended/ox_target)
*   [oxmysql](https://github.com/overextended/oxmysql)
*   [DjonStNix-Overdose](https://github.com/Djonluc/DjonStNix-Overdose) (Recommended)

---

## 🔧 Installation

1.  **Download & Move:** Place `DjonStNix-DrugProcessing` into your resources folder.
2.  **Database:** Import the consolidated SQL file: `sql/install.sql`.
3.  **Manifest:** Ensure `ensure DjonStNix-DrugProcessing` is in your `server.cfg`.
4.  **Items:** Add the items below to your inventory system.
5.  **Images:** Move all `.png` files from the `assets/` folder to your inventory's image directory.

---

## 🎒 COMPLETE ITEM LIST (Inventory Setup)

### 1️⃣ ox_inventory (`data/items.lua`)

```lua
-- [[ HARVESTING & RAW MATERIALS ]]
['cannabis'] = { label = 'Cannabis', weight = 2500, description = 'Uncured cannabis plant material.' },
['coca_leaf'] = { label = 'Coca Leaf', weight = 1500, description = 'Raw leaves used for cocaine extraction.' },
['poppyresin'] = { label = 'Poppy Resin', weight = 2000, description = 'Sticky resin harvested from poppies.' },
['chemicals'] = { label = 'Generic Chemicals', weight = 1500, description = 'Generic industrial chemicals.' },
['hydrochloric_acid'] = { label = 'Hydrochloric Acid', weight = 1500, description = 'Corrosive acid for chemical reactions.' },
['sulfuric_acid'] = { label = 'Sulfuric Acid', weight = 1500, description = 'Strong mineral acid for synthesis.' },
['sodium_hydroxide'] = { label = 'Sodium Hydroxide', weight = 1500, description = 'Lye used in drug purification.' },

-- [[ LAB CHEMICALS & INTERMEDIATES ]]
['thionyl_chloride'] = { label = 'Thionyl Chloride', weight = 1500, description = 'Highly reactive chemical for LSD synthesis.' },
['liquidmix'] = { label = 'Liquid Chem Mix', weight = 1500, description = 'Active drug precursor liquid.' },
['chemicalvapor'] = { label = 'Chemical Vapors', weight = 1500, description = 'Compressed explosive chemical gases.' },
['lsa'] = { label = 'LSA', weight = 500, description = 'Semi-synthetic precursor to LSD.' },
['bakingsoda'] = { label = 'Baking Soda', weight = 1500, description = 'Sodium bicarbonate for cutting/processing.' },
['industrial_powder'] = { label = 'Industrial Powder', weight = 500, description = 'Binding agent for pharmaceutical pills.' },
['coke'] = { label = 'Cocaine Powder', weight = 500, description = 'Raw cocaine powder before extraction.' },

-- [[ WHOLESALE & BULK PRODUCTS ]]
['weed_brick'] = { label = 'Weed Brick', weight = 1000, description = '1000g compressed marijuana brick.' },
['coke_brick'] = { label = 'Big Coke Brick', weight = 1000, description = '1kg brick of pure cocaine.' },
['coke_small_brick'] = { label = 'Small Coke Brick', weight = 500, description = 'Half-kilogram block of cocaine.' },
['methtray'] = { label = 'Meth Tray', weight = 2000, description = 'Large tray of cooling blue crystal meth.' },
['heroin_paste'] = { label = 'Heroin Paste', weight = 2000, description = 'Raw concentrated heroin paste base.' },
['lsd_sheet'] = { label = 'LSD Sheet', weight = 500, description = 'Blotter sheet containing 40 LSD tabs.' },

-- [[ RETAIL & CONSUMER PRODUCTS ]]
['weed_baggy'] = { label = 'Weed Baggy', weight = 100, description = 'Retail marijuana baggy.' },
['cokebaggy'] = { label = 'Coke Baggy', weight = 100, description = 'Street-ready cocaine baggy.' },
['meth'] = { label = 'Blue Meth', weight = 100, description = 'High-purity blue crystal meth shards.' },
['heroin'] = { label = 'Heroin Shot', weight = 100, description = 'Retail dose of high-grade heroin.' },
['lsd'] = { label = 'LSD Tab', weight = 50, description = 'A single hit of blotter LSD tab.' },
['marijuana'] = { label = 'Marijuana Buds', weight = 200, description = 'Dried marijuana flower buds.' },
['weed_skunk'] = { label = 'Skunk Weed', weight = 100, description = 'Highly potent indoor marijuana.' },
['joint'] = { label = 'Joint', weight = 50, description = 'A hand-rolled marijuana cigarette.' },
['pressed_pills'] = { label = 'Pressed Pills', weight = 100, description = 'Industrial-grade pharmaceutical pills.' },

-- [[ TOOLS & LABORATORY SUPPLIES ]]
['finescale'] = { label = 'Fine Scale', weight = 200, description = 'Digital scale for precise drug weighing.' },
['trimming_scissors'] = { label = 'Trimming Scissors', weight = 500, description = 'Heavy duty shears for plant processing.' },
['syringe'] = { label = 'Empty Syringe', weight = 50, description = 'Empty syringe for heroin preparation.' },
['lab_maintenance_kit'] = { label = 'Maintenance Kit', weight = 5000, description = 'Industrial tools to restore lab condition.' },
['rolling_paper'] = { label = 'Rolling Paper', weight = 10, description = 'Pre-cut papers for rolling joints.' },
['empty_weed_bag'] = { label = 'Empty Small Bag', weight = 10, description = 'Small plastic baggies for packaging.' },

-- [[ LABORATORY ACCESS KEYS ]]
['weedkey'] = { label = 'Key C (Seed)', weight = 50, description = 'Access key for the Weed Warehouse.' },
['cokekey'] = { label = 'Key B (Razor)', weight = 50, description = 'Access key for the Cocoa Factory.' },
['methkey'] = { label = 'Key A (Walter)', weight = 50, description = 'Access key for the Crystal Lab.' },
```

### 2️⃣ qb-inventory (`shared/items.lua`)

```lua
-- [[ HARVESTING & RAW MATERIALS ]]
['cannabis'] = {['name'] = 'cannabis', ['label'] = 'Cannabis', ['weight'] = 2500, ['type'] = 'item', ['image'] = 'cannabis.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Uncured cannabis plants.'},
['coca_leaf'] = {['name'] = 'coca_leaf', ['label'] = 'Cocaine Leaves', ['weight'] = 1500, ['type'] = 'item', ['image'] = 'coca_leaf.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Raw leaves for cocaine extraction.'},
['poppyresin'] = {['name'] = 'poppyresin', ['label'] = 'Poppy Resin', ['weight'] = 2000, ['type'] = 'item', ['image'] = 'poppyresin.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Sticky resin harvested from poppies.'},
['chemicals'] = {['name'] = 'chemicals', ['label'] = 'Mixed Chemicals', ['weight'] = 1500, ['type'] = 'item', ['image'] = 'chemicals.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Generic industrial chemicals.'},
['hydrochloric_acid'] = {['name'] = 'hydrochloric_acid', ['label'] = 'Hydrochloric Acid', ['weight'] = 1500, ['type'] = 'item', ['image'] = 'hydrochloric_acid.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'A corrosive mineral acid.'},
['sodium_hydroxide'] = {['name'] = 'sodium_hydroxide', ['label'] = 'Sodium Hydroxide', ['weight'] = 1500, ['type'] = 'item', ['image'] = 'sodium_hydroxide.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Industrial lye for synthesis.'},
['sulfuric_acid'] = {['name'] = 'sulfuric_acid', ['label'] = 'Sulfuric Acid', ['weight'] = 1500, ['type'] = 'item', ['image'] = 'sulfuric_acid.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Strong mineral acid for lab reactions.'},

-- [[ LAB CHEMICALS & INTERMEDIATES ]]
['thionyl_chloride'] = {['name'] = 'thionyl_chloride', ['label'] = 'Thionyl Chloride', ['weight'] = 1500, ['type'] = 'item', ['image'] = 'thionyl_chloride.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Chemical for LSD synthesis.'},
['liquidmix'] = {['name'] = 'liquidmix', ['label'] = 'Liquid Chem Mix', ['weight'] = 1500, ['type'] = 'item', ['image'] = 'liquidmix.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Active drug precursor liquid.'},
['chemicalvapor'] = {['name'] = 'chemicalvapor', ['label'] = 'Chemical Vapors', ['weight'] = 1500, ['type'] = 'item', ['image'] = 'chemicalvapor.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Compressed chemical vapors.'},
['lsa'] = {['name'] = 'lsa', ['label'] = 'LSA', ['weight'] = 500, ['type'] = 'item', ['image'] = 'lsa.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Synthesized precursor to LSD.'},
['bakingsoda'] = {['name'] = 'bakingsoda', ['label'] = 'Baking Soda', ['weight'] = 1500, ['type'] = 'item', ['image'] = 'bakingsoda.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Sodium bicarbonate for cutting.'},
['industrial_powder'] = {['name'] = 'industrial_powder', ['label'] = 'Industrial Powder', ['weight'] = 500, ['type'] = 'item', ['image'] = 'industrial_powder.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Pill pressing binding agent.'},
['coke'] = {['name'] = 'coke', ['label'] = 'Cocaine Powder', ['weight'] = 500, ['type'] = 'item', ['image'] = 'coke.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Raw cocaine powder.'},

-- [[ WHOLESALE & BULK PRODUCTS ]]
['weed_brick'] = {['name'] = 'weed_brick', ['label'] = 'Weed Brick', ['weight'] = 1000, ['type'] = 'item', ['image'] = 'weed_brick.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = '1kg compressed marijuana.'},
['coke_brick'] = {['name'] = 'coke_brick', ['label'] = 'Big Coke Brick', ['weight'] = 1000, ['type'] = 'item', ['image'] = 'coke_brick.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = '1kg brick of pure cocaine.'},
['coke_small_brick'] = {['name'] = 'coke_small_brick', ['label'] = 'Small Coke Brick', ['weight'] = 500, ['type'] = 'item', ['image'] = 'coke_small_brick.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Half-kilo blocks.'},
['methtray'] = {['name'] = 'methtray', ['label'] = 'Meth Tray', ['weight'] = 2000, ['type'] = 'item', ['image'] = 'meth_tray.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Bulk tray of blue crystal.'},
['heroin_paste'] = {['name'] = 'heroin_paste', ['label'] = 'Heroin Paste', ['weight'] = 2000, ['type'] = 'item', ['image'] = 'heroin_paste.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Wholesale heroin base.'},
['lsd_sheet'] = {['name'] = 'lsd_sheet', ['label'] = 'LSD Sheet', ['weight'] = 500, ['type'] = 'item', ['image'] = 'lsd_sheet.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = '40 LSD tabs.'},

-- [[ RETAIL & CONSUMER PRODUCTS ]]
['weed_baggy'] = {['name'] = 'weed_baggy', ['label'] = 'Weed Baggy', ['weight'] = 100, ['type'] = 'item', ['image'] = 'weed_baggy.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Retail marijuana baggy.'},
['cokebaggy'] = {['name'] = 'cokebaggy', ['label'] = 'Coke Baggy', ['weight'] = 100, ['type'] = 'item', ['image'] = 'cocainebaggy.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Retail cocaine baggy.'},
['meth'] = {['name'] = 'meth', ['label'] = 'Blue Meth', ['weight'] = 100, ['type'] = 'item', ['image'] = 'meth.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = false, ['description'] = 'Blue meth shards.'},
['heroin'] = {['name'] = 'heroin', ['label'] = 'Heroin Shot', ['weight'] = 100, ['type'] = 'item', ['image'] = 'heroin.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Retail heroin shot.'},
['lsd'] = {['name'] = 'lsd', ['label'] = 'LSD Tab', ['weight'] = 50, ['type'] = 'item', ['image'] = 'lsd.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'A single LSD hit.'},
['marijuana'] = {['name'] = 'marijuana', ['label'] = 'Marijuana Buds', ['weight'] = 200, ['type'] = 'item', ['image'] = 'marijuana.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = true, ['description'] = 'Dried buds.'},
['weed_skunk'] = {['name'] = 'weed_skunk', ['label'] = 'Skunk Weed', ['weight'] = 100, ['type'] = 'item', ['image'] = 'marijuana.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = true, ['description'] = 'Potent indoor buds.'},
['joint'] = {['name'] = 'joint', ['label'] = 'Joint', ['weight'] = 50, ['type'] = 'item', ['image'] = 'joint.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'A rolled joint.'},
['pressed_pills'] = {['name'] = 'pressed_pills', ['label'] = 'Pressed Pills', ['weight'] = 100, ['type'] = 'item', ['image'] = 'pressed_pills.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Pharma grade pills.'},

-- [[ TOOLS & LABORATORY SUPPLIES ]]
['finescale'] = {['name'] = 'finescale', ['label'] = 'Fine Scale', ['weight'] = 200, ['type'] = 'item', ['image'] = 'finescale.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Digital scale.'},
['trimming_scissors'] = {['name'] = 'trimming_scissors', ['label'] = 'Trimming Scissors', ['weight'] = 500, ['type'] = 'item', ['image'] = 'trimming_scissors.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Heavy shears.'},
['syringe'] = {['name'] = 'syringe', ['label'] = 'Empty Syringe', ['weight'] = 50, ['type'] = 'item', ['image'] = 'syringe.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Injection prep.'},
['lab_maintenance_kit'] = {['name'] = 'lab_maintenance_kit', ['label'] = 'Maintenance Kit', ['weight'] = 5000, ['type'] = 'item', ['image'] = 'maintenance_kit.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Lab repair tools.'},
['rolling_paper'] = {['name'] = 'rolling_paper', ['label'] = 'Rolling Paper', ['weight'] = 10, ['type'] = 'item', ['image'] = 'joint.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'King size papers.'},
['empty_weed_bag'] = {['name'] = 'empty_weed_bag', ['label'] = 'Empty Small Bag', ['weight'] = 10, ['type'] = 'item', ['image'] = 'marijuana.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Self-sealing baggies.'},

-- [[ LABORATORY ACCESS KEYS ]]
['weedkey'] = {['name'] = 'weedkey', ['label'] = 'Key C (Seed)', ['weight'] = 50, ['type'] = 'item', ['image'] = 'keyc.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Warehouse lab key.'},
['cokekey'] = {['name'] = 'cokekey', ['label'] = 'Key B (Razor)', ['weight'] = 50, ['type'] = 'item', ['image'] = 'keyb.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Factory lab key.'},
['methkey'] = {['name'] = 'methkey', ['label'] = 'Key A (Walter)', ['weight'] = 50, ['type'] = 'item', ['image'] = 'keya.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['description'] = 'Crystal lab key.'},
```

---

## 🔬 Drug Processing Workflow

### ❄️ Cocaine Chain
| Stage | Requirement | Result |
| :--- | :--- | :--- |
| **Harvest** | - | 1x Coca Leaf |
| **Extraction** | 100x Coca Leaf | 50x Coke (Powder) |
| **Refining** | 50x Coke (Powder) | 1x Coke Small Brick |
| **Packing** | 2x Coke Small Brick | 1x **Big Coke Brick** |
| **Breakdown** | 1x Brick + 100 Bags + Scale | 100x Coke Baggies |

### 💎 Meth Chain
| Stage | Requirement | Result |
| :--- | :--- | :--- |
| **Harvest** | - | 1x Chemicals |
| **Mixing** | 25x Acid + 25x Lye | 1x Liquid Mix |
| **Heating** | 1x Liquid Mix | 1x Chemical Vapor |
| **Cooling** | 1x Chemical Vapor | 1x **Meth Tray** |
| **Breakdown** | 1x Tray + 100 Bags + Scale | 100x Meth Shards |

### 🌿 Weed Chain
| Stage | Requirement | Result |
| :--- | :--- | :--- |
| **Harvest** | - | 1x Cannabis |
| **Drying** | 25x Cannabis | 10x Marijuana |
| **Packing** | 100x Marijuana | 1x **Weed Brick** |
| **Breakdown** | 1x Brick + 100 Bags + Scale | 100x Weed Baggies |

---

## 💰 Economy (Dealer Standard Prices)

*   **Heroin:** $1,500 / dose
*   **LSD:** $750 / tab
*   **Meth:** $400 / shard
*   **Cocaine:** $250 / baggy
*   **Weed:** $120 / baggy
*   **Pressed Pills:** $200 / pill

---

## 🚔 Police Alerts
Selling drugs has a **15% base chance** to alert police. Higher-tier drugs increase risk significantly.

---

## 👨‍💻 Developed by DjonStNix
Need support? Join us on [Discord](https://discord.gg/s7GPUHWrS7).
