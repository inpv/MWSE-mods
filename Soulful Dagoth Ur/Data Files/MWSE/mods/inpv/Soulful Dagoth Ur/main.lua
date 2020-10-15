--[[
-- Soulful Dagoth Ur
-- by inpv, 2020
]]

--[[ DATA ]]
local configPath = "soulfuldagothur"
local config = mwse.loadConfig(configPath)
local tooltipsComplete = include("Tooltips Complete.interop")
local tooltipData = {
    { id = "dagoth_ur_2", description = "The soul of Voryn Dagoth, leader of the Sixth House, keeper of the Tools of Kagrenac and friend to Indoril Nerevar." },
}

if (config == nil) then
	config = { enabled = false }
end

--[[ MAIN EVENT ]]
local function initialized()
    local obj = tes3.getObject("dagoth_ur_2")
    if (obj) then
       obj.soul = 1000
    end

    if tooltipsComplete then
        for _, data in ipairs(tooltipData) do
            tooltipsComplete.addTooltip(data.id, data.description, data.itemType)
        end
    end
end

event.register("initialized", initialized)

--[[ MCM ]]
local function registerModConfig()
    local mcm = require("mcm.mcm")

    local sidebarDefault = (
        "Gives the godly Dagoth Ur form a soul of 1000 enchantment points."
    )

    local template = mcm.createTemplate("Soulful Dagoth Ur")
    template:saveOnClose(configPath, config)

    local page = template:createSideBarPage{
        description = sidebarDefault
    }

    page:createOnOffButton{
        label = "Enable tooltip",
        variable = mcm.createTableVariable{
            id = "enabled",
            table = config
        },
        description = "Turn the filled soulgem tooltip on or off [turning ON requires Tooltips Complete]."
    }

    template:register()
end

event.register("modConfigReady", registerModConfig)
