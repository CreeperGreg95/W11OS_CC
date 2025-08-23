-- BIOS complet pour CraftOS 1.8 avec monitors, menu interactif et config persistante

local monitors_config = dofile("/bios/monitors_config.lua")
local monitors = monitors_config.detectMonitors()

-- Charger config_boot.lua
local config = {}
local fn, err = loadfile("/bios/config_boot.lua", "t", config)
if fn then fn() else error("Impossible de charger config_boot.lua: "..err) end

-- ========================
-- SPLASH SCREEN
-- ========================
monitors_config.refreshScreen(monitors)
monitors_config.writeAll(monitors, 1, "===================================")
monitors_config.writeAll(monitors, 2, "      Windows 11 Alpha - BIOS")
monitors_config.writeAll(monitors, 3, "         Initialisation")
monitors_config.writeAll(monitors, 4, "===================================")
sleep(1)

-- ========================
-- DETECTION PERIPHERIQUES
-- ========================
monitors_config.refreshScreen(monitors)
monitors_config.writeAll(monitors, 1, "Détection des périphériques...")
monitors_config.writeAll(monitors, 2, "Veuillez patienter...")

-- Attente selon config
sleep(config.TIME_PERIPH_FINDINGS or 5)

-- Liste des périphériques
monitors_config.refreshScreen(monitors)
monitors_config.writeAll(monitors, 1, "Périphériques détectés :")
local line = 2
for _, side in ipairs({"top","bottom","left","right","front","back"}) do
    if peripheral.isPresent(side) then
        monitors_config.writeAll(monitors, line, " - "..peripheral.getType(side).." sur "..side)
        line = line + 1
    end
end
sleep(2)

-- ========================
-- MENU DEMARRAGE (délégué à menu.lua)
-- ========================
local menu = dofile("/bios/menu.lua")
menu.run(monitors)
