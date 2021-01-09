--[[
-- Green Hideout
-- by inpv, 2020
]]

local function onActivateCrank(e)
    local cell = tes3.getPlayerCell()

    if (e.activator == tes3.player) then
        if (cell.isInterior) then
            if string.find(cell.name, "Green Hideout") then
                if string.find(e.target.object.id, "gh_in_dwrv_crank") then
                    event.trigger("Ashfall:WaterMenu", {
                        dirty = false,
                        rain = false
                        })
                end
            end
        end
    end
end

event.register("activate", onActivateCrank)
