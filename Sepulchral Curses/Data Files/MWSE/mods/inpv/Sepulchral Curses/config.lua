local configPath = "sepulchralcurses"

local defaultConfig = {
  enabled = true,
  spawnFrostDaedra = false,
  pickEquippedOnly = true,
  displayMessages = true,
  includeMiscObjects = true,
  easyMode = false,
  lowerBorder = 70,
  upperBorder = 75
}

local config = mwse.loadConfig(configPath, defaultConfig)

return config
