-- menu.lua
-- Gère l'affichage et l'exécution du menu de démarrage
-- Installer Version - Pastebin : 2.2.1

local monitors_config = dofile("/bios/monitors_config.lua")

local menu = {}

function menu.run(monitors)
    -- Menu de démarrage
    local choice = monitors_config.menu(monitors, {"Lancer le shell", "Redémarrer", "Éteindre"})

    -- Exécution des choix
    monitors_config.refreshScreen(monitors)

    if choice == 1 then
        monitors_config.writeAll(monitors, 1, "Lancement du shell...")
        sleep(0.5)
        shell.run("/rom/programs/shell.lua")

    elseif choice == 2 then
        monitors_config.writeAll(monitors, 1, "Redémarrage...")
        sleep(0.5)
        os.reboot()

    elseif choice == 3 then
        local messages = {
            "Cet ordinateur est maintenant éteint.",
            "This computer is now safely turned off"
        }
        local msg = messages[math.random(#messages)]
        monitors_config.writeAll(monitors, 1, msg)
        sleep(2)
        monitors_config.refreshScreen(monitors)
        os.shutdown()
    end
end

return menu
