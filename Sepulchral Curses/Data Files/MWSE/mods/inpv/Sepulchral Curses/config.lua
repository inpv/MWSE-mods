local configPath = "sepulchralcurses"
local config = mwse.loadConfig(configPath)

if (config == nil) then
	config = {
    enabled = true,
    spawnFrostDaedra = false,
    pickEquippedOnly = true,
    displayMessages = true,
    includeMiscObjects = true,
    easyMode = false,
    lowerBorder = 70,
    upperBorder = 75
  }
end

return config
