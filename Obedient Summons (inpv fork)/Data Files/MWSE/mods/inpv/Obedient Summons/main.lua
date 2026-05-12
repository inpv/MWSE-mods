---@diagnostic disable: undefined-field
local mod = {
    name = "Obedient Summons (inpv fork)",
    ver = "2.1",
    cf = {
        onOff               = true,
        conjurationRequired = 70,
    }
}
local cf = mwse.loadConfig(mod.name, mod.cf)
local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
if not framework then return end
tes3.claimSpellEffectId("soulRelease", 787)


---comment
---@param e table|deathEventData
event.register("death", function(e)
    local doit = e.reference and e.reference.data and e.reference.data.spa_SR_summonnedSoul
    if doit then
        local summon = e.reference
        local position = summon.position
        summon:delete()
        timer.start{duration = 0.5, callback = function()
        tes3.createVisualEffect{object = "VFX_Summon_Start", repeatCount = 1, position = position}
        end}
    end
end)

---comment
---@param e table|spellTickEventData
event.register("spellTick", function(e)
    if e.target ~= tes3.player then return end
    local instance = e.effectInstance
    if not (instance.createdData and instance.createdData.object and (instance.createdData.object.objectType == tes3.objectType.reference)) then
        return
    end
    if not instance.createdData.object.data.spa_SR_summonnedCreature then
    instance.createdData.object.data.spa_SR_summonnedCreature = true
    end
end)

local function valid(summon)
    if (summon and summon.data and summon.data.spa_SR_summonnedSoul) then
        return true
    elseif (summon and summon.data and summon.data.spa_SR_summonnedCreature) then
        return true
    end
    return false
end
---comment
---@param e table|activateEventData
event.register("activate", function(e)
    if not cf.onOff then return end
    if e.activator ~= tes3.player then return end
    local summon = e.target
    if not valid(summon) then
        return
    end
    tes3.messageBox{message = "How may I serve you, Master?", buttons = {"Wait here", "Patrol the area", "Follow me", "Show me what you hoard", "Begone"}, callback =
        ---comment
        ---@param f buttonPressedEventData
        function(f)
            if f.button == 0 then
                tes3.setAIWander{reference = summon, idles = {60, 20, 20, 0, 0, 0, 0, 0, 0}, range = 0, reset = false}
            elseif f.button == 1 then
                timer.delayOneFrame(function()
                    tes3.setAIWander{reference = summon, idles = {60, 20, 20, 0, 0, 0, 0, 0, 0}, range = 2000, reset = false}
                end)
            elseif f.button == 2 then
                tes3.setAIFollow{reference = summon, target = tes3.player, reset = false}
            elseif f.button == 3 then
                timer.delayOneFrame(function()
                    tes3.showContentsMenu{reference = summon, pickpocket = false}
                    end)
            elseif f.button == 4 then
                summon.mobile:kill()
            end
        end}
    return false
end, {priority = 100})

---comment
---@param ref tes3reference
---@param location tes3vector3
---@return boolean
local function getDistace(ref, location)
    return (ref.position:distance(location) <= 200)
end

local function onCollision(e)
    local position = e.collision and e.collision.point
    if not position then return end
    local caster = e.sourceInstance.caster and e.sourceInstance.caster.mobile
    local summon
    for _,cell in pairs(tes3.getActiveCells()) do
        for ref in cell:iterateReferences(tes3.objectType.miscItem) do
            if (ref
            and ref.object
            and ref.object.isSoulGem
            and ref.itemData
            and ref.itemData.soul
            and getDistace(ref, position)) then
                summon = tes3.createReference{object = ref.itemData.soul, position = position, cell = cell}
                tes3.playSound{sound = "conjuration hit", reference = tes3.player}
                for _,child in ipairs(summon.sceneNode.children) do
                    if child then
                        tes3.createVisualEffect{object = "VFX_Summon_Start", repeatCount = 1, avObject = child}
                    end
                end
                summon.mobile.fight = 30
                tes3.setAIFollow{reference = summon, target = tes3.player, reset = false}
                for _,stack in pairs(summon.object.inventory) do
                    tes3.removeItem{reference = summon, item = stack.object, playSound = false}
                end
                tes3.addItem{reference = summon, item = "random_weapon_melee_basic"}
                summon.data.spa_SR_summonnedSoul = true
                if caster then
                    summon.data.spa_StealSummon_summonnedCreature = {summonner = caster, value = caster:getSkillValue(tes3.skill.conjuration)}
                end
                if ref.itemData.owner then
                    tes3.triggerCrime{criminal = caster, type = tes3.crimeType.theft, victim = ref.itemData.owner, value = ref.object.value}
                end
                ref:delete()
                break
            end
        end
    end
    if not summon then
        tes3.messageBox("%s", tes3.findGMST("sMagicInvalidTarget").value)
    end
end

local function addEffect()
	framework.effects.conjuration.createBasicEffect({
		-- Base information.
		id = tes3.effect.soulRelease,
		name = "Soul Release",
		description = "Summons the Soul of a Fallen One contained inside of a Soul Gem.",

		-- Basic dials.
		baseCost = 200.0,

		-- Various flags.
		allowEnchanting = false,
        allowSpellmaking = true,
        canCastSelf = false,
        canCastTouch = false,
        canCastTarget = true,
        hasContinuousVFX = false,
        nonRecastable = false,
        casterLinked = false,
        hasNoDuration = true,
        hasNoMagnitude = true,

		-- Graphics/sounds.
		icon = "inpv\\Soul_Release_MW.tga",
        lighting = { 0.8, 0.8, 0.2 },
		-- Required callbacks.
		onTick = function(e) e:trigger() end,
        onCollision = onCollision
	})
end
event.register("magicEffectsResolved", addEffect)

local function registerSpells()
    framework.spells.createBasicSpell({
        id = "Spa_ME_SoulRelease",
        name = "Soul Release",
        effect = tes3.effect.soulRelease,
        range = tes3.effectRange.target,
    })
end
event.register("MagickaExpanded:Register", registerSpells)

local count = 0

local function onMobileActivated(e)
    if e.reference.object.objectType ~= tes3.objectType.npc then
        return
    end

    if not (e.mobile and e.mobile.object:offersService(tes3.merchantService.spells)) then
        return
    end

    if tes3.player then
        local conjSkill = tes3.player.mobile:getSkillValue(tes3.skill.conjuration)
        if conjSkill < (cf.conjurationRequired or 70) then
            return
        end
    end

    if e.reference.data.spammer_srdoonce then
        return
    end

    if math.random(0, 100) < 5 then
        tes3.addSpell({reference = e.mobile, spell = "Spa_ME_SoulRelease"})
        --print(e.mobile.object.name)
        count = 0
    else
        count = count+1
        --print(count)
        if count >= 20 then
            tes3.addSpell({reference = e.mobile, spell = "Spa_ME_SoulRelease"})
            --print(e.mobile.object.name)
            count = 0
        end
    end
    e.reference.data.spammer_srdoonce = true
end
event.register("mobileActivated", onMobileActivated, {priority = -500})

local function registerModConfig()
    local template = mwse.mcm.createTemplate(mod.name)
    template:saveOnClose(mod.name, cf)
    template:register()

    local page = template:createSideBarPage({label = '"' .. mod.name .. '" Settings'})
    page.sidebar:createInfo{
        text = 'Welcome to "' .. mod.name .. '" Configuration Menu.\n\nA mod by Spammer & inpv.'
    }
    page.sidebar:createHyperLink{
        text = "Spammer's Nexus Profile",
        url  = "https://www.nexusmods.com/users/140139148?tab=user+files"
    }

    -- General
    local catGeneral = page:createCategory("General")
    catGeneral:createOnOffButton{
        label       = "Enable mod",
        description = "Toggles the mod on or off.",
        variable    = mwse.mcm.createTableVariable{id = "onOff", table = cf}
    }

    -- Soul Release
    local catSR = page:createCategory("Soul Release")
    catSR:createSlider{
        label       = "Required Conjuration skill: %s",
        description = "Spell merchants will only offer Soul Release once the player reaches this Conjuration skill level.\n\n"
                   .. "The check runs again each time an NPC is activated, so the spell will appear naturally as your skill grows.",
        min      = 0,
        max      = 100,
        step     = 1,
        jump     = 5,
        variable = mwse.mcm.createTableVariable{id = "conjurationRequired", table = cf}
    }
end
event.register("modConfigReady", registerModConfig)

local function initialized()
    print("["..mod.name..", by Spammer & inpv] "..mod.ver.." Initialized!")
end
event.register("initialized", initialized, {priority = -1000})

