-- BIOS complet pour CraftOS 1.8 avec support monitors

-- Fonction pour écrire sur tous les écrans disponibles
local function writeAll(monitors, y, text)
    term.setCursorPos(1, y)
    print(text)
    for _, m in pairs(monitors) do
        m.setCursorPos(1, y)
        m.write(text)
    end
end

-- Détection des périphériques
local monitors = {}
if peripheral then
    for _, side in ipairs({"top","bottom","left","right","front","back"}) do
        if peripheral.isPresent(side) then
            local t = peripheral.getType(side)
            if t == "monitor" then
                local mon = peripheral.wrap(side)
                mon.clear()
                mon.setCursorPos(1,1)
                table.insert(monitors, mon)
            end
        end
    end
end

-- Nettoyage de l'écran local
term.clear()
term.setCursorPos(1,1)

-- Affichage splash screen
writeAll(monitors, 1, "===================================")
writeAll(monitors, 2, "      Windows 11 Alpha - BIOS")
writeAll(monitors, 3, "         Initialisation")
writeAll(monitors, 4, "===================================")
sleep(1)

-- Affichage périphériques détectés
writeAll(monitors, 6, "Détection périphériques...")
for _, side in ipairs({"top","bottom","left","right","front","back"}) do
    if peripheral.isPresent(side) then
        local t = peripheral.getType(side)
        writeAll(monitors, 6 + _, " - "..t.." détecté sur "..side)
    end
end
sleep(1)

-- Menu simple
local function menu(options)
    local choice = 1
    while true do
        term.clear()
        term.setCursorPos(1,1)
        for _, m in pairs(monitors) do m.clear() end
        for i, opt in ipairs(options) do
            local line = (i == choice) and ("> "..opt) or ("  "..opt)
            term.setCursorPos(1, i)
            print(line)
            for _, m in pairs(monitors) do
                m.setCursorPos(1, i)
                m.write(line)
            end
        end
        local event, key = os.pullEvent("key")
        if key == keys.up then
            choice = choice - 1
            if choice < 1 then choice = #options end
        elseif key == keys.down then
            choice = choice + 1
            if choice > #options then choice = 1 end
        elseif key == keys.enter then
            return choice
        end
    end
end

-- Menu de démarrage
local choice = menu({"Lancer le shell", "Redémarrer", "Éteindre"})

-- Exécution
if choice == 1 then
    writeAll(monitors, 1, "Lancement du shell...")
    sleep(0.5)
    shell.run("/rom/programs/shell.lua")
elseif choice == 2 then
    writeAll(monitors, 1, "Redémarrage...")
    sleep(0.5)
    os.reboot()
elseif choice == 3 then
    writeAll(monitors, 1, "Extinction...")
    sleep(0.5)
    os.shutdown()
end
