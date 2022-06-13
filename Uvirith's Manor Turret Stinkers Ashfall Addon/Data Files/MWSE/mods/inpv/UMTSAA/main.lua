local ashfall = include("mer.ashfall.interop")

if ashfall then

    ashfall.registerActivatorType({
        id = "bathcrystal",
        name = "Strange Looking Crystal",
        type = "bathcrystal",
        ids = {
            "in_t_crystal_02"
        },
    })
end

local soundsList = {
    "Fx\\envrn\\splash_lrg.wav",
    "Fx\\envrn\\splash_lrg2.wav",
    "Fx\\envrn\\splash_sml.wav",
    "St\\water_splash_00.wav",
    "abot\\water\\splash5.wav"
}

local function checkCrystal()
    local cell = tes3.getPlayerCell()
    local bathSound = soundsList[math.random(1, #soundsList)]
    local S3_bathed = tes3.findGlobal("S3_bathed")
    local S3_stink = tes3.findGlobal("S3_stink")

    if (cell.isInterior) then
        if string.find(cell.name, "Manor Turret") then

            if tes3.getItemCount({ reference = tes3.player, item = "S3_soap" }) == 0 then
                tes3.messageBox("You need soap to wash.")
            else
                tes3.playSound{ soundPath = bathSound }

                mwscript.removeSpell({ reference = tes3.player, spell = "S3_odor_01" })
                mwscript.removeSpell({ reference = tes3.player, spell = "S3_odor_02" })
                mwscript.removeSpell({ reference = tes3.player, spell = "S3_odor_03" })
                mwscript.removeSpell({ reference = tes3.player, spell = "S3_odor_04" })
                mwscript.removeSpell({ reference = tes3.player, spell = "S3_odor_05" })
                mwscript.removeSpell({ reference = tes3.player, spell = "S3_odor_06" })
                mwscript.removeSpell({ reference = tes3.player, spell = "S3_odor_07" })

                S3_bathed.value = 1
                S3_stink.value = 0

                mwscript.addSpell({ reference = tes3.player, spell = "S3_bath_telvanni" })
                tes3.messageBox("The hot water surrounds you. You wash away the dirt and feel cleaner.")
            end
        end
    end
end

event.register(
    "Ashfall:ActivatorActivated",
    function()
      checkCrystal()
    end,
    { filter = 'bathcrystal' }
)
