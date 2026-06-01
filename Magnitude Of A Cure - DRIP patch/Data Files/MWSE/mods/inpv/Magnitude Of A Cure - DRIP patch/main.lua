-- Cure Magnitude × DRIP compatibility patch
-- Fixes cure effect magnitudes on DRIP-generated loot copies.

local function patchCureEffects(object)
    -- Only process alchemy and enchanted items
    local validTypes = {
        [tes3.objectType.alchemy]      = true,
        [tes3.objectType.enchantment]  = true,
    }
    if not validTypes[object.objectType] then return end

    -- Load MoaC's config and common module (they're already in memory after init)
    local ok, common = pcall(require, "cureMagnitude.common")
    if not ok or not common.config then return end

    local edit_ok, edit = pcall(require, "cureMagnitude.edit")
    if not edit_ok then return end

    -- Check if this object has any cure effects that MoaC manages
    local hasCureEffect = false
    for _, effect in ipairs(object.effects) do
        if common.cureEffects[effect.id] then
            hasCureEffect = true
            break
        end
    end
    if not hasCureEffect then return end

    -- Re-apply MoaC's magnitude assignment to this newly created copy
    local interop_ok, interop = pcall(require, "cureMagnitude.interop")

    for i, effect in ipairs(object.effects) do
        if common.cureEffects[effect.id] then
            local magnitude

            -- Check if this specific object ID has a unique magnitude override
            if interop_ok and interop.uniqueMagnitude[effect.id]
               and interop.uniqueMagnitude[effect.id][object.id] then
                magnitude = interop.uniqueMagnitude[effect.id][object.id]
            else
                -- Fall back to the configured default for this effect + object type
                local effectIdStr   = tostring(effect.id)
                local objTypeStr    = tostring(object.objectType)
                local defaults      = common.config.defaultMagnitude
                if defaults and defaults[effectIdStr] and defaults[effectIdStr][objTypeStr] then
                    magnitude = defaults[effectIdStr][objTypeStr]
                end
            end

            if magnitude then
                object.effects[i].min = magnitude
                object.effects[i].max = magnitude
            end
        end
    end
end

-- DRIP fires "objectCreated" when it makes a copy via createCopy{}.
-- e.object is the new copy; e.copiedFrom is the original base object.
event.register("objectCreated", function(e)
    if not e.object then return end
    -- Only act when this was triggered by a copy operation (DRIP's pattern)
    if not e.copiedFrom then return end
    patchCureEffects(e.object)
end)

-- Also cover the mobileActivated path: after DRIP dripifies an NPC's
-- inventory, re-scan it for any cure-effect items that slipped through.
event.register("mobileActivated", function(e)
    if e.reference.baseObject.objectType ~= tes3.objectType.npc then return end
    -- Delay one frame so DRIP has finished modifying the inventory first
    timer.delayOneFrame(function()
        if not e.reference or not e.reference.object then return end
        local inventory = e.reference.object.inventory
        if not inventory then return end
        for _, stack in pairs(inventory) do
            patchCureEffects(stack.object)
        end
    end)
end, { priority = -100 }) -- low priority = runs after DRIP
