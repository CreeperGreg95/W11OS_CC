-- BIOS complet pour CraftOS 1.8 avec support monitors (clic + Enter)

-- Charger la config monitors
local monitors_config = dofile("/bios/monitors_config.lua")

-- Détecter les monitors
local monitors = monitors_config.detectMonitors()

-- Nettoyage de l'écran local
term.clear()
term.setCursorPos(1,1)

-- Affichage splash screen
monitors_config.writeAll(monitors, 1, "===================================")
monitors_config.writeAll(monitors, 2, "      Windows 11 Alpha - BIOS")
monitors_config.writeAll(monitors, 3, "         Initialisation")
monitors_config.writeAll(monitors, 4, "===================================")
sleep(1)

-- Affichage périphériques détectés
monitors_config.writeAll(monitors, 6, "Détection périphériques...")
for _, side in ipairs({"top","bottom","left","right","front","back"}) do
    if peripheral.isPresent(side) then
        local t = peripheral.getType(side)
        monitors_config.writeAll(monitors, 6 + _, " - "..t.." détecté sur "..side)
    end
end
sleep(1)

-- Menu de démarrage
local choice = monitors_config.menu(monitors, {"Lancer le shell", "Redémarrer", "Éteindre"})

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
