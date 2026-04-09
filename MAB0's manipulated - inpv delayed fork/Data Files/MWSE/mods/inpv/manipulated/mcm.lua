local this = {
  id = "MAB0_manipulated",
  name = "MetaBarj0's manipulated (inpv delayed fork)",
  config = {
    calmHumanoidEnabled = true,
    commandHumanoidEnabled = true,
    demoralizeHumanoidEnabled = true,
    frenzyHumanoidEnabled = true,
    rallyHumanoidEnabled = true,
    charmEnabled = true,
    highSkillPreventsCrime = true,
    crimeAvoidanceThreshold = 100
  },
}

local function loadConfig()
  local savedConfig = mwse.loadConfig( this.id )
  if savedConfig then
    this.config = savedConfig
    -- safely add new settings if they are missing from an old save file
    if this.config.highSkillPreventsCrime == nil then
      this.config.highSkillPreventsCrime = true
    end
    if this.config.crimeAvoidanceThreshold == nil then
      this.config.crimeAvoidanceThreshold = 100
    end
  end
end

local function registerMcm()
  local localeStrings = require( "inpv.manipulated.localeStrings" )
  local locale = require( "MAB0.locale" ).new( localeStrings )

  local template = mwse.mcm.createTemplate( this.name )

  template:saveOnClose( this.id, this.config )

  local page = template:createPage()

  page:createOnOffButton( {
    label = locale.getLocalizedString( "mcm.calmHumanoidEnabled" ),
    variable = mwse.mcm.createTableVariable( {
      id = "calmHumanoidEnabled",
      table = this.config
    } )
  } )

  page:createOnOffButton( {
    label = locale.getLocalizedString( "mcm.commandHumanoidEnabled" ),
    variable = mwse.mcm.createTableVariable( {
      id = "commandHumanoidEnabled",
      table = this.config
    } )
  } )

  page:createOnOffButton( {
    label = locale.getLocalizedString( "mcm.demoralizeHumanoidEnabled" ),
    variable = mwse.mcm.createTableVariable( {
      id = "demoralizeHumanoidEnabled",
      table = this.config
    } )
  } )

  page:createOnOffButton( {
    label = locale.getLocalizedString( "mcm.frenzyHumanoidEnabled" ),
    variable = mwse.mcm.createTableVariable( {
      id = "frenzyHumanoidEnabled",
      table = this.config
    } )
  } )

  page:createOnOffButton( {
    label = locale.getLocalizedString( "mcm.rallyHumanoidEnabled" ),
    variable = mwse.mcm.createTableVariable( {
      id = "rallyHumanoidEnabled",
      table = this.config
    } )
  } )

  page:createOnOffButton( {
    label = locale.getLocalizedString( "mcm.charmEnabled" ),
    variable = mwse.mcm.createTableVariable( {
      id = "charmEnabled",
      table = this.config
    } )
  } )

  page:createOnOffButton({
    label = "Enable Crime Avoidance with high Illusion skill",
    variable = mwse.mcm.createTableVariable({
      id = "highSkillPreventsCrime",
      table = this.config
    })
  })

  page:createSlider({
    label = "Skill Threshold for Crime Avoidance (Default 100)",
    min = 0,
    max = 100,
    variable = mwse.mcm.createTableVariable({
      id = "crimeAvoidanceThreshold",
      table = this.config
    })
  })

  mwse.mcm.register( template )
end

local function getConfig()
  return this.config
end

return {
  new = function()
    loadConfig()
    registerMcm()

    return {
      getConfig = getConfig
    }
  end
}