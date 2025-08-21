-- BIOS avec rafraîchissement écran avant exécution

local monitors_config = dofile("/bios/monitors_config.lua")
local monitors = monitors_config.detectMonitors()

-- Splash screen
monitors_config.refreshScreen(monitors)
monitors_config.writeAll(monitors, 1, "===================================")
monitors_config.writeAll(monitors, 2, "      Windows 11 Alpha - BIOS")
monitors_config.writeAll(monitors, 3, "         Initialisation")
monitors_config.writeAll(monitors, 4, "===================================")
sleep(1)

-- Détection périphériques
monitors_config.refreshScreen(monitors)
monitors_config.writeAll(monitors, 1, "Détection périphériques...")
for i, side in ipairs({"top","bottom","left","right","front","back"}) do
    if peripheral.isPresent(side) then
        monitors_config.writeAll(monitors, 1 + i, " - "..peripheral.getType(side).." détecté sur "..side)
    end
end
sleep(1)

-- Menu démarrage
local choice = monitors_config.menu(monitors, {"Lancer le shell", "Redémarrer", "Éteindre"})

-- Rafraîchissement avant exécution pour éviter superposition
monitors_config.refreshScreen(monitors)

-- Exécution
if choice == 1 then
    monitors_config.writeAll(monitors, 1, "Lancement du shell...")
    sleep(0.5)
    shell.run("/rom/programs/shell.lua")
elseif choice == 2 then
    monitors_config.writeAll(monitors, 1, "Redémarrage...")
    sleep(0.5)
    os.reboot()
elseif choice == 3 then
    monitors_config.writeAll(monitors, 1, "Extinction...")
    sleep(0.5)
    os.shutdown()
end
